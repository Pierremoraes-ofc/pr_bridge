---Notify module (native UI notifications).
---@param Renderer table
return function(Renderer)
    local Notify = {}
    local nextId = 0

    ---@class NotifyData
    ---@field id? string|number
    ---@field title? string
    ---@field description? string
    ---@field type? string
    ---@field duration? number
    ---@field position? string
    ---@field icon? string
    ---@field iconColor? string
    ---@field showDuration? boolean

    ---@param data NotifyData|string
    function Notify.Notify(data)
        if type(data) == "string" then
            data = { description = data }
        end

        if type(data) ~= "table" then
            return false
        end

        nextId = nextId + 1

        Renderer.send("notify:push", {
            id = data.id or ("pr_notify_" .. nextId),
            title = data.title,
            description = data.description or "",
            type = data.type or "info",
            duration = data.duration or 5000,
            position = data.position or "top-right",
            icon = data.icon,
            iconColor = data.iconColor,
            showDuration = data.showDuration,
        })

        return true
    end

    return Notify
end
