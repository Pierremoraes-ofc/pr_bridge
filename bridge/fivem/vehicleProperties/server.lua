--[[
    Ported from ox_lib vehicleProperties.
    Original source: https://github.com/overextended/ox_lib
    License: LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>
]]

local vehicleProperties = {
    eventName = "pr_bridge:setVehicleProperties",
    stateBagName = "pr_bridge:setVehicleProperties",
}

local function getConfig()
    return Config and Config.Fivem or {}
end

local function normalizeOptions(options)
    if type(options) == "boolean" then
        return options
    end

    if type(options) == "table" then
        return options.fixVehicle == true
    end

    return false
end

local function getNet()
    if PRFivemNet then return PRFivemNet end
    return Bridge and Bridge.fivem and Bridge.fivem.net
end

local function cacheVehicle(entity, netId, props)
    if not PRVehicleCache or type(props) ~= "table" then return end

    PRVehicleCache.set(entity, {
        entity = entity,
        netId = netId,
        plate = props.plate,
        props = props,
        updatedAt = GetGameTimer(),
    })
end

function vehicleProperties.setNetId(netId, props, target, options)
    if type(netId) ~= "number" or netId <= 0 or type(props) ~= "table" then
        return false
    end

    TriggerClientEvent(vehicleProperties.eventName, target or -1, netId, props, normalizeOptions(options))
    return true
end

function vehicleProperties.set(vehicle, props, options)
    local net = getNet()
    local entity, netId

    if net and net.resolveVehicle then
        entity, netId = net.resolveVehicle(vehicle, 1000)
    elseif type(vehicle) == "number" and vehicle > 0 and DoesEntityExist(vehicle) then
        entity = vehicle
        netId = NetworkGetNetworkIdFromEntity(vehicle)
    end

    if not entity or not netId or type(props) ~= "table" then
        if Debug then
            Debug("WARNING", ("Unable to set vehicle properties for '%s'."):format(tostring(vehicle)))
        end

        return false
    end

    local fixVehicle = normalizeOptions(options)
    local owner = net and net.getOwner and net.getOwner(entity) or NetworkGetEntityOwner(entity)

    if owner and owner > 0 then
        cacheVehicle(entity, netId, props)
        TriggerClientEvent(vehicleProperties.eventName, owner, netId, props, fixVehicle)
        return true
    end

    local config = getConfig()

    if config.VehiclePropertiesBroadcastFallback then
        cacheVehicle(entity, netId, props)
        TriggerClientEvent(vehicleProperties.eventName, -1, netId, props, fixVehicle)
        return true
    end

    if config.VehiclePropertiesStateBag then
        cacheVehicle(entity, netId, props)
        Entity(entity).state:set(vehicleProperties.stateBagName, {
            props = props,
            fixVehicle = fixVehicle,
        }, true)
        return true
    end

    if Debug then
        Debug("WARNING", ("Vehicle '%s' has no network owner; properties were not sent."):format(tostring(vehicle)))
    end

    return false
end

vehicleProperties.SetVehicleProperties = vehicleProperties.set
vehicleProperties.SetNetIdProperties = vehicleProperties.setNetId

return vehicleProperties
