local phone = {}

if ActiveBridges["phone"] ~= "okok_phone" then return end

Debug('SUCCESS', Lang:t('Debug.PhoneDetected', { phone = 'Okok Phone' }))

---Get a list of all available phone names in the system.
---@return table
function phone.GetPhoneNames()
    -- okokPhone doesn't have a direct 'getPhoneNames' list export.
    return {}
end

---Retrieve a player's phone number based on their source.
---@param source number
---@param mustBePhoneOwner? boolean (Not used in okokPhone getPhoneNumberFromSource)
---@return string?
function phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)
    if type(source) == "string" then
        -- if identifier is passed, okokPhone usually uses source for exports.
        -- Assuming source is needed for the provided server exports.
        return nil
    end
    return exports['okokPhone']:getPhoneNumberFromSource(source)
end

---Retrieve a player's phone metadata from their source ID.
---@param source number
---@return table | boolean
function phone.GetMetaFromSource(source)
    local imei = exports['okokPhone']:getImeiFromSource(source)
    if not imei then return false end
    return exports['okokPhone']:getPhoneDataFromImei(imei)
end

---Emergency Dispatch Notification.
---@param source number
---@param job string (Not used in okokPhone emergencyNotify)
---@param coords table
---@param messageType string (Not used in okokPhone emergencyNotify)
function phone.SendSOSMessage(source, job, coords, messageType)
    exports["okokPhone"]:emergencyNotify(source, coords)
end

---Send a push notification to a player's phone number.
---@param source number
---@param phoneNumber string
---@param message string
---@param appName string
function phone.SendNewMessageFromApp(source, phoneNumber, message, appName)
    exports["okokPhone"]:pushNotifyViaPhoneNumber(phoneNumber, {
        app = appName,
        title = appName,
        message = message,
        type = "normal"
    })
end

---Check if a player has an email address (effectively if they have an account).
---@param source number
---@return boolean
function phone.HasEmailAccount(source)
    local email = exports['okokPhone']:getEmailAddressFromSource(source)
    return email ~= nil
end

---okokPhone doesn't have a direct 'JobDuty' export like Quasar.
function phone.SetInJobDuty(source)
end

function phone.RemoveFromJobDuty(source)
end

function phone.IsInJobDuty(source)
    return false
end

return phone
