-- Native execution ports only. The existing context owns owned_tasks and registrations.
return function(ports)
    local n,owner=assert(ports.native),assert(ports.isCurrent)
    assert(n.GetCurrentResourceName()=='forge-core','Forge execution resource required')
    local side=n.IsDuplicityVersion()and'server'or'client'
    assert(side==ports.side,'execution side mismatch')
    local running,getSource=assert(ports.running),assert(ports.getSource)
    assert(type(running)=='function'and type(getSource)=='function','dynamic execution getters required')
    local events=assert(ports.events,'owned event ports required')
    local phase,entered='prepared',0;local refs,wrappers={},{}
    local api={Events=events,OperationalReady=false,PhysicalRemoval=false}
    local blocked={AddEventHandler=true,RemoveEventHandler=true,RegisterNetEvent=true,RegisterCommand=true,exports=true}
    -- Compile only the comparisons, not their results. Every invocation still
    -- checks every bound reference, including a replacement of an unrelated port.
    local refCheck,refsDirty=nil,true
    local compile=ports.compile or rawget(_ENV,'load')
    local function referencesCurrent()
        if refsDirty then
            local checks={}
            for key in pairs(refs)do checks[#checks+1]=('n[%q]==r[%q]'):format(key,key)end
            if type(compile)=='function' then
                local chunk=compile('return function(n,r) return '..(#checks>0 and table.concat(checks,' and ')or'true')..' end',
                    '@forge_native_reference_check','t',{})
                refCheck=chunk and chunk()or nil
            end
            refsDirty=false
        end
        if refCheck then return refCheck(n,refs)end
        for key,fn in pairs(refs)do if n[key]~=fn then return false end end
        return true
    end
    local function current()
        if phase=='closed'then return false end
        local ok,value=pcall(owner);if not ok or value~=true or phase=='closed'then return false end
        return referencesCurrent()
    end
    local function finish(ok,...)
        entered=entered-1
        if not ok then error((...),0)end
        return ...
    end
    local function invoke(fn,...)
        assert(current(),'native execution unavailable');entered=entered+1
        return finish(pcall(fn,...))
    end
    local function bind(name)
        assert(type(name)=='string'and not blocked[name],'use owned registrations for events/exports')
        if wrappers[name]then return wrappers[name]end
        local fn=assert(n[name],'missing native execution port:'..name);assert(type(fn)=='function','native function required')
        refs[name]=fn;refsDirty=true
        local function guarded(body)
            assert(type(body)=='function','task body required')
            return function(...)if current()then return invoke(body,...)end end
        end
        if name=='CreateThread'then
            wrappers[name]=function(body,...)return invoke(fn,guarded(body),...)end
        elseif name=='SetTimeout'then
            wrappers[name]=function(delay,body,...)return invoke(fn,delay,guarded(body),...)end
        else wrappers[name]=function(...)return invoke(fn,...)end end
        return wrappers[name]
    end
    local native={}
    for _,name in ipairs({'GetCurrentResourceName','IsDuplicityVersion','Wait','CreateThread','SetTimeout','GetGameTimer','GetConvar','GetConvarInt'})do native[name]=bind(name)end
    native.wait,native.createThread,native.spawn,native.setTimeout=native.Wait,native.CreateThread,native.CreateThread,native.SetTimeout
    api.Native=native
    function api.Bind(names)
        assert(current(),'native execution unavailable');local out={}
        for _,name in ipairs(names)do out[name]=bind(name)end;return out
    end
    function api.GetSource()return invoke(getSource)end
    function api.Running()return invoke(running)end
    function api.IsCurrent()return current()end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0,physicalRemoval=false}end
    return api
end
