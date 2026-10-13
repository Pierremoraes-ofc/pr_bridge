-- Class-shaped facade over the existing native DUI engine; no second renderer.
return function(api)
    local native=api.nativeDui or api.module('bridge/fivem/dui/client')
    local Dui=api.class('Dui')
    function Dui:constructor(data)
        local instance,reason=native.create(data)
        assert(instance,'DUI creation failed: '..tostring(reason))
        self.private.instance=instance
        for _,key in ipairs({'url','duiObject','duiHandle','runtimeTxd','txdObject','dictName','txtName'}) do self[key]=instance[key] end
    end
    function Dui:remove() return native.destroy(self.private.instance) end
    function Dui:setUrl(url)
        local ok,reason=native.setUrl(self.private.instance,url)
        if ok then self.url=self.private.instance.url end
        return ok,reason
    end
    for _,name in ipairs({'sendMessage','sendMouseMove','sendMouseDown','sendMouseUp','sendMouseWheel'}) do
        Dui[name]=function(self,...) return native[name](self.private.instance,...) end
    end
    api.dui=Dui
    return Dui
end
