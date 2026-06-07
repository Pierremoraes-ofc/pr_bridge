local inventory = {}
if ActiveBridges["inventory"] ~= "origen" then return end
local origen_inventory = exports.origen_inventory

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'Origen Inventory' }))

local function debugUsable(options, level, message)
    if options and options.debug then
        print(("[pr_bridge][inventory:origen][%s] %s"):format(level, message))
        return
    end

    if Debug then
        Debug(level, ("[inventory:origen] %s"):format(message))
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
        Debug("ERROR", ("origen_inventory usable item '%s' failed: %s"):format(tostring(item), tostring(result)))
    end

    return false
end

---@param player number
---@param data table
function inventory.setPlayerInventory(player, data)
    -- Origen handles this internally
end

---@param playerId number
---@param invType string
---@param data table
function inventory.forceOpenInventory(playerId, invType, data)
    if invType == "stash" then
        local stashId = type(data) == "table" and data.id or data
        return origen_inventory:OpenInventory(playerId, "stash", stashId)
    end

    return origen_inventory:OpenInventory(playerId, invType, data)
end

function inventory.UpdateVehicle(oldPlate, newPlate)
    -- No direct plate update export in provided docs
end

function inventory.Items(itemName)
    return origen_inventory:Items(itemName)
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    local success = origen_inventory:AddItem(inv, item, count or 1, metadata)
    if cb then cb(success) end
    return success
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    local success = origen_inventory:RemoveItem(inv, item, count or 1, metadata, slot)
    return success or false
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    if returnsCount then
        return origen_inventory:GetItemCount(inv, item) or 0
    end
    return origen_inventory:GetItem(inv, item, metadata)
end

function inventory.CanCarryItem(inv, item, count, metadata)
    local ok, result = pcall(function()
        return origen_inventory:CanCarryItem(inv, item, count, metadata)
    end)

    if ok then return result end

    ok, result = pcall(function()
        return origen_inventory:canCarryItem(inv, item, count, metadata)
    end)

    if ok then return result end
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    return origen_inventory:GetItemCount(inv, itemName) or 0
end

function inventory.GetInventory(inv)
    return origen_inventory:getInventory(inv)
end

function inventory.RegisterUsableItem(item, cb, options)
    if type(item) ~= "string" or item == "" or type(cb) ~= "function" then return false end
    options = options or {}

    debugUsable(options, "INFO", ("register item=%s hasCreateUseableItem=%s"):format(item, tostring(origen_inventory.CreateUseableItem ~= nil)))

    local ok = pcall(function()
        origen_inventory:CreateUseableItem(item, function(source, itemData)
            debugUsable(options, "INFO", ("callback item=%s source=%s slot=%s"):format(
                item,
                tostring(source),
                tostring(type(itemData) == "table" and itemData.slot or nil)
            ))
            return safeUseItemCallback(item, cb, source, itemData)
        end)
    end)

    debugUsable(options, ok and "SUCCESS" or "WARNING", ("register result item=%s ok=%s"):format(item, tostring(ok)))
    return ok
end

function inventory.CreateUsableItem(item, cb)
    return inventory.RegisterUsableItem(item, cb)
end

-- Origen Specific Server Exports
function inventory.setItemMetadata(src, slot, metadata)
    origen_inventory:setMetadata(src, slot, metadata)
end

function inventory.getItemInfo(item)
    return origen_inventory:Items(item)
end

return inventory
