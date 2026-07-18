local phone = {}

if ActiveBridges["phone"] ~= "y_phone" then return end

Debug('SUCCESS', Lang:t('Debug.PhoneDetected', { phone = 'Y-Phone' }))

---Get a list of all available phone names in the system.
---@return table
function phone.GetPhoneNames()
    return {}
end

---Retrieve a player's phone number based on their source.
---@param source number
---@param mustBePhoneOwner? boolean
---@return string?
function phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)
    -- y-phone (yseries) documentation doesn't explicitly show GetPhoneNumberFromSource 
    -- in the provided snippet, but it's a common export.
    -- We will attempt to use it if it exists, otherwise return nil.
    if exports.yseries.GetEquippedPhoneNumber then
        return exports.yseries:GetEquippedPhoneNumber(source)
    end
    return nil
end

---Retrieve a player's phone metadata (Screen Damage for y-phone).
---@param source number
---@return table | boolean
function phone.GetMetaFromSource(source)
    -- For y-phone, we can return screen damage as "metadata"
    local imei = nil -- We'd need the IMEI here.
    if exports.yseries.GetEquippedPhoneNumber then
        local phoneNumber = exports.yseries:GetEquippedPhoneNumber(source)
        -- This is a bit complex without a direct IMEI getter from source on server.
    end
    return false
end

---Send an SOS message (Cell Broadcast or Notification).
---@param source number
---@param job string
---@param coords table
---@param messageType string
function phone.SendSOSMessage(source, job, coords, messageType)
    exports.yseries:SendNotification({
        app = 'emergency',
        title = "Emergency: " .. job,
        text = "Location: " .. json.encode(coords),
        timeout = 5000,
        icon = 'warning'
    }, 'source', source)
end

---Send a notification (App Message) to a player.
---@param target string | number # source or phone number or IMEI
---@param phoneNumber string
---@param message string
---@param appName string
function phone.SendNewMessageFromApp(target, phoneNumber, message, appName)
    local toType = 'source'
    if type(target) == 'string' then
        toType = 'phoneNumber'
    end

    exports.yseries:SendNotification({
        app = appName,
        title = appName,
        text = message,
        timeout = 3000
    }, toType, target)
end

---Check if a player has an email account.
---@param source number
---@return boolean
function phone.HasEmailAccount(source)
    -- No direct check in docs, but usually linked to having a phone.
    return false
end

---y-phone doesn't have a direct 'JobDuty' export like Quasar.
function phone.SetInJobDuty(source)
end

function phone.RemoveFromJobDuty(source)
end

function phone.IsInJobDuty(source)
    return false
end

return phone
