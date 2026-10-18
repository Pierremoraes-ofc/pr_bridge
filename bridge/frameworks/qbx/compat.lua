local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
return function(F,context)
    local N={}
    if context~='server' then return N end
    local function api(name) return H.services.exported('qbx_core',name) end
    N.CreateJob=function()
        local create,get=api('CreateJob'),api('GetJobs')
        if not create or not get then return nil,'qbx_core CreateJob/GetJobs unavailable' end
        return function(input)
            local job,added=H.qbJob(input,get()[input.name])
            if not added then return false,'job_or_grades_exist' end
            -- Native commitToFile is explicit; default preserves shared files.
            return create(input.name,job,Config.compatCommitJobs==true)
        end
    end
    N.RefreshJobs=function() local get=api('GetJobs');return get and function() return get() end end
    N.RefreshJob=function() local get=api('GetJobs');return get and function(name) return get()[name] end end
    N.SetPlayerName=function() return H.displayName(F) end
    N.GetSSN=function() return H.metadataValue(F,(Config.compatMetadata or {}).ssn or 'ssn') end
    N.SetPlayerAccountMoney=function()
        return function(source,account,amount,reason)
            local player=assert(F.GetPlayer(source),'Invalid player')
            return player.Functions.SetMoney(account,amount,reason)
        end
    end
    N.SaveCompatibilityPlayer=function() return function(source)
        local player=assert(F.GetPlayer(source),'Invalid player');return player.Functions.Save()
    end end
    return N
end
