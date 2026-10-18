return function(E, C)
    local define = function(name, fn) C.define(E, name, fn) end
    local timeouts, sequence = {}, 0
    define('SetTimeout', function(delay, cb)
        assert(C.callable(cb), 'Expected timeout callback'); sequence=sequence+1; local id=sequence
        timeouts[id]=true; SetTimeout(delay, function() if not C.closed and timeouts[id] then timeouts[id]=nil; cb() end end); return id
    end)
    define('ClearTimeout', function(id) timeouts[id]=nil end)
    C.clearTimeouts=function() timeouts={} end
    define('Await', function(cb, message, timeout) return C.bridge.waitFor(cb, message, timeout) end)
    define('Round', function(n, decimals) return C.bridge.library.math.round(n, decimals) end)
    define('Math.Round', E.Round)
    define('Math.Trim', function(s) return s:match('^%s*(.-)%s*$') end)
    define('Math.GroupDigits', function(n) return C.bridge.library.math.groupdigits(n) end)
    define('Math.Random', function(a,b) return math.random(a or 1,b or 10) end)
    define('Math.GetHeadingFromCoords', function(a,b) return (math.deg(math.atan(a.y-b.y,a.x-b.x))+450)%360 end)
    define('GetRandomString', function(n) n=C.amount(n);return C.bridge.library.module('bridge/utils/strings').random(('Aa1'):rep(math.ceil(n/3)),n) end)
    define('DumpTable', function(value) return json.encode(value) end)
    define('ValidateType', function(value, ...)
        if select('#',...)==0 then return true end
        for i=1,select('#',...) do assert(type(select(i,...))=='string');if type(value)==select(i,...) then return true end end
        return false,'Unexpected ESX argument type: '..type(value)
    end)
    define('AssertType', function(...) local ok,reason=E.ValidateType(...);assert(ok,reason);return true end)
    define('IsFunctionReference', C.callable)
    define('IsValidLocaleString', function(s, digits) return type(s)=='string' and s:match(digits and '^[%a%d_]+$' or '^[%a_]+$') ~= nil end)
    define('GetConfig', function(key)
        local settings={CustomInventory=true,EnableDefaultInventory=false,EnableDebug=Config.Debug==true,
            Accounts={money={label='Cash'},bank={label='Bank'}},MaxWeight=0}
        if key then return C.copy(settings[key]) end; return settings
    end)
    define('Table.SizeOf', function(t) local n=0;for _ in pairs(t) do n=n+1 end;return n end)
    define('Table.Set', function(t) local r={};for _,v in pairs(t) do r[v]=true end;return r end)
    define('Table.IndexOf', function(t,v) for i=1,#t do if t[i]==v then return i end end;return -1 end)
    define('Table.LastIndexOf', function(t,v) for i=#t,1,-1 do if t[i]==v then return i end end;return -1 end)
    define('Table.Find', function(t,f) for i=1,#t do if f(t[i]) then return t[i] end end end)
    define('Table.FindIndex', function(t,f) for i=1,#t do if f(t[i]) then return i end end;return -1 end)
    define('Table.Filter', function(t,f) local r={};for k,v in pairs(t) do if f(v,k) then r[k]=v end end;return r end)
    define('Table.Map', function(t,f) local r={};for i=1,#t do r[i]=f(t[i],i) end;return r end)
    define('Table.Reverse', function(t) local r={};for i=#t,1,-1 do r[#r+1]=t[i] end;return r end)
    define('Table.Clone', C.copy)
    define('Table.Concat', function(a,b) local r=C.copy(a);for _,v in ipairs(b) do r[#r+1]=v end;return r end)
    define('Table.Join', function(t,separator) return table.concat(t,separator or ',') end)
    define('Table.TableContains', function(t,v) for _,item in pairs(t) do if item==v then return true end end;return false end)
    define('Table.Sort', function(t,f)
        local keys={};for k in pairs(t) do keys[#keys+1]=k end
        table.sort(keys,f and function(a,b) return f(t,a,b) end or nil)
        local i=0;return function() i=i+1;local k=keys[i];if k~=nil then return k,t[k] end end
    end)
    define('Table.ToArray', function(t) local r={};for _,v in pairs(t) do r[#r+1]=v end;return r end)
    define('Table.Wipe', function(t) for k in pairs(t) do t[k]=nil end end)
    PRCore.load('bridge.compat.esx.weapons')(E,C)
    return E
end
