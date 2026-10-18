return function(E, C, catalog)
    PRCore.load('bridge.compat.esx.player')(E,C,catalog)
    local F,I=C.bridge.framework,C.bridge.inventory
    local define=function(name,fn) C.define(E,name,fn) end
    local usable=C.state.usable
    define('GetPlayerFromId', C.player)
    define('Player', function(id) return type(id)=='string' and E.GetPlayerFromIdentifier(id) or C.player(id) end)
    define('GetPlayers', function() local r={};for _,id in ipairs(GetPlayers()) do r[#r+1]=tonumber(id) end;return r end)
    define('GetPlayerFromIdentifier', function(identifier)
        for _,id in ipairs(E.GetPlayers()) do local p=C.player(id);if p and p.getIdentifier()==identifier then return p end end
    end)
    define('GetPlayerIdFromIdentifier', function(identifier) local p=E.GetPlayerFromIdentifier(identifier);return p and p.source end)
    define('GetIdentifier', function(id) local p=C.player(id);return p and p.getIdentifier() end)
    define('IsPlayerLoaded', function(id) return C.player(id)~=nil end)
    define('GetExtendedPlayers', function(key,value,minimal)
        local result={};if type(value)=='table' then for _,v in ipairs(value) do result[v]=E.GetExtendedPlayers(key,v,minimal) end;return result end
        for _,id in ipairs(E.GetPlayers()) do local p=C.player(id)
            if p and (not key or (key=='job' and p.getJob().name or p[key])==value) then result[#result+1]=minimal and id or p end
        end;return result
    end)
    define('ExtendedPlayers', function(key,value) return E.GetExtendedPlayers(key,value,false) end)
    define('GetNumPlayers', function(key,value)
        local players=E.GetExtendedPlayers(key,value,true)
        if type(value)=='table' then local r={};for k,v in pairs(players) do r[k]=#v end;return r end;return #players
    end)
    define('GetItems', function() return C.copy(C.invoke(I,'Items')) end)
    define('GetItemLabel', function(name) local item=C.invoke(I,'Items',name);return item and item.label end)
    define('RegisterUsableItem', function(name,cb)
        assert(type(name)=='string' and C.callable(cb))
        assert(not usable[name] or usable[name].owner==C.owner,'ESX usable item belongs to another resource')
        local result=C.invoke(I,'RegisterUsableItem',name,function(id,item,...)
            if C.closed then return false end
            return cb(id,name,item,...)
        end)
        if result==false then return false end
        usable[name]={callback=cb,owner=C.owner};return result
    end)
    define('GetUsableItems', function() local r={};for name in pairs(usable) do r[name]=true end;return r end)
    define('UseItem', function(id,name,...)
        local entry=usable[name];if not entry or not C.player(id) or C.invoke(I,'GetItemCount',id,name)<1 then return false end
        return entry.callback(id,name,...)
    end)
    define('GetJobs', function(jobType)
        C.target();local jobs=C.invoke(F,'GetFrameworkJobs');local r={}
        for name,job in pairs(jobs) do if not jobType or job.type==jobType then
            local grades={};for level,grade in pairs(job.grades or {}) do
                grades[tostring(level)]={job_name=name,grade=tonumber(level),name=grade.name,label=grade.name,
                    salary=grade.payment or 0,skin_male={},skin_female={}}
            end
            r[name]={name=name,label=job.label,type=job.type,grades=grades}
        end end;return r
    end)
    define('DoesJobExist', function(name,grade) local job=E.GetJobs()[name];return job~=nil and job.grades[tostring(grade)]~=nil end)
    define('Trace', function(message) if Config.Debug then print('[PR Bridge ESX] '..tostring(message)) end end)
    define('TriggerClientEvent', function(name,players,...)
        if type(players)=='table' then for _,id in pairs(players) do TriggerClientEvent(name,id,...) end
        else TriggerClientEvent(name,players,...) end
    end)
    define('RegisterCommand', function(names,groups,cb,allowConsole,suggestion)
        assert(C.callable(cb));local owner=C.owner
        for _,name in ipairs(type(names)=='table' and names or {names}) do
            assert(type(name)=='string' and name~='')
            C.commands=C.commands or {};C.commands[name]=owner
            RegisterCommand(name,function(id,args,raw)
                if C.closed then return end
                if id==0 and not allowConsole then return end
                local p=id>0 and C.player(id) or nil;local allowed=id==0
                for _,group in ipairs(type(groups)=='table' and groups or {groups}) do
                    allowed=allowed or group=='user' or id>0 and C.invoke(F,'HasPermission',id,group)
                end
                if not allowed then return end
                local values={}
                for index,argument in ipairs(suggestion and suggestion.arguments or {}) do
                    local v=args[index]
                    if argument.type=='number' then v=tonumber(v)
                    elseif argument.type=='player' or argument.type=='playerId' then
                        v=v=='me' and id or tonumber(v);if argument.type=='player' then v=C.player(v) end
                    elseif argument.type=='string' and v then v=tostring(v) end
                    if v==nil then return end;values[argument.name]=v
                end
                cb(p,values,function(message) if id>0 then TriggerClientEvent('esx:showNotification',id,message,'error') else print(message) end end)
            end,false)
        end
    end)
    -- Saving uses the destination's normal persistence API, not ESX SQL tables.
    define('SavePlayer', function(id,cb)
        local p=C.player(id);if not p then return false end
        local result
        if F.SaveCompatibilityPlayer then result=C.invoke(F,'SaveCompatibilityPlayer',id)
        else local raw=C.invoke(F,'GetPlayer',id);result=C.invoke(raw.Functions,'Save') end
        if cb then cb() end;return result
    end)
    define('GetVehicleType',function(model,player,cb)
        C.target();local definition=C.invoke(F,'GetVehicleData',model)
        local kind=definition and definition.type
        if not kind then
            player=tonumber(player) or E.GetPlayers()[1]
            if not player then C.unsupported('GetVehicleType','unknown model and no player available') end
            kind=E.AwaitClientCallback(player,'__pr_esx:modelType',model)
        end
        if cb then cb(kind) else return kind end
    end)
    C.serverSnapshot=function(id)
        local p=C.player(id);if not p then return end
        return {source=id,identifier=p.getIdentifier(),name=p.getName(),job=p.getJob(),
            money=p.getMoney(),accounts=p.getAccounts(),inventory=p.getInventory(),metadata=p.getMeta(),coords=p.getCoords()}
    end
    PRCore.load('bridge.compat.esx.onesync')(E,C)
    PRCore.load('bridge.compat.esx.extensions')(E,C)
    return E
end
