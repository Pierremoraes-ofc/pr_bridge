-- Shared native authorization pipelines, also used by the legacy wire adapter.
return function(native)
    if native.statePolicy then return native.statePolicy end
    local library=native.library or PRCore.load('@pr_bridge/bridge/library/init')(native,_ENV)
    local function filter(hook,payload) return not hook.key or payload.key==hook.key end
    local pipelines={player=library.hook:new('setPlayerState',filter),entity=library.hook:new('setEntityState',filter)}
    local api={pipelines=pipelines}
    function api.request(playerId,bag,key,value,mode)
        return native.fivem.state.requestSet(playerId,bag,key,value,mode,function(payload)
            local dispatch <close> = pipelines[payload.type]:dispatch(payload)
            return dispatch.ok and dispatch.size>0
        end)
    end
    pipelines.entity:registerHook(function(payload)
        if payload.value then return false end
        local props=Entity(payload.entityId).state[payload.key]
        local plate=GetVehicleNumberPlateText(payload.entityId)
        return props and plate~='' and (not props.plate or native.utils.trim(props.plate)==native.utils.trim(plate)) or false
    end,{key='ox_lib:setVehicleProperties'})
    for _,key in ipairs({'pr_bridge:entity:setOnGround','ox_entity_setonground'}) do
        pipelines.entity:registerHook(function(payload) return payload.value==true or not payload.value end,{key=key})
    end
    native.statePolicy=api
    PRCore.load('@pr_bridge/bridge/callback/server').register('pr_bridge:requestSetStateBag',api.request)
    return api
end
