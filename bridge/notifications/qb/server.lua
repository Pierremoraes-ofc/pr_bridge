local notifications = {}

if ActiveBridges["notification"] ~= "qb" then return end

Debug('SUCCESS', Lang:t('Debug.NotificationDetected', { notification = 'QBX Notification' }))

---Send notification to playerPos
---@param src number
---@param data NotificationData
function notifications.Notify(src, data)
    local duration = data.duration or 5000
    local title = data.title or ''
    local desc = data.description or ''
    local type = data.type or 'inform'

    TriggerClientEvent('QBCore:Notify', src, title .. ' ' .. desc, type, duration)
end

return notifications
