-- Canonical entity facade; subclasses share one state/class/streaming engine.
return function(api)
local cache=api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@class Ped : GameEntity
---@field private new PedConstructor
api.ped = api.class('Ped', api.gameEntity)
api.ped.type = api.ped.__name

---@class PedConstructor
---@overload fun(self: Ped, handle: number): Ped
function api.ped:constructor(handle)
    self:super()

    if handle > 0 then
        self:setHandle(handle)
    end
end

function api.ped:__index(index)
    if index == 'handle' then
        return self.private.handle
    end

    return api.ped[index]
end

function api.ped:getArmour()
    return GetPedArmour(self.handle)
end

---@param amount number
function api.ped:setArmour(amount)
    SetPedArmour(self.handle, amount)
end
if api.context == 'client' then
    function api.ped.create(model,x,y,z,heading,isNetworked,bScriptHostPed)
        local handle,reason=api.streaming.createPed(model,vec3(x,y,z),heading or 0,{pedType=0,networked=isNetworked==true,scriptHostPed=bScriptHostPed==true})
        assert(handle and handle~=0, 'Entity creation failed: '..tostring(reason))
        return api.ped:new(handle)
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
---@return Ped
---@see CreatePed
---`server`
function api.ped.create(model, x, y, z, heading)
    local handle = CreatePed(0, model, x, y, z, heading or 0, true, true)

    return api.ped:new(handle)
end


end
return api.ped
end

