return function()
    local Radial = {}
    local resourceName = GetCurrentResourceName()
    local callbacks = {}

    local function normalize(items)
        if type(items) == "table" and items.id then items = { items } end
        local output = {}
        for i = 1, #(items or {}) do
            local item = items[i]
            if type(item) == "table" and type(item.id) == "string" and type(item.label) == "string" then
                output[#output + 1] = { id = item.id, label = item.label, icon = item.icon, iconWidth = item.iconWidth, iconHeight = item.iconHeight, menu = item.menu, keepOpen = item.keepOpen == true }
                callbacks[item.id] = item.onSelect
            end
        end
        return output
    end

    function Radial.AddRadialItem(items, parentMenuId)
        TriggerEvent("pr_bridge:radial:add", resourceName, normalize(items), parentMenuId)
    end
    function Radial.RemoveRadialItem(id, parentMenuId)
        callbacks[id] = nil
        TriggerEvent("pr_bridge:radial:remove", resourceName, id, parentMenuId)
    end
    function Radial.ClearRadialItems()
        callbacks = {}
        TriggerEvent("pr_bridge:radial:clear", resourceName)
    end
    function Radial.RegisterRadial(data)
        if type(data) ~= "table" or type(data.id) ~= "string" then return false end
        TriggerEvent("pr_bridge:radial:register", resourceName, { id = data.id, items = normalize(data.items) })
        return true
    end
    function Radial.HideRadial() TriggerEvent("pr_bridge:radial:hide") end
    function Radial.DisableRadial(state) TriggerEvent("pr_bridge:radial:disable", state == true) end
    function Radial.GetCurrentRadialId() return LocalPlayer.state.pr_bridge_radial_current end

    AddEventHandler("pr_bridge:radial:select", function(target, menuId, itemId, index)
        if target ~= resourceName then return end
        local callback = callbacks[itemId]
        if type(callback) == "function" then callback(menuId, index)
        elseif type(callback) == "string" then TriggerEvent(callback, menuId, index) end
    end)
    return Radial
end