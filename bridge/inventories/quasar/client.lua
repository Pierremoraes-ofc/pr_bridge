local inventory = {}

if ActiveBridges["inventory"] ~= "quasar" then return end

local qs_inventory = exports['qs-inventory']

---@param invType string
---@param data table
function inventory.openInventory(invType, data)
    if invType == 'stash' then
        local stashId = type(data) == 'table' and data.id or data
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId)
        TriggerEvent('inventory:client:SetCurrentStash', stashId)
    else
        -- Default inventory open
        TriggerServerEvent('inventory:server:OpenInventory')
    end
end

function inventory.openNearbyInventory()
    -- Quasar doesn't have a direct "open nearby" export commonly used, usually integrated in main inventory
    TriggerServerEvent('inventory:server:OpenInventory')
end

function inventory.closeInventory()
    -- Quasar doesn't have a direct closeInventory export in the docs, but sometimes it's needed
    -- We can use setInventoryDisabled(true) then (false) as a hack or just leave it if not available
end

---@param itemName string
function inventory.Items(itemName)
    local items = qs_inventory:GetItemList()
    if itemName then
        return items[itemName]
    end
    return items
end

function inventory.useItem(data, cb)
    -- Quasar uses internal item usage
end

function inventory.useSlot(slot)
    -- Quasar uses internal slot usage
end

function inventory.setStashTarget(id, owner)
    -- Quasar uses RegisterStash
end

function inventory.getCurrentWeapon()
    return qs_inventory:GetCurrentWeapon()
end

function inventory.displayMetadata(metadata, value)
    -- Quasar might not have direct metadata display export
end

function inventory.giveItemToTarget(serverId, slotId, count)
    -- Usually handled by inventory UI
end

function inventory.weaponWheel(state)
    qs_inventory:WeaponWheel(state)
end

function inventory.Search(search, item, metadata)
    -- documentation says Search returns quantity
    return qs_inventory:Search(item or search)
end

function inventory.GetItemCount(itemName, metadata, strict)
    return qs_inventory:Search(itemName) or 0
end

function inventory.GetPlayerItems()
    return qs_inventory:getUserInventory()
end

function inventory.GetPlayerWeight()
    -- Not directly in documentation
    return 0
end

function inventory.GetPlayerMaxWeight()
    -- Not directly in documentation
    return 0
end

-- Quasar Specific Exports from documentation
function inventory.GetItemList()
    return qs_inventory:GetItemList()
end

function inventory.GetWeaponList()
    return qs_inventory:GetWeaponList()
end

function inventory.isInventoryOpen()
    return qs_inventory:inInventory()
end

function inventory.setInventoryDisabled(state)
    qs_inventory:setInventoryDisabled(state)
end

function inventory.RegisterStash(id, slots, weight)
    qs_inventory:RegisterStash(id, slots, weight)
end

function inventory.setInClothing(state)
    qs_inventory:setInClothing(state)
end

function inventory.CheckIfInventoryBlocked()
    return qs_inventory:CheckIfInventoryBlocked()
end

return inventory
