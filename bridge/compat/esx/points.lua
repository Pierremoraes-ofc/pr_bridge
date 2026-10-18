-- Legacy ESX point/interaction contracts use PR's existing scheduler and keybind.
return function(E,C)
    local points,nextId={},0
    local function engine()
        if not C.state.spatial then C.state.spatial=PRCore.load('@pr_bridge/bridge/fivem/spatial/client') end
        return C.state.spatial.points
    end
    C.define(E,'CreatePointInternal',function(coords,distance,hidden,enter,leave,inside)
        assert(coords and coords.x and type(distance)=='number' and distance>0)
        for _,cb in pairs({enter=enter,leave=leave,inside=inside}) do assert(C.callable(cb),'Invalid point callback') end
        nextId=nextId+1;local id=nextId
        local point={coords=coords,distance=distance,hidden=hidden==true}
        function point:contains() return not self.hidden and self.currentDistance<=self.distance end
        point.onEnter=function() if not C.closed and enter then enter() end end
        point.onExit=function() if not C.closed and leave then leave() end end
        point.nearby=inside and function(self) if not C.closed then inside(self.currentDistance) end end or nil
        points[id]=engine().new(point);return id
    end)
    C.define(E,'RemovePointInternal',function(id)
        local point=points[id];if point then point.onExit=nil;point:remove();points[id]=nil end
    end)
    C.define(E,'HidePointInternal',function(id,hidden) if points[id] then points[id].hidden=hidden==true end end)
    C.define(E,'Point',function(properties)
        local object=C.copy(properties)
        object.handle=E.CreatePointInternal(properties.coords,properties.distance,properties.hidden,
            function() if object.enter then object:enter() end end,
            function() if object.leave then object:leave() end end,
            properties.inside and function(distance) object:inside(distance) end or nil)
        function object:delete() E.RemovePointInternal(self.handle) end
        function object:toggle(hidden) if hidden==nil then hidden=not self.hidden end
            self.hidden=hidden;E.HidePointInternal(self.handle,hidden)
        end
        return object
    end)
    local interactions=C.state.interactions or {};C.state.interactions=interactions
    local function dispatch()
        for _,entry in pairs(interactions) do
            local ok,allowed=pcall(entry.condition)
            if ok and allowed then local success,reason=pcall(entry.onPress)
                if not success then print('[PR Bridge ESX interaction] '..tostring(reason)) end
            end
        end
    end
    C.define(E,'RegisterInteraction',function(name,onPress,condition)
        assert(type(name)=='string' and C.callable(onPress) and (not condition or C.callable(condition)))
        assert(not interactions[name] or interactions[name].owner==C.owner,'ESX interaction belongs to another resource')
        interactions[name]={owner=C.owner,onPress=onPress,condition=condition or function() return true end}
        if not C.state.interactKey then
            C.state.interactKey=C.bridge.addKeybind({name='esx_interact',description='ESX interaction',defaultKey='E',onPressed=dispatch})
            C.state.interactHandler=AddEventHandler('xLib:interact',dispatch)
        end
    end)
    C.define(E,'RemoveInteraction',function(name)
        if interactions[name] and interactions[name].owner==C.owner then interactions[name]=nil end
    end)
    C.define(E,'GetInteractKey',function()
        return C.state.interactKey and C.state.interactKey:getCurrentKey() or 'E'
    end)
    C.clearPoints=function()
        for _,point in pairs(points) do point.onExit=nil;point:remove() end;points={}
        for name,entry in pairs(interactions) do if entry.owner==C.owner then interactions[name]=nil end end
    end
end
