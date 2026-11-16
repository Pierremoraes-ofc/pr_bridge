-- Prepared Forge server adapter. No detection, global exports or startup effects.
return function(ports)
    local owner=assert(ports.isCurrent);local phase,pending='open',0
    local function current()local ok,value=pcall(owner);return phase=='open'and ok and value==true end
    local function call(fn,...)
        assert(current(),'forge_server_adapter_closed');pending=pending+1
        local result=table.pack(pcall(fn,...));pending=pending-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local function scope(value,seen)
        if value==nil then return end;assert(type(value)=='table','explicit adapter port table required')
        seen=seen or{};if seen[value]then return seen[value]end;local out={};seen[value]=out
        for k,v in pairs(value)do
            if type(v)=='function'then local fn=v;out[k]=function(...)return call(fn,...)end
            elseif type(v)=='table'then out[k]=scope(v,seen)else out[k]=v end
        end;return out
    end
    local core=scope(assert(ports.core));local inventory,banking=scope(ports.inventory),scope(ports.banking)
    local db,callback,native=scope(ports.db),scope(ports.callback),scope(assert(ports.native))
    local decode=function(...)return call(assert(ports.decode),...)end
    local framework={}
function framework.RegisterCallback(name, cb)
    if callback then
        callback.register(name, cb)
    end
end

function framework.GetWeapon(source, name)
    if inventory and inventory.GetWeapon then return inventory.GetWeapon(source, name) end
    local Player = core.GetPlayer(source)
    if not Player then return 0 end
    local item = call(Player.Functions.GetItemByName, name)
    return item and item.amount or 0
end

function framework.GetIdentifier(source)
    local Player = core.GetPlayer(source)
    return Player and Player.PlayerData.citizenid or nil
end

-- Player Data
function framework.getPlayerFromId(source)
    return core.GetPlayer(tonumber(source))
end

function framework.GetPlayerFromIdentifier(identifier)
    return core.GetPlayerByCitizenId(identifier)
end

function framework.GetOfflinePlayer(identifier)
    return core.GetOfflinePlayer(identifier)
end

function framework.getPlayerSourceFromPlayer(Player)
    return Player.PlayerData.source
end

function framework.getPlayerName(source)
    local Player = core.GetPlayer(source)
    if not Player then return "Unknown" end
    return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
end

function framework.getPlayerHeight(source)
    return '/'
end

--- Retorna as coordenadas do player
--- @param source number
--- @param withHeading boolean incluir heading (rotação) ou não
function framework.GetCoords(source, withHeading)
    local ped = native.GetPlayerPed(source)
    if withHeading then
        local coords = native.GetEntityCoords(ped)
        return native.vec4(coords.x, coords.y, coords.z, native.GetEntityHeading(ped))
    else
        return native.GetEntityCoords(ped)
    end
end

function framework.getPlayerDOB(source)
    local Player = core.GetPlayer(source)
    return Player and Player.PlayerData.charinfo.birthdate or nil
end

function framework.getPlayerSex(source)
    local Player = core.GetPlayer(source)
    if not Player then return 'm' end
    return Player.PlayerData.charinfo.gender == 0 and 'm' or 'f'
end

function framework.getPlayerMetadata(source, meta)
    local Player = core.GetPlayer(source)
    if not Player then return nil end
    return Player.PlayerData.metadata[meta]
end

function framework.setPlayerMetadata(source, meta, value)
    local Player = core.GetPlayer(source)
    if not Player then return end
    call(Player.Functions.SetMetaData, meta, value)
end

-- Status values are owned by qbx_core's server cache. These methods avoid a
-- metadata read/write race and keep cache, metadata and HUD synchronized.
function framework.GetPlayerStatus(source, status)
    local ok, value = pcall(function()
        return core.GetStatus(tonumber(source), status)
    end)
    if not ok then return nil, value end
    return value
end

function framework.SetPlayerStatus(source, status, value)
    local ok, result = pcall(function()
        return core.SetStatus(tonumber(source), status, value)
    end)
    if not ok then return false, result end
    return result ~= false
end

function framework.AddPlayerStatus(source, status, amount)
    local ok, result = pcall(function()
        return core.AddStatus(tonumber(source), status, amount)
    end)
    if not ok then return false, result end
    return result ~= false
end

