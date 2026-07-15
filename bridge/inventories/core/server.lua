local factory=PRCore.load("@pr_bridge/bridge/inventories/compat/server",_ENV); local inv=factory("core_inventory",{}); local api=exports.core_inventory
function inv.AddItem(src,item,count,metadata) return api:addItem(src,item,count or 1,metadata)~=false end
function inv.RemoveItem(src,item,count) api:removeItem(src,item,count or 1); return true end
function inv.CanCarryItem(src,item,count,metadata) return api:canCarry(src,item,count or 1,metadata)==true end
function inv.GetItemCount(src,item) return api:getItemCount(src,item) or 0 end
function inv.HasItem(src,item,count) return api:hasItem(src,item,count or 1)==true end
function inv.GetItem(src,item) return api:getItem(src,item) end; inv.GetItemByName=inv.GetItem
function inv.GetItemBySlot(src,slot) return api:getItemBySlot(src,slot) end
function inv.GetInventory(src) return api:getInventory(src) or {} end; inv.GetInventoryItems=inv.GetInventory
function inv.ClearInventory(src) api:clearInventory(src,src); return true end
function inv.SetMetadata(src,slot,metadata) api:setMetadata(src,slot,metadata); return true end
function inv.RegisterStash(id,label,slots,maxWeight) inv.Stashes[id]={label=label,slots=slots,maxWeight=maxWeight}; return true end
function inv.OpenStash(src,id) local data=inv.Stashes[id] or {}; api:openInventory(src,id,"stash",data.slots or 30,data.maxWeight or 50000,true,nil,false); return true end
function inv.Items(item) local items=api:getItemsList() or {}; return item and items[item] or items end
function inv.GetItemLabel(item) local data=inv.Items(item); return type(data)=="table" and (data.label or item) or item end
function inv.GetImagePath(item) for _,ext in ipairs({"png","webp"}) do if LoadResourceFile("core_inventory",("html/img/%s.%s"):format(item,ext)) then return ("nui://core_inventory/html/img/%s.%s"):format(item,ext) end end return "" end; inv.getInventoryImg=inv.GetImagePath
return inv