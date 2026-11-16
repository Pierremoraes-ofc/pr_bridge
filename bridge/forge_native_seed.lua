-- Physical seed candidate;execute only in the Forge resource after raw125.Prepare.
return function(raw,options)
    assert(GetCurrentResourceName()=='forge-core','native seed entry belongs to Forge')
    assert(PRCore.forgeRawEntry==raw and PRCore.forgeOwnedCallbacks==raw.RPC and raw.Progress().phase=='prepared','prepared local raw PR entry required')
    assert(type(options)=='table'and type(options.isCurrent)=='function','explicit native seed options required')
    local function factory(path)
        local text=assert(LoadResourceFile('forge-core',path),'missing native seed factory:'..path)
        return assert(load(text,'@@forge-core/'..path,'t',_ENV))()
    end
    local native={GetCurrentResourceName=GetCurrentResourceName,IsDuplicityVersion=IsDuplicityVersion,
        LoadResourceFile=LoadResourceFile,SaveResourceFile=SaveResourceFile,Wait=Wait,CreateThread=CreateThread,SetTimeout=SetTimeout,
        GetGameTimer=GetGameTimer,GetConvar=GetConvar,GetConvarInt=GetConvarInt}
    return factory('kernel/entry/native_seed.lua')({prCore=PRCore,rpc=raw.RPC,native=native,json=json,
        public=assert(options.public),nativeCache=assert(options.nativeCache),events=assert(options.events),
        inventoryBridgeProbe=assert(options.inventoryBridgeProbe),environment=_ENV,compile=load,createRegistry=factory('kernel/entry/native_factory_registry.lua'),
        isCurrent=function()return PRCore.forgeRawEntry==raw and options.isCurrent()==true end,running=coroutine.running,getSource=function()return source end,
        loadPR=function(path,environment)return PRCore.load(path,environment or _ENV)end})
end
