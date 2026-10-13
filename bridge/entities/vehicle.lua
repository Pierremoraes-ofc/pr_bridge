-- Canonical entity facade; subclasses share one state/class/streaming engine.
return function(api)
local cache=api.cache
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@alias VehicleType 'automobile' | 'bike' | 'boat' | 'heli' | 'plane' | 'submarine' | 'trailer' | 'train'

---@class Vehicle : GameEntity
---@field private new VehicleConstructor
api.vehicle = api.class('Vehicle', api.gameEntity)
api.vehicle.type = api.vehicle.__name

---@class VehicleConstructor
---@overload fun(self: Vehicle, handle: number): Vehicle
function api.vehicle:constructor(handle)
    self:super()
    self:setHandle(handle)
end

function api.vehicle:__index(index)
    if index == 'handle' then
        return self.private.handle
    end

    return api.vehicle[index]
end

---@return VehicleType
function api.vehicle:getType()
    return GetVehicleType(self.handle)
end

function api.vehicle:getPlate()
    return GetVehicleNumberPlateText(self.handle)
end

---@param plate string
function api.vehicle:setPlate(plate)
    SetVehicleNumberPlateText(self.handle, plate)
end

function api.vehicle:setOnGround()
    if api.context == 'client' then
        return SetVehicleOnGroundProperly(self.handle)
    end

    self:setr('pr_bridge:entity:setOnGround', true)
end
if api.context == 'client' then
    function api.vehicle.create(model,x,y,z,heading,isNetworked,netMissionEntity)
        local handle,reason=api.streaming.createVehicle(model,vec3(x,y,z),heading or 0,{networked=isNetworked==true,missionEntity=netMissionEntity==true})
        assert(handle and handle~=0, 'Entity creation failed: '..tostring(reason))
        return api.vehicle:new(handle)
    end
else
---@diagnostic disable: duplicate-set-field

---@private
---@param model string | number
---@param type VehicleType
---@param x number
---@param y number
---@param z number
---@param heading? number
---@return Vehicle
---@see CreateVehicleServerSetter (FiveM)
---@see CreateVehicle (RedM)
---`server`
function api.vehicle.create(model, type, x, y, z, heading)
    heading = heading or 0
    local handle = CreateVehicleServerSetter
        and CreateVehicleServerSetter(model, type, x, y, z, heading)
        or CreateVehicle(model, x, y, z, heading, true, true)

    return api.vehicle:new(handle)
end


end
return api.vehicle
end

