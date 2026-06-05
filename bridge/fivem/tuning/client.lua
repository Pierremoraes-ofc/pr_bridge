local tuning = {}

local function getVehicleProperties()
    return PRVehicleProperties or (Bridge and Bridge.fivem and Bridge.fivem.vehicleProperties)
end

local function getNet()
    return PRFivemNet or (Bridge and Bridge.fivem and Bridge.fivem.net)
end

local function resolveVehicle(vehicle)
    local net = getNet()
    if net and net.resolveVehicle then
        return net.resolveVehicle(vehicle, 1000)
    end

    return vehicle
end

local function getFixVehicle(options)
    if type(options) == "boolean" then return options end
    if type(options) == "table" then return options.fixVehicle == true end
    return false
end

function tuning.get(vehicle)
    local vehicleProperties = getVehicleProperties()
    if not vehicleProperties or not vehicleProperties.get then return nil end

    return vehicleProperties.get(vehicle)
end

function tuning.apply(vehicle, props, options)
    local vehicleProperties = getVehicleProperties()
    if not vehicleProperties or not vehicleProperties.set then return false end

    return vehicleProperties.set(vehicle, props, getFixVehicle(options)) == true
end

function tuning.applyNetId(netId, props, options)
    local vehicle = resolveVehicle(netId)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    return tuning.apply(vehicle, props, options)
end

function tuning.snapshot(vehicle)
    return tuning.get(vehicle)
end

function tuning.restore(vehicle, snapshot, options)
    return tuning.apply(vehicle, snapshot, options)
end

function tuning.repair(vehicle)
    vehicle = resolveVehicle(vehicle)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)

    return true
end

function tuning.setPlate(vehicle, plate)
    vehicle = resolveVehicle(vehicle)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    SetVehicleNumberPlateText(vehicle, tostring(plate or ""))
    return true
end

function tuning.setFuel(vehicle, fuelLevel)
    vehicle = resolveVehicle(vehicle)
    fuelLevel = tonumber(fuelLevel)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) or not fuelLevel then return false end

    SetVehicleFuelLevel(vehicle, fuelLevel + 0.0)
    return true
end

function tuning.setMod(vehicle, modType, modIndex, customTires)
    vehicle = resolveVehicle(vehicle)
    modType = tonumber(modType)
    modIndex = tonumber(modIndex)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) or not modType or not modIndex then return false end

    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, modType, modIndex, customTires == true)

    return true
end

function tuning.toggleMod(vehicle, modType, state)
    vehicle = resolveVehicle(vehicle)
    modType = tonumber(modType)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) or not modType then return false end

    SetVehicleModKit(vehicle, 0)
    ToggleVehicleMod(vehicle, modType, state == true)

    return true
end

function tuning.setExtra(vehicle, extraId, state)
    vehicle = resolveVehicle(vehicle)
    extraId = tonumber(extraId)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) or not extraId or not DoesExtraExist(vehicle, extraId) then return false end

    SetVehicleExtra(vehicle, extraId, state == true and 0 or 1)
    return true
end

function tuning.setNeon(vehicle, enabled, color)
    vehicle = resolveVehicle(vehicle)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(vehicle, i, enabled == true)
    end

    if type(color) == "table" then
        SetVehicleNeonLightsColour(vehicle, color[1] or color.r or 255, color[2] or color.g or 255, color[3] or color.b or 255)
    end

    return true
end

function tuning.setXenon(vehicle, enabled, color)
    vehicle = resolveVehicle(vehicle)
    if type(vehicle) ~= "number" or vehicle == 0 or not DoesEntityExist(vehicle) then return false end

    ToggleVehicleMod(vehicle, 22, enabled == true)

    if color ~= nil then
        SetVehicleXenonLightsColor(vehicle, tonumber(color) or 0)
    end

    return true
end

return tuning
