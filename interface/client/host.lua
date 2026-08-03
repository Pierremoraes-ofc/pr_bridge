---NUI host — só no pr_bridge (dono do ui_page).

local ownerResource = nil
local focusCount = 0
local textuiDebugEnabled = false

local function getUiInterface()
    local value = Config and Config.ui_interface or "svelte"

    if type(value) ~= "string" then
        return "svelte"
    end

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
        data = {
            interface = getUiInterface(),
        },
    })
end

local function applyGlobalConfig(config)
    if type(config) ~= "table" then return end
    SendNUIMessage({
        action = "theme:apply",
        data = config,
    })
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
    if type(resourceName) == "string" and resourceName ~= "" then
        ownerResource = resourceName
    end
end)

AddEventHandler("pr_bridge:ui:send", function(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end)

AddEventHandler("pr_bridge:ui:setFocus", function(keepInput)
    setFocus(keepInput == true)
end)

AddEventHandler("pr_bridge:ui:clearFocus", function()
    clearFocus()
end)

AddEventHandler("pr_bridge:ui:resetFocus", function()
    resetFocus()
end)

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

RegisterNUICallback("context:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:context:close", resource)
    end
end)

RegisterNUICallback("context:back", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:context:back", resource)
    end
end)

RegisterNUICallback("alert:result", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:alert:result", resource, data and data.result or "cancel")
    end
end)

RegisterNUICallback("alert:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:alert:close", resource)
    end
end)

RegisterNUICallback("input:submit", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:input:submit", resource, data and data.values or nil)
    end
end)

RegisterNUICallback("input:close", function(data, cb)
    cb(1)
    local resource = payloadOwner(data)
    if resource then
        TriggerEvent("pr_bridge:ui:input:close", resource)
    end
end)

local radial = { items = {}, menus = {}, current = nil, history = {}, disabled = false, open = false }

local function radialItems(resource, menuId)
    if menuId then
        local menu = radial.menus[resource .. ":" .. menuId]
        return menu and menu.items or {}
    end
    return radial.items
end

local function showRadial(resource, menuId)
    if radial.disabled then return end
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

AddEventHandler("pr_bridge:radial:add", function(resource, items, parentMenuId)
    local target = radialItems(resource, parentMenuId)
    for i = 1, #(items or {}) do
        items[i].resource = resource
        target[#target + 1] = items[i]
    end
end)
AddEventHandler("pr_bridge:radial:register", function(resource, menu)
    radial.menus[resource .. ":" .. menu.id] = menu
end)
AddEventHandler("pr_bridge:radial:remove", function(resource, id, parentMenuId)
    local target = radialItems(resource, parentMenuId)
    for i = #target, 1, -1 do if target[i].id == id then table.remove(target, i) end end
end)
AddEventHandler("pr_bridge:radial:clear", function()
    radial.items = {}; radial.menus = {}; hideRadial()
end)
AddEventHandler("pr_bridge:radial:hide", hideRadial)
AddEventHandler("pr_bridge:radial:disable", function(state) radial.disabled = state; if state then hideRadial() end end)

local function toggleRadial()
    if radial.open then hideRadial() else showRadial(GetCurrentResourceName(), nil) end
end

RegisterCommand("prradial", toggleRadial, false)
CreateThread(function()
    while true do
        Wait(0)
        if not radial.open and IsControlJustReleased(0, 288) then
            toggleRadial()
        end
    end
end)

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
        return
    end
    local selectedMenuId = current.menuId
    local selectedItemId = item.id
    local selectedIndex = tonumber(data.index)

    if item.keepOpen then
        TriggerEvent("pr_bridge:radial:select", itemResource, selectedMenuId, selectedItemId, selectedIndex)
        return
    end

    -- Libera o foco do radial antes do callback abrir outra interface.
    -- Assim o fechamento do radial nao remove o foco adquirido pelo registerContext.
    hideRadial()
    SetTimeout(280, function()
        TriggerEvent("pr_bridge:radial:select", itemResource, selectedMenuId, selectedItemId, selectedIndex)
    end)
end)
CreateThread(function()
    applyUiInterface()

    while type(GlobalState.pr_bridge_ui_config) ~= "table" do Wait(100) end
    applyGlobalConfig(GlobalState.pr_bridge_ui_config)
end)

AddStateBagChangeHandler("pr_bridge_ui_config", "global", function(_, _, value)
    applyGlobalConfig(value)
end)

local NativeUI = PRCore.load("@pr_bridge/interface/client/ui", _ENV)

RegisterNUICallback("ui:ready", function(_, cb)
    cb(1)
    if NativeUI and NativeUI.modules and NativeUI.modules.textui then
        NativeUI.modules.textui.Refresh()
    end
end)

Bridge.debug.info("[pr_interface] NUI host pronto.")
