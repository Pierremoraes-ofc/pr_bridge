-- Bind the installed config boundaries to explicit natives and PR providers;no config defaults duplicated.
return function(ports)
    local execution,external,loadModule=assert(ports.execution),assert(ports.external),assert(ports.load)
    local side=assert(ports.side);assert(side=='server'or side=='client','configuration side required')
    local owner=assert(ports.isCurrent);local closed=false;local api={OperationalReady=false}
    local function current()local ok,value=pcall(owner);return not closed and ok and value==true and execution.IsCurrent()end
    local function guard(fn)return function(...)assert(current(),'native configuration closed');return fn(...)end end
    local names={'GetResourceState','GetVehicleNumberPlateText','vec4'}
    names[#names+1]=side=='server'and'SetVehicleDoorsLocked'or'joaat'
    local n=execution.Bind(names)
    local function borrowed(resource,name)
        return guard(function(_,...)local proxy=assert(external[resource],'configuration provider unavailable:'..resource)
            return assert(proxy[name],'configuration export unavailable:'..name)(proxy,...)
        end)
    end
    local function factory(module)
        return function(input)
            assert(current(),'native configuration closed');local p={};for k,v in pairs(input)do p[k]=v end
            local prior=assert(p.isCurrent);p.isCurrent=function()return current()and prior()==true end
            return module(p)
        end
    end
    local common={getResourceState=guard(n.GetResourceState),getVehicleNumberPlateText=guard(n.GetVehicleNumberPlateText)}
    if side=='server'then
        local strings=loadModule('@pr_bridge/bridge/utils/strings')
        common.setVehicleDoorsLocked=guard(n.SetVehicleDoorsLocked);common.random=guard(assert(ports.random))
        common.randomString=guard(assert(strings.random));common.pr=assert(ports.keys).Pr
        common.qbxVehiclekeys={GiveKeys=borrowed('qbx_vehiclekeys','GiveKeys'),SetLockState=borrowed('qbx_vehiclekeys','SetLockState')}
        api.Shared={vec4=guard(n.vec4)}
        api.CreateConfiguration=factory(loadModule('@pr_bridge/bridge/vehicle_key/forge_configuration'))
    else
        common.vec4,common.joaat=guard(n.vec4),guard(n.joaat)
        common.prKeys={HaveKey=borrowed('pr_carkeys','HaveKey')};common.qbxKeys={HasKeys=borrowed('qbx_vehiclekeys','HasKeys')}
        common.waitFor=guard(loadModule('@pr_bridge/bridge/utils/waitFor'));common.running=assert(ports.running)
        api.CreateConfiguration=factory(loadModule('@pr_bridge/bridge/delivery/forge_client_configuration'))
    end
    common.isCurrent=current;api.Configuration=common
    function api.Close()closed=true;return true end
    function api.IsCurrent()return current()end
    return api
end
