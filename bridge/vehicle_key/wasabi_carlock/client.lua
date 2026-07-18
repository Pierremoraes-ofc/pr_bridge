local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "wasabi_carlock" then return end

local wasabi_carlock = exports.wasabi_carlock

function vehicle_key.ToggleLock()
    wasabi_carlock:ToggleLock()
end

function vehicle_key.HasKey(plate)
    return wasabi_carlock:HasKey(plate)
end

function vehicle_key.GiveKey(plate)
    return wasabi_carlock:GiveKey(plate)
end

function vehicle_key.RemoveKey(plate)
    return wasabi_carlock:RemoveKey(plate)
end

function vehicle_key.GiveKeyMenu(plate)
    wasabi_carlock:GiveKeyMenu(plate)
end

function vehicle_key.GetAllKeys(target)
    return wasabi_carlock:GetAllKeys(target)
end

function vehicle_key.ManageKeysMenu()
    wasabi_carlock:ManageKeysMenu()
end

-- Bridge standard mappings
function vehicle_key.GiveKeys(vehicle, plate)
    if not plate and DoesEntityExist(vehicle) then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    if plate then
        wasabi_carlock:GiveKey(plate)
    end
end

function vehicle_key.RemoveKeys(vehicle, plate)
    if not plate and DoesEntityExist(vehicle) then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    if plate then
        wasabi_carlock:RemoveKey(plate)
    end
end

function vehicle_key.GetResourceName()
    return "wasabi_carlock"
end

return vehicle_key
