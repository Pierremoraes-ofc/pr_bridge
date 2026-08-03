---TextUI module.
---@param Renderer table
return function(Renderer)
    local visible = false
    local current = nil

    local TextUI = {}

    ---@param text string
    ---@param options table|nil
    function TextUI.ShowTextUI(text, options)
        options = options or {}
        if SetNuiZIndex then SetNuiZIndex(1000) end
        visible = true

        current = {
            text = text or "",
            position = options.position or "right-center",
            icon = options.icon,
            iconColor = options.iconColor,
            style = options.style,
            debug = options.debug == true,
        }

        Renderer.send("textui:show", current)

        return true
    end

    function TextUI.HideTextUI()
        if not visible then
            return false
        end

        visible = false
        current = nil
        Renderer.send("textui:hide")
        return true
    end

    function TextUI.Refresh()
        if not visible or not current then return false end
        Renderer.send("textui:show", current)
        return true
    end

    ---@return boolean
    function TextUI.IsTextUIOpen()
        return visible
    end

    return TextUI
end
