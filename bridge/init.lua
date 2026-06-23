ActiveBridges = {}
Lang = Locale.init()

if IsDuplicityVersion() then
    local bridgeLocale = GetConvar("pr_bridge:locale", "en-us")

    if type(bridgeLocale) == "string" and bridgeLocale ~= "" then
        if GlobalState then
            GlobalState.pr_bridge_locale = bridgeLocale
        end

        if SetConvarReplicated then
            SetConvarReplicated("pr_bridge:locale", bridgeLocale)
        end
    end
end

Lang = Locale.init()

if IsDuplicityVersion() then
    local bridgeLocale = GetConvar("pr_bridge:locale", "en-us")

    if type(bridgeLocale) == "string" and bridgeLocale ~= "" then
        if GlobalState then
            GlobalState.pr_bridge_locale = bridgeLocale
        end

        if SetConvarReplicated then
            SetConvarReplicated("pr_bridge:locale", bridgeLocale)
        end
    end
end

Lang = Locale.init()

local ActiveBridgeAliases = {
    inventories = "inventory",
    notifications = "notification",
    targets = "target",
    phones = "phone",
}

local function setActiveBridge(bridgeType, folder)
    ActiveBridges[bridgeType] = folder

    local alias = ActiveBridgeAliases[bridgeType]
    if alias then
        ActiveBridges[alias] = folder
    end
end

--- Gets the bridge functions
---@param bridgeType string Bridge type from config.lua
---@return string
local function getBridge(bridgeType)
    local context = PRCore.context
    local bridge = ConfigBridge[bridgeType]
    local fallback = ("bridge.%s.%s.%s"):format(bridgeType, "default", context)

    if not bridge then
        setActiveBridge(bridgeType, "default")
        return fallback
    end

    if bridgeType == "database" then
        local forced = Config.Database or Config.SQL
        if type(forced) == "string" and forced ~= "" and forced ~= "auto" then
            for i = 1, #bridge do
                local info = bridge[i]
                if info.resource == forced or info.folder == forced then
                    if GetResourceState(info.resource):find("start") then
                        setActiveBridge(bridgeType, info.folder)
                        return ("bridge.%s.%s.%s"):format(bridgeType, info.folder, context)
                    end

                    if Debug then
                        Debug("WARNING", ("Database bridge '%s' forced but resource is not started."):format(forced))
                    end

                    break
                end
            end
        end
    end

    for i = 1, #bridge do
        local info = bridge[i]
        if GetResourceState(info.resource):find("start") then
            setActiveBridge(bridgeType, info.folder)
            return ("bridge.%s.%s.%s"):format(bridgeType, info.folder, context)
        end
    end

    setActiveBridge(bridgeType, "default")
    return fallback
end


Bridge = {
    framework = PRCore.load(getBridge("frameworks")),
    inventory = PRCore.load(getBridge("inventories")),
    notify = PRCore.load(getBridge("notifications")),
    menus = PRCore.load(getBridge("menus")),
    target = PRCore.load(getBridge("targets")),
    phone = PRCore.load(getBridge("phones")),
    progress = PRCore.load(getBridge("progressbar")),
    weather = PRCore.load(getBridge("weather")),
    fuel = PRCore.load(getBridge("fuel")),
    vehicle_key = PRCore.load(getBridge("vehicle_key"))
}

Bridge.name = "pr_bridge"
Bridge.context = PRCore.context
Bridge.activeBridges = ActiveBridges
Bridge.config = Config
Bridge.locale = Locale.init
Bridge.load = PRCore.load
Bridge.loadFile = PRCore.loadFile
Bridge.loadJson = PRCore.loadJson
Bridge.loadModule = PRCore.loadModule
Bridge.callback = PRCore.callback
Bridge.debug = PRDebug
Bridge.utils = PRCore.load("bridge.utils.shared") or {}
Bridge.callback = PRCore.load(("bridge.callback.%s"):format(PRCore.context)) or PRCore.callback
Bridge.translator = PRCore.load(("bridge.translator.%s"):format(PRCore.context), env, true) or {}

Bridge.inventories = Bridge.inventory
Bridge.notifications = Bridge.notify
Bridge.notification = Bridge.notify
Bridge.menu = Bridge.menus
Bridge.targets = Bridge.target
Bridge.phones = Bridge.phone
Bridge.progressbar = Bridge.progress
Bridge.vehicleKey = Bridge.vehicle_key
Bridge.vehicleKeys = Bridge.vehicle_key
Bridge.fivem = PRCore.load(("bridge.fivem.%s"):format(PRCore.context)) or {}
Bridge.vehicleProperties = Bridge.fivem.vehicleProperties
local normalizeInventoryBridge = PRCore.load("bridge.inventory_normalizer")

if PRCore.context == "server" then
    Bridge.database = PRCore.load(getBridge("database")) or {}
else
    Bridge.database = PRCore.load("bridge.database.default.client") or {}
end

if PRCore.context == "server" then
    Bridge.inventory = Bridge.inventory or {}
end
if normalizeInventoryBridge then normalizeInventoryBridge(Bridge.inventory, PRCore.context) end

