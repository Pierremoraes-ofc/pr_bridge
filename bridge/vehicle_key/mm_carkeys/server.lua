local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "mm_carkeys" then return end
Debug('SUCCESS', Lang:t('Debug.VehicleKeyDetected', { vehiclekey = 'MM Car Keys' }))
local mm_carkeys = exports.mm_carkeys

function vehicle_key.GiveTempKeys(source, plate)
    mm_carkeys:GiveTempKeys(source, plate)
end

function vehicle_key.RemoveTempKeys(source, plate)
    mm_carkeys:RemoveTempKeys(source, plate)
end

function vehicle_key.GiveKeyItem(source, plate, netId)
    mm_carkeys:GiveKeyItem(source, plate, netId)
end

function vehicle_key.RemoveKeyItem(source, plate)
    mm_carkeys:RemoveKeyItem(source, plate)
end

function vehicle_key.HaveTemporaryKey(source, plate)
    return mm_carkeys:HaveTemporaryKey(source, plate)
end

function vehicle_key.HavePermanentKey(source, plate)
    return mm_carkeys:HavePermanentKey(source, plate)
end

return vehicle_key
