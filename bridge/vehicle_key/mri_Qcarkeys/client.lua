local vehicle_key = {}

if ActiveBridges["vehicle_key"] ~= "mri_Qcarkeys" then return end


local mri_Qcarkeys = exports.mri_Qcarkeys

function vehicle_key.GiveTempKeys(plate)
    mri_Qcarkeys:GiveTempKeys(plate)
end

function vehicle_key.RemoveTempKeys(plate)
    mri_Qcarkeys:RemoveTempKeys(plate)
end

function vehicle_key.GiveKeyItem(plate, vehicle)
    mri_Qcarkeys:GiveKeyItem(plate, vehicle)
end

function vehicle_key.RemoveKeyItem(plate)
    mri_Qcarkeys:RemoveKeyItem(plate)
end

function vehicle_key.HaveTemporaryKey(plate)
    return mri_Qcarkeys:HaveTemporaryKey(plate)
end

function vehicle_key.HavePermanentKey(plate)
    return mri_Qcarkeys:HavePermanentKey(plate)
end

return vehicle_key
