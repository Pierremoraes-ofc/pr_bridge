local function convarNumber(name, fallback, minimum)
    local value = GetConvarInt and GetConvarInt(name, fallback) or fallback
    value = tonumber(value) or fallback
    return math.max(minimum or 0, value)
end

local function convarBoolean(name, fallback)
    if not GetConvar then return fallback end
    local value = GetConvar(name, fallback and "true" or "false"):lower()
    return value == "true" or value == "1" or value == "yes" or value == "on"
end

return function(api, activeBridges)
    local context = IsDuplicityVersion() and "server" or "client"
    local values, expires, listeners = {}, {}, {}
    local listenerSequence = 0
    local worldEnabled = convarBoolean("pr_bridge:cache:world", true)
    local worldInterval = convarNumber(
        "pr_bridge:cache:worldInterval",
        context == "client" and 1500 or 2000,
        250
    )

    local metrics = {
        hits = 0,
        misses = 0,
        writes = 0,
        unchanged = 0,
        evictions = 0,
        listenerErrors = 0,
        entityScans = 0,
        entities = 0,
        players = 0,
    }

    local cache = {
        resource = GetCurrentResourceName(),
        context = context,
        activeBridges = activeBridges or {},
        entities = {},
        entitiesByNetId = {},
        peds = {},
        vehicles = {},
        objects = {},
        players = {},
        metrics = metrics,
    }
    local isHost = cache.resource == "pr_bridge"

    values.game = GetGameName and GetGameName() or "fxserver"
    values.resource = cache.resource
    values.context = context
    values.activeBridges = cache.activeBridges

    local function reportListenerError(key, err)
        metrics.listenerErrors = metrics.listenerErrors + 1
        local debugApi = api and api.debug
        if debugApi and type(debugApi.warn) == "function" then
            debugApi.warn(("[pr_bridge:cache] listener '%s' falhou: %s"):format(key, tostring(err)))
        else
            print(("^3[pr_bridge:cache]^0 listener '%s' falhou: %s"):format(key, tostring(err)))
        end
    end

    local function dispatch(key, value, oldValue)
        local entries = listeners[key]
        if not entries then return end

        for _, entry in pairs(entries) do
            CreateThread(function()
                local ok, err = pcall(entry.callback, value, oldValue, key)
                if not ok then reportListenerError(key, err) end
            end)
        end
    end

    local function normalizeCall(first, second, third, fourth)
        if first == cache then return second, third, fourth end
        return first, second, third
    end

    function cache.set(first, second, third, fourth)
        local key, value, ttl = normalizeCall(first, second, third, fourth)
        assert(type(key) == "string" and key ~= "", "cache key must be a non-empty string")

        local oldValue = values[key]
        if oldValue == value then
            metrics.unchanged = metrics.unchanged + 1
            if ttl then expires[key] = GetGameTimer() + math.max(0, tonumber(ttl) or 0) end
            return false, value
        end

        values[key] = value
        expires[key] = ttl and (GetGameTimer() + math.max(0, tonumber(ttl) or 0)) or nil
        metrics.writes = metrics.writes + 1
        dispatch(key, value, oldValue)
        return true, value
    end

    function cache.get(first, second, third)
        local key, fallback = first == cache and second or first, first == cache and third or second
        local value = values[key]
        if value == nil then
            metrics.misses = metrics.misses + 1
            return fallback
        end
        metrics.hits = metrics.hits + 1
        return value
    end

    function cache.has(first, second)
        local key = first == cache and second or first
        return values[key] ~= nil
    end

    function cache.clear(first, second)
        local key = first == cache and second or first
        if key == nil then
            local keys = {}
            for cacheKey in pairs(values) do keys[#keys + 1] = cacheKey end
            for i = 1, #keys do cache.clear(keys[i]) end
            return true
        end

        local oldValue = values[key]
        if oldValue == nil then return false end
        values[key], expires[key] = nil, nil
        metrics.evictions = metrics.evictions + 1
        dispatch(key, nil, oldValue)
        return true
    end

    function cache.clearPrefix(first, second)
        local prefix = first == cache and second or first
        assert(type(prefix) == "string", "cache prefix must be a string")
        local keys = {}
        for key in pairs(values) do
            if key:sub(1, #prefix) == prefix then keys[#keys + 1] = key end
        end
        for i = 1, #keys do cache.clear(keys[i]) end
        return #keys
    end

    function cache.remember(first, second, third, fourth)
        local key, callback, ttl = normalizeCall(first, second, third, fourth)
        assert(type(callback) == "function", "cache callback must be a function")
        local value = values[key]
        if value ~= nil then
            metrics.hits = metrics.hits + 1
            return value
        end

        metrics.misses = metrics.misses + 1
        value = callback()
        cache.set(key, value, ttl)
        return value
    end

    cache.call = cache.remember

    function cache.onChange(first, second, third)
        local key, callback = first == cache and second or first, first == cache and third or second
        assert(type(key) == "string" and key ~= "", "cache key must be a non-empty string")
        assert(type(callback) == "function", "cache listener must be a function")

        listenerSequence = listenerSequence + 1
        local id = listenerSequence
        listeners[key] = listeners[key] or {}
        listeners[key][id] = { id = id, callback = callback }

        return function()
            local entries = listeners[key]
            if not entries or not entries[id] then return false end
            entries[id] = nil
            if next(entries) == nil then listeners[key] = nil end
            return true
        end, id
    end

    cache.on = cache.onChange

    function cache.off(first, second, third)
        local key, id = first == cache and second or first, first == cache and third or second
        local entries = listeners[key]
        if not entries or not entries[id] then return false end
        entries[id] = nil
        if next(entries) == nil then listeners[key] = nil end
        return true
    end

    function cache.getMetrics()
        local snapshot = {}
        for key, value in pairs(metrics) do snapshot[key] = value end
        local entries, listenerCount = 0, 0
        for _ in pairs(values) do entries = entries + 1 end
        for _, registered in pairs(listeners) do
            for _ in pairs(registered) do listenerCount = listenerCount + 1 end
        end
        snapshot.entries = entries
        snapshot.listeners = listenerCount
        snapshot.worldEnabled = worldEnabled
        snapshot.worldInterval = worldInterval
        return snapshot
    end

    local stateMethods = {}
    function stateMethods:get(key, fallback) return cache.get(key, fallback) end
    function stateMethods:set(key, value, ttl) return cache.set(key, value, ttl) end
    function stateMethods:on(key, callback) return cache.onChange(key, callback) end
    function stateMethods:off(key, id) return cache.off(key, id) end

    cache.state = setmetatable({}, {
        __index = function(_, key) return stateMethods[key] or values[key] end,
        __newindex = function(_, key, value) cache.set(key, value) end,
        __pairs = function() return next, values end,
    })

    local function entityRecord(entity, kind)
        local record = cache.entities[entity]
        if record then return record end

        local networked = NetworkGetEntityIsNetworked and NetworkGetEntityIsNetworked(entity) or false
        local netId = networked and NetworkGetNetworkIdFromEntity(entity) or 0
        record = { entity = entity, id = entity, type = kind, networked = networked, netId = netId }
        cache.entities[entity] = record
        if netId and netId > 0 then cache.entitiesByNetId[netId] = record end
        return record
    end

    function cache.getEntity(first, second)
        local identifier = first == cache and second or first
        local record = cache.entities[identifier] or cache.entitiesByNetId[identifier]
        if not record then return nil end
        if DoesEntityExist and not DoesEntityExist(record.entity) then return nil end

        record.coords = GetEntityCoords and GetEntityCoords(record.entity) or record.coords
        record.model = GetEntityModel and GetEntityModel(record.entity) or record.model
        if Entity then record.state = Entity(record.entity).state end
        return record
    end

    cache.entity = cache.getEntity

    function cache.getEntityState(first, second)
        local record = cache.getEntity(first, second)
        return record and record.state or nil
    end

    local pools = {
        { name = "peds", pool = "CPed", kind = "ped" },
        { name = "vehicles", pool = "CVehicle", kind = "vehicle" },
        { name = "objects", pool = "CObject", kind = "object" },
    }

    local function scanWorld()
        if not worldEnabled or type(GetGamePool) ~= "function" then return end
        local seen = {}

        for i = 1, #pools do
            local definition = pools[i]
            local target = cache[definition.name]
            local current = GetGamePool(definition.pool) or {}
            local typedSeen = {}

            for index = 1, #current do
                local entity = current[index]
                if entity and entity ~= 0 then
                    local record = entityRecord(entity, definition.kind)
                    target[entity] = record
                    seen[entity], typedSeen[entity] = true, true
                end
            end

            for entity in pairs(target) do
                if not typedSeen[entity] then target[entity] = nil end
            end
        end

        for entity, record in pairs(cache.entities) do
            if not seen[entity] then
                cache.entities[entity] = nil
                if record.netId and record.netId > 0 then cache.entitiesByNetId[record.netId] = nil end
                dispatch("entity:remove", record, record)
            end
        end

        local count = 0
        for _ in pairs(cache.entities) do count = count + 1 end
        metrics.entities, metrics.entityScans = count, metrics.entityScans + 1
        cache.set("entityCount", count)
    end

    function cache.setWorldEnabled(first, second)
        local enabled = first == cache and second or first
        worldEnabled = enabled == true
        return worldEnabled
    end

    function cache.scanWorld() scanWorld(); return metrics.entities end

    function cache.GetPlayer(source, timeout)
        if context == "server" then
            if type(source) ~= "number" then return nil end
            return cache.remember(("player:%s"):format(source), function()
                return api.framework and api.framework.GetPlayer and api.framework.GetPlayer(source)
            end, timeout or 1000)
        end
        return cache.remember("player:self", function()
            return api.framework and api.framework.GetPlayer and api.framework.GetPlayer()
        end, source or 1000)
    end

    function cache.GetMetadata(source, metadata, timeout)
        if context == "server" then
            if type(source) ~= "number" or type(metadata) ~= "string" then return nil end
            return cache.remember(("metadata:%s:%s"):format(source, metadata), function()
                return api.framework and api.framework.getPlayerMetadata and api.framework.getPlayerMetadata(source, metadata)
            end, timeout or 1000)
        end

        local metadataName = source
        if type(metadataName) ~= "string" then return nil end
        return cache.remember(("metadata:self:%s"):format(metadataName), function()
            return api.framework and api.framework.getPlayerMetadata and api.framework.getPlayerMetadata(metadataName)
        end, metadata or 1000)
    end

    function cache.InvalidatePlayer(source)
        if context == "server" then
            if type(source) ~= "number" then return end
            cache.clear(("player:%s"):format(source))
            cache.clearPrefix(("metadata:%s:"):format(source))
            cache.players[source] = nil
            return
        end
        cache.clear("player:self")
        cache.clearPrefix("metadata:self:")
    end

    CreateThread(function()
        while true do
            local now = GetGameTimer()
            local expired = {}
            for key, deadline in pairs(expires) do
                if deadline <= now then expired[#expired + 1] = key end
            end
            for i = 1, #expired do cache.clear(expired[i]) end
            Wait(500)
        end
    end)

    if isHost then
    if context == "client" then
        local fastInterval = convarNumber("pr_bridge:cache:playerInterval", 100, 50)
        local coordsInterval = convarNumber("pr_bridge:cache:coordsInterval", 250, 100)
        local slowInterval = convarNumber("pr_bridge:cache:slowInterval", 500, 100)

        CreateThread(function()
            local nextCoords, nextSlow = 0, 0
            while true do
                local now = GetGameTimer()
                local playerId = PlayerId()
                local ped = PlayerPedId()
                cache.set("playerId", playerId)
                cache.set("serverId", GetPlayerServerId(playerId))

                if ped and ped ~= 0 then
                    cache.set("ped", ped)
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    vehicle = vehicle and vehicle > 0 and vehicle or false
                    cache.set("vehicle", vehicle)

                    local seat = false
                    if vehicle then
                        local maxPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
                        for index = -1, maxPassengers - 1 do
                            if GetPedInVehicleSeat(vehicle, index) == ped then seat = index break end
                        end
                    end
                    cache.set("seat", seat)

                    local hasWeapon, weapon = GetCurrentPedWeapon(ped, true)
                    cache.set("weapon", hasWeapon and weapon ~= 0 and weapon or false)

                    if now >= nextCoords then
                        cache.set("coords", GetEntityCoords(ped))
                        nextCoords = now + coordsInterval
                    end

                    if now >= nextSlow then
                        cache.set("interior", GetInteriorFromEntity(ped))
                        cache.set("dead", IsEntityDead(ped))
                        nextSlow = now + slowInterval
                    end
                end
                Wait(fastInterval)
            end
        end)
    else
        local playerInterval = convarNumber("pr_bridge:cache:serverPlayerInterval", 1000, 250)
        CreateThread(function()
            while true do
                local seen = {}
                local currentPlayers = GetPlayers and GetPlayers() or {}
                for i = 1, #currentPlayers do
                    local source = tonumber(currentPlayers[i])
                    if source then
                        local record = cache.players[source] or { source = source, serverId = source }
                        record.ped = GetPlayerPed and GetPlayerPed(source) or 0
                        record.name = GetPlayerName and GetPlayerName(source) or nil
                        cache.players[source], seen[source] = record, true
                    end
                end
                for source in pairs(cache.players) do
                    if not seen[source] then cache.players[source] = nil end
                end
                metrics.players = #currentPlayers
                cache.set("playerCount", metrics.players)
                Wait(playerInterval)
            end
        end)

        AddEventHandler("playerDropped", function()
            cache.InvalidatePlayer(source)
        end)
    end

    CreateThread(function()
        while true do
            scanWorld()
            Wait(worldInterval)
        end
    end)
    end

    setmetatable(cache, {
        __call = function(_, key, callback, timeout) return cache.remember(key, callback, timeout) end,
        __index = function(_, key) return values[key] end,
    })

    return cache
end
