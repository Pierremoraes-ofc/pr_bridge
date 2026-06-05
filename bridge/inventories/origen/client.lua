local inventory = {}
if ActiveBridges["inventory"] ~= "origen" then return end
local origen_inventory = exports.origen_inventory

function inventory.openInventory(invType, data)
    -- Origen doesn't have a direct openInventory export in the provided docs
end

function inventory.openNearbyInventory()
    -- Origen doesn't have a direct openNearbyInventory export in the provided docs
end

function inventory.closeInventory()
    -- Origen doesn't have a direct closeInventory export in the provided docs
end

function inventory.Items(itemName)
    return origen_inventory:Items(itemName)
end

function inventory.useItem(data, cb)
    -- Origen handles this internally
end

function inventory.useSlot(slot)
    -- Origen handles this internally
end

function inventory.setStashTarget(id, owner)
    -- Not in provided docs
end

function inventory.getCurrentWeapon()
    -- Not in provided docs
    return nil
end

function inventory.displayMetadata(metadata, value)
    -- Not in provided docs
end

function inventory.giveItemToTarget(serverId, slotId, count)
    -- Handled by inventory UI
end

function inventory.weaponWheel(state)
    -- Not in provided docs
end

function inventory.Search(search, item, metadata)
    -- Standard implementation since no Search export was provided
    -- Usually involves getting player items and counting
    return 0
end

function inventory.GetItemCount(itemName, metadata, strict)
    return inventory.Search(nil, itemName)
end

function inventory.GetPlayerItems()
    -- Not in provided docs
    return {}
end

function inventory.GetPlayerWeight()
    return 0
end

function inventory.GetPlayerMaxWeight()
    return 0
end

-- Origen specific from documentation
function inventory.getItemInfo(item)
    return origen_inventory:Items(item)
end

return inventory
