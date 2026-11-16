-- Inactive167 candidate:keybinds from the installed PR module;remaining boot inputs explicit.
return function(raw,options)
    assert(GetCurrentResourceName()=='forge-core','native profile must execute in Forge')
    assert(type(options)=='table'and type(options.isCurrent)=='function','explicit native profile options required')
    assert(PRCore.forgeRawEntry==raw and PRCore.forgeOwnedCallbacks==raw.RPC and raw.Progress().phase=='prepared','prepared local raw125 required')
    assert(PRCore.forgeNativeProfileEntry==nil,'native profile entry already owned')
    local api={OperationalReady=false};local phase='allocated';local seed,profile,platform,utilities;PRCore.forgeNativeProfileEntry=api
    local function current()return phase~='closed'and PRCore.forgeNativeProfileEntry==api and PRCore.forgeRawEntry==raw and options.isCurrent()==true end
    local function factory(path)
        local source=assert(LoadResourceFile('forge-core',path),'missing native profile factory:'..path)
        return assert(load(source,'@@forge-core/'..path,'t',_ENV))()
    end
    local native={GetCurrentResourceName=GetCurrentResourceName,IsDuplicityVersion=IsDuplicityVersion,
        LoadResourceFile=LoadResourceFile,SaveResourceFile=SaveResourceFile,Wait=Wait,CreateThread=CreateThread,SetTimeout=SetTimeout,
        GetGameTimer=GetGameTimer,GetConvar=GetConvar,GetConvarInt=GetConvarInt,GetResourceState=GetResourceState,
        GetVehicleNumberPlateText=GetVehicleNumberPlateText,SetVehicleDoorsLocked=SetVehicleDoorsLocked,vec4=vec4,vec3=vec3,joaat=joaat}
    local side=IsDuplicityVersion()and'server'or'client'
    local names=side=='server'and{'GetInvokingResource','GetPlayerName','GetPlayerIdentifierByType','GetPlayerIdentifiers','DropPlayer','TriggerClientEvent','TriggerEvent','GetPlayerPed','SetPedArmour','Player','DoesEntityExist','GetEntityCoords','GetEntityHeading'}or{'GetGameTimer','GetCurrentResourceName','GetEntityCoords','GetEntityHeading','PlayerPedId','PlayerId','GetPlayerServerId','GetResourceState','joaat','Wait','CreateThread','SetTimeout','TriggerServerEvent','TriggerEvent','DoScreenFadeIn','DoScreenFadeOut','FreezeEntityPosition','SetEntityCoords','SetEntityHeading','RequestCollisionAtCoord','ShutdownLoadingScreen','ShutdownLoadingScreenNui'}
    for _,name in ipairs(names)do native[name]=assert(_ENV[name],'native140 missing:'..name)end
    local function closeSeed()
        local done=true
        if utilities and not utilities.Close()then done=false end
        if platform and not platform.Close()then done=false end
        if not done then return false end
        if seed and not seed.Close()then return false end
        phase='closed';if PRCore.forgeNativeProfileEntry==api then PRCore.forgeNativeProfileEntry=nil end;return true
    end
    function api.Stop()
        if phase=='closed'then return true end;phase='closing'
        if profile and not profile.Stop()then return false end;return closeSeed()
    end
    function api.Poll()
        if phase=='closed'then return true end
        if phase~='closing'then
            if profile and profile.Progress().phase=='closing'then return api.Stop()end
            return false,'entry_not_stopping'
        end
        if profile and not profile.Poll()then return false end;return closeSeed()
    end
    function api.Prepare(...)
        if phase~='allocated'or not current()then return false,'entry_prepare_unavailable'end
        phase='preparing';local args=table.pack(...)
        local ok,result,reason=pcall(function()
            seed=factory('kernel/entry/native_seed.lua')({prCore=PRCore,rpc=raw.RPC,native=native,json=json,
                public=assert(options.public),nativeCache=assert(options.nativeCache),events=assert(options.events),
                inventoryBridgeProbe=assert(options.inventoryBridgeProbe),environment=_ENV,compile=load,
                createRegistry=factory('kernel/entry/native_factory_registry.lua'),isCurrent=current,running=coroutine.running,
                getSource=function()return source end,loadPR=function(path,environment)return PRCore.load(path,environment or _ENV)end})
            api.Seed=seed;assert(seed.Prepare(),'native seed preparation refused')
            local bootstrap={};for k,v in pairs(assert(options.bootstrap))do bootstrap[k]=v end
            -- Capture only actual engine functions;unknown/optional slots remain explicit in the input.
            local schema=seed.Registry.Require('kernel.entry.'..side..'_engine_schema')()
            for _,target in pairs(schema)do
                if target:sub(1,1)~='$'and native[target]==nil then
                    local ok,fn=pcall(function()return _ENV[target]end)
                    if ok and type(fn)=='function'then native[target]=fn end
                end
            end
            local loadPR=function(path,environment)return PRCore.load(path,environment or _ENV)end
            platform=loadPR('@pr_bridge/bridge/delivery/forge_native_platform')({execution=seed.Execution,events=options.events,side=side,isCurrent=current,time=os.time,locale=assert(options.locale)})
            api.Platform=platform;local bind=seed.Registry.Require('kernel.entry.native_graph_ports')
            if side=='client'then
                utilities=loadPR('@pr_bridge/bridge/delivery/forge_native_utilities')({environment=_ENV,isCurrent=current,
                    load=function(path,environment)
                        if path=='@pr_bridge/bridge/utils/tables'then path='@pr_bridge/bridge/delivery/forge_native_tables'end
                        return loadPR(path,environment)
                    end});api.Utilities=utilities
                bootstrap.context=bind.Client(bootstrap.context,platform,utilities)
            else bootstrap.context=bind.Server(bootstrap.context,platform)end
            if side=='client'then
                local progressEnv=loadPR('@pr_bridge/bridge/delivery/forge_progress_environment')
                for _,name in ipairs(progressEnv.Names())do if native[name]==nil then native[name]=assert(_ENV[name],'progress155 native missing:'..name)end end
            end
            if side=='client'then
                for _,name in ipairs({'RegisterKeyMapping','IsPauseMenuActive','GetControlInstructionalButton','joaat'})do if native[name]==nil then native[name]=assert(_ENV[name],'keybind167 native missing:'..name)end end
            end
            local factory='kernel.entry.keybind_native_profile'
            profile=seed.Registry.Require(factory)(assert(options.base),{side=side,
                seed=seed,services=raw.Services,prCore=PRCore,external=exports,public=options.public,environment=_ENV,
                bootstrap=bootstrap,barrier=options.barrier,random=math.random,running=coroutine.running,
                progress=side=='client'and{localPlayer=assert(LocalPlayer,'existing LocalPlayer required'),settings=assert(options.public.settings,'existing PR settings required')}or nil,
                nativeAdjuncts={time=os.time,date=os.date,locale=assert(options.locale),newPromise=promise.new,awaitPromise=Citizen.Await},
                domainConfigurationPorts={getConvar=seed.Execution.Native.GetConvar,
                    vec3=seed.Execution.Bind({'vec3'}).vec3,locale=assert(options.domainLocale,'explicit Forge domain locale required')},
                onError=assert(options.onError),loadPR=function(path,environment)return PRCore.load(path,environment or _ENV)end})
            api.Profile=profile;return profile.Prepare(table.unpack(args,1,args.n))
        end)
        if not ok or result~=true or phase~='preparing'or not current()then api.Stop();return false,ok and reason or result end
        phase='prepared';return true
    end
    function api.Install()
        if phase~='prepared'or not current()then return false,'entry_install_unavailable'end
        local ok,reason=profile.Install();if not ok then api.Stop();return false,reason end;phase='installed';return true
    end
    function api.Start()
        if phase~='installed'or not current()then return false,'entry_start_unavailable'end
        local ok,reason=profile.Start();if not ok then api.Stop();return false,reason end;phase='running';return true
    end
    function api.Progress()return{phase=phase,profile=profile and profile.Progress(),seed=seed and seed.Progress(),complete=phase=='closed',operationalReady=false}end
    return api
end
