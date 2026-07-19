---TextUI module.
---@param Renderer table
return function(Renderer)
    local visible = false

    local TextUI = {}

    ---@param text string
    ---@param options table|nil
    function TextUI.ShowTextUI(text, options)
        options = options or {}
        visible = true

        Renderer.send("textui:show", {
            text = text or "",
            position = options.position or "right-center",
            icon = options.icon,
            iconColor = options.iconColor,
            style = options.style,
        })

        return true
    end

    function TextUI.HideTextUI()
        if not visible then
            return false
        end

        visible = false
        Renderer.send("textui:hide")
        return true
    end

    ---@return boolean
    function TextUI.IsTextUIOpen()
        return visible
    end

    return TextUI
end
