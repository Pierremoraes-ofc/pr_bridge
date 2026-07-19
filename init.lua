---@meta

if not _VERSION:find("5.4") then
    error("Lua 5.4 must be enabled in the resource manifest!", 2)
end

local resourceName = GetCurrentResourceName()
local bridgeResource = "pr_bridge"

if resourceName == bridgeResource then return end

if pr_lib and pr_lib.name == bridgeResource then
    error(("Cannot load pr_bridge more than once.\n\tRemove duplicate entries from '@%s/fxmanifest.lua'"):format(resourceName), 2)
end

if GetResourceState(bridgeResource) ~= "started" then
    error("^1pr_bridge must be started before this resource.^0", 2)
end

if not PRCore then
    local chunk = LoadResourceFile(bridgeResource, "bridge/core.lua")
    if not chunk then
        error("^1Could not load @pr_bridge/bridge/core.lua.^0", 2)
    end

    local fn, err = load(chunk, "@@pr_bridge/bridge/core.lua", "t", _ENV)
    if not fn then error(err, 2) end

    fn()
end

local public = {
    name = bridgeResource,
    resource = resourceName,
    context = PRCore.context,
}

pr_lib = public
if _G then
    _G.pr_lib = public
end
_ENV.pr_lib = public

public.load = PRCore.load
public.loadFile = PRCore.loadFile
public.loadJson = PRCore.loadJson
public.readJson = PRCore.readJson
public.saveJson = PRCore.saveJson
public.writeJson = PRCore.writeJson
public.updateJson = PRCore.updateJson
public.mergeJson = PRCore.mergeJson
public.deleteJson = PRCore.deleteJson
public.jsonExists = PRCore.jsonExists
public.loadModule = PRCore.loadModule
public.callback = PRCore.callback

local env = setmetatable({
    Bridge = public,
    ActiveBridges = {},
    PRCore = PRCore,
}, {
    __index = _ENV,
})

PRCore.load("@pr_bridge/bridge/locale", env)
public.locale = function(invokingResource)
    if type(invokingResource) ~= "string" or invokingResource == "" then
        invokingResource = resourceName
    end

    return env.Locale.init(invokingResource)
end
PRCore.load("@pr_bridge/bridge/config", env)
public.debug = PRCore.load("@pr_bridge/bridge/debug", env)
env.Lang = env.Locale.init("pr_bridge")
public.utils = PRCore.load("@pr_bridge/bridge/utils/shared", env) or {}
public.math = PRCore.load("@pr_bridge/bridge/utils/numbers", env) or {}
public.table = PRCore.load("@pr_bridge/bridge/utils/tables", env) or {}
public.ids = PRCore.load("@pr_bridge/bridge/utils/ids", env) or {}
public.translator = PRCore.load(("@pr_bridge/bridge/translator/%s"):format(PRCore.context), env, true) or {}

local debugValue = GetResourceMetadata(resourceName, "pr_bridge_debug", 0)
env.Config.Debug = debugValue == "true" or debugValue == "yes" or debugValue == "1"
public.callback = PRCore.load(("@pr_bridge/bridge/callback/%s"):format(PRCore.context), env) or PRCore.callback
local normalizeInventoryBridge = PRCore.load("@pr_bridge/bridge/inventory_normalizer", env)
local normalizeApi = PRCore.load("@pr_bridge/bridge/api_normalizer", env)

local activeAliases = {
    inventories = "inventory",
    notifications = "notification",
    targets = "target",
    phones = "phone",
}

local function setActiveBridge(bridgeType, folder)
    env.ActiveBridges[bridgeType] = folder

    local alias = activeAliases[bridgeType]
    if alias then
        env.ActiveBridges[alias] = folder
    end
end

