-- Shared wait primitive. Native callers may return false on timeout; adapters
-- can request an exception without implementing another polling loop.
return function(callback,message,timeout,raiseOnTimeout)
    assert(type(callback)=='function','waitFor callback must be a function')
    local limit
    if timeout~=false then limit=tonumber(timeout) or 1000 end
    local started=GetGameTimer()
    repeat
        local value=callback()
        if value~=nil then return value end
        if limit and GetGameTimer()-started>=limit then
            if raiseOnTimeout or message then error(message or 'failed to resolve callback',2) end
            return false
        end
        Wait(0)
    until false
end
