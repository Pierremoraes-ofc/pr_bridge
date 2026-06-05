local phone = {}

if ActiveBridges["phone"] ~= "lb_phone" then return end

function phone.InPhone()
    return exports["lb-phone"]:IsOpen()
end

function phone.SetCanOpenPhone(bool)
    exports["lb-phone"]:ToggleDisabled(not bool)
end

function phone.ClosePhone()
    exports["lb-phone"]:ToggleOpen(false)
end

function phone.IsInCamera()
    return exports["lb-phone"]:IsWalkingCamEnabled() or exports["lb-phone"]:IsSelfieCam()
end

function phone.CreateCall(name, number, image, anonymous)
    exports["lb-phone"]:CreateCall({
        number = number,
        hideNumber = anonymous
    })
end

function phone.GetCall()
    -- lb-phone documentation doesn't show a direct 'getCall' export, but 'IsInCall' is available.
    return { InCall = exports["lb-phone"]:IsInCall() }
end

function phone.EndCall()
    -- lb-phone documentation doesn't show a direct 'endCall' export that is generic, 
    -- but they have EndCustomCall. For standard calls, it's usually handled by the UI.
    -- We'll try to use what's available or leave as empty if not supported.
    if exports["lb-phone"]:IsInCall() then
        -- No direct 'endCall' for standard calls in documentation snippet, 
        -- but many scripts use ToggleOpen(false) to force close.
    end
end

function phone.IsInCall()
    return exports["lb-phone"]:IsInCall()
end

function phone.SetSOS(bool)
    -- lb-phone handles services differently (SendCompanyMessage/SendCompanyCoords).
end

-- Events
RegisterNetEvent("lb-phone:phoneToggled", function(open)
    if not open then
        TriggerEvent('bridge:phone:handleClosePhone', {})
    end
end)

return phone
