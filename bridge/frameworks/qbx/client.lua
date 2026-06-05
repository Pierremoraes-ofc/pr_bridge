if ActiveBridges["frameworks"] ~= "qbx" then return end

local framework = {}
local qbx_core = exports.qbx_core

QBX = QBX or {}
QBX.PlayerData = QBX.PlayerData or qbx_core:GetPlayerData() or {}

local cashAmount = QBX.PlayerData and QBX.PlayerData.money and QBX.PlayerData.money.cash or 0
local bankAmount = QBX.PlayerData and QBX.PlayerData.money and QBX.PlayerData.money.bank or 0

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    QBX.PlayerData = {}
    cashAmount = 0
    bankAmount = 0
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(value)
    QBX.PlayerData = value or {}

    if QBX.PlayerData.money then
        cashAmount = QBX.PlayerData.money.cash or 0
        bankAmount = QBX.PlayerData.money.bank or 0
    end
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
    if not QBX.PlayerData or not QBX.PlayerData.money then return end

    cashAmount = QBX.PlayerData.money.cash or 0
    bankAmount = QBX.PlayerData.money.bank or 0
end)

---Get Player data
---@return table
function framework.GetPlayer()
    local playerData = QBX.PlayerData
    if not playerData or not playerData.charinfo then return {} end

    local player = playerData.charinfo
    local firstName = player.firstname
    local lastName = player.lastname
    return {
        fullName = ("%s %s"):format(firstName, lastName),
        firstName = firstName,
        lastName = lastName,
        dob = player.birthdate,
        gender = player.gender
    }
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    if QBX.PlayerData and QBX.PlayerData.money then
        cashAmount = QBX.PlayerData.money.cash or cashAmount
        bankAmount = QBX.PlayerData.money.bank or bankAmount
    end

    if type == "cash" then
        return cashAmount
    elseif type == "bank" then
        return bankAmount
    elseif type == "black" then
        if Bridge.inventory and Bridge.inventory.GetItemCount then
            -- Tentamos pegar o item de dinheiro sujo. Se não existir ou for 0, retornamos o cash normal.
            local dirtyMoney = Bridge.inventory.GetItemCount("black_money")
            return dirtyMoney > 0 and dirtyMoney or cashAmount
        end
        
        return cashAmount
    end
end

---Get all job info for the player
---@return table
function framework.GetJobInfo()
    local player = QBX.PlayerData
    if not player or not player.job then return {} end

    local job = player.job
    return {
        grade = job.grade.level,
        gradeName = job.grade.name,
        jobName = job.name,
        jobLabel = player.job.label
    }
end

---@return boolean
function framework.IsPlayerLoaded()
    return QBX.PlayerData ~= nil
end

-- Documentation implementation


---@param meta string
---@return any
function framework.getPlayerMetadata(meta)
    local playerData = QBX.PlayerData
    if not playerData or not playerData.metadata then return nil end

    local metadata = playerData.metadata[meta]
    return metadata
end

---@param wear boolean
---@param outfits table
function framework.toggleOutfit(wear, outfits)
    if wear then
        local playerData = QBX.PlayerData
        if not playerData then return end
        local gender = playerData.charinfo.gender
        local outfit = gender == 1 and outfits.Female or outfits.Male
        if not outfit then return end
        TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = outfit })
    else
        TriggerServerEvent('qb-clothing:loadPlayerSkin')
    end
end

return framework
