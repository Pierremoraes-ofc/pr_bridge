---@diagnostic disable: assign-type-mismatch
local notifications = {}

if ActiveBridges["notification"] ~= "qb" then return end

--- Notification
---@param data NotificationData
function notifications.Notify(data)
    -- QBX's qb-core alias can be advertised before its client exports exist.
    -- Resolve the core only for the action, never while the PR host boots.
    local QBCore = exports["qb-core"]:GetCoreObject()
    if data.type == "inform" then
        data.type = "info"
    end

    QBCore.Functions.Notify({
        text = data.description,
        caption = data.title
    }, data.type, data.duration)
end

return notifications
