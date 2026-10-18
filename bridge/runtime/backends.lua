-- A framework can depend on the provided ox_lib identity, so PR Bridge may
-- start first. Bind only ready external backends and refresh after they start.
-- Update tables in place to preserve aliases/references held by other modules.
return function(api, catalog, active, selectPath, onRefresh)
    local categories = {
        frameworks = "framework", inventories = "inventory", database = "database",
        banking = "banking", phones = "phone", weather = "weather", fuel = "fuel", vehicle_key = "vehicle_key",
    }
    if not IsDuplicityVersion() then categories.database = nil end
    local function refresh(resource)
        for category, field in pairs(categories) do
            local relevant = false
            for _, entry in ipairs(catalog[category] or {}) do
                if entry.resource == resource then relevant = true; break end
            end
            if relevant then
                local previous = active[category]
                local path = selectPath(category)
                if active[category] ~= previous then
                    local replacement = PRCore.load(path) or {}
                    local current = api[field]
                    if type(current) == "table" and type(replacement) == "table" then
                        for key in pairs(current) do current[key] = nil end
                        for key, value in pairs(replacement) do current[key] = value end
                        setmetatable(current, getmetatable(replacement))
                    else api[field] = replacement end
                    if onRefresh then onRefresh(field) end
                    TriggerEvent("pr_bridge:backend:changed", category, active[category])
                end
            end
        end
    end
    -- onResourceStart runs inside Resource::Start, before the resource state
    -- necessarily becomes 'started'. Selection deliberately rejects 'starting'
    -- backends, so use the queued notification after the start has completed.
    AddEventHandler(IsDuplicityVersion() and "onServerResourceStart" or "onClientResourceStart", function(resource)
        if resource ~= "pr_bridge" then refresh(resource) end
    end)
    return refresh
end
