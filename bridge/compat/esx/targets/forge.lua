-- Native Forge player methods; unsupported ESX operations remain explicit capabilities.
return function(F,context)
    local N={}
    if context~='server'then return N end
    N.SetPlayerAccountMoney=function()
        return function(source,account,amount,reason)
            local player=assert(F.GetPlayer(source),'Invalid player')
            return assert(player.Functions.SetMoney,'Native Forge SetMoney unavailable')(account,amount,reason)
        end
    end
    N.SaveCompatibilityPlayer=function()
        return function(source)
            local player=assert(F.GetPlayer(source),'Invalid player')
            return assert(player.Functions.Save,'Native Forge Save unavailable')()
        end
    end
    return N
end
