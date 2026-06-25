local inventory = {}
if ActiveBridges["inventory"] ~= "qb" then return end

local qbInventory = exports['qb-inventory']
local QBCore = exports['qb-core']:GetCoreObject()

Debug('SUCCESS', Lang:t('Debug.InventoryDetected', { inventory = 'QB Inventory' }))

inventory.Version = nil
inventory.Stashes = {}
inventory.Old = {}
inventory.ShopData = {}

local function getInventoryNewVersion()
    if tonumber(string.sub(GetResourceMetadata("qb-inventory", "version", 0), 1, 1)) >= 2 then
        inventory.Version = true
        return
    end
    inventory.Version = false
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    getInventoryNewVersion()
end)

function inventory.setPlayerInventory(player, data)
end

function inventory.forceOpenInventory(playerId, invType, data)
    if invType == "stash" or invType == "trunk" or invType == "glovebox" then
        if not inventory.Version then return inventory.Old.OpenStash(playerId, invType, data) end
        return qbInventory:OpenInventory(playerId, data)
    elseif invType == "shop" then
        if not inventory.Version then return inventory.Old.OpenShop(playerId, data) end
        return qbInventory:OpenShop(playerId, data)
    else
        qbInventory:OpenInventory(playerId, data)
    end
end

function inventory.UpdateVehicle(oldPlate, newPlate)
    if not inventory.Version then return inventory.Old.UpdatePlate(oldPlate, newPlate) end
    local gloveboxInv = qbInventory:GetInventory('glovebox-'..oldPlate) or {slots = 5, maxweight = 10000, items = {}}
    local storedGloveBox = {}
    for k,v in pairs(gloveboxInv) do storedGloveBox[k] = v end
    local trunkInv = qbInventory:GetInventory('trunk-'..oldPlate) or {slots = 5, maxweight = 10000, items = {}}
    local storedTrunk = {}
    for k,v in pairs(trunkInv) do storedTrunk[k] = v end

    qbInventory:ClearStash('glovebox-'..oldPlate)
    qbInventory:ClearStash('trunk-'..oldPlate)
    qbInventory:CreateInventory('glovebox-'..newPlate, {label = 'glovebox-'..newPlate, slots = storedGloveBox.slots, maxweight = storedGloveBox.maxweight})
    qbInventory:SetInventory('glovebox-'..newPlate, storedGloveBox.items, "Bridge moving items")
    qbInventory:CreateInventory('trunk-'..newPlate, {label = 'trunk-'..newPlate, slots = storedTrunk.slots, maxweight = storedTrunk.maxweight})
    qbInventory:SetInventory('trunk-'..newPlate, storedTrunk.items, "Bridge moving items")

    if GetResourceState('jg-mechanic') ~= 'missing' then
        exports["jg-mechanic"]:vehiclePlateUpdated(oldPlate, newPlate)
    end
end

function inventory.Items(itemName)
    if not itemName then return QBCore.Shared.Items end
    return QBCore.Shared.Items[itemName]
end

