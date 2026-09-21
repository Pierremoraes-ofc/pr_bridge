local fuel = {}
function fuel.GetResourceName() return "standalone" end
function fuel.GetFuel(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return GetVehicleFuelLevel(vehicle)
end
function fuel.SetFuel(vehicle, amount)
    if not DoesEntityExist(vehicle) then return false end
    SetVehicleFuelLevel(vehicle, math.max(0.0, math.min(100.0, tonumber(amount) or 0.0)) + 0.0)
    return true
end
return fuel
