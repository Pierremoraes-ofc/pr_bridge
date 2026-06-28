local inventory={}
local api=exports.jaksam_inventory
function inventory.GetResourceName() return "jaksam_inventory" end
function inventory.GetItemCount(item,metadata,strict) return api:getTotalItemAmount(item) or 0 end
function inventory.HasItem(item,count,metadata,strict) return (api:getTotalItemAmount(item) or 0)>=(count or 1) end
function inventory.GetPlayerItems() return api:getInventory() or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
function inventory.GetItemLabel(item) return api:getItemLabel(item) or item end
function inventory.GetImagePath(item) return api:getItemImagePath(item) or "" end
inventory.getInventoryImg=inventory.GetImagePath
return inventory
