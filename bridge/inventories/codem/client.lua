local inventory = {}
if ActiveBridges["inventory"] ~= "codem" then return end
local codem_inventory = exports['codem-inventory']

function inventory.openInventory(invType, data)
    -- Codem usually opens inventory via events or keybinds, no direct export in provided docs
    -- But we can trigger standard open if needed
    TriggerEvent('codem-inventory:client:openInventory')
end

function inventory.closeInventory()
    -- No direct close export in docs
    TriggerEvent('codem-inventory:client:closeInventory')
end

function inventory.Items(itemName)
    local items = codem_inventory:GetItemList()
    if itemName then
        return items[itemName]
    end
    return items
end

function inventory.getCurrentWeapon()
    -- No direct export in docs, usually part of user inventory
    local inv = codem_inventory:getUserInventory()
    -- Look for equipped weapon in inventory data if available
    return nil
end

function inventory.Search(search, item, metadata)
    local inv = codem_inventory:getUserInventory()
    local itemName = item or search
    local count = 0
    if inv then
        for _, itemData in pairs(inv) do
            if itemData.name == itemName then
                count = count + (itemData.amount or 0)
            end
        end
    end
    return count
end

function inventory.GetItemCount(itemName, metadata, strict)
    return inventory.Search(nil, itemName)
end

function inventory.GetPlayerItems()
    return codem_inventory:getUserInventory()
end

-- Codem specific exports from docs
function inventory.GetItemList()
    return codem_inventory:GetItemList()
end

function inventory.getUserInventory()
    return codem_inventory:getUserInventory()
end

function inventory.GetClientPlayerInventory()
    return codem_inventory:GetClientPlayerInventory()
end

return inventory
