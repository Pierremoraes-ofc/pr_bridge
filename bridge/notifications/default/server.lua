local notifications = {}

function notifications.Notify(source, data)
    if type(source) ~= "number" or source <= 0 or type(data) ~= "table" then return false end
    TriggerClientEvent("bridge:notify", source, data)
    return true
end

function notifications.NotifyPlayer(source, data)
    return notifications.Notify(source, data)
end

function notifications.NotifyAll(data)
    if type(data) ~= "table" then return false end
    TriggerClientEvent("bridge:notify", -1, data)
    return true
end

return notifications