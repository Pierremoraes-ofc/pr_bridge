local framework = {}
if ActiveBridges["frameworks"] ~= "qb" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

Debug('SUCCESS', Lang:t('Debug.FrameworkDetected', { framework = 'QB Core' }))

function framework.RegisterCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function framework.GetWeapon(source, name)
    if Inventory.GetWeapon then return Inventory.GetWeapon(source, name) end
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local item = xPlayer.Functions.GetItemByName(name)
    if item ~= nil then
        return item.amount
    else
        return 0
    end
end

function framework.GetIdentifier(source)
    local source = source  -- Save Variable
    local Identifier = nil -- Create new Variable
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        Identifier = Player.PlayerData.citizenid
    end

    return Identifier
end

-- Player Data
function framework.getPlayerFromId(source)
    return QBCore.Functions.GetPlayer(tonumber(source))
end

function framework.GetPlayerFromIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

function framework.getPlayerSourceFromPlayer(Player)
    return Player.PlayerData.source
end

function framework.getPlayerName(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
end

function framework.getPlayerHeight(source)
    return '/' -- TODO: Lookup for alternative
end

--- Retorna as coordenadas do player (compatível com ESX e QBCore)
--- @param source number
--- @param withHeading boolean incluir heading (rotação) ou não
function framework.GetCoords(source, withHeading)
    local ped = GetPlayerPed(source)
    if withHeading then
        return vec4(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, GetEntityHeading(ped))
    else
        return GetEntityCoords(ped)
    end
end

function framework.getPlayerDOB(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.charinfo.birthdate
end

function framework.getPlayerSex(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.charinfo.gender == 0 and 'm' or 'f'
end

function framework.getPlayerMetadata(source, meta)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return nil end
    return Player.PlayerData.metadata[meta]
end

function framework.setPlayerMetadata(source, meta, value)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    Player.Functions.SetMeta(meta, value)
end

function framework.addSocietyBalance(job, amount)
    local society = exports['qb-banking']:GetAccount(job)
    if not society then return end
    exports['qb-banking']:AddMoney(society, amount, '')
end

function framework.removeSocietyBalance(job, amount)
    local society = exports['qb-banking']:GetAccount(job)
    if not society then return end
    exports['qb-banking']:RemoveMoney(society, amount, '')
end

function framework.RegisterUsableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, cb)
end

function framework.GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function framework.GetPlayerData(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player and Player.PlayerData or nil
end

function framework.getItemByName(name)
    return xPlayer.Functions.GetItemByName(name)
end

function framework.CreateWeaponData(source, data, weaponData)
    if Inventory.CreateWeaponData then return Inventory.CreateWeaponData(source, data, weaponData) end
    return data
end

function framework.RemoveWeapon(source, data)
    if Inventory.RemoveWeapon then return Inventory.RemoveWeapon(source, data) end
    local xPlayer = QBCore.Functions.GetPlayer(source)
    return xPlayer.Functions.RemoveItem(data.weapon, 1)
end

function framework.AddWeapon(source, data)
    if Inventory.AddWeapon then return Inventory.AddWeapon(source, data) end
    local xPlayer = QBCore.Functions.GetPlayer(source)
    return xPlayer.Functions.AddItem(data.weapon, 1)
end

function framework.getPlayerGroup(source)
    local PlayerPerms = QBCore.Functions.GetPermission(source)
    if type(PlayerPerms) == "table" and next(PlayerPerms) then
        local PlayerPermsString = 'Unknown'
        for k, v in pairs(PlayerPerms) do
            if PlayerPermsString == 'Unknown' then
                PlayerPermsString = k
            else
                PlayerPermsString = PlayerPermsString .. ', ' .. k
            end
        end
        return PlayerPermsString
    else
        return 'user'
    end
end

function framework.getPlayerJob(source, dataType)
    local Player = framework.getPlayerFromId(source)
    if not Player or not Player.PlayerData or not Player.PlayerData.job then return nil end
    if dataType == 'label' then
        return Player.PlayerData.job.label
    elseif dataType == 'name' then
        return Player.PlayerData.job.name
    elseif dataType == 'grade' then
        return Player.PlayerData.job.grade.level
    elseif dataType == 'gradeLabel' then
        return Player.PlayerData.job.grade.name
    end
end

function framework.GetPlayerJob(source)
    local Player = framework.getPlayerFromId(source)
    return Player and Player.PlayerData and Player.PlayerData.job or nil
end

function framework.SetPlayerJob(source, jobName, grade)
    local Player = framework.getPlayerFromId(source)
    if not Player or not Player.Functions or not Player.Functions.SetJob then return false, 'invalid_player' end

    local ok, success, result = pcall(function()
        return Player.Functions.SetJob(jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, success end
    return success ~= false, result
end

function framework.SetPlayerDuty(source, onDuty)
    local Player = framework.getPlayerFromId(source)
    if not Player or not Player.Functions or not Player.Functions.SetJobDuty then return false, 'invalid_player' end

    local ok, result = pcall(function()
        return Player.Functions.SetJobDuty(onDuty == true)
    end)

    if not ok then return false, result end
    return result ~= false, result
end

function framework.PlayerHasJob(source, jobName, grade)
    local job = framework.GetPlayerJob(source)
    if not job or tostring(job.name or ''):lower() ~= tostring(jobName or ''):lower() then return false end
    if grade == nil then return true end

    local jobGrade = job.grade
    local level = type(jobGrade) == 'table' and (jobGrade.level or jobGrade.grade or jobGrade.value) or jobGrade
    return (tonumber(level) or 0) >= (tonumber(grade) or 0)
end

function framework.getPlayerMoney(source, moneyWallet)
    local Player = framework.getPlayerFromId(source)
    if moneyWallet == 'money' then
        return Player.PlayerData.money['cash']
    elseif moneyWallet == 'bank' then
        return Player.PlayerData.money['bank']
    elseif moneyWallet == 'black_money' then
        return Player.PlayerData.money['blackmoney']
    end
end

function framework.addPlayerMoney(source, moneyWallet, amount)
    local Player = framework.getPlayerFromId(source)
    if moneyWallet == 'money' then
        Player.Functions.AddMoney('cash', amount)
    elseif moneyWallet == 'bank' then
        Player.Functions.AddMoney('bank', amount)
    elseif moneyWallet == 'black_money' then
        Player.Functions.AddMoney('blackmoney', amount)
    end
end

function framework.removePlayerMoney(source, moneyWallet, amount)
    local Player = framework.getPlayerFromId(source)
    if moneyWallet == 'money' then
        Player.Functions.RemoveMoney('cash', amount)
    elseif moneyWallet == 'bank' then
        Player.Functions.RemoveMoney('bank', amount)
    elseif moneyWallet == 'black_money' then
        Player.Functions.RemoveMoney('blackmoney', amount)
    end
end

function framework.InventoryManagement(source, data)
    local Player = framework.getPlayerFromId(source)

    if data.type == 'valid' then
        return QBCore.Shared.Items[data.item:lower()] ~= nil
    elseif data.type == 'label' then
        return QBCore.Shared.Items[data.item:lower()].label
    elseif data.type == 'count' then
        local PlayerItem = Player.Functions.GetItemByName(data.item)
        if not PlayerItem then return 0 end -- Return 0 if player does not have item in inventory
        return Player.Functions.GetItemByName(data.item).amount
    elseif data.type == 'weight' then
        return QBCore.Shared.Items[data.item:lower()].weight
    elseif data.type == 'add' then
        Player.Functions.AddItem(data.item, data.amount)
    elseif data.type == 'remove' then
        Player.Functions.RemoveItem(data.item, data.amount)
    end
end

-- Dream Police Impound (QBCore Version)
function framework.GetOwnedVehicleOwner(plate)
    local result = Bridge.db and Bridge.db.single('SELECT * FROM player_vehicles WHERE plate = ?', { plate })
    return result and result.citizenid or nil
end

function framework.GetOwnedVehicleData(plate)
    local result = Bridge.db and Bridge.db.single('SELECT * FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return {
            props = json.decode(result.mods)
        }
    else
        return nil
    end
end

function framework.DeleteOwnedVehicle(plate)
    if not Bridge.db then return end

    if DreamCore.DeleteVehicle then
        Bridge.db.execute('DELETE FROM player_vehicles WHERE plate = ?', { plate })
    else
        Bridge.db.execute('UPDATE player_vehicles SET state = 2 WHERE plate = ?', { plate })
    end
end

local function getVehicleFromVehList(hash)
    for model, v in pairs(QBCore.Shared.Vehicles) do
        if hash == v.hash then
            return model -- Returns the spawn code, not the name
        end
    end
    return nil -- If not found
end

function framework.InsertOwnedVehicle(plate, owner, vehicle)
    local Player = framework.getPlayerFromId(owner)
    if not Player then
        Utils.Debug(Locales['Bridge']['Server']['Debug']['InsertOwnedVehicle'], tostring(owner))
        return
    end

    local VehicleProps = json.decode(vehicle)
    if not VehicleProps or not VehicleProps['plate'] or not VehicleProps['model'] then
        Utils.Debug(Locales['Bridge']['Server']['Debug']['InsertOwnedVehicle2'], tostring(plate))
        return
    end


    if DreamCore.DeleteVehicle then
        if not Bridge.db then return end

        -- Find vehicle spawn code based on model hash
        local vehname = getVehicleFromVehList(VehicleProps['model'])
        if not vehname then
            Utils.Debug((Locales['Bridge']['Server']['Debug']['InsertOwnedVehicle2']):format(VehicleProps['model']))
            return
        end

        Bridge.db.execute(
        'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (@license, @citizenid, @vehicle, @hash, @mods, @plate, @state)',
            {
                ['@license'] = Player.PlayerData.license,
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@vehicle'] = vehname, -- Vehicle spawn code (fixed)
                ['@hash'] = VehicleProps['model'],
                ['@mods'] = vehicle,
                ['@plate'] = VehicleProps['plate'],
                ['@state'] = 0,
            })
    else
        if Bridge.db then
            Bridge.db.execute('UPDATE player_vehicles SET state = 0 WHERE plate = ?', { plate })
        end
    end

end

function framework.GetPlayerNameByIdentifier(identifier)
    local Player = QBCore.Functions.GetPlayerByCitizenId(identifier)
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

return framework
