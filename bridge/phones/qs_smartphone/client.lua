local phone = {}

if ActiveBridges["phone"] ~= "qs_smartphone" then return end

function phone.InPhone()
    return exports['qs-smartphone-pro']:InPhone()
end

function phone.SetCanOpenPhone(bool)
    exports['qs-smartphone-pro']:SetCanOpenPhone(bool)
end

function phone.ClosePhone()
    exports['qs-smartphone-pro']:ClosePhone()
end

function phone.IsInCamera()
    return exports['qs-smartphone-pro']:IsInCamera()
end

function phone.CreateCall(name, number, image, anonymous)
    exports['qs-smartphone-pro']:createCall(name, number, image, anonymous)
end

function phone.GetCall()
    return exports['qs-smartphone-pro']:getCall()
end

function phone.EndCall()
    exports['qs-smartphone-pro']:endCall()
end

function phone.IsInCall()
    return exports['qs-smartphone-pro']:isInCall()
end

function phone.SetSOS(bool)
    exports['qs-smartphone-pro']:setSOS(bool)
end

AddEventHandler('qs-smartphone-pro:handleClosePhone', function(meta)
    TriggerEvent('bridge:phone:handleClosePhone', meta)
end)

return phone
