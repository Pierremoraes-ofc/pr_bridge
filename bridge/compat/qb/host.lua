-- Host only. Native QB and QBX already own qb-core: never replace their exports,
-- callback events, character login or player lifecycle with a second handler.
if not Config.compatFramework or Config.compatFramework=='off' or Config.compatQBCore==false then return end
local context=PRCore.context
local server=context=='server'
local function external(resource)
    local state=GetResourceState(resource)
    return (state=='starting' or state=='started') and GetResourceMetadata(resource,'name',0)~='pr_bridge'
end
local function native()
    local backend=ActiveBridges.frameworks
    return backend=='qb' or backend=='qbx' or external('qb-core') or external('qbx_core')
end
local getter
exports('getQBCoreObject',function(filters)
    if native() then
        local backend=ActiveBridges.frameworks
        assert(backend=='qb' or backend=='qbx','[PR Bridge QB] an original QB core conflicts with the selected destination')
        if backend=='qbx' then assert(GetConvar('qbx:enablebridge','true')~='false','[PR Bridge QB] enable the native QBX bridge (qbx:enablebridge)') end
        return exports['qb-core']:GetCoreObject(filters)
    end
    assert(getter,'[PR Bridge QB] native destination changed; restart pr_bridge and consumers')
    return getter(GetInvokingResource() or 'pr_bridge',filters)
end)
if native() then return end
local routing=Bridge.frameworkRouting or PRCore.load('bridge.compat.framework_routing',_ENV)(ActiveBridges,Config)
local catalog=PRCore.load('bridge.compat.qb.catalog',_ENV)
local instances,state={}, {callbacks={},usables={},usableRegistered={},commands={},rates={}}
local function budget(id)
    local now=GetGameTimer();local rate=state.rates[id]
    if not rate or now-rate.time>=10000 then rate={time=now,count=0};state.rates[id]=rate end
    rate.count=rate.count+1;return rate.count<=64
end
getter=function(owner,filters)
    assert(not native(),'[PR Bridge QB] native core now owns qb-core; reacquire its object')
    owner=owner or GetInvokingResource() or 'pr_bridge'
    routing.assertAllowed('qb',owner)
    local instance=instances[owner]
    if not instance then
        local Q={};local C=PRCore.load('bridge.compat.qb.common',_ENV)(owner,context)
        C.state=state
        C.routing=routing
        PRCore.load('bridge.compat.qb.shared',_ENV)(Q,C,catalog)
        PRCore.load('bridge.compat.qb.'..context,_ENV)(Q,C,catalog,state)
        PRCore.load('bridge.compat.qb.callbacks',_ENV)(Q,C,state)
        C.finish(Q,catalog);instance={Q=Q,C=C};instances[owner]=instance
    end
    local Q,C=instance.Q,instance.C
    C.refreshShared();if C.sync then C.sync() end
    if C.refreshPlayers then C.refreshPlayers() end
    if not filters then return Q end
    assert(type(filters)=='table','Invalid QB core filters')
    local result={};for _,key in ipairs(filters) do if Q[key]~=nil then result[key]=Q[key] end end;return result
end
state.engine=PRCore.load('bridge.callback.transport',_ENV)({
    server=server,timeout=10000,rejectErrors=true,responseEvent='pr_bridge:qb:reply',
    requestEvent=function(name) return 'pr_bridge:qb:request:'..name end,
    acceptResponse=function(player,target) return not native() and (server and tonumber(player)==tonumber(target) or not server and player==65535) end,
    acceptRequest=function(player,_,key)
        if native() or type(key)~='string' or #key>=512 then return false end
        if server then local id=tonumber(player);return id and id>0 and budget(id) end
        return player==65535
    end,
    validateTarget=server and function(id) assert(type(id)=='number' and id>0 and GetPlayerName(id),'Invalid QB callback target') end or nil,
    parseRequest=function(key,...) return nil,key,table.pack(...) end,
    send=function(name,target,key,...)
        if server then TriggerClientEvent('pr_bridge:qb:request:'..name,target,key,...)
        else TriggerServerEvent('pr_bridge:qb:request:'..name,key,...) end
    end,
    reply=function(player,_,key,...)
        if server then TriggerClientEvent('pr_bridge:qb:reply',player,key,...)
        else TriggerServerEvent('pr_bridge:qb:reply',key,...) end
    end,
    onError=function(reason) print('[PR Bridge QB callbacks] '..tostring(reason)) end,
})
if server then
    state.engine.register('__pr_qb:shared',function(_,namespace)
        local allowed={Jobs=true,Gangs=true,VehicleHashes=true,Vehicles=true}
        assert(allowed[namespace],'Unsupported shared catalog request')
        return Bridge.framework.QBCore.GetShared(namespace)
    end)
else
    state.catalogs={}
end
local function publish(name,handler)
    AddEventHandler('__cfx_export_qb-core_'..name,function(setCallback) if not native() then setCallback(handler) end end)
