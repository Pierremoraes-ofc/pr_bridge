local phone = {}

if ActiveBridges["phone"] ~= "qs_smartphone" then return end

Debug('SUCCESS', Lang:t('Debug.PhoneDetected', { phone = 'QS Smartphone Pro' }))

---Get a list of all available phone names in the system.
---@return table
function phone.GetPhoneNames()
    return exports['qs-smartphone-pro']:getPhoneNames()
end

---Retrieve a player's phone number based on their identifier.
---@param identifier string
---@param mustBePhoneOwner boolean
---@return string | boolean
function phone.GetPhoneNumberFromIdentifier(identifier, mustBePhoneOwner)
    return exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(identifier, mustBePhoneOwner)
end

---Retrieve a player's phone metadata from their source ID.
---@param source number
---@return table | boolean
function phone.GetMetaFromSource(source)
    return exports['qs-smartphone-pro']:getMetaFromSource(source)
end

---Send an SOS message to a specified job.
---@param phoneNumber string
---@param job string
---@param coords table | string (JSON encoded)
---@param messageType string ('location' for location-based SOS)
function phone.SendSOSMessage(phoneNumber, job, coords, messageType)
    if type(coords) == "table" then
        coords = json.encode(coords)
    end
    exports['qs-smartphone-pro']:sendSOSMessage(phoneNumber, job, coords, messageType)
end

---Send a new message from an app to a player's phone.
---@param source number
---@param phoneNumber string
---@param message string
---@param appName string
function phone.SendNewMessageFromApp(source, phoneNumber, message, appName)
    exports['qs-smartphone-pro']:sendNewMessageFromApp(source, phoneNumber, message, appName)
end

---Check if a player is logged into the Mail app.
---@param source number
---@return boolean
function phone.HasEmailAccount(source)
    return exports['qs-smartphone-pro']:hasEmailAccount(source)
end

---Register a player as available for their current job.
---@param source number
function phone.SetInJobDuty(source)
    exports['qs-smartphone-pro']:setInJobDuty(source)
end

---Remove a player from their job duty status.
---@param source number
function phone.RemoveFromJobDuty(source)
    exports['qs-smartphone-pro']:removeFromJobDuty(source)
end

---Check if a player is currently registered as on duty for their job.
---@param source number
---@return boolean
function phone.IsInJobDuty(source)
    return exports['qs-smartphone-pro']:isInJobDuty(source)
end

return phone
