-- Host only. Never start es_extended or create an ESX player/database alongside QBX.
if not Config.compatFramework or Config.compatFramework=='off' then return end
local context=PRCore.context
local server=context=='server'
local routing=Bridge.frameworkRouting or PRCore.load('bridge.compat.framework_routing')(ActiveBridges,Config)
local function original()
    local state=GetResourceState('es_extended')
    return (state=='started' or state=='starting') and GetResourceMetadata('es_extended','name',0)~='pr_bridge'
end
if original() then return end
local catalog=PRCore.load('bridge.compat.esx.catalog')
local instances,state={}, {callbacks={},rates={},usable={}}
local activeConsumers,nativeHandlers=0,{}
local activate
local cancelSync=function() end
local function listen(name,callback,network)
    if network then RegisterNetEvent(name) end
    nativeHandlers[#nativeHandlers+1]=AddEventHandler(name,callback)
end
local function deactivate()
    cancelSync()
    for _,handle in ipairs(nativeHandlers) do RemoveEventHandler(handle) end
    nativeHandlers={}
end
local function firstConsumer()
    for owner,instance in pairs(instances) do if owner~='pr_bridge' then return instance end end
end
local function budget(id)
    local now=GetGameTimer();local rate=state.rates[id]
    if not rate or now-rate.time>=10000 then rate={time=now,count=0};state.rates[id]=rate end
    rate.count=rate.count+1;return rate.count<=64
end
local function get(owner)
    owner=owner or GetInvokingResource() or 'pr_bridge'
    if original() then return exports.es_extended:getSharedObject() end
    routing.assertAllowed('esx',owner)
    if instances[owner] then return instances[owner].E end
    local E={};local C=PRCore.load('bridge.compat.esx.common')(Bridge,context,owner)
    C.state=state
    C.routing=routing
    if not server then
        C.clientHandlers={}
        local env=setmetatable({GetCurrentResourceName=function() return owner end,
            AddEventHandler=function(name,cb)
                local handle=AddEventHandler(name,cb)
                C.clientHandlers[#C.clientHandlers+1]=handle;return handle
            end},{__index=_ENV})
        env._G=env;C.ui=PRCore.load('@pr_bridge/interface/client/ui',env)
    end
    PRCore.load('bridge.compat.esx.shared')(E,C)
    local scope=setmetatable({GetCurrentResourceName=function() return owner end},{__index=_ENV});scope._G=scope
    local files={cache={resource=owner},originalRequire=require}
    PRCore.load('@pr_bridge/bridge/files/loader',scope)(files)
    C.define(E,'load',files.load);C.define(E,'loadJson',files.loadJson);C.define(E,'require',files.require)
    PRCore.load('bridge.compat.esx.'..context)(E,C,catalog)
    PRCore.load('bridge.compat.esx.callbacks')(E,C,state)
    C.finish(E,catalog)
    instances[owner]={E=E,C=C}
    if owner~='pr_bridge' then activeConsumers=activeConsumers+1;activate() end
    if not server then
        local ok,reason=pcall(C.sync,false)
        if not ok then C.report('player view',reason) end
    end
    return E
end
state.engine=PRCore.load('bridge.callback.transport')({
    server=server,timeout=10000,rejectErrors=true,responseEvent='pr_bridge:esx:reply',
    requestEvent=function(name) return 'pr_bridge:esx:request:'..name end,
    acceptResponse=function(player,target) return server and tonumber(player)==tonumber(target) or not server and player==65535 end,
    acceptRequest=function(player,_,key)
        if type(key)~='string' or #key>=512 then return false end
        if server then local id=tonumber(player);return id and id>0 and budget(id) end
        return player==65535
    end,
    validateTarget=server and function(id) assert(type(id)=='number' and id>0 and GetPlayerName(id),'Invalid ESX callback target') end or nil,
    parseRequest=function(key,...) return nil,key,table.pack(...) end,
    send=function(name,target,key,...)
        if server then TriggerClientEvent('pr_bridge:esx:request:'..name,target,key,...)
        else TriggerServerEvent('pr_bridge:esx:request:'..name,key,...) end
    end,
    reply=function(player,_,key,...)
        if server then TriggerClientEvent('pr_bridge:esx:reply',player,key,...)
        else TriggerServerEvent('pr_bridge:esx:reply',key,...) end
    end,
    onError=function(message) print('[PR Bridge ESX] '..tostring(message)) end,
})
exports('getESXObject',function() return get() end)
local function publish(name,fn)
    AddEventHandler('__cfx_export_es_extended_'..name,function(setCallback) if not original() then setCallback(fn) end end)
end
publish('getSharedObject',function() return get() end)
AddEventHandler('esx:getSharedObject',function(cb)
    -- Local server scripts only; a network sender must never receive privileged objects.
    if server and tonumber(source) and tonumber(source)>0 then return end
    if type(cb)=='function' or type(cb)=='table' and getmetatable(cb) then cb(get()) end
end)
if server then
    publish('RunStaticPlayerMethod',function(id,name,...)
        local E=get();local p=E.GetPlayerFromId(id);if not p then return end
        assert(catalog.player[name],'Unknown static ESX player method');return p[name](...)
    end)
    publish('SavePlayer',function(id,cb) return get().SavePlayer(id,cb) end)
    for _,name in ipairs({'StoreJobVehicle','WithPlayerPersistence'}) do
        publish(name,function() error('[PR Bridge ESX] '..name..' requires a destination-specific persistence contract') end)
    end
    RegisterNetEvent('esx:triggerServerCallback',function(name,request,invoker,...)
        local id=tonumber(source);if not id or id<1 or type(name)~='string' or #name>128
            or type(request)~='number' or request<0 or request%1~=0
            or type(invoker)~='string' or #invoker>128 then return end
        if not budget(id) then return end
        local callback=state.callbacks[name];if not callback then TriggerClientEvent('esx:serverCallback',id,request,invoker,nil);return end
        local values=table.pack(pcall(callback.wrapped,id,...))
        if values[1] then TriggerClientEvent('esx:serverCallback',id,request,invoker,table.unpack(values,2,values.n)) end
    end)
    local function unload(id)
        id=tonumber(id);if not id then return end;state.rates[id]=nil
        for _,instance in pairs(instances) do instance.C.invalidatePlayer(id) end
        if activeConsumers>0 then TriggerEvent('esx:playerDropped',id) end
    end
    activate=function()
        if #nativeHandlers>0 then return end
        listen('pr_bridge:server:OnPlayerUnloaded',unload)
        listen('playerDropped',function() unload(source) end)
        listen('pr_bridge:server:OnPlayerLoaded',function(id)
            local instance=firstConsumer();if not instance then return end
            local p=instance.E.GetPlayerFromId(id);if not p then return end
            TriggerEvent('esx:playerLoaded',id,p,false)
            -- Client lifecycle is emitted once after its cache commits.
        end)
    end
else
    state.engine.register('__pr_esx:modelType',function(model) return get('pr_bridge').GetVehicleTypeClient(model) end)
    local publishedData={}
    local function same(a,b)
        if type(a)~=type(b) then return false end
        if type(a)~='table' then return a==b end
        for key,value in pairs(a) do if not same(value,b[key]) then return false end end
        for key in pairs(b) do if a[key]==nil then return false end end
        return true
    end
    local function sync(emit)
        if activeConsumers==0 then return end
        local snapshot,copy
        local batch={}
        for owner,instance in pairs(instances) do
            if owner~='pr_bridge' then
                local ok,data=pcall(instance.C.sync,false,batch)
                if ok and not snapshot then snapshot,copy=data,instance.C.copy end
                if not ok then instance.C.report('player view',data) end
            end
        end
        if not snapshot then return end
        -- These are global legacy events. Publishing once per instance would
        -- multiply every consumer callback by the number of importing resources.
        if emit then
            local keys={};for key in pairs(snapshot) do keys[key]=true end;for key in pairs(publishedData) do keys[key]=true end
            for key in pairs(keys) do if not same(snapshot[key],publishedData[key]) then
                TriggerEvent('esx:setPlayerData',key,copy(snapshot[key]),copy(publishedData[key]))
            end end
        end
        publishedData=copy(snapshot)
        return snapshot
    end
    local queued,loadedQueued,jobQueued,generation=false,false,false,0
    cancelSync=function()
        generation=generation+1;queued=false;loadedQueued=false;jobQueued=false
    end
    local function queueSync(kind)
        if activeConsumers==0 then return end
        loadedQueued=loadedQueued or kind=='loaded';jobQueued=jobQueued or kind=='job'
        if queued then return end
        queued=true;local token=generation
        SetTimeout(0,function()
            if token~=generation then return end
            queued=false
            local emitLoaded,emitJob=loadedQueued,jobQueued;loadedQueued=false;jobQueued=false
            local snapshot=sync(true);if not snapshot then return end
            if emitLoaded then TriggerEvent('esx:playerLoaded',snapshot,false,{}) end
            if emitJob then TriggerEvent('esx:setJob',snapshot.job) end
        end)
    end
    activate=function()
        if #nativeHandlers>0 then return end
        listen('pr_bridge:client:OnPlayerLoaded',function() queueSync('loaded') end)
        listen('pr_bridge:client:OnPlayerUnloaded',function()
            cancelSync()
            for _,instance in pairs(instances) do instance.E.PlayerData={};instance.E.PlayerLoaded=false end
            publishedData={};TriggerEvent('esx:onPlayerLogout')
        end)
        -- Native player-data/inventory notifications already reach this event
        -- through PR's lifecycle. Do not subscribe to SetPlayerData a second time.
        listen('pr_bridge:client:OnInventoryChanged',function() queueSync() end)
        listen('QBCore:Client:OnJobUpdate',function() queueSync('job') end,true)
        listen('QBCore:Client:SetDuty',function() queueSync() end,true)
    end
    for _,name in ipairs({'showNotification','showAdvancedNotification','showHelpNotification'}) do
        RegisterNetEvent('esx:'..name,function(...) if source==65535 then get('pr_bridge')[name:sub(1,1):upper()..name:sub(2)](...) end end)
    end
    RegisterNetEvent('esx:executeCommand',function(command) if source==65535 and type(command)=='string' then ExecuteCommand(command) end end)
    RegisterNetEvent('pr_bridge:esx:weaponUpdated',function(slot,name,key,value)
        if source~=65535 or type(slot)~='number' or type(name)~='string' or type(value)~='number' then return end
        if key~='ammo' and key~='tint' then return end
        local current=Bridge.inventory.getCurrentWeapon and Bridge.inventory.getCurrentWeapon()
        if current and current.slot==slot and current.name==name then
            if key=='ammo' then SetPedAmmo(PlayerPedId(),current.hash,value)
            else SetPedWeaponTintIndex(PlayerPedId(),current.hash,value) end
        end
        queueSync()
    end)
    RegisterNetEvent('pr_bridge:esx:weaponAttachment',function(slot,name,hash,add)
        if source~=65535 or type(slot)~='number' or type(name)~='string' or type(hash)~='number' or type(add)~='boolean' then return end
        local current=Bridge.inventory.getCurrentWeapon and Bridge.inventory.getCurrentWeapon()
        if current and current.slot==slot and current.name==name then
            if add then GiveWeaponComponentToPed(PlayerPedId(),current.hash,hash)
            else RemoveWeaponComponentFromPed(PlayerPedId(),current.hash,hash) end
        end
        queueSync()
    end)
    RegisterNetEvent('esx:updatePlayerData',function(key,value)
        if source~=65535 or key~='variables' or type(value)~='table' then return end
        for _,instance in pairs(instances) do instance.E.PlayerData.variables=instance.C.copy(value) end
        TriggerEvent('esx:setPlayerData',key,value)
    end)
end
AddEventHandler(server and 'onResourceStop' or 'onClientResourceStop',function(owner)
    local entry=instances[owner]
    if entry and not server then
        local ok,reason=pcall(entry.E.UI.Menu.CloseAll)
        if not ok then print('[PR Bridge ESX cleanup] '..tostring(reason)) end
    end
    if entry then
        entry.C.closed=true;entry.C.clearTimeouts()
        if entry.C.clearScaleforms then entry.C.clearScaleforms() end
        if entry.C.clearPoints then entry.C.clearPoints() end
        for _,handle in ipairs(entry.C.clientHandlers or {}) do RemoveEventHandler(handle) end
    end
    instances[owner]=nil
    if entry and owner~='pr_bridge' then
        activeConsumers=activeConsumers-1
        if activeConsumers==0 then deactivate() end
    end
    routing.forget(owner)
    if server and Bridge.framework.ReleaseCompatibilityOwner then Bridge.framework.ReleaseCompatibilityOwner(owner) end
    for name,callback in pairs(state.callbacks) do if callback.owner==owner then state.callbacks[name]=nil end end
    for name,item in pairs(state.usable) do if item.owner==owner then state.usable[name]=nil end end
end)
