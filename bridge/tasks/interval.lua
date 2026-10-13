local api, intervals, sequence = {}, {}, 0
function api.set(callback, delay, ...)
    delay = delay or 0
    assert(type(delay)=='number', 'Interval must be a number')
    if type(callback)=='number' and intervals[callback] then intervals[callback].delay=delay; return end
    assert(type(callback)=='function', 'Interval callback must be a function')
    sequence=sequence+1
    local id,args,entry=sequence,table.pack(...),{delay=delay}
    intervals[id]=entry
    CreateThread(function()
        while entry.delay>=0 do
            Wait(entry.delay)
            if entry.delay<0 then break end
            callback(table.unpack(args,1,args.n))
        end
        intervals[id]=nil
    end)
    return id
end
function api.clear(id)
    assert(type(id)=='number' and intervals[id], 'No interval exists with id '..tostring(id))
    intervals[id].delay=-1
end
return api
