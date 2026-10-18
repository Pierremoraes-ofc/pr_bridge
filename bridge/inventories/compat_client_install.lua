local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I,backend,natives)
    natives=natives or {}
    local previous=I._compatDisplayMetadata
    local declaration=I.displayMetadata or I.DisplayMetadata
    if previous and declaration==previous.wrapper then declaration=previous.declaration end
    local function native()
        if natives.displayMetadata then return natives.displayMetadata() end
        if S.callable(declaration) and not S.isUnavailable(declaration) then return declaration end
        return nil,'displayMetadata absent in selected resource; implement bridge/inventories/'..backend..'/client.lua:displayMetadata'
    end
    local wrapper=function(...) return S.call('inventories',backend,'displayMetadata',native,nil,...) end
    I._compatDisplayMetadata={wrapper=wrapper,declaration=declaration}
    I.displayMetadata=wrapper
    I.DisplayMetadata=I.displayMetadata
    I.GetCompatibilityCapabilities=function()
        local fn,provider=S.resolve('inventories',backend,'displayMetadata',native)
        return {displayMetadata={available=fn~=nil,provider=provider}}
    end
    return I
end
