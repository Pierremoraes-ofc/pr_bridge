local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I)
    if ActiveBridges.frameworks=='qb' then
        return PRCore.load('@pr_bridge/bridge/inventories/qb/compat',_ENV)(I)
    end
    local N={}
    if ActiveBridges.frameworks~='esx' then return N end
    local function esx()
        if GetResourceMetadata('es_extended','name',0)=='pr_bridge' then return end
        local get=S.exported('es_extended','getSharedObject');return get and get()
    end
    for _,name in ipairs({'AddItems','RefreshItems'}) do
        N[name]=function() local core=esx();return core and core[name] end
    end
    -- Original ESX inventory owns original ESX pickups, not an Ox drop.
    N.CreatePickup=function()
        local core=esx();if not core or not S.callable(core.CreatePickup) then return end
        return function(request)
            local metadata=request.metadata or {}
            return core.CreatePickup(request.kind,request.name,metadata.ammo or request.count,request.label,
                request.source,metadata.components,metadata.tint,request.coords,request.bucket)
        end
    end
    return N
end
