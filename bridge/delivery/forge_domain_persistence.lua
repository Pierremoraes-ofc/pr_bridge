-- Borrow the existing local IO127 JSON delegates;no second recovery/lock engine.
return function(ports)
    local io,owner=assert(ports.io),assert(ports.isCurrent)
    local closed,pending=false,0;local api={Library={},OperationalReady=false};local references={}
    assert(io.Describe().resource=='forge-core'and io.Describe().side=='server','server-local Forge persistence required')
    local function valid()
        local ok,v=pcall(owner);if closed or not ok or v~=true or io.Progress().closed then return false end
        for name,fn in pairs(references)do if io.JSON[name]~=fn then return false end end;return true
    end
    for _,name in ipairs({'loadJsonRecovery','saveJsonRecovery','saveJsonBatch'})do
        local fn=assert(io.JSON[name],'installed persistence delegate required:'..name);references[name]=fn
        api.Library[name]=function(...)
            assert(valid(),'domain persistence unavailable');pending=pending+1
            local out=table.pack(pcall(fn,...));pending=pending-1
            if not out[1]then error(out[2],0)end;return table.unpack(out,2,out.n)
        end
    end
    function api.Close()closed=true;return pending==0 end
    function api.IsCurrent()return valid()end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    return api
end
