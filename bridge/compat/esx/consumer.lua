-- Runs inside @es_extended/imports.lua consumers; does not import another core.
if ESX and ESX.__prESXConsumer then return end
local ok,E=pcall(function() return exports.pr_bridge:getESXObject() end)
assert(ok and type(E)=='table','PR Bridge ESX compatibility is disabled or not initialized')
ESX=E;ESX.__prESXConsumer=true;ESX.currentResourceName=GetCurrentResourceName()
-- File execution belongs to the importing resource, not the host environment.
if not PRCore then assert(load(assert(LoadResourceFile('pr_bridge','bridge/core.lua')),'@@pr_bridge/bridge/core.lua','t',_ENV))() end
local files={cache={resource=GetCurrentResourceName()},originalRequire=require}
PRCore.load('@pr_bridge/bridge/files/loader',_ENV)(files)
ESX.load,ESX.loadJson,ESX.require=files.load,files.loadJson,files.require
if not IsDuplicityVersion() then
    ESX.PlayerData=ESX.GetPlayerData();ESX.PlayerLoaded=ESX.IsPlayerLoaded()
    OnPlayerData=OnPlayerData or function() end
    AddEventHandler('esx:setPlayerData',function(key,value,previous)
        if GetInvokingResource()~='pr_bridge' then return end
        ESX.PlayerData[key]=value;OnPlayerData(key,value,previous)
    end)
    AddEventHandler('esx:playerLoaded',function(data)
        if source~=65535 and GetInvokingResource()~='pr_bridge' then return end
        ESX.PlayerData=data;ESX.PlayerLoaded=true
    end)
    AddEventHandler('esx:onPlayerLogout',function()
        if source~=65535 and GetInvokingResource()~='pr_bridge' then return end
        ESX.PlayerData={};ESX.PlayerLoaded=false
    end)
end
