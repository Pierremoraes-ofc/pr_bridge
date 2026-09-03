local environment = {}

local ENVIRONMENT_CONVAR = "pr_bridge:environment"
local CALLBACK_SECURE_CONVAR = "pr_bridge:callback:secure"
local DEVELOPER_ACE = "pr_bridge.developer"
local ADMIN_ACE = "forge-core.admin"

local aliases = {
    prod = "production",
    production = "production",
    dev = "development",
    development = "development",
    test = "test",
    testing = "test",
}

local function trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function normalizeBoolean(value, defaultValue)
    if type(value) == "boolean" then return value end

    local normalized = trim(value):lower()
    if normalized == "true" or normalized == "1" or normalized == "yes" or normalized == "on" then return true end
    if normalized == "false" or normalized == "0" or normalized == "no" or normalized == "off" then return false end

    return defaultValue == true
end

local mode = aliases[trim(GetConvar(ENVIRONMENT_CONVAR, "production")):lower()] or "production"
local secureCallback = normalizeBoolean(GetConvar(CALLBACK_SECURE_CONVAR, "false"), false)

function environment.getMode() return mode end
function environment.isProduction() return mode == "production" end
function environment.isDevelopment() return mode == "development" end
function environment.isTest() return mode == "test" end
function environment.normalizeBoolean(value, defaultValue) return normalizeBoolean(value, defaultValue) end
function environment.getCallbackMode() return secureCallback and "secure" or "legacy" end
function environment.isSecureCallbackEnabled() return secureCallback end
function environment.getDeveloperAce() return DEVELOPER_ACE end
function environment.getAdminAce() return ADMIN_ACE end

local function isAceAllowedResult(value)
    return value == true or value == 1
end

local function playerAceAllowed(source, aceName)
    local principal = ('player.%s'):format(tostring(tonumber(source) or source or ''))
    if principal ~= 'player.' then
        local ok, allowed = pcall(IsPrincipalAceAllowed, principal, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    local numericSource = tonumber(source)
    if numericSource then
        local ok, allowed = pcall(IsPlayerAceAllowed, numericSource, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    local textSource = tostring(source or '')
    if textSource ~= '' then
        local ok, allowed = pcall(IsPlayerAceAllowed, textSource, aceName)
        if ok and isAceAllowedResult(allowed) then return true end
    end

    return false
end

function environment.hasDeveloperAccess(playerSource)
    if not IsDuplicityVersion() then return false end

    local sourceId = tonumber(playerSource)
    if sourceId == 0 then return true end
    if not sourceId or sourceId < 1 or type(IsPlayerAceAllowed) ~= "function" then return false end

    return playerAceAllowed(sourceId, DEVELOPER_ACE)
        or playerAceAllowed(sourceId, ADMIN_ACE)
end

function environment.canUseDeveloperTools(playerSource)
    if environment.isProduction() or not IsDuplicityVersion() then return false end
    return environment.hasDeveloperAccess(playerSource)
end

function environment.getCallbackLimits()
    return {
        timeout = math.max(1000, GetConvarInt("pr_bridge:callback:timeout", 10000)),
        maxPending = math.max(16, GetConvarInt("pr_bridge:callback:maxPending", 1024)),
        maxPendingPerPlayer = math.max(4, GetConvarInt("pr_bridge:callback:maxPendingPerPlayer", 64)),
        maxInboundPerPlayer = math.max(4, GetConvarInt("pr_bridge:callback:maxInboundPerPlayer", 32)),
    }
end

return environment
