-- Consumer-local native identity/publication. Core attachment is explicitly later.
return function(ports)
    local pr,public=assert(ports.prCore),ports.public;local native=assert(ports.native)
    local side,resource=assert(ports.side),assert(ports.resource)
    assert(side=='client'or side=='server','explicit allocation side required')
    assert(native.GetCurrentResourceName()==resource,'native consumer resource identity mismatch')
    assert((not not native.IsDuplicityVersion())==(side=='server'),'native consumer side identity mismatch')
    local current,ready=assert(ports.isCurrent),assert(ports.isReady)
    local phase,pending='allocated',0;local children,slots={},{};local late,normal,route,host
    local api={OperationalReady=false,Framework={},Inventory={},NativeHost={}}
    local function valid()
        if phase=='closed'or rawget(pr,'forgeConsumerOwner')~=api then return false end
        local ok,value=pcall(current);if not ok or value~=true then return false end
        for _,s in ipairs(slots)do if s.published and rawget(s.object,s.key)~=s.value then return false end end
        return native.GetCurrentResourceName()==resource
    end
    local function check()assert(valid(),'Forge consumer allocation unavailable')end
    local function tracked(fn,...)
        pending=pending+1;local out=table.pack(pcall(fn,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    local function own(name,child)
        assert(type(child)=='table'and type(child.Close)=='function'and type(child.Progress)=='function','owned allocation component required')
        children[#children+1]={name=name,api=child};check();return child
    end
    local function invoke(kind,name,...)
        assert(phase=='attached'and valid(),'Forge consumer not attached')
        return tracked(function(...)
            assert(ready()==true,'Forge consumer providers unavailable');check();assert(phase=='attached','Forge consumer closed during readiness')
            local target=kind=='framework'and normal.Framework or kind=='inventory'and late.Inventory or host
            return assert(target[name],'Forge allocation delegate missing')(...)
        end,...)
    end
    local methods=assert(ports.normalizedMethods);local aliases={};local count=0
    for name,canonical in pairs(methods)do
        assert(type(name)=='string'and type(canonical)=='string'and methods[canonical]==canonical,'explicit normalization schema required')
        aliases[canonical]=aliases[canonical]or function(...)return invoke('framework',canonical,...)end
        api.Framework[name]=aliases[canonical];count=count+1
    end;assert(count>0,'normalization schema required')
    if ports.inventory then for _,name in ipairs({'UseItem','setPlayerData','syncInventory','hasLicense','buyLicense','isPlayerBoss','getOwnedVehicleId'})do
        api.Inventory[name]=function(...)return invoke('inventory',name,...)end
    end end
    api.NativeHost.GetCoreObject=function(...)return invoke('host','GetCoreObject',...)end
    function api.Close()
        phase='closed';local clean=true
        for i=#children,1,-1 do local ok,result=pcall(children[i].api.Close);if not ok or result==false then clean=false end end
        for _,s in ipairs(slots)do if s.published and rawget(s.object,s.key)==s.value then rawset(s.object,s.key,nil)end;s.published=false end
        if rawget(pr,'forgeConsumerOwner')==api and clean and pending==0 then rawset(pr,'forgeConsumerOwner',nil)end
        return clean and pending==0
    end
    function api.Prepare()
        if phase~='allocated'then return false,'consumer allocation not repeatable'end
        assert(rawget(pr,'forgeConsumerOwner')==nil,'foreign consumer allocation')
        slots={{object=pr,key='forgeLateBinding',value=api},{object=pr,key='forgeNormalizedFacade',value=api.Framework}}
        if public then slots[#slots+1]={object=public,key='forgeLateBinding',value=api}end
        for _,s in ipairs(slots)do assert(rawget(s.object,s.key)==nil,'foreign allocation publication')end
        assert(rawget(pr,'forgeRouting')==nil,'foreign Forge routing')
        rawset(pr,'forgeConsumerOwner',api);phase='preparing'
        local ok,problem=pcall(tracked,function()
            check();late=own('late',ports.createLate());route=own('routing',ports.createRouting());host=ports.createHost and own('host',ports.createHost(route))or nil
            slots[#slots+1]={object=pr,key='forgeRouting',value=route}
            for _,s in ipairs(slots)do check();assert(rawget(s.object,s.key)==nil,'allocation publication changed');rawset(s.object,s.key,s.value);s.published=true end
            check();assert(phase=='preparing','allocation closed during preparation')
        end)
        if not ok then api.Close();return false,problem end;phase='prepared';return true
    end
    function api.Attach()
        if phase~='prepared'then return false,'consumer allocation not prepared'end
        phase='attaching';local ok,problem=pcall(tracked,function()
            check();assert(ready()==true,'consumer providers not ready');check()
            normal=own('normalization',ports.createNormalization(late.Framework))
            for name,canonical in pairs(methods)do assert(type(normal.Framework[name])=='function'and normal.Framework[name]==normal.Framework[canonical],'normalization schema changed: '..name)end
            assert(late.Attach());check();assert(phase=='attaching','consumer closed during attach')
        end)
        if not ok then api.Close();return false,problem end;phase='attached';return true
    end
    function api.IsAttached()return phase=='attached'and valid()end
    function api.Progress()
        local all,clean,total={},true,pending
        for _,c in ipairs(children)do local p=c.api.Progress();all[c.name]=p;total=total+(p.pending or 0);if not p.complete then clean=false end end
        return{phase=phase,pending=total,children=all,complete=phase=='closed'and pending==0 and clean and rawget(pr,'forgeConsumerOwner')~=api}
    end
    return api
end
