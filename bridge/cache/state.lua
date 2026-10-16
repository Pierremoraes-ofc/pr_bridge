-- StateBag-style API for pr_lib. Legacy cache API is deliberately untouched.
-- Server owns custom logical scopes; native OneSync owns player/entity/global state.
return function(api, cache)
    local server = IsDuplicityVersion()
    local host = GetCurrentResourceName() == 'pr_bridge'
    local logical = {}
    local hydrated = {}
    local pending = {}
    local revisions = {}
    local watchers = {}
    local sequence = 0
    local EVENT_UPDATE = 'pr_bridge:state:update'
    local EVENT_SNAPSHOT = 'pr_bridge:state:snapshot'
    local EVENT_REQUEST = 'pr_bridge:state:request'

    local function makeId(kind, id)
        assert(type(kind) == 'string' and type(id) == 'string' and id ~= '', 'invalid state scope')
        return kind .. ':' .. id
    end

    local function localBag(scope)
        local bag = logical[scope]
        if not bag then bag = {}; logical[scope] = bag end
        return bag
    end

    local function publishLocal(scope, key, value)
        local bag = localBag(scope)
        local previous = bag[key]
        if previous == value then return false end
        bag[key] = value
        local listeners = watchers[scope]
        if listeners then
            for _, fn in pairs(listeners) do
                CreateThread(function()
                    local ok, err = pcall(fn, key, value, previous)
                    if not ok then print('[pr_bridge:state] listener error: ' .. tostring(err)) end
                end)
            end
        end
        return true
    end

    local function snapshot(scope)
        local out = {}
        for k, v in pairs(localBag(scope)) do out[k] = v end
        return out
    end

    local function applySnapshot(scope, data, version)
        if type(data) ~= 'table' then return end
        local old = localBag(scope)
        for k in pairs(old) do
            if data[k] == nil then publishLocal(scope, k, nil) end
        end
        for k, v in pairs(data) do publishLocal(scope, k, v) end
        revisions[scope] = version or revisions[scope] or 0
        hydrated[scope] = true
    end

    local function isValid(value, depth, seen)
        local kind = type(value)
        if kind == 'nil' or kind == 'boolean' or kind == 'number' or kind == 'string' then
            return kind ~= 'number' or (value == value and value ~= math.huge and value ~= -math.huge)
        end
        if kind ~= 'table' or depth > 8 or seen[value] then return false end
        seen[value] = true
        for k, v in pairs(value) do
            if type(k) ~= 'string' and type(k) ~= 'number' then return false end
            if not isValid(v, depth + 1, seen) then return false end
        end
        seen[value] = nil
        return true
    end

    local function validate(scope, key, value)
        assert(type(key) == 'string' and #key > 0 and #key <= 128, 'invalid state key')
        assert(isValid(value, 0, {}), 'state value must be a serializable primitive/table')
        local size = #json.encode(value)
        assert(size <= 16384, 'state value exceeds 16 KiB')
        assert(#scope <= 256, 'state scope too long')
    end

    local function isActivePlayer(src)
        return type(src) == 'number' and src > 0 and GetPlayerName(src) ~= nil
    end

    local function saveCustom(scope, key, value, replicate)
        validate(scope, key, value)
        if not server then
            -- Never trust client writes for durable logical state.
            return false, 'server_only'
        end
        if not host then
            local ok, result, reason = pcall(function()
                return exports.pr_bridge:stateWrite(scope, key, value, replicate == true)
            end)
            if not ok then return false, result end
            if result then publishLocal(scope, key, value) end
            return result, reason
        end
        local changed = publishLocal(scope, key, value)
        if changed then
            if replicate == true then pending[scope] = true end
            revisions[scope] = (revisions[scope] or 0) + 1
            TriggerEvent(EVENT_UPDATE, scope, key, value, revisions[scope])
            if replicate == true then
                TriggerClientEvent(EVENT_UPDATE, -1, scope, key, value, revisions[scope])
            end
        end
        return true
    end

    if host and server then
        exports('stateWrite', function(scope, key, value, replicate)
            if type(scope) ~= 'string' or not scope:match('^(mission|property):') then
                return false, 'invalid_scope'
            end
            return saveCustom(scope, key, value, replicate)
        end)
        exports('stateSnapshot', function(scope)
            if type(scope) ~= 'string' then return nil end
            return snapshot(scope), revisions[scope] or 0
        end)
        RegisterNetEvent(EVENT_REQUEST, function(scope)
            local src = source
            if not isActivePlayer(src) or type(scope) ~= 'string' then return end
            if not scope:match('^(mission|property):') or #scope > 256 then return end
            -- Custom scopes are server-owned. Explicit replicate=true makes a scope public.
            if pending[scope] then
                TriggerClientEvent(EVENT_SNAPSHOT, src, scope, snapshot(scope), revisions[scope] or 0)
            end
        end)
        AddEventHandler(EVENT_UPDATE, function(scope, key, value, revision)
            if type(scope) ~= 'string' or not scope:match('^(mission|property):') then return end
            if revisions[scope] and revision and revision <= revisions[scope] then return end
            publishLocal(scope, key, value)
            revisions[scope] = revision or (revisions[scope] or 0) + 1
        end)
    elseif server then
        AddEventHandler(EVENT_UPDATE, function(scope, key, value, revision)
            if type(scope) ~= 'string' then return end
            if revision and revision <= (revisions[scope] or 0) then return end
            publishLocal(scope, key, value)
            revisions[scope] = revision or (revisions[scope] or 0) + 1
        end)
    else
        RegisterNetEvent(EVENT_UPDATE, function(scope, key, value, version)
            if type(scope) ~= 'string' then return end
            if version and version <= (revisions[scope] or 0) then return end
            publishLocal(scope, key, value)
            revisions[scope] = version or (revisions[scope] or 0) + 1
        end)
        RegisterNetEvent(EVENT_SNAPSHOT, function(scope, data, version)
            if type(scope) == 'string' and (version or 0) >= (revisions[scope] or 0) then
                applySnapshot(scope, data, version)
            end
        end)
    end

    local function customScope(kind, id)
        local scope = makeId(kind, tostring(id))
        if server and not host and not hydrated[scope] then
            local ok, data, version = pcall(function()
                return exports.pr_bridge:stateSnapshot(scope)
            end)
            if ok and type(data) == 'table' then applySnapshot(scope, data, version) end
        end
        local methods = {}
        function methods:set(key, value, replicated)
            return saveCustom(scope, key, value, replicated)
        end
        function methods:get(key) return localBag(scope)[key] end
        function methods:onChange(cb)
            assert(type(cb) == 'function', 'callback required')
            sequence = sequence + 1
            local id = sequence
            watchers[scope] = watchers[scope] or {}
            watchers[scope][id] = cb
            return function() watchers[scope][id] = nil end
        end
        if not server and not hydrated[scope] then
            hydrated[scope] = true
            TriggerServerEvent(EVENT_REQUEST, scope)
        end
        local proxy = setmetatable({}, {
            __index = function(_, key)
                if methods[key] then return methods[key] end
                return localBag(scope)[key]
            end,
            __newindex = function(_, key, value)
                local ok, err = saveCustom(scope, key, value, false)
                if not ok then error(tostring(err), 2) end
            end,
            __pairs = function() return next, snapshot(scope) end,
        })
        return { state = proxy }
    end

    local function native(kind, id)
        local nativeState
        if kind == 'player' then
            nativeState = Player(id).state
        elseif kind == 'entity' then
            nativeState = Entity(id).state
        end
        return { state = nativeState }
    end

    api.Player = function(id) return native('player', id) end
    api.Entity = function(entity) return native('entity', entity) end
    if not server then
        api.LocalPlayer = { state = LocalPlayer.state }
    end
    api.GlobalState = GlobalState
    api.Mission = function(id) return customScope('mission', id) end
    api.Property = function(id) return customScope('property', id) end
end
