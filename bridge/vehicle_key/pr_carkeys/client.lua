local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "pr_carkeys" then return end

local pr_carkeys = exports.pr_carkeys

function vehicle_key.GiveTempKeys(plate)
    return false
end

function vehicle_key.RemoveTempKeys(plate)
    return false
end

function vehicle_key.GiveKeyItem(plate, vehicle)
    return false
end

function vehicle_key.RemoveKeyItem(plate)
    return false
end

function vehicle_key.HaveTemporaryKey(plate)
    return pr_carkeys:HaveTempKey(plate)
end

function vehicle_key.HavePermanentKey(plate)
    return pr_carkeys:HavePermanentKey(plate)
end

return vehicle_key
