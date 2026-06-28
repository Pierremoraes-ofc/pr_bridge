return function(resourceName, options)
    local inventory, api = {}, exports[resourceName]; options=options or {}
    local function invoke(names,...)
        if type(names)=="string" then names={names} end; local args=table.pack(...)
        for _,name in ipairs(names or {}) do local ok,result=pcall(function() return api[name](api,table.unpack(args,1,args.n)) end); if ok then return result end end
    end
    function inventory.GetResourceName() return resourceName end
    function inventory.GetItemCount(item,metadata,strict) local result=invoke(options.count or {"GetItemCount","getItemCount","GetItemAmount"},item,metadata,strict); return tonumber(result) or (type(result)=="table" and tonumber(result.count or result.amount)) or 0 end
    function inventory.HasItem(item,count,metadata,strict) local result=invoke(options.has or {"HasItem","hasItem"},item,count or 1,metadata,strict); if result~=nil then return result==true or tonumber(result or 0)>=(count or 1) end; return inventory.GetItemCount(item,metadata,strict)>=(count or 1) end
    function inventory.GetPlayerItems() return invoke(options.inventory or {"GetPlayerInventory","GetInventory","getInventory"}) or {} end
    inventory.GetPlayerInventory=inventory.GetPlayerItems
    function inventory.GetImagePath(item) return (options.imagePath or ("nui://%s/html/images"):format(resourceName)):gsub("/$","").."/"..tostring(item) end
    inventory.getInventoryImg=inventory.GetImagePath
    return inventory
end