-- Native list menu. Unlike a context-menu conversion, this preserves ox_lib
-- side-scroll, checkbox and selected-index callback contracts.
return function(Renderer)
    local menus, active = {}, nil
    local Menu = {}
    local function serialise(value)
        if type(value) == "function" or type(value) == "thread" or type(value) == "userdata" then return nil end
        if type(value) ~= "table" then return value end
        local copy = {}
        for k, v in pairs(value) do copy[k] = serialise(v) end
        return copy
    end
    function Menu.registerMenu(data, callback)
        assert(type(data) == "table" and data.id and data.title and data.options, "Menu id, title and options are required")
        menus[data.id] = { data = data, callback = callback }
    end
    function Menu.showMenu(id, startIndex)
        local menu = assert(menus[id], "Unknown menu: " .. tostring(id))
        assert(#menu.data.options > 0, "Cannot open an empty menu")
        local alreadyOpen = active ~= nil
        active = menu
        if Renderer.menuFocus then Renderer.menuFocus(not menu.data.disableInput, alreadyOpen)
        elseif alreadyOpen then Renderer.ensureFocus(not menu.data.disableInput)
        else Renderer.setFocus(not menu.data.disableInput) end
        if not alreadyOpen then
            CreateThread(function()
                while active do
                    if active.data.disableInput == nil or active.data.disableInput then
                        DisablePlayerFiring(PlayerId(), true)
                        HudWeaponWheelIgnoreSelection()
                        DisableControlAction(0, 140, true)
                    end
                    Wait(0)
                end
            end)
        end
        Renderer.send("menu:open", {
            id = id, title = menu.data.title, options = serialise(menu.data.options),
            position = menu.data.position or "top-left", canClose = menu.data.canClose,
            startIndex = math.max(1, math.min(#menu.data.options, tonumber(startIndex) or 1)),
        })
    end
    function Menu.hideMenu(onExit, key)
        if not active then return end
        local previous = active
        active = nil
        Renderer.send("menu:close")
        Renderer.clearFocus()
        if onExit and previous.data.onClose then previous.data.onClose(key) end
    end
    function Menu.getOpenMenu() return active and active.data.id end
    function Menu.setMenuOptions(id, options, index)
        local menu = assert(menus[id], "Unknown menu: " .. tostring(id))
        if index then menu.data.options[index] = options
        else
            assert(type(options) == "table" and options[1], "Expected an array of options")
            menu.data.options = options
        end
    end
    function Menu.Handle(action, data)
        local menu = active
        if not menu or type(data) ~= "table" or data.id ~= menu.data.id then return end
        if action == "close" then
            if menu.data.canClose ~= false then Menu.hideMenu(true, data.key) end
            return
        end
        local index = tonumber(data.selected)
        if not index or index % 1 ~= 0 then return end
        local option = menu.data.options[index]
        if not option or option.disabled or option.readOnly then return end
        local scroll = tonumber(data.scrollIndex)
        if option.values then
            if not scroll or scroll % 1 ~= 0 or not option.values[scroll] then return end
        else scroll = nil end
        local checked = type(data.checked) == "boolean" and data.checked or false
        if action == "selected" and menu.data.onSelected then
            assert(option.args == nil or type(option.args) == "table", "Menu args must be a table")
            local args = {}
            for k, v in pairs(option.args or {}) do args[k] = v end
            if option.values then args.isScroll = true
            elseif option.checked ~= nil then args.isCheck = true end
            local value
            if option.values then value = scroll elseif option.checked ~= nil then value = checked end
            menu.data.onSelected(index, value, args)
        elseif action == "side" and menu.data.onSideScroll and option.values then
            menu.data.onSideScroll(index, scroll, option.args)
        elseif action == "check" and menu.data.onCheck and option.checked ~= nil then
            menu.data.onCheck(index, checked, option.args)
        elseif action == "confirm" then
            if option.close ~= false then Menu.hideMenu(false) end
            if menu.callback then menu.callback(index, scroll, option.args, data.checked) end
        end
    end
    return Menu
end
