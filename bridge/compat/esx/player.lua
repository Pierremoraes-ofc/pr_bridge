return function(E, C, catalog)
    local wrappers, epochs = {}, {}
    local F, I = C.bridge.framework, C.bridge.inventory
    local function rawPlayer(id)
        C.target();local native=C.invoke(F,'GetPlayer',id)
        local data=native and (F.GetCompatibilityPlayerData and C.invoke(F,'GetCompatibilityPlayerData',id) or native.PlayerData)
        return native,data
    end
    function C.player(id)
        id=tonumber(id); if not id or id<1 or id%1~=0 then return end
        local backend=C.target()
        local native,data=rawPlayer(id); if not native then return end
        if not data or data.citizenid==nil then C.unsupported('xPlayer', 'destination player snapshot/identity unavailable') end
        local identifier=data.citizenid
        local epoch=epochs[id] or 0
        C.state.variables=C.state.variables or {}
        local variables=C.state.variables[id]
        if not variables or variables.identifier~=identifier then
            variables={identifier=identifier,data=C.copy(data.charinfo or {})}
            C.state.variables[id]=variables
        end
        local existing=wrappers[id]
        local overrideRevision=F.GetCompatibilityOverrideRevision and F.GetCompatibilityOverrideRevision() or 0
        if existing and existing.backend==backend and existing.identifier==identifier and existing.epoch==epoch and existing.overrideRevision==overrideRevision then existing.refresh();return existing.player end
        local methods, supported = {}, {}
        local function current()
            assert(not C.closed,'[PR Bridge ESX] owning resource stopped')
            assert(C.target()==backend,'[PR Bridge ESX] destination changed; reacquire xPlayer')
            local player,d=rawPlayer(id)
            assert((epochs[id] or 0)==epoch and player and d and d.citizenid==identifier,
                '[PR Bridge ESX] stale xPlayer session; reacquire GetPlayerFromId')
            return player,d
        end
        local function fn(name, callback)
            supported[name]=true
            methods[name]=function(...) current(); return callback(...) end
        end
        local function functions(name, ...)
            local player=current(); return C.invoke(player.Functions, name, ...)
        end
        supported.isCurrent=true
        methods.isCurrent=function() local ok=pcall(current);return ok end
        fn('getSource', function() return id end)
        fn('getPlayerId', methods.getSource)
        fn('getIdentifier', function() return identifier end)
        fn('getName', function() local _,d=current();return (d.metadata or {}).prCompatDisplayName or C.invoke(F,'getPlayerName',id) end)
        fn('triggerEvent', function(name,...) assert(type(name)=='string');TriggerClientEvent(name,id,...) end)
        fn('kick', function(reason) DropPlayer(id,reason or 'Disconnected') end)
        fn('executeCommand', function(command) TriggerClientEvent('esx:executeCommand',id,command) end)
        fn('getGroup', function() return C.invoke(F,'getPlayerGroup',id) end)
        fn('isAdmin', function() return C.invoke(F,'HasPermission',id,{'admin','god'}) end)
        -- ESX variables are auxiliary session data, not arbitrary QB PlayerData
        -- fields. In particular set('money', ...) must not overwrite core wallets.
        fn('get', function(key) return C.copy(variables.data[key]) end)
        fn('set', function(key,value)
            assert(type(key)=='string');variables.data[key]=C.copy(value)
            TriggerClientEvent('esx:updatePlayerData',id,'variables',C.copy(variables.data))
        end)
        fn('getMeta', function(key,sub)
            local _,d=current();local value=key and (d.metadata or {})[key] or d.metadata or {}
            if type(value)=='table' and sub then
                if type(sub)=='table' then local r={};for _,k in ipairs(sub) do r[k]=C.copy(value[k]) end;return r end
                return C.copy(value[sub])
            end
            return C.copy(value)
        end)
        fn('setMeta', function(key,value,sub)
            assert(type(key)=='string' and value~=nil)
            if sub~=nil then local old=methods.getMeta(key) or {};assert(type(old)=='table' and type(value)=='string');old[value]=C.copy(sub);value=old end
            return C.invoke(F,'setPlayerMetadata',id,key,C.copy(value))
        end)
        fn('clearMeta', function(key,sub)
            local old=methods.getMeta(key)
            if sub then assert(type(old)=='table');for _,k in ipairs(type(sub)=='table' and sub or {sub}) do old[k]=nil end
            else old=nil end
            return C.invoke(F,'setPlayerMetadata',id,key,old)
        end)
        fn('getJob', function() return C.job(C.invoke(F,'GetPlayerJob',id)) end)
        fn('setJob', function(name,grade,duty)
            local result,reason=C.invoke(F,'SetPlayerJob',id,name,C.amount(tonumber(grade)))
            if result==false then return false,reason end
            if duty~=nil then return C.invoke(F,'SetPlayerDuty',id,duty==true) end
            return result
        end)
        fn('refreshJob', methods.getJob)
        fn('getAccount', function(name)
            return {name=name,money=C.invoke(F,'getPlayerMoney',id,C.account(name)),label=name,round=true}
        end)
        fn('getAccounts', function(minimal)
            local result={};for name in pairs(Config.compatESXAccounts or {money='cash',bank='bank'}) do
                local account=methods.getAccount(name);if minimal then result[name]=account.money else result[#result+1]=account end
            end;return result
        end)
        fn('getMoney', function() return methods.getAccount('money').money end)
        fn('addAccountMoney', function(name,value,reason) return C.invoke(F,'addPlayerMoney',id,C.account(name),C.amount(value),reason or 'esx-compat') end)
        fn('removeAccountMoney', function(name,value,reason) return C.invoke(F,'removePlayerMoney',id,C.account(name),C.amount(value),reason or 'esx-compat') end)
        fn('setAccountMoney', function(name,value,reason)
            if F.SetPlayerAccountMoney then return C.invoke(F,'SetPlayerAccountMoney',id,C.account(name),C.amount(value),reason or 'esx-compat') end
            return functions('SetMoney',C.account(name),C.amount(value),reason or 'esx-compat')
        end)
        fn('setMoney', function(value) return methods.setAccountMoney('money',value) end)
        fn('addMoney', function(value,reason) return methods.addAccountMoney('money',value,reason) end)
        fn('removeMoney', function(value,reason) return methods.removeAccountMoney('money',value,reason) end)
        fn('getInventory', function(minimal)
            local list=C.inventory(id);if not minimal then return list end
            local result={};for _,item in ipairs(list) do if item.count>0 then result[item.name]=item.count end end;return result
        end)
        fn('getInventoryItem', function(name)
            local definition=C.invoke(I,'Items',name);if not definition then return end
            return {name=name,label=definition.label or name,weight=definition.weight or 0,
                count=C.invoke(I,'GetItemCount',id,name),usable=definition.usable==true,rare=false,canRemove=true}
        end)
        fn('addInventoryItem', function(name,count) return C.invoke(I,'AddItem',id,name,C.amount(count)) end)
        fn('removeInventoryItem', function(name,count) return C.invoke(I,'RemoveItem',id,name,C.amount(count)) end)
        fn('setInventoryItem', function(name,count)
            count=C.amount(count);local existing=C.invoke(I,'GetItemCount',id,name)
            if count>existing then return methods.addInventoryItem(name,count-existing) end
            if count<existing then return methods.removeInventoryItem(name,existing-count) end;return true
        end)
        fn('hasItem', function(name)
            local item=methods.getInventoryItem(name);if item and item.count>0 then return item,item.count end
            return false
        end)
        fn('getWeight', function() return C.invoke(I,'GetInventory',id).weight end)
        fn('getMaxWeight', function() return C.invoke(I,'GetInventory',id).maxWeight end)
        fn('setMaxWeight', function(value) return C.invoke(I,'SetMaxWeight',id,C.amount(value)) end)
        fn('canCarryItem', function(name,count) return C.invoke(I,'CanCarryItem',id,name,C.amount(count)) end)
        fn('canSwapItem', function(a,ac,b,bc) return C.invoke(I,'CanSwapItem',id,a,C.amount(ac),b,C.amount(bc)) end)
        fn('getCoords', function(vector,heading)
            local ped=GetPlayerPed(id);local p=GetEntityCoords(ped);local h=GetEntityHeading(ped)
            if vector then return heading and vector4(p.x,p.y,p.z,h) or p end
            return {x=p.x,y=p.y,z=p.z,heading=heading and h or nil}
        end)
        fn('setCoords', function(p)
            assert(p and type(p.x)=='number' and type(p.y)=='number' and type(p.z)=='number')
            local ped=GetPlayerPed(id);if ped==0 then return false end
            SetEntityCoords(ped,p.x,p.y,p.z,false,false,false,false);if p.w or p.heading then SetEntityHeading(ped,p.w or p.heading) end
        end)
        for _,name in ipairs({'showNotification','showAdvancedNotification','showHelpNotification'}) do
            fn(name,function(...) TriggerClientEvent('esx:'..name,id,...) end)
        end
        C.attachPlayerWeapons(id,fn,methods)
        local contract=PRCore.load('bridge.frameworks.compat_contract')
        for legacy,operation in pairs(contract.player) do
            fn(legacy,function(...) return C.invoke(F,operation,id,...) end)
        end
        for name in pairs(catalog.player) do
            if not methods[name] then methods[name]=function() C.unsupported('xPlayer.'..name) end end
        end
        -- Raw method fields survive FiveM export serialization; authority is
        -- always re-read by the closures, not copied into a second player store.
        local facade=setmetatable(methods, {__index=function(_,key)
            local _,d=current()
            if key=='job' then return C.job(d.job) end
            if key=='metadata' then return C.copy(d.metadata) end
            if key=='variables' then return C.copy(variables.data) end
            if key=='accounts' then return methods.getAccounts() end
            if key=='inventory' then return methods.getInventory() end
            if key=='coords' then return methods.getCoords() end
            if key=='name' then return methods.getName() end
            if key=='group' then return methods.getGroup() end
        end, __newindex=function() error('Use xPlayer methods; raw writes do not update the destination core') end})
        rawset(facade,'source',id);rawset(facade,'identifier',identifier)
        -- Standard serializable property snapshot, refreshed on every lookup.
        local function refresh()
            local _,d=current();rawset(facade,'job',C.job(d.job));rawset(facade,'name',methods.getName())
            rawset(facade,'metadata',C.copy(d.metadata));rawset(facade,'variables',C.copy(variables.data))
            rawset(facade,'inventory',methods.getInventory());rawset(facade,'accounts',methods.getAccounts())
        end
        refresh()
        if F.ApplyCompatibilityOverrides then C.invoke(F,'ApplyCompatibilityOverrides',facade,C.owner,current) end
        wrappers[id]={backend=backend,identifier=identifier,epoch=epoch,overrideRevision=overrideRevision,player=facade,refresh=refresh}
        C.playerSupport=supported
        return facade
    end
    C.invalidatePlayer=function(id) id=tonumber(id);if id then
        epochs[id]=(epochs[id] or 0)+1;wrappers[id]=nil
        if C.state.variables then C.state.variables[id]=nil end
        if F.ReleaseCompatibilityPlayer then C.invoke(F,'ReleaseCompatibilityPlayer',id) end
    end end
    return C.player
end
