local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I,backend,natives)
    natives=natives or {}
    local automatic={}
    if backend=='ox' and ActiveBridges.frameworks=='qbx' then
        automatic.AddItems={{resource='forge-core',export='CompatAddItems'}}
        automatic.RefreshItems={{resource='forge-core',export='CompatRefreshItems'}}
    end
    for _,name in ipairs({'AddItems','RefreshItems','CreatePickup'}) do
        I[name]=function(...) return S.call('inventories',backend,name,natives[name],automatic[name],...) end
    end
    I.GetCompatibilityCapabilities=function()
        local out={}
        for _,name in ipairs({'AddItems','RefreshItems','CreatePickup'}) do
            local fn,provider=S.resolve('inventories',backend,name,natives[name],automatic[name])
            out[name]={available=fn~=nil,provider=provider}
        end
        return out
    end
    return I
end
