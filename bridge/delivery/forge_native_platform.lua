-- Explicit engine/platform aliases for the private graph. No resource exports/framework resolution.
return function(ports)
    local execution,events=assert(ports.execution),assert(ports.events)
    local side,owner=assert(ports.side),assert(ports.isCurrent)
    assert(side=='server'or side=='client','platform side required')
    assert((not not execution.Native.IsDuplicityVersion())==(side=='server'),'platform native side mismatch')
    local time,locale=assert(ports.time),assert(ports.locale)
    local closed,pending=false,0;local cache={};local api={OperationalReady=false,Side=side}
    local function current()local ok,value=pcall(owner);return not closed and ok and value==true and execution.IsCurrent()end
    local function invoke(fn,...)
        assert(current(),'native platform closed');pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    local function body(fn)assert(type(fn)=='function','scheduled body required');return function(...)if current()then return invoke(fn,...)end end end
    local special={source=execution.GetSource,getSource=execution.GetSource,time=time,locale=locale,on=assert(events.listen),listen=events.listen}
    local aliases={getInvokingResource='GetInvokingResource',getPlayerName='GetPlayerName',getIdentifier='GetPlayerIdentifierByType',
        dropPlayer='DropPlayer',wait='Wait',thread='CreateThread',spawn='CreateThread',createThread='CreateThread',setTimeout='SetTimeout',
        emitClient='TriggerClientEvent',emitServer='TriggerServerEvent',emit='TriggerEvent',getPed='GetPlayerPed',setArmour='SetPedArmour',
        player='Player',entityExists='DoesEntityExist',getCoords='GetEntityCoords',getHeading='GetEntityHeading',getPlayers='GetPlayers',
        getPlayerPing='GetPlayerPing',getGameTimer='GetGameTimer',isAceAllowed='IsPlayerAceAllowed',isPlayerAceAllowed='IsPlayerAceAllowed',
        isPrincipalAceAllowed='IsPrincipalAceAllowed',getResourceState='GetResourceState',resourceState='GetResourceState',
        getResourceMetadata='GetResourceMetadata',resourceName='GetCurrentResourceName',setPlayerBucket='SetPlayerRoutingBucket',
        setEntityBucket='SetEntityRoutingBucket',deleteEntity='DeleteEntity',execute='ExecuteCommand',print='print',vec4='vec4',vec3='vec3',vec2='vec2'}
    if side=='server'then aliases.emitServer='TriggerEvent'end
    local function bind(name)
        if cache[name]then return cache[name]end
        local target=aliases[name]or name;local fn=special[name]
        if not fn then fn=execution.Bind({target})[target]end
        local wrapped
        if target=='CreateThread'then wrapped=function(callback,...)return invoke(fn,body(callback),...)end
        elseif target=='SetTimeout'then wrapped=function(delay,callback,...)return invoke(fn,delay,body(callback),...)end
        else wrapped=function(...)return invoke(fn,...)end end
        cache[name]=wrapped;return wrapped
    end
    function api.Select(names)
        assert(current(),'native platform closed');local out={}
        for _,name in ipairs(names)do out[name]=bind(name)end;return out
    end
    function api.Player()
        assert(side=='server','server Player platform required')
        return api.Select({'getInvokingResource','getPlayerName','getIdentifier','dropPlayer','locale','wait','emitClient','emitServer','on','thread',
            'getPed','setArmour','player','entityExists','getCoords','getHeading','vec4','time'})
    end
    function api.Close()closed=true;return pending==0 end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    function api.IsCurrent()return current()end
    return api
end
