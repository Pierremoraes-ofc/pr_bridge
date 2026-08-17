if ActiveBridges["target"] ~= "native" then return {} end

local api = PRCore.load("bridge.targets.native.api")

local function convert(input)
    input = type(input) == "table" and input or {}
    local distance = input.distance
    local source = input.options or input
    local options = {}

    for key, value in pairs(source) do
        if type(key) == "number" and type(value) == "table" then options[#options + 1] = value end
    end

    for i = 1, #options do
        local option = options[i]
        option.onSelect = option.onSelect or option.action
        option.distance = option.distance or distance
        option.name = option.name or option.label
        option.groups = option.groups or option.job
        option.items = option.items or option.item or option.required_item
        if option.event and option.type and option.type ~= "client" then
            if option.type == "server" then option.serverEvent = option.event
            elseif option.type == "command" then option.command = option.event end
            option.event = nil
        end
        option.action, option.job, option.item, option.required_item, option.type = nil, nil, nil, nil, nil
        option.qtarget = true
    end
    return options
end

local function AddBoxZone(name, center, length, width, options, targetOptions)
    options = options or {}
    local minZ, maxZ = tonumber(options.minZ) or -100.0, tonumber(options.maxZ) or 800.0
    local height = options.useZ and (tonumber(options.height) or 2.0) or math.abs(maxZ - minZ)
    local z = options.useZ and center.z or minZ + height * 0.5
    return api.addBoxZone({
        name = name, coords = vector3(center.x, center.y, z),
        size = vector3(width, length, height), rotation = options.heading or 0.0,
        debug = options.debugPoly == true, options = convert(targetOptions),
    })
end

local function AddPolyZone(name, points, options, targetOptions)
    options = options or {}
    local minZ, maxZ = tonumber(options.minZ) or -100.0, tonumber(options.maxZ) or 800.0
    local converted = {}
    for i = 1, #points do converted[i] = vector3(points[i].x, points[i].y, (minZ + maxZ) * 0.5) end
    return api.addPolyZone({ name = name, points = converted, thickness = math.abs(maxZ - minZ),
        debug = options.debugPoly == true, options = convert(targetOptions) })
end

local function AddCircleZone(name, center, radius, options, targetOptions)
    return api.addSphereZone({ name = name, coords = center, radius = radius,
        debug = options and options.debugPoly == true, options = convert(targetOptions) })
end

local function AddTargetBone(bones, options)
    bones = type(bones) == "table" and bones or { bones }
    local converted = convert(options)
    for i = 1, #converted do converted[i].bones = bones end
    return api.addGlobalVehicle(converted)
end

local function AddTargetEntity(entities, options)
    entities = type(entities) == "table" and entities or { entities }
    local networked, localEntities = {}, {}
    for i = 1, #entities do
        if NetworkGetEntityIsNetworked(entities[i]) then networked[#networked + 1] = NetworkGetNetworkIdFromEntity(entities[i])
        else localEntities[#localEntities + 1] = entities[i] end
    end
    if #networked > 0 then api.addEntity(networked, convert(options)) end
    if #localEntities > 0 then api.addLocalEntity(localEntities, convert(options)) end
    return true
end

local function RemoveTargetEntity(entities, labels)
    entities = type(entities) == "table" and entities or { entities }
    local networked, localEntities = {}, {}
    for i = 1, #entities do
        if NetworkGetEntityIsNetworked(entities[i]) then networked[#networked + 1] = NetworkGetNetworkIdFromEntity(entities[i])
        else localEntities[#localEntities + 1] = entities[i] end
    end
    if #networked > 0 then api.removeEntity(networked, labels) end
    if #localEntities > 0 then api.removeLocalEntity(localEntities, labels) end
end

local compatibility = {
    AddBoxZone = AddBoxZone, AddPolyZone = AddPolyZone, AddCircleZone = AddCircleZone,
    RemoveZone = function(id) return api.removeZone(id, true) end,
    AddTargetBone = AddTargetBone, AddTargetEntity = AddTargetEntity, RemoveTargetEntity = RemoveTargetEntity,
    AddTargetModel = function(models, options) return api.addModel(models, convert(options)) end,
    RemoveTargetModel = api.removeModel,
    Ped = function(options) return api.addGlobalPed(convert(options)) end,
    RemovePed = api.removeGlobalPed,
    Vehicle = function(options) return api.addGlobalVehicle(convert(options)) end,
    RemoveVehicle = api.removeGlobalVehicle,
    Object = function(options) return api.addGlobalObject(convert(options)) end,
    RemoveObject = api.removeGlobalObject,
    Player = function(options) return api.addGlobalPlayer(convert(options)) end,
    RemovePlayer = api.removeGlobalPlayer,
}

for name, callback in pairs(compatibility) do exports(name, callback) end
return compatibility