local function getBridgePath(bridgeType)
    local bridge = env.ConfigBridge[bridgeType]
    local fallback = ("@pr_bridge/bridge/%s/default/%s"):format(bridgeType, PRCore.context)

    if not bridge then
        setActiveBridge(bridgeType, "default")
        return fallback
    end

    if bridgeType == "frameworks" then
        local forced = env.Config.Framework
        if type(forced) == "string" and forced ~= "" and forced ~= "auto" then
            if forced == "custom" then
                setActiveBridge(bridgeType, "custom")
                return ("@pr_bridge/bridge/frameworks/custom/%s"):format(PRCore.context)
            end

            for i = 1, #bridge do
                local info = bridge[i]
                if info.resource == forced or info.folder == forced then
                    if GetResourceState(info.resource):find("start") then
                        setActiveBridge(bridgeType, info.folder)
                        return ("@pr_bridge/bridge/frameworks/%s/%s"):format(info.folder, PRCore.context)
                    end
                    break
                end
            end
        end
    end
    if bridgeType == "database" then
        local forced = env.Config.Database or env.Config.SQL
        if type(forced) == "string" and forced ~= "" and forced ~= "auto" then
            for i = 1, #bridge do
                local info = bridge[i]
                if info.resource == forced or info.folder == forced then
                    if GetResourceState(info.resource):find("start") then
                        setActiveBridge(bridgeType, info.folder)
                        return ("@pr_bridge/bridge/%s/%s/%s"):format(bridgeType, info.folder, PRCore.context)
                    end

                    if env.Debug then
                        env.Debug("WARNING", ("Database bridge '%s' forced but resource is not started."):format(forced))
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
            return ("@pr_bridge/bridge/%s/%s/%s"):format(bridgeType, info.folder, PRCore.context)
        end
    end

    setActiveBridge(bridgeType, "default")
    return fallback
end

local function loadBridgeModule(publicName, bridgeType)
    public[publicName] = PRCore.load(getBridgePath(bridgeType), env) or {}
    return public[publicName]
end

loadBridgeModule("framework", "frameworks")
loadBridgeModule("inventory", "inventories")
if normalizeInventoryBridge then normalizeInventoryBridge(public.inventory, PRCore.context, env.ActiveBridges.inventories) end
loadBridgeModule("notify", "notifications")
loadBridgeModule("menus", "menus")
loadBridgeModule("target", "targets")
loadBridgeModule("textuiAdapter", "textui")
loadBridgeModule("banking", "banking")
if normalizeApi then normalizeApi.target(public.target, env.ActiveBridges.target); normalizeApi.textui(public.textuiAdapter); normalizeApi.banking(public.banking); normalizeApi.notification(public.notify, PRCore.context, env.ActiveBridges.notification) end
loadBridgeModule("phone", "phones")
loadBridgeModule("progress", "progressbar")
if PRCore.context == "client" then
    loadBridgeModule("minigame", "minigames")
else
    public.minigame = {}
end
loadBridgeModule("weather", "weather")
public.fivem = PRCore.load(("@pr_bridge/bridge/fivem/%s"):format(PRCore.context), env) or {}
public.github = PRCore.load(("@pr_bridge/bridge/github/%s"):format(PRCore.context), env) or {}
public.versionCheck = public.github.versionCheck
public.checkDependency = public.github.checkDependency
if PRCore.context == "server" then
    public.triggerClientEvent = PRCore.load("@pr_bridge/bridge/triggerClientEvent/server", env)
    loadBridgeModule("database", "database")
    if normalizeApi then normalizeApi.database(public.database) end

    local createBackupApi = PRCore.load("@pr_bridge/bridge/database/backup/server", env)
    if createBackupApi then
        public.database.backup = createBackupApi(public.database, resourceName)
        public.database.createBackup = public.database.backup.create
        public.sqlBackup = public.database.backup
    end
else
    public.database = PRCore.load("@pr_bridge/bridge/database/default/client", env) or {}
end
loadBridgeModule("fuel", "fuel")
loadBridgeModule("vehicle_key", "vehicle_key")
local normalizeFramework = PRCore.load("@pr_bridge/bridge/framework_normalizer", env)
if normalizeFramework then normalizeFramework(public.framework, PRCore.context, public.inventory, public.banking, public.notify, public.textuiAdapter, env.ActiveBridges.frameworks) end

if PRCore.context == "server" then
    public.inventory = public.inventory or {}
end

PRCore.load("@pr_bridge/bridge/notifications/cl_events", env)

public.activeBridges = env.ActiveBridges
public.config = env.Config

