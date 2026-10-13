-- One lazy, consumer-owned PR library. Nothing here imports ox_lib or initialises
-- framework adapters. Existing pr_lib.player/locale/load keep their contracts.
return function(public, environment)
    environment = environment or _ENV
    if rawget(public, 'library') then return public.library end
    local shared=rawget(environment,'__prCanonicalLibrary')
    if shared then
        public.library,public.collections,public.entities=shared,shared.collections,shared.entities
        shared.cache=public.cache or shared.cache
        shared.nativeDui=public.fivem and public.fivem.dui or shared.nativeDui
        shared.nativeStreaming=public.fivem and public.fivem.streaming or shared.nativeStreaming
        return shared
    end
    local context = public.context or PRCore.context
    local api = { context = context, cache = public.cache, originalRequire=environment.require }
    api.nativeDui = public.fivem and public.fivem.dui
    api.nativeStreaming = public.fivem and public.fivem.streaming
    local paths = {
        class='bridge/utils/class', array='bridge/collections/array', map='bridge/collections/map',
        set='bridge/collections/set', heap='bridge/collections/heap', lru='bridge/collections/lru',
        ringbuffer='bridge/collections/ringbuffer', selector='bridge/collections/selector',
        grid='bridge/fivem/grid/shared', uuid='bridge/utils/uuid', print='bridge/logging/console',
        hook='bridge/hooks/pipeline', registerHook='bridge/hooks/event', require='bridge/files/loader',
        locale='bridge/i18n/consumer', gameEntity='bridge/entities/gameEntity',
        ped='bridge/entities/ped', prop='bridge/entities/prop', vehicle='bridge/entities/vehicle',
        player='bridge/entities/player', zones='bridge/fivem/zones/shared',
        getRelativeCoords='bridge/fivem/relativeCoords/shared',
    }
    if context == 'client' then
        paths.dui='bridge/entities/dui'
        paths.marker='bridge/fivem/marker/client'
        paths.scaleform='bridge/fivem/scaleform/client'
    else
        paths.cron='bridge/tasks/cron'
        paths.logger='bridge/logging/server'
        paths.getFilesInDirectory='bridge/files/directory/server'
    end
    local direct = { math='bridge/utils/numbers', table='bridge/utils/tables',
        timer='bridge/utils/timer', waitFor='bridge/utils/waitFor', callback='bridge/callback/'..context,
        intervals='bridge/tasks/interval', localeSettings='bridge/i18n/settings' }
    local aliases={load='require',loadJson='require',package='require',translate='locale',getLocales='locale',getLocale='locale'}
    local loading = {}
    function api.module(path)
        api._modules = api._modules or {}
        if not api._modules[path] then api._modules[path] = PRCore.load('@pr_bridge/' .. path, environment) end
        return api._modules[path]
    end
    setmetatable(api, { __index = function(self, name)
        if aliases[name] then
            local module=self[aliases[name]]
            return rawget(self,name)
        end
        local path = paths[name] or direct[name]
        if not path then return nil end
        assert(not loading[name], 'Circular PR library module: ' .. name)
        loading[name] = true
        local ok, value = pcall(function()
            local module = api.module(path)
            if name == 'table' or name == 'math' then
                local standard = environment[name]
                return setmetatable({}, {__index=function(_,key) return module[key] or standard[key] end})
            end
            return paths[name] and module(api) or module
        end)
        loading[name] = nil
        if not ok then error(value, 2) end
        rawset(self, name, value)
        return value
    end })
    api.collections = setmetatable({}, { __index=function(_, key)
        if paths[key] and paths[key]:find('bridge/collections/', 1, true) then return api[key] end
    end })
    api.entities = setmetatable({}, { __index=function(_, key)
        if paths[key] and paths[key]:find('bridge/entities/', 1, true) then return api[key] end
    end })
    public.library, public.collections, public.entities = api, api.collections, api.entities
    rawset(environment,'__prCanonicalLibrary',api)
    api.hasLoaded=function() return true end
    api.getLocaleKey=function() return api.localeSettings.getKey() end
    api.setLocale=function(key) return api.localeSettings.setKey(key) end
    -- Asset loaders reuse the exact streaming module already used by pr_lib.
    if context == 'client' then
        local streaming
        local function assets() streaming = api.nativeStreaming or streaming or api.module('bridge/fivem/streaming/client'); return streaming end
        for _, name in ipairs({'requestModel','requestScaleformMovie','requestStreamedTextureDict'}) do
            api[name] = function(asset,timeout,...)
                local ok,value=assets()[name](asset,timeout or (name=='requestScaleformMovie' and 1000 or 30000),...)
                assert(ok,'Failed to load '..name..': '..tostring(asset))
                return value or asset
            end
        end
        api.streaming = setmetatable({}, { __index=function(_, key) return assets()[key] end })
    end
    return api
end
