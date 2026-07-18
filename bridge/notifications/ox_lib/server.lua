local notifications = {}

if ActiveBridges["notification"] ~= "ox_lib" then return end

Debug('SUCCESS', Lang:t('Debug.NotificationDetected', { notification = 'Ox Lib Notification' }))

---Send notification to player
---@param src number
---@param data NotificationData
function notifications.Notify(src, data)
    TriggerClientEvent('ox_lib:notify', src, data)
end

return notifications