public.inventories = public.inventory
public.notifications = public.notify
public.notification = public.notify
public.menu = public.menus
public.targets = public.target
public.phones = public.phone
public.progressbar = public.progress
public.textUIAdapter = public.textuiAdapter
public.textuiBridge = public.textuiAdapter
public.textUIBridge = public.textuiAdapter
public.bank = public.banking
public.adapters = { framework=public.framework, inventory=public.inventory, notification=public.notify, menu=public.menus, target=public.target, textui=public.textuiAdapter, banking=public.banking, phone=public.phone, progress=public.progress, weather=public.weather }
public.vehicleKey = public.vehicle_key
public.vehicleKeys = public.vehicle_key
public.db = public.database
public.sql = public.database
public.vehicleProperties = public.fivem.vehicleProperties
public.addKeybind = public.fivem.addKeybind
public.keybind = public.fivem.keybind
public.keybinds = public.fivem.keybinds
public.addCommand = public.fivem.addCommand
public.command = public.fivem.command
public.commands = public.fivem.commands
public.ace = public.fivem.ace
public.permissions = public.fivem.permissions
public.identifiers = public.fivem.identifiers
public.identifier = public.fivem.identifier
public.drawtext = public.fivem.drawtext
public.drawText = public.fivem.drawText
public.textui = public.fivem.textui
public.textUI = public.fivem.textUI
public.dui = public.fivem.dui
public.duis = public.fivem.duis
public.raycast = public.fivem.raycast
public.ui = public.fivem.ui
public.editorCamera = public.fivem.editorCamera
public.gizmo = public.fivem.gizmo
public.devlaser = public.fivem.devlaser
public.devLaser = public.fivem.devLaser
public.devtools = public.fivem.devtools
public.devTools = public.fivem.devTools
public.developerTools = public.fivem.developerTools


if PRCore.context == "client" then
    local UI = PRCore.load("@pr_bridge/interface/client/ui", env, true) or {
        RegisterContext = public.menus and public.menus.RegisterContext,
        ShowContext = public.menus and public.menus.ShowContext,
        HideContext = public.menus and public.menus.HideContext,
        GetOpenContextMenu = public.menus and public.menus.GetOpenContextMenu,
        AlertDialog = public.menus and public.menus.AlertDialog,
        InputDialog = public.menus and public.menus.InputDialog,
        Notify = public.notify and public.notify.Notify,
        ShowTextUI = public.textuiAdapter and public.textuiAdapter.Show,
        HideTextUI = public.textuiAdapter and public.textuiAdapter.Hide,
        IsTextUIOpen = function()
            if GetResourceState("ox_lib"):find("start") then
                return exports.ox_lib:isTextUIOpen()
            end
            return false
        end,
    }
    if UI then
        public.interface = UI
        public.menus = UI
        public.menu = UI
        if public.adapters then public.adapters.menu = UI end
        public.RegisterContext = UI.RegisterContext
        public.registerContext = UI.registerContext or UI.RegisterContext
        public.ShowContext = UI.ShowContext
        public.showContext = UI.showContext or UI.ShowContext
        public.HideContext = UI.HideContext
        public.hideContext = UI.hideContext or UI.HideContext
        public.GetOpenContextMenu = UI.GetOpenContextMenu
        public.getOpenContextMenu = UI.getOpenContextMenu or UI.GetOpenContextMenu
        public.RegisterMenu = UI.RegisterMenu
        public.registerMenu = UI.registerMenu or UI.RegisterMenu
        public.ShowMenu = UI.ShowMenu
        public.showMenu = UI.showMenu or UI.ShowMenu
        public.HideMenu = UI.HideMenu
        public.hideMenu = UI.hideMenu or UI.HideMenu
        public.AlertDialog = UI.AlertDialog
        public.alertDialog = UI.alertDialog or UI.AlertDialog
        public.InputDialog = UI.InputDialog
        public.inputDialog = UI.inputDialog or UI.InputDialog
        public.Notify = UI.Notify
        public.ShowTextUI = UI.ShowTextUI
        public.showTextUI = UI.showTextUI or UI.ShowTextUI
        public.HideTextUI = UI.HideTextUI
        public.hideTextUI = UI.hideTextUI or UI.HideTextUI
        public.IsTextUIOpen = UI.IsTextUIOpen
        public.isTextUIOpen = UI.isTextUIOpen or UI.IsTextUIOpen
        public.OpenVisualAdminMenu = UI.OpenVisualAdminMenu
        public.openVisualAdminMenu = UI.openVisualAdminMenu or UI.OpenVisualAdminMenu
        public.GetVisualConfig = UI.GetVisualConfig
        public.getVisualConfig = UI.getVisualConfig or UI.GetVisualConfig
    end
