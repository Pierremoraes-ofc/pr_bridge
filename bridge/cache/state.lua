-- State-style syntax over the existing cache. No native bags, network, SQL or polling.
return function(api, cache)
    local client = cache.context == 'client'
    local containers = {}
    local kinds = { player = true, entity = true, mission = true, property = true, resource = true }

    local function identifier(value, numeric)
        if numeric then
            local number = tonumber(value)
            if not number or number <= 0 or number % 1 ~= 0 then return nil end
            return tostring(math.floor(number))
        end
        if type(value) ~= 'string' and type(value) ~= 'number' then return nil end
        value = tostring(value)
        if #value == 0 or #value > 96 or not value:match('^[%w_.%-]+$') then return nil end
        return value
    end

    local function ownId()
        local id = cache.get('serverId')
        return identifier(id, true)
    end

    local function fieldName(field, allowEmpty)
        return type(field) == 'string' and #field <= 128 and (allowEmpty or field ~= '')
    end

    -- Only these explicit namespaces are shared within one client OR the server.
    -- Unrelated cache keys retain their existing resource-local semantics.
    local function normalize(key, prefix)
        if type(key) ~= 'string' then return nil end
        if key:sub(1, 7) == 'global:' then
            return fieldName(key:sub(8), prefix) and key or nil
        end
        if prefix and kinds[key:match('^(%a+):$')] then return key end
        local kind, id, field = key:match('^(%a+):([^:]+):(.*)$')
        if not kinds[kind] or not fieldName(field, prefix) then return nil end
        if kind == 'player' and id == 'local' and client then id = ownId()
        else id = identifier(id, kind == 'player' or kind == 'entity') end
        return id and (kind .. ':' .. id .. ':' .. field) or nil
    end
    cache._stateKey = function(key) return normalize(key, false) end
    cache._statePrefix = function(prefix) return normalize(prefix, true) end

    local function proxy(kind, id)
        local function prefix()
            if kind == 'global' then return 'global:' end
            local current = type(id) == 'function' and id() or id
            assert(current, 'LocalPlayer cache requires a serverId explicitly published by a producer')
            return kind .. ':' .. current .. ':'
        end
        local function key(field)
            assert(fieldName(field), 'state field must be a string (1..128 chars)')
            return prefix() .. field
        end
        local methods = {}
        function methods:get(field, fallback) return cache.get(key(field), fallback) end
        function methods:set(field, value, ttl)
            assert(ttl == nil or (type(ttl) == 'number' and ttl >= 0 and ttl < math.huge),
                'cache state accepts an optional TTL in milliseconds, not a replication flag')
            return cache.set(key(field), value, ttl)
        end
        function methods:onChange(field, callback) return cache.onChange(key(field), callback) end
        function methods:off(field, subscription) return cache.off(key(field), subscription) end
        function methods:clear(field)
            if field == nil then return cache.clearPrefix(prefix()) end
            return cache.clear(key(field))
        end
        return setmetatable({}, {
            __index = function(_, field)
                if methods[field] then return methods[field] end
                return cache.get(key(field))
            end,
            __newindex = function(_, field, value) cache.set(key(field), value) end,
        })
    end

    local function container(kind, id)
        id = identifier(id, kind == 'player' or kind == 'entity')
        assert(id, 'invalid ' .. kind .. ' cache identifier')
        local bucket = containers[kind]
        if not bucket then
            bucket = setmetatable({}, { __mode = 'v' })
            containers[kind] = bucket
        end
        local object = bucket[id]
        if not object then
            object = { state = proxy(kind, id) }
            bucket[id] = object
        end
        return object
    end

    api.Player = function(id) return container('player', id) end
    -- Entity identifiers are handles in this context, not interchangeable network IDs.
    api.Entity = function(handle) return container('entity', handle) end
    cache._entityState = function(handle) return api.Entity(handle).state end
    api.Mission = function(id) return container('mission', id) end
    api.Property = function(id) return container('property', id) end
    api.GlobalState = proxy('global')
    if client then api.LocalPlayer = { state = proxy('player', ownId) } end
end
