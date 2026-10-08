-- Two small, authoritative domains; no arbitrary cache replication or polling.
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
        return true
    end

    function settings.get(domain, fallback)
        local record = records[domain]
        return record and record.data or fallback
    end

    function settings.snapshot(domain)
        return copy(records[domain])
    end

    if host then
        exports("GetCachedState", settings.snapshot)
        if server then
            function settings.publish(domain, data)
                assert(keys[domain] and type(data) == "table", "Invalid settings domain")
                local record = { epoch = epoch, revision = (records[domain] and records[domain].revision or 0) + 1, data = data }
                accept(domain, record)
                TriggerEvent("pr_bridge:resourceState:changed", "pr_bridge", domain, copy(record))
                TriggerClientEvent("pr_bridge:settings:sync", -1, domain, record)
            end
            api.callback.register("pr_bridge:settings:snapshot", function()
                return copy(records)
            end)
        else
            local function apply(domain, record)
                if accept(domain, record) then
                    TriggerEvent("pr_bridge:resourceState:changed", "pr_bridge", domain, copy(record))
                end
            end
            RegisterNetEvent("pr_bridge:settings:sync", function(domain, record)
                if source ~= 65535 then return end -- Ignore locally forged network updates.
                apply(domain, record)
            end)
            CreateThread(function()
                -- Bounded startup retries only; no per-player/per-frame polling.
                for attempt = 1, 3 do
                    local snapshot = api.callback.await("pr_bridge:settings:snapshot", 10000)
                    if type(snapshot) == "table" then
                        for domain, record in pairs(snapshot) do apply(domain, record) end
                        return
                    end
                    if attempt < 3 then Wait(1000 * attempt) end
                end
                api.debug.warn("[pr_bridge:settings] snapshot_unavailable")
            end)
        end
    else
        local function hydrate()
            if GetResourceState("pr_bridge") ~= "started" then return end
            for domain in pairs(keys) do
                local ok, record = pcall(function() return exports.pr_bridge:GetCachedState(domain) end)
                if ok then accept(domain, record) end
            end
        end
        AddEventHandler("pr_bridge:resourceState:changed", function(owner, domain, record)
            if owner == "pr_bridge" then accept(domain, record) end
        end)
        AddEventHandler(server and "onResourceStart" or "onClientResourceStart", function(resource)
            if resource == "pr_bridge" then hydrate() end
        end)
        hydrate()
    end
    return settings
end
