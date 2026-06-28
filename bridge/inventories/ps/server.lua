local factory=PRCore.load("@pr_bridge/bridge/inventories/compat/server",_ENV); local inv=factory("ps-inventory",{}); local api=exports["ps-inventory"]; local qb=exports["qb-core"]:GetCoreObject()
function inv.AddItem(src,item,count,metadata,slot) return api:AddItem(src,item,count or 1,slot,metadata)~=false end
function inv.RemoveItem(src,item,count,metadata,slot) return api:RemoveItem(src,item,count or 1,slot)~=false end
function inv.CanCarryItem() return true end
function inv.GetItemCount(src,item) local player=qb.Functions.GetPlayer(src); local count=0; for _,entry in pairs(player and player.PlayerData.items or {}) do if entry.name==item then count=count+(entry.amount or 0) end end; return count end
function inv.HasItem(src,item,count) return api:HasItem(src,item,count or 1)==true end
function inv.GetItem(src,item) return api:GetItemByName(src,item) end; inv.GetItemByName=inv.GetItem
function inv.GetItemBySlot(src,slot) return api:GetItemBySlot(src,slot) end
function inv.GetInventory(src) local player=qb.Functions.GetPlayer(src); return player and player.PlayerData.items or {} end; inv.GetInventoryItems=inv.GetInventory
function inv.ClearInventory() return false end; function inv.SetMetadata() return false end; function inv.RegisterStash() return false end
function inv.OpenStash(src,id) api:OpenInventory("stash",id,nil,src); return true end
function inv.Items(item) return item and qb.Shared.Items[item] or qb.Shared.Items end
function inv.GetItemLabel(item) local data=inv.Items(item); return data and data.label or item end
function inv.GetImagePath(item) for _,ext in ipairs({"png","webp"}) do if LoadResourceFile("ps-inventory",("html/images/%s.%s"):format(item,ext)) then return ("nui://ps-inventory/html/images/%s.%s"):format(item,ext) end end return "" end; inv.getInventoryImg=inv.GetImagePath
return inv