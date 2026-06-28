local notifications={}
function notifications.GetResourceName() return "17mov_Hud" end
function notifications.Notify(data)
 data=type(data)=='table' and data or {description=tostring(data)}
 local message=data.description or data.title or ''
 local kind=data.type or 'info'
 local duration=data.duration or 5000
 exports['17mov_Hud']:ShowNotification(message, kind == 'warning' and 'error' or kind, data.title or '', duration)
 return true
end
return notifications
