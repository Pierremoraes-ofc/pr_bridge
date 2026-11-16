-- Explicit engine delegates over execution129. Registrations remain with their existing owners.
return function(ports)
    local execution,owner=assert(ports.execution),assert(ports.isCurrent)
    local side=assert(ports.side);assert(side=='server'or side=='client','native ports side required')
    assert((not not execution.Native.IsDuplicityVersion())==(side=='server'),'native ports side mismatch')
    local closed,pending=false,0;local cache,refs={},{};local api={OperationalReady=false,Side=side}
    local function current()
        local ok,v=pcall(owner);if closed or not ok or v~=true or not execution.IsCurrent()then return false end
        for name,value in pairs(refs)do if ports[name]~=value then return false end end;return true
    end
    local function finish(ok,...)
        pending=pending-1
        if not ok then error((...),0)end
        return ...
    end
    local function invoke(fn,...)
        assert(current(),'native graph ports unavailable');pending=pending+1
        return finish(pcall(fn,...))
    end
    local special={['$source']=function()return execution.GetSource()end}
    for target,key in pairs({['$time']='time',['$date']='date',['$locale']='locale',['$promise']='newPromise',['$await']='awaitPromise'})do
        special[target]=function(...)
            local fn=assert(ports[key],'explicit native adjunct required:'..key);assert(type(fn)=='function','native adjunct function required:'..key)
            refs[key]=fn;return fn(...)
        end
    end
    local blocked={AddEventHandler=true,RemoveEventHandler=true,RegisterNetEvent=true,RegisterCommand=true,exports=true,Capture=true,CaptureRegister=true}
    local function bind(target)
        assert(type(target)=='string'and not blocked[target],'owned registration cannot become an engine port')
        if cache[target]then return cache[target]end
        local fn=special[target]or assert(execution.Bind({target})[target])
        local wrapped
        local function body(callback)assert(type(callback)=='function','scheduled callback required');return function(...)if current()then return invoke(callback,...)end end end
        if target=='CreateThread'then wrapped=function(callback,...)return invoke(fn,body(callback),...)end
        elseif target=='SetTimeout'then wrapped=function(delay,callback,...)return invoke(fn,delay,body(callback),...)end
        else wrapped=function(...)return invoke(fn,...)end end
        cache[target]=wrapped;return wrapped
    end
    function api.Select(schema)
        assert(current(),'native graph ports unavailable');local out={}
        for name,target in pairs(schema)do assert(type(name)=='string','native alias required');out[name]=bind(target)end
        return out
    end
    function api.Close()closed=true;return pending==0 end
    function api.IsCurrent()return current()end
    function api.Progress()return{closed=closed,pending=pending,complete=closed and pending==0,operationalReady=false}end
    return api
end
