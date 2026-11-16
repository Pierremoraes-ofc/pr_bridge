-- Inventory -> PR -> canonical Forge API. Does not masquerade as a QBX version.
local methods={'GetPlayer','GetPlayersData','CanUseItem','GetGroups','IsGradeBoss'}
return function(ports)
    assert(ports.consumer=='ox_inventory','explicit customized inventory consumer required')
    local identity,current,ready=assert(ports.identity),assert(ports.isCurrent),assert(ports.isReady)
    local core=assert(ports.core);local refs={}
    for _,name in ipairs(methods)do refs[name]=assert(core[name]);assert(type(refs[name])=='function','complete Forge inventory contract required')end
    local phase,pending='open',0;local api={Protocol='forge-inventory-core/1',Authority='forge-core',Core={},OperationalReady=false}
    local function check()
        local ok,value=pcall(current);assert(phase=='open'and ok and value==true,'Forge inventory contract closed')
        for _,name in ipairs(methods)do assert(core[name]==refs[name],'Forge inventory handler replaced: '..name)end
    end
    local function call(fn,...)
        pending=pending+1;local out=table.pack(pcall(function(...)
            check();local proof,problem=identity.Probe();check();assert(proof,problem)
            assert(proof.framework=='forge'and proof.authority=='forge-core'and proof.protocol=='1','Forge inventory identity mismatch')
            assert(ready()==true,'Forge inventory provider not ready');check();return fn(...)
        end,...));pending=pending-1
        if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
    end
    for _,name in ipairs(methods)do local fn=refs[name];api.Core[name]=function(_,...)return call(fn,...)end end
    function api.Check()return call(function()return true end)end
    function api.Close()phase='closed';return pending==0 end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    function api.Describe()local names={};for i,name in ipairs(methods)do names[i]=name end;return{protocol=api.Protocol,authority=api.Authority,methods=names}end
    return api
end
