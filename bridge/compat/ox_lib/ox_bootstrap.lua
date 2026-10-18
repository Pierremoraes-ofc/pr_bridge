-- @ox_lib/init.lua may be imported by the framework itself. Do not initialize
-- framework/inventory adapters inside that framework before its exports exist.
return function(consumer, resource)
    local context = IsDuplicityVersion() and "server" or "client"
    local public = { resource = resource, context = context }
    local cache = PRCore.load('@pr_bridge/bridge/cache/shared', consumer)(public, {})
    public.cache = cache
    PRCore.load('@pr_bridge/bridge/cache/state', consumer)(public, cache)
    PRCore.load('@pr_bridge/bridge/cache/central', consumer)(cache)
    PRCore.load('@pr_bridge/bridge/cache/resources', consumer)(cache)
    local lib = { name = "ox_lib", bridge = "pr_bridge", installed = true }
    public.ox_lib = lib
    lib.onCache = cache.onChange
    if context == "client" then
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
    return PRCore.load("@pr_bridge/bridge/compat/ox_lib/ox_runtime", consumer)(public, consumer)
end
