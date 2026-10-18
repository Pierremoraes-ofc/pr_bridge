-- Destination tmc: native services not supplied by this core must be
-- declared as normalized provider exports in Config.compatServices.frameworks.tmc.
return function(F,context)
    local N={}
    if context=='server' then
        local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
        N.SetPlayerName=function() return H.displayName(F) end
        N.GetSSN=function() return H.metadataValue(F,(Config.compatMetadata or {}).ssn or 'ssn') end
    end
    return N
end
