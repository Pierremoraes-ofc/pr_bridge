local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
local contract=PRCore.load('@pr_bridge/bridge/frameworks/compat_contract',_ENV)
return function(F,context)
    local N={}
    local function core()
        -- Do not recurse through PR's own provided es_extended identity.
        if GetResourceMetadata('es_extended','name',0)=='pr_bridge' then return end
        local fn=H.services.exported('es_extended','getSharedObject');return fn and fn()
    end
    for _,name in ipairs(contract[context]) do
        N[name]=function()
            local esx=core();local fn=esx and esx[name]
            if H.services.callable(fn) then return fn end
        end
    end
    if context=='server' then
        N.CreateJob=function()
            local esx=core();if not esx or not H.services.callable(esx.CreateJob) then return end
            return function(input) return esx.CreateJob(input.name,input.label,input.grades,input.type) end
        end
        for legacy,name in pairs(contract.player) do
            N[name]=function() return function(source,...)
                local esx=assert(core(),'Native ESX unavailable')
                local player=assert(esx.GetPlayerFromId(source),'Invalid player')
                assert(H.services.callable(player[legacy]),'Native ESX method unavailable: '..legacy)
                return player[legacy](...)
            end end
        end
    end
    return N
end
