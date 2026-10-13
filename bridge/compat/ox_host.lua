-- Runs only in PR Bridge. No new resource, no original ox_lib frontend.
local context = PRCore.context
local function originalRunning(name)
    return GetResourceState(name):find("start") ~= nil
        and GetResourceMetadata(name, "name", 0) ~= "pr_bridge"
end
local publish = PRCore.load("bridge.compat.ox_exports")
local services, clients = {}, {}
local registry = PRCore.load('bridge.callback.registry')
Bridge.callbackRegistry = registry
local cleanupVisual
local hostEnv = setmetatable({}, { __index = _ENV })
hostEnv._G = hostEnv
local nativeExports = exports
hostEnv.exports = setmetatable({}, {
    __index = function(_, name) return nativeExports[name] end,
    __call = function(_, name, method)
        nativeExports(name, method)
        -- Hook pipelines publish dynamic export names, not just fixed APIs.
        publish("ox_lib", { [name] = method }, originalRunning)
    end,
})
local public = setmetatable({ resource = "pr_bridge", context = context, cache = Bridge.cache }, { __index = Bridge })
PRCore.load("bridge.compat.ox_phase1", hostEnv)(public, { force = true })
local lib = PRCore.load("bridge.compat.ox_runtime", hostEnv)(public, hostEnv)

local library = lib.__native('bridge/library/init')
services.hasLoaded = library.hasLoaded
library.localePath = 'bridge/compat/ox_locales'
services.getLocaleKey = function() return PRCore.load('bridge.i18n.settings').getKey() end
library.locale(services.getLocaleKey())
hostEnv.locale = library.translate
function services.setLocale(key)
    library.setLocale(key)
    TriggerEvent('ox_lib:setLocale',key)
end
function services.getLocale(key)
    local value=library.getLocales()[key]
    if value~=nil then return value end
    if Lang and Lang.has and Lang:has(key) then return Lang:t(key) end
end
services.setValidCallback, services.isCallbackValid = registry.set, registry.valid

-- Local imports call these directly; external consumers use oxService.
lib.setValidCallback, lib.isCallbackValid = services.setValidCallback, services.isCallbackValid
lib.getLocaleKey, lib.setLocale = services.getLocaleKey, services.setLocale
local oxActiveAtBoot = originalRunning("ox_lib")
if not oxActiveAtBoot then
    RegisterNetEvent("ox_lib:validateCallback", function(name, owner, key)
        if originalRunning("ox_lib") or registry.exists(name) then return end
        if type(name) ~= "string" or type(owner) ~= "string" or type(key) ~= "string" then return end
        if context == "server" then
            if not tonumber(source) or tonumber(source) <= 0 then return end
            TriggerClientEvent("__ox_cb_" .. owner, source, key, "cb_invalid")
        elseif source ~= "" then
            TriggerServerEvent("__ox_cb_" .. owner, key, "cb_invalid")
        end
    end)
end

for name, method in pairs(PRCore.load('bridge.compat.ox_native')(Bridge, context, lib.contractVersion, originalRunning)) do
    services[name] = method
end
if not oxActiveAtBoot and context == 'server' then
    lib.callback.register('ox_lib:checkPlayerAce', Bridge.fivem.ace.isPlayerAceAllowed)
end
if not oxActiveAtBoot then PRCore.load('bridge.compat.ox_protocol',hostEnv)(lib,Bridge,context) end
if not oxActiveAtBoot and context=='server' then
    for _,pipeline in pairs(Bridge.statePolicy.pipelines) do
        publish('ox_lib', {
            ['registerHook:'..pipeline.event]=function(cb,options) return pipeline:registerHook(cb,options) end,
            ['removeHook:'..pipeline.event]=function(id) return pipeline:remove(GetInvokingResource() or 'pr_bridge',id) end,
        },originalRunning)
    end
end

exports("oxService", function(name, ...)
    if originalRunning("ox_lib") then return exports.ox_lib[name](nil, ...) end
    local method = services[name]
    if not method then error(("ox_lib service '%s' unavailable on %s; restart PR Bridge and its consumers after stopping ox_lib"):format(tostring(name), context), 2) end
    return method(...)
end)

