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