Bridge.db = Bridge.database
Bridge.sql = Bridge.database
Bridge.drawtext = Bridge.fivem.drawtext
Bridge.drawText = Bridge.fivem.drawText
Bridge.textui = Bridge.fivem.textui
Bridge.textUI = Bridge.fivem.textUI
Bridge.dui = Bridge.fivem.dui
Bridge.duis = Bridge.fivem.duis
Bridge.editorCamera = Bridge.fivem.editorCamera
Bridge.gizmo = Bridge.fivem.gizmo
Bridge.devlaser = Bridge.fivem.devlaser
Bridge.devLaser = Bridge.fivem.devLaser
Bridge.devtools = Bridge.fivem.devtools
Bridge.devTools = Bridge.fivem.devTools
Bridge.developerTools = Bridge.fivem.developerTools

local cacheStore = {}
local cacheEvents = {}

local bridgeCache = {
    resource = GetCurrentResourceName(),
    context = PRCore.context,
    activeBridges = ActiveBridges,
}

local function dispatchCacheEvent(key, value, oldValue)
    local events = cacheEvents[key]
    if not events then return end

    for i = 1, #events do
        CreateThread(function()
            events[i](value, oldValue)
        end)
    end
end

function bridgeCache.set(key, value)
    local oldValue = cacheStore[key]
    cacheStore[key] = value
    dispatchCacheEvent(key, value, oldValue)
    return value
end

function bridgeCache.get(key, fallback)
    local value = cacheStore[key]
    if value == nil then return fallback end
    return value
end

function bridgeCache.clear(key)
    if key == nil then
        for cacheKey in pairs(cacheStore) do
            bridgeCache.clear(cacheKey)
        end

        return
    end

    local oldValue = cacheStore[key]
    cacheStore[key] = nil
    dispatchCacheEvent(key, nil, oldValue)
end

function bridgeCache.clearPrefix(prefix)
    for key in pairs(cacheStore) do
        if key:sub(1, #prefix) == prefix then
            bridgeCache.clear(key)
        end
    end
end

function bridgeCache.remember(key, callback, timeout)
    local value = cacheStore[key]
    if value ~= nil then return value end

    value = callback()
    bridgeCache.set(key, value)

    if timeout then
        SetTimeout(timeout, function()
            if cacheStore[key] == value then
                bridgeCache.clear(key)
            end
        end)
    end

    return value
end

bridgeCache.call = bridgeCache.remember

function bridgeCache.onChange(key, callback)
    cacheEvents[key] = cacheEvents[key] or {}
    cacheEvents[key][#cacheEvents[key] + 1] = callback
end

function bridgeCache.GetPlayer(source, timeout)
    if PRCore.context == "server" then
        if type(source) ~= "number" then return nil end

        return bridgeCache.remember(("player:%s"):format(source), function()
            return Bridge.framework.GetPlayer and Bridge.framework.GetPlayer(source)
        end, timeout or 1000)
    end

    return bridgeCache.remember("player:self", function()
        return Bridge.framework.GetPlayer and Bridge.framework.GetPlayer()
    end, source or 1000)
end

function bridgeCache.GetMetadata(source, metadata, timeout)
    if PRCore.context == "server" then
        if type(source) ~= "number" or type(metadata) ~= "string" then return nil end

        return bridgeCache.remember(("metadata:%s:%s"):format(source, metadata), function()
            return Bridge.framework.getPlayerMetadata and Bridge.framework.getPlayerMetadata(source, metadata)
        end, timeout or 1000)
    end

    local metadataName = source
    if type(metadataName) ~= "string" then return nil end

    return bridgeCache.remember(("metadata:self:%s"):format(metadataName), function()
        return Bridge.framework.getPlayerMetadata and Bridge.framework.getPlayerMetadata(metadataName)
    end, metadata or 1000)
end

function bridgeCache.InvalidatePlayer(source)
    if PRCore.context == "server" then
        if type(source) ~= "number" then return end

        bridgeCache.clear(("player:%s"):format(source))
        bridgeCache.clearPrefix(("metadata:%s:"):format(source))
        return
    end

    bridgeCache.clear("player:self")
    bridgeCache.clearPrefix("metadata:self:")
end

setmetatable(bridgeCache, {
    __call = function(_, key, callback, timeout)
        return bridgeCache.remember(key, callback, timeout)
    end,
})

Bridge.cache = bridgeCache
pr_lib = Bridge
if _G then
    _G.pr_lib = Bridge
end

if PRCore.context == "client" and GetConvar("pr_bridge:translator_auto_notify", "true") == "true" then
    if Bridge.notify and Bridge.notify.Notify then
        local originalNotify = Bridge.notify.Notify
        Bridge.notify.Notify = function(data)
            if data and (data.title or data.description) then
                local targetLang = data.lang or data.locale or GetConvar("pr_bridge:locale", "en-us"):lower():sub(1, 2)
                local strings = { data.title or "", data.description or "" }
                local translated = Bridge.translator.translateBatch(strings, targetLang)
                if translated and #translated > 0 then
                    if data.title and data.title ~= "" then
                        data.title = translated[1]
                    end
                    if data.description and data.description ~= "" then
                        data.description = translated[2]
                    end
                end
            end
            originalNotify(data)
        end
    end
end

exports("getLib", function()
    return Bridge
end)
