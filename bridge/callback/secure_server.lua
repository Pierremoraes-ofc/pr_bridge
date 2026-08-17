local callback = {}
local pending, pendingBySource, registered = {}, {}, {}
local sequence, pendingCount = 0, 0
local resourceName = GetCurrentResourceName()
local responseEvent = ("pr_bridge:callback:response:%s"):format(resourceName)
local defaultTimeout = math.max(1000, GetConvarInt("pr_bridge:callback:timeout", 10000))
local maxPending = math.max(16, GetConvarInt("pr_bridge:callback:maxPending", 1024))
local maxInbound = math.max(4, GetConvarInt("pr_bridge:callback:maxInboundPerPlayer", 32))
local maxPendingPerPlayer = math.max(4, GetConvarInt("pr_bridge:callback:maxPendingPerPlayer", 64))
local inbound = {}

local stats = { sent = 0, received = 0, timedOut = 0, cancelled = 0, rejected = 0, forged = 0, errors = 0 }

local function warn(message)
    local debugApi = Bridge and Bridge.debug
    if debugApi and type(debugApi.warn) == "function" then debugApi.warn(message)
    else print(("^3[pr_bridge:callback]^0 %s"):format(message)) end
end

local function nextRequestId(target)
    local requestId
    repeat
        sequence = sequence < 2147483646 and sequence + 1 or 1
        requestId = ("%s:server:%s:%s:%s:%06d"):format(resourceName, target, GetGameTimer(), sequence, math.random(0, 999999))
    until not pending[requestId]
    return requestId
end

local function release(requestId)
    local request = pending[requestId]
    if not request then return nil end
    pending[requestId] = nil
    pendingCount = math.max(0, pendingCount - 1)
    local target = request.expectedSource
    if target then
        pendingBySource[target] = math.max(0, (pendingBySource[target] or 1) - 1)
        if pendingBySource[target] == 0 then pendingBySource[target] = nil end
    end
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

