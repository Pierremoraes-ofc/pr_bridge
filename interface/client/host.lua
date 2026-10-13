---NUI host — só no pr_bridge (dono do ui_page).

local ownerResource = nil
local focusCount = 0
local textuiDebugEnabled = false

local function getUiInterface()
    local value = Config and Config.ui_interface or "svelte"
    if type(value) ~= "string" then return "svelte" end

    value = value:lower()
    if value ~= "svelte" and value ~= "vue" then
        Bridge.debug.warn(("[pr_interface] ui_interface '%s' invalida, usando svelte."):format(value))
        return "svelte"
    end

    return value
end

local function applyUiInterface()
    SendNUIMessage({
        action = "ui:load",
        data = { interface = getUiInterface() },
    })
end

local function applyGlobalConfig(config)
    if type(config) ~= "table" then return end
    SendNUIMessage({ action = "theme:apply", data = config })
end

local function payloadOwner(data)
    if type(data) == "table" then
        return data.__resource or data.resource or data.owner or ownerResource
    end
    return ownerResource
end

local function setFocus(keepInput)
    focusCount = focusCount + 1
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(keepInput == true)
end

local function ensureFocus(keepInput)
    if focusCount <= 0 then focusCount = 1 end
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(keepInput == true)
end

local function clearFocus()
    focusCount = math.max(0, focusCount - 1)
    if focusCount <= 0 then
        focusCount = 0
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

local function resetFocus()
    focusCount = 0
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end

AddEventHandler("pr_bridge:ui:claim", function(resourceName)
    if type(resourceName) == "string" and resourceName ~= "" then ownerResource = resourceName end
end)

AddEventHandler("pr_bridge:ui:send", function(action, data)
    SendNUIMessage({ action = action, data = data })
end)

AddEventHandler("pr_bridge:ui:setFocus", function(keepInput)
    setFocus(keepInput == true)
end)

AddEventHandler("pr_bridge:ui:ensureFocus", function(keepInput)
    ensureFocus(keepInput == true)
end)

AddEventHandler("pr_bridge:ui:menuFocus", function(keepInput, replace)
    if replace then ensureFocus(keepInput) else setFocus(keepInput) end
    SetNuiFocus(true, false)
end)

AddEventHandler("pr_bridge:ui:setKeyboardFocus", function()
    focusCount = focusCount + 1
    SetNuiFocus(true, false)
    SetNuiFocusKeepInput(false)
end)

AddEventHandler("pr_bridge:ui:clearKeyboardFocus", function()
    focusCount = math.max(0, focusCount - 1)
    if focusCount > 0 then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
        return
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end)

AddEventHandler("pr_bridge:ui:clearFocus", clearFocus)
AddEventHandler("pr_bridge:ui:resetFocus", resetFocus)
AddEventHandler("pr_bridge:ui:hasFocus", function(requestId)
    TriggerEvent("pr_bridge:ui:hasFocus:result", requestId, focusCount > 0)
end)
AddEventHandler("pr_bridge:ui:textuiDebug", function(enabled)
    textuiDebugEnabled = enabled == true
    print(("[pr_bridge:textui-debug] enabled=%s"):format(tostring(textuiDebugEnabled)))
end)

RegisterNUICallback("debug:textui", function(data, cb)
    cb(1)
    if not textuiDebugEnabled then return end
    local ok, payload = pcall(json.encode, data or {})
    print(("[pr_bridge:textui-debug] %s"):format(ok and payload or tostring(data)))
end)

RegisterNUICallback("context:select", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource and type(data) == "table" then
        TriggerEvent("pr_bridge:ui:context:select", resource, data.id, tonumber(data.index))
    end
end)

for _, action in ipairs({ "selected", "side", "check", "confirm", "close" }) do
    RegisterNUICallback("menu:" .. action, function(data, cb)
        cb(1)
        local resource = payloadOwner(data)
        if resource then TriggerEvent("pr_bridge:ui:menu:event", resource, action, data) end
    end)
end
RegisterNUICallback("context:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:context:close", resource) end
end)
RegisterNUICallback("context:back", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:context:back", resource) end
end)
RegisterNUICallback("alert:result", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:alert:result", resource, data and data.result or "cancel") end
end)
RegisterNUICallback("alert:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:alert:close", resource) end
end)
RegisterNUICallback("input:submit", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:input:submit", resource, data and data.values or nil) end
end)
RegisterNUICallback("input:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then TriggerEvent("pr_bridge:ui:input:close", resource) end
end)
RegisterNUICallback("skillcheck:result", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource and type(data) == "table" then
        TriggerEvent("pr_bridge:ui:skillcheck:result", resource, data.token, data.result == true, data.reason)
    end
end)

local radial = { items = {}, menus = {}, menuOwners = {}, current = nil, history = {}, disabled = false, open = false }

local function radialItems(resource, menuId)
    if menuId then
        local owner = radial.menus[resource .. ":" .. menuId] and resource or radial.menuOwners[menuId]
        local menu = owner and radial.menus[owner .. ":" .. menuId]
        return menu and menu.items or {}
    end
    return radial.items
end

local function showRadial(resource, menuId)
    if radial.disabled then return end
    if menuId and not radial.menus[resource .. ":" .. menuId] then resource = radial.menuOwners[menuId] or resource end
    local items = radialItems(resource, menuId)
    if #items == 0 then return end
    radial.current = { resource = resource, menuId = menuId, items = items }
    radial.open = true
    LocalPlayer.state:set("pr_bridge_radial_current", menuId, false)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({ action = "radial:open", data = { title = menuId or "MENU RAPIDO", menuId = menuId, items = items } })
