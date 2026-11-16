-- Port of the installed customized OX QBX bridge; providers/installation are explicit.
-- Upstream OX Inventory bridge retained as the provenance source; see NOTICE-113 and capture113.
local methods={'UseItem','setPlayerData','syncInventory','hasLicense','buyLicense','isPlayerBoss','getOwnedVehicleId'}
return function(ports)
    local contract=assert(ports.contract);assert(contract.Protocol=='forge-inventory-core/1'and contract.Authority=='forge-core','explicit Forge/PR inventory contract required')
    local current=assert(ports.isCurrent);local target=assert(ports.server);local native=assert(ports.native)
    local phase,pending='allocated',0;local records,timers,published,before={},{},{},{}
    local server={};for k,v in pairs(target)do server[k]=v end
    for _,name in ipairs(methods)do before[name]=rawget(target,name)end
    local api={OperationalReady=false};local QBX=assert(contract.Core);local Inventory=assert(ports.Inventory);local debug={traceback=assert(ports.traceback)}
    local function valid()local ok,value=pcall(current);return phase~='closed'and ok and value==true end
    local function finish(ok,...)
        pending=pending-1;if not ok then error((...),0)end;return ...
    end
    local function invoke(fn,...)
        assert(phase=='installed'and valid(),'Forge inventory bridge unavailable')
        pending=pending+1;return finish(pcall(fn,...))
    end
    local collect={}
    function collect.event(name,fn)records[#records+1]={name=name,handler=fn}end
    function collect.timer(ms,fn)timers[#timers+1]={ms=ms,handler=fn}end
    function collect.require(name)
        if name=='modules.inventory.server'then return assert(ports.Inventory)end
        assert(name=='modules.state.server','explicit inventory module required');return{clear=assert(ports.clearState)}
    end
    -- BEGIN INSTALLED BRIDGE BODY
local loading = {}

collect.event('QBCore:Server:OnPlayerUnload', function(src)
    loading[tonumber(src)] = nil
    (collect.require 'modules.state.server').clear(src)
end)
collect.event('playerDropped', function() loading[tonumber(ports.source())] = nil end)

collect.event('qbx_core:server:playerLoggedOut', server.playerDropped)

collect.event('qbx_core:server:onGroupUpdate', function(source, groupName, groupGrade)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[groupName] = not groupGrade and nil or groupGrade
end)

local function setupPlayer(playerData)
    if type(playerData) ~= 'table' then return end
    local src, character = tonumber(playerData.source), playerData.citizenid
    if not src or loading[src] or not character then return end
    local existing = Inventory(src)
    if existing and existing.owner == character then return end
    local ticket = {}
    loading[src] = ticket
    local function isCurrent()
        local player = QBX:GetPlayer(src)
        return loading[src] == ticket and player and player.PlayerData.citizenid == character
    end
    local ok, err = xpcall(function()
        playerData.identifier = playerData.citizenid
        playerData.name = ('%s %s'):format(playerData.charinfo.firstname, playerData.charinfo.lastname)
        if not server.setPlayerInventory(playerData, nil, isCurrent) or not isCurrent() then return end

        local accounts = Inventory.GetAccountItemCounts(playerData.source)
        if not accounts then return end
        for account in pairs(accounts) do
            local playerAccount = account == 'money' and 'cash' or account
            Inventory.SetItem(playerData.source, account, playerData.money[playerAccount])
        end
    end, debug.traceback)
    if loading[src] == ticket then loading[src] = nil end
    if not ok then error(err, 0) end
end

collect.event('QBCore:Server:PlayerLoaded', function(player)
    setupPlayer(player and player.PlayerData)
end)

collect.timer(500, function()
    local playersData = QBX:GetPlayersData()
    for i = 1, #playersData do setupPlayer(playersData[i]) end
end)

function server.UseItem(source, itemName, data)
    local cb = QBX:CanUseItem(itemName)
    return cb and cb(source, data)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local groups = QBX:GetGroups(player.source)
    return {
        source = player.source,
        name = ('%s %s'):format(player.charinfo.firstname, player.charinfo.lastname),
        groups = groups,
        sex = player.charinfo.gender,
        dateofbirth = player.charinfo.birthdate,
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if not accounts then return end

    local player = QBX:GetPlayer(inv.id)
    player.Functions.SetPlayerData('items', inv.items)

    for account, amount in pairs(accounts) do
        local accountName = account == 'money' and 'cash' or account
        if player.Functions.GetMoney(accountName) ~= amount then
            player.Functions.SetMoney(accountName, amount, ('Sync %s with inventory'):format(accountName))
        end
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local player = QBX:GetPlayer(inv.id)
    return player and player.PlayerData.metadata.licences[license]
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
    local player = QBX:GetPlayer(inv.id)
    if not player then return end

    if player.PlayerData.metadata.licences[license.name] then
        return false, 'already_have'
    elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
        return false, 'can_not_afford'
    end

    Inventory.RemoveItem(inv, 'money', license.price)
    player.PlayerData.metadata.licences[license.name] = true
    player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

    return true, 'have_purchased'
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group, grade)
    return QBX:IsGradeBoss(group, grade)
end

---@param entityId number
---@return number | string
---@diagnostic disable-next-line: duplicate-set-field
function server.getOwnedVehicleId(entityId)
    if not entityId or entityId == 0 or not native.DoesEntityExist(entityId) then return end

    local entityState = native.Entity(entityId).state
    local vehicleId = entityState and entityState.vehicleid
    if vehicleId then return vehicleId end

    local plate = native.GetVehicleNumberPlateText(entityId)
    if type(plate) ~= 'string' or plate == '' then return end

    plate = plate:match('^%s*(.-)%s*$')
    if plate == '' then return end

    return ports.database.scalar('SELECT id FROM player_vehicles WHERE plate = ? LIMIT 1', { plate })
end

    -- END INSTALLED BRIDGE BODY
    local wrappers={}
    for _,name in ipairs(methods)do local fn=assert(server[name]);wrappers[name]=function(...)return invoke(fn,...)end end
    function api.Close()
        phase='closed';for key in pairs(loading)do loading[key]=nil end
        local clean=true
        for i=#records,1,-1 do local r=records[i]
            if r.token then local ok,result=pcall(ports.events.remove,r.token);if ok and result~=false then r.token=nil else clean=false end end
            if r.uncertain then clean=false end
        end
        for _,name in ipairs(methods)do
            if published[name]and rawget(target,name)==wrappers[name]then rawset(target,name,before[name])end;published[name]=nil
        end
        return clean and pending==0
    end
    function api.Install()
        if phase~='allocated'then return false,'inventory bridge installation not repeatable'end
        phase='installing';pending=pending+1
        local ok,problem=pcall(function()
            assert(valid()and contract.Check(),'inventory bridge provider not ready')
            for _,name in ipairs(methods)do assert(rawget(target,name)==before[name],'foreign inventory method: '..name)end
            for _,r in ipairs(records)do
                assert(phase=='installing'and valid(),'inventory bridge closed during registration')
                local accepted,token=pcall(ports.events.listen,r.name,function(...)
                    if phase=='installed'and valid()then return invoke(r.handler,...)end
                end)
                if not accepted or token==nil or token==false then r.uncertain=true;error(accepted and'inventory event token required'or token,0)end
                r.token=token
            end
            assert(phase=='installing'and valid(),'inventory bridge closed during registration')
            for _,timer in ipairs(timers)do
                assert(ports.schedule(timer.ms,function(...)if phase=='installed'and valid()then return invoke(timer.handler,...)end end)~=false,'inventory timeout refused')
                assert(phase=='installing'and valid(),'inventory bridge closed during scheduling')
            end
            for _,name in ipairs(methods)do
                assert(rawget(target,name)==before[name],'inventory method replaced before commit')
                rawset(target,name,wrappers[name]);published[name]=true
            end
            assert(phase=='installing'and valid(),'inventory bridge closed before commit')
        end)
        pending=pending-1
        if not ok then api.Close();return false,problem end
        phase='installed';return true
    end
    function api.Progress()
        local listeners,unknown=0,0;for _,r in ipairs(records)do if r.token then listeners=listeners+1 end;if r.uncertain then unknown=unknown+1 end end
        return{phase=phase,pending=pending,listeners=listeners,uncertainRegistrations=unknown,retainedTimers=#timers,
            physicalTimerCancellation=false,complete=phase=='closed'and pending==0 and listeners==0 and unknown==0}
    end
    function api.Describe()local out={};for i,name in ipairs(methods)do out[i]=name end;return{methods=out,events=#records,timers=#timers,protocol=contract.Protocol}end
    return api
end
