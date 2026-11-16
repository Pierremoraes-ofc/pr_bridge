-- Explicit cache/event boundary. The supplied installed PR cache stays passive.
return function(ports)
    local current,running=assert(ports.isCurrent),assert(ports.running)
    local access,emit,state=assert(ports.accessCacheState),assert(ports.emit),assert(ports.getResourceState)
    local cache=assert(ports.cache);local phase,entered,windows='prepared',0,0;local permits={};local main={}
    local api={OperationalReady=false,Delivery={},Cache={}}
    local function thread()return running()or main end
    local function owner()local ok,v=pcall(current);return ok and v==true end
    local function invoke(fn,...)
        if not owner()or not(phase=='open'or(phase=='draining'and permits[thread()]))then error('cache_delivery_closed',0)end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    api.EmitLocal=function(...)return invoke(emit,...)end
    api.Delivery={getResourceState=function(...)return invoke(state,...)end,
        writeCache=function(...)return invoke(access,...)end,emit=api.EmitLocal}
    for _,name in ipairs({'get','set','patch','clear','clearPrefix','GetPlayer','GetMetadata','GetResourceState','SetResourceState'})do
        local fn=assert(cache[name],'installed PR cache method required: '..name)
        api.Cache[name]=function(...)
            local args=table.pack(...);if args[1]==api.Cache then args[1]=cache end
            return invoke(fn,table.unpack(args,1,args.n))
        end
    end
    function api.Open()if phase~='prepared'or not owner()then return false end;phase='open';return true end
    function api.CloseIngress()if phase~='closed'then phase='draining'end;return true end
    function api.DuringCleanup(fn,...)
        assert(phase=='draining'and owner(),'cache cleanup owner required');local key=thread()
        permits[key]=(permits[key]or 0)+1;windows=windows+1
        local result=table.pack(pcall(fn,...));windows=windows-1;permits[key]=permits[key]-1;if permits[key]==0 then permits[key]=nil end
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,cleanupWindows=windows,complete=phase=='closed'and entered==0 and windows==0,DeliveryAcknowledged=false}end
    return api
end
