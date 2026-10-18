local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(I)
    return {displayMetadata=function() return S.exported('ox_inventory','displayMetadata') end}
end