if context == "client" then
    services.cache = function(key) return Bridge.cache[key] end
    services.onCache = Bridge.onCache
    local nui=Bridge.fivem.nui or PRCore.load('bridge.fivem.nui.client')
    Bridge.fivem.nui=nui
    services.setNuiFocus=function(allowInput,disableCursor)
        return nui.focus(true,not disableCursor,allowInput,GetInvokingResource() or 'pr_bridge')
    end
    services.resetNuiFocus=function()
        return nui.focus(false,false,false,GetInvokingResource() or 'pr_bridge')
    end
    for _, key in ipairs({ "ped", "vehicle", "seat", "weapon", "playerId", "serverId" }) do
        Bridge.onCache(key, function(value, previous)
            if not originalRunning("ox_lib") then TriggerEvent("ox_lib:cache:" .. key, value, previous) end
        end)
    end

    local function uiForOwner(owner)
        if clients[owner] then return clients[owner].ui end
        local handlers = {}
        local env = setmetatable({
            GetCurrentResourceName = function() return owner end,
            AddEventHandler = function(event, cb)
                local id = AddEventHandler(event, cb)
                handlers[#handlers + 1] = id
                return id
            end,
        }, { __index = _ENV })
        env._G = env
        local ui = PRCore.load("@pr_bridge/interface/client/ui", env)
        local radial = PRCore.load("bridge.compat.ox_radial")(ui, owner)
        ui.registerRadial, ui.addRadialItem = radial.registerRadial, radial.addRadialItem
        local progress = Bridge.nativeProgress
        local skill = PRCore.load("@pr_bridge/bridge/minigames/default/client", env)
        for _, name in ipairs({ "progressBar", "progressCircle", "progressActive", "cancelProgress" }) do ui[name] = progress[name] end
        ui.skillCheck, ui.cancelSkillCheck, ui.skillCheckActive = skill.SkillCheck, skill.CancelSkillCheck, skill.SkillCheckActive
        clients[owner] = { ui = ui, handlers = handlers }
        return ui
    end
    local visual = {
        "alertDialog", "closeAlertDialog", "inputDialog", "closeInputDialog", "notify", "defaultNotify",
        "registerContext", "showContext", "hideContext", "getOpenContextMenu",
        "registerMenu", "showMenu", "hideMenu", "setMenuOptions", "getOpenMenu",
        "showTextUI", "hideTextUI", "isTextUIOpen", "registerRadial", "getCurrentRadialId",
        "hideRadial", "addRadialItem", "removeRadialItem", "clearRadialItems", "disableRadial",
        "progressBar", "progressCircle", "progressActive", "cancelProgress",
        "skillCheck", "cancelSkillCheck", "skillCheckActive",
    }
    for _, name in ipairs(visual) do
        services[name] = function(...)
            local ui = uiForOwner(GetInvokingResource() or "pr_bridge")
            local method = ui[name]
            assert(type(method) == "function", "Missing native UI contract: " .. name)
            return method(...)
        end
    end
    local coordinated
    coordinated, cleanupVisual = PRCore.load("bridge.compat.ox_visual")(function() return GetInvokingResource() or "pr_bridge" end, uiForOwner)
    for name, method in pairs(coordinated) do services[name] = method end
    local activities = PRCore.load("bridge.compat.ox_activity")(function() return GetInvokingResource() or "pr_bridge" end, uiForOwner)
    for name, method in pairs(activities) do services[name] = method end
    if not oxActiveAtBoot then
        RegisterCommand('cancelprogress', function() Bridge.nativeProgress.cancelProgress() end, false)
        for _, name in ipairs({ "progressBar", "progressCircle", "progressActive", "cancelProgress" }) do
            services[name] = function(...)
                local progress = Bridge.nativeProgress
                if name == 'cancelProgress' then
                    if not progress.progressActive() then error('No progress bar is active', 2) end
                    return progress.cancelProgress(true)
                end
                if name == 'progressActive' then return progress.progressActive() and true or nil end
                if name == 'progressBar' or name == 'progressCircle' then
                    while progress.progressActive() do Wait(0) end
                    return progress[name](...)
                end
            end
        end
        RegisterCommand("+ox_lib-radial", function() TriggerEvent("pr_bridge:radial:toggle") end, false)
        RegisterCommand("-ox_lib-radial", function() end, false)
        RegisterKeyMapping("+ox_lib-radial", hostEnv.locale("open_radial_menu"), "keyboard", "Z")
    end
    for _, name in ipairs({ "setClipboard" }) do
        if type(Bridge[name]) == "function" then services[name] = Bridge[name] end
    end
    RegisterNetEvent("ox_lib:notify", function(data)
        if not originalRunning("ox_lib") then services.notify(data) end
    end)
    RegisterNetEvent("ox_lib:defaultNotify", function(data)
        if not originalRunning("ox_lib") then services.defaultNotify(data) end
    end)
    local target = PRCore.load("bridge.targets.native.api")
    publish("ox_target", PRCore.load("bridge.compat.ox_target")(target), originalRunning)
    RegisterNetEvent("ox_target:removeEntity", function(netIds)
        if not originalRunning("ox_target") and source ~= "" then target.removeEntity(netIds) end
    end)
else
    services.notify = function(playerId, data) TriggerClientEvent("ox_lib:notify", playerId, data) end
end
publish("ox_lib", services, originalRunning)

AddEventHandler(context == "client" and "onClientResourceStop" or "onResourceStop", function(owner)
    if cleanupVisual then cleanupVisual(owner) end
    registry.removeOwner(owner)
    local client = clients[owner]
    if not client then return end
    if client.ui.getOpenContextMenu() then client.ui.hideContext(false) end
    client.ui.hideMenu(false)
    client.ui.closeInputDialog()
    client.ui.closeAlertDialog()
    client.ui.hideTextUI()
    client.ui.cancelProgress(true, owner)
    client.ui.cancelSkillCheck()
    for _, handler in ipairs(client.handlers) do RemoveEventHandler(handler) end
    clients[owner] = nil
end)
