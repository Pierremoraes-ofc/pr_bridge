-- Explicit Forge selection branch. Other framework modes remain with the existing selector.
local accepted={forge=true,['forge-core']=true}
return function(ports)
    local side=assert(ports.side);assert(side=='server'or side=='client','explicit selection side required')
    local identity,current=assert(ports.identity),assert(ports.isCurrent)
    local phase,pending='open',0;local api={OperationalReady=false}
    local function check()local ok,value=pcall(current);assert(phase=='open'and ok and value==true,'Forge selector closed')end
    function api.Select(kind,requested)
        check();if kind~='frameworks'or not accepted[requested]then return nil end
        pending=pending+1;local out=table.pack(pcall(function()
            check();local proof,problem=identity.Probe();check();assert(proof,problem)
            assert(proof.framework=='forge'and proof.authority=='forge-core'and proof.publicResource=='forge-core'and proof.protocol=='1','explicit Forge identity required')
            return{folder='forge',resource='forge-core',path='bridge.frameworks.forge.'..side,operationalReady=false}
        end));pending=pending-1
        if not out[1]then error(out[2],0)end;return out[2]
    end
    function api.Close()phase='closed';return pending==0 end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
