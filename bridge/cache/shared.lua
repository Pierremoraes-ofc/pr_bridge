-- Passive memory store: no collectors, framework lookups, timers or push events.
return function(api, activeBridges)
    local values, expires, listeners = {}, {}, {}
    local listenerSequence = 0
    local metrics = { hits=0, misses=0, writes=0, unchanged=0, evictions=0,
        listenerErrors=0, entityScans=0, entities=0, players=0 }
    local cache = {
        resource=GetCurrentResourceName(), context=IsDuplicityVersion() and 'server' or 'client',
        activeBridges=activeBridges or {}, entities={}, entitiesByNetId={},
        peds={}, vehicles={}, objects={}, players={}, metrics=metrics,
    }
    local function arguments(first, second, third, fourth)
        if first == cache then return second, third, fourth end
        return first, second, third
    end
    function cache.set(first, second, third, fourth)
        local key, value, ttl = arguments(first, second, third, fourth)
        assert(type(key) == 'string' and key ~= '', 'cache key must be a non-empty string')
        expires[key] = ttl and value ~= nil and (GetGameTimer() + math.max(0, tonumber(ttl) or 0)) or nil
        if values[key] == value then
            metrics.unchanged = metrics.unchanged + 1
            return false, value
        end
        values[key] = value
        metrics.writes = metrics.writes + 1
        return true, value
    end
    function cache.get(first, second, third)
        local key, fallback = arguments(first, second, third)
        local value = values[key]
        if value == nil then metrics.misses=metrics.misses+1; return fallback end
        metrics.hits=metrics.hits+1
        return value
    end
    function cache.has(first, second)
        local key = arguments(first, second)
        return cache.get(key) ~= nil
    end
    -- Explicit partial delivery, not a collector or notification. Useful when
    -- a producer changes metadata without resending an entire inventory list.
    function cache.patch(first, second, third)
        local key, fields = arguments(first, second, third)
        assert(type(fields) == 'table', 'cache patch must be a table')
        local current = cache.get(key)
        local value = {}
        if type(current) == 'table' then for field, item in pairs(current) do value[field] = item end end
        for field, item in pairs(fields) do value[field] = item end
        return cache.set(key, value)
    end
    function cache.clear(first, second)
        local key = arguments(first, second)
        if key == nil then
            local keys = {}
            for stored in pairs(values) do keys[#keys+1] = stored end
            for i=1,#keys do cache.clear(keys[i]) end
            return true
        end
        if values[key] == nil then return false end
        values[key], expires[key] = nil, nil
        metrics.evictions = metrics.evictions + 1
        return true
    end
    function cache.clearPrefix(first, second)
        local prefix = arguments(first, second)
        assert(type(prefix) == 'string', 'cache prefix must be a string')
        local keys = {}
        for key in pairs(values) do
            if key:sub(1,#prefix) == prefix then keys[#keys+1] = key end
        end
        local removed=0
        for i=1,#keys do if cache.clear(keys[i]) then removed=removed+1 end end
        return removed
    end
    -- Only an explicit caller-supplied producer is evaluated, on this request.
    -- The library never supplies a framework fallback or polls a producer later.
    function cache.remember(first, second, third, fourth)
        local key, callback, ttl = arguments(first, second, third, fourth)
        assert(type(callback) == 'function', 'cache callback must be a function')
        local shared = cache._stateKey and cache._stateKey(key)
        local value = cache.get(key)
        local deadline = not shared and expires[key] or nil
        if value ~= nil and (not deadline or deadline > GetGameTimer()) then return value end
        value = callback()
        cache.set(key,value,ttl)
        return value
    end
    cache.call = cache.remember
    -- Legacy signatures stay cancelable, but never invoke callbacks automatically.
    function cache.onChange(first, second, third)
        local key, callback = arguments(first,second,third)
        assert(type(key)=='string' and key~='', 'cache key must be a non-empty string')
        assert(type(callback)=='function', 'cache listener must be a function')
        listenerSequence=listenerSequence+1
        local id=listenerSequence
        listeners[key]=listeners[key] or {}
        listeners[key][id]=callback
        return function() return cache.off(key,id) end,id
    end
    cache.on=cache.onChange
    function cache.off(first,second,third)
        local key,id=arguments(first,second,third)
        local entries=listeners[key]
        if not entries or not entries[id] then return false end
        entries[id]=nil
        if next(entries)==nil then listeners[key]=nil end
        return true
    end
    function cache.getMetrics()
        local snapshot={}
        for key,value in pairs(metrics) do snapshot[key]=value end
        snapshot.entries,snapshot.listeners,snapshot.entities,snapshot.players=0,0,0,0
        for _ in pairs(values) do snapshot.entries=snapshot.entries+1 end
        for _,entries in pairs(listeners) do
            for _ in pairs(entries) do snapshot.listeners=snapshot.listeners+1 end
        end
        for _ in pairs(cache.entities) do snapshot.entities=snapshot.entities+1 end
        for _ in pairs(cache.players) do snapshot.players=snapshot.players+1 end
        snapshot.worldEnabled,snapshot.worldInterval=false,0
        snapshot.automaticCleanup,snapshot.automaticCollection,snapshot.automaticNotifications=false,false,false
        return snapshot
    end
    local methods={}
    function methods:get(key,fallback) return cache.get(key,fallback) end
    function methods:set(key,value,ttl) return cache.set(key,value,ttl) end
    function methods:on(key,callback) return cache.onChange(key,callback) end
    function methods:off(key,id) return cache.off(key,id) end
    cache.state=setmetatable({},{
        __index=function(_,key) return methods[key] or cache.get(key) end,
        __newindex=function(_,key,value) cache.set(key,value) end,
        __pairs=function() return next,values end,
    })
    function cache.getEntity(first,second)
        local id=arguments(first,second)
        local record=cache.entities[id] or cache.entitiesByNetId[id]
        if not record then return nil end
        if api.Entity and record.entity then record.state=api.Entity(record.entity).state end
        return record
    end
    cache.entity=cache.getEntity
    function cache.getEntityState(first,second)
        local record=cache.getEntity(first,second)
        return record and record.state or nil
    end
    -- Source-compatible queries over delivered records; never scan the game.
    function cache.setWorldEnabled() return false end
    function cache.scanWorld()
        local count=0
        for _ in pairs(cache.entities) do count=count+1 end
        return count
    end
    function cache.GetPlayer(source)
        if cache.context=='server' then
            if type(source)~='number' then return nil end
            return cache.get(('player:%s'):format(source))
        end
        return cache.get('playerData') or cache.get('player:self')
    end
    function cache.GetMetadata(source,metadata)
        if cache.context=='server' then
            if type(source)~='number' or type(metadata)~='string' then return nil end
            return cache.get(('metadata:%s:%s'):format(source,metadata))
        end
        if type(source)~='string' then return nil end
        return cache.get('metadata:self:'..source)
    end
    function cache.InvalidatePlayer(source)
        if cache.context=='server' then
            if type(source)~='number' then return end
            cache.clear(('player:%s'):format(source))
            cache.clearPrefix(('metadata:%s:'):format(source))
        else
            cache.clear('player:self')
            cache.clearPrefix('metadata:self:')
        end
    end
    function cache.collectExpired()
        local now,expired=GetGameTimer(),{}
        for key,deadline in pairs(expires) do
            if deadline<=now then expired[#expired+1]=key end
        end
        local removed=0
        for i=1,#expired do if cache.clear(expired[i]) then removed=removed+1 end end
        return removed
    end
    setmetatable(cache,{
        __call=function(_,key,callback,ttl) return cache.remember(key,callback,ttl) end,
        __index=function(_,key) return cache.get(key) end,
    })
    return cache
end
