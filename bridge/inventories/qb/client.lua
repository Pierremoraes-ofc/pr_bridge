local inventory = {}
if ActiveBridges["inventory"] ~= "qb" then return end

local qb = exports['qb-inventory']
local QBCore = exports['qb-core']:GetCoreObject()

function inventory.openInventory(invType, data)
    if invType == "stash" then
        TriggerEvent("inventory:client:SetCurrentStash", data.id or data)
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.id or data, { maxweight = data.weight, slots = data.slots })
    else
        TriggerServerEvent('inventory:server:OpenInventory', invType, data)
    end
end

function inventory.openNearbyInventory()
    TriggerEvent("inventory:client:OpenInventory")
end

function inventory.closeInventory()
    TriggerEvent("inventory:client:closeInventory")
end

function inventory.Items(itemName)
    return itemName and QBCore.Shared.Items[itemName] or QBCore.Shared.Items
end

function inventory.useItem(data, cb)
end

function inventory.useSlot(slot)
end

function inventory.setStashTarget(id, owner)
end

function inventory.getCurrentWeapon()
    return nil
end

function inventory.displayMetadata(metadata, value)
end

function inventory.giveItemToTarget(serverId, slotId, count)
end

function inventory.weaponWheel(state)
end

function inventory.Search(search, item, metadata)
    if search == "count" then
        return inventory.GetItemCount(item, metadata)
    end
    return qb:HasItem(item)
end

function inventory.GetItemCount(itemName, metadata, strict)
    if qb:HasItem(itemName) then
        return 1
    end
    return 0
end

function inventory.GetPlayerItems()
    local p = QBCore.Functions.GetPlayerData()
    return p and p.items or {}
end

function inventory.GetPlayerWeight()
    return 0
end

function inventory.GetPlayerMaxWeight()
    return 120000
end

function inventory.GetSlotIdWithItem(itemName, metadata, strict)
    return nil
end

function inventory.GetSlotIdsWithItem(itemName, metadata, strict)
    return {}
end

function inventory.GetSlotWithItem(itemName, metadata, strict)
    return nil
end

function inventory.GetSlotsWithItem(itemName, metadata, strict)
    return {}
end

-- Helpers mantidos do convert.md original para garantir retrocompatibilidade:
function inventory.GetResourceName()
    return "qb-inventory"
end

function inventory.GetItemInfo(item)
    local itemData = QBCore.Shared.Items[item]
    if not itemData then return {} end
    return {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = inventory.GetImagePath(itemData.image or itemData.name)
    }
end

function inventory.HasItem(item, requiredCount)
    return qb:HasItem(item, requiredCount or 1)
end

function inventory.GetImagePath(item)
    if inventory.StripPNG then item = inventory.StripPNG(item) end
    local file = LoadResourceFile("qb-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qb-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

RegisterNetEvent('pr_bridge:client:qb-inventory:openStash', function(id, data)
    if source ~= 65535 then return end
    inventory.openInventory("stash", {id = id, weight = data.weight, slots = data.slots})
end)

function inventory.getInventoryImg(image)
    return ("nui://qb-inventory/html/images/%s"):format(image)
end

return inventory