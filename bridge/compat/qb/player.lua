return function(Q,C,catalog)
    local wrappers={}
    function C.player(source)
        source=tonumber(source);if not source or source<1 or source%1~=0 then return end
        local backend=C.target();local data=C.api().GetPlayerData(source)
        if not data or data.citizenid==nil then return end
        local identifier=data.citizenid
        local existing=wrappers[source]
        if existing and existing.identifier==identifier and existing.backend==backend then
            existing.player.PlayerData=C.copy(data);return existing.player
        end
        local player={PlayerData=C.copy(data),Offline=false,Functions={}}
        local function current()
            assert(C.target()==backend,'[PR Bridge QB] destination changed; reacquire player')
            local live=C.api().GetPlayerData(source)
            assert(live and live.citizenid==identifier and wrappers[source] and wrappers[source].player==player,
                '[PR Bridge QB] stale player session; reacquire GetPlayer')
            return live
        end
        for name in pairs(catalog.player) do
            player.Functions[name]=function(...)
                current();local result=table.pack(C.method(name,source,...))
                local live=C.api().GetPlayerData(source);if live then player.PlayerData=C.copy(live) end
                return table.unpack(result,1,result.n)
            end
        end
        player.Functions.GetPlayerData=function() return C.copy(current()) end
        player.Functions.GetName=function() local live=current();return live.name or ((live.charinfo.firstname or '')..' '..(live.charinfo.lastname or '')) end
        player.Functions.UpdateClient=function() player.PlayerData=C.copy(current());TriggerClientEvent('QBCore:Player:SetPlayerData',source,player.PlayerData) end
        player.Functions.UpdatePlayerData=player.Functions.UpdateClient
        player.Functions.AddMethod=function(name,handler)
            current();assert(type(name)=='string' and C.callable(handler),'Invalid player extension')
            assert(player.Functions[name]==nil,'Cannot overwrite an authoritative player method')
            player.Functions[name]=function(...) current();return handler(...) end
        end
        player.Functions.AddField=function(name,value)
            current();assert(type(name)=='string' and player[name]==nil,'Cannot overwrite player field')
            player[name]=C.copy(value) -- facade extension only, not native player data
        end
        wrappers[source]={identifier=identifier,backend=backend,player=player}
        return player
    end
    function C.releasePlayer(source) wrappers[tonumber(source)]=nil end
end
