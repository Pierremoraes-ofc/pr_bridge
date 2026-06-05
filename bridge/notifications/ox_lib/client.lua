local notifications = {}

if ActiveBridges["notification"] ~= "ox_lib" then return end

--- Notification
---@param data NotificationData
function notifications.Notify(data)
    TriggerEvent("ox_lib:notify", data)
end

return notifications
