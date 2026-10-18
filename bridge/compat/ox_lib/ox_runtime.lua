-- Consumer-local ox_lib contract. Utilities are lazy imports, never an export
-- proxy to a running ox_lib. Native pr_lib APIs are deliberately left intact.
local BRIDGE = "pr_bridge"

return function(public, consumer)
    consumer = consumer or _ENV
    local compat = assert(public.ox_lib, "Install ox_phase1 before ox_runtime")
    if compat.runtimeInstalled then return compat end
    local catalog = assert(load(LoadResourceFile(BRIDGE, "bridge/compat/ox_lib/ox_catalog.lua"), "@@pr_bridge/bridge/compat/ox_lib/ox_catalog.lua", "t", consumer))()
    local context = public.context
    local installed = consumer.lib == compat
    local loading, loaded = {}, {}
    local originalRequire = consumer.require
    -- Imported consumer modules must share their globals with their caller,
    -- exactly as @ox_lib/init.lua does. Isolate only the optional namespace
    -- when an actual ox_lib instance is deliberately being preserved.
    local environment = installed and consumer or setmetatable({ lib = compat, cache = public.cache }, { __index = consumer })
    environment._G = environment
    -- Reuse the caller's native library where it is already initialised.
    -- The lean @ox_lib bootstrap loads individual native modules only once;
    -- it must not initialise framework adapters recursively.
    local nativeModules = {
        ['bridge/utils/numbers'] = public.math,
        ['bridge/utils/tables'] = public.table,
        ['bridge/utils/strings'] = public.string,
        ['bridge/utils/timer'] = public.timer,
        ['bridge/utils/waitFor'] = public.waitFor,
        ['bridge/fivem/streaming/client'] = public.fivem and public.fivem.streaming,
        ['bridge/fivem/raycast/client'] = public.fivem and public.fivem.raycast,
        ['bridge/addKeybind/client'] = public.addKeybind,
        ['bridge/addCommand/server'] = public.addCommand,
        ['bridge/triggerClientEvent/server'] = public.triggerClientEvent,
        ['bridge/fivem/proximity/shared'] = public.fivem and public.fivem.proximity,
        ['bridge/fivem/spatial/client'] = public.points and {points=public.points,zones=public.zones},
        ['bridge/fivem/objects/' .. context] = public.fivem and public.fivem.objects,
    }
    function compat.__native(path)
        if not nativeModules[path] then
            nativeModules[path] = PRCore.load('@pr_bridge/' .. path, environment)
            if path == 'bridge/fivem/proximity/shared' then
                nativeModules[path] = nativeModules[path](compat.__native('bridge/fivem/objects/' .. context), context, public.cache)
            elseif path == 'bridge/library/init' then
                nativeModules[path] = nativeModules[path](public, environment)
            end
        end
        return nativeModules[path]
    end
    compat.context = context
    local nativeLibrary = compat.__native('bridge/library/init')
    compat.hasLoaded = nativeLibrary.hasLoaded
    compat.contractVersion = catalog.version
    compat.runtimeInstalled = true
    if context == "client" then
        local ui = public.interface or {}
        for _, name in ipairs({ "closeInputDialog", "closeAlertDialog", "defaultNotify", "setMenuOptions" }) do
            if type(ui[name]) == "function" then compat[name] = ui[name] end
        end
        if public.skillCheckActive then compat.skillCheckActive = public.skillCheckActive end
        for _, name in ipairs({ "progressBar", "progressCircle", "progressActive", "cancelProgress", "skillCheck", "cancelSkillCheck", "skillCheckActive" }) do
            compat[name] = function(...) return exports[BRIDGE]:oxService(name, ...) end
        end
    end

    -- These phase-1 aliases have different signatures/protocols in ox_lib.
    -- Only the compatibility namespace changes, not public.callback etc.
    compat.callback, compat.addCommand, compat.requestAnimDict = nil, nil, nil

    local function import(module)
        if loaded[module] then return rawget(compat, module) end
        local available = catalog.modules[module]
        if not available or not (available.shared or available[context]) then return end
        if loading[module] then error(("Circular ox_lib import: %s"):format(module), 2) end
        loading[module] = true
        if module == "require" then environment.require = originalRequire end
        local chunks = {}
        for _, side in ipairs({ "shared", context }) do
            if available[side] then
                local path = ("imports/%s/%s.lua"):format(module, side)
                chunks[#chunks + 1] = assert(LoadResourceFile(BRIDGE, path), "Missing @pr_bridge/" .. path)
            end
        end
        -- Keep the logical source name expected by ox_lib's require resolver.
        local fn, err = load(table.concat(chunks, "\n"), ("@@ox_lib/imports/%s/%s.lua"):format(module, context), "t", environment)
        if not fn then loading[module] = nil; error(err, 2) end
        local ok, result = pcall(fn)
        loading[module] = nil
        if not ok then error(result, 2) end
        loaded[module] = true
        if rawget(compat, module) == nil then rawset(compat, module, result) end
        if module == "require" then
            environment.require = compat.require
            if installed then consumer.require, consumer.package = compat.require, environment.package end
        elseif module == "locale" and installed then
            consumer.locale = environment.locale
        end
        return rawget(compat, module)
    end

    setmetatable(compat, {
        __index = function(self, key)
            local module = catalog.symbols[key] or (catalog.modules[key] and key)
            if module then
                import(module)
                return rawget(self, key)
            end
            -- Resource-level services are listed explicitly by the host. An
            -- unknown name fails visibly rather than returning a no-op.
            return nil
        end,
        __call = function(self, key) return self[key] end,
    })

    -- The require module captures the original loader before installing its
    -- searchers. Giving it the lazy wrapper would recurse into itself.
    environment.require = originalRequire
    local lazyRequire = function(...) return compat.require(...) end
    local services = {
        'hasLoaded',
        "setValidCallback", "isCallbackValid", "getLocaleKey", "setLocale",
        "getVehicleProperties", "setVehicleProperties", "checkDependency", "versionCheck",
        "addAce", "removeAce", "addPrincipal", "removePrincipal", "setNuiFocus", "resetNuiFocus",
    }
    for _, name in ipairs(services) do
        if rawget(compat, name) == nil then
            compat[name] = function(...) return exports[BRIDGE]:oxService(name, ...) end
        end
    end
    if context == 'client' then compat.cache = function(key) return public.cache[key] end end
    if context == "server" then
        compat.notify = function(playerId, data)
            TriggerClientEvent("__ox_notify_" .. public.resource, playerId, data)
        end
    end

    if installed then
        consumer.cache = public.cache
        consumer.noop = consumer.noop or function() end
        consumer.require = lazyRequire
        if msgpack and msgpack.setoption then msgpack.setoption("ignore_invalid", true) end

        local intervals = compat.__native('bridge/library/init').intervals
        consumer.SetInterval, consumer.ClearInterval = intervals.set, intervals.clear
        environment.SetInterval, environment.ClearInterval = intervals.set, intervals.clear

        if context == "client" then
            RegisterNetEvent("__ox_notify_" .. public.resource, function(data)
                if type(data) ~= "table" then return end
                local translate = consumer.locale
                if translate then
                    data.title = data.title and translate(data.title)
                    data.description = data.description and translate(data.description)
                end
                compat.notify(data)
            end)
        else
            consumer.GetActivePlayers = function()
                local players = GetPlayers()
                for i = 1, #players do players[i] = tonumber(players[i]) end
                return players
            end
        end

        -- require/locale write globals in their sandbox; publish only the
        -- documented globals, without replacing the consumer's environment.
        for index = 0, GetNumResourceMetadata(public.resource, "ox_lib") - 1 do
            local value = GetResourceMetadata(public.resource, "ox_lib", index)
            local names = value and value:sub(1, 1) == "[" and json.decode(value) or { value }
            for _, name in ipairs(names) do
                local entry = compat[name]
                if type(entry) == "function" then entry() end
            end
        end
    end
    return compat
end
