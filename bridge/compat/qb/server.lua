return function(Q,C,catalog,state)
    PRCore.load('bridge.compat.qb.player',_ENV)(Q,C,catalog)
    local function define(name,fn) C.define(Q.Functions,name,fn);C.supported[name]=nil;C.supported['Functions.'..name]='adapted' end
    define('GetPlayer',C.player)
    define('GetPlayers',function() local ids={};for _,id in ipairs(GetPlayers()) do ids[#ids+1]=tonumber(id) end;return ids end)
    define('GetQBPlayers',function() local result={};for _,id in ipairs(Q.Functions.GetPlayers()) do local player=C.player(id);if player then result[id]=player end end;return result end)
    define('GetPlayerByCitizenId',function(id)
        for _,source in ipairs(Q.Functions.GetPlayers()) do local p=C.player(source);if p and p.PlayerData.citizenid==id then return p end end
    end)
    define('GetPlayerByLicense',function(license)
        for _,source in ipairs(Q.Functions.GetPlayers()) do
            for _,id in ipairs(GetPlayerIdentifiers(source)) do if id==license then return C.player(source) end end
        end
    end)
    define('GetIdentifier',function(source,kind)
        kind=(kind or 'license')..':'
        for _,id in ipairs(GetPlayerIdentifiers(source)) do if id:sub(1,#kind)==kind then return id end end
    end)
    define('GetSource',function(identifier)
        for _,source in ipairs(Q.Functions.GetPlayers()) do
            for _,id in ipairs(GetPlayerIdentifiers(source)) do if id==identifier then return source end end
        end;return 0
    end)
    define('GetPlayerByCharInfo',function(property,value)
        for _,p in pairs(Q.Functions.GetQBPlayers()) do if (p.PlayerData.charinfo or {})[property]==value then return p end end
    end)
    define('GetPlayerByPhone',function(number) return Q.Functions.GetPlayerByCharInfo('phone',number) end)
    define('GetPlayerByAccount',function(number) return Q.Functions.GetPlayerByCharInfo('account',number) end)
    define('GetPlayersByJob',function(name,onDuty)
        local result={};for source,p in pairs(Q.Functions.GetQBPlayers()) do
            local job=p.PlayerData.job or {};if job.name==name and (not onDuty or job.onduty) then result[#result+1]=source end
        end;return result,#result
    end)
    define('GetPlayersOnDuty',function(name) return Q.Functions.GetPlayersByJob(name,true) end)
    define('GetDutyCount',function(name) local _,count=Q.Functions.GetPlayersOnDuty(name);return count end)
    define('Kick',function(source,reason) assert(GetPlayerName(source),'Invalid player');DropPlayer(source,reason or 'Disconnected') end)
    define('GetCoords',function(entity) local c=GetEntityCoords(entity);return vector4(c.x,c.y,c.z,GetEntityHeading(entity)) end)
    define('CreateUseableItem',function(name,handler)
        if not C.callable(handler) and type(handler)=='table' then handler=handler.cb or handler.callback end
        assert(type(name)=='string' and C.callable(handler),'Invalid usable item')
        local previous=state.usables[name];assert(not previous or previous.owner==C.owner,'Usable item belongs to another resource')
        local ok=true
        if not state.usableRegistered[name] then
            ok=Bridge.inventory.RegisterUsableItem(name,function(source,item)
                local current=state.usables[name]
                if not current then return false end
                return current.func(source,item)
            end)
            if ok==false then return false end
            state.usableRegistered[name]=true
        end
        state.usables[name]={owner=C.owner,func=function(...)
            if C.closed then return false end;return handler(...)
        end}
        return ok
    end)
    define('CanUseItem',function(name) return C.copy(state.usables[name]) end)
    define('UseItem',function(source,item)
        assert(type(item)=='table' and type(item.name)=='string' and type(item.slot)=='number','UseItem requires actual inventory slot')
        local live=Bridge.inventory.GetSlot(source,item.slot)
        if not live or live.name~=item.name or (live.count or live.amount or 0)<1 then return false end
        local use=state.usables[item.name];if not use or not C.player(source) then return false end
        return use.func(source,C.copy(live))
    end)
    define('AddItem',function(name,data)
        if C.api().GetShared('Items')[name] then return false,'item_exists' end
        data=C.copy(data);data.name=name
        if data.stack==nil then data.stack=data.unique~=true end
        return Bridge.framework.AddItems({data})
    end)
    define('AddItems',function(items)
        local list={};for name,data in pairs(items) do
            data=C.copy(data);data.name=data.name or name
            if data.stack==nil then data.stack=data.unique~=true end
            list[#list+1]=data
        end
        return Bridge.framework.AddItems(list)
    end)
    define('AddJob',function(name,data)
        if C.api().GetShared('Jobs')[name] then return false,'job_exists' end
        local grades={};for level,grade in pairs(data.grades or {}) do
            grades[#grades+1]={grade=tonumber(level),name=grade.name,label=grade.name,salary=grade.payment,isboss=grade.isboss}
        end
        return Bridge.framework.CreateJob({name=name,label=data.label,type=data.type,grades=grades})
    end)
    define('AddJobs',function(jobs) for name,data in pairs(jobs) do local ok,reason=Q.Functions.AddJob(name,data);if ok==false then return false,reason end end;return true end)
    Q.Player={}
    for name in pairs(catalog.lifecycle) do Q.Player[name]=function(...) return C.api().Lifecycle[name](...) end end
    Q.Player.Save=function(source) local p=C.player(source);return p and p.Functions.Save() end
    Q.Commands={List={}}
    Q.Commands.Add=function(name,help,args,required,callback,permission,...)
        C.target();assert(type(name)=='string' and name:match('^[%w_%-]+$') and C.callable(callback),'Invalid command')
        local permissions={permission or 'user',...};local old=state.commands[name]
        assert(not old or old.owner==C.owner,'Command belongs to another resource')
        local command={owner=C.owner,name=name,help=help,arguments=args or {},callback=callback,permission=permissions}
        state.commands[name]=command;Q.Commands.List[name]=C.copy(command)
        RegisterCommand(name,function(source,values,raw)
            if C.closed or state.commands[name]~=command then return end
            local allowed=source==0
            for _,group in ipairs(permissions) do allowed=allowed or group=='user' or Bridge.framework.HasPermission(source,group) end
            if not allowed or required and #values<#command.arguments then return end
            callback(source,values,raw)
        end,false)
    end
    Q.Commands.Refresh=function(source)
        C.target();local suggestions={}
        for name,command in pairs(state.commands) do
            local allowed=false;for _,group in ipairs(command.permission) do allowed=allowed or group=='user' or Bridge.framework.HasPermission(source,group) end
            if allowed then suggestions[#suggestions+1]={name='/'..name,help=command.help,params=command.arguments}
            else TriggerClientEvent('chat:removeSuggestion',source,'/'..name) end
        end
        TriggerClientEvent('chat:addSuggestions',source,suggestions)
    end
    Q.PlayersByCitizenId={};Q.UsableItems={}
    function C.refreshPlayers()
        local players=Q.Functions.GetQBPlayers()
        for id in pairs(Q.Players) do Q.Players[id]=nil end
        for id in pairs(Q.PlayersByCitizenId) do Q.PlayersByCitizenId[id]=nil end
        for id,p in pairs(players) do Q.Players[id]=p;Q.PlayersByCitizenId[p.PlayerData.citizenid]=p end
        Q.UsableItems=C.copy(state.usables)
    end
end
