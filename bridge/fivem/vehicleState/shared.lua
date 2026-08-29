local isServer = IsDuplicityVersion()

local function convarNumber(name, fallback, minimum, maximum)
    local value = GetConvarInt and GetConvarInt(name, fallback) or fallback
    value = tonumber(value) or fallback
    value = math.max(minimum or value, value)
    if maximum then value = math.min(maximum, value) end
    return value
end

local limits = {
    maxKeyLength = convarNumber("pr_bridge:vehicleState:maxKeyLength", 96, 16, 256),
    maxPayloadBytes = convarNumber("pr_bridge:vehicleState:maxPayloadBytes", 8192, 256, 32768),
    waitInterval = convarNumber("pr_bridge:vehicleState:waitInterval", 50, 0, 1000),
}

local allowedValueTypes = {
    ["nil"] = true,
    boolean = true,
    number = true,
    string = true,
    table = true,
    vector2 = true,
    vector3 = true,
    vector4 = true,
    quaternion = true,
}

local function copy(source)
    local target = {}
    if type(source) == "table" then
        for key, value in pairs(source) do target[key] = value end
    end
    return target
end

local function merge(defaults, options)
    local result = copy(defaults)
    if type(options) == "table" then
        for key, value in pairs(options) do result[key] = value end
    end
    return result
end

local function encode(value)
    if value == nil then return "nil", 0 end

    if msgpack and type(msgpack.pack) == "function" then
        local ok, packed = pcall(msgpack.pack, value)
        if ok and type(packed) == "string" then return packed, #packed end
    end

    if json and type(json.encode) == "function" then
        local ok, packed = pcall(json.encode, value)
        if ok and type(packed) == "string" then return packed, #packed end
    end

    return nil, 0
end

