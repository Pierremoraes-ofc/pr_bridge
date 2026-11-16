local contracts = PRCore.load('@pr_bridge/bridge/housing/contracts')
local active = {}
local subscriptionsInstalled = false

local function invalidate(resource)
    if contracts[resource] then active[resource] = nil end
end

local function isAvailable(resource)
    if not subscriptionsInstalled then
        local side = PRCore.context == 'server' and 'Server' or 'Client'
        AddEventHandler('on' .. side .. 'ResourceStart', invalidate)
        AddEventHandler('onResourceStop', function(stopped)
            if contracts[stopped] then active[stopped] = false end
        end)
        subscriptionsInstalled = true
    end
    if active[resource] == nil then
        local state = GetResourceState(resource)
        if state == 'starting' then return false end
        active[resource] = state == 'started'
    end
    return active[resource]
end

local function providerApi(resource)
    local api = {}
    function api.getProvider()
        if isAvailable(resource) then return resource end
    end

    for _, name in ipairs(contracts[resource][PRCore.context]) do
        api[name] = function(...)
            if not isAvailable(resource) then return nil, 'housing_provider_unavailable' end
            local provider = exports[resource]
            return provider[name](provider, ...)
        end
    end
    return api
end

local housing = providerApi('forge-housing')
housing.realtor = providerApi('forge-realtor')

if PRCore.context == 'client' then
    function housing.enterProperty(propertyId, ...)
        if not isAvailable('forge-housing') then return false, 'housing_provider_unavailable' end
        TriggerServerEvent('forge-housing:server:enterProperty', propertyId, ...)
        return true
    end
end

return housing
