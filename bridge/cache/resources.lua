-- Producers explicitly publish values. Getters never query producer exports.
return function(cache)
    local function key(resource,domain)
        assert(type(resource)=='string' and resource:match('^[%w_.%-]+$') and #resource<=96,'invalid resource cache owner')
        assert(type(domain)=='string' and domain~='' and #domain<=128,'invalid resource cache domain')
        return 'resource:'..resource..':'..domain
    end
    local function copy(value,seen)
        if type(value)~='table' then return value end
        seen=seen or {}
        if seen[value] then return seen[value] end
        local result={};seen[value]=result
        for field,item in pairs(value) do result[field]=copy(item,seen) end
        return result
    end
    function cache.SetResourceState(first,second,third,fourth)
        local resource,domain,data
        if first==cache then resource,domain,data=second,third,fourth
        else resource,domain,data=first,second,third end
        assert(data==nil or type(data)=='table','resource cache data must be a table or nil')
        return cache.set(key(resource,domain),copy(data))
    end
    function cache.GetResourceState(first,second,third)
        local resource,domain
        if first==cache then resource,domain=second,third else resource,domain=first,second end
        if type(resource)~='string' or type(domain)~='string' then return nil end
        return copy(cache.get(key(resource,domain)))
    end
    function cache.OnResourceState(first,second,third,fourth)
        local resource,domain,callback
        if first==cache then resource,domain,callback=second,third,fourth
        else resource,domain,callback=first,second,third end
        assert(type(callback)=='function','invalid resource cache subscription')
        return cache.onChange(key(resource,domain),callback)
    end
end
