local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "mm_carkeys" then return end

local mm_carkeys = exports.mm_carkeys

function vehicle_key.GiveTempKeys(plate)
    mm_carkeys:GiveTempKeys(plate)
end

function vehicle_key.RemoveTempKeys(plate)
    mm_carkeys:RemoveTempKeys(plate)
end

function vehicle_key.GiveKeyItem(plate, vehicle)
    mm_carkeys:GiveKeyItem(plate, vehicle)
end

function vehicle_key.RemoveKeyItem(plate)
    mm_carkeys:RemoveKeyItem(plate)
end

function vehicle_key.HaveTemporaryKey(plate)
    return mm_carkeys:HaveTemporaryKey(plate)
end

function vehicle_key.HavePermanentKey(plate)
    return mm_carkeys:HavePermanentKey(plate)
end

return vehicle_key
