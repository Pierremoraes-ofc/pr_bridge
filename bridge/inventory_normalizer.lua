local function copyItem(item, fallbackSlot)
    if type(item) ~= "table" then return nil end

    local out = {}
    for key, value in pairs(item) do
        out[key] = value
    end

    out.name = out.name or out.item
    out.slot = out.slot or fallbackSlot
    out.count = out.count or out.amount or out.quantity
    out.amount = out.amount or out.count
    out.metadata = out.metadata or out.info
    out.info = out.info or out.metadata

    return out
end

local function metadataMatches(item, metadata, strict)
    if metadata == nil then return true end

    local itemMetadata = item and (item.metadata or item.info)
    if metadata == false then return true end

    if type(metadata) ~= "table" then
        if itemMetadata == metadata then return true end
        return type(itemMetadata) == "table" and (itemMetadata.type == metadata or itemMetadata[metadata] ~= nil)
    end

    if type(itemMetadata) ~= "table" then return false end

    for key, value in pairs(metadata) do
        if itemMetadata[key] ~= value then return false end
    end

    if strict then
        for key in pairs(itemMetadata) do
            if metadata[key] == nil then return false end
        end
    end

    return true
end

local function itemMatches(item, itemName, metadata, strict)
    if type(item) ~= "table" then return false end
    local name = item.name or item.item
    if itemName and name ~= itemName then return false end
    return metadataMatches(item, metadata, strict)
end

local function slotMatches(left, right)
    if left == right then return true end
    local leftNumber = tonumber(left)
    local rightNumber = tonumber(right)
    return leftNumber ~= nil and rightNumber ~= nil and leftNumber == rightNumber
end

