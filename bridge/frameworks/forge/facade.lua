-- Stable native PR API. Loading it never requests a core object or waits for Forge.
local methods=PRCore.load('@pr_bridge/bridge/frameworks/forge/consumer_schema',_ENV)[PRCore.context].normalized
local facade,aliases={},{}
for name,canonical in pairs(methods)do
    if canonical=='GetResourceName'then
        aliases[canonical]=aliases[canonical]or function()return'forge-core'end
    else
        aliases[canonical]=aliases[canonical]or function(...)
            local service=assert(PRCore.forgeConsumerService,'Forge integration service unavailable')
            service.Ensure()
            local target=assert(PRCore.forgeNormalizedFacade,'Forge native adapter unavailable')
            return assert(target[canonical],'Forge native operation unavailable: '..canonical)(...)
        end
    end
    facade[name]=aliases[canonical]
end
return facade
