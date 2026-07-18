local inventory={}
local api=exports.ak47_inventory
function inventory.GetResourceName() return "ak47_inventory" end
function inventory.GetItemCount(item,metadata,strict) return api:GetAmount(item,metadata,strict==true) or 0 end
function inventory.HasItem(item,count,metadata,strict) return api:HasItems(item)==true end
function inventory.GetPlayerItems() return api:GetPlayerItems() or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
function inventory.GetItemLabel(item) return api:GetItemLabel(item) or item end
function inventory.GetImagePath(item) return "nui://ak47_inventory/web/build/images/"..tostring(item) end
inventory.getInventoryImg=inventory.GetImagePath
return inventory
