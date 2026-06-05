local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "qb-vehiclekeys" then return end

---Gives the player (self) the keys of the specified vehicle.
---@param vehicle number The vehicle entity handle.
---@param plate? string The plate of the vehicle.
function vehicle_key.GiveKeys(vehicle, plate)
    if not DoesEntityExist(vehicle) then return end
    
    if not plate then
        plate = GetVehicleNumberPlateText(vehicle)
    end

    TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
end

---Removes the keys of the specified vehicle from the player (self).
---@param vehicle number The vehicle entity handle.
---@param plate? string The plate of the vehicle.
function vehicle_key.RemoveKeys(vehicle, plate)
    if not DoesEntityExist(vehicle) then return end
    
    if not plate then
        plate = GetVehicleNumberPlateText(vehicle)
    end

    TriggerEvent("qb-vehiclekeys:client:RemoveKeys", plate)
end

function vehicle_key.GetResourceName()
    return "qb-vehiclekeys"
end

return vehicle_key