framework.getPlayerStatus = framework.GetPlayerStatus
framework.setPlayerStatus = framework.SetPlayerStatus
framework.addPlayerStatus = framework.AddPlayerStatus
function framework.addSocietyBalance(job, amount)
    if not banking then return end
    banking.addAccountMoney(job, amount)
end

function framework.removeSocietyBalance(job, amount)
    if not banking then return end
    banking.removeAccountMoney(job, amount)
end

function framework.RegisterUsableItem(item, cb)
    core.CreateUseableItem(item, cb)
end

function framework.GetPlayer(source)
    return core.GetPlayer(source)
end

function framework.GetPlayerData(source)
    local Player = core.GetPlayer(source)
    return Player and Player.PlayerData or nil
end

function framework.HasPermission(source, permissions)
    local ok, allowed = pcall(function()
        return core.HasPermission(source, permissions)
    end)

    return ok and allowed == true
end

function framework.getItemByName(source, name)
    if inventory and inventory.GetItem then
        return inventory.GetItem(source, name)
    end
    local Player = core.GetPlayer(source)
    if not Player then return nil end
    return call(Player.Functions.GetItemByName, name)
end

function framework.CreateWeaponData(source, data, weaponData)
    if inventory and inventory.CreateWeaponData then return inventory.CreateWeaponData(source, data, weaponData) end
    return data
end

function framework.RemoveWeapon(source, data)
    if inventory and inventory.RemoveWeapon then return inventory.RemoveWeapon(source, data) end
    local Player = core.GetPlayer(source)
    return Player and call(Player.Functions.RemoveItem, data.weapon, 1) or false
end

function framework.AddWeapon(source, data)
    if inventory and inventory.AddWeapon then return inventory.AddWeapon(source, data) end
    local Player = core.GetPlayer(source)
    return Player and call(Player.Functions.AddItem, data.weapon, 1) or false
end

function framework.getPlayerGroup(source)
    -- QBX uses permissions, returning 'user' by default if no perms found
    -- This is a simplification
    return "user"
end

function framework.getPlayerJob(source, dataType)
    local Player = core.GetPlayer(source)
    if not Player then return nil end
    local job = Player.PlayerData.job
    if dataType == 'label' then
        return job.label
    elseif dataType == 'name' then
        return job.name
    elseif dataType == 'grade' then
        return job.grade.level
    elseif dataType == 'gradeLabel' then
        return job.grade.name
    end
end

function framework.GetPlayerJob(source)
    local Player = core.GetPlayer(source)
    return Player and Player.PlayerData.job or nil
end

