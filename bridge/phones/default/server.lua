local phone = {}

function phone.GetPhoneNames()
    return {}
end

function phone.GetPhoneNumberFromIdentifier(identifier, mustBePhoneOwner)
    return false
end

function phone.GetMetaFromSource(source)
    return false
end

function phone.SendSOSMessage(phoneNumber, job, coords, messageType)
end

function phone.SendNewMessageFromApp(source, phoneNumber, message, appName)
end

function phone.HasEmailAccount(source)
    return false
end

function phone.SetInJobDuty(source)
end

function phone.RemoveFromJobDuty(source)
end

function phone.IsInJobDuty(source)
    return false
end

return phone
