local inventory = {}
if ActiveBridges["inventory"] ~= "ox" then return end
local ox_inventory = exports.ox_inventory

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'Ox Inventory' }))

local function debugUsable(options, level, message)
    if options and options.debug then
        print(("[pr_bridge][inventory:ox][%s] %s"):format(level, message))
        return
    end

    if Debug then
        Debug(level, ("[inventory:ox] %s"):format(message))
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
        Debug("ERROR", ("ox_inventory usable item '%s' failed: %s"):format(tostring(item), tostring(result)))
    end

    return false
end

function inventory.RegisterUsableItem(item, cb, options)
    if type(item) ~= "string" or item == "" or type(cb) ~= "function" then return false end

    options = options or {}
    local cancelUse = options.cancelUse
    if cancelUse == nil then cancelUse = true end
    local recentUse = {}

    local function dispatchUse(source, itemData)
        if type(itemData) ~= "table" then
            itemData = { name = item }
        elseif not itemData.name then
            itemData.name = item
        end

        local useKey = ("%s:%s:%s"):format(tostring(source), item, tostring(itemData.slot))

        if recentUse[useKey] then
            debugUsable(options, "WARNING", ("duplicate ignored item=%s source=%s slot=%s"):format(item, tostring(source), tostring(itemData.slot)))
            if cancelUse then return false end
            return
        end

        recentUse[useKey] = true
        SetTimeout(750, function()
            recentUse[useKey] = nil
        end)

        debugUsable(options, "INFO", ("dispatch item=%s source=%s slot=%s"):format(item, tostring(source), tostring(itemData.slot)))
        local result = safeUseItemCallback(item, cb, source, itemData)
        if result ~= nil then return result end
        if cancelUse then return false end
    end

    local function handleUse(payload)
        local usedItem = payload and payload.item
        local usedName = type(usedItem) == "table" and usedItem.name or usedItem

        debugUsable(options, "INFO", ("inventory hook payload item=%s source=%s slot=%s"):format(
            tostring(usedName),
            tostring(payload and payload.source),
            tostring(payload and payload.slot)
        ))

        if usedName ~= item then return end

        if type(usedItem) ~= "table" then
            usedItem = { name = item, slot = payload and payload.slot }
        elseif not usedItem.slot and payload and payload.slot then
            usedItem.slot = payload.slot
        end

        return dispatchUse(payload and payload.source, usedItem)
    end

    local hookOptions = {
        itemFilter = {
            [item] = true
        }
    }

    debugUsable(options, "INFO", ("register item=%s framework=%s inventoryHook=%s frameworkFallback=%s"):format(
        item,
        tostring(ActiveBridges and ActiveBridges["frameworks"]),
        tostring(not options.disableInventoryHook),
        "false"
    ))

    local registered = false

    if not options.disableInventoryHook then
        local ok = pcall(function()
            ox_inventory:registerHook("useItem", handleUse, hookOptions)
        end)
        registered = registered or ok
        debugUsable(options, ok and "SUCCESS" or "WARNING", ("hook useItem item=%s ok=%s"):format(item, tostring(ok)))

        ok = pcall(function()
            ox_inventory:registerHook("usingItem", handleUse, hookOptions)
        end)
        registered = registered or ok
        debugUsable(options, ok and "SUCCESS" or "WARNING", ("hook usingItem item=%s ok=%s"):format(item, tostring(ok)))
    end

    debugUsable(options, registered and "SUCCESS" or "ERROR", ("register result item=%s registered=%s"):format(item, tostring(registered)))
    return registered
end

function inventory.setPlayerInventory(player, data)
    ox_inventory:setPlayerInventory(player, data)
end

function inventory.forceOpenInventory(playerId, invType, data)
    ox_inventory:forceOpenInventory(playerId, invType, data)
end

function inventory.UpdateVehicle(oldPlate, newPlate)
    ox_inventory:UpdateVehicle(oldPlate, newPlate)
end

function inventory.Items(itemName)
    return ox_inventory:Items(itemName)
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    return ox_inventory:AddItem(inv, item, count, metadata, slot, cb)
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    return ox_inventory:RemoveItem(inv, item, count, metadata, slot) or false
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    return ox_inventory:GetItem(inv, item, metadata, returnsCount)
end

