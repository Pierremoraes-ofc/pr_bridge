local framework = {}
if ActiveBridges["frameworks"] ~= "qbx" then return end

local qbx_core = exports.qbx_core

Debug('SUCCESS', Lang:t('Debug.FrameworkDetected', { framework = 'QBX Core' }))

function framework.RegisterCallback(name, cb)
    if PRCore and PRCore.callback then
        PRCore.callback.register(name, cb)
    end
end

function framework.GetWeapon(source, name)
    if Bridge.inventory and Bridge.inventory.GetWeapon then return Bridge.inventory.GetWeapon(source, name) end
    local Player = qbx_core:GetPlayer(source)
    if not Player then return 0 end
    local item = Player.Functions.GetItemByName(name)
    return item and item.amount or 0
end

function framework.GetIdentifier(source)
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.PlayerData.citizenid or nil
end

-- Player Data
function framework.getPlayerFromId(source)
    return qbx_core:GetPlayer(tonumber(source))
end

function framework.GetPlayerFromIdentifier(identifier)
    return qbx_core:GetPlayerByCitizenId(identifier)
end

function framework.getPlayerSourceFromPlayer(Player)
    return Player.PlayerData.source
end

function framework.getPlayerName(source)
    local Player = qbx_core:GetPlayer(source)
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
    local ped = GetPlayerPed(source)
    if withHeading then
        local coords = GetEntityCoords(ped)
        return vec4(coords.x, coords.y, coords.z, GetEntityHeading(ped))
    else
        return GetEntityCoords(ped)
    end
end

function framework.getPlayerDOB(source)
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.PlayerData.charinfo.birthdate or nil
end

function framework.getPlayerSex(source)
    local Player = qbx_core:GetPlayer(source)
    if not Player then return 'm' end
    return Player.PlayerData.charinfo.gender == 0 and 'm' or 'f'
end

function framework.getPlayerMetadata(source, meta)
    local Player = qbx_core:GetPlayer(source)
    if not Player then return nil end
    return Player.PlayerData.metadata[meta]
end

function framework.setPlayerMetadata(source, meta, value)
    local Player = qbx_core:GetPlayer(source)
    if not Player then return end
    Player.Functions.SetMetaData(meta, value)
end

function framework.addSocietyBalance(job, amount)
    if not exports['Renewed-Banking'] then return end
    exports['Renewed-Banking']:addAccountMoney(job, amount)
end

function framework.removeSocietyBalance(job, amount)
    if not exports['Renewed-Banking'] then return end
    exports['Renewed-Banking']:removeAccountMoney(job, amount)
end

function framework.RegisterUsableItem(item, cb)
    qbx_core:CreateUseableItem(item, cb)
end

function framework.GetPlayer(source)
    return qbx_core:GetPlayer(source)
end

function framework.GetPlayerData(source)
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.PlayerData or nil
end

function framework.HasPermission(source, permissions)
    local ok, allowed = pcall(function()
        return qbx_core:HasPermission(source, permissions)
    end)

    return ok and allowed == true
end

function framework.getItemByName(source, name)
    if Bridge.inventory and Bridge.inventory.GetItem then
        return Bridge.inventory.GetItem(source, name)
    end
    local Player = qbx_core:GetPlayer(source)
    if not Player then return nil end
    return Player.Functions.GetItemByName(name)
end

function framework.CreateWeaponData(source, data, weaponData)
    if Bridge.inventory and Bridge.inventory.CreateWeaponData then return Bridge.inventory.CreateWeaponData(source, data, weaponData) end
    return data
end

function framework.RemoveWeapon(source, data)
    if Bridge.inventory and Bridge.inventory.RemoveWeapon then return Bridge.inventory.RemoveWeapon(source, data) end
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.Functions.RemoveItem(data.weapon, 1) or false
end

function framework.AddWeapon(source, data)
    if Bridge.inventory and Bridge.inventory.AddWeapon then return Bridge.inventory.AddWeapon(source, data) end
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.Functions.AddItem(data.weapon, 1) or false
end

function framework.getPlayerGroup(source)
    -- QBX uses permissions, returning 'user' by default if no perms found
    -- This is a simplification
    return "user"
end

function framework.getPlayerJob(source, dataType)
    local Player = qbx_core:GetPlayer(source)
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
    local Player = qbx_core:GetPlayer(source)
    return Player and Player.PlayerData.job or nil
end

