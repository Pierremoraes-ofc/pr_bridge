-- Private server configuration ports. Alternate vehicle-key exports stay outside the framework.
return function(ports)
    local pr,raw=assert(ports.pr),assert(ports.qbxVehiclekeys)
    local current=assert(ports.isCurrent)
    local phase,entered='prepared',0
    local api={OperationalReady=false,Ports={vehicleKeys={pr={},qbx={}}}}
    local function owner()local ok,value=pcall(current);return ok and value==true end
    local function invoke(fn,...)
        if phase~='open'or not owner()then return nil,'configuration_scope_closed'end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    for _,name in ipairs({'getResourceState','getVehicleNumberPlateText','setVehicleDoorsLocked','random','randomString'})do
        local fn=assert(ports[name],'explicit PR/platform configuration port required: '..name)
        assert(type(fn)=='function','configuration function required: '..name)
        api.Ports[name]=function(...)return invoke(fn,...)end
    end
    for _,name in ipairs({'buyOriginalKey','createTempKeyItem','giveTempKey','setLockState'})do
        local fn=assert(pr[name],'PR65 configuration key operation required: '..name)
        api.Ports.vehicleKeys.pr[name]=function(...)return invoke(fn,...)end
    end
    for name,export in pairs({giveKeys='GiveKeys',setLockState='SetLockState'})do
        -- Optional resource: resolve lazily only when the unchanged config06 selects it.
        api.Ports.vehicleKeys.qbx[name]=function(...)
            return invoke(function(...)return assert(raw[export],'alternate vehicle-key export unavailable: '..export)(raw,...)end,...)
        end
    end
    function api.Open()
        if phase~='prepared'or not owner()then return false,'configuration_scope_not_prepared'end
        phase='open';return true
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,complete=phase=='closed'and entered==0}end
    return api
end
