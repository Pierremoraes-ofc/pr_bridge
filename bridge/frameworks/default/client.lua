local framework = {}
local loaded = false

AddEventHandler("playerSpawned", function()
    loaded = true
end)

---Get Player data
---@return table
function framework.GetPlayer()
    local name = GetPlayerName(cache.playerId)
    return {
        fullName = name,
        firstName = name,
        lastName = "",
        dob = "",
        gender = IsPedMale(cache.ped) and "Male" or "Female"
    }
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    return 0
end

---Get all job info for the player
---@return table
function framework.GetJobInfo()
    return {
        grade = 0,
        gradeName = "",
        jobName = "",
        jobLabel = ""
    }
end

function framework.GetPlayerData()
    return {}
end

function framework.GetPlayerJob()
    return { name = "", label = "", grade = 0, gradeLabel = "", onduty = false }
end

function framework.PlayerHasJob(jobName, grade)
    return false
end

---@return boolean
function framework.IsPlayerLoaded()
    return loaded
end

return framework
