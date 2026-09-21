-- Pure Lua ledger shared by optional progression consumers.
-- It does not run threads, write storage, or register network events.
PRProgression = PRProgression or {}
local P = PRProgression
local serial = 0

function P.number(value)
    value = tonumber(value)
    if not value or value ~= value or value == math.huge or value == -math.huge then return nil end
    return value
end

function P.round(value)
    return math.floor(value * 10000 + 0.5) / 10000
end

function P.copy(value)
    if type(value) ~= 'table' then return value end
    local result = {}
    for key, entry in pairs(value) do result[key] = P.copy(entry) end
    return result
end

function P.session(values, token, now)
    serial = serial + 1
    return {
        values = P.copy(values), ack = {}, budgets = {}, dirty = false, revision = 0,
        token = tostring(token) .. ':' .. serial, started = now,
    }
end

function P.change(session, name, delta, maximum)
    local previous = P.number(session.values[name]) or 0
    local value = P.round(math.max(0, math.min(maximum, previous + delta)))
    session.values[name] = value
    if value ~= previous then
        session.dirty = true
        session.revision = session.revision + 1
    end
    return P.round(value - previous)
end

function P.packet(session)
    return { token = session.token, revision = session.revision, values = P.copy(session.values), ack = P.copy(session.ack) }
end

-- Validate the whole batch before mutating anything. Cumulative counters make
-- retries idempotent and do not overwrite simultaneous server-export awards.
function P.accept(session, packet, resolve, now)
    if type(packet) ~= 'table' or packet.token ~= session.token or type(packet.counters) ~= 'table' then
        return false, 'invalid_session'
    end
    local changes, count = {}, 0
    for name, counters in pairs(packet.counters) do
        count = count + 1
        if count > 256 or type(name) ~= 'string' or type(counters) ~= 'table' then return false, 'invalid_batch' end
        local gain, loss = P.number(counters.gain), P.number(counters.loss)
        local ack = session.ack[name] or { gain = 0, loss = 0 }
        if not gain or not loss or gain < 0 or loss < 0 or gain > 1e12 or loss > 1e12 then return false, 'invalid_amount' end
        local dg, dl = math.max(0, gain - ack.gain), math.max(0, loss - ack.loss)
        if dg > 0 or dl > 0 then
            local rule = resolve(name)
            if not rule or not rule.client then return false, 'client_gain_disabled:' .. name end
            if (dg > 0 and rule.gains == false) or (dl > 0 and rule.losses == false) then return false, 'direction_disabled:' .. name end
            local rate = math.max(0, rule.rate or 0)
            local previousBudget = session.budgets[name] or { tokens = rate, time = now }
            local tokens = math.min(rate, previousBudget.tokens + math.max(0, now - previousBudget.time) * rate / 60000)
            if dg + dl > tokens + 0.0001 then return false, 'delta_limit:' .. name end
            changes[#changes + 1] = { name = name, gain = math.max(gain, ack.gain), loss = math.max(loss, ack.loss),
                delta = dg - dl, maximum = rule.maximum, tokens = math.max(0, tokens - dg - dl) }
        end
    end
    local applied = {}
    for _, change in ipairs(changes) do
        session.ack[change.name] = { gain = change.gain, loss = change.loss }
        session.budgets[change.name] = { tokens = change.tokens, time = now }
        applied[change.name] = P.change(session, change.name, change.delta, change.maximum)
    end
    -- Even a clamped change must acknowledge the counters.
    if #changes > 0 then session.revision = session.revision + 1 end
    return true, applied
end

function P.client()
    return { values = {}, counters = {}, ack = {}, revision = -1 }
end

function P.receive(client, packet, maximum)
    if type(packet) ~= 'table' or type(packet.values) ~= 'table' or type(packet.ack) ~= 'table' then return false end
    if client.token ~= packet.token then
        client.counters, client.revision = {}, -1
    end
    if (packet.revision or 0) < client.revision then return false end
    client.token, client.revision, client.ack = packet.token, packet.revision or 0, P.copy(packet.ack)
    client.values = P.copy(packet.values)
    for name, counters in pairs(client.counters) do
        local ack = client.ack[name] or { gain = 0, loss = 0 }
        local pending = math.max(0, counters.gain - ack.gain) - math.max(0, counters.loss - ack.loss)
        client.values[name] = P.round(math.max(0, math.min(maximum(name), (client.values[name] or 0) + pending)))
    end
    return true
end

function P.clientChange(client, name, delta, maximum)
    if not client.token then return false, 'not_loaded' end
    delta = P.number(delta)
    if not delta then return false, 'invalid_amount' end
    local before = client.values[name] or 0
    local value = P.round(math.max(0, math.min(maximum, before + delta)))
    local actual = P.round(value - before)
    local ack = client.ack[name] or { gain = 0, loss = 0 }
    local counters = client.counters[name] or P.copy(ack)
    counters.gain, counters.loss = math.max(counters.gain, ack.gain), math.max(counters.loss, ack.loss)
    if actual >= 0 then counters.gain = P.round(counters.gain + actual)
    else counters.loss = P.round(counters.loss - actual) end
    client.counters[name], client.values[name] = counters, value
    return true, actual
end

function P.snapshot(client)
    if not client.token then return nil end
    return { token = client.token, counters = P.copy(client.counters) }
end