function inventory.AddItem(inv, item, count, metadata, slot, cb)
    local success = false
    if type(inv) == "string" then
        -- Handle stashes or non-player invs
        success = qbInventory:AddItem(inv, item, count or 1, slot, metadata, 'pr_bridge')
        if cb then cb(success) end
        return success
    end

    if inventory.Version then 
        if not qbInventory:CanAddItem(inv, item, count) then 
            if cb then cb(false) end 
            return false 
        end 
    end
    success = qbInventory:AddItem(inv, item, count, slot, metadata, 'pr_bridge')
    
    if success and type(inv) == "number" then
        TriggerClientEvent('qb-inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'add', count)
    end
    if cb then cb(success) end
    return success
end

function inventory.RemoveItem(inv, item, count, metadata, slot)
    if type(inv) == "string" then return false end
    local success = qbInventory:RemoveItem(inv, item, count, slot, 'pr_bridge')
    if success and type(inv) == "number" then
        TriggerClientEvent('qb-inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'remove', count)
    end
    return success or false
end

function inventory.GetItem(inv, item, metadata, returnsCount)
    local pItem = qbInventory:GetItemByName(inv, item)
    if returnsCount then
        return pItem and pItem.amount or 0
    end
    return pItem
end

function inventory.CanCarryItem(inv, item, count, metadata)
    if type(inv) == "string" then return true end
    if not inventory.Version then return inventory.Old.CanCarryItem(inv, item, count) end
    return qbInventory:CanAddItem(inv, item, count)
end

function inventory.GetItemCount(inv, itemName, metadata, strict)
    local pItem = qbInventory:GetItemByName(inv, itemName)
    return pItem and pItem.amount or 0
end

function inventory.GetInventory(inv)
    return qbInventory:GetInventory(inv)
end

function inventory.ClearInventory(inv, keep)
    if inventory.Stashes[inv] then inventory.Stashes[inv] = nil end
    if not inventory.Version then return inventory.Old.ClearStash(inv, "stash") end
    local invData = qbInventory:GetInventory(inv)
    if not invData then return true end
    qbInventory:ClearStash(inv)
    return true
end

function inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
    inventory.Stashes[id] = { weight = maxWeight, slots = slots }
end

-- Backward compatibility methods from user convert.md:
inventory.Old.OpenStash = function(src, _type, id)
    local tbl = inventory.Stashes[id] or {weight=5000, slots=20}
    TriggerClientEvent('pr_bridge:client:qb-inventory:openStash', src, id, tbl)
end

inventory.Old.OpenShop = function(src, shopTitle)
    local shopData = inventory.ShopData[shopTitle]
    if not shopData then return false end
    TriggerClientEvent("inventory:client:OpenInventory", src, "shop", shopTitle, shopData)
end

inventory.Old.UpdatePlate = function(oldplate, newplate)
    local queries = {
        'UPDATE inventory_glovebox SET plate = @newplate WHERE plate = @oldplate',
        'UPDATE inventory_trunk SET plate = @newplate WHERE plate = @oldplate',
    }
    local values = { newplate = newplate, oldplate = oldplate }
    if Bridge.db and Bridge.db.transaction then
        Bridge.db.transaction(queries, values)
    end

    if GetResourceState('jg-mechanic') ~= 'missing' then 
        exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    end
    return true
end

inventory.Old.CanCarryItem = function(src, item, count)
    return true
end

inventory.Old.ClearStash = function(id, _type)
    return false
end

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
        image = inventory.GetImagePath and inventory.GetImagePath(itemData.image or itemData.name) or ""
    }
end

function inventory.GetItemBySlot(src, slot)
    local slotData = qbInventory:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = slotData.name,
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount,
        metadata = slotData.info,
        stack = slotData.unique,
        description = slotData.description
    }
end

function inventory.AddStashItems(id, items)
    if type(items) ~= "table" then return false end
    local success = false
    for _, item in pairs(items) do
        success = qbInventory:AddItem(id, item.item, item.count or item.amount, nil, item.metadata or item.info, "pr_bridge")
    end
    return success
end

function inventory.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then return false end
    local fullTrunkId = "trunk-"..identifier
    if not qbInventory:GetInventory(fullTrunkId) then
        qbInventory:CreateInventory(fullTrunkId, {label = fullTrunkId, slots = 15, maxweight = 10000})
    end
    Wait(1000)
    for i = 1, #items do
        qbInventory:AddItem(fullTrunkId, items[i].name, items[i].amount or items[i].count, items[i].slot or nil, items[i].info or items[i].metadata or {}, "pr_bridge")
    end
    return true
end

function inventory.HasItem(src, item, requiredCount)
    return qbInventory:HasItem(src, item, requiredCount or 1)
end

function inventory.OpenShop(src, shopTitle)
    if not inventory.Version then return inventory.Old.OpenShop(src, shopTitle) end
    return qbInventory:OpenShop(src, shopTitle)
end

function inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)
    if not shopTitle or not invData then return end
    if inventory.ShopData[shopTitle] then return true end
    local repackedShopItems = {}
    for _, v in pairs(invData) do
        table.insert(repackedShopItems, {name = v.name, price = v.price, amount = v.count or v.amount or 1000})
    end
    inventory.ShopData[shopTitle] = { inventory = repackedShopItems, coords = shopCoords, groups = shopGroups }
    qbInventory:CreateShop({ name = shopTitle, label = shopTitle, coords = shopCoords, items = repackedShopItems })
end

function inventory.OpenPlayerInventory(src, target)
    qbInventory:OpenInventory(src, target)
end

function inventory.getInventoryImg(image)
    local resource = GetResourceState("qbx_inventory"):find("start") and "qbx_inventory" or "qb-inventory"
    return ("nui://%s/html/images/%s"):format(resource, image)
end

return inventory
