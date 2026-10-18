---@meta

if not _VERSION:find("5.4") then
    error("Lua 5.4 must be enabled in the resource manifest!", 2)
end

local resourceName = GetCurrentResourceName()
local bridgeResource = "pr_bridge"
local legacyOxImport = debug.getinfo(1, "S").source:find("@ox_lib/init.lua", 1, true) ~= nil

if resourceName == bridgeResource then return end

if pr_lib and pr_lib.name == bridgeResource then
    if legacyOxImport or pr_lib.legacyOxBootstrap then return end
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

if legacyOxImport then
    local compatConfig = {}
    PRCore.load('@pr_bridge/bridge/config', compatConfig)
    if compatConfig.Config.compatOx_lib ~= true then
        error('PR Bridge ox_lib compatibility is disabled (Config.compatOx_lib=false). Start the original ox_lib and remove its provide alias from pr_bridge/fxmanifest.lua.', 2)
    end
    if lib and lib.bridge == bridgeResource and lib.runtimeInstalled then return end
    return PRCore.load("@pr_bridge/bridge/compat/ox_lib/ox_bootstrap", _ENV)(_ENV, resourceName)
end

local public = {
    name = bridgeResource,
    resource = resourceName,
    context = PRCore.context,
    legacyOxBootstrap = legacyOxImport,
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
public.jsonDraft = PRCore.jsonDraft
public.withJsonLock = PRCore.withJsonLock
public.wrapJsonMutations = PRCore.wrapJsonMutations
public.loadJsonRecovery = PRCore.loadJsonRecovery
public.saveJsonRecovery = PRCore.saveJsonRecovery
public.recordJsonIncident = PRCore.recordJsonIncident
public.saveJsonBatch = PRCore.saveJsonBatch
public.loadModule = PRCore.loadModule
public.callback = PRCore.callback

-- Registers exports on the resource that loaded @pr_bridge/init.lua. Because
-- this file runs inside the consumer environment, client scripts create client
-- exports and server scripts create server exports without extra manifests.
local registeredExports = {}

local function inferExportName(callback)
    if type(callback) ~= "function" then return end

    if _G then
        for name, value in pairs(_G) do
            if type(name) == "string" and value == callback then return name end
        end
    end

    if debug and debug.getinfo then
        local info = debug.getinfo(callback, "n")
        if info and info.name and info.name ~= "" then return info.name end
    end
end

local function registerExport(name, callback)
    if type(name) ~= "string" or name == "" then return false, "invalid_name" end
    if type(callback) ~= "function" then return false, "invalid_callback" end

    local current = registeredExports[name]
    if current then
        return current == callback, current == callback and nil or "already_registered"
    end

    local ok, reason = pcall(function()
        exports(name, callback)
    end)
    if not ok then return false, reason end

    registeredExports[name] = callback
    return true
end

function public.addExports(name, callback)
    if type(name) == "table" and callback == nil then
        local registered = {}
        for exportName, exportCallback in pairs(name) do
            local ok, reason = registerExport(exportName, exportCallback)
            if not ok then return false, reason, exportName end
            registered[#registered + 1] = exportName
        end
        table.sort(registered)
        return true, registered
    end

    if type(name) == "function" then
        if type(callback) == "string" then
            name, callback = callback, name
        else
            callback = name
            name = inferExportName(callback)
        end
    elseif type(name) == "string" and callback == nil then
        callback = _G and _G[name] or nil
    end

    if not name then return false, "name_required" end
    return registerExport(name, callback)
end

public.addExport = public.addExports
public.AddExport = public.addExports
public.AddExports = public.addExports
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
public.getLocales = function(invokingResource)
    return public.locale(invokingResource):getAll()
end
PRCore.load("@pr_bridge/bridge/config", env)
public.debug = PRCore.load("@pr_bridge/bridge/debug", env)
public.print = {
    info = function(...) public.debug.info(...) end,
    warn = function(...) public.debug.warn(...) end,
    error = function(...) public.debug.error(...) end,
}

function public.logger(source, event, message, tag)
    local scope = tag and ("[%s]"):format(tag) or ""
    print(("^3[pr_bridge][%s][%s]%s^0 %s"):format(resourceName, tostring(event or "log"), scope, tostring(message or "")))
end

public.waitFor = PRCore.load('@pr_bridge/bridge/utils/waitFor', env)

local intervals = {}
local nextIntervalId = 0

function public.setInterval(callback, interval, ...)
    interval = interval or 0

    if type(interval) ~= "number" then
        error(("interval must be a number (received '%s')"):format(type(interval)), 2)
    end

    if type(callback) == "number" then
        local entry = intervals[callback]
        if not entry then
            error(("no interval exists with id %s"):format(callback), 2)
        end

        entry.delay = interval
        return
    end

    if type(callback) ~= "function" then
        error(("interval callback must be a function (received '%s')"):format(type(callback)), 2)
    end

    nextIntervalId = nextIntervalId + 1
    local id = nextIntervalId
    local entry = {
        active = true,
        delay = interval,
        callback = callback,
        args = { ... },
    }

    intervals[id] = entry

    CreateThread(function()
        while entry.active do
            local delay = entry.delay
            Wait(delay)
            if not entry.active or delay < 0 then break end
            entry.callback(table.unpack(entry.args))
        end

        intervals[id] = nil
    end)

    return id
end

function public.clearInterval(id)
    if type(id) ~= "number" then
        error(("interval id must be a number (received '%s')"):format(type(id)), 2)
    end

    local entry = intervals[id]
    if not entry then
        error(("no interval exists with id %s"):format(id), 2)
    end

    entry.active = false
end

public.array = {}
function public.array:new(...)
    local values = { ... }
    local lookup = {}
    for i = 1, #values do lookup[values[i]] = true end

    function values:includes(value)
        return lookup[value] == true
    end

    return values
end
env.Lang = env.Locale.init("pr_bridge")
public.utils = PRCore.load("@pr_bridge/bridge/utils/shared", env) or {}
public.math = PRCore.load("@pr_bridge/bridge/utils/numbers", env) or {}
public.table = PRCore.load("@pr_bridge/bridge/utils/tables", env) or {}
public.string = PRCore.load("@pr_bridge/bridge/utils/strings", env) or {}
public.timer = PRCore.load("@pr_bridge/bridge/utils/timer", env)
public.ids = PRCore.load("@pr_bridge/bridge/utils/ids", env) or {}
public.translator = PRCore.load(("@pr_bridge/bridge/translator/%s"):format(PRCore.context), env, true) or {}

if _ENV.SetInterval == nil then _ENV.SetInterval = public.setInterval end
if _ENV.ClearInterval == nil then _ENV.ClearInterval = public.clearInterval end

if PRCore.context == "client" then
    function public.setClipboard(value)
        assert(type(value) == "string", "clipboard value must be a string")
        TriggerEvent("pr_bridge:ui:send", "setClipboard", value)
        return true
    end
else
    function public.setClipboard()
        return false, "client_only"
    end
end

local debugValue = GetResourceMetadata(resourceName, "pr_bridge_debug", 0)
env.Config.Debug = debugValue == "true" or debugValue == "yes" or debugValue == "1"
public.environment = PRCore.load("@pr_bridge/bridge/environment", env)
PRCore.environment = public.environment
public.callback = PRCore.load(("@pr_bridge/bridge/callback/%s"):format(PRCore.context), env) or PRCore.callback
local callbackMode = "legacy"
if public.environment.isSecureCallbackEnabled() then
    local secureCallback = PRCore.load(("@pr_bridge/bridge/callback/secure_%s"):format(PRCore.context), env)
    if secureCallback then
        public.callback = secureCallback
        callbackMode = "secure"
    end
end
public.callback.getMode = function() return callbackMode end
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
                    if PRCore.isResourceStarted(info.resource) then
                        setActiveBridge(bridgeType, info.folder)
                        return ("@pr_bridge/bridge/frameworks/%s/%s"):format(info.folder, PRCore.context)
                    end
                    break
                end
            end
        end
    end
    if bridgeType == "targets" then
        local forced = env.Config.Target
        if type(forced) == "string" and forced ~= "" and forced ~= "auto" then
            for i = 1, #bridge do
                local info = bridge[i]
                if info.resource == forced or info.folder == forced then
                    if PRCore.isResourceStarted(info.resource) then
                        setActiveBridge(bridgeType, info.folder)
                        return ("@pr_bridge/bridge/%s/%s/%s"):format(bridgeType, info.folder, PRCore.context)
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
                    if PRCore.isResourceStarted(info.resource) then
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
                    if PRCore.isResourceStarted(info.resource) then
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
public.interact = PRCore.load(("@pr_bridge/bridge/interact/%s"):format(PRCore.context), env) or {}
public.interactions = public.interact
loadBridgeModule("textuiAdapter", "textui")
loadBridgeModule("banking", "banking")
if normalizeApi then normalizeApi.target(public.target, env.ActiveBridges.target); normalizeApi.textui(public.textuiAdapter); normalizeApi.banking(public.banking); normalizeApi.notification(public.notify, PRCore.context, env.ActiveBridges.notification) end
loadBridgeModule("phone", "phones")
loadBridgeModule("progress", "progressbar")
if PRCore.context == "client" then
    loadBridgeModule("minigame", "minigames")
    local skillCheckAdapter = public.minigame
    if type(skillCheckAdapter.SkillCheck or skillCheckAdapter.skillCheck) ~= "function" then
        skillCheckAdapter = PRCore.load("@pr_bridge/bridge/minigames/default/client", env) or {}
    end
    public.skillCheck = skillCheckAdapter.SkillCheck or skillCheckAdapter.skillCheck
    public.cancelSkillCheck = skillCheckAdapter.CancelSkillCheck or skillCheckAdapter.cancelSkillCheck
    public.skillCheckActive = skillCheckAdapter.SkillCheckActive or skillCheckAdapter.skillCheckActive
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
public.frameworkRouting = PRCore.load('@pr_bridge/bridge/compat/framework_routing', env)(env.ActiveBridges, env.Config)

public.inventories = public.inventory
if PRCore.context == "server" then
    -- A API publica de notificacoes usa sempre a interface nativa do PR Bridge.
    public.notify = PRCore.load("@pr_bridge/bridge/notifications/default/server", env)
end
public.notifications = public.notify
public.notification = public.notify
public.menu = public.menus
public.targets = public.target
public.phones = public.phone
public.progressbar = public.progress
if PRCore.context == "client" and type(public.progress) == "table" then
    public.progressBar = public.progress.progressBar
    public.progressCircle = public.progress.progressCircle
    public.progressActive = public.progress.progressActive
    public.cancelProgress = public.progress.cancelProgress

    setmetatable(public.progressbar, {
        __call = function(_, data)
            return public.progress.progressBar(data)
        end,
    })
end
public.textUIAdapter = public.textuiAdapter
public.textuiBridge = public.textuiAdapter
public.textUIBridge = public.textuiAdapter
public.garage = PRCore.load(("@pr_bridge/bridge/garages/%s"):format(PRCore.context), env)(public)
public.bank = public.banking
public.adapters = { framework=public.framework, inventory=public.inventory, notification=public.notify, menu=public.menus, target=public.target, interact=public.interact, textui=public.textuiAdapter, banking=public.banking, phone=public.phone, progress=public.progress, weather=public.weather }
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
if PRCore.context == "client" then
    public.requestModel = public.fivem.streaming.requestModel
    public.requestAnimDict = public.fivem.streaming.requestAnimDict
    public.requestAnimSet = public.fivem.streaming.requestAnimSet
    public.requestNamedPtfxAsset = public.fivem.streaming.requestPtfxAsset
    public.playAnim = public.fivem.streaming.playAnim
    public.getClosestVehicle = function(coords, radius, includePlayers)
        local options = type(includePlayers) == "table" and includePlayers or nil
        local closest = public.fivem.objects.getClosestVehicle(coords, radius or 2.0, options)
        return closest and closest.entity or nil, closest and closest.coords or nil
    end
    public.getClosestPlayer = function(coords, radius, includePlayer)
        coords = coords or GetEntityCoords(PlayerPedId())
        radius = tonumber(radius) or 2.0
        local closestPlayer, closestPed, closestCoords, closestDistance
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() and playerId ~= includePlayer then
                local ped = GetPlayerPed(playerId)
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
                if distance <= radius and (not closestDistance or distance < closestDistance) then
                    closestPlayer, closestPed, closestCoords, closestDistance = playerId, ped, pedCoords, distance
                end
            end
        end
        return closestPlayer, closestPed, closestCoords
    end
    public.getNearbyPlayers = function(coords, radius, includePlayer)
        coords = coords or GetEntityCoords(PlayerPedId())
        radius = tonumber(radius) or 2.0
        local nearby = {}
        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() and playerId ~= includePlayer then
                local ped = GetPlayerPed(playerId)
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
                if distance <= radius then
                    nearby[#nearby + 1] = { id = playerId, ped = ped, coords = pedCoords, distance = distance }
                end
            end
        end
        table.sort(nearby, function(a, b) return a.distance < b.distance end)
        return nearby
    end

    if public.raycast then
        public.raycast.cam = function(flags, ignoreFlags, distance)
            return public.raycast.fromCamera(distance or 10.0, flags, ignoreFlags, PlayerPedId())
        end
    end

    public.disableControls = PRCore.load("@pr_bridge/bridge/fivem/controls/client", env)(false)
end
public.ui = public.fivem.ui
public.nui = public.fivem.nui
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
        public.GetOpenMenu = UI.GetOpenMenu
        public.getOpenMenu = UI.getOpenMenu or UI.GetOpenMenu
        public.AlertDialog = UI.AlertDialog
        public.alertDialog = UI.alertDialog or UI.AlertDialog
        public.InputDialog = UI.InputDialog
        public.inputDialog = UI.inputDialog or UI.InputDialog
        public.Notify = UI.Notify
        public.notify.Notify = UI.Notify
        public.NotifyBubble = UI.NotifyBubble
        public.notifyBubble = UI.notifyBubble or UI.NotifyBubble
        public.HideNotifyBubble = UI.HideNotifyBubble
        public.hideNotifyBubble = UI.hideNotifyBubble or UI.HideNotifyBubble
        if type(public.notify) == "table" then
            public.notify.NotifyBubble = public.NotifyBubble
            public.notify.HideNotifyBubble = public.HideNotifyBubble
        end
        public.ShowTextUI = UI.ShowTextUI
        public.showTextUI = UI.showTextUI or UI.ShowTextUI
        public.HideTextUI = UI.HideTextUI
        public.hideTextUI = UI.hideTextUI or UI.HideTextUI
        public.IsTextUIOpen = UI.IsTextUIOpen
        public.isTextUIOpen = UI.isTextUIOpen or UI.IsTextUIOpen
        local NativeTextUI = {
            Show = UI.ShowTextUI,
            show = UI.showTextUI or UI.ShowTextUI,
            Hide = UI.HideTextUI,
            hide = UI.hideTextUI or UI.HideTextUI,
            IsOpen = UI.IsTextUIOpen,
            isOpen = UI.isTextUIOpen or UI.IsTextUIOpen,
        }
        public.textuiAdapter = NativeTextUI
        public.textUIAdapter = NativeTextUI
        public.textuiBridge = NativeTextUI
        public.textUIBridge = NativeTextUI
        if public.adapters then public.adapters.textui = NativeTextUI end
        if public.framework then
            public.framework.ShowTextUI = UI.ShowTextUI
            public.framework.HideTextUI = UI.HideTextUI
        end
        public.OpenVisualAdminMenu = UI.OpenVisualAdminMenu
        public.openVisualAdminMenu = UI.openVisualAdminMenu or UI.OpenVisualAdminMenu
        public.GetVisualConfig = UI.GetVisualConfig
        public.getVisualConfig = UI.getVisualConfig or UI.GetVisualConfig
        public.addRadialItem = UI.AddRadialItem
        public.removeRadialItem = UI.RemoveRadialItem
        public.clearRadialItems = UI.ClearRadialItems
        public.registerRadial = UI.RegisterRadial
        public.hideRadial = UI.HideRadial
        public.disableRadial = UI.DisableRadial
        public.getCurrentRadialId = UI.GetCurrentRadialId
    end
end

if PRCore.context == "server" then
    local bubbleSequence = 0
    local function prepareBubble(source, data, all)
        if type(data) == "string" then data = { description = data } end
        if type(data) ~= "table" then return nil end
        local payload = {}
        for key, value in pairs(data) do payload[key] = value end
        bubbleSequence = bubbleSequence + 1
        payload.id = tostring(payload.id or (resourceName .. ":server_bubble:" .. bubbleSequence))
        if not all and payload.serverId == nil and payload.playerId == nil and payload.entity == nil and payload.netId == nil then
            payload.serverId = source
        end
        return payload
    end

    function public.NotifyBubble(source, data)
        source = tonumber(source)
        if not source or source <= 0 then return false end
        local payload = prepareBubble(source, data, false)
        if not payload then return false end
        TriggerClientEvent("pr_bridge:notifyBubble", source, payload)
        return payload.id
    end

    function public.NotifyBubbleAll(source, data)
        if type(source) ~= "number" then
            data = source
            source = type(data) == "table" and tonumber(data.serverId or data.source) or nil
        end
        source = tonumber(source)
        if not source or source <= 0 then return false end
        local payload = prepareBubble(source, data, true)
        if not payload then return false end
        payload.serverId = source
        TriggerClientEvent("pr_bridge:notifyBubble", -1, payload)
        return payload.id
    end

    function public.HideNotifyBubble(source, id)
        source = tonumber(source)
        if not source or source == 0 or id == nil then return false end
        TriggerClientEvent("pr_bridge:notifyBubble:hideNet", source, tostring(id))
        return true
    end

    public.notifyBubble = public.NotifyBubble
    public.notifyBubbleAll = public.NotifyBubbleAll
    public.hideNotifyBubble = public.HideNotifyBubble
    if type(public.notify) == "table" then
        public.notify.NotifyBubble = public.NotifyBubble
        public.notify.NotifyBubbleAll = public.NotifyBubbleAll
        public.notify.HideNotifyBubble = public.HideNotifyBubble
    end
end

local createPassiveCache = assert(PRCore.load('@pr_bridge/bridge/cache/shared', env), 'PR Bridge passive cache module unavailable')
local prCache = createPassiveCache(public, env.ActiveBridges)
public.cache = prCache
PRCore.load('@pr_bridge/bridge/cache/state', env)(public, prCache)
PRCore.load('@pr_bridge/bridge/cache/central', env)(prCache)
PRCore.load('@pr_bridge/bridge/cache/resources', env)(prCache)
public.onCache = prCache.onChange
public.getCacheMetrics = prCache.getMetrics
if PRCore.context == 'client' then
    public.player = PRCore.load('@pr_bridge/bridge/cache/player_client', env)(public)
end
public.settings = PRCore.load("@pr_bridge/bridge/settings", env)(public)
if PRCore.context == "client" then
    local normalizeEntities = PRCore.load("@pr_bridge/bridge/compat/entities_client", env)
    if normalizeEntities then normalizeEntities(public) end
end

if PRCore.context == "client" then
    local spatial = PRCore.load("@pr_bridge/bridge/fivem/spatial/client", env)
    public.points, public.zones = spatial.points, spatial.zones
end

-- Cache data is published by producers, never gathered per consumer.

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

if type(public.notify) == "table" then
    local notifyMetatable = getmetatable(public.notify) or {}
    notifyMetatable.__call = notifyMetatable.__call or function(self, ...)
        local callback = public.Notify or self.Notify or self.notify
        if type(callback) ~= "function" then return false end
        return callback(...)
    end
    setmetatable(public.notify, notifyMetatable)
end

PRCore.load('@pr_bridge/bridge/library/init', env)(public, _ENV)
if env.Config.compatOx_lib == true then
    local installOxCompatibility = PRCore.load("@pr_bridge/bridge/compat/ox_lib/ox_phase1", env)
    installOxCompatibility(public, { existing = rawget(_ENV, "lib") })
    PRCore.load("@pr_bridge/bridge/compat/ox_lib/ox_runtime", env)(public, _ENV)
end
