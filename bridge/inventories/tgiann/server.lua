local factory=PRCore.load("@pr_bridge/bridge/inventories/compat/server",_ENV); local inv=factory("tgiann-inventory",{}); local api=exports["tgiann-inventory"]
function inv.AddItem(src,item,count,metadata,slot) api:AddItem(src,item,count or 1,slot,metadata,false); return true end
function inv.RemoveItem(src,item,count,metadata,slot) api:RemoveItem(src,item,count or 1,slot,metadata); return true end
function inv.CanCarryItem(src,item,count) return api:CanCarryItem(src,item,count or 1)==true end
function inv.GetItemCount(src,item) return api:GetItemCount(src,item) or 0 end
function inv.HasItem(src,item,count) return api:HasItem(src,item,count or 1)==true end
function inv.GetItem(src,item,metadata) return api:GetItemByName(src,item,metadata) end; inv.GetItemByName=inv.GetItem
function inv.GetItemBySlot(src,slot,metadata) return api:GetItemBySlot(src,slot,metadata) end
function inv.GetInventory(src) return api:GetPlayerItems(src) or {} end; inv.GetInventoryItems=inv.GetInventory
function inv.ClearInventory(src) api:ClearInventory(src); return true end
function inv.SetMetadata(src,slot,metadata) local item=api:GetItemBySlot(src,slot); if not item then return false end; api:SetItemData(src,item.name,slot,metadata); return true end
function inv.RegisterStash(id,label,slots,maxWeight) inv.Stashes[id]=true; api:RegisterStash(id,label,slots,maxWeight); return true end
function inv.OpenStash(src,id) api:ForceOpenInventory(src,"stash",id); return true end
function inv.GetStashItems(id) return api:GetSecondaryInventoryItems("stash",id) or {} end
function inv.Items(item) return api:Items(item) or {} end
function inv.GetItemLabel(item) return api:GetItemLabel(item) or item end
function inv.GetImagePath(item) for _,ext in ipairs({"png","webp"}) do if LoadResourceFile("inventory_images",("images/%s.%s"):format(item,ext)) then return ("nui://inventory_images/images/%s.%s"):format(item,ext) end end return "" end; inv.getInventoryImg=inv.GetImagePath
return inv