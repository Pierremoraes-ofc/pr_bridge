-- Private client runtime imports. Native ox cache and positional locale are not the passive PR cache/Locale class.
return function(ports)
    local owner,running=assert(ports.isCurrent),assert(ports.running)
    local raw,translate=assert(ports.nativeCache),assert(ports.locale)
    assert(type(raw)=='table'and type(translate)=='function','existing native cache and initialized locale required')
    local phase,entered,windows='prepared',0,0;local permits={};local main={}
    local api={OperationalReady=false}
    local function thread()return running()or main end
    local function allowed()
        local ok,value=pcall(owner)
        return ok and value==true and(phase=='prepared'or phase=='open'or(phase=='draining'and permits[thread()]~=nil))
    end
    local function invoke(fn,...)
        if not allowed()then error('runtime_imports_closed',0)end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    api.NativeCache=setmetatable({}, {__index=function(_,key)return invoke(function()return raw[key]end)end,
        __newindex=function()error('native_cache_view_read_only',0)end,__metatable=false})
    function api.Translate(...)return invoke(translate,...)end
    function api.Open()
        if phase~='prepared'then return false end
        local ok,value=pcall(owner);if not ok or value~=true then return false end
        phase='open';return true
    end
    function api.CloseIngress()if phase~='closed'then phase='draining'end;return true end
    function api.DuringCleanup(fn,...)
        local ok,value=pcall(owner);assert(phase=='draining'and ok and value==true,'runtime imports cleanup owner required')
        local key=thread();permits[key]=(permits[key]or 0)+1;windows=windows+1
        local result=table.pack(pcall(fn,...));windows=windows-1;permits[key]=permits[key]-1;if permits[key]==0 then permits[key]=nil end
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,cleanupWindows=windows,complete=phase=='closed'and entered==0 and windows==0,PhysicalRemoval=false}end
    return api
end
