local phone = {}

if ActiveBridges["phone"] ~= "lb_phone" then return end

Debug('SUCCESS', Lang:t('Debug.PhoneDetected', { phone = 'LB-Phone' }))


---Get a list of all available phone names in the system.
---@return table
function phone.GetPhoneNames()
    -- LB-Phone uses variations, but doesn't have a direct 'getPhoneNames' list like Quasar.
    -- Returning an empty table as it's not directly supported in the documented exports.
    return {}
end

---Retrieve a player's phone number based on their identifier or source.
---@param source number | string
---@param mustBePhoneOwner? boolean (Not used in LB-Phone GetEquippedPhoneNumber)
---@return string?
function phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)
    return exports["lb-phone"]:GetEquippedPhoneNumber(source)
end

---Retrieve a player's phone settings from their phone number.
---@param phoneNumber string
---@return table?
function phone.GetMetaFromSource(phoneNumber)
    -- In LB-Phone, metadata/settings are retrieved by phone number on server side.
    if type(phoneNumber) == "number" then
        phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(phoneNumber)
    end
    return exports["lb-phone"]:GetSettings(phoneNumber)
end

---Send an SOS message (Emergency Alert) to a player.
---@param source number
---@param job string (Not used directly in LB-Phone EmergencyNotification)
---@param coords table (Not used directly in LB-Phone EmergencyNotification)
---@param messageType string (Not used directly in LB-Phone EmergencyNotification)
function phone.SendSOSMessage(source, job, coords, messageType)
    exports["lb-phone"]:EmergencyNotification(source, {
        title = "Emergency Alert",
        content = "Emergency request from " .. job,
        icon = "warning"
    })
end

---Send a notification (similar to app message) to a player.
---@param target string | number # source or phone number
---@param phoneNumber string
---@param message string
---@param appName string
function phone.SendNewMessageFromApp(target, phoneNumber, message, appName)
    exports["lb-phone"]:SendNotification(target, {
        app = appName,
        title = appName,
        content = message
    })
end

---Check if a player has an email address (effectively if they have an account).
---@param phoneNumber string
---@return boolean
function phone.HasEmailAccount(phoneNumber)
    local email = exports["lb-phone"]:GetEmailAddress(phoneNumber)
    return email ~= nil
end

---LB-Phone doesn't have a direct 'JobDuty' export like Quasar in the provided docs.
function phone.SetInJobDuty(source)
end

function phone.RemoveFromJobDuty(source)
end

function phone.IsInJobDuty(source)
    return false
end

return phone
