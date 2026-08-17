---Notify module (native UI notifications).
---@param Renderer table
return function(Renderer)
    local Notify = {}
    local nextId = 0
    local activeIds = {}

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
        local id = data.id or ("pr_notify_" .. nextId)
        local duration = tonumber(data.duration) or 5000

        if activeIds[id] then return false end
        activeIds[id] = true
        SetTimeout(duration, function() activeIds[id] = nil end)

        Renderer.send("notify:push", {
            id = id,
            title = data.title,
            description = data.description or "",
            type = data.type or "info",
            duration = duration,
            position = data.position or "top-right",
            icon = data.icon,
            iconColor = data.iconColor,
            showDuration = data.showDuration,
        })

        return true
    end

    return Notify
end
