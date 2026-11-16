-- Private client config/wait ports; provider calls remain PR-owned, never framework-routed.
return function(ports)
    local current,running=assert(ports.isCurrent),assert(ports.running)
    local phase,entered,windows='prepared',0,0;local permits={};local main={}
    local api={OperationalReady=false,Ports={}}
    local function thread()return running()or main end
    local function allowed()
        local ok,value=pcall(current)
        return ok and value==true and(phase=='open'or(phase=='draining'and permits[thread()]~=nil))
    end
    local function check()if not allowed()then error('client_configuration_closed',0)end end
    local function invoke(fn,...)
        check();entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local pr,qbx=assert(ports.prKeys),assert(ports.qbxKeys)
    local haveKey,hasKeys=assert(pr.HaveKey),assert(qbx.HasKeys)
    local state,plate=assert(ports.getResourceState),assert(ports.getVehicleNumberPlateText)
    api.Ports={vec4=assert(ports.vec4),joaat=assert(ports.joaat),
        getResourceState=function(...)return invoke(state,...)end,
        getVehicleNumberPlateText=function(...)return invoke(plate,...)end,
        vehicleKeys={pr={haveKey=function(...)return invoke(haveKey,pr,...)end},
            qbx={hasKeys=function(...)return invoke(hasKeys,qbx,...)end}}}
    local waitFor=assert(ports.waitFor,'installed PR waitFor required')
    function api.WaitFor(callback,...)
        check();assert(type(callback)=='function','waitFor callback must be a function')
        return invoke(waitFor,function(...)check();return callback(...)end,...)
    end
    function api.Open()
        if phase~='prepared'then return false end
        local ok,value=pcall(current);if not ok or value~=true then return false end
        phase='open';return true
    end
    function api.CloseIngress()if phase~='closed'then phase='draining'end;return true end
    function api.DuringCleanup(fn,...)
        local ok,value=pcall(current);assert(phase=='draining'and ok and value==true,'client configuration cleanup owner required')
        local key=thread();permits[key]=(permits[key]or 0)+1;windows=windows+1
        local result=table.pack(pcall(fn,...));windows=windows-1;permits[key]=permits[key]-1;if permits[key]==0 then permits[key]=nil end
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,cleanupWindows=windows,complete=phase=='closed'and entered==0 and windows==0,DeliveryAcknowledged=false}end
    return api
end
