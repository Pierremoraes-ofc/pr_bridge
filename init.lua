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

function public.waitFor(callback, message, timeout)
    assert(type(callback) == "function", "waitFor callback must be a function")
    timeout = tonumber(timeout) or 1000
    local started = GetGameTimer()

    while true do
        local result = callback()
        if result ~= nil then return result end
        if GetGameTimer() - started >= timeout then
            if message then error(message, 2) end
            return false
        end
        Wait(0)
    end
end

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
public.callback = PRCore.load(("@pr_bridge/bridge/callback/%s"):format(PRCore.context), env) or PRCore.callback
if GetConvar("pr_bridge:callback:secure", "false") == "true" then
    public.callback = PRCore.load(("@pr_bridge/bridge/callback/secure_%s"):format(PRCore.context), env) or public.callback
end
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
    if bridgeType == "targets" then
        local forced = env.Config.Target
        if type(forced) == "string" and forced ~= "" and forced ~= "auto" then
            for i = 1, #bridge do
                local info = bridge[i]
                if info.resource == forced or info.folder == forced then
                    if GetResourceState(info.resource):find("start") then
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

    public.player = {}
    function public.player:new()
        local state = LocalPlayer.state
        return {
            get = function(_, key) return state[key] end,
            set = function(_, key, value) state:set(key, value, false) end,
            setr = function(_, key, value) state:set(key, value, true) end,
        }
    end
    if public.raycast then
        public.raycast.cam = function(flags, ignoreFlags, distance)
            return public.raycast.fromCamera(distance or 10.0, flags, ignoreFlags, PlayerPedId())
        end
    end

    local disabledControls = {}
    local disableControls = {}
    function disableControls:Add(controls)
        for i = 1, #(controls or {}) do disabledControls[controls[i]] = true end
    end
    function disableControls:Remove(controls)
        for i = 1, #(controls or {}) do disabledControls[controls[i]] = nil end
    end
    setmetatable(disableControls, {
        __call = function()
            for control in pairs(disabledControls) do DisableControlAction(0, control, true) end
        end,
    })
    public.disableControls = disableControls
end
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
        public.GetOpenMenu = UI.GetOpenMenu
        public.getOpenMenu = UI.getOpenMenu or UI.GetOpenMenu
        public.AlertDialog = UI.AlertDialog
        public.alertDialog = UI.alertDialog or UI.AlertDialog
        public.InputDialog = UI.InputDialog
        public.inputDialog = UI.inputDialog or UI.InputDialog
        public.Notify = UI.Notify
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
    if oldValue == value then return value end
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
    __index = function(_, key)
        return cacheStore[key]
    end,
})

public.cache = prCache
public.onCache = prCache.onChange
local createAutomaticCache = PRCore.load("@pr_bridge/bridge/cache/shared", env)
if createAutomaticCache then
    prCache = createAutomaticCache(public, env.ActiveBridges)
    local centralizeCache = PRCore.load("@pr_bridge/bridge/cache/central", env)
    if centralizeCache then centralizeCache(prCache) end
    public.cache = prCache
    public.onCache = prCache.onChange
    public.getCacheMetrics = prCache.getMetrics
end
if PRCore.context == "client" then
    local normalizeEntities = PRCore.load("@pr_bridge/bridge/compat/entities_client", env)
    if normalizeEntities then normalizeEntities(public) end
end

