-- One control-set implementation. Native users can choose reference counts
-- when independent actions may disable the same control concurrently.
return function(counted)
    local keys, api = {}, {}
    function api:Add(...)
        local controls = type(...) == 'table' and ... or {...}
        for _, key in ipairs(controls) do keys[key] = counted and (keys[key] or 0) + 1 or 1 end
    end
    function api:Remove(...)
        local controls = type(...) == 'table' and ... or {...}
        for _, key in ipairs(controls) do
            if counted and (keys[key] or 0) > 1 then keys[key] = keys[key] - 1
            else keys[key] = nil end
        end
    end
    function api:Clear(...)
        local controls = type(...) == 'table' and ... or {...}
        for _, key in ipairs(controls) do keys[key] = nil end
    end
    return setmetatable(api, {
        __index=keys, __newindex=keys,
        __call=function() for key in pairs(keys) do DisableControlAction(0,key,true) end end,
    })
end
