-- Bound only to the existing progress streaming provider;accepted requests may finish after Close.
return function(streaming,isCurrent)
    assert(type(streaming)=='table'and type(isCurrent)=='function','progress streaming lease required')
    local library={}
    for _,name in ipairs({'requestModel','releaseModel','requestAnimDict','releaseAnimDict'})do
        local fn=assert(streaming[name]);assert(type(fn)=='function','progress streaming function required')
        library[name]=function(...)
            assert(isCurrent()==true,'progress streaming scope closed')
            local out=table.pack(fn(...))
            assert(isCurrent()==true,'progress streaming scope closed after request')
            return table.unpack(out,1,out.n)
        end
    end
    return library
end
