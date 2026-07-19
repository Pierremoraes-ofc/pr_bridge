local vehicle_key = {}

local function hasPrCarkeys()
    return GetResourceState("pr_carkeys"):find("start") ~= nil
end

function vehicle_key.GiveTempKeys(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:GiveTempKey(source, plate) end
    return false
end

function vehicle_key.RemoveTempKeys(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:RemoveTempKey(source, plate) end
    return false
end

function vehicle_key.GiveKeyItem(source, plate, netId)
    if hasPrCarkeys() then return exports.pr_carkeys:CreateTempKeyItem(source, plate, "carkey_temp") end
    return false
end

function vehicle_key.RemoveKeyItem(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:RemoveTempKeyItem(source, plate) end
    return false
end

function vehicle_key.HaveTemporaryKey(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:HasVehicleAccess(source, plate) end
    return false
end

function vehicle_key.HavePermanentKey(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:HasVehicleAccess(source, plate) end
    return false
end

function vehicle_key.HasKey(source, plate)
    if hasPrCarkeys() then return exports.pr_carkeys:HasVehicleAccess(source, plate) end
    return false
end

function vehicle_key.GiveKey()
    return false
end

function vehicle_key.RemoveKey()
    return false
end

function vehicle_key.GetAllKeys()
    return {}
end

return vehicle_key
