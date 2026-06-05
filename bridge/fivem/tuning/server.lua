local tuning = {}

local function getVehicleProperties()
    return PRVehicleProperties or (Bridge and Bridge.fivem and Bridge.fivem.vehicleProperties)
end

function tuning.apply(vehicle, props, options)
    local vehicleProperties = getVehicleProperties()
    if not vehicleProperties or not vehicleProperties.set then return false end

    return vehicleProperties.set(vehicle, props, options) == true
end

function tuning.applyNetId(netId, props, target, options)
    local vehicleProperties = getVehicleProperties()

    if vehicleProperties and vehicleProperties.setNetId then
        return vehicleProperties.setNetId(netId, props, target, options) == true
    end

    return tuning.apply(netId, props, options)
end

function tuning.snapshot()
    return nil
end

function tuning.restore(vehicle, snapshot, options)
    return tuning.apply(vehicle, snapshot, options)
end

return tuning