function inventory.CanCarryItem(inv, item, count, metadata)
    return ox_inventory:CanCarryItem(inv, item, count, metadata)
end

function inventory.CanCarryAmount(inv, item)
    return ox_inventory:CanCarryAmount(inv, item)
end

function inventory.CanCarryWeight(inv, weight)
    return ox_inventory:CanCarryWeight(inv, weight)
end

function inventory.SetMaxWeight(inv, maxWeight)
    ox_inventory:SetMaxWeight(inv, maxWeight)
end

function inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)
    return ox_inventory:CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    return ox_inventory:GetItemCount(inv, itemName, metadata, strict)
end

function inventory.GetItemSlots(inv, item, metadata)
    return ox_inventory:GetItemSlots(inv, item, metadata)
end

function inventory.GetSlot(inv, slot)
    return ox_inventory:GetSlot(inv, slot)
end

function inventory.GetSlotForItem(inv, itemName, metadata)
    return ox_inventory:GetSlotForItem(inv, itemName, metadata)
end

function inventory.GetSlotIdWithItem(inv, itemName, metadata, strict)
    return ox_inventory:GetSlotIdWithItem(inv, itemName, metadata, strict)
end

function inventory.GetSlotIdsWithItem(inv, itemName, metadata, strict)
    return ox_inventory:GetSlotIdsWithItem(inv, itemName, metadata, strict)
end

function inventory.GetSlotWithItem(inv, itemName, metadata, strict)
    return ox_inventory:GetSlotWithItem(inv, itemName, metadata, strict)
end

function inventory.GetSlotsWithItem(inv, itemName, metadata, strict)
    return ox_inventory:GetSlotsWithItem(inv, itemName, metadata, strict)
end

function inventory.GetEmptySlot(inv)
    return ox_inventory:GetEmptySlot(inv)
end

function inventory.GetContainerFromSlot(inv, slotId)
    return ox_inventory:GetContainerFromSlot(inv, slotId)
end

function inventory.SetSlotCount(inv, slots)
    ox_inventory:SetSlotCount(inv, slots)
end

function inventory.GetInventory(inv, owner)
    return ox_inventory:GetInventory(inv, owner)
end

function inventory.GetInventoryItems(inv, owner)
    return ox_inventory:GetInventoryItems(inv, owner)
end

function inventory.InspectInventory(target, source)
    ox_inventory:InspectInventory(target, source)
end

function inventory.ConfiscateInventory(source)
    ox_inventory:ConfiscateInventory(source)
end

function inventory.ReturnInventory(source)
    ox_inventory:ReturnInventory(source)
end

function inventory.ClearInventory(inv, keep)
    ox_inventory:ClearInventory(inv, keep)
end

function inventory.Search(inv, search, item, metadata)
    return ox_inventory:Search(inv, search, item, metadata)
end

function inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
    ox_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
end

function inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)
    invData = invData or {}
    local groups = shopGroups or invData.groups
    if type(groups) == "table" and not next(groups) then groups = nil end

    local shopData = {
        name = invData.name or shopTitle,
        inventory = invData.inventory or invData.items or {},
        slots = invData.slots,
    }

    if shopCoords then shopData.locations = shopCoords end
    if groups then shopData.groups = groups end

    ox_inventory:RegisterShop(shopTitle, shopData)

    return true
end

function inventory.RegisterHook(event, callback, options)
    if type(event) ~= "string" or type(callback) ~= "function" then return nil end
    return ox_inventory:registerHook(event, callback, options)
end

function inventory.CreateTemporaryStash(properties)
    return ox_inventory:CreateTemporaryStash(properties)
end

function inventory.CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)
    ox_inventory:CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)
end

function inventory.CreateDropFromPlayer(playerId)
    return ox_inventory:CreateDropFromPlayer(playerId)
end

function inventory.GetCurrentWeapon(inv)
    return ox_inventory:GetCurrentWeapon(inv)
end

function inventory.SetDurability(inv, slot, durability)
    ox_inventory:SetDurability(inv, slot, durability)
end

function inventory.SetMetadata(inv, slot, metadata)
    ox_inventory:SetMetadata(inv, slot, metadata)
end

function inventory.getInventoryImg(image)
    return ("nui://ox_inventory/web/images/%s"):format(image)
end

return inventory
