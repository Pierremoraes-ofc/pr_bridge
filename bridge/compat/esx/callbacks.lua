-- Native bounded RPC engine; ESX callback-style replies are adapted here only.
return function(E,C,state)
    local server=C.context=='server'
    local function wrap(handler)
        assert(C.callable(handler),'Expected ESX callback')
        return function(...)
            local args=table.pack(...);local result=promise.new();local resolved=false
            local function reply(...)
                if resolved then return end;resolved=true;result:resolve(table.pack(...))
            end
            SetTimeout(10000,function() if not resolved then resolved=true;result:reject('ESX callback reply timed out') end end)
            if server then handler(args[1],reply,table.unpack(args,2,args.n))
            else handler(reply,table.unpack(args,1,args.n)) end
            local values=Citizen.Await(result);return table.unpack(values,1,values.n)
        end
    end
    local define=function(name,fn) C.define(E,name,fn) end
    local function register(name,handler)
        assert(type(name)=='string' and #name<=128 and name:sub(1,9)~='__pr_esx:','Invalid or reserved ESX callback name')
        local previous=state.callbacks[name]
        assert(not previous or previous.owner==C.owner,'ESX callback is owned by another resource: '..name)
        state.callbacks[name]={owner=C.owner,handler=handler,wrapped=wrap(handler)}
        state.engine.register(name,function(...)
            local current=state.callbacks[name]
            if not current then return nil,'callback_unregistered' end
            return current.wrapped(...)
        end)
    end
    local function trigger(name,target,cb,...)
        assert(C.callable(cb),'Expected ESX reply callback')
        return state.engine.request(name,target,function(...) cb(...) end,10000,...)
    end
    if server then
        define('RegisterServerCallback',register)
        define('DoesServerCallbackExist',function(name) return state.callbacks[name]~=nil end)
        define('TriggerClientCallback',function(id,name,cb,...) return trigger(name,id,cb,...) end)
        define('AwaitClientCallback',function(id,name,...) return state.engine.request(name,id,false,10000,...) end)
    else
        define('RegisterClientCallback',register)
        define('DoesClientCallbackExist',function(name) return state.callbacks[name]~=nil end)
        define('TriggerServerCallback',function(name,cb,...) return trigger(name,nil,cb,...) end)
        define('AwaitServerCallback',function(name,...) return state.engine.request(name,nil,false,10000,...) end)
    end
end
