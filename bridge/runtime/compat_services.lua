-- Explicit capability routing. Never guess an export signature or retry a
-- denied/failed mutation through another provider. No polling or state bags.
local resources = {qbx='qbx_core',qb='qb-core',esx='es_extended',nd='ND_Core',ox='ox_core',tmc='core'}
local inventoryResources = {ox='ox_inventory',qb='qb-inventory',ps='ps-inventory',core='core_inventory',
    jaksam='jaksam_inventory',origen='origen_inventory',quasar='qs-inventory',tgiann='tgiann-inventory',
    ak47='ak47_inventory',codem='codem-inventory'}
local recent = {}
local function callable(value)
    local mt=type(value)=='table' and getmetatable(value)
    return type(value)=='function' or mt and mt.__call~=nil
end
local function started(resource)
    return resource and GetResourceState(resource)=='started'
end
local function exported(resource, name)
    if not started(resource) then return nil end
    -- exports[resource][name] may be a lazy proxy even for a missing export.
    -- Discovery is read-only and does not execute the actual service operation.
    local discovered
    TriggerEvent(('__cfx_export_%s_%s'):format(resource,name),function(fn) discovered=fn end)
    if not callable(discovered) then return nil end
    local ok,fn=pcall(function() return exports[resource][name] end)
    if ok and callable(fn) then return function(...) return fn(exports[resource],...) end end
end
local function configured(namespace, backend, operation)
    local config=Config.compatServices or {}
    local scope=config[namespace] or {}
    local specific=scope[backend] or {}
    local all=scope['*'] or {}
    if specific[operation]~=nil then return specific[operation],true end
    if all[operation]~=nil then return all[operation],true end
end
local function failure(namespace, backend, operation, reason)
    reason=tostring(reason):gsub('https?://%S+','[url]'):sub(1,700)
    local message=('[PR Bridge compat] %s.%s | caller=%s | framework=%s | inventory=%s | %s'):format(
        namespace,operation,GetInvokingResource() or GetCurrentResourceName(),
        tostring(ActiveBridges.frameworks),tostring(ActiveBridges.inventories or ActiveBridges.inventory),reason)
    local key=namespace..':'..backend..':'..operation
    local now=GetGameTimer()
    if not recent[key] or now-recent[key]>=30000 then
        recent[key]=now;print('^1'..message..'^7')
    end
    error(message,3)
end
local S={callable=callable,exported=exported,started=started,resources=resources,inventoryResources=inventoryResources}
-- Keep public declarations even when the native resource has no equivalent.
-- A developer replaces this placeholder with the implementation in its adapter.
-- The weak registry distinguishes that declaration from actual native support.
PRCore.compatUnavailableFunctions=PRCore.compatUnavailableFunctions or setmetatable({},{__mode='k'})
function S.unavailable(namespace,backend,operation,detail)
    local fn=function() return failure(namespace,backend,operation,detail or 'function absent in selected resource; implement its PR Bridge adapter') end
    PRCore.compatUnavailableFunctions[fn]=true
    return fn
end
function S.isUnavailable(fn) return PRCore.compatUnavailableFunctions[fn]==true end
function S.resolve(namespace,backend,operation,native,automatic)
    local entry,explicit=configured(namespace,backend,operation)
    if explicit then
        if entry==false then return nil,'disabled in Config.compatServices' end
        if type(entry)~='table' or type(entry.resource)~='string' or type(entry.export)~='string' then
            return nil,'invalid provider descriptor; expected {resource=..., export=...}'
        end
        local fn=exported(entry.resource,entry.export)
        return fn,fn and ('configured:'..entry.resource..':'..entry.export)
            or ('provider unavailable: '..entry.resource..':'..entry.export)
    end
    -- A known auxiliary registry owns its persistence. Do not fall back to
    -- core-only runtime writes while that authoritative registry is starting.
    if automatic then
        for _,provider in ipairs(automatic) do
            local state=GetResourceState(provider.resource)
            if state=='starting' then return nil,'provider starting: '..provider.resource end
            if state=='started' then
                local fn=exported(provider.resource,provider.export)
                return fn,fn and ('service:'..provider.resource..':'..provider.export)
                    or ('missing export: '..provider.resource..':'..provider.export)
            end
            if state=='stopped' or state=='stopping' then return nil,'provider unavailable: '..provider.resource end
        end
    end
    if native then
        local fn,reason=native()
        if callable(fn) then return fn,'native:'..backend end
        if reason then return nil,reason end
    end
    return nil,'no equivalent API; configure a contract adapter in Config.compatServices'
end
function S.call(namespace,backend,operation,native,automatic,...)
    local resolved=table.pack(pcall(S.resolve,namespace,backend,operation,native,automatic))
    if not resolved[1] then return failure(namespace,backend,operation,'provider resolution failed: '..tostring(resolved[2])) end
    local fn,reason=resolved[2],resolved[3]
    if not fn then return failure(namespace,backend,operation,reason) end
    local result=table.pack(pcall(fn,...))
    if not result[1] then return failure(namespace,backend,operation,'provider error: '..tostring(result[2])) end
    return table.unpack(result,2,result.n)
end
return S
