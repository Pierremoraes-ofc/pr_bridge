local factory=PRCore.load("@pr_bridge/bridge/inventories/compat/server",_ENV); local inv=factory("jaksam_inventory",{}); local api=exports.jaksam_inventory
function inv.AddItem(src,item,count,metadata,slot) return api:addItem(src,item,count or 1,metadata,slot)~=false end
function inv.RemoveItem(src,item,count,metadata,slot) return api:removeItem(src,item,count or 1,metadata,slot)~=false end
function inv.CanCarryItem(src,item,count) return api:canCarryItem(src,item,count or 1)==true end
function inv.GetItemCount(src,item) return api:getTotalItemAmount(src,item,nil,true) or 0 end
function inv.HasItem(src,item,count) return api:hasItem(src,item,count or 1)==true end
function inv.GetInventory(src) return api:getInventory(src) or {} end; inv.GetInventoryItems=inv.GetInventory
function inv.ClearInventory(src) return api:clearInventory(src)~=false end
function inv.SetMetadata(src,slot,metadata) return api:setItemMetadataInSlot(src,slot,metadata)~=false end
function inv.RegisterStash(id,label,slots,maxWeight,owner,groups,coords) inv.Stashes[id]=true; local jobs={}; for _,job in ipairs(groups or {}) do jobs[job]=true end; return api:registerStash({id=id,label=label,maxSlots=slots,maxWeight=maxWeight,isPrivate=owner~=nil and owner~=false,allowedJobs=next(jobs) and jobs or nil,coords=coords})~=false end
function inv.OpenStash(src,id) return api:forceOpenInventory(src,id)~=false end
function inv.Items(item) return item and api:getStaticItem(item) or api:getStaticItemsList() end
function inv.GetItemLabel(item) return api:getItemLabel(item) or item end
function inv.GetImagePath(item) return api:getItemImagePath(item) or "" end; inv.getInventoryImg=inv.GetImagePath
return inv