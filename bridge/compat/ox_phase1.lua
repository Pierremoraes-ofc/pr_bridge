local function bind(owner, callback)
    if type(callback) ~= "function" then
        return function() return false, "not_available" end
    end

    return function(first, ...)
        if first == owner then
            return callback(...)
        end

        return callback(first, ...)
    end
end

local function firstFunction(...)
    local candidates = { ... }
    for index = 1, #candidates do
        if type(candidates[index]) == "function" then return candidates[index] end
    end
end

return function(public, options)
    options = type(options) == "table" and options or {}

    local compatibility = public.ox_lib or {}
    local targetSource = public.target or {}
    local target = compatibility.target or {}
    local targetFunctions = {
        "addGlobalOption", "removeGlobalOption",
        "addGlobalObject", "removeGlobalObject",
        "addGlobalPickup", "removeGlobalPickup",
        "addGlobalPed", "removeGlobalPed",
        "addGlobalPlayer", "removeGlobalPlayer",
        "addGlobalVehicle", "removeGlobalVehicle",
        "addModel", "removeModel",
        "addPickupType", "removePickupType",
        "addPickup", "removePickup",
        "addEntity", "removeEntity",
        "addLocalEntity", "removeLocalEntity",
        "addSphereZone", "addBoxZone", "addPolyZone",
        "removeZone", "zoneExists", "disableTargeting", "isActive",
        "getTargetOptions", "inspectModels",
    }

    for index = 1, #targetFunctions do
        local name = targetFunctions[index]
        target[name] = bind(target, targetSource[name] or targetSource[name:sub(1, 1):upper() .. name:sub(2)])
    end

    compatibility.name = "ox_lib"
    compatibility.bridge = "pr_bridge"
    compatibility.phase = 1
    compatibility.target = target
    compatibility.ox_target = target

    -- Interface ox_lib-compatible. The underlying pr_bridge modules already
    -- preserve the synchronous return values expected by ox_lib consumers.
    compatibility.alertDialog = firstFunction(public.alertDialog, public.AlertDialog)
    compatibility.setClipboard = public.setClipboard
    compatibility.registerContext = firstFunction(public.registerContext, public.RegisterContext)
    compatibility.showContext = firstFunction(public.showContext, public.ShowContext)
    compatibility.hideContext = firstFunction(public.hideContext, public.HideContext)

    -- Runtime primitives used by resources migrated away from @ox_lib/init.lua.
    -- Keep these aliases on `lib` so legacy calls continue working while new
    -- code can use the canonical pr_lib APIs directly.
    compatibility.callback = public.callback
    compatibility.onCache = public.onCache
    compatibility.addCommand = public.addCommand
    compatibility.requestAnimDict = public.requestAnimDict

    compatibility.getOpenContextMenu = firstFunction(public.getOpenContextMenu, public.GetOpenContextMenu)
    compatibility.inputDialog = firstFunction(public.inputDialog, public.InputDialog)
    compatibility.registerMenu = firstFunction(public.registerMenu, public.RegisterMenu)
    compatibility.showMenu = firstFunction(public.showMenu, public.ShowMenu)
    compatibility.hideMenu = firstFunction(public.hideMenu, public.HideMenu)
    compatibility.getOpenMenu = firstFunction(public.getOpenMenu, public.GetOpenMenu)

    compatibility.progressBar = public.progressBar
    compatibility.progressCircle = public.progressCircle
    compatibility.progressActive = public.progressActive
    compatibility.cancelProgress = public.cancelProgress
    compatibility.skillCheck = public.skillCheck
    compatibility.cancelSkillCheck = public.cancelSkillCheck

    compatibility.addRadialItem = public.addRadialItem
    compatibility.removeRadialItem = public.removeRadialItem
    compatibility.clearRadialItems = public.clearRadialItems
    compatibility.registerRadial = public.registerRadial
    compatibility.hideRadial = public.hideRadial
    compatibility.disableRadial = public.disableRadial
    compatibility.getCurrentRadialId = public.getCurrentRadialId

    compatibility.showTextUI = firstFunction(public.showTextUI, public.ShowTextUI)
    compatibility.hideTextUI = firstFunction(public.hideTextUI, public.HideTextUI)
    compatibility.isTextUIOpen = firstFunction(public.isTextUIOpen, public.IsTextUIOpen)

    if public.context == "server" then
        compatibility.notify = function(playerId, data)
            local callback = public.notify and (public.notify.Notify or public.notify.notify)
            if type(callback) ~= "function" then return false, "not_available" end
            return callback(playerId, data)
        end
    else
        compatibility.notify = firstFunction(public.Notify, public.notify and public.notify.Notify)
    end

    -- Direct target aliases ease migration from exports.ox_target to lib.*
    -- while lib.target/pr_lib.ox_target remain the collision-free form.
    for index = 1, #targetFunctions do
        local name = targetFunctions[index]
        if compatibility[name] == nil then compatibility[name] = target[name] end
    end

    public.ox_lib = compatibility
    public.ox = compatibility
    public.ox_target = target
    public.compat = public.compat or {}
    public.compat.ox_lib = compatibility
    public.compat.ox_target = target

    local force = options.force == true or GetConvar("pr_bridge:ox_compat:force", "false") == "true"
    local existing = options.existing or rawget(_ENV, "lib")
    if force or existing == nil then
        _ENV.lib = compatibility
        if _G then _G.lib = compatibility end
        compatibility.installed = true
    else
        compatibility.installed = existing == compatibility
        compatibility.preserved = existing
    end

    local existingCache = rawget(_ENV, "cache")
    if force or existingCache == nil then
        _ENV.cache = public.cache
        if _G then _G.cache = public.cache end
        compatibility.cacheInstalled = true
    end

    return compatibility
end
