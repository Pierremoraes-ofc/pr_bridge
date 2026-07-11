local inventory={}
local api=exports["ps-inventory"]; local qb=exports["qb-core"]:GetCoreObject()
function inventory.GetResourceName() return "ps-inventory" end
function inventory.GetItemCount(item,metadata,strict) local total=0; for _,entry in pairs(qb.Functions.GetPlayerData().items or {}) do if entry.name==item then total=total+(entry.amount or 0) end end; return total end
function inventory.HasItem(item,count,metadata,strict) return api:HasItem(item,count or 1)==true end
function inventory.GetPlayerItems() return qb.Functions.GetPlayerData().items or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
function inventory.GetItemLabel(item) local data=qb.Shared.Items[item]; return data and data.label or item end
function inventory.GetImagePath(item) return "nui://ps-inventory/html/images/"..tostring(item) end
inventory.getInventoryImg=inventory.GetImagePath
return inventory
