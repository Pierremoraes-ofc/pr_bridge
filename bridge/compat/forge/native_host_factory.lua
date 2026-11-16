-- Prepared native QB host only. The destination must supply its own native bridge getter.
return function(ports)
    local resource=assert(ports.resourceName,'explicit destination resource required')
    local owner,ready=assert(ports.isCurrent),assert(ports.isReady)
    local nativeOwner,setting=assert(ports.getNativeOwner),assert(ports.getBridgeSetting)
    local contracts,routing=assert(ports.contracts),assert(ports.routing)
    local getter=ports.getCoreObject;local phase,pending='open',0;local api={OperationalReady=false}
    local function current()local ok,v=pcall(owner);return phase=='open'and ok and v==true end
    local function check()assert(current(),'forge_native_host_closed')end
    function api.GetCoreObject(filters)
        check();pending=pending+1
        local result=table.pack(pcall(function()
            assert(contracts.qb==true,'forge_native_qb_contract_unavailable')
            local available=ready();check();assert(available==true,'forge_native_host_unready')
            local destination=nativeOwner();check();assert(destination==resource,'forge_native_host_owner_conflict')
            local enabled=setting();check();assert(enabled~='false','[PR Bridge QB] enable the native QBX bridge (qbx:enablebridge)')
            assert(type(getter)=='function','forge_native_qb_getter_unavailable')
            local supported=routing.isNative('qb');check();assert(supported==true,'forge_native_qb_route_unavailable')
            return getter(filters)
        end));pending=pending-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    api.Exports={getQBCoreObject=api.GetCoreObject}
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=pending,complete=phase=='closed'and pending==0}end
    return api
end
