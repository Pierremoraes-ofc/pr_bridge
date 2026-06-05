local phone = {}

if ActiveBridges["phone"] ~= "okok_phone" then return end

function phone.InPhone()
    return LocalPlayer.state['okokPhone:isOpen']
end

function phone.SetCanOpenPhone(bool)
    LocalPlayer.state:set("okokPhone:isDisable", not bool, true)
end

function phone.ClosePhone()
    exports['okokPhone']:closePhone()
end

function phone.IsInCamera()
    -- okokPhone doesn't have a direct 'isInCamera' export in docs, 
    -- but usually it's handled via internal state or camera app.
    return false 
end

function phone.CreateCall(name, number, image, anonymous)
    -- name and image are not used in okokPhone:createCall export
    exports['okokPhone']:createCall(number)
end

function phone.GetCall()
    return { InCall = exports['okokPhone']:isInCall() }
end

function phone.EndCall()
    exports['okokPhone']:endCall()
end

function phone.IsInCall()
    return exports['okokPhone']:isInCall()
end

function phone.SetSOS(bool)
    -- okokPhone has its own emergency notify system on server side
end

-- Events
-- okokPhone uses state bags for many things, but we can hook into close if needed.
-- Since it uses 'okokPhone:isOpen' state bag, we can watch it.
AddStateBagChangeHandler('okokPhone:isOpen', nil, function(bagName, key, value, _unused, replicated)
    if not value then
        TriggerEvent('bridge:phone:handleClosePhone', {})
    end
end)

return phone
