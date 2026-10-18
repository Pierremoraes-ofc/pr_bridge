-- QBCore is a source contract, not the selected destination framework.
local S=PRCore.load('@pr_bridge/bridge/runtime/compat_services',_ENV)
local H=PRCore.load('@pr_bridge/bridge/frameworks/compat_helpers',_ENV)
local catalog=PRCore.load('@pr_bridge/bridge/compat/qb/catalog',_ENV)
return function(F,context,I,backend)
    local api={Functions={},Player={},Lifecycle={}}
    local N=PRCore.load(('@pr_bridge/bridge/frameworks/%s/qb_compat'):format(backend),_ENV)(F,context,I)
    local function native(fn) return function() return fn end end
    local function delegate(method)
        return function(...)
            assert(S.callable(F[method]),'PR framework method unavailable: '..method)
            return F[method](...)
        end
    end
    local function wallet(name)
        local target=(Config.compatQBAccounts or {cash='cash',bank='bank'})[name]
        assert(type(target)=='string','Unmapped QB account; configure compatQBAccounts')
        return target
    end
    local function amount(value)
        assert(type(value)=='number' and value==value and value>=0 and value<math.huge,'Invalid nonnegative amount')
        return value
    end
    local function itemList(source)
        local raw
        if context=='server' then raw=I.GetInventoryItems(source)
        else raw=I.GetPlayerItems() end
        local list={}
        for key,item in pairs(raw or {}) do
            if type(item)=='table' and item.name then
                local entry=H.copy(item);entry.amount=item.amount or item.count or 0
                entry.slot=item.slot or tonumber(key);entry.info=H.copy(item.info or item.metadata or {})
                list[entry.slot or key]=entry
            end
        end
        return list
    end
    local function job(value)
        value=H.copy(value or {});local old=value.grade
        if type(old)~='table' then value.grade={level=tonumber(old) or 0,name=value.grade_label or value.grade_name or value.gradeLabel or tostring(old or 0)} end
        value.payment=value.payment or value.grade_salary or value.grade.payment
        if value.onduty==nil then value.onduty=value.onDuty end
        return value
    end
    local function snapshot(source)
        local raw
        if context=='server' then raw=F.GetPlayer(source) else raw=F.GetPlayerData() end
        if not raw then return end
        local data=raw.PlayerData or raw
        if data.citizenid then data=H.copy(data);data.items=itemList(source);return data end
        local id
        if context=='server' then id=F.GetIdentifier(source) else id=F.GetPlayerIdentifier() end
        if id==nil then return end
        local name=context=='server' and F.getPlayerName(source) or F.GetPlayerName()
        local info=data.charinfo or data.variables or {}
        local money={}
        if context=='server' then
            for account in pairs(Config.compatQBAccounts or {cash='cash',bank='bank'}) do money[account]=F.getPlayerMoney(source,wallet(account)) end
        else
            for _,account in pairs(data.accounts or {}) do
                if type(account)=='table' and account.name then
                    if account.name=='money' then money.cash=account.money else money[account.name]=account.money end
                end
            end
        end
        return {source=source,citizenid=id,name=type(name)=='string' and name or name.fullName,
            charinfo={firstname=info.firstname or info.firstName or (type(name)=='table' and name.firstName) or (type(name)=='string' and name) or '',
                lastname=info.lastname or info.lastName or (type(name)=='table' and name.lastName) or '',
                birthdate=info.birthdate or info.dateofbirth,gender=info.gender or info.sex},
            job=job(F.GetPlayerJob(source)),metadata=H.copy(data.metadata or {}),money=money,items=itemList(source)}
    end
    api.GetPlayerData=snapshot
    api.GetItems=itemList
    api.GetShared=function(namespace)
        if namespace=='Items' then
            local result={}
            for name,item in pairs(I.Items() or {}) do
                local entry=H.copy(item);entry.name=entry.name or name
                entry.type=entry.type or (entry.weapon and 'weapon' or 'item')
                if entry.unique==nil then entry.unique=entry.stack==false end
                entry.image=entry.image or (entry.client and entry.client.image) or (name..'.png')
                result[name]=entry
            end
            return result
        elseif namespace=='Jobs' then
            local result={}
            for name,value in pairs(F.GetFrameworkJobs() or {}) do
                local entry=H.copy(value);entry.name=entry.name or name
                for _,grade in pairs(entry.grades or {}) do grade.payment=grade.payment or grade.salary end
                result[name]=entry
            end
            return result
        elseif namespace=='Gangs' then return F.GetFrameworkGangs and H.copy(F.GetFrameworkGangs()) or {}
        elseif namespace=='VehicleHashes' then return F.GetVehiclesByHash and H.copy(F.GetVehiclesByHash()) or {}
        elseif namespace=='Vehicles' then
            local values={}
            for _,vehicle in pairs(F.GetVehiclesByHash and F.GetVehiclesByHash() or {}) do
                if vehicle.model then values[vehicle.model]=H.copy(vehicle) end
            end
            return values
        end
        return S.call('frameworks',backend,'QBCore.Shared.'..namespace,N['Shared.'..namespace],nil)
    end
    local function hasItems(source,items,minimum)
        minimum=amount(minimum or 1)
        if type(items)=='string' then return (context=='server' and I.GetItemCount(source,items) or I.GetItemCount(items))>=minimum end
        assert(type(items)=='table','Expected item name/list/map')
        for key,value in pairs(items) do
            local name=type(key)=='number' and value or key
            local needed=type(key)=='number' and minimum or amount(value)
            if not hasItems(source,name,needed) then return false end
        end
        return true
    end
    N.HasItem=native(context=='server' and hasItems or function(items,minimum) return hasItems(nil,items,minimum) end)
    if context=='server' then
        N.GetPlayerByCitizenId=native(delegate('GetPlayerFromIdentifier'))
        N.HasPermission=native(delegate('HasPermission'))
        for legacy,canonical in pairs({SetJob='SetPlayerJob',SetJobDuty='SetPlayerDuty',SetMetaData='setPlayerMetadata',Save='SaveCompatibilityPlayer'}) do
            N['Player.'..legacy]=N['Player.'..legacy] or native(delegate(canonical))
        end
        N['Player.GetMoney']=native(function(source,name) return F.getPlayerMoney(source,wallet(name)) end)
        for legacy,canonical in pairs({AddMoney='addPlayerMoney',RemoveMoney='removePlayerMoney'}) do
            N['Player.'..legacy]=native(function(source,name,value,reason) return F[canonical](source,wallet(name),amount(value),reason or 'qb-compat') end)
        end
        N['Player.GetMetaData']=native(function(source,key) return F.getPlayerMetadata(source,key) end)
        N['Player.AddItem']=native(function(source,name,count,slot,info) return I.AddItem(source,name,amount(count or 1),info,slot) end)
        N['Player.RemoveItem']=native(function(source,name,count,slot) return I.RemoveItem(source,name,amount(count or 1),nil,slot) end)
        N['Player.GetItemBySlot']=native(function(source,slot) return H.copy(itemList(source)[tonumber(slot) or slot]) end)
        N['Player.GetItemsByName']=native(function(source,name)
            local result={};for _,item in pairs(itemList(source)) do if item.name==name then result[#result+1]=item end end
            table.sort(result,function(a,b) return (a.slot or 0)<(b.slot or 0) end);return result
        end)
        N['Player.GetItemByName']=native(function(source,name) return api.Player.GetItemsByName(source,name)[1] end)
        N['Player.HasItem']=native(hasItems)
        N['Player.ClearInventory']=native(function(source,keep) return I.ClearInventory(source,keep) end)
    end
    for group,names in pairs({Functions=catalog[context],Player=context=='server' and catalog.player or {},Lifecycle=context=='server' and catalog.lifecycle or {}}) do
        for name in pairs(names) do
            local key=(group=='Player' and 'Player.' or group=='Lifecycle' and 'Lifecycle.' or '')..name
            api[group][name]=function(...) return S.call('frameworks',backend,'QBCore.'..key,N[key],nil,...) end
        end
    end
    api.GetCapabilities=function()
        local result={}
        for group,names in pairs({Functions=catalog[context],Player=context=='server' and catalog.player or {},Lifecycle=context=='server' and catalog.lifecycle or {}}) do
            for name in pairs(names) do
                local key=(group=='Player' and 'Player.' or group=='Lifecycle' and 'Lifecycle.' or '')..name
                local fn,provider=S.resolve('frameworks',backend,'QBCore.'..key,N[key],nil)
                result[group..'.'..name]={available=fn~=nil,provider=provider}
            end
        end
        return result
    end
    F.QBCore=api
    return api
end
