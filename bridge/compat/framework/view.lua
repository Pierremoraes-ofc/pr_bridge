-- A source-contract view owns adaptations; the native framework table is never changed.
return function(bridge,context,backend,qb)
    backend=backend or'default'
    local native=assert(bridge.framework,'native PR framework required')
    local view=setmetatable({},{__index=native})
    local create=PRCore.load('@pr_bridge/bridge/compat/framework/install',_ENV)
    local target=PRCore.load(('@pr_bridge/bridge/compat/esx/targets/%s'):format(backend),_ENV)
    create(view,context,bridge.inventory,backend,target(view,context))
    if qb and not view.QBCore then
        PRCore.load('@pr_bridge/bridge/compat/qb/adapter',_ENV)(view,context,bridge.inventory,backend)
    end
    local result={}
    for name,value in pairs(bridge)do result[name]=value end
    result.framework=view
    return result
end
