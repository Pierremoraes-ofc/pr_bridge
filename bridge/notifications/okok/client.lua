local notifications={}
function notifications.GetResourceName() return "okokNotify" end
function notifications.Notify(data)
 data=type(data)=='table' and data or {description=tostring(data)}
 local message=data.description or data.title or ''
 local kind=data.type or 'info'
 local duration=data.duration or 5000
 exports['okokNotify']:Alert(data.title or '', message, duration, kind)
 return true
end
return notifications
