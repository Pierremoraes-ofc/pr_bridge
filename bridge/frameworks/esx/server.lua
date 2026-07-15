local framework = {}
if ActiveBridges["frameworks"] ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

Debug('SUCCESS', Lang:t('Debug.FrameworkDetected', { framework = 'ESX Legacy' }))


function framework.RegisterCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function framework.GetWeapon(source, name)
    if Inventory and Inventory.GetWeapon then return Inventory.GetWeapon(source, name) end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end
    local item = xPlayer.getInventoryItem(name)
    return item and item.count or 0
end

function framework.GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.getIdentifier() or nil
end

-- Player Data
function framework.getPlayerFromId(source)
    return ESX.GetPlayerFromId(tonumber(source))
end

function framework.GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function framework.getPlayerSourceFromPlayer(Player)
    return Player.source
end

function framework.getPlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return "Unknown" end
    return xPlayer.variables.firstName .. ' ' .. xPlayer.variables.lastName
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
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.variables.dateofbirth or nil
end

function framework.getPlayerSex(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.variables.sex or 'm'
end

function framework.GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function framework.GetPlayerData(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.get and xPlayer.get() or xPlayer
end

function framework.getPlayerJob(source, dataType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end
    local job = xPlayer.getJob()
    if dataType == 'label' then
        return job.label
    elseif dataType == 'name' then
        return job.name
    elseif dataType == 'grade' then
        return job.grade
    elseif dataType == 'gradeLabel' then
        return job.grade_label
    end
    return job
end

function framework.GetPlayerJob(source)
    return framework.getPlayerJob(source)
end

function framework.SetPlayerJob(source, jobName, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.setJob then return false, 'invalid_player' end

    local ok, result = pcall(function()
        return xPlayer.setJob(jobName, tonumber(grade) or 0)
    end)

    if not ok then return false, result end
    return result ~= false, result
end

function framework.SetPlayerDuty(source, onDuty)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false, 'invalid_player' end

    if xPlayer.set and type(xPlayer.set) == 'function' then
        xPlayer.set('onduty', onDuty == true)
        return true
    end

    return false, 'duty_unavailable'
end

function framework.PlayerHasJob(source, jobName, grade)
    local job = framework.GetPlayerJob(source)
    if not job or tostring(job.name or ''):lower() ~= tostring(jobName or ''):lower() then return false end
    if grade == nil then return true end

    return (tonumber(job.grade) or 0) >= (tonumber(grade) or 0)
end

function framework.getPlayerMoney(source, moneyWallet)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end
    if moneyWallet == 'cash' or moneyWallet == 'money' then
        return xPlayer.getAccount('money').money
    elseif moneyWallet == 'bank' then
        return xPlayer.getAccount('bank').money
    elseif moneyWallet == 'black_money' then
        return xPlayer.getAccount('black_money').money
    end
    return 0
end

function framework.addPlayerMoney(source, moneyWallet, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if moneyWallet == 'cash' or moneyWallet == 'money' then
        xPlayer.addAccountMoney('money', amount)
    elseif moneyWallet == 'bank' then
        xPlayer.addAccountMoney('bank', amount)
    elseif moneyWallet == 'black_money' then
        xPlayer.addAccountMoney('black_money', amount)
    end
end

function framework.removePlayerMoney(source, moneyWallet, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if moneyWallet == 'cash' or moneyWallet == 'money' then
        xPlayer.removeAccountMoney('money', amount)
    elseif moneyWallet == 'bank' then
        xPlayer.removeAccountMoney('bank', amount)
    elseif moneyWallet == 'black_money' then
        xPlayer.removeAccountMoney('black_money', amount)
    end
end

function framework.getPlayerMetadata(source, meta)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.getMeta(meta)
end

function framework.setPlayerMetadata(source, meta, value)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    xPlayer.setMeta(meta, value)
end

function framework.addSocietyBalance(job, amount)
    local society = exports['esx_society']:GetSociety(job)
    if not society then return end
    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
        account.addMoney(amount)
    end)
end

function framework.removeSocietyBalance(job, amount)
    local society = exports['esx_society']:GetSociety(job)
    if not society then return end
    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
        account.removeMoney(amount)
    end)
end

function framework.RegisterUsableItem(item, cb)
    ESX.RegisterUsableItem(item, cb)
end

-- Vehicle functions
function framework.GetOwnedVehicleOwner(plate)
    local result = Bridge.db and Bridge.db.single('SELECT owner FROM owned_vehicles WHERE plate = ?', { plate })
    return result and result.owner or nil
end

function framework.GetOwnedVehicleData(plate)
    local result = Bridge.db and Bridge.db.single('SELECT vehicle FROM owned_vehicles WHERE plate = ?', { plate })
    if result then
        return {
            props = json.decode(result.vehicle)
        }
    else
        return nil
    end
end

function framework.DeleteOwnedVehicle(plate)
    if Bridge.db then
        Bridge.db.execute('DELETE FROM owned_vehicles WHERE plate = ?', { plate })
    end
end

function framework.InsertOwnedVehicle(plate, owner, vehicle)
    if not Bridge.db then return end

    Bridge.db.execute(
        'INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, `stored`) VALUES (@owner, @plate, @vehicle, @type, @job, @stored)',
        {
            ['@owner'] = owner,
            ['@plate'] = plate,
            ['@vehicle'] = vehicle,
            ['@type'] = 'car',
            ['@job'] = nil,
            ['@stored'] = 1,
        })
end

function framework.GetPlayerNameByIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    if xPlayer then
        return xPlayer.variables.firstName .. " " .. xPlayer.variables.lastName
    else
        local result = Bridge.db and Bridge.db.single('SELECT firstname, lastname FROM users WHERE identifier = ?', { identifier })
        if result then
            return ('%s %s'):format(result.firstname, result.lastname)
        end
    end
    return "Unknown"
end

return framework
