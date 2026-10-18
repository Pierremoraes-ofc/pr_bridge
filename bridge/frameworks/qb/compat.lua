local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
return function(F,context)
    local N={}
    if context~='server' then return N end
    local function core()
        local fn=H.services.exported('qb-core','GetCoreObject');return fn and fn()
    end
    N.CreateJob=function()
        local qb=core();if not qb then return nil,'qb-core unavailable' end
        local add=H.services.exported('qb-core','AddJob')
        local update=H.services.exported('qb-core','UpdateJob')
        if not add or not update then return nil,'qb-core AddJob/UpdateJob unavailable' end
        return function(input)
            local previous=qb.Shared.Jobs[input.name]
            local job,added=H.qbJob(input,previous);if not added then return false,'job_or_grades_exist' end
            return (previous and update or add)(input.name,job)
        end
    end
    N.RefreshJobs=function() local qb=core();return qb and function() return qb.Shared.Jobs end end
    N.RefreshJob=function() local qb=core();return qb and function(name) return qb.Shared.Jobs[name] end end
    N.SetPlayerName=function() return H.displayName(F) end
    N.GetSSN=function() return H.metadataValue(F,(Config.compatMetadata or {}).ssn or 'ssn') end
    N.SetPlayerAccountMoney=function() return function(source,account,amount,reason)
        return assert(F.GetPlayer(source),'Invalid player').Functions.SetMoney(account,amount,reason)
    end end
    N.SaveCompatibilityPlayer=function() return function(source) return assert(F.GetPlayer(source),'Invalid player').Functions.Save() end end
    return N
end
