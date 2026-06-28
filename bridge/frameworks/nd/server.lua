local framework = {}
if ActiveBridges["frameworks"] ~= "nd" then return end

local NDCore = exports["ND_Core"]

Debug("SUCCESS", Lang:t("Debug.FrameworkDetected", { framework = "ND Core" }))

function framework.GetResourceName()
    return "ND_Core"
end

function framework.getPlayerFromId(source)
    return NDCore:getPlayer(tonumber(source))
end

framework.GetPlayer = framework.getPlayerFromId
framework.GetPlayerFromId = framework.getPlayerFromId

function framework.GetPlayerFromIdentifier(identifier)
    for _, player in pairs(NDCore:getPlayers() or {}) do
        if player and (player.identifier == identifier or player.id == identifier) then
            return player
        end
    end
end

function framework.GetIdentifier(source)
    local player = framework.getPlayerFromId(source)
    return player and player.identifier or nil
end

framework.GetPlayerIdentifier = framework.GetIdentifier

function framework.getPlayerSourceFromPlayer(player)
    return player and (player.source or player.id) or nil
end

function framework.getPlayerName(source)
    local player = framework.getPlayerFromId(source)
    return player and (player.fullname or ((player.firstname or "") .. " " .. (player.lastname or "")):match("^%s*(.-)%s*$")) or "Unknown"
end

function framework.GetPlayerName(source)
    local player = framework.getPlayerFromId(source)
    if not player then return { fullName = "", firstName = "", lastName = "" } end
    return {
        fullName = player.fullname or framework.getPlayerName(source),
        firstName = player.firstname or "",
        lastName = player.lastname or "",
    }
end

function framework.GetCoords(source, withHeading)
    local ped = GetPlayerPed(source)
    if ped == 0 then return nil end
    local coords = GetEntityCoords(ped)
    return withHeading and vector4(coords.x, coords.y, coords.z, GetEntityHeading(ped)) or coords
end

function framework.getPlayerDOB(source)
    local player = framework.getPlayerFromId(source)
    return player and (player.dob or player.birthdate) or nil
end
framework.GetPlayerDob = framework.getPlayerDOB

function framework.getPlayerSex(source)
    local player = framework.getPlayerFromId(source)
    return player and player.gender or nil
end
framework.GetPlayerGender = framework.getPlayerSex

function framework.GetPlayerJob(source)
    local player = framework.getPlayerFromId(source)
    local info = player and player.jobInfo or {}
    return {
        name = player and player.job or "",
        label = info.label or (player and player.job) or "",
        grade = info.rank or info.grade or 0,
        gradeLabel = info.rankName or info.gradeName or "",
        onduty = info.onduty,
    }
end

function framework.getPlayerJob(source, dataType)
    local job = framework.GetPlayerJob(source)
    return dataType and job[dataType] or job
end

function framework.SetPlayerJob(source, jobName, jobGrade)
    local player = framework.getPlayerFromId(source)
    return player and player.setJob and player.setJob(jobName, jobGrade or 0) ~= false or false
end

function framework.PlayerHasJob(source, jobName, jobGrade)
    local job = framework.GetPlayerJob(source)
    return job.name == jobName and (jobGrade == nil or tonumber(job.grade or 0) >= tonumber(jobGrade))
end

function framework.GetJobCount(jobName)
    local count = 0
    for _, player in pairs(NDCore:getPlayers("job", jobName, false) or {}) do
        if player and player.job == jobName then count = count + 1 end
    end
    return count
end

function framework.GetAllPlayers()
    return NDCore:getPlayers() or {}
end

function framework.getPlayerGroup()
    return "user"
end
framework.GetPlayerGroup = framework.getPlayerGroup

function framework.getPlayerMetadata(source, key)
    local player = framework.getPlayerFromId(source)
    return player and player.metadata and player.metadata[key] or nil
end
framework.GetPlayerMetadata = framework.getPlayerMetadata

function framework.setPlayerMetadata(source, key, value)
    local player = framework.getPlayerFromId(source)
    if not player then return false end
    if player.setMetadata then return player.setMetadata(key, value) ~= false end
    if player.setData then return player.setData(key, value) ~= false end
    return false
end
framework.SetPlayerMetadata = framework.setPlayerMetadata

function framework.getPlayerMoney(source, account)
    local player = framework.getPlayerFromId(source)
    if not player then return 0 end
    account = account == "money" and "cash" or account
    if player.PlayerData and player.PlayerData.money then return player.PlayerData.money[account] or 0 end
    return tonumber(player[account]) or 0
end

function framework.addPlayerMoney(source, account, amount, reason)
    local player = framework.getPlayerFromId(source)
    account = account == "money" and "cash" or account
    if player and player.addMoney then return player.addMoney(account, amount, reason or "pr_bridge") ~= false end
    if player and player.Functions and player.Functions.AddMoney then return player.Functions.AddMoney(account, amount, reason or "pr_bridge") ~= false end
    return false
end

function framework.removePlayerMoney(source, account, amount, reason)
    local player = framework.getPlayerFromId(source)
    account = account == "money" and "cash" or account
    if player and player.deductMoney then return player.deductMoney(account, amount, reason or "pr_bridge") ~= false end
    if player and player.removeMoney then return player.removeMoney(account, amount, reason or "pr_bridge") ~= false end
    if player and player.Functions and player.Functions.RemoveMoney then return player.Functions.RemoveMoney(account, amount, reason or "pr_bridge") ~= false end
    return false
end

framework.GetAccountBalance = framework.getPlayerMoney
framework.GetPlayerAccountBalance = framework.getPlayerMoney
framework.AddAccountBalance = framework.addPlayerMoney
framework.AddPlayerAccountBalance = framework.addPlayerMoney
framework.RemoveAccountBalance = framework.removePlayerMoney
framework.RemovePlayerAccountBalance = framework.removePlayerMoney

function framework.RegisterUsableItem()
    return false
end

AddEventHandler("ND:characterLoaded", function(character)
    TriggerEvent("pr_bridge:server:OnPlayerLoaded", character and character.source or source)
end)

AddEventHandler("ND:characterUnloaded", function(playerSource)
    TriggerEvent("pr_bridge:server:OnPlayerUnloaded", playerSource or source)
end)

return framework