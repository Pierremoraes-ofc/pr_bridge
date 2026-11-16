-- Private installed PR-carkeys/garage boundary; no framework lookup or persistence authority.
return function(ports)
    local public,raw=assert(ports.vehicleKey),assert(ports.prCarkeys)
    local state,selected,current,send=assert(ports.resourceState),assert(ports.selected),assert(ports.isCurrent),assert(ports.sendClient)
    local phase,entered='prepared',0
    local api={OperationalReady=false,VehicleKey={},Pr={},Integration={}}
    local function owner()local ok,value=pcall(current);return ok and value==true end
    local function invoke(fn,...)
        if phase~='open'or not owner()then return nil,'vehicle_scope_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    for _,name in ipairs({'GiveTempKeys','RemoveTempKeys','GiveKeyItem','RemoveKeyItem','HaveTemporaryKey','HavePermanentKey'})do
        local fn=assert(public[name],'installed PR vehicle-key function required: '..name)
        assert(type(fn)=='function','PR function required: '..name)
        api.VehicleKey[name]=function(...)return invoke(fn,...)end
    end
    for name,export in pairs({buyOriginalKey='BuyOriginalKey',createTempKeyItem='CreateTempKeyItem',
        giveTempKey='GiveTempKey',setLockState='SetLockState'})do
        local fn=assert(raw[export],'explicit PR carkeys export required: '..export)
        assert(type(fn)=='function','export function required: '..export)
        api.Pr[name]=function(...)return invoke(fn,raw,...)end
    end
    api.Integration.buyOriginalKey=api.Pr.buyOriginalKey
    api.Integration.resourceState=function(...)return invoke(state,...)end
    api.Integration.registerExistingPersistentVehicle=function(target,plate,netId)
        return invoke(send,'forge_garage:client:registerExistingPersistentVehicle',target,plate,netId)
    end
    function api.Open()
        if phase~='prepared'then return false,'vehicle_scope_not_repeatable'end
        local status=state('pr_carkeys')
        if not owner()or selected()~='pr_carkeys'or(status~='starting'and status~='started')or phase~='prepared'or not owner()then
            return false,'pr_carkeys_provider_not_ready'
        end
        phase='open';return true
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0}end
    return api
end
