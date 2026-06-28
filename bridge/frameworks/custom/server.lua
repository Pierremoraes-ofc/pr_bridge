local framework = {}
if ActiveBridges["frameworks"] ~= "custom" then return end

-- Custom framework contract.
-- Replace the safe defaults below with calls to your framework.

function framework.GetResourceName() return "custom" end

-- Player lookup. These functions must return your native player object or nil.
function framework.getPlayerFromId(source) return nil end
framework.GetPlayer = framework.getPlayerFromId
framework.GetPlayerFromId = framework.getPlayerFromId
function framework.GetPlayerFromIdentifier(identifier) return nil end
function framework.getPlayerSourceFromPlayer(player) return nil end

-- Player identity.
function framework.GetIdentifier(source) return nil end
framework.GetPlayerIdentifier = framework.GetIdentifier
function framework.getPlayerName(source) return "Unknown" end
function framework.GetPlayerName(source) return { fullName = "", firstName = "", lastName = "" } end
function framework.getPlayerDOB(source) return nil end
framework.GetPlayerDob = framework.getPlayerDOB
function framework.getPlayerSex(source) return nil end
framework.GetPlayerGender = framework.getPlayerSex
function framework.getPlayerHeight(source) return nil end
function framework.GetCoords(source, withHeading)
    local ped = GetPlayerPed(source)
    if ped == 0 then return nil end
    local coords = GetEntityCoords(ped)
    return withHeading and vector4(coords.x, coords.y, coords.z, GetEntityHeading(ped)) or coords
end

-- Player state and metadata.
function framework.GetPlayerData(source) return framework.getPlayerFromId(source) end
function framework.getPlayerMetadata(source, key) return nil end
framework.GetPlayerMetadata = framework.getPlayerMetadata
function framework.setPlayerMetadata(source, key, value) return false end
framework.SetPlayerMetadata = framework.setPlayerMetadata
function framework.getPlayerGroup(source) return "user" end
framework.GetPlayerGroup = framework.getPlayerGroup

-- Jobs.
function framework.GetPlayerJob(source)
    return { name = "", label = "", grade = 0, gradeLabel = "", onduty = false }
end
function framework.getPlayerJob(source, dataType)
    local job = framework.GetPlayerJob(source)
    return dataType and job[dataType] or job
end
function framework.SetPlayerJob(source, jobName, grade) return false end
function framework.PlayerHasJob(source, jobName, grade) return false end
function framework.GetJobCount(jobName) return 0 end
function framework.GetFrameworkJobs() return {} end
function framework.GetAllPlayers()
    local players = {}
    for _, source in ipairs(GetPlayers()) do players[#players + 1] = tonumber(source) end
    return players
end

-- Money. Supported account names should include: money/cash, bank and black_money.
function framework.getPlayerMoney(source, account) return 0 end
framework.GetAccountBalance = framework.getPlayerMoney
framework.GetPlayerAccountBalance = framework.getPlayerMoney
function framework.addPlayerMoney(source, account, amount, reason) return false end
framework.AddAccountBalance = framework.addPlayerMoney
framework.AddPlayerAccountBalance = framework.addPlayerMoney
function framework.removePlayerMoney(source, account, amount, reason) return false end
framework.RemoveAccountBalance = framework.removePlayerMoney
framework.RemovePlayerAccountBalance = framework.removePlayerMoney

-- Society/job banking. Implement here only when banking belongs to the framework.
function framework.GetJobAccountBalance(account) return 0 end
function framework.AddJobAccountBalance(account, amount, reason) return false end
function framework.RemoveJobAccountBalance(account, amount, reason) return false end
function framework.addSocietyBalance(account, amount, reason) return framework.AddJobAccountBalance(account, amount, reason) end
function framework.removeSocietyBalance(account, amount, reason) return framework.RemoveJobAccountBalance(account, amount, reason) end

-- Framework callbacks and usable items.
function framework.RegisterCallback(name, callback)
    if PRCore and PRCore.callback then PRCore.callback.register(name, callback); return true end
    return false
end
function framework.RegisterUsableItem(itemName, callback) return false end

-- Inventory fallbacks. Prefer implementing inventory adapters under bridge/inventories.
function framework.AddItem(source, itemName, count, metadata, slot) return false end
function framework.RemoveItem(source, itemName, count, metadata, slot) return false end
function framework.CanCarryItem(source, itemName, count, metadata) return false end
function framework.GetItemCount(source, itemName, metadata, strict) return 0 end
function framework.HasItem(source, itemName, count, metadata, strict) return false end
function framework.GetItemData(source, itemName, metadata, slot) return nil end
function framework.GetItemByName(source, itemName, metadata, slot) return nil end
function framework.GetItemBySlot(source, slot) return nil end
function framework.GetPlayerInventory(source) return {} end
function framework.ClearPlayerInventory(source) return false end
function framework.SetMetadata(source, slot, metadata) return false end
function framework.GetItemLabel(itemName) return itemName end
framework.GetItemlabel = framework.GetItemLabel
function framework.Items(itemName) return itemName and nil or {} end

-- Weapon compatibility.
function framework.GetWeapon(source, name) return 0 end
function framework.CreateWeaponData(source, data, weaponData) return data end
function framework.RemoveWeapon(source, data) return false end
function framework.AddWeapon(source, data) return false end

-- Owned vehicles. Return nil/false when unsupported.
function framework.GetOwnedVehicleOwner(plate) return nil end
function framework.GetOwnedVehicleData(plate) return nil end
function framework.DeleteOwnedVehicle(plate) return false end
function framework.InsertOwnedVehicle(plate, owner, vehicle) return false end
function framework.GetPlayerNameByIdentifier(identifier) return "Unknown" end

return framework