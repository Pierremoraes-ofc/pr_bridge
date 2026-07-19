---NUI host — só no pr_bridge (dono do ui_page).

local ownerResource = nil
local focusCount = 0

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

RegisterNUICallback("context:select", function(data, cb)
    cb(1)
    if ownerResource and type(data) == "table" then
        TriggerEvent("pr_bridge:ui:context:select", ownerResource, data.id, tonumber(data.index))
    end
end)

RegisterNUICallback("context:close", function(_, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:context:close", ownerResource)
    end
end)

RegisterNUICallback("context:back", function(_, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:context:back", ownerResource)
    end
end)

RegisterNUICallback("alert:result", function(data, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:alert:result", ownerResource, data and data.result or "cancel")
    end
end)

RegisterNUICallback("alert:close", function(_, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:alert:close", ownerResource)
    end
end)

RegisterNUICallback("input:submit", function(data, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:input:submit", ownerResource, data and data.values or nil)
    end
end)

RegisterNUICallback("input:close", function(_, cb)
    cb(1)
    if ownerResource then
        TriggerEvent("pr_bridge:ui:input:close", ownerResource)
    end
end)

Bridge.debug.info("[pr_interface] NUI host pronto.")
