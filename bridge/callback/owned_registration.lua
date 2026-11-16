-- Private opt-in transport owner. Not loaded by either installed public adapter/bootstrap.
return function(spec)
    local factory=assert(spec.createTransport,'explicit transport factory required')
    assert(type(factory)=='function'and(spec.protocol=='native'or spec.protocol=='ox'),'explicit transport protocol required')
    assert(spec.side=='server'or spec.side=='client','explicit transport side required')
    local protocol,side=spec.protocol,spec.side
    local api={Protocol=protocol,Side=side,State='prepared-inactive'}
    local phase,engine,options,available,releaseClaim='prepared-inactive'
    local records,names={},{}
    local capture
    function api.CaptureRegister(name,handler)
        assert(capture and capture.thread==coroutine.running(),'registration outside owned capture')
        assert(name==capture.name and type(handler)=='function'and capture.handler==nil,'invalid or duplicate capture')
        capture.handler=handler
    end
    function api.Capture(name,producer)
        assert(not capture and type(name)=='string'and type(producer)=='function','invalid/reentrant capture')
        local context={name=name};local thread=coroutine.create(producer);context.thread=thread;capture=context
        local ok,problem=coroutine.resume(thread);capture=nil
        assert(ok,problem)
        if coroutine.status(thread)~='dead'then coroutine.close(thread);error('callback preparation must not yield',0)end
        assert(type(context.handler)=='function','owned delivery was not used during Security construction')
        return context.handler
    end
    function api.Open(config,ownership)
        assert(phase=='prepared-inactive','transport opening is not repeatable')
        assert(type(config)=='table'and config.server==(side=='server'),'transport side mismatch')
        assert(type(ownership)=='table'and type(ownership.available)=='function','external namespace preflight required')
        assert(type(config.requestEvent)=='function'and type(config.responseEvent)=='string','explicit wire options required')
        assert((protocol=='ox')==(type(config.claim)=='function'),'protocol/claim mismatch')
        if protocol=='ox'then assert(type(ownership.releaseClaim)=='function','owned ox claim removal required')end
        options={};for k,v in pairs(config)do options[k]=v end
        available,releaseClaim=ownership.available,ownership.releaseClaim
        if config.claim then
            local claim=config.claim
            options.claim=function(name)
                local record=assert(names[name],'unreserved claim');claim(name);record.claimed=true
            end
        end
        phase='opening';api.State=phase
        local ok,value=pcall(factory,options)
        if not ok then phase='open-failed';api.State=phase;error(value,0)end
        assert(type(value)=='table'and type(value.register)=='function'and type(value.unregister)=='function'
            and type(value.request)=='function'and type(value.cancel)=='function'and type(value.getPending)=='function','complete owned transport required')
        engine={register=value.register,unregister=value.unregister,request=value.request,cancel=value.cancel,getPending=value.getPending}
        phase='opened';api.State=phase
        -- Existing wire/throttle adapters can retain these request methods; registrations use leases only.
        return {request=engine.request,cancel=engine.cancel,getPending=engine.getPending,
            register=function()error('owned transport requires a registration lease',0)end}
    end
    function api.IsReady()return phase=='opened'end
    local function eventName(name)
        assert(phase=='opened'and type(name)=='string'and name~='','opened transport/name required')
        local wire=options.requestEvent(name)
        assert(wire==(protocol=='native'and name or'__ox_cb_'..name),'wire protocol mismatch')
        assert(wire~=options.responseEvent,'request collides with response event')
        return wire
    end
    api.EventName=eventName
    function api.Reserve(name)
        local wire=eventName(name)
        assert(names[name]==nil,'callback already leased: '..name)
        assert(available(name,wire)==true,'external callback collision: '..name)
        local lease={};local record={name=name,lease=lease,active=false}
        records[lease],names[name]=record,record;return lease
    end
    function api.Bind(lease,handler)
        local record=assert(records[lease],'foreign callback lease')
        assert(phase=='opened'and not record.attempted and not record.releasing and type(handler)=='function','callback binding not repeatable')
        assert(available(record.name,eventName(record.name))==true,'callback namespace changed before binding')
        record.attempted=true;record.active=true
        local function dispatch(...)
            if not record.active or records[lease]~=record then return end
            return handler(...)
        end
        engine.register(record.name,dispatch)
        return true
    end
    function api.Release(lease)
        local record=assert(records[lease],'foreign callback lease')
        assert(not record.releasing,'callback release in progress');record.releasing=true;record.active=false
        local ok,problem=pcall(function()
            if record.attempted and not record.removed then engine.unregister(record.name);record.removed=true end
            if record.claimed then assert(releaseClaim(record.name)~=false,'owned claim removal rejected');record.claimed=false end
        end)
        record.releasing=false
        if not ok then error(problem,0)end
        records[lease],names[record.name]=nil,nil;return true
    end
    return api
end
