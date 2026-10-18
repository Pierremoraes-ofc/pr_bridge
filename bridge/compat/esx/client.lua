return function(E,C)
    local define=function(name,fn) C.define(E,name,fn) end
    E.PlayerData={};E.PlayerLoaded=false;E.playerId=PlayerId();E.serverId=GetPlayerServerId(E.playerId)
    function C.sync(emit,batch)
        C.target();local F=C.bridge.framework
        batch=batch or {}
        if not batch.raw then batch.raw=C.invoke(F,F.GetCompatibilityPlayerData and 'GetCompatibilityPlayerData' or 'GetPlayerData') or {} end
        local raw=batch.raw
        local previous=E.PlayerData
        local data={identifier=raw.citizenid,name=raw.charinfo and ((raw.charinfo.firstname or '')..' '..(raw.charinfo.lastname or '')),
            job=C.job(raw.job),metadata=C.copy(raw.metadata or {}),variables=C.copy(previous.variables or raw.charinfo or {}),
            accounts={},inventory={},loadout={},ped=PlayerPedId()}
        data.name=(raw.metadata or {}).prCompatDisplayName or data.name
        for name,wallet in pairs(Config.compatESXAccounts or {money='cash',bank='bank'}) do
            data.accounts[#data.accounts+1]={name=name,money=(raw.money or {})[wallet] or 0,label=name,round=true}
        end
        data.money=(raw.money or {}).cash or 0
        if raw.citizenid then
            if not batch.prepared then
                batch.prepared=true
                local ok,input=pcall(C.readInventory)
                if ok then
                    local definitions={}
                    local inventoryOK,inventory=pcall(C.inventory,nil,input,definitions)
                    if inventoryOK then batch.inventory=inventory end
                    if not inventoryOK then C.report('inventory view',inventory) end
                    local loadoutOK,loadout=pcall(C.loadout,nil,false,input,definitions)
                    if loadoutOK then batch.loadout=loadout end
                    if not loadoutOK then C.report('weapon view',loadout) end
                end
                if not ok then C.report('GetPlayerItems',input) end
            end
            data.inventory=C.copy(batch.inventory or {})
            data.loadout=C.copy(batch.loadout or {})
        end
        E.PlayerData=data;E.PlayerLoaded=raw.citizenid~=nil
        if emit then for key,value in pairs(data) do TriggerEvent('esx:setPlayerData',key,C.copy(value),C.copy(previous[key])) end end
        return data
    end
    define('IsPlayerLoaded',function() return E.PlayerLoaded end)
    define('GetPlayerData',function() return C.copy(E.PlayerData) end)
    define('SetPlayerData',function(key,value)
        assert(type(key)=='string');local previous=E.PlayerData[key];E.PlayerData[key]=C.copy(value)
        TriggerEvent('esx:setPlayerData',key,C.copy(value),previous)
        -- This is a client preview only, never a server metadata/money write.
    end)
    define('GetAccount',function(name) for _,account in ipairs(E.PlayerData.accounts or {}) do if account.name==name then return C.copy(account) end end end)
    define('SearchInventory',function(items,count)
        local single=type(items)=='string';local result={};for _,name in ipairs(single and {items} or items) do
            if count then result[name]=0 end
            for _,item in ipairs(E.PlayerData.inventory or {}) do if item.name==name then result[name]=count and item.count or C.copy(item);break end end
        end;return single and result[items] or result
    end)
    define('ShowInventory',function() return C.invoke(C.bridge.inventory,'openInventory','player') end)
    define('HashString',joaat)
    define('SecureNetEvent',function(name,handler)
        assert(C.callable(handler));RegisterNetEvent(name,function(...) if source==65535 or GetInvokingResource()=='pr_bridge' then handler(...) end end)
    end)
    define('ShowNotification',function(message,kind,duration,title,position)
        return C.bridge.Notify({description=message,type=kind=='info' and 'inform' or kind or 'inform',duration=duration,title=title,position=position})
    end)
    define('ShowAdvancedNotification',function(sender,subject,message) return E.ShowNotification(message,'inform',5000,sender..' · '..subject) end)
    define('ShowHelpNotification',function(message,thisFrame,beep,duration)
        BeginTextCommandDisplayHelp('STRING');AddTextComponentSubstringPlayerName(message);EndTextCommandDisplayHelp(0,false,beep~=false,duration or -1)
    end)
    define('ShowFloatingHelpNotification',function(message,p)
        SetFloatingHelpTextWorldPosition(1,p.x,p.y,p.z);SetFloatingHelpTextStyle(1,1,2,-1,3,0)
        BeginTextCommandDisplayHelp('STRING');AddTextComponentSubstringPlayerName(message);EndTextCommandDisplayHelp(2,false,false,-1)
    end)
    define('DrawMissionText',function(message,time) BeginTextCommandPrint('STRING');AddTextComponentSubstringPlayerName(message);EndTextCommandPrint(time or 5000,true) end)
    define('TextUI',function(text,style) return C.ui.showTextUI(text,style) end)
    define('HideUI',function() return C.ui.hideTextUI() end)
    define('Progressbar',function(message,length,options)
        options=options or {};local data=C.copy(options);data.label=message;data.duration=length
        CreateThread(function() local completed=C.bridge.nativeProgress.progressBar(data)
            local cb=completed and options.onFinish or options.onCancel;if C.callable(cb) then cb() end end)
    end)
    define('CancelProgressbar',function() return C.bridge.nativeProgress.cancelProgress() end)
    define('DisableSpawnManager',function()
        if GetResourceState('spawnmanager')=='started' then return exports.spawnmanager:setAutoSpawn(false) end
    end)
    define('UI.ShowInventoryItemNotification',function(add,item,count) return E.ShowNotification((add and '+ ' or '- ')..tostring(count)..' '..tostring(item)) end)
    define('RegisterInput',function(command,label,group,key,onPress,onRelease)
        assert(type(command)=='string');RegisterCommand('+'..command,function() if not C.closed and onPress then onPress() end end,false)
        RegisterCommand('-'..command,function() if not C.closed and onRelease then onRelease() end end,false)
        RegisterKeyMapping('+'..command,label,group or 'keyboard',key)
    end)
    PRCore.load('bridge.compat.esx.menu')(E,C)
    PRCore.load('bridge.compat.esx.game')(E,C)
    PRCore.load('bridge.compat.esx.points')(E,C)
    PRCore.load('bridge.compat.esx.extensions')(E,C)
    return E
end
