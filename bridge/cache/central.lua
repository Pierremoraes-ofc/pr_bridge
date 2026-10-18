-- Explicit local requests only: no push streams, mirroring or bootstrap snapshots.
local common={
    game=true,playerId=true,serverId=true,ped=true,vehicle=true,seat=true,
    weapon=true,coords=true,interior=true,dead=true,entityCount=true,playerCount=true,
    seatbelt=true,playerLoaded=true,playerData=true,job=true,gang=true,groups=true,
    cash=true,bank=true,dirtyMoney=true,isDead=true,health=true,armor=true,
    hunger=true,thirst=true,stress=true,oxygen=true,stamina=true,playerStatus=true,
    pr_bridge_locale=true,pr_bridge_ui_config=true,
}
local function shallowRecord(record)
    if type(record)~='table' then return nil end
    return {entity=record.entity,id=record.id,type=record.type,networked=record.networked,
        netId=record.netId,coords=record.coords,model=record.model}
end
return function(cache)
    local host=GetCurrentResourceName()=='pr_bridge'
    local baseSet,baseGet,baseClear,baseClearPrefix,basePatch=cache.set,cache.get,cache.clear,cache.clearPrefix,cache.patch
    local function arguments(first,second,third,fourth)
        if first==cache then return second,third,fourth end
        return first,second,third
    end
    local function stateKey(key) return cache._stateKey and cache._stateKey(key) end
    local function sharedKey(key)
        if type(key)~='string' then return nil end
        local canonical=stateKey(key)
        if canonical then return canonical end
        if common[key] or key=='player:self' or key:match('^player:%d+$')
            or key:match('^metadata:[^:]+:.+$') then return key end
    end
    local function sharedPrefix(prefix)
        if type(prefix)~='string' then return nil end
        return cache._statePrefix and cache._statePrefix(prefix)
            or prefix:match('^metadata:[^:]+:') and prefix or nil
    end
    local function access(operation,key,value,ttl)
        return pcall(function() return exports.pr_bridge:accessCacheState(operation,key,value,ttl) end)
    end
    local function requireAccess(operation,key,value,ttl)
        local ok,changed,stored=access(operation,key,value,ttl)
        if not ok then error('PR Bridge shared cache unavailable: '..tostring(changed),3) end
        return changed,stored
    end
    cache.set=function(first,second,third,fourth)
        local key,value,ttl=arguments(first,second,third,fourth)
        local shared=sharedKey(key)
        if not host and shared then return requireAccess('set',shared,value,ttl) end
        return baseSet(shared or key,value,ttl)
    end
    cache.get=function(first,second,third)
        local key,fallback=arguments(first,second,third)
        local shared=sharedKey(key)
        if host or not shared then return baseGet(shared or key,fallback) end
        local ok,value=access('get',shared)
        if not ok or value==nil then return fallback end
        return value
    end
    cache.patch=function(first,second,third)
        local key,fields=arguments(first,second,third)
        local shared=sharedKey(key)
        if not host and shared then return requireAccess('patch',shared,fields) end
        return basePatch(shared or key,fields)
    end
    local clearingPrivate=false
    cache.clear=function(first,second)
        local key=arguments(first,second)
        local shared=sharedKey(key)
        if not host and shared then
            if clearingPrivate then return false end
            return requireAccess('clear',shared)
        end
        if key==nil and not host then
            local previous=clearingPrivate
            clearingPrivate=true
            local ok,result=pcall(baseClear)
            clearingPrivate=previous
            if not ok then error(result,2) end
            return result
        end
        return baseClear(shared or key)
    end
    cache.clearPrefix=function(first,second)
        local prefix=arguments(first,second)
        local shared=sharedPrefix(prefix)
        if not host and shared then return requireAccess('clearPrefix',shared) end
        return baseClearPrefix(shared or prefix)
    end
    local baseOn,baseOff=cache.onChange,cache.off
    cache.onChange=function(first,second,third)
        local key,callback=arguments(first,second,third)
        return baseOn(sharedKey(key) or key,callback)
    end
    cache.off=function(first,second,third)
        local key,id=arguments(first,second,third)
        return baseOff(sharedKey(key) or key,id)
    end
    cache.on=cache.onChange
    cache.setShared=function(first,second,third,fourth)
        local key,value,ttl=arguments(first,second,third,fourth)
        key=assert(sharedKey(key),'invalid shared cache key')
        return cache.set(key,value,ttl)
    end
    if host then
        function cache.accessStateCache(operation,key,value,ttl)
            if operation=='clearPrefix' then return cache.clearPrefix(assert(sharedPrefix(key),'invalid shared prefix')) end
            key=assert(sharedKey(key),'invalid shared cache key')
            if operation=='get' then return cache.get(key) end
            if operation=='set' then return cache.set(key,value,ttl) end
            if operation=='patch' then return cache.patch(key,value) end
            if operation=='clear' then return cache.clear(key) end
            error('invalid cache state operation')
        end
        -- Receiving an explicit producer publication is not a collection/push.
        AddEventHandler('pr_bridge:cache:publish',function(key,value,ttl)
            if sharedKey(key) then cache.set(key,value,ttl) end
        end)
        function cache.getSnapshot()
            local result={}
            for key in pairs(common) do
                local value=cache.get(key)
                if value~=nil then result[key]=value end
            end
            return result
        end
        function cache.getEntitySnapshot(id) return shallowRecord(cache.getEntity(id)) end
        function cache.getEntities(kind)
            local source,result=kind and cache[kind] or cache.entities,{}
            if type(source)~='table' then return result end
            for id,record in pairs(source) do result[id]=shallowRecord(record) end
            return result
        end
    else
        function cache.getSnapshot()
            local ok,result=pcall(function() return exports.pr_bridge:getCacheSnapshot() end)
            return ok and type(result)=='table' and result or {}
        end
        local getEntity=cache.getEntity
        cache.getEntity=function(first,second)
            local id=arguments(first,second)
            local record=getEntity(id)
            if record then return record end
            local ok,result=pcall(function() return exports.pr_bridge:getCachedEntity(id) end)
            if not ok or type(result)~='table' then return nil end
            if cache._entityState and result.entity then result.state=cache._entityState(result.entity) end
            return result
        end
        cache.entity=cache.getEntity
        function cache.getEntities(kind)
            local ok,result=pcall(function() return exports.pr_bridge:getCachedEntities(kind) end)
            return ok and type(result)=='table' and result or {}
        end
    end
    return cache
end
