local centralPath = assert(arg[1], "central cache module path is required")
local handlers = {}
local currentResource = "pr_bridge"

function GetCurrentResourceName()
    return currentResource
end

function GetResourceState(resource)
    return resource == "pr_bridge" and "started" or "missing"
end

function AddEventHandler(name, callback)
    handlers[name] = handlers[name] or {}
    handlers[name][#handlers[name] + 1] = callback
end

function TriggerEvent(name, ...)
    local callbacks = handlers[name] or {}
    for i = 1, #callbacks do
        callbacks[i](...)
    end
end

function CreateThread()
end

exports = { pr_bridge = {} }

local function newCache()
    local values = {}
    local cache = { entities = {}, peds = {}, vehicles = {}, objects = {} }

    function cache.set(first, second, third)
        local key, value
        if first == cache then
            key, value = second, third
        else
            key, value = first, second
        end
        local changed = values[key] ~= value
        values[key] = value
        return changed, value
    end

    function cache.get(first, second, third)
        local key, fallback
        if first == cache then
            key, fallback = second, third
        else
            key, fallback = first, second
        end
        local value = values[key]
        return value == nil and fallback or value
    end

    function cache.getEntity()
        return nil
    end

    return cache
end

local centralize = assert(loadfile(centralPath))()

local host = newCache()
centralize(host)

currentResource = "forge-hud"
local hud = newCache()
centralize(hud)

currentResource = "forge-radialmenu"
local radial = newCache()
