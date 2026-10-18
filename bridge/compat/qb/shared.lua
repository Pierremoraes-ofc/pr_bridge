return function(Q,C,catalog)
    Q.Functions={};Q.Shared={};Q.PlayerData={};Q.Players={};Q.ServerCallbacks={};Q.ClientCallbacks={}
    Q.Config=C.copy(Config.compatQBConfig or {})
    local function define(name,fn) C.define(Q.Shared,name,fn);C.supported[name]=nil;C.supported['Shared.'..name]='adapted' end
    define('IsFunction',C.callable)
    define('Trim',function(value) if value~=nil then return tostring(value):match('^%s*(.-)%s*$') end end)
    define('FirstToUpper',function(value) return value and value:gsub('^%l',string.upper) end)
    define('Round',function(value,decimals) local scale=10^(decimals or 0);return math.floor(value*scale+0.5)/scale end)
    local function random(length,alphabet)
        assert(type(length)=='number' and length>=0 and length%1==0 and length<=4096,'Invalid random string length')
        local value={};for i=1,length do local index=math.random(1,#alphabet);value[i]=alphabet:sub(index,index) end;return table.concat(value)
    end
    define('RandomStr',function(length) return random(length,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz') end)
    define('RandomInt',function(length) return random(length,'0123456789') end)
    define('SplitStr',function(text,delimiter)
        assert(type(delimiter)=='string' and delimiter~='','Invalid delimiter')
        local result,from={},1
        while true do local first,last=text:find(delimiter,from);if not first then break end
            assert(last>=from,'Delimiter cannot match an empty string');result[#result+1]=text:sub(from,first-1);from=last+1
        end
        result[#result+1]=text:sub(from);return result
    end)
    for name in pairs(catalog.shared) do if not Q.Shared[name] then Q.Shared[name]=function(...) return C.missing('Shared.'..name,...) end end end
    Q.Debug=function(value) C.target();if Config.Debug then print('[PR Bridge QB] '..tostring(value)) end end
    Q.ShowError=function(resource,message) C.target();print(('[PR Bridge QB][%s] %s'):format(resource,tostring(message))) end
    Q.ShowSuccess=Q.ShowError
    function C.refreshShared()
        local api=C.api()
        for _,name in ipairs({'Items','Jobs','Gangs','VehicleHashes','Vehicles'}) do
            local ok,value
            if C.context=='client' and name~='Items' then
                value=C.state.catalogs[name]
                if value==nil then
                    value=C.state.engine.request('__pr_qb:shared',nil,false,10000,name)
                    assert(type(value)=='table','[PR Bridge QB] shared catalog unavailable: '..name)
                    C.state.catalogs[name]=value
                end
                ok=true
            else ok,value=pcall(api.GetShared,name) end
            if ok and type(value)=='table' then
                local existing=Q.Shared[name] or {};for key in pairs(existing) do existing[key]=nil end
                for key,item in pairs(value) do existing[key]=item end;Q.Shared[name]=existing
            end
        end
    end
    Q.GetShared=function(namespace,item)
        C.target();C.refreshShared()
        local value=Q.Shared[namespace]
        if value==nil then value=C.api().GetShared(namespace) end
        if item~=nil then return value and value[item] end
        return value
    end
end
