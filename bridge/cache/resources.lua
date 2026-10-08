-- Read-only provider contract. It does not turn arbitrary cache keys into
-- networked globals: each provider owns its transport, authorization and data.
return function(cache)
    local function copy(value)
        if type(value)~='table' then return value end
        local result={};for key,item in pairs(value) do result[key]=copy(item) end;return result
    end
    function cache.GetResourceState(first,second,third)
        local resource,key=first==cache and second or first,first==cache and third or second
        if type(resource)~='string' or type(key)~='string' or GetResourceState(resource)~='started' then return nil end
        local ok,record=pcall(function() return exports[resource]:GetCachedState(key) end)
        if not ok or type(record)~='table' or type(record.data)~='table' then return nil end
        return copy(record.data)
    end
    function cache.OnResourceState(first,second,third,fourth)
        local resource,key,fn
        if first==cache then resource,key,fn=second,third,fourth else resource,key,fn=first,second,third end
        assert(type(resource)=='string' and type(key)=='string' and type(fn)=='function','Invalid resource cache subscription')
        local active=true
        local handler=AddEventHandler('pr_bridge:resourceState:changed',function(owner,domain,record)
            if active and owner==resource and domain==key then fn(record and copy(record.data) or nil) end
        end)
        return function() active=false;RemoveEventHandler(handler) end
    end
end
