local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
return function(F,context,I,backend)
    local N={}
    local function native(fn) return function() return fn end end
    N.Notify=native(function(a,b,c,d)
        local source,text,kind,length
        if context=='server' then source,text,kind,length=a,b,c,d else text,kind,length=a,b,c end
        local data=type(text)=='table' and {title=text.caption,description=text.text} or {description=tostring(text)}
        data.type=kind=='primary' and 'inform' or kind or 'inform';data.duration=length
        if context=='server' then return Bridge.notify.NotifyPlayer(source,data) end
        return Bridge.Notify(data)
    end)
    if context~='server' then return N end
    N['Player.Notify']=native(function(...) return N.Notify()(... ) end)
    if backend=='qb' or backend=='qbx' or backend=='tmc' then
        for _,name in ipairs({'SetMoney','SetGang','SetPlayerData','Logout','GetRep','AddRep','RemoveRep'}) do
            N['Player.'..name]=native(function(source,...)
                local player=assert(F.GetPlayer(source),'Player unavailable')
                local fn=player.Functions and player.Functions[name]
                assert(S.callable(fn),'Destination player method absent: '..name)
                if name=='SetMoney' then
                    local account,value=...
                    assert((Config.compatQBAccounts or {cash='cash',bank='bank'})[account],'Unmapped QB account')
                    assert(type(value)=='number' and value==value and value>=0 and value<math.huge,'Invalid amount')
                end
                if name=='SetPlayerData' then
                    local key=...
                    local reserved={money=true,citizenid=true,source=true,license=true,job=true,gang=true,items=true,charinfo=true,metadata=true}
                    assert(not reserved[key],'Reserved field; use dedicated player methods')
                end
                return fn(...)
            end)
        end
    elseif backend=='esx' then
        N['Player.SetMoney']=native(function(source,wallet,value,reason)
            assert(type(value)=='number' and value==value and value>=0 and value<math.huge,'Invalid amount')
            local account=(Config.compatQBAccounts or {cash='cash',bank='bank'})[wallet]
            assert(account,'Unmapped QB account');if account=='cash' then account='money' end
            return assert(F.GetPlayer(source),'Player unavailable').setAccountMoney(account,value,reason)
        end)
        N['Player.Save']=function()
            local save=S.exported('es_extended','SavePlayer')
            if not save then return nil,'Native ESX SavePlayer export unavailable' end
            return function(source)
                assert(F.GetPlayer(source),'Player unavailable')
                local p=promise.new();local done=false
                save(source,function(success) if not done then done=true;p:resolve(success==true) end end)
                SetTimeout(10000,function() if not done then done=true;p:reject('ESX save timed out') end end)
                return Citizen.Await(p)
            end
        end
    end
    return N
end
