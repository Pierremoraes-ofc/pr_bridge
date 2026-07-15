local notifications={}
function notifications.GetResourceName() return "mythic_notify" end
function notifications.Notify(data)
 data=type(data)=='table' and data or {description=tostring(data)}
 local message=data.description or data.title or ''
 local kind=data.type or 'info'
 local duration=data.duration or 5000
 exports['mythic_notify']:DoCustomHudText(kind == 'info' and 'inform' or kind, message, duration)
 return true
end
return notifications
