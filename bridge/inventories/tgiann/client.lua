local inventory={}
local api=exports["tgiann-inventory"]
function inventory.GetResourceName() return "tgiann-inventory" end
function inventory.GetItemCount(item,metadata,strict) return api:GetItemCount(item,metadata,strict==true) or 0 end
function inventory.HasItem(item,count,metadata,strict) return api:HasItem(item,count or 1)==true end
function inventory.GetPlayerItems() return api:GetPlayerItems() or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
function inventory.GetItemLabel(item) return item end
function inventory.GetImagePath(item) return "nui://inventory_images/images/"..tostring(item) end
inventory.getInventoryImg=inventory.GetImagePath
return inventory
