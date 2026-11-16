--[[
    Private dependency-injected port of ox_lib/imports/locale/shared.lua.
    LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>
    Copyright (c) 2025 Linden <https://github.com/thelindat>
    No ambient exports/events/IO; initialization and binding are explicit.
]]
return function(ports)
    local resource,path=assert(ports.resource),assert(ports.path)
    local read,decode,warn=assert(ports.readFile),assert(ports.decode),assert(ports.warn)
    local merge,wipe,getKey,pull=assert(ports.merge),assert(ports.wipe),assert(ports.getLocaleKey),assert(ports.pullLocale)
    local owner,running=assert(ports.isCurrent),assert(ports.running)
    local dict,permits,main={},{},{};local phase,entered,windows='prepared',0,0
    local api={OperationalReady=false,Initialized=false}
    local function thread()return running()or main end
    local function invoke(fn,...)
        local ok,value=pcall(owner)
        if not ok or value~=true or not(phase=='prepared'or phase=='open'or(phase=='draining'and permits[thread()]))then error('locale_scope_closed',0)end
        entered=entered+1;local result=table.pack(pcall(fn,...));entered=entered-1
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    local function flatten(source,target,prefix)
        for key,value in pairs(source)do
            local fullKey=prefix and(prefix..'.'..key)or key
            if type(value)=='table'then flatten(value,target,fullKey)else target[fullKey]=value end
        end;return target
    end
    local function loadLocale(key)
        local data=read(resource,('%s/%s.json'):format(path,key))
        if not data then warn(("could not load '%s/%s.json'"):format(path,key))end
        return decode(data)or{}
    end
    function api.Initialize(key)return invoke(function()
        local lang=key or getKey();local locales=loadLocale('en')
        if lang~='en'then merge(locales,loadLocale(lang))end
        wipe(dict);local flat=flatten(locales,{})
        for k,v in pairs(flat)do
            if type(v)=='string'then for var in v:gmatch('${[%w%s%p]-}')do
                local value=flat[var:sub(3,-2)]
                if value then value=value:gsub('%%','%%%%');v=v:gsub(var,value)end
            end end;dict[k]=v
        end
        api.Initialized=true
    end)end
    function api.Translate(str,...)return invoke(function(...)
        local value=dict[str];if value then if ... then return value and value:format(...)end;return value end;return str
    end,...)end
    function api.GetLocales()return invoke(function()return dict end)end
    function api.GetLocale(key)return invoke(function()return dict[key]end)end
    function api.PullLocale(other,key)return invoke(function()
        local value=dict[key];if value then warn(("overwriting existing locale '%s' (%s)"):format(key,value))end
        value=pull(other,key);dict[key]=value
        if not value then warn(("no locale exists with key '%s' in resource '%s'"):format(key,other))end;return value
    end)end
    function api.Open()
        local ok,value=pcall(owner);if phase~='prepared'or not ok or value~=true then return false end;phase='open';return true
    end
    function api.CloseIngress()if phase~='closed'then phase='draining'end;return true end
    function api.DuringCleanup(fn,...)
        local ok,value=pcall(owner);assert(phase=='draining'and ok and value==true,'locale cleanup owner required')
        local key=thread();permits[key]=(permits[key]or 0)+1;windows=windows+1
        local result=table.pack(pcall(fn,...));windows=windows-1;permits[key]=permits[key]-1;if permits[key]==0 then permits[key]=nil end
        if not result[1]then error(result[2],0)end;return table.unpack(result,2,result.n)
    end
    function api.Close()phase='closed';return true end
    function api.Progress()return{phase=phase,pending=entered,cleanupWindows=windows,initialized=api.Initialized,complete=phase=='closed'and entered==0 and windows==0}end
    return api
end
