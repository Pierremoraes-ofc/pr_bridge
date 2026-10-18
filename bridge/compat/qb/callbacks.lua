return function(Q,C,state)
    local server=C.context=='server'
    local function wrap(handler)
        return function(...)
            assert(not C.closed,'QB callback owner stopped')
            local args=table.pack(...);local result=promise.new();local resolved=false
            local function reply(...)
                if resolved then return end;resolved=true;result:resolve(table.pack(...))
            end
            SetTimeout(10000,function() if not resolved then resolved=true;result:reject('QB callback reply timed out') end end)
            if server then handler(args[1],reply,table.unpack(args,2,args.n)) else handler(reply,table.unpack(args,1,args.n)) end
            local values=Citizen.Await(result);return table.unpack(values,1,values.n)
        end
    end
    local function register(name,handler)
        C.target();assert(type(name)=='string' and #name>0 and #name<=128 and name:sub(1,8)~='__pr_qb:' and C.callable(handler),'Invalid or reserved QB callback')
        local previous=state.callbacks[name];assert(not previous or previous.owner==C.owner,'QB callback belongs to another resource')
        local entry={owner=C.owner,handler=handler,wrapped=wrap(handler)};state.callbacks[name]=entry
        state.engine.register(name,function(...)
            local live=state.callbacks[name];assert(live,'QB callback unregistered');return live.wrapped(...)
        end)
        local registry=server and Q.ServerCallbacks or Q.ClientCallbacks
        registry[name]=handler
    end
    local function request(name,target,...)
        C.target();local args=table.pack(...);local callback,start=nil,1
        if C.callable(args[1]) then callback=args[1];start=2 end
        if callback then
            return state.engine.request(name,target,function(...) if not C.closed then callback(...) end end,10000,table.unpack(args,start,args.n))
        end
        return state.engine.request(name,target,false,10000,table.unpack(args,start,args.n))
    end
    if server then
        Q.Functions.CreateCallback=register
        Q.Functions.TriggerClientCallback=function(name,target,...) return request(name,tonumber(target),...) end
        Q.Functions.TriggerCallback=function(name,source,reply,...)
            C.target();local entry=assert(state.callbacks[name],'QB callback unavailable')
            return entry.handler(source,reply,...)
        end
    else
        Q.Functions.CreateClientCallback=register
        Q.Functions.TriggerCallback=function(name,...) return request(name,nil,...) end
    end
    C.supported[server and 'Functions.CreateCallback' or 'Functions.CreateClientCallback']='adapted'
    C.supported[server and 'Functions.TriggerClientCallback' or 'Functions.TriggerCallback']='adapted'
end