if PRCore.context == "client" then
    local activePoints = {}
    public.points = {}

    function public.points.new(data, distance, extraData)
        local point
        if extraData ~= nil then
            point = extraData
            point.coords = data
            point.distance = distance
        else
            point = data or {}
        end
        point.distance = tonumber(point.distance) or 1.0
        point.currentDistance = math.huge
        point.inside = false
        function point:remove()
            self.removed = true
            if self.inside and self.onExit then self:onExit() end
            self.inside = false
        end
        activePoints[#activePoints + 1] = point
        return point
    end

    function public.points.getAllPoints()
        local points = {}
        for i = 1, #activePoints do
            if not activePoints[i].removed then points[#points + 1] = activePoints[i] end
        end
        return points
    end

    function public.points.getClosestPoint(filter)
        local closest
        for i = 1, #activePoints do
            local point = activePoints[i]
            if not point.removed and point.currentDistance < math.huge and (not filter or filter(point)) then
                if not closest or point.currentDistance < closest.currentDistance then
                    closest = point
                end
            end
        end
        return closest
    end
    public.zones = {}
    function public.zones.sphere(data)
        data = data or {}
        data.distance = tonumber(data.radius or data.distance) or 1.0
        return public.points.new(data)
    end

    local function polygonContains(points, x, y)
        local inside = false
        local previous = #points

        for current = 1, #points do
            local a = points[current]
            local b = points[previous]
            local crosses = (a.y > y) ~= (b.y > y)

            if crosses then
                local edgeX = ((b.x - a.x) * (y - a.y) / (b.y - a.y)) + a.x
                if x < edgeX then inside = not inside end
            end

            previous = current
        end

        return inside
    end

    function public.zones.poly(data)
        data = data or {}
        local points = data.points or {}
        local thickness = tonumber(data.thickness) or 4.0
        local explicitMinZ = tonumber(data.minZ)
        local explicitMaxZ = tonumber(data.maxZ)
        local minZ, maxZ = math.huge, -math.huge
        local centerX, centerY, centerZ = 0.0, 0.0, 0.0

        for i = 1, #points do
            local point = points[i]
            local z = tonumber(point.z) or 0.0
            minZ = math.min(minZ, z)
            maxZ = math.max(maxZ, z)
            centerX = centerX + point.x
            centerY = centerY + point.y
            centerZ = centerZ + z
        end

        if #points == 0 then
            minZ, maxZ = 0.0, 0.0
        else
            centerX = centerX / #points
            centerY = centerY / #points
            centerZ = centerZ / #points
        end

        local lowerZ = explicitMinZ or (minZ - thickness * 0.5)
        local upperZ = explicitMaxZ or (maxZ + thickness * 0.5)
        if lowerZ > upperZ then lowerZ, upperZ = upperZ, lowerZ end

        data.minZ = lowerZ
        data.maxZ = upperZ
        data.coords = data.coords or vector3(centerX, centerY, (lowerZ + upperZ) * 0.5)
        data.contains = function(_, coords)
            local insideZ = coords.z >= lowerZ and coords.z <= upperZ
            return insideZ and #points >= 3 and polygonContains(points, coords.x, coords.y)
        end

        return public.points.new(data)
    end

    function public.zones.box(data)
        data = data or {}
        local size = data.size or vector3(1.0, 1.0, 1.0)
        local rotation = math.rad(tonumber(data.rotation) or 0.0)
        local cosine, sine = math.cos(rotation), math.sin(rotation)

        data.contains = function(self, coords)
            local center = self.coords
            local dx, dy, dz = coords.x - center.x, coords.y - center.y, coords.z - center.z
            local localX = dx * cosine + dy * sine
            local localY = -dx * sine + dy * cosine

            return math.abs(localX) <= size.x * 0.5
                and math.abs(localY) <= size.y * 0.5
                and math.abs(dz) <= size.z * 0.5
        end

        return public.points.new(data)
    end

    CreateThread(function()
        while true do
            local sleep = 250
            local coords = GetEntityCoords(PlayerPedId())
            local closestPoint = public.points.getClosestPoint()
            for i = #activePoints, 1, -1 do
                local point = activePoints[i]
                point.isClosest = point == closestPoint
                if point.removed then
                    table.remove(activePoints, i)
                elseif point.coords then
                    point.currentDistance = #(coords - vector3(point.coords.x, point.coords.y, point.coords.z))
                    local inside
                    if point.contains then
                        inside = point:contains(coords)
                    else
                        inside = point.currentDistance <= point.distance
                    end
                    if inside then
                        sleep = 0
                        if not point.inside then
                            point.inside = true
                            if point.onEnter then point:onEnter() end
                        end
                        if point.nearby then point:nearby() end
                    elseif point.inside then
                        point.inside = false
                        if point.onExit then point:onExit() end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

if PRCore.context == "client" then
    CreateThread(function()
        while true do
            local playerId = PlayerId()
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle == 0 then vehicle = nil end

            local seat
            if vehicle then
                for index = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
                    if GetPedInVehicleSeat(vehicle, index) == ped then
                        seat = index
                        break
                    end
                end
            end

            local playerData = public.framework.GetPlayerData and public.framework.GetPlayerData() or {}
            if type(playerData) ~= "table" then playerData = {} end

            local loaded = next(playerData) ~= nil
            if public.framework.IsPlayerLoaded then
                local ok, result = pcall(public.framework.IsPlayerLoaded)
                if ok then loaded = result == true end
            end

            local metadata = type(playerData.metadata) == "table" and playerData.metadata or {}
            local money = type(playerData.money) == "table" and playerData.money or {}
            local function account(name)
                if public.framework.GetMoney then
                    local ok, value = pcall(public.framework.GetMoney, name)
                    if ok and value ~= nil then return tonumber(value) or 0 end
                end
                return tonumber(money[name]) or 0
            end

            prCache.set("resource", resourceName)
            prCache.set("playerId", playerId)
            prCache.set("serverId", GetPlayerServerId(playerId))
            prCache.set("ped", ped)
            prCache.set("vehicle", vehicle)
            prCache.set("seat", seat)
            prCache.set("playerLoaded", loaded)
            prCache.set("playerData", playerData)
            prCache.set("job", playerData.job)
            prCache.set("gang", playerData.gang)
            prCache.set("cash", account("cash"))
            prCache.set("bank", account("bank"))
            prCache.set("dirtyMoney", account("black"))
            prCache.set("hunger", tonumber(metadata.hunger) or 0)
            prCache.set("thirst", tonumber(metadata.thirst) or 0)
            prCache.set("stress", tonumber(metadata.stress) or 0)
            prCache.set("isDead", IsEntityDead(ped) or metadata.isdead == true or metadata.inlaststand == true)
            Wait(100)
        end
    end)
end

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

local installOxCompatibility = PRCore.load("@pr_bridge/bridge/compat/ox_phase1", env, true)
if type(installOxCompatibility) == "function" then
    installOxCompatibility(public, { existing = rawget(_ENV, "lib") })
end
