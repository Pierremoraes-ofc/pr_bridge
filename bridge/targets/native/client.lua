local target = {}

if ActiveBridges["target"] ~= "native" then return target end

local native = exports.pr_bridge

function target.GetResourceName() return "pr_bridge" end
function target.disableTargeting(value) return native:disableTargeting(value) end
function target.isActive() return native:isActive() end
function target.addGlobalOption(options) return native:addGlobalOption(options) end
function target.removeGlobalOption(names) return native:removeGlobalOption(names) end
function target.addGlobalObject(options) return native:addGlobalObject(options) end
function target.removeGlobalObject(names) return native:removeGlobalObject(names) end
function target.addGlobalPed(options) return native:addGlobalPed(options) end
function target.removeGlobalPed(names) return native:removeGlobalPed(names) end
function target.addGlobalPlayer(options) return native:addGlobalPlayer(options) end
function target.removeGlobalPlayer(names) return native:removeGlobalPlayer(names) end
function target.addGlobalVehicle(options) return native:addGlobalVehicle(options) end
function target.removeGlobalVehicle(names) return native:removeGlobalVehicle(names) end
function target.addModel(models, options) return native:addModel(models, options) end
function target.removeModel(models, names) return native:removeModel(models, names) end
function target.inspectModels(models) return native:inspectModels(models) end
function target.addEntity(netIds, options) return native:addEntity(netIds, options) end
function target.removeEntity(netIds, names) return native:removeEntity(netIds, names) end
function target.addLocalEntity(entities, options) return native:addLocalEntity(entities, options) end
function target.removeLocalEntity(entities, names) return native:removeLocalEntity(entities, names) end
function target.addSphereZone(parameters) return native:addSphereZone(parameters) end
function target.addBoxZone(parameters) return native:addBoxZone(parameters) end
function target.addPolyZone(parameters) return native:addPolyZone(parameters) end
function target.zoneExists(id) return native:zoneExists(id) end
function target.removeZone(id, suppressWarning) return native:removeZone(id, suppressWarning) end
function target.getTargetOptions(entity, entityType, model) return native:getTargetOptions(entity, entityType, model) end

return target