function framework.SetPlayerJob(source, jobName, grade)
    local ok, success, result = pcall(function()
        return qbx_core:SetJob(source, jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerDuty(source, onDuty)
    local ok, result = pcall(function()
        return qbx_core:SetJobDuty(source, onDuty == true)
    end)

    if not ok then return false, result end
    return result ~= false, result
end

function framework.AddPlayerToJob(citizenid, jobName, grade)
    local ok, success, result = pcall(function()
        return qbx_core:AddPlayerToJob(citizenid, jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.RemovePlayerFromJob(citizenid, jobName)
    local ok, success, result = pcall(function()
        return qbx_core:RemovePlayerFromJob(citizenid, jobName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerPrimaryJob(citizenid, jobName)
    local ok, success, result = pcall(function()
        return qbx_core:SetPlayerPrimaryJob(citizenid, jobName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.AddPlayerToGang(citizenid, gangName, grade)
    local ok, success, result = pcall(function()
        return qbx_core:AddPlayerToGang(citizenid, gangName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.RemovePlayerFromGang(citizenid, gangName)
    local ok, success, result = pcall(function()
        return qbx_core:RemovePlayerFromGang(citizenid, gangName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.SetPlayerPrimaryGang(citizenid, gangName)
    local ok, success, result = pcall(function()
        return qbx_core:SetPlayerPrimaryGang(citizenid, gangName)
    end)

    if not ok then return false, success end
    return success == true, result
end

function framework.PlayerHasJob(source, jobName, grade)
    local Player = qbx_core:GetPlayer(source)
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
    return qbx_core:GetMoney(source, moneyWallet)
end

function framework.addPlayerMoney(source, moneyWallet, amount, reason)
    if moneyWallet == 'money' then moneyWallet = 'cash' end
    if moneyWallet == 'black_money' then moneyWallet = 'blackmoney' end
    qbx_core:AddMoney(source, moneyWallet, amount, reason or "Unknown")
end

function framework.removePlayerMoney(source, moneyWallet, amount, reason)
    if moneyWallet == 'money' then moneyWallet = 'cash' end
    if moneyWallet == 'black_money' then moneyWallet = 'blackmoney' end
    return qbx_core:RemoveMoney(source, moneyWallet, amount, reason or "Unknown")
end

function framework.InventoryManagement(source, data)
    local Player = qbx_core:GetPlayer(source)
    if not Player then return end

    if data.type == 'valid' then
        -- This is a bit complex in QBX without QBCore.Shared.Items
        return true
    elseif data.type == 'label' then
        return data.item
    elseif data.type == 'count' then
        local PlayerItem = Player.Functions.GetItemByName(data.item)
        return PlayerItem and PlayerItem.amount or 0
    elseif data.type == 'weight' then
        return 0
    elseif data.type == 'add' then
        Player.Functions.AddItem(data.item, data.amount)
    elseif data.type == 'remove' then
        Player.Functions.RemoveItem(data.item, data.amount)
    end
end

-- Vehicle functions
function framework.GetOwnedVehicleOwner(plate)
    local result = Bridge.db and Bridge.db.single('SELECT citizenid FROM player_vehicles WHERE plate = ?', { plate })
    return result and result.citizenid or nil
end

function framework.GetOwnedVehicleData(plate)
    local result = Bridge.db and Bridge.db.single('SELECT mods FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return {
            props = json.decode(result.mods)
        }
    else
        return nil
    end
end

function framework.DeleteOwnedVehicle(plate)
    if Bridge.db then
        Bridge.db.execute('DELETE FROM player_vehicles WHERE plate = ?', { plate })
    end
end

function framework.InsertOwnedVehicle(plate, owner, vehicle)
    local Player = qbx_core:GetPlayer(owner)
    if not Player then return end

    local VehicleProps = json.decode(vehicle)
    if not VehicleProps or not VehicleProps['plate'] or not VehicleProps['model'] then return end

    if not Bridge.db then return end

    Bridge.db.execute(
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
    local Player = qbx_core:GetPlayerByCitizenId(identifier)
    if Player then
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    else
        local result = Bridge.db and Bridge.db.single('SELECT charinfo FROM players WHERE citizenid = ?', { identifier })
        if result then
            local charinfo = json.decode(result.charinfo)
            return ('%s %s'):format(charinfo.firstname, charinfo.lastname)
        end
    end
    return "Unknown"
end

-- Original exports converted to framework functions for consistency
function framework.takeMoney(src, amount, reason)
    if qbx_core:GetMoney(src, 'cash') >= amount then
        qbx_core:RemoveMoney(src, 'cash', amount, reason)
        return true
    elseif qbx_core:GetMoney(src, 'bank') >= amount then
        qbx_core:RemoveMoney(src, 'bank', amount, reason)
        return true
    else
        return false
    end
end

function framework.addMoney(src, amount, account, reason)
    qbx_core:AddMoney(src, account, amount, reason)
end

return framework