end

local cacheStore = {}
local cacheEvents = {}

local prCache = {
    resource = resourceName,
    context = PRCore.context,
    activeBridges = env.ActiveBridges,
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

function prCache.set(key, value)
    local oldValue = cacheStore[key]
    cacheStore[key] = value
    dispatchCacheEvent(key, value, oldValue)
    return value
end

function prCache.get(key, fallback)
    local value = cacheStore[key]
    if value == nil then return fallback end
    return value
end

function prCache.clear(key)
    if key == nil then
        for cacheKey in pairs(cacheStore) do
            prCache.clear(cacheKey)
        end

        return
    end

    local oldValue = cacheStore[key]
    cacheStore[key] = nil
    dispatchCacheEvent(key, nil, oldValue)
end

function prCache.clearPrefix(prefix)
    for key in pairs(cacheStore) do
        if key:sub(1, #prefix) == prefix then
            prCache.clear(key)
        end
    end
end

function prCache.remember(key, callback, timeout)
    local value = cacheStore[key]
    if value ~= nil then return value end

    value = callback()
    prCache.set(key, value)

    if timeout then
        SetTimeout(timeout, function()
            if cacheStore[key] == value then
                prCache.clear(key)
            end
        end)
    end

    return value
end

prCache.call = prCache.remember

function prCache.onChange(key, callback)
    cacheEvents[key] = cacheEvents[key] or {}
    cacheEvents[key][#cacheEvents[key] + 1] = callback
end

function prCache.GetPlayer(source, timeout)
    if PRCore.context == "server" then
        if type(source) ~= "number" then return nil end

        return prCache.remember(("player:%s"):format(source), function()
            return public.framework.GetPlayer and public.framework.GetPlayer(source)
        end, timeout or 1000)
    end

    return prCache.remember("player:self", function()
        return public.framework.GetPlayer and public.framework.GetPlayer()
    end, source or 1000)
end

function prCache.GetMetadata(source, metadata, timeout)
    if PRCore.context == "server" then
        if type(source) ~= "number" or type(metadata) ~= "string" then return nil end

        return prCache.remember(("metadata:%s:%s"):format(source, metadata), function()
            return public.framework.getPlayerMetadata and public.framework.getPlayerMetadata(source, metadata)
        end, timeout or 1000)
    end

    local metadataName = source
    if type(metadataName) ~= "string" then return nil end

    return prCache.remember(("metadata:self:%s"):format(metadataName), function()
        return public.framework.getPlayerMetadata and public.framework.getPlayerMetadata(metadataName)
    end, metadata or 1000)
end

function prCache.InvalidatePlayer(source)
    if PRCore.context == "server" then
        if type(source) ~= "number" then return end

        prCache.clear(("player:%s"):format(source))
        prCache.clearPrefix(("metadata:%s:"):format(source))
        return
    end

    prCache.clear("player:self")
    prCache.clearPrefix("metadata:self:")
end

setmetatable(prCache, {
    __call = function(_, key, callback, timeout)
        return prCache.remember(key, callback, timeout)
    end,
})

public.cache = prCache

pr_lib = public
if _G then
    _G.pr_lib = public
end
_ENV.pr_lib = public

if PRCore.context == "client" and GetConvar("pr_bridge:translator_auto_notify", "true") == "true" then
    if public.notify and public.notify.Notify then
        local originalNotify = public.notify.Notify
        public.notify.Notify = function(data)
            if data and (data.title or data.description) then
                local targetLang = data.lang or data.locale or GetConvar("pr_bridge:locale", "en-us"):lower():sub(1, 2)
                local strings = { data.title or "", data.description or "" }
                local translated = public.translator.translateBatch(strings, targetLang)
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
