local target = {}

if ActiveBridges["target"] ~= "native" then return target end

local native = exports.pr_bridge

local function inputList(value)
    if type(value) ~= "table" or value.__prPickupDescriptor then return { value } end
    return value
end

local function pickupDescriptor(value)
    if type(value) == "table" and value.__prPickupDescriptor then return value end

    local handle = tonumber(value)
    if not handle or handle <= 0 or type(DoesPickupExist) ~= "function" or not DoesPickupExist(handle) then
        return nil
    end

    local object = type(GetPickupObject) == "function" and GetPickupObject(handle) or 0
    object = tonumber(object) or 0
    local validObject = object > 0 and DoesEntityExist(object) and GetEntityType(object) > 0
    local coords
    if validObject then
        coords = GetEntityCoords(object)
    elseif type(GetPickupCoords) == "function" then
        coords = GetPickupCoords(handle)
    end

    local networked = validObject and type(NetworkGetEntityIsNetworked) == "function"
        and NetworkGetEntityIsNetworked(object) or false
    local netId = networked and NetworkGetNetworkIdFromEntity(object) or 0

    return {
        __prPickupDescriptor = true,
        pickup = handle,
        entity = validObject and object or 0,
        netId = tonumber(netId) or 0,
        networked = networked == true,
        model = validObject and GetEntityModel(object) or nil,
        pickupType = type(GetPickupHash) == "function" and GetPickupHash(handle) or nil,
        coords = coords and { x = coords.x, y = coords.y, z = coords.z } or nil,
    }
end

local function describePickups(values)
    local output = {}
    for _, value in ipairs(inputList(values)) do
        output[#output + 1] = pickupDescriptor(value) or value
    end
    return output
end

function target.GetResourceName() return "pr_bridge" end
function target.disableTargeting(value) return native:disableTargeting(value) end
function target.isActive() return native:isActive() end
function target.addGlobalOption(options) return native:addGlobalOption(options) end
function target.removeGlobalOption(names) return native:removeGlobalOption(names) end
function target.addGlobalObject(options) return native:addGlobalObject(options) end
function target.removeGlobalObject(names) return native:removeGlobalObject(names) end
function target.addGlobalPickup(options) return native:addGlobalPickup(options) end
function target.removeGlobalPickup(names) return native:removeGlobalPickup(names) end
function target.addGlobalPed(options) return native:addGlobalPed(options) end
function target.removeGlobalPed(names) return native:removeGlobalPed(names) end
function target.addGlobalPlayer(options) return native:addGlobalPlayer(options) end
function target.removeGlobalPlayer(names) return native:removeGlobalPlayer(names) end
function target.addGlobalVehicle(options) return native:addGlobalVehicle(options) end
function target.removeGlobalVehicle(names) return native:removeGlobalVehicle(names) end
function target.addModel(models, options) return native:addModel(models, options) end
function target.removeModel(models, names) return native:removeModel(models, names) end
function target.addPickupType(pickupTypes, options) return native:addPickupType(pickupTypes, options) end
function target.removePickupType(pickupTypes, names) return native:removePickupType(pickupTypes, names) end
function target.addPickup(pickups, options) return native:addPickup(describePickups(pickups), options) end
function target.removePickup(pickups, names) return native:removePickup(describePickups(pickups), names) end
function target.inspectModels(models) return native:inspectModels(models) end
function target.addEntity(netIds, options) return native:addEntity(describePickups(netIds), options) end
function target.removeEntity(netIds, names) return native:removeEntity(describePickups(netIds), names) end
function target.addLocalEntity(entities, options) return native:addLocalEntity(describePickups(entities), options) end
function target.removeLocalEntity(entities, names) return native:removeLocalEntity(describePickups(entities), names) end
function target.addSphereZone(parameters) return native:addSphereZone(parameters) end
function target.addBoxZone(parameters) return native:addBoxZone(parameters) end
function target.addPolyZone(parameters) return native:addPolyZone(parameters) end
function target.zoneExists(id) return native:zoneExists(id) end
function target.removeZone(id, suppressWarning) return native:removeZone(id, suppressWarning) end
function target.getTargetOptions(entity, entityType, model, pickup, pickupType) return native:getTargetOptions(entity, entityType, model, pickup, pickupType) end

return target
