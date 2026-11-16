-- Prepared Forge adapter only. Not auto-selected or installed; QBX identifiers remain transition contracts.
return function(ports)
    local view,cache=assert(ports.view),ports.cache
    local namespace=assert(ports.cacheNamespace,'explicit producer namespace required')
    local owner=assert(ports.isCurrent);local readReady=assert(ports.readSessionReady)
    local inventory=ports.inventory;local localEvent,serverEvent=assert(ports.triggerLocal),assert(ports.triggerServer)
    assert(type(view.PlayerData)=='table','consumer snapshot required')
    local phase,pending='open',0;local cashAmount=view.PlayerData.money and view.PlayerData.money.cash or 0
    local bankAmount=view.PlayerData.money and view.PlayerData.money.bank or 0
    local api={OperationalReady=false,Framework={},Events={},View=view}
    local function current()local ok,value=pcall(owner);return phase=='open'and ok and value==true end
    local function check()assert(current(),'forge_client_adapter_closed')end
    local function finish(ok,...)
        pending=pending-1;if not ok then error((...),0)end;return ...
    end
    local function guard(fn)return function(...)
        if not current()then return end;pending=pending+1
        return finish(pcall(fn,...))
    end end
    local function readData()
        if cache then
            local session=cache.GetResourceState(namespace,'session');check()
            if session and session.authenticated==false then return{}end
            local data=cache.get('playerData');check();if type(data)=='table'then return data end
        end
        return view.PlayerData or{}
    end
    local function setData(value)
        view.PlayerData=value or{};local money=view.PlayerData.money or{}
        cashAmount,bankAmount=money.cash or 0,money.bank or 0
    end
    local function event(name,network,fn)api.Events[#api.Events+1]={name=name,network=network,handler=guard(fn)}end
    event('QBCore:Client:OnPlayerLoaded',true,function(value)if type(value)=='table'then setData(value.PlayerData or value)end end)
    event('QBCore:Client:OnPlayerUnload',true,function()setData({})end)
    event('QBCore:Player:SetPlayerData',true,setData)
    event('qbx_core:client:statusChanged',false,function(status)
        if type(status)~='table'then return end;view.PlayerData=view.PlayerData or{};view.PlayerData.metadata=view.PlayerData.metadata or{}
        for _,key in ipairs({'health','armor','hunger','thirst','stress','oxygen'})do if status[key]~=nil then view.PlayerData.metadata[key]=status[key]end end
    end)
    event('QBCore:Client:OnJobUpdate',true,function(job)view.PlayerData=view.PlayerData or{};view.PlayerData.job=job end)
    event('QBCore:Client:OnGangUpdate',true,function(gang)view.PlayerData=view.PlayerData or{};view.PlayerData.gang=gang end)
    event('QBCore:Client:SetDuty',true,function(duty)view.PlayerData=view.PlayerData or{};view.PlayerData.job=view.PlayerData.job or{};view.PlayerData.job.onduty=duty==true end)
    event('qbx_core:client:setGroups',true,function(groups)view.PlayerData=view.PlayerData or{};view.PlayerData.groups=groups or{}end)
    event('hud:client:OnMoneyChange',true,function()
        if not view.PlayerData or not view.PlayerData.money then return end
        cashAmount,bankAmount=view.PlayerData.money.cash or 0,view.PlayerData.money.bank or 0
    end)
    local functions={}
    function functions.GetPlayer()
        local data=readData();if not data or not data.charinfo then return{}end;local p=data.charinfo
        return{fullName=('%s %s'):format(p.firstname,p.lastname),firstName=p.firstname,lastName=p.lastname,dob=p.birthdate,gender=p.gender}
    end
    function functions.GetPlayerData()return readData()end
    function functions.GetMoney(kind)
        local data=readData();cashAmount=data.money and data.money.cash or 0;bankAmount=data.money and data.money.bank or 0
        if kind=='cash'then return cashAmount elseif kind=='bank'then return bankAmount
        elseif kind=='black'then
            if inventory and inventory.GetItemCount then local dirty=inventory.GetItemCount('black_money');return dirty>0 and dirty or cashAmount end
            return cashAmount
        end
    end
    function functions.GetJobInfo()
        local player=readData();if not player or not player.job then return{}end;local job=player.job
        return{grade=job.grade.level,gradeName=job.grade.name,jobName=job.name,jobLabel=job.label}
    end
    function functions.GetPlayerJob()return readData().job end
    function functions.PlayerHasJob(name,grade)
        local job=readData().job;if not job or job.name~=tostring(name or''):lower()then return false end
        if grade==nil then return true end;local jobGrade=job.grade
        local level=type(jobGrade)=='table'and(jobGrade.level or jobGrade.grade)or jobGrade
        return(tonumber(level)or 0)>=(tonumber(grade)or 0)
    end
    function functions.IsPlayerLoaded()
        local data=readData();return type(data)=='table'and(data.citizenid~=nil or data.identifier~=nil)
    end
    function functions.IsSessionReady()local ok,loaded=pcall(readReady);return ok and loaded==true end
    function functions.getPlayerMetadata(key)local data=readData();if not data or not data.metadata then return nil end;return data.metadata[key]end
    function functions.toggleOutfit(wear,outfits)
        if wear then
            local data=readData();if not data then return end;local gender=data.charinfo.gender
            local outfit=gender==1 and outfits.Female or outfits.Male;if not outfit then return end
            localEvent('qb-clothing:client:loadOutfit',{outfitData=outfit})
        else
            serverEvent('qb-clothing:loadPlayerSkin')
        end
    end
    for name,fn in pairs(functions)do api.Framework[name]=guard(fn)end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
