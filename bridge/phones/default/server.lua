local phone = {}

local function getForgePhoneResource()
    if GetResourceState('forge-phone'):find('start') then return 'forge-phone' end
    if GetResourceState('npwd'):find('start') then return 'npwd' end
end

function phone.GetActiveContext(source)
    source = tonumber(source)
    if not source or source <= 0 then return nil end
    local resource = getForgePhoneResource()
    if not resource then return nil end
    local ok, context = pcall(function()
        return exports[resource]:getActivePhoneContext(source)
    end)
    return ok and type(context) == 'table' and context or nil
end

function phone.GetActiveOwnerIdentifier(source)
    local context = phone.GetActiveContext(source)
    return context and context.ownerIdentifier or nil
end

function phone.GetActiveDeviceId(source)
    local context = phone.GetActiveContext(source)
    return context and context.deviceId or nil
end

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
