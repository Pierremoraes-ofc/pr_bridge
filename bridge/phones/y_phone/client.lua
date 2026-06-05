local phone = {}

if ActiveBridges["phone"] ~= "y_phone" then return end

function phone.InPhone()
    return exports.yseries:IsOpen()
end

function phone.SetCanOpenPhone(bool)
    exports.yseries:ToggleDisabled(not bool)
end

function phone.ClosePhone()
    exports.yseries:ToggleOpen(false)
end

function phone.IsInCamera()
    -- y-phone uses a system of signal towers and specific apps, 
    -- no direct "isInCamera" export for generic check in docs.
    return false
end

function phone.CreateCall(name, number, image, anonymous)
    exports.yseries:CreateCall(number, { anonymous = anonymous })
end

function phone.GetCall()
    local inCall, callId = exports.yseries:IsInCall()
    return { InCall = inCall, CallId = callId }
end

function phone.EndCall()
    exports.yseries:CancelCall()
end

function phone.IsInCall()
    local inCall = exports.yseries:IsInCall()
    return inCall
end

function phone.SetSOS(bool)
    -- y-phone uses SendCompanyMessage for dispatch/SOS style.
end

-- Events
-- y-phone triggers yseries:client:phone:service-changed or can be tracked via IsOpen.
-- We'll use a thread or simple check if needed, but usually scripts handle this via ToggleOpen.
-- The documentation doesn't specify a "closed" event clearly besides the UI toggle.

return phone
