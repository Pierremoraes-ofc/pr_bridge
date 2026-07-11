local framework = {}
if ActiveBridges["frameworks"] ~= "qb" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

---Get Player data
---@return table
function framework.GetPlayer()
    local player = QBCore.Functions.GetPlayerData()
    local info = player.charinfo
    local lastName = info.lastname
    local firstName = info.firstname
    return {
        fullName = ("%s %s"):format(firstName, lastName),
        firstName = firstName,
        lastName = lastName,
        dob = info.birthdate,
        gender = info.gender
    }
end

function framework.GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    local player = QBCore.Functions.GetPlayerData()
    if type == "cash" then
        return player.money["cash"]
    elseif type == "bank" then
        return player.money["bank"]
    elseif type == "black" then
        return player.money["cash"] -- note: need to figure this out.
    end
end

---Get all job info for the player
---@return table
function framework.GetJobInfo()
    local player = QBCore.Functions.GetPlayerData()
    local job = player.job
    return {
        grade = job.grade.level,
        gradeName = job.grade.name,
        jobName = job.name,
        jobLabel = job.label
    }
end

function framework.GetPlayerJob()
    local player = QBCore.Functions.GetPlayerData()
    return player and player.job or nil
end

function framework.PlayerHasJob(jobName, grade)
    local job = framework.GetPlayerJob()
    if not job or tostring(job.name or ''):lower() ~= tostring(jobName or ''):lower() then return false end
    if grade == nil then return true end

    local jobGrade = job.grade
    local level = type(jobGrade) == 'table' and (jobGrade.level or jobGrade.grade or jobGrade.value) or jobGrade
    return (tonumber(level) or 0) >= (tonumber(grade) or 0)
end

---@return boolean
function framework.IsPlayerLoaded()
    return QBCore.Functions.GetPlayerData() ~= nil
end

-- Documentation implementation

---@return table
function framework.getCharacterName()
    local playerData = QBCore.Functions.GetPlayerData()
    local firstName = playerData.charinfo.firstname or ''
    local lastName = playerData.charinfo.lastname or ''
    return { first = firstName, last = lastName }
end

---@param meta string
---@return any
function framework.getPlayerMetadata(meta)
    local playerData = QBCore.Functions.GetPlayerData()
    local metadata = playerData.metadata[meta]
    return metadata
end

---@param wear boolean
---@param outfits table
function framework.toggleOutfit(wear, outfits)
    if wear then
        local playerData = QBCore.Functions.GetPlayerData()
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