local function extractItems(data)
    if type(data) ~= "table" then return {} end

    local rawItems = data.items
    if type(rawItems) ~= "table" then rawItems = data.inventory end
    if type(rawItems) ~= "table" then rawItems = data.slots end
    if type(rawItems) ~= "table" then rawItems = data end

    local items = {}
    for key, value in pairs(rawItems) do
        if type(value) == "table" and (value.name or value.item) then
            items[#items + 1] = copyItem(value, value.slot or tonumber(key) or key)
        end
    end

    return items
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

local function getLabelFromItems(inventory, item)
    local itemData = safeCall(inventory.Items, item)
    if type(itemData) == "table" then
        return itemData.label or itemData.name or item
    end

    return itemData or item
end

local function getInfoFromItems(inventory, item)
    local itemData = safeCall(inventory.Items, item)
    if type(itemData) ~= "table" then return itemData end

    local out = copyItem(itemData)
    out.name = out.name or item
    out.label = out.label or out.name
    out.description = out.description
    out.weight = out.weight
    out.stack = out.stack

    return out
end

local function addServerHelpers(inventory)
    if not inventory.HasItem and inventory.GetItemCount then
        function inventory.HasItem(inv, item, amount, metadata, strict)
            return (tonumber(inventory.GetItemCount(inv, item, metadata, strict)) or 0) >= (amount or 1)
        end
    end

    if not inventory.GetInventoryItems and inventory.GetInventory then
        function inventory.GetInventoryItems(inv, owner)
            return extractItems(safeCall(inventory.GetInventory, inv, owner))
        end
    end

    if not inventory.GetSlot and inventory.GetInventoryItems then
        function inventory.GetSlot(inv, slot)
            local slotId = tonumber(slot) or slot
            local items = inventory.GetInventoryItems(inv)
            for i = 1, #items do
                if slotMatches(items[i].slot, slotId) then return items[i] end
            end
        end
    end

    if not inventory.GetItemBySlot and inventory.GetSlot then
        inventory.GetItemBySlot = inventory.GetSlot
    end

    if not inventory.GetItemSlots and inventory.GetInventoryItems then
        function inventory.GetItemSlots(inv, item, metadata, strict)
            local slots = {}
            local items = inventory.GetInventoryItems(inv)
            for i = 1, #items do
                local itemData = items[i]
                if itemMatches(itemData, item, metadata, strict) and itemData.slot then
                    slots[itemData.slot] = itemData.count or itemData.amount or 1
                end
            end
            return slots
        end
    end

    if not inventory.GetSlotWithItem and inventory.GetInventoryItems then
        function inventory.GetSlotWithItem(inv, item, metadata, strict)
            local items = inventory.GetInventoryItems(inv)
            for i = 1, #items do
                if itemMatches(items[i], item, metadata, strict) then return items[i] end
            end
        end
    end

    if not inventory.GetSlotsWithItem and inventory.GetInventoryItems then
        function inventory.GetSlotsWithItem(inv, item, metadata, strict)
            local slots = {}
            local items = inventory.GetInventoryItems(inv)
            for i = 1, #items do
                if itemMatches(items[i], item, metadata, strict) then
                    slots[#slots + 1] = items[i]
                end
            end
            return slots
        end
    end

    if not inventory.GetSlotIdWithItem and inventory.GetSlotWithItem then
        function inventory.GetSlotIdWithItem(inv, item, metadata, strict)
            local slot = inventory.GetSlotWithItem(inv, item, metadata, strict)
            return slot and slot.slot
        end
    end

    if not inventory.GetSlotForItem and inventory.GetSlotIdWithItem then
        inventory.GetSlotForItem = inventory.GetSlotIdWithItem
    end

    if not inventory.GetSlotIdsWithItem and inventory.GetSlotsWithItem then
        function inventory.GetSlotIdsWithItem(inv, item, metadata, strict)
            local ids = {}
            local slots = inventory.GetSlotsWithItem(inv, item, metadata, strict)
            for i = 1, #slots do
                if slots[i].slot then ids[#ids + 1] = slots[i].slot end
            end
            return ids
        end
    end

    if not inventory.Search and inventory.GetItemCount then
        function inventory.Search(inv, search, item, metadata)
            if search == "slots" and inventory.GetSlotsWithItem then
                return inventory.GetSlotsWithItem(inv, item, metadata)
            end

            if search == "slot" and inventory.GetSlotWithItem then
                return inventory.GetSlotWithItem(inv, item, metadata)
            end

            if search == "count" then
                return inventory.GetItemCount(inv, item, metadata)
            end

            return inventory.HasItem and inventory.HasItem(inv, item or search, 1, metadata) or false
        end
    end
end

local function addClientHelpers(inventory)
    if not inventory.GetInventoryItems and inventory.GetPlayerItems then
        function inventory.GetInventoryItems()
            return extractItems(safeCall(inventory.GetPlayerItems))
        end
    end

    if not inventory.HasItem and inventory.GetItemCount then
        function inventory.HasItem(item, amount, metadata, strict)
            return (tonumber(inventory.GetItemCount(item, metadata, strict)) or 0) >= (amount or 1)
        end
    end

    if not inventory.GetSlotWithItem and inventory.GetInventoryItems then
        function inventory.GetSlotWithItem(item, metadata, strict)
            local items = inventory.GetInventoryItems()
            for i = 1, #items do
                if itemMatches(items[i], item, metadata, strict) then return items[i] end
            end
        end
    end

    if not inventory.GetSlotsWithItem and inventory.GetInventoryItems then
        function inventory.GetSlotsWithItem(item, metadata, strict)
            local slots = {}
            local items = inventory.GetInventoryItems()
            for i = 1, #items do
                if itemMatches(items[i], item, metadata, strict) then
                    slots[#slots + 1] = items[i]
                end
            end
            return slots
        end
    end

    if not inventory.GetSlotIdWithItem and inventory.GetSlotWithItem then
        function inventory.GetSlotIdWithItem(item, metadata, strict)
            local slot = inventory.GetSlotWithItem(item, metadata, strict)
            return slot and slot.slot
        end
    end

    if not inventory.GetSlotIdsWithItem and inventory.GetSlotsWithItem then
        function inventory.GetSlotIdsWithItem(item, metadata, strict)
            local ids = {}
            local slots = inventory.GetSlotsWithItem(item, metadata, strict)
            for i = 1, #slots do
                if slots[i].slot then ids[#ids + 1] = slots[i].slot end
            end
            return ids
        end
    end

    if not inventory.Search and inventory.GetItemCount then
        function inventory.Search(search, item, metadata)
            if search == "slots" and inventory.GetSlotsWithItem then
                return inventory.GetSlotsWithItem(item, metadata)
            end

            if search == "slot" and inventory.GetSlotWithItem then
                return inventory.GetSlotWithItem(item, metadata)
            end

            if search == "count" then
                return inventory.GetItemCount(item, metadata)
            end

            return inventory.HasItem and inventory.HasItem(item or search, 1, metadata) or false
        end
    end
end

return function(inventory, context)
    if type(inventory) ~= "table" then return inventory end

    if not inventory.GetItemBySlot and inventory.GetSlot then inventory.GetItemBySlot = inventory.GetSlot end
    if not inventory.GetSlot and inventory.GetItemBySlot then inventory.GetSlot = inventory.GetItemBySlot end

    if not inventory.SetItemMetadata and inventory.setItemMetadata then inventory.SetItemMetadata = inventory.setItemMetadata end
    if not inventory.setItemMetadata and inventory.SetItemMetadata then inventory.setItemMetadata = inventory.SetItemMetadata end
    if not inventory.SetMetadata and inventory.SetItemMetadata then inventory.SetMetadata = inventory.SetItemMetadata end
    if not inventory.SetItemMetadata and inventory.SetMetadata then inventory.SetItemMetadata = inventory.SetMetadata end

    if not inventory.GetItemInfo and inventory.getItemInfo then inventory.GetItemInfo = inventory.getItemInfo end
    if not inventory.getItemInfo and inventory.GetItemInfo then inventory.getItemInfo = inventory.GetItemInfo end

    if not inventory.GetItemLabel and inventory.Items then
        function inventory.GetItemLabel(item)
            return getLabelFromItems(inventory, item)
        end
    end

    if not inventory.GetItemInfo and inventory.Items then
        function inventory.GetItemInfo(item)
            return getInfoFromItems(inventory, item)
        end
        inventory.getItemInfo = inventory.GetItemInfo
    end

    if context == "server" then
        addServerHelpers(inventory)
    else
        addClientHelpers(inventory)
    end

    return inventory
end
