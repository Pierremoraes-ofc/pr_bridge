-- The callback reference belongs to the Forge provider, keeping the original
-- caller visible to GetInvokingResource even through the old export name.
local resource = GetCurrentResourceName()
local legacy = ({
    ['forge-housing'] = 'ps-housing',
    ['forge-realtor'] = 'ps-realtor',
})[resource]
if not legacy then return end
local side = IsDuplicityVersion() and 'Server' or 'Client'
local path = 'bridge/housing/contracts.lua'
local contracts = assert(load(assert(LoadResourceFile('pr_bridge', path)), '@pr_bridge/' .. path, 't'))()
local allowed = {}
for _, name in ipairs(contracts[resource][side:lower()]) do allowed[name] = true end
local available = GetResourceState(legacy) == 'started'
AddEventHandler('on' .. side .. 'ResourceStart', function(name)
    if name == legacy then available = true end
end)
AddEventHandler('onResourceStop', function(name)
    if name == legacy then available = false end
end)
local registerExport = exports

exports = setmetatable({}, {
    __index = registerExport,
    __call = function(_, name, handler)
        registerExport(name, handler)
        if not allowed[name] then return end
        local function legacyHandler(...)
            if not available then return nil, 'housing_provider_unavailable' end
            return handler(...)
        end
        AddEventHandler(('__cfx_export_%s_%s'):format(legacy, name), function(setExport)
            if not available and GetResourceState(legacy) == 'started' then available = true end
            if available then setExport(legacyHandler) end
        end)
    end,
})
