-- PR Bridge cache-backed state facade. No native FiveM State Bags are used.
-- Both API styles read and write the same cache keys.
return function(api, cache)
    local server = IsDuplicityVersion()
    local host = GetCurrentResourceName() == 'pr_bridge'
    local UPDATE = 'pr_bridge:state:cacheUpdate'
    local NET_UPDATE = 'pr_bridge:state:netUpdate'
    local NET_WRITE = 'pr_bridge:state:netWrite'
    local SNAPSHOT = 'pr_bridge:state:cacheSnapshot'
    local REQUEST = 'pr_bridge:state:requestSnapshot'
    local replicated = {}
    local versions = {}
    local remoteWrite = false
    local MAX_VALUE_BYTES = 16384

    local function keyFor(kind, id, field)
        assert(type(field) == 'string' and field ~= '' and #field <= 128, 'state field must be a string (1..128 chars)')
        if kind == 'global' then return field end
        if kind == 'local' then return 'player:local:' .. field end
        return kind .. ':' .. tostring(id) .. ':' .. field
    end

    local function valid(value, depth, seen)
        local t = type(value)
        if t == 'nil' or t == 'string' or t == 'boolean' then return true end
        if t == 'number' then return value == value and value ~= math.huge and value ~= -math.huge end
        if t ~= 'table' or depth >= 8 or seen[value] then return false end
        seen[value] = true
        for k, v in pairs(value) do
            if (type(k) ~= 'string' and type(k) ~= 'number') or not valid(v, depth + 1, seen) then return false end
        end
        seen[value] = nil
        return true
    end

    local function check(key, value)
        assert(type(key) == 'string' and #key > 0 and #key <= 256, 'invalid cache key')
        assert(valid(value, 0, {}), 'state value must be serializable')
        if value ~= nil then
            assert(#json.encode(value) <= MAX_VALUE_BYTES, 'state value exceeds 16 KiB')
        end
    end

    local function apply(key, value)
        remoteWrite = true
        local ok, err = pcall(function()
            if value == nil then cache.clear(key) else cache.set(key, value) end
        end)
        remoteWrite = false
        if not ok then print('[pr_bridge:cache] sync error: ' .. tostring(err)) end
    end

    local function publish(key, value, shouldReplicate)
        check(key, value)
        if not server then
            -- Client writes are local unless explicitly replicated. Only own player keys
            -- may be sent to the server; server decides whether to accept them.
            if shouldReplicate then
                local ownId = GetPlayerServerId(PlayerId())
                if key:sub(1, #('player:' .. ownId .. ':')) == ('player:' .. ownId .. ':') then
                    TriggerServerEvent(NET_WRITE, key, value)
                else
                    return false, 'client_replication_not_authorized'
                end
            end
            if value == nil then cache.clear(key) else cache.set(key, value) end
            return true
        end
        if host then
            if value == nil then cache.clear(key) else cache.set(key, value) end
            if shouldReplicate then
                replicated[key] = true
                versions[key] = (versions[key] or 0) + 1
                TriggerClientEvent(NET_UPDATE, -1, key, value, versions[key])
            end
            TriggerEvent(UPDATE, key, value)
            return true
        end
        local ok, result, reason = pcall(function()
            return exports.pr_bridge:writeCacheState(key, value, shouldReplicate == true)
        end)
        if not ok then return false, result end
        if result then apply(key, value) end
        return result, reason
    end

    if host and server then
        exports('writeCacheState', function(key, value, shouldReplicate)
            if type(key) ~= 'string' then return false, 'invalid_key' end
            local ok, err = pcall(publish, key, value, shouldReplicate)
            return ok, ok and nil or tostring(err)
        end)
        exports('readCacheState', function(key)
            return cache.get(key)
        end)
        RegisterNetEvent(NET_WRITE, function(key, value)
            local src = source
            if type(key) ~= 'string' or key:sub(1, #('player:' .. src .. ':')) ~= ('player:' .. src .. ':') then return end
            -- Explicit opt-in: default-deny client writes unless a server convar enables them.
            if GetConvar('pr_bridge:cache:allowClientWrites', 'false') ~= 'true' then return end
            local ok, err = pcall(publish, key, value, true)
            if not ok then print('[pr_bridge:cache] rejected client write: ' .. tostring(err)) end
        end)
        RegisterNetEvent(REQUEST, function()
            local src = source
            local data = {}
            for key in pairs(replicated) do
                data[key] = cache.get(key)
            end
            TriggerClientEvent(SNAPSHOT, src, data, versions)
        end)
        AddEventHandler('playerDropped', function()
            local prefix = 'player:' .. source .. ':'
            cache.clearPrefix(prefix)
            for key in pairs(replicated) do
                if key:sub(1, #prefix) == prefix then replicated[key] = nil end
            end
        end)
    elseif not server then
        RegisterNetEvent(NET_UPDATE, function(key, value, version)
            if type(key) ~= 'string' or type(version) ~= 'number' then return end
            if version <= (versions[key] or 0) then return end
            versions[key] = version
            apply(key, value)
        end)
        RegisterNetEvent(SNAPSHOT, function(data, incomingVersions)
            if type(data) ~= 'table' or type(incomingVersions) ~= 'table' then return end
            for key, value in pairs(data) do
                local version = incomingVersions[key]
                if type(key) == 'string' and type(version) == 'number' and version > (versions[key] or 0) then
                    versions[key] = version
                    apply(key, value)
                end
            end
        end)
        CreateThread(function()
            while GetResourceState('pr_bridge') ~= 'started' do Wait(250) end
            TriggerServerEvent(REQUEST)
        end)
    end

    -- Host broadcasts cache writes to other server resources. They maintain local
    -- mirrors, preserving existing cache.get semantics in the same runtime.
    if server then
        AddEventHandler(UPDATE, function(key, value)
            if not host and type(key) == 'string' then apply(key, value) end
        end)
    end

    local function proxy(kind, id)
        local methods = {}
        function methods:set(field, value, shouldReplicate)
            return publish(keyFor(kind, id, field), value, shouldReplicate == true)
        end
        function methods:get(field, fallback)
            local key = keyFor(kind, id, field)
            local value = cache.get(key)
            if value == nil and server and not host then
                local ok, remote = pcall(function() return exports.pr_bridge:readCacheState(key) end)
                if ok and remote ~= nil then apply(key, remote); value = remote end
            end
            if value == nil then return fallback end
            return value
        end
        function methods:onChange(field, callback)
            return cache.onChange(keyFor(kind, id, field), callback)
        end
        return setmetatable({}, {
            __index = function(_, field)
                if methods[field] then return methods[field] end
                return methods:get(field)
            end,
            __newindex = function(_, field, value)
                local ok, err = methods:set(field, value, false)
                if not ok then error(tostring(err), 2) end
            end,
        })
    end

    local function container(kind, id)
        assert(id ~= nil and tostring(id) ~= '', 'state identifier is required')
        return { state = proxy(kind, id) }
    end

    api.Player = function(id) return container('player', id) end
    api.Entity = function(id) return container('entity', id) end
    api.LocalPlayer = { state = proxy('local') }
    api.GlobalState = proxy('global')
    api.Mission = function(id) return container('mission', id) end
    api.Property = function(id) return container('property', id) end
end
