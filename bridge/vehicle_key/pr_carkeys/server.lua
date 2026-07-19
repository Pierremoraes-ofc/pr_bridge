local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "pr_carkeys" then return end

local pr_carkeys = exports.pr_carkeys

Debug('SUCCESS', Lang:t('Debug.VehicleKeyDetected', { vehiclekey = 'PR Carkeys' }))

function vehicle_key.GiveTempKeys(source, plate)
    return pr_carkeys:GiveTempKey(source, plate)
end

function vehicle_key.RemoveTempKeys(source, plate)
    return pr_carkeys:RemoveTempKey(source, plate)
end

function vehicle_key.GiveKeyItem(source, plate, netId)
    return pr_carkeys:CreateTempKeyItem(source, plate, "carkey_temp")
end

function vehicle_key.RemoveKeyItem(source, plate)
    return pr_carkeys:RemoveTempKeyItem(source, plate)
end

function vehicle_key.HaveTemporaryKey(source, plate)
    return pr_carkeys:HasVehicleAccess(source, plate)
end

function vehicle_key.HavePermanentKey(source, plate)
    return pr_carkeys:HasVehicleAccess(source, plate)
end

return vehicle_key
