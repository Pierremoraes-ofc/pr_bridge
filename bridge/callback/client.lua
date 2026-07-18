local callback = PRCore.callback or {}
local pending = {}
local currentRequestId = 0
local resourceName = GetCurrentResourceName()
local responseEvent = "pr_bridge:callback:response"

local function debug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function nextRequestId()
    currentRequestId = currentRequestId < 65535 and currentRequestId + 1 or 0
    return ("%s:client:%s:%s"):format(resourceName, GetGameTimer(), currentRequestId)
end

RegisterNetEvent(responseEvent, function(requestId, ...)
    local request = pending[requestId]
    if not request then return end

    pending[requestId] = nil
    request.callback(...)
end)

function callback.trigger(name, cb, ...)
    assert(type(name) == "string" and name ~= "", "callback name must be a non-empty string")

    local requestId = nextRequestId()
    pending[requestId] = {
        callback = type(cb) == "function" and cb or function() end,
    }

    TriggerServerEvent(name, requestId, ...)
    return requestId
end

function callback.await(name, timeout, ...)
    timeout = tonumber(timeout) or 10000

    local promiseRef = promise.new()
    local requestId

    requestId = callback.trigger(name, function(...)
        local result = table.pack(...)
        result.ok = true
        promiseRef:resolve(result)
    end, ...)

    SetTimeout(timeout, function()
        if pending[requestId] then
            pending[requestId] = nil
            debug("warn", ("[pr_bridge] Callback '%s' expirou apos %sms."):format(name, timeout))
            promiseRef:resolve({ ok = false, n = 2, nil, "timeout" })
        end
    end)

    local result = Citizen.Await(promiseRef)
    if not result.ok then return table.unpack(result, 1, result.n or #result) end

    return table.unpack(result, 1, result.n or #result)
end

function callback.cancel(requestId)
    pending[requestId] = nil
end

function callback.getPending()
    return pending
end

return callback
