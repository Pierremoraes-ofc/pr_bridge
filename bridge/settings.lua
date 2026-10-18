-- Explicit settings storage/requests only; no bootstrap fetches or push stream.
return function(api)
    local host = GetCurrentResourceName() == "pr_bridge"
    local server = IsDuplicityVersion()
    local records = {}
    local keys = { locale = "pr_bridge_locale", interface = "pr_bridge_ui_config" }
    local epoch = server and (tostring(os.time()) .. ":" .. tostring(GetGameTimer())) or nil
    local settings = {}

    local function copy(value)
        if type(value) ~= "table" then return value end
        local result = {}
        for key, entry in pairs(value) do result[key] = copy(entry) end
        return result
    end

    local function accept(domain, record)
        if not keys[domain] or type(record) ~= "table" or type(record.data) ~= "table"
            or type(record.epoch) ~= "string" or type(record.revision) ~= "number" then return false end
        if record.revision < 1 or record.revision % 1 ~= 0 or record.revision == math.huge then return false end
        local stamp, timer = record.epoch:match("^(%d+):(%-?%d+)$")
        stamp, timer = tonumber(stamp), tonumber(timer)
        if not stamp or not timer then return false end
        if domain == "locale" and (type(record.data.name) ~= "string" or record.data.name == ""
            or #record.data.name > 32) then return false end
        local previous = records[domain]
        if previous then
            if previous.epoch == record.epoch and previous.revision >= record.revision then return false end
            local oldStamp, oldTimer = previous.epoch:match("^(%d+):(%-?%d+)$")
            oldStamp, oldTimer = tonumber(oldStamp), tonumber(oldTimer)
            if stamp < oldStamp or (stamp == oldStamp and timer < oldTimer) then return false end
        end
        records[domain] = copy(record)
        api.cache.set(keys[domain], domain == "locale" and record.data.name or records[domain].data)
        api.cache.SetResourceState('pr_bridge', domain, records[domain].data)
        return true
    end

    function settings.get(domain, fallback)
        if not host then
            local ok, record = pcall(function() return exports.pr_bridge:GetCachedState(domain) end)
            return ok and type(record) == 'table' and copy(record.data) or fallback
        end
        local record = records[domain]
        return record and copy(record.data) or fallback
    end

    function settings.snapshot(domain)
        if not host then
            local ok, record = pcall(function() return exports.pr_bridge:GetCachedState(domain) end)
            return ok and copy(record) or nil
        end
        return copy(records[domain])
    end

    -- A producer explicitly delivers a record on this side; no network relay.
    function settings.receive(domain, record)
        assert(host, 'settings records must be delivered to the PR Bridge host')
        return accept(domain, record)
    end

    if host then
        exports("GetCachedState", settings.snapshot)
        if server then
            function settings.publish(domain, data)
                assert(keys[domain] and type(data) == "table", "Invalid settings domain")
                local record = { epoch = epoch, revision = (records[domain] and records[domain].revision or 0) + 1, data = data }
                accept(domain, record)
                return copy(record)
            end
            api.callback.register("pr_bridge:settings:snapshot", function()
                return copy(records)
            end)
        end
    end
    return settings
end
