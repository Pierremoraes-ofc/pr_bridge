local notifications={}
function notifications.GetResourceName() return "codem-notification" end
function notifications.Notify(data)
 data=type(data)=='table' and data or {description=tostring(data)}
 local message=data.description or data.title or ''
 local kind=data.type or 'info'
 local duration=data.duration or 5000
 TriggerEvent('codem-notification:Create', message, kind == 'warning' and 'error' or kind, data.title, duration)
 return true
end
return notifications
