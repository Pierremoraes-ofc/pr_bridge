-- Canonical entity facade; subclasses share one state/class/streaming engine.
return function(api)
local cache=api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@class Prop : GameEntity
---@field private new ObjectConstructor
api.prop = api.class('Prop', api.gameEntity)
api.prop.type = api.prop.__name

---@class ObjectConstructor
---@overload fun(self: Prop, handle: number): Prop
function api.prop:constructor(handle)
    self:super()
    self:setHandle(handle)
end

function api.prop:__index(index)
    if index == 'handle' then
        return self.private.handle
    end

    return api.prop[index]
end

function api.prop:setOnGround()
    if api.context == 'client' then
        return PlaceObjectOnGroundProperly(self.handle)
    end

    return self:setr('pr_bridge:entity:setOnGround', true)
end
if api.context == 'client' then
    function api.prop.create(model,x,y,z,heading,isNetworked,netMissionEntity,dynamic)
        local handle,reason=api.streaming.createObject(model,vec3(x,y,z),{noOffset=false,networked=isNetworked==true,missionEntity=netMissionEntity==true,doorFlag=dynamic==true,heading=heading})
        assert(handle and handle~=0, 'Entity creation failed: '..tostring(reason))
        return api.prop:new(handle)
    end
else
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@diagnostic disable: duplicate-set-field

---@private
---@param model string | number
---@param x number
---@param y number
---@param z number
---@param heading? number
---@param dynamic? boolean
---@return Prop
---@see CreateObjectNoOffset
---`server`
function api.prop.create(model, x, y, z, heading, dynamic)
    local handle = CreateObjectNoOffset(model, x, y, z, true, true, dynamic or false)
    local prop = api.prop:new(handle)

    if heading then prop:setHeading(heading) end

    return prop
end


end
return api.prop
end

