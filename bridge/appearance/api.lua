local contracts = PRCore.load("@pr_bridge/bridge/appearance/contracts")
local resource = "forge-appearance"
local available
local subscribed = false
local api = {}

function api.getProvider()
    if not subscribed then
        local side = PRCore.context == "server" and "Server" or "Client"
        AddEventHandler("on" .. side .. "ResourceStart", function(name)
            if name == resource then available = true end
        end)
        AddEventHandler("on" .. side .. "ResourceStop", function(name)
            if name == resource then available = false end
        end)
        subscribed = true
    end
    if available == nil then
        local state = GetResourceState(resource)
        if state == "starting" then return nil end
        available = state == "started"
    end
    if available then return resource end
end

for _, name in ipairs(contracts[PRCore.context]) do
    api[name] = function(...)
        if not api.getProvider() then return nil, "appearance_provider_unavailable" end
        local provider = exports[resource]
        return provider[name](provider, ...)
    end
end

return api
