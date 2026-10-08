-- Consumer-owned NUI: never sends to the PR Bridge menu host.
local nui, focused, stopped = {}, false, false
function nui.send(action, data)
    if stopped or type(action) ~= 'string' then return false end
    SendNUIMessage({ action = action, data = data })
    return true
end
function nui.focus(enabled, cursor, keepInput)
    if stopped then return false end
    -- A foreign resource may own focus. Do not release it when this consumer is closed.
    if enabled ~= true and not focused then return true end
    focused = enabled == true
    SetNuiFocus(focused, focused and cursor ~= false)
    SetNuiFocusKeepInput(focused and keepInput == true)
    return true
end
function nui.isFocused() return focused end
function nui.register(name, handler)
    assert(type(name) == 'string' and type(handler) == 'function', 'invalid NUI callback')
    RegisterNUICallback(name, function(data, cb)
        local answered = false
        local function reply(value)
            if answered then return end
            answered = true
            cb(value == nil and {} or value)
        end
        local ok, err = pcall(handler, data, reply)
        if not ok then
            print(('[pr_bridge:nui] %s: %s'):format(name, tostring(err)))
            reply({ ok = false, error = 'callback_failed' })
        end
    end)
end
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if focused then nui.focus(false) end
    stopped = true
end)
return nui