function framework.SetPlayerJob(source, jobName, grade)
    local ok, success, result = pcall(function()
        return core.SetJob(source, jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerDuty(source, onDuty)
    local ok, result = pcall(function()
        return core.SetJobDuty(source, onDuty == true)
    end)

    if not ok then return false, result end
    return result ~= false, result
end

function framework.AddPlayerToJob(citizenid, jobName, grade)
    local ok, success, result = pcall(function()
        return core.AddPlayerToJob(citizenid, jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.RemovePlayerFromJob(citizenid, jobName)
    local ok, success, result = pcall(function()
        return core.RemovePlayerFromJob(citizenid, jobName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerPrimaryJob(citizenid, jobName)
    local ok, success, result = pcall(function()
        return core.SetPlayerPrimaryJob(citizenid, jobName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.AddPlayerToGang(citizenid, gangName, grade)
    local ok, success, result = pcall(function()
        return core.AddPlayerToGang(citizenid, gangName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.RemovePlayerFromGang(citizenid, gangName)
    local ok, success, result = pcall(function()
        return core.RemovePlayerFromGang(citizenid, gangName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerPrimaryGang(citizenid, gangName)
    local ok, success, result = pcall(function()
        return core.SetPlayerPrimaryGang(citizenid, gangName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.PlayerHasJob(source, jobName, grade)
    local Player = core.GetPlayer(source)
    if not Player or not Player.PlayerData then return false end

    jobName = tostring(jobName or ''):lower()
    local jobs = Player.PlayerData.jobs or {}
    local playerGrade = jobs[jobName]

    if playerGrade == nil and Player.PlayerData.job and Player.PlayerData.job.name == jobName then
        local currentGrade = Player.PlayerData.job.grade
        playerGrade = type(currentGrade) == 'table' and (currentGrade.level or currentGrade.grade) or currentGrade
    end

    if playerGrade == nil then return false end
    if grade == nil then return true end

    return (tonumber(playerGrade) or 0) >= (tonumber(grade) or 0)
end

function framework.getPlayerMoney(source, moneyWallet)
    if moneyWallet == 'money' then moneyWallet = 'cash' end
    if moneyWallet == 'black_money' then moneyWallet = 'blackmoney' end
    return core.GetMoney(source, moneyWallet)
end

function framework.addPlayerMoney(source, moneyWallet, amount, reason)
    if moneyWallet == 'money' then moneyWallet = 'cash' end
    if moneyWallet == 'black_money' then moneyWallet = 'blackmoney' end
    return core.AddMoney(source, moneyWallet, amount, reason or "Unknown")
end

function framework.removePlayerMoney(source, moneyWallet, amount, reason)
    if moneyWallet == 'money' then moneyWallet = 'cash' end
    if moneyWallet == 'black_money' then moneyWallet = 'blackmoney' end
    return core.RemoveMoney(source, moneyWallet, amount, reason or "Unknown")
end

function framework.InventoryManagement(source, data)
    local Player = core.GetPlayer(source)
    if not Player then return end

    if data.type == 'valid' then
        -- This is a bit complex in QBX without QBCore.Shared.Items
        return true
    elseif data.type == 'label' then
        return data.item
    elseif data.type == 'count' then
        local PlayerItem = call(Player.Functions.GetItemByName, data.item)
        return PlayerItem and PlayerItem.amount or 0
    elseif data.type == 'weight' then
        return 0
    elseif data.type == 'add' then
        call(Player.Functions.AddItem, data.item, data.amount)
    elseif data.type == 'remove' then
        call(Player.Functions.RemoveItem, data.item, data.amount)
    end
end

-- Vehicle functions
function framework.GetOwnedVehicleOwner(plate)
    local result = db and db.single('SELECT citizenid FROM player_vehicles WHERE plate = ?', { plate })
    return result and result.citizenid or nil
end

function framework.GetOwnedVehicleData(plate)
    local result = db and db.single('SELECT mods FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return {
            props = decode(result.mods)
        }
    else
        return nil
    end
end

function framework.DeleteOwnedVehicle(plate)
    if db then
        db.execute('DELETE FROM player_vehicles WHERE plate = ?', { plate })
    end
end

function framework.InsertOwnedVehicle(plate, owner, vehicle)
    local Player = core.GetPlayer(owner)
    if not Player then return end

    local VehicleProps = decode(vehicle)
    if not VehicleProps or not VehicleProps['plate'] or not VehicleProps['model'] then return end

    if not db then return end

    db.execute(
        'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (@license, @citizenid, @vehicle, @hash, @mods, @plate, @state)',
        {
            ['@license'] = Player.PlayerData.license,
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@vehicle'] = VehicleProps['model'],
            ['@hash'] = VehicleProps['model'],
            ['@mods'] = vehicle,
            ['@plate'] = VehicleProps['plate'],
            ['@state'] = 0,
        })
end

function framework.GetPlayerNameByIdentifier(identifier)
    local Player = core.GetPlayerByCitizenId(identifier)
    if Player then
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    else
        local result = db and db.single('SELECT charinfo FROM players WHERE citizenid = ?', { identifier })
        if result then
            local charinfo = decode(result.charinfo)
            return ('%s %s'):format(charinfo.firstname, charinfo.lastname)
        end
    end
    return "Unknown"
end

-- Original exports converted to framework functions for consistency
function framework.takeMoney(src, amount, reason)
    if core.GetMoney(src, 'cash') >= amount then
        core.RemoveMoney(src, 'cash', amount, reason)
        return true
    elseif core.GetMoney(src, 'bank') >= amount then
        core.RemoveMoney(src, 'bank', amount, reason)
        return true
    else
        return false
    end
end

function framework.addMoney(src, amount, account, reason)
    core.AddMoney(src, account, amount, reason)
end


    local api={OperationalReady=false,Framework={}};local wrapped={}
    for name,fn in pairs(framework)do
        if not wrapped[fn]then wrapped[fn]=function(...)if not current()then return end;return call(fn,...)end end
        api.Framework[name]=wrapped[fn]
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
