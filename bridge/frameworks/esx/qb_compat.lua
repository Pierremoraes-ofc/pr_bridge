-- Destination-owned native additions. Absent QB operations retain handlers
-- through qb_adapter_install and can be implemented here by the developer.
return function(F,context,I)
    return PRCore.load('@pr_bridge/bridge/frameworks/qb_native',_ENV)(F,context,I,'esx')
end
