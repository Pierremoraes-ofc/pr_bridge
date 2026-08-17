local callback = {}
local pending, cooldowns, registered = {}, {}, {}
local sequence, pendingCount = 0, 0
local resourceName = GetCurrentResourceName()
local responseEvent = ("pr_bridge:callback:response:%s"):format(resourceName)
local defaultTimeout = math.max(1000, GetConvarInt("pr_bridge:callback:timeout", 10000))
local maxPending = math.max(16, GetConvarInt("pr_bridge:callback:maxPending", 1024))

local stats = { sent = 0, received = 0, timedOut = 0, cancelled = 0, rejected = 0, errors = 0 }

local function warn(message)
    local debugApi = Bridge and Bridge.debug
    if debugApi and type(debugApi.warn) == "function" then debugApi.warn(message)
    else print(("^3[pr_bridge:callback]^0 %s"):format(message)) end
end

local function nextRequestId()
    local requestId
    repeat
        sequence = sequence < 2147483646 and sequence + 1 or 1
        requestId = ("%s:client:%s:%s:%06d"):format(resourceName, GetGameTimer(), sequence, math.random(0, 999999))
    until not pending[requestId]
    return requestId
end

local function release(requestId)
    local request = pending[requestId]
    if not request then return nil end
    pending[requestId] = nil
    pendingCount = math.max(0, pendingCount - 1)
    return request
end

local function invoke(request, ...)
    local ok, err = pcall(request.callback, ...)
    if not ok then
        stats.errors = stats.errors + 1
        warn(("Callback de resposta '%s' falhou: %s"):format(request.name or "unknown", tostring(err)))
    end
    return ok
end

local function eventAllowed(name, delay)
    if type(delay) ~= "number" or delay <= 0 then return true end
    local now = GetGameTimer()
    if (cooldowns[name] or 0) > now then return false end
    cooldowns[name] = now + delay
    return true
end

RegisterNetEvent(responseEvent, function(requestId, envelope, ...)
    if source == "" then return end
    local request = release(requestId)
    if not request then return end
    stats.received = stats.received + 1

    if type(envelope) == "table" and envelope.__prCallback then
        if not envelope.ok then
            stats.errors = stats.errors + 1
            return invoke(request, nil, envelope.error or "callback_error")
        end
        return invoke(request, ...)
    end

    invoke(request, envelope, ...)
end)

local function send(name, cb, timeout, ...)
    assert(type(name) == "string" and name ~= "", "callback name must be a non-empty string")
    if pendingCount >= maxPending then
        stats.rejected = stats.rejected + 1
        error(("callback pending limit reached (%s)"):format(maxPending), 3)
    end

    local requestId = nextRequestId()
    local duration = math.max(1, tonumber(timeout) or defaultTimeout)
    pending[requestId] = {
        callback = type(cb) == "function" and cb or function() end,
        name = name,
        createdAt = GetGameTimer(),
        expiresAt = GetGameTimer() + duration,
    }
    pendingCount, stats.sent = pendingCount + 1, stats.sent + 1

    TriggerServerEvent(name, requestId, ...)
    SetTimeout(duration, function()
        local request = release(requestId)
        if not request then return end
        stats.timedOut = stats.timedOut + 1
        warn(("Callback '%s' expirou apos %sms."):format(name, duration))
        invoke(request, nil, "timeout")
    end)
    return requestId
end

function callback.trigger(name, cb, ...)
    return send(name, cb, defaultTimeout, ...)
end

function callback.await(name, timeout, ...)
    local promiseRef = promise.new()
    send(name, function(...)
        promiseRef:resolve(table.pack(...))
    end, timeout, ...)
    local result = Citizen.Await(promiseRef)
    return table.unpack(result, 1, result.n)
end

function callback.call(name, delay, cb, ...)
    if not eventAllowed(name, delay) then return false end
    if cb == false or cb == nil then return callback.await(name, defaultTimeout, ...) end
    assert(type(cb) == "function", "callback must be a function")
    return callback.trigger(name, cb, ...)
end

function callback.awaitOx(name, delay, ...)
    if not eventAllowed(name, delay) then return nil, "rate_limited" end
    return callback.await(name, defaultTimeout, ...)
end

function callback.register(name, handler)
    assert(type(name) == "string" and name ~= "", "callback name must be a non-empty string")
    assert(type(handler) == "function", "callback handler must be a function")
    assert(not registered[name], ("callback '%s' is already registered"):format(name))
    registered[name] = true

    RegisterNetEvent(name, function(requestId, ...)
        if source == "" or type(requestId) ~= "string" or #requestId > 256 then return end
        local requester = requestId:match("^([^:]+):server:")
        if not requester then return end
        local args = table.pack(...)

        CreateThread(function()
            local result = table.pack(pcall(handler, table.unpack(args, 1, args.n)))
            local ok = result[1]
            if not ok then stats.errors = stats.errors + 1 end
            local envelope = { __prCallback = true, ok = ok, error = ok and nil or tostring(result[2]) }
            TriggerServerEvent(("pr_bridge:callback:response:%s"):format(requester), requestId, envelope,
                table.unpack(result, 2, result.n))
        end)
    end)
end

function callback.cancel(requestId, reason)
    local request = release(requestId)
    if not request then return false end
    stats.cancelled = stats.cancelled + 1
    invoke(request, nil, reason or "cancelled")
    return true
end

function callback.getPending() return pending end
function callback.getStats()
    local result = { pending = pendingCount, maxPending = maxPending, timeout = defaultTimeout }
    for key, value in pairs(stats) do result[key] = value end
    return result
end

callback.ox = setmetatable({ await = callback.awaitOx }, {
    __call = function(_, name, delay, cb, ...) return callback.call(name, delay, cb, ...) end,
})

setmetatable(callback, {
    __call = function(_, name, delayOrCallback, ...)
        if type(delayOrCallback) == "function" then
            return callback.trigger(name, delayOrCallback, ...)
        end

        local args = table.pack(...)
        return callback.call(name, delayOrCallback, args[1], table.unpack(args, 2, args.n))
    end,
})

AddEventHandler("onResourceStop", function(resource)
    if resource ~= resourceName then return end
    local ids = {}
    for requestId in pairs(pending) do ids[#ids + 1] = requestId end
    for index = 1, #ids do callback.cancel(ids[index], "resource_stopped") end
end)

return callback