RegisterNetEvent(responseEvent, function(requestId, envelope, ...)
    local request = pending[requestId]
    if not request then return end
    if tonumber(source) ~= request.expectedSource then
        stats.forged = stats.forged + 1
        return warn(("Resposta rejeitada para '%s': source %s, esperado %s."):format(
            request.name, tostring(source), tostring(request.expectedSource)))
    end

    request = release(requestId)
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

local function send(target, name, cb, timeout, ...)
    assert(type(target) == "number" and target > 0, "callback target must be a valid player source")
    assert(type(name) == "string" and name ~= "", "callback name must be a non-empty string")
    if GetPlayerName and not GetPlayerName(target) then error(("callback target %s does not exist"):format(target), 3) end
    if pendingCount >= maxPending then
        stats.rejected = stats.rejected + 1
        error(("callback pending limit reached (%s)"):format(maxPending), 3)
    end
    if (pendingBySource[target] or 0) >= maxPendingPerPlayer then
        stats.rejected = stats.rejected + 1
        error(("callback pending limit reached for player %s (%s)"):format(target, maxPendingPerPlayer), 3)
    end

    local requestId = nextRequestId(target)
    local duration = math.max(1, tonumber(timeout) or defaultTimeout)
    pending[requestId] = {
        callback = type(cb) == "function" and cb or function() end,
        expectedSource = target,
        name = name,
        createdAt = GetGameTimer(),
        expiresAt = GetGameTimer() + duration,
    }
    pendingCount, stats.sent = pendingCount + 1, stats.sent + 1
    pendingBySource[target] = (pendingBySource[target] or 0) + 1
    TriggerClientEvent(name, target, requestId, ...)

    SetTimeout(duration, function()
        local request = release(requestId)
        if not request then return end
        stats.timedOut = stats.timedOut + 1
        warn(("Callback client '%s' expirou apos %sms."):format(name, duration))
        invoke(request, nil, "timeout")
    end)
    return requestId
end

function callback.triggerClient(target, name, cb, ...)
    return send(target, name, cb, defaultTimeout, ...)
end

function callback.awaitClient(target, name, timeout, ...)
    local promiseRef = promise.new()
    send(target, name, function(...) promiseRef:resolve(table.pack(...)) end, timeout, ...)
    local result = Citizen.Await(promiseRef)
    return table.unpack(result, 1, result.n)
end

function callback.awaitOx(name, target, ...)
    return callback.awaitClient(target, name, defaultTimeout, ...)
end

function callback.callOx(name, target, cb, ...)
    if cb == false or cb == nil then return callback.awaitOx(name, target, ...) end
    assert(type(cb) == "function", "callback must be a function")
    return callback.triggerClient(target, name, cb, ...)
end

function callback.trigger(first, second, third, ...)
    if type(first) == "string" then
        return callback.callOx(first, second, third, ...)
    end
    return callback.triggerClient(first, second, third, ...)
end

function callback.await(first, second, ...)
    if type(first) == "string" then
        return callback.awaitOx(first, second, ...)
    end

    local args = table.pack(...)
    return callback.awaitClient(first, second, args[1], table.unpack(args, 2, args.n))
end

callback.awaitLegacy = callback.awaitClient

setmetatable(callback, {
    __call = function(_, first, second, third, ...)
        return callback.trigger(first, second, third, ...)
    end,
})

function callback.register(name, handler)
    assert(type(name) == "string" and name ~= "", "callback name must be a non-empty string")
    assert(type(handler) == "function", "callback handler must be a function")
    assert(not registered[name], ("callback '%s' is already registered"):format(name))
    registered[name] = true

    RegisterNetEvent(name, function(requestId, ...)
        local playerSource = tonumber(source)
        if not playerSource or playerSource <= 0 or type(requestId) ~= "string" or #requestId > 256 then return end
        local requester = requestId:match("^([^:]+):client:")
        if not requester then return end

        inbound[playerSource] = (inbound[playerSource] or 0) + 1
        if inbound[playerSource] > maxInbound then
            inbound[playerSource] = inbound[playerSource] - 1
            stats.rejected = stats.rejected + 1
            local envelope = { __prCallback = true, ok = false, error = "too_many_requests" }
            return TriggerClientEvent(("pr_bridge:callback:response:%s"):format(requester), playerSource,
                requestId, envelope)
        end

        local args = table.pack(...)
        CreateThread(function()
            local result = table.pack(pcall(handler, playerSource, table.unpack(args, 1, args.n)))
            inbound[playerSource] = math.max(0, (inbound[playerSource] or 1) - 1)
            local ok = result[1]
            if not ok then stats.errors = stats.errors + 1 end
            local envelope = { __prCallback = true, ok = ok, error = ok and nil or tostring(result[2]) }
            TriggerClientEvent(("pr_bridge:callback:response:%s"):format(requester), playerSource,
                requestId, envelope, table.unpack(result, 2, result.n))
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
    local result = {
        pending = pendingCount, maxPending = maxPending, maxPendingPerPlayer = maxPendingPerPlayer,
        maxInboundPerPlayer = maxInbound, timeout = defaultTimeout,
    }
    for key, value in pairs(stats) do result[key] = value end
    return result
end

callback.ox = setmetatable({ await = callback.awaitOx }, {
    __call = function(_, name, target, cb, ...) return callback.callOx(name, target, cb, ...) end,
})

AddEventHandler("playerDropped", function()
    local playerSource = tonumber(source)
    inbound[playerSource] = nil
    local ids = {}
    for requestId, request in pairs(pending) do
        if request.expectedSource == playerSource then ids[#ids + 1] = requestId end
    end
    for i = 1, #ids do callback.cancel(ids[i], "player_dropped") end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= resourceName then return end
    local ids = {}
    for requestId in pairs(pending) do ids[#ids + 1] = requestId end
    for index = 1, #ids do callback.cancel(ids[index], "resource_stopped") end
end)

return callback
