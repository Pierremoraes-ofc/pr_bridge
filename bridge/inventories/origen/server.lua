local inventory = {}
if ActiveBridges["inventory"] ~= "origen" then return end
local origen_inventory = exports.origen_inventory

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'Origen Inventory' }))

---@param player number
---@param data table
function inventory.setPlayerInventory(player, data)
    -- Origen handles this internally
end

---@param playerId number
---@param invType string
---@param data table
function inventory.forceOpenInventory(playerId, invType, data)
    -- No direct server-side force open export in provided docs
end

function inventory.UpdateVehicle(oldPlate, newPlate)
    -- No direct plate update export in provided docs
end

function inventory.Items(itemName)
    return origen_inventory:Items(itemName)
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    local success = origen_inventory:addItem(inv, item, count, metadata)
    if cb then cb(success) end
    return success
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    return origen_inventory:removeItem(inv, item, count, metadata, slot)
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    if returnsCount then
        return origen_inventory:getItemCount(inv, item) or 0
    end
    return origen_inventory:getItem(inv, item, metadata)
end

function inventory.CanCarryItem(inv, item, count, metadata)
    return origen_inventory:canCarryItem(inv, item, count)
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    return origen_inventory:getItemCount(inv, itemName) or 0
end

function inventory.GetInventory(inv)
    return origen_inventory:getInventory(inv)
end

-- Origen Specific Server Exports
function inventory.setItemMetadata(src, slot, metadata)
    origen_inventory:setMetadata(src, slot, metadata)
end

function inventory.getItemInfo(item)
    return origen_inventory:Items(item)
end

return inventory
