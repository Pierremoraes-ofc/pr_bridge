-- Private client boundary. Accepted provider work is not preempted or rolled back.
return function(ports)
    local current,running=assert(ports.isCurrent),assert(ports.running)
    local phase,entered,windows='prepared',0,0;local permits={};local main={}
    local api={OperationalReady=false,Audio={},Streaming={},Native={}}
    local function thread()return running()or main end
    local function owner()local ok,v=pcall(current);return ok and v==true end
    local function invoke(fn,cleanup,...)
        if not owner()or not(phase=='open'or(phase=='draining'and cleanup and permits[thread()]))then error('client_media_closed',0)end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local sound=assert(ports.nativeSound)
    for _,name in ipairs({'PlayLocalNativeSound','PlayLocalNativeSoundFromEntity','PlayLocalNativeSoundFromCoords',
        'PlaySharedNativeSoundFromEntity','PlaySharedNativeSoundFromCoords'})do
        local fn=assert(sound[name],'explicit client audio export required: '..name)
        api.Audio[name]=function(...)return invoke(fn,false,sound,...)end
    end
    local streaming=assert(ports.streaming)
    for _,name in ipairs({'requestModel','requestAnimDict','createObject','createPed','createVehicle','deleteEntity','releaseModel','releaseAnimDict'})do
        local fn=assert(streaming[name],'installed PR streaming delegate required: '..name)
        local cleanup=name=='deleteEntity'or name=='releaseModel'or name=='releaseAnimDict'
        api.Streaming[name]=function(...)return invoke(fn,cleanup,...)end
    end
    local native=assert(ports.nativeAudio)
    for _,name in ipairs({'GetResourceState','RequestScriptAudioBank','GetSoundId','PlaySoundFromCoord','PlaySoundFromEntity','PlaySoundFrontend','ReleaseSoundId'})do
        local fn=assert(native[name],'explicit client audio native required: '..name)
        api.Native[name]=function(...)return invoke(fn,name=='ReleaseSoundId',...)end
    end
    function api.Open()if phase~='prepared'or not owner()then return false end;phase='open';return true end
    function api.CloseIngress()if phase~='closed'then phase='draining'end;return true end
    function api.DuringCleanup(fn,...)
        assert(phase=='draining'and owner(),'client media cleanup owner required')
        local key=thread();permits[key]=(permits[key]or 0)+1;windows=windows+1
        local result=table.pack(pcall(fn,...));windows=windows-1;permits[key]=permits[key]-1;if permits[key]==0 then permits[key]=nil end
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,cleanupWindows=windows,
        complete=phase=='closed'and entered==0 and windows==0,DeliveryAcknowledged=false}end
    return api
end
