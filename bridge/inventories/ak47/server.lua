local factory=PRCore.load("@pr_bridge/bridge/inventories/compat/server",_ENV); local inv=factory("ak47_inventory",{}); local api=exports.ak47_inventory
function inv.AddItem(src,item,count,metadata,slot) return api:AddItem(src,item,count or 1,slot,metadata)~=false end
function inv.RemoveItem(src,item,count,metadata,slot) return api:RemoveItem(src,item,count or 1,slot)~=false end
function inv.CanCarryItem(src,item,count) return api:CanAddItem(src,item,count or 1)==true end
function inv.GetItemCount(src,item,metadata,strict) return api:GetAmount(src,item,metadata,strict==true) or 0 end
function inv.HasItem(src,items,count) local result=api:HasItems(src,items); if type(result)=="number" then return result>=(count or 1) end; return result==true end
function inv.GetItem(src,item,metadata,strict) return api:GetItem(src,item,metadata,strict==true) end; inv.GetItemByName=inv.GetItem
function inv.GetInventory(src) return api:GetInventoryItems(src) or {} end; inv.GetInventoryItems=inv.GetInventory
function inv.ClearInventory(src) api:ClearInventory(src,src); return true end
function inv.SetMetadata(src,slot,metadata) return api:SetItemInfo(src,slot,metadata)~=false end
function inv.RegisterStash(id,label,slots,maxWeight) inv.Stashes[id]=true; return api:CreateInventory(id,{type="stash",label=label,slots=slots or 50,maxWeight=maxWeight or 50000})~=false end
function inv.OpenStash(src,id) return api:OpenInventory(src,id)~=false end
function inv.Items(item) return api:Items(item) end
function inv.GetItemLabel(item) return api:GetItemLabel(item) or item end
function inv.GetImagePath(item) for _,ext in ipairs({"png","webp"}) do if LoadResourceFile("ak47_inventory",("web/build/images/%s.%s"):format(item,ext)) then return ("nui://ak47_inventory/web/build/images/%s.%s"):format(item,ext) end end return "" end; inv.getInventoryImg=inv.GetImagePath
return inv