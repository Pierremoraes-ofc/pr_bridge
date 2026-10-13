return function(server)
    local callback = PRCore.callback or {}
    if callback._transportInstalled then return callback end
    PRCore.callback = callback
    local engine = PRCore.load('@pr_bridge/bridge/callback/transport', _ENV)({
        server=server, timeout=10000, responseEvent='pr_bridge:callback:response',
        requestEvent=function(name) return name end,
        acceptResponse=function(player,target) return server and tonumber(player)==tonumber(target) or not server and player~='' end,
        acceptRequest=function(player,_,key) return type(key)=='string' and (server and tonumber(player) and tonumber(player)>0 or not server and player~='') end,
        validateTarget=server and function(target) assert(type(target)=='number' and target>0,'Invalid callback target') end or nil,
        send=function(name,target,key,...)
            if server then TriggerClientEvent(name,target,key,...) else TriggerServerEvent(name,key,...) end
        end,
        parseRequest=function(key,...) return nil,key,table.pack(...) end,
        reply=function(player,_,key,...)
            if server then TriggerClientEvent('pr_bridge:callback:response',player,key,...)
            else TriggerServerEvent('pr_bridge:callback:response',key,...) end
        end,
        onError=function(reason) print('[pr_bridge:callback] '..reason) end,
    })
    local function trigger(target,name,cb,...) return engine.request(name,target,type(cb)=='function' and cb or function() end,10000,...) end
    local function await(target,name,timeout,...) return engine.request(name,target,false,tonumber(timeout) or 10000,...) end
    if server then callback.triggerClient, callback.awaitClient = trigger,await
    else
        trigger=function(name,cb,...) return engine.request(name,nil,type(cb)=='function' and cb or function() end,10000,...) end
        await=function(name,timeout,...) return engine.request(name,nil,false,tonumber(timeout) or 10000,...) end
    end
    callback.trigger, callback.await, callback.register = trigger,await,engine.register
    callback.cancel, callback.getPending = engine.cancel,engine.getPending
    callback._transportInstalled = true
    return callback
end
