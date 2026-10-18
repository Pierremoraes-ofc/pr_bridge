if ActiveBridges["frameworks"] ~= "qbx" then return end

local framework = {}
local qbx_core = exports.qbx_core

QBX = QBX or {}
QBX.PlayerData = QBX.PlayerData or {}

local cashAmount = QBX.PlayerData and QBX.PlayerData.money and QBX.PlayerData.money.cash or 0
local bankAmount = QBX.PlayerData and QBX.PlayerData.money and QBX.PlayerData.money.bank or 0

local function setPlayerData(value)
    QBX.PlayerData = value or {}
    local money = QBX.PlayerData.money or {}
    cashAmount = money.cash or 0
    bankAmount = money.bank or 0
end

-- An explicit getter reads the snapshot already delivered by QBX. No startup
-- pull from the framework, polling, listener dispatch or producer discovery.
local function currentPlayerData()
    local cache = Bridge and Bridge.cache or pr_lib and pr_lib.cache
    if cache then
        local session = cache.GetResourceState('qbx_core', 'session')
        if session and session.authenticated == false then return {} end
        local data = cache.get('playerData')
        if type(data) == 'table' then return data end
    end
    return QBX.PlayerData or {}
end

-- Only consume data delivered by the producer; never pull a startup snapshot.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function(value)
    if type(value) == 'table' then setPlayerData(value.PlayerData or value) end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    setPlayerData({})
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', setPlayerData)

AddEventHandler('qbx_core:client:statusChanged', function(status)
    if type(status) ~= 'table' then return end
    QBX.PlayerData = QBX.PlayerData or {}
    QBX.PlayerData.metadata = QBX.PlayerData.metadata or {}
    for _, key in ipairs({ 'health', 'armor', 'hunger', 'thirst', 'stress', 'oxygen' }) do
        if status[key] ~= nil then QBX.PlayerData.metadata[key] = status[key] end
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    QBX.PlayerData = QBX.PlayerData or {}
    QBX.PlayerData.job = job
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    QBX.PlayerData = QBX.PlayerData or {}
    QBX.PlayerData.gang = gang
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
    QBX.PlayerData = QBX.PlayerData or {}
    QBX.PlayerData.job = QBX.PlayerData.job or {}
    QBX.PlayerData.job.onduty = onDuty == true
end)

RegisterNetEvent('qbx_core:client:setGroups', function(groups)
    QBX.PlayerData = QBX.PlayerData or {}
    QBX.PlayerData.groups = groups or {}
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
    if not QBX.PlayerData or not QBX.PlayerData.money then return end

    cashAmount = QBX.PlayerData.money.cash or 0
    bankAmount = QBX.PlayerData.money.bank or 0
end)

---Get Player data
---@return table
function framework.GetPlayer()
    local playerData = currentPlayerData()
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

function framework.GetPlayerData()
    return currentPlayerData()
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    local data = currentPlayerData()
    cashAmount = data.money and data.money.cash or 0
    bankAmount = data.money and data.money.bank or 0

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
    local player = currentPlayerData()
    if not player or not player.job then return {} end

    local job = player.job
    return {
        grade = job.grade.level,
        gradeName = job.grade.name,
        jobName = job.name,
        jobLabel = player.job.label
    }
end

function framework.GetPlayerJob()
    return currentPlayerData().job
end

function framework.PlayerHasJob(jobName, grade)
    local job = currentPlayerData().job
    if not job or job.name ~= tostring(jobName or ''):lower() then return false end

    if grade == nil then return true end

    local jobGrade = job.grade
    local level = type(jobGrade) == 'table' and (jobGrade.level or jobGrade.grade) or jobGrade
    return (tonumber(level) or 0) >= (tonumber(grade) or 0)
end

---@return boolean
function framework.IsPlayerLoaded()
    -- Preserve the existing authenticated-character contract: the spawn UI
    -- and appearance may run before the world-ready notification.
    local data = currentPlayerData()
    return type(data) == 'table' and (data.citizenid ~= nil or data.identifier ~= nil)
end

function framework.IsSessionReady()
    local ok, loaded = pcall(function() return qbx_core:IsPlayerLoaded() end)
    return ok and loaded == true
end

-- Documentation implementation


---@param meta string
---@return any
function framework.getPlayerMetadata(meta)
    local playerData = currentPlayerData()
    if not playerData or not playerData.metadata then return nil end

    local metadata = playerData.metadata[meta]
    return metadata
end

---@param wear boolean
---@param outfits table
function framework.toggleOutfit(wear, outfits)
    if wear then
        local playerData = currentPlayerData()
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