end
publish('GetCoreObject',function(filters) return getter(nil,filters) end)
publish('GetShared',function(namespace,item) return getter().GetShared(namespace,item) end)
for name in pairs(catalog.exports[context]) do
    if name~='GetCoreObject' and name~='GetShared' then publish(name,function(...)
        local Q=getter();local fn
        if name=='DrawText' or name=='ChangeText' or name=='HideText' or name=='KeyPressed' then fn=Q[name]
        else fn=Q.Functions[name] or Q[name] end
        if fn then return fn(...) end
        return instances[GetInvokingResource() or 'pr_bridge'].C.missing(name,...)
    end) end
end
AddEventHandler('QBCore:GetObject',function(callback)
    if not native() and GetInvokingResource() and (source==nil or source==0 or type(source)~='number') then callback(getter()) end
end)
if server then
    RegisterNetEvent('QBCore:Server:TriggerCallback',function(name,...)
        local id=tonumber(source)
        if native() or not id or id<1 or type(name)~='string' or #name>128 or not budget(id) then return end
        local callback=state.callbacks[name]
        if not callback then TriggerClientEvent('QBCore:Client:TriggerCallback',id,name,nil,'callback_unavailable');return end
        local result=table.pack(pcall(callback.wrapped,id,...))
        if result[1] then TriggerClientEvent('QBCore:Client:TriggerCallback',id,name,table.unpack(result,2,result.n))
        else TriggerClientEvent('QBCore:Client:TriggerCallback',id,name,nil,'callback_failed') end
    end)
    local function unload(id)
        id=tonumber(id);if not id then return end
        state.rates[id]=nil
        for _,instance in pairs(instances) do
            instance.C.releasePlayer(id)
            local previous=instance.Q.Players[id]
            if previous then instance.Q.PlayersByCitizenId[previous.PlayerData.citizenid]=nil end
            instance.Q.Players[id]=nil
        end
        if not native() then TriggerEvent('QBCore:Server:OnPlayerUnload',id) end
    end
    AddEventHandler('pr_bridge:server:OnPlayerUnloaded',unload)
    AddEventHandler('playerDropped',function() unload(source) end)
    AddEventHandler('pr_bridge:server:OnPlayerLoaded',function(id)
        if native() then return end
        for _,instance in pairs(instances) do instance.C.refreshPlayers() end
        local player=getter('pr_bridge').Functions.GetPlayer(id)
        if player then TriggerEvent('QBCore:Server:PlayerLoaded',player) end
    end)
else
    local function sync()
        if native() then return end
        local data
        for _,instance in pairs(instances) do data=instance.C.sync();instance.C.refreshShared() end
        if data then TriggerEvent('QBCore:Player:SetPlayerData',data) end
    end
    AddEventHandler('pr_bridge:client:OnInventoryChanged',sync)
    AddEventHandler('pr_bridge:client:OnPlayerLoaded',function()
        if native() then return end
        SetTimeout(0,function() getter('pr_bridge');sync();TriggerEvent('QBCore:Client:OnPlayerLoaded') end)
    end)
    AddEventHandler('pr_bridge:client:OnPlayerUnloaded',function()
        for _,instance in pairs(instances) do instance.Q.PlayerData={} end
        if not native() then TriggerEvent('QBCore:Client:OnPlayerUnload') end
    end)
    RegisterNetEvent('QBCore:Notify',function(...) if source==65535 and not native() then getter('pr_bridge').Functions.Notify(...) end end)
    RegisterNetEvent('QBCore:Client:TriggerClientCallback',function(name,...)
        if source~=65535 or native() or type(name)~='string' then return end
        local callback=state.callbacks[name]
        if not callback then TriggerServerEvent('QBCore:Server:TriggerClientCallback',name,nil,'callback_unavailable');return end
        local result=table.pack(pcall(callback.wrapped,...))
        if result[1] then TriggerServerEvent('QBCore:Server:TriggerClientCallback',name,table.unpack(result,2,result.n)) end
    end)
end
AddEventHandler(server and 'onResourceStop' or 'onClientResourceStop',function(owner)
    local instance=instances[owner];if instance then instance.C.closed=true;instances[owner]=nil end
    routing.forget(owner)
    for name,callback in pairs(state.callbacks) do if callback.owner==owner then state.callbacks[name]=nil;state.engine.unregister(name) end end
    for name,item in pairs(state.usables) do if item.owner==owner then state.usables[name]=nil end end
    for name,command in pairs(state.commands) do if command.owner==owner then state.commands[name]=nil end end
end)
if server then
    AddEventHandler('onResourceStart',function(resource)
        for _,entry in ipairs(ConfigBridge and ConfigBridge.inventories or {}) do
            if entry.resource==resource and entry.folder==ActiveBridges.inventories then
                state.usableRegistered={}
                for name,use in pairs(state.usables) do
                    local instance=instances[use.owner]
                    if instance then instance.Q.Functions.CreateUseableItem(name,use.func) end
                end
                return
            end
        end
    end)
end
