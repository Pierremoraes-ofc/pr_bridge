local replicatedKeys = {
    game = true,
    playerId = true,
    serverId = true,
    ped = true,
    vehicle = true,
    seat = true,
    weapon = true,
    coords = true,
    interior = true,
    dead = true,
    entityCount = true,
    playerCount = true,
    seatbelt = true,
}

local function shallowRecord(record)
    if type(record) ~= "table" then return nil end
    return {
        entity = record.entity,
        id = record.id,
        type = record.type,
        networked = record.networked,
        netId = record.netId,
        coords = record.coords,
        model = record.model,
    }
end

return function(cache)
    local isHost = GetCurrentResourceName() == "pr_bridge"

    if isHost then
        local baseSet = cache.set
        cache.set = function(first, second, third, fourth)
            local key = first == cache and second or first
            local changed, value = baseSet(first, second, third, fourth)
            if changed and replicatedKeys[key] then
                TriggerEvent("pr_bridge:cache:update", key, value)
            end
            return changed, value
        end

        function cache.getSnapshot()
            local snapshot = {}
            for key in pairs(replicatedKeys) do
                local value = cache.get(key)
                if value ~= nil then snapshot[key] = value end
            end
            return snapshot
        end

        function cache.getEntitySnapshot(identifier)
            return shallowRecord(cache.getEntity(identifier))
        end

        function cache.getEntities(kind)
            local source = kind and cache[kind] or cache.entities
            if type(source) ~= "table" then return {} end
            local result = {}
            for identifier, record in pairs(source) do
                result[identifier] = shallowRecord(record)
            end
            return result
        end
        cache.setShared = cache.set

        AddEventHandler("pr_bridge:cache:publish", function(key, value, ttl)
            if replicatedKeys[key] then
                cache.set(key, value, ttl)
            end
        end)


        return cache
    end

    local baseSet = cache.set

    function cache.setShared(first, second, third, fourth)
        local key, value, ttl
        if first == cache then
            key, value, ttl = second, third, fourth
        else
            key, value, ttl = first, second, third
        end
        assert(replicatedKeys[key], ("cache key '%s' is not shared"):format(tostring(key)))

        local changed, stored = baseSet(key, value, ttl)
        if changed and GetResourceState("pr_bridge") == "started" then
            TriggerEvent("pr_bridge:cache:publish", key, stored, ttl)
        end
        return changed, stored
    end

    AddEventHandler("pr_bridge:cache:update", function(key, value)
        if replicatedKeys[key] then baseSet(key, value) end
    end)

    CreateThread(function()
        Wait(0)
        if GetResourceState("pr_bridge") ~= "started" then return end
        local ok, snapshot = pcall(function()
            return exports.pr_bridge:getCacheSnapshot()
        end)
        if not ok or type(snapshot) ~= "table" then return end
        for key, value in pairs(snapshot) do
            if replicatedKeys[key] then cache.set(key, value) end
        end
    end)

    local baseGetEntity = cache.getEntity
    cache.getEntity = function(first, second)
        local identifier = first == cache and second or first
        local record = baseGetEntity(first, second)
        if record or GetResourceState("pr_bridge") ~= "started" then return record end
        local ok, remote = pcall(function()
            return exports.pr_bridge:getCachedEntity(identifier)
        end)
        return ok and remote or nil
    end
    cache.entity = cache.getEntity

    function cache.getEntities(kind)
        if GetResourceState("pr_bridge") ~= "started" then return {} end
        local ok, result = pcall(function()
            return exports.pr_bridge:getCachedEntities(kind)
        end)
        return ok and type(result) == "table" and result or {}
    end

    function cache.getSnapshot()
        local snapshot = {}
        for key in pairs(replicatedKeys) do
            local value = cache.get(key)
            if value ~= nil then snapshot[key] = value end
        end
        return snapshot
    end

    return cache
end
