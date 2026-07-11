local framework = {}
if ActiveBridges["frameworks"] ~= "nd" then return end

local NDCore = exports["ND_Core"]

---Get Player data
---@return table
function framework.GetPlayer()
    local player = NDCore:getPlayer()
    return {
        fullName = player.fullname,
        firstName = player.firstname,
        lastName = player.lastname,
        dob = player.dob,
        gender = player.gender
    }
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    local player = NDCore:getPlayer()
    if type == "cash" then
        return player.cash
    elseif type == "bank" then
        return player.bank
    elseif type == "black" then
        if Bridge.inventory and Bridge.inventory.GetItemCount then
            local dirtyMoney = Bridge.inventory.GetItemCount("black_money")
            return dirtyMoney > 0 and dirtyMoney or player.cash
        end
        
        -- ND doesn't have "dirty" or "black" by default, for realism normal cash is used.
        return player.cash
    end
end

---Get all job info for the player
---@return table
function framework.GetJobInfo()
    local player = NDCore:getPlayer()
    local jobInfo = player and player.jobInfo or {}

    return {
        grade = jobInfo.rank or 0,
        gradeName = jobInfo.rankName or "",
        jobName = player and player.job or "",
        jobLabel = jobInfo.label or (player and player.job) or ""
    }
end

function framework.GetPlayerData()
    return NDCore:getPlayer()
end

function framework.GetPlayerJob()
    local player = NDCore:getPlayer()
    local jobInfo = player and player.jobInfo or {}

    return {
        name = player and player.job or "",
        label = jobInfo.label or (player and player.job) or "",
        grade = jobInfo.rank or jobInfo.grade or 0,
        gradeLabel = jobInfo.rankName or jobInfo.gradeName or "",
        onduty = jobInfo.onduty,
    }
end

function framework.PlayerHasJob(jobName, grade)
    local job = framework.GetPlayerJob()
    if not job or tostring(job.name or ''):lower() ~= tostring(jobName or ''):lower() then return false end
    if grade == nil then return true end

    return (tonumber(job.grade) or 0) >= (tonumber(grade) or 0)
end

---@return boolean
function framework.IsPlayerLoaded()
    return NDCore:getPlayer() ~= nil
end

return framework