end

local function hideRadial()
    radial.open = false
    radial.current = nil
    radial.history = {}
    LocalPlayer.state:set("pr_bridge_radial_current", nil, false)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = "radial:close" })
end

local function refreshRadial()
    if not radial.open or not radial.current then return end
    local current = radial.current
    if #radialItems(current.resource, current.menuId) == 0 then hideRadial()
    else showRadial(current.resource, current.menuId) end
end

AddEventHandler("pr_bridge:radial:add", function(resource, items, parentMenuId)
    if parentMenuId then assert(radial.menus[resource .. ":" .. parentMenuId] or radial.menuOwners[parentMenuId], "No radial submenu with such parent id found") end
    local target = radialItems(resource, parentMenuId)
    for i = 1, #(items or {}) do
        items[i].resource = resource
        local found
        for index, previous in ipairs(target) do
            if previous.id == items[i].id then target[index] = items[i]; found = true; break end
        end
        if not found then target[#target + 1] = items[i] end
    end
    refreshRadial()
end)
AddEventHandler("pr_bridge:radial:register", function(resource, menu)
    for _, item in ipairs(menu.items) do item.resource = resource end
    radial.menus[resource .. ":" .. menu.id] = menu
    radial.menuOwners[menu.id] = resource
    refreshRadial()
end)
AddEventHandler("pr_bridge:radial:remove", function(resource, id, parentMenuId)
    local target = radialItems(resource, parentMenuId)
    for i = #target, 1, -1 do if target[i].id == id then table.remove(target, i) end end
    refreshRadial()
end)
AddEventHandler("pr_bridge:radial:clear", function()
    radial.items = {}
    refreshRadial()
end)
AddEventHandler("pr_bridge:radial:hide", hideRadial)
AddEventHandler("pr_bridge:radial:disable", function(state)
    radial.disabled = state == true
    if radial.disabled then hideRadial() end
end)

local function toggleRadial()
    if radial.open then hideRadial() else showRadial(GetCurrentResourceName(), nil) end
end

RegisterCommand("prradial", toggleRadial, false)
AddEventHandler("pr_bridge:radial:toggle", toggleRadial)

AddEventHandler("onClientResourceStop", function(resource)
    for index = #radial.items, 1, -1 do
        if radial.items[index].resource == resource then table.remove(radial.items, index) end
    end
    for key in pairs(radial.menus) do
        if key:sub(1, #resource + 1) == resource .. ":" then radial.menus[key] = nil end
    end
    for id, owner in pairs(radial.menuOwners) do if owner == resource then radial.menuOwners[id] = nil end end
    if radial.current and radial.current.resource == resource then hideRadial() else refreshRadial() end
end)

local radialKeybind, radialKeybindError = Bridge.addKeybind({
    name = "pr_bridge_radial",
    description = "Menu radial",
    defaultMapper = "keyboard",
    defaultKey = GetConvar("pr_bridge:radial:defaultKey", "F1"),
    onPressed = toggleRadial,
})
if not radialKeybind then
    print(("^1[pr_bridge:radial] Falha ao registrar keybind: %s^0"):format(tostring(radialKeybindError)))
else
    print("^2[pr_bridge:radial] Keybind '(pr_bridge) Menu radial' registrado.^0")
end

RegisterNUICallback("radial:close", function(_, cb) cb(1); hideRadial() end)
RegisterNUICallback("radial:back", function(_, cb)
    cb(1)
    local previous = table.remove(radial.history)
    if previous then return showRadial(previous.resource, previous.menuId) end
    hideRadial()
end)
RegisterNUICallback("radial:select", function(data, cb)
    cb(1)
    local current = radial.current
    local item = current and current.items[tonumber(data and data.index)]
    if not item then return end
    local itemResource = item.resource or current.resource
    if item.menu then
        radial.history[#radial.history + 1] = { resource = current.resource, menuId = current.menuId }
        showRadial(itemResource, item.menu)
        TriggerEvent("pr_bridge:radial:select", itemResource, current.menuId, item.id, tonumber(data.index))
        return
    end

    local selectedMenuId = current.menuId
    local selectedItemId = item.id
    local selectedIndex = tonumber(data.index)
    if item.keepOpen then
        TriggerEvent("pr_bridge:radial:select", itemResource, selectedMenuId, selectedItemId, selectedIndex)
        return
    end

    hideRadial()
    SetTimeout(280, function()
        TriggerEvent("pr_bridge:radial:select", itemResource, selectedMenuId, selectedItemId, selectedIndex)
    end)
end)

CreateThread(function()
    applyUiInterface()
    applyGlobalConfig(Bridge.settings.get("interface"))
end)

Bridge.cache.OnResourceState("pr_bridge", "interface", function(value)
    applyGlobalConfig(value)
end)

local NativeUI = PRCore.load("@pr_bridge/interface/client/ui", _ENV)

RegisterNUICallback("ui:ready", function(_, cb)
    cb(1)
    applyUiInterface()
    applyGlobalConfig(Bridge.settings.get("interface"))
    -- World overlays suppress duplicate packets. Rehydrate them when the NUI
    -- mounts again instead of depending on constant per-frame resends.
    TriggerEvent("pr_bridge:ui:ready")
    if NativeUI and NativeUI.modules and NativeUI.modules.textui then
        NativeUI.modules.textui.Refresh()
    end
end)

Bridge.debug.info("[pr_interface] NUI host pronto.")