local function makeScope(entityType, prefix)
    local channels = {}
    local writes = {}
    local watchers = {}
    local watcherSequence = 0
    local metrics = {
        reads = 0,
        writes = 0,
        unchanged = 0,
        rejected = 0,
        oversized = 0,
        rateLimited = 0,
        watcherCalls = 0,
        watcherErrors = 0,
    }

    local scope = {
        entityType = entityType,
        prefix = prefix,
        limits = limits,
    }

    local function reject(reason)
        metrics.rejected = metrics.rejected + 1
        return false, reason
    end

    local function validateEntity(entity, options)
        if type(entity) ~= "number" or entity <= 0 or not DoesEntityExist(entity) then
            return false, "invalid_entity"
        end

        if options and options.allowAnyEntity ~= true and type(GetEntityType) == "function" then
            local actualType = GetEntityType(entity)
            if actualType ~= entityType then return false, "invalid_entity_type" end
        end

        return true
    end

    local function validateChannel(channel)
        if channel == nil or channel == "" then return nil end
        if type(channel) ~= "string" or not channel:match("^[%w_%-]+$") then
            return false, "invalid_channel"
        end
        return channel
    end

    local function stateKey(channel, key, options)
        if type(key) ~= "string" or key == "" then return nil, "invalid_key" end
        if options and options.raw == true then
            if #key > limits.maxKeyLength then return nil, "key_too_long" end
            return key
        end

        local normalized, reason = validateChannel(channel)
        if normalized == false then return nil, reason end
        local fullKey = normalized and (prefix .. normalized .. ":" .. key) or (prefix .. key)
        if #fullKey > limits.maxKeyLength then return nil, "key_too_long" end
        return fullKey
    end

    local function channelOptions(channel, options)
        return merge(channels[channel or ""], options)
    end

    local function validateValue(value, options)
        if not allowedValueTypes[type(value)] then return nil, nil, "invalid_value_type" end
        local signature, bytes = encode(value)
        if not signature then return nil, nil, "value_not_serializable" end
        local maximum = tonumber(options.maxPayloadBytes) or limits.maxPayloadBytes
        maximum = math.min(math.max(1, maximum), limits.maxPayloadBytes)
        if bytes > maximum then
            metrics.oversized = metrics.oversized + 1
            return nil, bytes, "payload_too_large"
        end
        return signature, bytes
    end

    local function canReplicate(entity, options)
        if options.replicated ~= true then return true end
        if type(NetworkGetEntityIsNetworked) == "function" and not NetworkGetEntityIsNetworked(entity) then
            return false, "entity_not_networked"
        end
        if isServer then return true end
        if options.authority ~= "owner" then return false, "server_authority_required" end
        if type(NetworkHasControlOfEntity) == "function" and not NetworkHasControlOfEntity(entity) then
            return false, "network_control_required"
        end
        return true
    end

    local function prepare(entity, channel, key, value, options)
        options = channelOptions(channel, options)
        local valid, reason = validateEntity(entity, options)
        if not valid then
            local ok
            ok, reason = reject(reason)
            return nil, ok, reason
        end

        local fullKey
        fullKey, reason = stateKey(channel, key, options)
        if not fullKey then
            local ok
            ok, reason = reject(reason)
            return nil, ok, reason
        end

        local signature, bytes
        signature, bytes, reason = validateValue(value, options)
        if not signature then
            local ok
            ok, reason = reject(reason)
            return nil, ok, reason
        end

        valid, reason = canReplicate(entity, options)
        if not valid then
            local ok
            ok, reason = reject(reason)
            return nil, ok, reason
        end

        return {
            entity = entity,
            key = fullKey,
            value = value,
            signature = signature,
            bytes = bytes,
            options = options,
        }
    end

    function scope.registerChannel(name, defaults)
        local normalized, reason = validateChannel(name)
        if not normalized then return false, reason or "channel_required" end
        channels[normalized] = merge(channels[normalized], defaults)
        return true, copy(channels[normalized])
    end

    function scope.getChannel(name)
        return copy(channels[name])
    end

    function scope.getKey(channel, key, options)
        return stateKey(channel, key, channelOptions(channel, options))
    end

    function scope.get(entity, channel, key, options)
        options = channelOptions(channel, options)
        local valid, reason = validateEntity(entity, options)
        if not valid then metrics.rejected = metrics.rejected + 1 return nil, reason end
        local fullKey
        fullKey, reason = stateKey(channel, key, options)
        if not fullKey then metrics.rejected = metrics.rejected + 1 return nil, reason end
        metrics.reads = metrics.reads + 1
        return Entity(entity).state[fullKey]
    end

    function scope.set(entity, channel, key, value, options)
        local prepared, ok, reason = prepare(entity, channel, key, value, options)
        if not prepared then return ok, reason end

        local writeKey = ("%s:%s"):format(entity, prepared.key)
        local previous = writes[writeKey]
        local now = GetGameTimer()
        local minInterval = math.max(0, tonumber(prepared.options.minIntervalMs) or 0)
        if prepared.options.force ~= true and previous and previous.signature == prepared.signature then
            metrics.unchanged = metrics.unchanged + 1
            return false, "unchanged"
        end
        if prepared.options.force ~= true and previous and minInterval > 0 and now - previous.at < minInterval then
            metrics.rateLimited = metrics.rateLimited + 1
            return false, "rate_limited"
        end

        Entity(entity).state:set(prepared.key, value, prepared.options.replicated == true)
        writes[writeKey] = { signature = prepared.signature, at = now, bytes = prepared.bytes }
        metrics.writes = metrics.writes + 1
        return true, prepared.bytes
    end

    function scope.remove(entity, channel, key, options)
        return scope.set(entity, channel, key, nil, merge(options, { force = true }))
    end

    function scope.update(entity, channel, key, updater, options)
        if type(updater) ~= "function" then return reject("updater_required") end
        local current, reason = scope.get(entity, channel, key, options)
        if reason then return false, reason end
        local ok, value = pcall(updater, current)
        if not ok then return reject("updater_failed") end
        return scope.set(entity, channel, key, value, options)
    end

    function scope.setMany(entity, channel, values, options)
        if type(values) ~= "table" then return reject("values_required") end
        local prepared = {}
        for key, value in pairs(values) do
            local entry, ok, reason = prepare(entity, channel, key, value, options)
            if not entry then return ok, reason, key end
            prepared[#prepared + 1] = entry
        end
        local changed = 0
        for index = 1, #prepared do
            local entry = prepared[index]
            local ok = scope.set(entity, nil, entry.key, entry.value, merge(entry.options, { raw = true }))
            if ok then changed = changed + 1 end
        end
        return true, changed
    end

    function scope.snapshot(entity, channel, keys, options)
        if type(keys) ~= "table" then return nil, "keys_required" end
        local result = {}
        for index = 1, #keys do
            local key = keys[index]
            result[key] = scope.get(entity, channel, key, options)
        end
        return result
    end

    function scope.wait(entity, channel, key, predicate, timeout, options)
        if type(predicate) ~= "function" then
            local expected = predicate
            predicate = function(value) return value == expected end
        end
        local deadline = GetGameTimer() + math.max(0, tonumber(timeout) or 5000)
        repeat
            local value, reason = scope.get(entity, channel, key, options)
            if reason then return nil, reason end
            if predicate(value) then return value end
            Wait(limits.waitInterval)
        until GetGameTimer() >= deadline
        return nil, "timeout"
    end

    local function bagNameFor(entity)
        if type(NetworkGetEntityIsNetworked) == "function" and not NetworkGetEntityIsNetworked(entity) then
            return nil, "entity_not_networked"
        end
        local netId = NetworkGetNetworkIdFromEntity(entity)
        if not netId or netId <= 0 then return nil, "invalid_net_id" end
        return ("entity:%s"):format(netId)
    end

    function scope.watch(entity, channel, key, callback, options)
        if type(callback) ~= "function" then return false, "callback_required" end
        options = channelOptions(channel, options)
        local valid, reason = validateEntity(entity, options)
        if not valid then return false, reason end
        local fullKey
        fullKey, reason = stateKey(channel, key, options)
        if not fullKey then return false, reason end
        local bagName
        bagName, reason = bagNameFor(entity)
        if not bagName then return false, reason end
        if type(AddStateBagChangeHandler) ~= "function" then return false, "handler_unavailable" end

        local previous = Entity(entity).state[fullKey]
        watcherSequence = watcherSequence + 1
        local id = watcherSequence
        local cookie = AddStateBagChangeHandler(fullKey, bagName, function(changedBag, changedKey, value, _, replicated)
            if changedBag ~= bagName or changedKey ~= fullKey then return end
            local oldValue = previous
            previous = value
            metrics.watcherCalls = metrics.watcherCalls + 1
            local callbackOk = pcall(callback, value, oldValue, key, entity, replicated == true)
            if not callbackOk then metrics.watcherErrors = metrics.watcherErrors + 1 end
        end)
        watchers[id] = cookie
        return id
    end

    local function entityFromBagName(bagName)
        if type(bagName) ~= "string" then return nil end

        if type(GetEntityFromStateBagName) == "function" then
            local entity = GetEntityFromStateBagName(bagName)
            if entity and entity > 0 then return entity end
        end

        local netId = tonumber(bagName:match("^entity:(%d+)$"))
        if not netId or netId <= 0 or type(NetworkGetEntityFromNetworkId) ~= "function" then return nil end
        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity and entity > 0 then return entity end
    end

    function scope.watchAny(channel, key, callback, options)
        if type(callback) ~= "function" then return false, "callback_required" end
        if type(AddStateBagChangeHandler) ~= "function" then return false, "handler_unavailable" end

        options = channelOptions(channel, options)
        local fullKey, reason = stateKey(channel, key, options)
        if not fullKey then return false, reason end

        local previousByBag = {}
        watcherSequence = watcherSequence + 1
        local id = watcherSequence
        local cookie = AddStateBagChangeHandler(fullKey, nil, function(bagName, changedKey, value, _, replicated)
            if changedKey ~= fullKey then return end

            local entity = entityFromBagName(bagName)
            if not entity or not DoesEntityExist(entity) then return end
            if options.allowAnyEntity ~= true and type(GetEntityType) == "function" and GetEntityType(entity) ~= entityType then return end

            local oldValue = previousByBag[bagName]
            previousByBag[bagName] = value
            metrics.watcherCalls = metrics.watcherCalls + 1
            local callbackOk = pcall(callback, value, oldValue, key, entity, replicated == true, bagName)
            if not callbackOk then metrics.watcherErrors = metrics.watcherErrors + 1 end
        end)
        watchers[id] = cookie
        return id
    end

    function scope.unwatch(id)
        local cookie = watchers[id]
        if cookie == nil then return false end
        if type(RemoveStateBagChangeHandler) == "function" then RemoveStateBagChangeHandler(cookie) end
        watchers[id] = nil
        return true
    end

    function scope.clearWatchers()
        local ids = {}
        for id in pairs(watchers) do ids[#ids + 1] = id end
        for index = 1, #ids do scope.unwatch(ids[index]) end
        return #ids
    end

    function scope.getMetrics()
        local result = copy(metrics)
        local count = 0
        for _ in pairs(watchers) do count = count + 1 end
        result.watchers = count
        result.maxKeyLength = limits.maxKeyLength
        result.maxPayloadBytes = limits.maxPayloadBytes
        return result
    end

    function scope.channel(name, defaults)
        if defaults then
            local ok, reason = scope.registerChannel(name, defaults)
            if not ok then return nil, reason end
        elseif not channels[name] then
            local ok, reason = scope.registerChannel(name, {})
            if not ok then return nil, reason end
        end

        local channel = { name = name }
        function channel.get(entity, key, options) return scope.get(entity, name, key, options) end
        function channel.set(entity, key, value, options) return scope.set(entity, name, key, value, options) end
        function channel.remove(entity, key, options) return scope.remove(entity, name, key, options) end
        function channel.update(entity, key, updater, options) return scope.update(entity, name, key, updater, options) end
        function channel.setMany(entity, values, options) return scope.setMany(entity, name, values, options) end
        function channel.snapshot(entity, keys, options) return scope.snapshot(entity, name, keys, options) end
        function channel.wait(entity, key, predicate, timeout, options) return scope.wait(entity, name, key, predicate, timeout, options) end
        function channel.watch(entity, key, callback, options) return scope.watch(entity, name, key, callback, options) end
        function channel.watchAny(key, callback, options) return scope.watchAny(name, key, callback, options) end
        return channel
    end

    scope.raw = {}
    function scope.raw.get(entity, key, options) return scope.get(entity, nil, key, merge(options, { raw = true })) end
    function scope.raw.set(entity, key, value, options) return scope.set(entity, nil, key, value, merge(options, { raw = true })) end
    function scope.raw.remove(entity, key, options) return scope.remove(entity, nil, key, merge(options, { raw = true })) end
    function scope.raw.watch(entity, key, callback, options) return scope.watch(entity, nil, key, callback, merge(options, { raw = true })) end
    function scope.raw.watchAny(key, callback, options) return scope.watchAny(nil, key, callback, merge(options, { raw = true })) end

    AddEventHandler("onResourceStop", function(resource)
        if resource == GetCurrentResourceName() then scope.clearWatchers() end
    end)

    return scope
end

local vehicleState = makeScope(2, "pr_bridge:vehicle:")
local propState = makeScope(3, "pr_bridge:prop:")

vehicleState.props = propState
vehicleState.entities = propState

vehicleState.registerChannel("mileage", { replicated = true, authority = "server", maxPayloadBytes = 2048 })
vehicleState.registerChannel("keys", { replicated = true, authority = "server", maxPayloadBytes = 2048 })
vehicleState.registerChannel("fueltech", { replicated = true, authority = "server", maxPayloadBytes = 4096 })
vehicleState.registerChannel("suspension", { replicated = true, authority = "server", maxPayloadBytes = 4096 })
vehicleState.registerChannel("dynamo", { replicated = true, authority = "server", maxPayloadBytes = 4096 })

function propState.link(prop, vehicle, data, options)
    if type(vehicle) ~= "number" or vehicle <= 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then
        return false, "invalid_vehicle"
    end
    if not NetworkGetEntityIsNetworked(vehicle) then return false, "vehicle_not_networked" end
    local payload = {
        vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle),
        role = type(data) == "table" and data.role or nil,
        data = type(data) == "table" and data.data or data,
    }
    return propState.set(prop, "link", "vehicle", payload, merge({ replicated = true, authority = "server" }, options))
end

function propState.unlink(prop, options)
    return propState.remove(prop, "link", "vehicle", merge({ replicated = true, authority = "server" }, options))
end

function propState.getLinkedVehicle(prop)
    local link, reason = propState.get(prop, "link", "vehicle")
    if not link then return nil, reason or "not_linked" end
    local netId = tonumber(link.vehicleNetId)
    if not netId or netId <= 0 then return nil, "invalid_vehicle_net_id" end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle <= 0 or not DoesEntityExist(vehicle) then return nil, "vehicle_not_available" end
    return vehicle, link
end

return vehicleState
