-- Assemble existing PR factories with local natives,raw PR providers and an explicit Forge API.
return function(ports)
    local n,loadFactory=assert(ports.native),assert(ports.load)
    local side=n.IsDuplicityVersion()and'server'or'client';local resource=n.GetCurrentResourceName()
    local schema=loadFactory('bridge/frameworks/forge/consumer_schema')[side]
    local closed=false;local current=assert(ports.isCurrent);local ready=assert(ports.isReady)
    local allocation,services;local api={OperationalReady=false}
    local function owner()return not closed and current()==true and n.GetCurrentResourceName()==resource end
    local function raw()
        if not services then services=assert(ports.getServices(),'raw PR providers required')end;return services
    end
    local function gate(fn)
        assert(type(fn)=='function','explicit Forge API method required')
        return function(...)assert(allocation and allocation.IsAttached()and owner(),'Forge native binding not attached');return fn(...)end
    end
    local function map(t)local out={};for k,v in pairs(assert(t))do out[k]=type(v)=='function'and gate(v)or v end;return out end
    local identity=loadFactory('bridge/frameworks/forge/identity')({getResourceState=n.GetResourceState,
        getResourceMetadata=n.GetResourceMetadata,getNumResourceMetadata=n.GetNumResourceMetadata,isCurrent=owner})
    local input=assert(ports.api);local active={frameworks='forge'};local contracts=assert(ports.contracts)
    assert(contracts.qb~=true or type(input.getCoreObject)=='function','native QB getter required for declared capability')
    local function createLate()
        local phase,pending='allocated',0;local real;local late={Framework={},Inventory={},OperationalReady=false};local aliases={}
        local function invoke(kind,name,...)
            assert(phase=='attached'and owner(),'late native component unavailable');pending=pending+1
            local out=table.pack(pcall(real[kind][name],...));pending=pending-1
            if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
        end
        for name,canonical in pairs(schema.framework)do aliases[canonical]=aliases[canonical]or function(...)return invoke('Framework',canonical,...)end;late.Framework[name]=aliases[canonical]end
        if ports.inventory then for _,name in ipairs({'UseItem','setPlayerData','syncInventory','hasLicense','buyLicense','isPlayerBoss','getOwnedVehicleId'})do late.Inventory[name]=function(...)return invoke('Inventory',name,...)end end end
        function late.Close()phase='closed';local clean=not real or real.Close();return clean and pending==0 end
        function late.Progress()local p=real and real.Progress();return{phase=phase,pending=pending+(p and p.pending or 0),complete=phase=='closed'and pending==0 and(not p or p.complete)}end
        function late.Attach()
            if phase~='allocated'then return false end;phase='attaching';pending=pending+1
            local ok,problem=pcall(function()
                local s=raw();local publications={};local target={}
                publications[1]={object=target,key='framework'}
                local function adapter()
                    local p={isCurrent=owner,native=n,inventory=s.inventory,banking=s.banking,db=s.db,decode=s.decode,
                        view=ports.view,cache=s.cache,cacheNamespace=ports.cacheNamespace or'qbx_core',readSessionReady=ports.readSessionReady,
                        triggerLocal=n.TriggerEvent,triggerServer=n.TriggerServerEvent,core=side=='server'and map(input.framework)or nil}
                    return loadFactory('bridge/runtime/forge/consumer_binding')({side=side,isCurrent=owner,adapter=p,
                        createAdapter=loadFactory('bridge/frameworks/forge/'..side..'_factory'),publications=publications,
                        events=s.events,callbacks=s.callbacks,createEvents=assert(ports.createEvents)})
                end
                real=loadFactory('bridge/runtime/forge/late_binding_factory')({side=side,frameworkMethods=schema.framework,
                    inventoryServer=ports.inventory and assert(s.inventoryBridge).server or nil,isCurrent=owner,isReady=ready,
                    createSelection=function()return loadFactory('bridge/runtime/forge/selection_factory')({side=side,identity=identity,isCurrent=owner})end,
                    createContract=function()return loadFactory('bridge/frameworks/forge/inventory_core_factory')({consumer=resource,identity=identity,
                        core=input.inventory,isCurrent=owner,isReady=ready})end,
                    createAdapter=adapter,createInventory=function(contract)
                        local p={};for k,v in pairs(s.inventoryBridge)do p[k]=v end;p.contract=contract;p.isCurrent=owner
                        return loadFactory('bridge/inventories/ox/forge_bridge_factory')(p)
                    end})
                assert(phase=='attaching'and owner(),'native assembly closed during construction')
                assert(real.Attach());assert(phase=='attaching'and owner(),'native assembly closed during attach')
            end);pending=pending-1
            if not ok then late.Close();return false,problem end;phase='attached';return true
        end
        return late
    end
    allocation=loadFactory('bridge/runtime/forge/consumer_allocation_factory')({side=side,resource=resource,native=n,prCore=assert(ports.prCore),public=ports.public,
        inventory=ports.inventory,normalizedMethods=schema.normalized,isCurrent=owner,isReady=ready,createLate=createLate,
        createRouting=function()return loadFactory('bridge/compat/forge/routing_factory')({active=active,config=assert(ports.config),resourceName='forge-core',
            contracts=contracts,readDeclarations=assert(ports.readDeclarations),isCurrent=owner})end,
        createNormalization=function(base)
            local s=raw();return loadFactory('bridge/frameworks/forge/normalization_factory')({side=side,framework=base,resourceName='forge-core',
                core=map(input.core),native=n,inventory=s.inventory,banking=s.banking,notify=s.notify,textui=s.textui,isCurrent=owner})
        end,
        createHost=function(route)return loadFactory('bridge/compat/forge/native_host_factory')({resourceName='forge-core',contracts=contracts,routing=route,
            getNativeOwner=function()local p=identity.Probe();return p and p.authority end,getBridgeSetting=function()return n.GetConvar('qbx:enablebridge','true')end,
            getCoreObject=input.getCoreObject and gate(input.getCoreObject)or nil,isCurrent=owner,isReady=function()return allocation.IsAttached()and ready()end})end})
    api.Allocation=allocation
    local function operation(fn)
        local out=table.pack(pcall(fn))
        if not out[1]or out[2]~=true then api.Close();if not out[1]then error(out[2],0)end end
        return table.unpack(out,2,out.n)
    end
    function api.Prepare()return operation(allocation.Prepare)end
    function api.Attach()return operation(allocation.Attach)end
    function api.Close()closed=true;local a=allocation.Close();local b=identity.Close();return a and b end
    function api.Progress()local a,b=allocation.Progress(),identity.Progress();return{phase=a.phase,pending=a.pending+b.pending,allocation=a,identity=b,complete=a.complete and b.complete}end
    return api
end
