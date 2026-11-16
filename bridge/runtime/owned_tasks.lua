-- Private scheduling utility. Explicit providers only; not installed in the live bridge.
return function(ports)
    local current=assert(ports.isCurrent)
    local running=assert(ports.running)
    local onError=assert(ports.onError)
    local phase,serial='prepared',0
    local records=setmetatable({},{__mode='k'})
    local active,executing,bindings={},{},{}
    local totals={completed=0,cancelled=0,failed=0}
    local cancelled={} -- Private sentinel; never returned as an application failure.
    local api={Cooperative=true,PhysicalRemoval=false}
    local function finish(r,status)
        if active[r]then active[r]=nil;totals[status]=totals[status]+1 end
        r.status,r.fn,r.args=status,nil,nil
    end
    local function close()
        if phase=='closed'then return false end
        phase='closed'
        for r in pairs(active)do
            r.cancel=true
            if r.status=='queued'then finish(r,'cancelled')end
        end
        return true
    end
    local function valid(r)
        if phase~='open'then return false end
        local ok,value=pcall(current)
        if not ok or not value then close();return false end
        if phase~='open'then return false end
        while r do if r.cancel then return false end;r=r.parent end
        return true
    end
    local function checkpoint(r)if r and not valid(r)then error(cancelled,0)end end
    local function schedule(b,kind,delay,fn,args)
        assert(type(fn)=='function','task function required')
        local parent=executing[running()]
        if not valid(parent)then return nil,'task_scope_closed'end
        local provider=assert(kind=='timeout'and b.timeout or b.thread,'scheduler provider required')
        serial=serial+1
        local handle={}
        local r={id=serial,parent=parent,kind=kind,status='queued',fn=fn,args=args}
        records[handle],active[r]=r,true
        local function run(...)
            if r.status~='queued'then return end
            if not valid(r)then finish(r,'cancelled');return end
            local co=running();local prior=executing[co]
            r.status='running';executing[co]=r
            local body,params=r.fn,r.args;r.fn,r.args=nil,nil
            local result=table.pack(pcall(body,table.unpack(params,1,params.n)))
            executing[co]=prior
            if result[1]then
                finish(r,valid(r)and'completed'or'cancelled')
                return table.unpack(result,2,result.n)
            elseif result[2]==cancelled then finish(r,'cancelled')
            else
                finish(r,'failed');r.error=tostring(result[2])
                close()
                onError(result[2],r.id)
            end
        end
        -- Record first: a provider may publish and then throw or reenter Close.
        local result
        if kind=='timeout'then result=table.pack(pcall(provider,delay,run))
        else result=table.pack(pcall(provider,run))end
        if not result[1]then close();error(result[2],0)end
        return handle,table.unpack(result,2,result.n)
    end
    function api.WrapNative(native)
        assert(phase=='prepared','native ports must be wrapped before Open')
        local n={};for k,v in pairs(native)do n[k]=v end
        local b={thread=n.CreateThread or n.createThread,timeout=n.SetTimeout or n.setTimeout}
        bindings[n]=b
        for _,name in ipairs({'CreateThread','createThread'})do
            if n[name]then
                local provider=n[name]
                n[name]=function(fn,...)
                    local result=table.pack(schedule({thread=provider},'thread',nil,fn,table.pack(...)))
                    if not result[1]then return nil,result[2]end
                    return table.unpack(result,2,result.n)
                end
            end
        end
        for _,name in ipairs({'SetTimeout','setTimeout'})do
            if n[name]then
                local provider=n[name]
                n[name]=function(ms,fn,...)
                    local result=table.pack(schedule({timeout=provider},'timeout',ms,fn,table.pack(...)))
                    if not result[1]then return nil,result[2]end
                    return table.unpack(result,2,result.n)
                end
            end
        end
        for _,name in ipairs({'Wait','wait'})do
            if n[name]then
                local provider=n[name]
                n[name]=function(...)
                    local r=executing[running()];checkpoint(r)
                    local result=table.pack(provider(...));checkpoint(r)
                    return table.unpack(result,1,result.n)
                end
            end
        end
        return n
    end
    function api.Open()
        if phase~='prepared'then return false end
        phase='open'
        return valid()
    end
    function api.Launch(native,fn,...)
        local b=assert(bindings[native],'foreign native binding')
        return(schedule(b,'thread',nil,fn,table.pack(...)))
    end
    function api.Boundary(fn,...)
        local r=executing[running()];checkpoint(r)
        local result=table.pack(fn(...));checkpoint(r)
        return table.unpack(result,1,result.n)
    end
    function api.Cancel(handle)
        local r=records[handle]
        if not r or r.cancel then return false end
        r.cancel=true
        for child in pairs(active)do
            local ancestor=child
            while ancestor and ancestor~=r do ancestor=ancestor.parent end
            if ancestor==r then
                child.cancel=true
                if child.status=='queued'then finish(child,'cancelled')end
            end
        end
        return true
    end
    function api.Task(handle)
        local r=records[handle];if not r then return nil end
        return{id=r.id,parent=r.parent and r.parent.id,kind=r.kind,status=r.status,cancelRequested=r.cancel==true,error=r.error}
    end
    function api.Snapshot()
        local out={phase=phase,scheduled=serial,queued=0,running=0,completed=totals.completed,cancelled=totals.cancelled,failed=totals.failed}
        for r in pairs(active)do out[r.status]=out[r.status]+1 end
        out.quiescent=out.queued==0 and out.running==0
        return out
    end
    api.Close=close
    return api
end
