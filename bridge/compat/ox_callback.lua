-- Wire/throttle adapter only. All RPC lifecycle work is in the native engine.
local server = lib.context == 'server'
local engine = PRCore.load('@pr_bridge/bridge/callback/transport', _ENV)({
    server=server, timeout=GetConvarInt('ox:callbackTimeout',300000),
    rejectErrors=true, invalidResult='cb_invalid', responseEvent='__ox_cb_'..cache.resource,
    acceptResponse=function(player,target) return server and tonumber(player)==tonumber(target) or not server and player~='' end,
    acceptRequest=function(player,owner,key) return type(owner)=='string' and type(key)=='string' and (server and tonumber(player) and tonumber(player)>0 or not server and player~='') end,
    validateTarget=server and function(target) assert(DoesPlayerExist(target),'Target player does not exist: '..tostring(target)) end or nil,
    requestEvent=function(name) return '__ox_cb_'..name end,
    parseRequest=function(owner,key,...) return owner,key,table.pack(...) end,
    claim=function(name) lib.setValidCallback(name,true) end,
    send=function(name,target,key,...)
        if server then
            TriggerClientEvent('ox_lib:validateCallback',target,name,cache.resource,key)
            TriggerClientEvent('__ox_cb_'..name,target,cache.resource,key,...)
        else
            TriggerServerEvent('ox_lib:validateCallback',name,cache.resource,key)
            TriggerServerEvent('__ox_cb_'..name,cache.resource,key,...)
        end
    end,
    reply=function(player,owner,key,...)
        if server then TriggerClientEvent('__ox_cb_'..owner,player,key,...)
        else TriggerServerEvent('__ox_cb_'..owner,key,...) end
    end,
    onError=print,
})
local throttle = {}
local function request(event,destination,callback,...)
    if not server and type(destination)=='number' and destination>0 then
        local now=GetGameTimer()
        if (throttle[event] or 0)>now then return end
        throttle[event]=now+destination
    end
    return engine.request(event,server and destination or nil,callback,nil,...)
end
local api=setmetatable({}, {__call=function(_,event,destination,callback,...)
    local meta=type(callback)=='table' and getmetatable(callback)
    assert(not callback or type(callback)=='function' or meta and meta.__call,'Expected callback function')
    return request(event,destination,callback,...)
end})
function api.await(event,destination,...) return request(event,destination,false,...) end
api.register=engine.register
return api
