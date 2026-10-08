-- Server-only, opt-in JSON protection. No threads, polling or client transport.
return function(core, resolve)
    local locks, paths, validBytes, seeded = {}, {}, {}, {}
    local function location(path)
        if not paths[path] then
            local resource, name = resolve(path, '.json', true)
            paths[path] = { resource, name }
        end
        return table.unpack(paths[path])
    end
    local function copy(value, deep)
        if type(value) ~= 'table' then return value end
        local result = {}
        for key, item in pairs(value) do result[key] = deep and copy(item, true) or item end
        return result
    end

    -- nil = full copy for infrequent administration; selected branches for hot paths.
    function core.jsonDraft(value, branches)
        if branches == nil then return copy(value, true) end
        local result = copy(value, false)
        for key, branch in pairs(branches) do
            if branch == true then result[key] = copy(value[key], true)
            elseif branch == 'shallow' then result[key] = copy(value[key], false)
            else result[key] = core.jsonDraft(value[key], branch) end
        end
        return result
    end

    function core.withJsonLock(path, action, ...)
        local resource, name = location(path)
        local key, owner = resource .. '/' .. name, coroutine.running()
        if locks[key] then
            if locks[key] == owner then return action(...) end
            return false, 'busy'
        end
        locks[key] = owner
        local result = table.pack(xpcall(action, debug.traceback, ...))
        locks[key] = nil
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end

    function core.wrapJsonMutations(path, service, methods)
        for _, name in ipairs(methods) do
            local action = assert(service[name], name)
            service[name] = function(...) return core.withJsonLock(path, action, ...) end
        end
    end

    local function decode(content)
        if type(content) ~= 'string' or content == '' then return nil end
        local ok, value = pcall(json.decode, content)
        if ok and value ~= nil then return value end
    end
    local function write(resource, name, content)
        local ok, saved = pcall(SaveResourceFile, resource, name, content, #content)
        -- The CFX Lua wrapper may expose BOOL as integer 1/0, not boolean.
        local success = ok and (saved == true or saved == 1)
        if not success then
            print(('[%s][persistence] write rejected @%s/%s: %s (%s)'):format(
                core.resource, resource, name, tostring(saved), ok and type(saved) or 'exception'))
        end
        return success
    end

    function core.loadJsonRecovery(path)
        local resource, name = location(path)
        local primary = LoadResourceFile(resource, name)
        local value = decode(primary)
        if value ~= nil then validBytes[resource .. '/' .. name] = primary; return value end
        local backup = LoadResourceFile(resource, name .. '.bak')
        value = decode(backup)
        if value ~= nil then
            validBytes[resource .. '/' .. name] = backup
            print(('[%s][persistence] recovered @%s/%s from backup'):format(core.resource, resource, name))
            return value, 'recovered_backup'
        end
        if primary ~= nil or backup ~= nil then
            -- Do not silently install defaults over corrupted economic data.
            error(('invalid JSON and recovery copy: @%s/%s'):format(resource, name), 2)
        end
    end

    function core.saveJsonRecovery(path, value, options)
        options = options or {}
        return core.withJsonLock(path, function()
            local resource, name = location(path)
            local ok, encoded = pcall(json.encode, value)
            if not ok or type(encoded) ~= 'string' then return false, 'encode_failed' end
            local previous = LoadResourceFile(resource, name)
            local key = resource .. '/' .. name
            -- Decode old bytes once on load/external edits, not on every purchase.
            if previous ~= nil and previous ~= validBytes[key] and decode(previous) == nil then
                previous = LoadResourceFile(resource, name .. '.bak')
                if decode(previous) == nil then return false, 'invalid_previous_json' end
            end
            if previous == encoded then return true, { resource = resource, path = name, unchanged = true } end
            -- Administration: backup before every edit. Hot paths: one seed, then
            -- a single normal write; preserve latest bytes on a reported failure.
            -- This is NOT crash-atomic durability or a cross-resource DB transaction.
            local backupNeeded = options.backup ~= 'on_failure'
            if previous and not backupNeeded and not seeded[key] then
                backupNeeded = decode(LoadResourceFile(resource, name .. '.bak')) == nil
            end
            if previous and backupNeeded and not write(resource, name .. '.bak', previous) then return false, 'backup_failed' end
            if previous then seeded[key] = true end
            if not write(resource, name, encoded) then
                if previous then write(resource, name .. '.bak', previous) end
                if previous and not write(resource, name, previous) then
                    print(('[%s][persistence] save/restore failed @%s/%s; backup retained'):format(core.resource, resource, name))
                end
                return false, 'save_failed'
            end
            validBytes[key] = encoded
            return true, { resource = resource, path = name, bytes = #encoded }
        end)
    end

    -- Infrequent multi-file administration: serialize and restore written files
    -- if a later file fails. Runtime rollback, not a power-loss atomic commit.
    function core.saveJsonBatch(changes)
        local ordered, before = {}, {}
        for path, value in pairs(changes) do ordered[#ordered + 1] = {path=path, value=value} end
        table.sort(ordered, function(a,b) return a.path < b.path end)
        local function commit()
            for _, entry in ipairs(ordered) do
                local resource, name = location(entry.path)
                local old = core.loadJsonRecovery(entry.path) or {}
                local ok, bytes = pcall(json.encode, old)
                if not ok then return false, 'encode_failed' end
                before[entry.path] = {resource=resource,name=name,bytes=bytes}
            end
            for index, entry in ipairs(ordered) do
                local ok, err = core.saveJsonRecovery(entry.path, entry.value)
                if not ok then
                    local restored = true
                    for previous=1,index-1 do
                        local old = before[ordered[previous].path]
                        if not write(old.resource, old.name, old.bytes) then restored=false end
                        if restored then validBytes[old.resource .. '/' .. old.name] = old.bytes end
                    end
                    if not restored then
                        core.recordJsonIncident(ordered[1].path, 'batch', {at=os.time(),error=err,files=ordered})
                        return false, 'reconciliation_required'
                    end
                    return false, err
                end
            end
            return true
        end
        local function locked(index)
            if not ordered[index] then return commit() end
            return core.withJsonLock(ordered[index].path, function() return locked(index+1) end)
        end
        return locked(1)
    end

    -- Exceptional-path journal only; never broadcast private financial details.
    function core.recordJsonIncident(path, key, details)
        local journal = path .. '.incidents.json'
        local entries = core.loadJsonRecovery(journal) or {}
        entries[key] = details
        local ok, err = core.saveJsonRecovery(journal, entries)
        print(('[%s][persistence] reconciliation required: %s %s (journal=%s)'):format(
            core.resource, path, key, ok and 'saved' or tostring(err)))
        return ok, err
    end
end
