local inventory = {}
if ActiveBridges["inventory"] ~= "codem" then return end
local codem_inventory = exports['codem-inventory']

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'Codem Inventory' }))

---@param player number
---@param data table
function inventory.setPlayerInventory(player, data)
    -- Codem handles this internally or via LoadInventory
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
    local items = codem_inventory:GetItemList()
    if itemName then
        return items[itemName]
    end
    return items
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    local success = codem_inventory:AddItem(inv, item, count, slot, metadata)
    if cb then cb(success) end
    return success
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    return codem_inventory:RemoveItem(inv, item, count, slot)
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    if returnsCount then
        return codem_inventory:GetItemsTotalAmount(inv, item) or 0
    end
    return codem_inventory:GetItemByName(inv, item)
end

function inventory.CanCarryItem(inv, item, count, metadata)
    -- Documentation doesn't show a direct CanCarry check, 
    -- but we can infer based on weight if needed. 
    -- For now, returning true as per standard fallback.
    return true
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    return codem_inventory:GetItemsTotalAmount(inv, itemName) or 0
end

function inventory.GetInventory(inv, source)
    -- identifier is inv, source is source
    return codem_inventory:GetInventory(inv, source)
end

-- Codem Specific Server Exports
function inventory.HasItem(source, items, amount)
    return codem_inventory:HasItem(source, items, amount)
end

function inventory.GetTotalWeight(items)
    return codem_inventory:GetTotalWeight(items)
end

function inventory.SetItemBySlot(source, slot, itemdata)
    codem_inventory:SetItemBySlot(source, slot, itemdata)
end

function inventory.GetItemBySlot(source, slot)
    return codem_inventory:GetItemBySlot(source, slot)
end

function inventory.SaveInventory(source, offline)
    codem_inventory:SaveInventory(source, offline)
end

function inventory.LoadInventory(source, identifier)
    codem_inventory:LoadInventory(source, identifier)
end

function inventory.ClearInventory(source)
    codem_inventory:ClearInventory(source)
end

function inventory.CheckItemValid(source, name, count)
    return codem_inventory:CheckItemValid(source, name, count)
end

function inventory.GetItemLabel(itemname)
    return codem_inventory:GetItemLabel(itemname)
end

function inventory.GetStashItems(stashid)
    return codem_inventory:GetStashItems(stashid)
end

function inventory.UpdateStash(stashid, items)
    codem_inventory:UpdateStash(stashid, items)
end

function inventory.SetInventoryItems(source, item, amount)
    codem_inventory:SetInventoryItems(source, item, amount)
end

function inventory.SetItemMetadata(source, slot, metadata)
    codem_inventory:SetItemMetadata(source, slot, metadata)
end

return inventory
