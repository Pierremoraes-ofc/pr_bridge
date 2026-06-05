local phone = {}

function phone.InPhone()
    return false
end

function phone.SetCanOpenPhone(bool)
end

function phone.ClosePhone()
end

function phone.IsInCamera()
    return false
end

function phone.CreateCall(name, number, image, anonymous)
end

function phone.GetCall()
    return nil
end

function phone.EndCall()
end

function phone.IsInCall()
    return false
end

function phone.SetSOS(bool)
end

return phone
