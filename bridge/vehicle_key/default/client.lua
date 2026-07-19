local vehicle_key = {}

local function hasPrCarkeys()
    return GetResourceState("pr_carkeys"):find("start") ~= nil
end

function vehicle_key.GiveKeys()
    return false
end

function vehicle_key.RemoveKeys()
    return false
end

function vehicle_key.HasKey(plate)
    if hasPrCarkeys() then
        return exports.pr_carkeys:HaveTempKey(plate) or exports.pr_carkeys:HavePermanentKey(plate)
    end

    return false
end

function vehicle_key.GiveKey()
    return false
end

function vehicle_key.RemoveKey()
    return false
end

function vehicle_key.GetResourceName()
    if hasPrCarkeys() then return "pr_carkeys" end
    return "default"
end

function vehicle_key.HaveTemporaryKey(plate)
    if hasPrCarkeys() then return exports.pr_carkeys:HaveTempKey(plate) end
    return false
end

function vehicle_key.HavePermanentKey(plate)
    if hasPrCarkeys() then return exports.pr_carkeys:HavePermanentKey(plate) end
    return false
end

return vehicle_key
