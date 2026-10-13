return function(native,library)
    RegisterNetEvent('pr_bridge:setStateBagValue',function(key,value)
        if source~='' then LocalPlayer.state[key]=value end
    end)
    local function handler(bag,key,value)
        if not value then return end
        local entity=library.waitFor(function()
            if NetworkIsInTutorialSession() then return end
            local handle=GetEntityFromStateBagName(bag)
            if handle and handle~=0 and not IsEntityWaitingForWorldCollision(handle) then return handle end
        end,'Failed to stream entity for ground placement',10000)
        local kind=IsEntityAVehicle(entity) and 'vehicle' or 'prop'
        if native.fivem.streaming.placeEntityProperly(entity,kind) then library.vehicle:new(entity):setr(key,nil) end
    end
    AddStateBagChangeHandler('pr_bridge:entity:setOnGround','',handler)
    return handler
end
