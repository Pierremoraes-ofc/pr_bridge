return function(resourceName, options)
    local inventory, api = {}, exports[resourceName]
    options = options or {}; inventory.Stashes = {}
    local function invoke(names, ...)
        if type(names) == "string" then names = { names } end
        local args = table.pack(...)
        for _, name in ipairs(names or {}) do
            local ok, result, extra = pcall(function() return api[name](api, table.unpack(args, 1, args.n)) end)
            if ok then return result, extra, name end
        end
    end
    function inventory.GetResourceName() return resourceName end
    function inventory.AddItem(inv,item,count,metadata,slot) local result=invoke(options.add or {"AddItem","addItem"},inv,item,count or 1,metadata,slot); return result == true or type(result)=="number" end
    function inventory.RemoveItem(inv,item,count,metadata,slot) local result=invoke(options.remove or {"RemoveItem","removeItem"},inv,item,count or 1,metadata,slot); return result == true or type(result)=="number" end
    function inventory.CanCarryItem(inv,item,count,metadata) local result=invoke(options.carry or {"CanCarryItem","CanAddItem","canCarryItem"},inv,item,count or 1,metadata); return result == nil and true or result == true end
    function inventory.GetItemCount(inv,item,metadata,strict) local result=invoke(options.count or {"GetItemCount","getItemCount","GetItemAmount"},inv,item,metadata,strict); return tonumber(result) or (type(result)=="table" and tonumber(result.count or result.amount)) or 0 end
    function inventory.HasItem(inv,item,count,metadata,strict) local result=invoke(options.has or {"HasItem","hasItem"},inv,item,count or 1,metadata,strict); if result~=nil then return result==true or tonumber(result or 0)>=(count or 1) end; return inventory.GetItemCount(inv,item,metadata,strict)>=(count or 1) end
    function inventory.GetItem(inv,item,metadata) return invoke(options.getItem or {"GetItem","GetItemByName","getItem"},inv,item,metadata) end
    inventory.GetItemByName=inventory.GetItem
    function inventory.GetItemBySlot(inv,slot,metadata) return invoke(options.slot or {"GetItemBySlot","GetSlot","getItemBySlot"},inv,slot,metadata) end
    function inventory.GetInventory(inv) return invoke(options.inventory or {"GetInventory","GetPlayerInventory","getInventory"},inv) or {} end
    inventory.GetInventoryItems=inventory.GetInventory
    function inventory.ClearInventory(inv,keep) local result=invoke(options.clear or {"ClearInventory","ClearPlayerInventory","clearInventory"},inv,keep); return result~=false end
    inventory.ClearPlayerInventory=inventory.ClearInventory
    function inventory.SetMetadata(inv,slot,metadata) local result=invoke(options.metadata or {"SetMetadata","SetItemMetadata","setMetadata"},inv,slot,metadata); return result~=false end
    inventory.SetItemMetadata=inventory.SetMetadata
    function inventory.RegisterStash(id,label,slots,maxWeight,owner,groups,coords)
        inventory.Stashes[id]={label=label,slots=slots,maxWeight=maxWeight,owner=owner,groups=groups,coords=coords}
        local result=invoke(options.registerStash or {"RegisterStash","CreateInventory","registerStash"},id,label,slots,maxWeight,owner,groups,coords); return result~=false
    end
    function inventory.OpenStash(source,id)
        local data=inventory.Stashes[id] or {}; local result=invoke(options.openStash or {"OpenStash","OpenInventory","openInventory"},source,id,data); return result~=false
    end
    function inventory.AddStashItems(id,items) local success=true; for _,item in pairs(items or {}) do success=inventory.AddItem(id,item.name or item.item,item.count or item.amount,item.metadata or item.info,item.slot) and success end; return success end
    function inventory.GetStashItems(id) return inventory.GetInventory(id) end
    function inventory.ClearStash(id) inventory.Stashes[id]=nil; return inventory.ClearInventory(id) end
    function inventory.Items(item) return invoke(options.items or {"Items","GetItems","getItems"},item) end
    function inventory.GetItemLabel(item) local data=inventory.Items(item); return type(data)=="table" and (data.label or data.name) or item end
    function inventory.GetImagePath(item) return (options.imagePath or ("nui://%s/html/images"):format(resourceName)):gsub("/$","").."/"..tostring(item) end
    inventory.getInventoryImg=inventory.GetImagePath
    return inventory
end