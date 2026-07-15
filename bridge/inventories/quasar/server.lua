local inventory = {}

if ActiveBridges["inventory"] ~= "quasar" then return end

local qs_inventory = exports['qs-inventory']

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'Quasar Inventory' }))

local function debugUsable(options, level, message)
    if options and options.debug then
        print(("[pr_bridge][inventory:quasar][%s] %s"):format(level, message))
        return
    end

    if Debug then
        Debug(level, ("[inventory:quasar] %s"):format(message))
    end
end

local function safeUseItemCallback(item, cb, source, itemData)
    if type(itemData) ~= "table" then
        itemData = { name = item }
    elseif not itemData.name then
        itemData.name = item
    end

    local ok, result = pcall(cb, source, itemData)
    if ok then return result end

    if Debug then
        Debug("ERROR", ("qs-inventory usable item '%s' failed: %s"):format(tostring(item), tostring(result)))
    end

    return false
end

---@param player number
---@param data table
function inventory.setPlayerInventory(player, data)
    -- Quasar uses automatic inventory loading based on framework
end

---@param playerId number
---@param invType string
---@param data table
function inventory.forceOpenInventory(playerId, invType, data)
    local stashId = type(data) == 'table' and data.id or data
    TriggerClientEvent('inventory:client:SetCurrentStash', playerId, stashId)
    TriggerClientEvent('inventory:server:OpenInventory', playerId, invType, stashId)
end

function inventory.UpdateVehicle(oldPlate, newPlate)
    qs_inventory:UpdateVehiclePlate(oldPlate, newPlate)
end

function inventory.Items(itemName)
    local items = qs_inventory:GetItemList()
    if itemName then
        return items[itemName]
    end
    return items
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    local success = qs_inventory:AddItem(inv, item, count, slot, metadata)
    if cb then cb(success) end
    return success
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    return qs_inventory:RemoveItem(inv, item, count, slot, metadata)
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    local playerInv = qs_inventory:GetInventory(inv)
    if not playerInv then return returnsCount and 0 or nil end

    local totalAmount = 0
    local firstMatch = nil

    for _, itemData in pairs(playerInv) do
        if itemData.name == item then
            totalAmount = totalAmount + itemData.amount
            if not firstMatch then firstMatch = itemData end
        end
    end

    if returnsCount then
        return totalAmount
    end
    return firstMatch
end

function inventory.CanCarryItem(inv, item, count, metadata)
    return qs_inventory:CanCarryItem(inv, item, count)
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    return qs_inventory:GetItemTotalAmount(inv, itemName) or 0
end

function inventory.GetInventory(inv)
    return qs_inventory:GetInventory(inv)
end

-- Quasar Specific Server Exports
function inventory.GetWeaponAttachmentItems()
    return qs_inventory:GetWeaponAttachmentItems()
end

function inventory.GetItemLabel(item)
    return qs_inventory:GetItemLabel(item)
end

function inventory.RegisterUsableItem(item, cb, options)
    if type(item) ~= "string" or item == "" or type(cb) ~= "function" then return false end
    options = options or {}

    debugUsable(options, "INFO", ("register item=%s hasCreateUsableItem=%s"):format(item, tostring(qs_inventory.CreateUsableItem ~= nil)))

    if not qs_inventory.CreateUsableItem then return false end

    local ok = pcall(function()
        qs_inventory:CreateUsableItem(item, function(source, itemData)
            debugUsable(options, "INFO", ("callback item=%s source=%s slot=%s"):format(
                item,
                tostring(source),
                tostring(type(itemData) == "table" and itemData.slot or nil)
            ))
            safeUseItemCallback(item, cb, source, itemData)
        end)
    end)

    debugUsable(options, ok and "SUCCESS" or "WARNING", ("register result item=%s ok=%s"):format(item, tostring(ok)))
    return ok
end

function inventory.CreateUsableItem(item, cb)
    return inventory.RegisterUsableItem(item, cb)
end

function inventory.SetItemMetadata(source, slot, metadata)
    qs_inventory:SetItemMetadata(source, slot, metadata)
end

function inventory.GetTotalUsedSlots(source)
    return qs_inventory:GetTotalUsedSlots(source)
end

-- Stash Management
function inventory.RegisterStash(source, id, slots, weight)
    qs_inventory:RegisterStash(source, id, slots, weight)
end

function inventory.AddItemIntoStash(id, item, amount, slot, metadata, slots, maxWeight)
    return qs_inventory:AddItemIntoStash(id, item, amount, slot, metadata, slots, maxWeight)
end

function inventory.RemoveItemIntoStash(id, item, amount, slot, slots, maxWeight)
    return qs_inventory:RemoveItemIntoStash(id, item, amount, slot, slots, maxWeight)
end

function inventory.GetStashItems(id)
    return qs_inventory:GetStashItems(id)
end

function inventory.ClearOtherInventory(type, id)
    qs_inventory:ClearOtherInventory(type, id)
end

function inventory.getInventoryImg(image)
    return ("nui://qs-inventory/html/images/%s"):format(image)
end

return inventory
