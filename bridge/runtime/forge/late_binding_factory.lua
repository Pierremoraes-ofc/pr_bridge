-- Stable PR/inventory facades with explicit late attachment; constructors never query the core.
local inventoryNames={'UseItem','setPlayerData','syncInventory','hasLicense','buyLicense','isPlayerBoss','getOwnedVehicleId'}
return function(ports)
    local side=assert(ports.side);assert(side=='server'or side=='client','explicit late binding side required')
    local current,ready=assert(ports.isCurrent),assert(ports.isReady)
    local methods=assert(ports.frameworkMethods);local inventory=ports.inventoryServer
    assert(inventory==nil or(side=='server'and type(inventory)=='table'),'inventory target belongs only to its server consumer')
    local phase,pending='allocated',0;local children={};local adapter;local captured={}
    local api={OperationalReady=false,Framework={},Inventory={}}
    local function valid()local ok,value=pcall(current);return phase~='closed'and ok and value==true end
    local function check()assert(valid(),'late Forge binding closed')end
    local function tracked(fn,...)
        pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    local function call(kind,name,...)
        assert(phase=='attached'and valid(),'late Forge binding not ready')
        return tracked(function(...)
            assert(ready()==true,'late Forge providers not ready');check();assert(phase=='attached','late Forge binding closed during readiness')
            local destination=kind=='framework'and adapter.Framework or inventory
            local fn=assert(captured[kind..':'..name]);assert(destination[name]==fn,'late Forge target replaced')
            return fn(...)
        end,...)
    end
    local aliases={};local count=0
    for name,canonical in pairs(methods)do
        assert(type(name)=='string'and type(canonical)=='string'and methods[canonical]==canonical,'explicit framework method/alias map required')
        if not aliases[canonical]then aliases[canonical]=function(...)return call('framework',canonical,...)end end
        api.Framework[name]=aliases[canonical];count=count+1
    end;assert(count>0,'framework methods required')
    if inventory then for _,name in ipairs(inventoryNames)do api.Inventory[name]=function(...)return call('inventory',name,...)end end end
    local function own(name,child)
        assert(type(child)=='table'and type(child.Close)=='function'and type(child.Progress)=='function','owned late binding component required')
        children[#children+1]={name=name,api=child};check();return child
    end
    function api.Close()
        phase='closed';local clean=true
        for i=#children,1,-1 do local ok,value=pcall(children[i].api.Close);if not ok or value==false then clean=false end end
        return clean and pending==0
    end
    function api.Attach()
        if phase~='allocated'then return false,'late attachment not repeatable'end
        phase='attaching';local ok,problem=pcall(tracked,function()
            check();assert(ready()==true,'late Forge providers not ready');check()
            local selection=own('selection',ports.createSelection());assert(selection.Select('frameworks','forge').folder=='forge');check()
            local contract
            if inventory then contract=own('contract',ports.createContract());assert(contract.Check());check()end
            adapter=own('adapter',ports.createAdapter());assert(adapter.Install());check()
            if inventory then local bridge=own('inventory',ports.createInventory(contract));assert(bridge.Install());check()end
            for name,canonical in pairs(methods)do
                assert(type(adapter.Framework[name])=='function'and adapter.Framework[name]==adapter.Framework[canonical],'framework method/alias mismatch')
                captured['framework:'..name]=adapter.Framework[name]
            end
            if inventory then for _,name in ipairs(inventoryNames)do captured['inventory:'..name]=assert(inventory[name]);assert(type(inventory[name])=='function')end end
            assert(phase=='attaching','late Forge attachment closed');check()
        end)
        if not ok then api.Close();return false,problem end
        phase='attached';return true
    end
    function api.Progress()
        local out,clean={},true;local total=pending
        for _,c in ipairs(children)do local p=c.api.Progress();out[c.name]=p;total=total+(p.pending or 0);if not p.complete then clean=false end end
        return{phase=phase,pending=total,children=out,complete=phase=='closed'and pending==0 and clean}
    end
    return api
end
