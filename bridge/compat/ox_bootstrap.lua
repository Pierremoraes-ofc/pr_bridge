-- @ox_lib/init.lua may be imported by the framework itself. Do not initialize
-- framework/inventory adapters inside that framework before its exports exist.
return function(consumer, resource)
    local context = IsDuplicityVersion() and "server" or "client"
    local listeners, expires = {}, {}
    local cache = { resource = resource, game = GetGameName() }
    setmetatable(cache, {
        __index = function(self, key)
            local value = context == "client" and exports.pr_bridge:oxService("cache", key) or false
            value = value == nil and false or value
            rawset(self, key, value)
            if context == "client" then
                AddEventHandler("ox_lib:cache:" .. key, function(newValue, oldValue)
                    for _, callback in ipairs(listeners[key] or {}) do
                        CreateThread(function() callback(newValue, oldValue) end)
                    end
                    rawset(self, key, newValue)
                end)
            end
            return value
        end,
        __call = function(self, key, callback, timeout)
            local value = rawget(self, key)
            if value == nil or (expires[key] and GetGameTimer() >= expires[key]) then
                value = callback()
                rawset(self, key, value)
                expires[key] = timeout and GetGameTimer() + timeout or nil
            end
            return value
        end,
    })
    local public = { resource = resource, context = context, cache = cache }
    local lib = { name = "ox_lib", bridge = "pr_bridge", installed = true }
    public.ox_lib = lib
    lib.onCache = function(key, callback)
        assert(type(callback) == "function", "Expected cache listener")
        local _ = cache[key]
        listeners[key] = listeners[key] or {}
        listeners[key][#listeners[key] + 1] = callback
    end
    if context == "client" then
        cache.playerId, cache.serverId = PlayerId(), GetPlayerServerId(PlayerId())
        local visual = {
            "registerContext", "showContext", "hideContext", "getOpenContextMenu",
            "registerMenu", "showMenu", "hideMenu", "getOpenMenu", "setMenuOptions",
            "alertDialog", "closeAlertDialog", "inputDialog", "closeInputDialog",
            "notify", "defaultNotify", "showTextUI", "hideTextUI", "isTextUIOpen",
            "progressBar", "progressCircle", "progressActive", "cancelProgress",
            "skillCheck", "cancelSkillCheck", "skillCheckActive", "setClipboard",
            "addRadialItem", "removeRadialItem", "clearRadialItems", "registerRadial",
            "hideRadial", "disableRadial", "getCurrentRadialId",
        }
        for _, name in ipairs(visual) do
            lib[name] = function(...) return exports.pr_bridge:oxService(name, ...) end
        end
    end
    consumer.lib, consumer.cache = lib, cache
    return PRCore.load("@pr_bridge/bridge/compat/ox_runtime", consumer)(public, consumer)
end
