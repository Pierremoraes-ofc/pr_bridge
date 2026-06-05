local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "wasabi_carlock" then return end

Debug('SUCCESS', Lang:t('Debug.VehicleKeyDetected', { vehiclekey = 'Wasabi CarLock' }))

local wasabi_carlock = exports.wasabi_carlock
local wasabi_scripts = exports.wasabi_scripts

function vehicle_key.HasKey(source, plate)
    return wasabi_carlock:HasKey(source, plate)
end

function vehicle_key.GiveKey(source, plate)
    return wasabi_carlock:GiveKey(source, plate)
end

function vehicle_key.RemoveKey(source, plate)
    return wasabi_carlock:RemoveKey(source, plate)
end

function vehicle_key.GetAllKeys(source)
    if wasabi_scripts then
        return wasabi_scripts:GetAllKeys(source)
    end
    return {}
end


return vehicle_key
