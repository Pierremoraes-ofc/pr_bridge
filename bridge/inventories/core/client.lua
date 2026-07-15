local inventory={}
local api=exports.core_inventory
function inventory.GetResourceName() return "core_inventory" end
function inventory.GetItemCount(item,metadata,strict) return api:getItemCount(item) or 0 end
function inventory.HasItem(item,count,metadata,strict) return api:hasItem(item,count or 1)==true end
function inventory.GetPlayerItems() return api:getInventory() or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
function inventory.GetItemLabel(item) return item end
function inventory.GetImagePath(item) return "nui://core_inventory/html/img/"..tostring(item) end
inventory.getInventoryImg=inventory.GetImagePath
return inventory
