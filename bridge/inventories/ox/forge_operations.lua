-- Private raw/public contracts. Keep the installed PR transformations distinct from raw OX returns.
return function(ports)
    local inventory,custom=assert(ports.inventory),assert(ports.custom)
    local current,state,resource=assert(ports.isCurrent),assert(ports.resourceState),assert(ports.executingResource)
    local read=assert(ports.readResourceFile)
    local phase,entered='prepared',0
    local api={OperationalReady=false,Public={},Raw={}}
    local function owner()
        local ok,value=pcall(function()return current()==true and resource()=='forge-core'end)
        return ok and value==true
    end
    local function live()return phase=='open'and owner()end
    local function invoke(fn,...)
        if not live()then return nil,'inventory_operations_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end
        return table.unpack(result,2,result.n)
    end
    for _,name in ipairs({'AddItem','RemoveItem','Search','SetDurability','CanCarryItem','GetInventory','ClearInventory',
        'GetSlot','GetSlotWithItem','GetSlotsWithItem','SetMetadata','CanCarryAmount','SetMaxWeight','SetSlotCount','RegisterStash','RegisterShop'})do
        local fn=assert(inventory[name],'installed PR operation required: '..name)
        assert(type(fn)=='function','PR function required: '..name)
        api.Public[name]=function(...)return invoke(fn,...)end
    end
    for _,name in ipairs({'AddItem','RemoveItem','Search','SetDurability','Items','ClearInventory','CanCarryItem',
        'SetItem','GetSlot','GetSlotWithItem','GetSlotsWithItem','GetInventory','ApplyPlayerInventoryBonus'})do
        local fn=assert(custom[name],'installed custom OX operation required: '..name)
        assert(type(fn)=='function','OX function required: '..name)
        api.Raw[name]=function(...)return invoke(fn,custom,...)end
    end
    function api.Raw.searchCountRaw(source,name)return api.Raw.Search(source,'count',name)end
    function api.Raw.searchSlotsRaw(source,name)return api.Raw.Search(source,'slots',name)end
    function api.ReadShopFile(file)return invoke(read,'ox_inventory',file)end
    -- Preserve the state string; each installed consumer retains its own starting/started policy.
    function api.ResourceState()return state('ox_inventory')end
    function api.IsReady()return live()and state('ox_inventory')=='started'end
    function api.Open()
        if phase~='prepared'then return false,'inventory_operations_not_repeatable'end
        if not owner()or state('ox_inventory')~='started'or phase~='prepared'then return false,'inventory_operations_not_ready'end
        phase='open';return true
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0}end
    return api
end
