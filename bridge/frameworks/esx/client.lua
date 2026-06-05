local framework = {}
if ActiveBridges["frameworks"] ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

---Get Player data
---@return table
function framework.GetPlayer()
    local player = ESX.PlayerData
    return {
        fullName = ("%s %s"):format(player.firstName, player.lastName),
        firstName = player.firstName,
        lastName = player.lastName,
        dob = player.dateofbirth,
        gender = player.sex
    }
end

---Get any money/accounts
---@param type string
---@return number
function framework.GetMoney(type)
    local player = ESX.PlayerData
    if type == "cash" then
        return player.accounts.Money
    elseif type == "bank" then
        return player.accounts.Bank
    elseif type == "black" then
        return player.accounts.Black
    end
end

---Get all job info for the player
---@return table
function framework.GetJobInfo()
    local player = ESX.PlayerData
    return {
        grade = player.job.grade,
        gradeName = player.job.grade_name,
        jobName = player.job.name,
        jobLabel = player.job.label
    }
end

---@return boolean
function framework.IsPlayerLoaded()
    return ESX.IsPlayerLoaded()
end

-- Documentation implementation

---@param meta string
---@return any
function framework.getPlayerMetadata(meta)
    local playerData = ESX.PlayerData
    if not playerData.metadata then return nil end
    return playerData.metadata[meta]
end

---@param wear boolean
---@param outfits table
function framework.toggleOutfit(wear, outfits)
    if wear then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            local gender = skin.sex
            local outfit = gender == 1 and outfits.Female or outfits.Male
            if not outfit then return end
            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        end)
    else
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end

return framework