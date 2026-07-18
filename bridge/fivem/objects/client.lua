local objects = {}

local function hash(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return joaat(value) end
    return nil
end

local function toCoords(coords)
    if coords then
        return type(coords) == "vector3" and coords or vector3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
    end

    return GetEntityCoords(PlayerPedId())
end

local function buildModelSet(model)
    if model == nil then return nil end

    local modelSet = {}

    if type(model) == "table" then
        for i = 1, #model do
            local modelHash = hash(model[i])
            if modelHash then modelSet[modelHash] = true end
        end
    else
        local modelHash = hash(model)
        if modelHash then modelSet[modelHash] = true end
    end

    return next(modelSet) and modelSet or nil
end

local poolAliases = {
    ped = "CPed",
    peds = "CPed",
    player = "CPed",
    players = "CPed",
    object = "CObject",
    objects = "CObject",
    prop = "CObject",
    props = "CObject",
    netobject = "CNetObject",
    netobjects = "CNetObject",
    networked = "CNetObject",
    vehicle = "CVehicle",
    vehicles = "CVehicle",
    pickup = "CPickup",
    pickups = "CPickup",
    cped = "CPed",
    cobject = "CObject",
    cnetobject = "CNetObject",
    cvehicle = "CVehicle",
    cpickup = "CPickup",
    CPed = "CPed",
    CObject = "CObject",
    CNetObject = "CNetObject",
    CVehicle = "CVehicle",
    CPickup = "CPickup",
}

objects.supportedPools = { "CPed", "CObject", "CNetObject", "CVehicle", "CPickup" }

local function normalizePoolName(poolName)
    if type(poolName) ~= "string" then return nil end
    return poolAliases[poolName] or poolAliases[poolName:lower()]
end

local function enumerate(init, move, dispose)
    return coroutine.wrap(function()
        local iterator, entity = init()

        if not entity or entity == 0 then
            if iterator and iterator ~= -1 then dispose(iterator) end
            return
        end

        local nextEntity = true
        repeat
            coroutine.yield(entity)
            nextEntity, entity = move(iterator)
        until not nextEntity

        dispose(iterator)
    end)
end

local function enumerateObjects()
    return enumerate(FindFirstObject, FindNextObject, EndFindObject)
end

local function enumerateVehicles()
    return enumerate(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function collectInRadius(enumerator, coords, radius, options)
    coords = toCoords(coords)
    radius = tonumber(radius) or 5.0
    options = options or {}

    local modelSet = buildModelSet(options.model or options.models)
    local includeCoords = options.includeCoords ~= false
    local results = {}

    for entity in enumerator() do
        if DoesEntityExist(entity) then
            local entityModel = GetEntityModel(entity)

            if not modelSet or modelSet[entityModel] then
                local entityCoords = GetEntityCoords(entity)
                local distance = #(entityCoords - coords)

                if distance <= radius then
                    results[#results + 1] = {
                        entity = entity,
                        model = entityModel,
                        coords = includeCoords and entityCoords or nil,
                        distance = distance,
                    }
                end
            end
        end
    end

    table.sort(results, function(left, right)
        return left.distance < right.distance
    end)

    return results
end

local function decorateResult(result, poolName)
    if poolName == "CVehicle" then
        result.plate = GetVehicleNumberPlateText(result.entity)
    elseif poolName == "CPed" and IsPedAPlayer(result.entity) then
        local playerIndex = NetworkGetPlayerIndexFromPed(result.entity)

        if playerIndex and playerIndex ~= -1 then
            result.player = playerIndex
            result.serverId = GetPlayerServerId(playerIndex)
        end
    end

    result.pool = poolName
    return result
end

local function collectEntityListInRadius(entityList, poolName, coords, radius, options)
    coords = toCoords(coords)
    radius = tonumber(radius) or 5.0
    options = options or {}

    local modelSet = buildModelSet(options.model or options.models)
    local includeCoords = options.includeCoords ~= false
    local results = {}

    for i = 1, #entityList do
        local entity = entityList[i]

        if DoesEntityExist(entity) then
            local entityModel = GetEntityModel(entity)

            if not modelSet or modelSet[entityModel] then
                local entityCoords = GetEntityCoords(entity)
                local distance = #(entityCoords - coords)

                if distance <= radius then
                    results[#results + 1] = decorateResult({
                        entity = entity,
                        model = entityModel,
                        coords = includeCoords and entityCoords or nil,
                        distance = distance,
                    }, poolName)
                end
            end
        end
    end

    table.sort(results, function(left, right)
        return left.distance < right.distance
    end)

    return results
end

function objects.getPoolName(poolName)
    return normalizePoolName(poolName)
end

function objects.getPool(poolName)
    poolName = normalizePoolName(poolName)
    if not poolName or type(GetGamePool) ~= "function" then return {} end

    return GetGamePool(poolName) or {}
end

function objects.getPoolInRadius(poolName, coords, radius, options)
    poolName = normalizePoolName(poolName)
    if not poolName then return {} end

    return collectEntityListInRadius(objects.getPool(poolName), poolName, coords, radius, options)
end

function objects.getPoolByModelInRadius(poolName, model, coords, radius, options)
    options = options or {}
    options.model = model
    return objects.getPoolInRadius(poolName, coords, radius, options)
end

function objects.getClosestFromPool(poolName, coords, radius, options)
    local results = objects.getPoolInRadius(poolName, coords, radius, options)
    return results[1]
end

function objects.getPedsInRadius(coords, radius, options)
    return objects.getPoolInRadius("CPed", coords, radius, options)
end

function objects.getPedsByModelInRadius(model, coords, radius, options)
    return objects.getPoolByModelInRadius("CPed", model, coords, radius, options)
end

function objects.getNetworkedObjectsInRadius(coords, radius, options)
    return objects.getPoolInRadius("CNetObject", coords, radius, options)
end

function objects.getPickupsInRadius(coords, radius, options)
    return objects.getPoolInRadius("CPickup", coords, radius, options)
end

function objects.getObjectsInRadius(coords, radius, options)
    return collectInRadius(enumerateObjects, coords, radius, options)
end

function objects.getByModelInRadius(model, coords, radius, options)
    options = options or {}
    options.model = model
    return objects.getObjectsInRadius(coords, radius, options)
end

function objects.getClosestObject(coords, radius, options)
    local results = objects.getObjectsInRadius(coords, radius, options)
    return results[1]
end

function objects.getClosestByModel(model, coords, radius, options)
    local results = objects.getByModelInRadius(model, coords, radius, options)
    return results[1]
end

function objects.freezeByModelInRadius(model, coords, radius, state)
    local results = objects.getByModelInRadius(model, coords, radius)

    for i = 1, #results do
        FreezeEntityPosition(results[i].entity, state == true)
    end

    return results
end

function objects.getVehiclesInRadius(coords, radius, options)
    local results = collectInRadius(enumerateVehicles, coords, radius, options)

    for i = 1, #results do
        results[i].plate = GetVehicleNumberPlateText(results[i].entity)
    end

    return results
end

function objects.getObjectsInRadiusUsingPool(coords, radius, options)
    return objects.getPoolInRadius("CObject", coords, radius, options)
end

function objects.getVehiclesInRadiusUsingPool(coords, radius, options)
    return objects.getPoolInRadius("CVehicle", coords, radius, options)
end

function objects.getVehiclesByModelInRadius(model, coords, radius, options)
    options = options or {}
    options.model = model
    return objects.getVehiclesInRadius(coords, radius, options)
end

function objects.getClosestVehicle(coords, radius, options)
    local results = objects.getVehiclesInRadius(coords, radius, options)
    return results[1]
end

function objects.getClosestVehicleByModel(model, coords, radius, options)
    local results = objects.getVehiclesByModelInRadius(model, coords, radius, options)
    return results[1]
end

objects.findObjectsInRadius = objects.getObjectsInRadius
objects.findVehiclesInRadius = objects.getVehiclesInRadius
objects.findObjectsInRadiusUsingPool = objects.getObjectsInRadiusUsingPool
objects.findVehiclesInRadiusUsingPool = objects.getVehiclesInRadiusUsingPool
objects.getObjectsByPool = objects.getPoolInRadius
objects.getByPoolInRadius = objects.getPoolInRadius

return objects
