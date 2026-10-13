-- Legacy wire names and authorization policy, not another implementation.
return function(lib, native, context)
    if context=='server' then
        RegisterNetEvent('ox_lib:progressProps',function(props)
            native.progressProps.publish(source,props,'lib:progressProps')
        end)
        local policy=PRCore.load('bridge.fivem.state.policy')(native)
        lib.callback.register('ox_lib:requestSetStateBag',policy.request)
        return
    end
    AddStateBagChangeHandler('lib:progressProps',nil,native.progressProps.render)
    RegisterNetEvent('ox_lib:setStateBagValue',function(key,value)
        if source~='' then LocalPlayer.state[key]=value end
    end)
    local properties=native.fivem.vehicleProperties
    local function clear(entity,key) return lib.vehicle:new(entity):setr(key,nil) end
    AddStateBagChangeHandler('ox_lib:setVehicleProperties','',function(bag,key,value)
        properties.applyQueue(bag,key,value,clear,lib.setVehicleProperties)
    end)
    RegisterNetEvent('ox_lib:setVehicleProperties',function(netId,props)
        local vehicle=native.fivem.net.getVehicle(netId,1000)
        if vehicle and vehicle~=0 then lib.setVehicleProperties(vehicle,props) end
    end)
    AddStateBagChangeHandler('ox_entity_setonground','',native.stateGroundHandler)
end
