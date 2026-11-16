-- Register legacy names in the provider runtime to retain the original event
-- source. A legacy resource can start after the provider, including on clients.

local function legacyName(event)
    if type(event) ~= 'string' then return end
    local name = event:match('^forge%-housing:(.+)$')
    if name then return 'ps-housing:' .. name end
    name = event:match('^forge%-realtor:(.+)$')
    if not name then return end
    if name:match('^server:') or name == 'client:toggleUI' or name == 'client:furnitureCatalogUpdated' then
        return 'bl-realtor:' .. name
    end
    return 'ps-realtor:' .. name
end

local listen, registerNet = AddEventHandler, RegisterNetEvent
local server = IsDuplicityVersion()
local resource = GetCurrentResourceName()

-- Only notifications consumed by outside scripts are published to the legacy
-- name. Relay them on the receiving side, avoiding a second network payload.
local notifications = server and {
    'forge-housing:security:ownerAlert',
} or {
    'forge-housing:client:addProperty',
    'forge-housing:client:hygieneUpdated',
    'forge-housing:client:initialisedProperties',
    'forge-housing:client:removeProperty',
    'forge-housing:client:updateApartment',
    'forge-housing:client:updateProperty',
    'forge-housing:client:updatedProperty',
    'forge-housing:securityOwnerAlert',
    'forge-housing:setApartments',
}

local outbound = {}
for _, event in ipairs(notifications) do
    outbound[event] = true
    if resource == 'forge-housing' then
        local legacy = legacyName(event)
        if legacy then listen(event, function(...) TriggerEvent(legacy, ...) end) end
    end
end

function AddEventHandler(event, handler)
    local handle = listen(event, handler)
    local legacy = legacyName(event)
    if legacy and not outbound[event] then listen(legacy, handler) end
    return handle
end

function RegisterNetEvent(event, handler)
    local handle = registerNet(event)
    if handler then handle = listen(event, handler) end
    local legacy = legacyName(event)
    if legacy and not outbound[event] then
        registerNet(legacy)
        if handler then listen(legacy, handler) end
    end
    return handle
end

if server then RegisterServerEvent = RegisterNetEvent end
