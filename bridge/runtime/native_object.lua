-- Internal deferred reference. Every accessed value comes from the real native object.
return function(getter)
    assert(type(getter)=='function','native object getter required')
    local function target()return assert(getter(),'native provider returned no object')end
    return setmetatable({},{
        __index=function(_,key)return target()[key]end,
        __newindex=function(_,key,value)target()[key]=value end,
        __pairs=function()return pairs(target())end,
        __len=function()return #target()end,
        __call=function(_,...)return target()(...)end,
    })
end
