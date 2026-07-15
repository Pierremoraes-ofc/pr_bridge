local target = {}

if ActiveBridges["target"] ~= "ox" then return end

local ox_target = exports.ox_target

function target.disableTargeting(state)
    ox_target:disableTargeting(state)
end

function target.addGlobalOption(options)
    return ox_target:addGlobalOption(options)
end

function target.removeGlobalOption(optionNames)
    return ox_target:removeGlobalOption(optionNames)
end

function target.addGlobalObject(options)
    return ox_target:addGlobalObject(options)
end

function target.removeGlobalObject(optionNames)
    return ox_target:removeGlobalObject(optionNames)
end

function target.addGlobalPed(options)
    return ox_target:addGlobalPed(options)
end

function target.removeGlobalPed(optionNames)
    return ox_target:removeGlobalPed(optionNames)
end

function target.addGlobalPlayer(options)
    return ox_target:addGlobalPlayer(options)
end

function target.removeGlobalPlayer(optionNames)
    return ox_target:removeGlobalPlayer(optionNames)
end

function target.addGlobalVehicle(options)
    return ox_target:addGlobalVehicle(options)
end

function target.removeGlobalVehicle(optionNames)
    return ox_target:removeGlobalVehicle(optionNames)
end

function target.addModel(models, options)
    return ox_target:addModel(models, options)
end

function target.removeModel(models, optionNames)
    return ox_target:removeModel(models, optionNames)
end

function target.addEntity(netIds, options)
    return ox_target:addEntity(netIds, options)
end

function target.removeEntity(netIds, optionNames)
    return ox_target:removeEntity(netIds, optionNames)
end

function target.addLocalEntity(entities, options)
    return ox_target:addLocalEntity(entities, options)
end

function target.removeLocalEntity(entities, optionNames)
    return ox_target:removeLocalEntity(entities, optionNames)
end

function target.addSphereZone(parameters)
    return ox_target:addSphereZone(parameters)
end

function target.addBoxZone(parameters)
    return ox_target:addBoxZone(parameters)
end

function target.addPolyZone(parameters)
    return ox_target:addPolyZone(parameters)
end

function target.removeZone(id)
    return ox_target:removeZone(id)
end

return target
