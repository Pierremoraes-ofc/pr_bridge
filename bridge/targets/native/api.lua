local Zones = PRCore.load("bridge.targets.native.zones")
local singletonKey = "__pr_bridge_native_target_api"
local existingApi = rawget(_G, singletonKey)
if existingApi then return existingApi end

local api = {}

local state = { active = false, disabled = false }
local collections = {
    global = {}, peds = {}, vehicles = {}, objects = {}, players = {},
    models = {}, entities = {}, localEntities = {},
}

local function owner()
    return GetInvokingResource() or GetCurrentResourceName()
end

local function array(value)
    if type(value) ~= "table" then return { value } end
    if value.label then return { value } end
    return value
end

local function normalizeOptions(options)
    if type(options) ~= "table" then error("target options must be a table", 3) end
    options = array(options)
    for i = 1, #options do
        if type(options[i]) ~= "table" then error(("target option #%d must be a table"):format(i), 3) end
    end
    return options
end

local function names(value)
    if type(value) == "table" then return value end
    return { value }
end

local function removeTarget(target, remove, resource, replace)
    if not target then return end
    local list = names(remove)
    for i = #target, 1, -1 do
        local option = target[i]
        if option.resource == resource then
            for j = 1, #list do
                if option.name == list[j] then
                    table.remove(target, i)
                    if replace then
                        print(("^3[pr_bridge:target] substituindo opcao '%s' do recurso %s.^0"):format(tostring(option.name), resource))
                    end
                    break
                end
            end
        end
    end
end

local function addTarget(target, options, resource)
    options = normalizeOptions(options)
    resource = resource or owner()
    local existing = {}

    for i = 1, #options do
        local option = options[i]
        option.resource = resource
        if option.name then existing[#existing + 1] = option.name end
    end
    if #existing > 0 then removeTarget(target, existing, resource, true) end
    for i = 1, #options do target[#target + 1] = options[i] end
    return true
end

local function hashes(value)
    value = array(value)
    local output = {}
    for i = 1, #value do
        local model = value[i]
        output[i] = tonumber(model) or joaat(model)
    end
    return output
end

local function ids(value)
    if type(value) == "table" then return value end
    return { value }
end

local function addKeyed(target, keys, options, resource)
    for i = 1, #keys do
        local key = keys[i]
        target[key] = target[key] or {}
        addTarget(target[key], options, resource)
    end
    return true
end

local function removeKeyed(target, keys, optionNames, resource)
    for i = 1, #keys do
        local key = keys[i]
        local options = target[key]
        if options then
            if optionNames then removeTarget(options, optionNames, resource) end
            if not optionNames or #options == 0 then target[key] = nil end
        end
    end
    return true
end

function api.addGlobalOption(options) return addTarget(collections.global, options, owner()) end
function api.removeGlobalOption(optionNames) return removeTarget(collections.global, optionNames, owner()) end
function api.addGlobalObject(options) return addTarget(collections.objects, options, owner()) end
function api.removeGlobalObject(optionNames) return removeTarget(collections.objects, optionNames, owner()) end
function api.addGlobalPed(options) return addTarget(collections.peds, options, owner()) end
function api.removeGlobalPed(optionNames) return removeTarget(collections.peds, optionNames, owner()) end
function api.addGlobalPlayer(options) return addTarget(collections.players, options, owner()) end
function api.removeGlobalPlayer(optionNames) return removeTarget(collections.players, optionNames, owner()) end
function api.addGlobalVehicle(options) return addTarget(collections.vehicles, options, owner()) end
function api.removeGlobalVehicle(optionNames) return removeTarget(collections.vehicles, optionNames, owner()) end

function api.addModel(models, options) return addKeyed(collections.models, hashes(models), options, owner()) end
function api.removeModel(models, optionNames) return removeKeyed(collections.models, hashes(models), optionNames, owner()) end
function api.inspectModels(models)
    local input = array(models)
    local modelHashes = hashes(models)
    local output = {}

    for i = 1, #modelHashes do
        local options = collections.models[modelHashes[i]] or {}
        local optionNames = {}
        for optionIndex = 1, #options do
            optionNames[#optionNames + 1] = options[optionIndex].name
        end
        output[#output + 1] = {
            input = input[i],
            hash = modelHashes[i],
            count = #options,
            names = optionNames,
        }
    end

    return output
end

function api.addEntity(netIds, options)
    local resource = owner()
    local valid = {}
    for _, netId in ipairs(ids(netIds)) do
        netId = tonumber(netId)
        if netId and NetworkDoesNetworkIdExist(netId) then
            valid[#valid + 1] = netId
            if not collections.entities[netId] then
                TriggerServerEvent("pr_bridge:target:setEntityHasOptions", netId)
            end
        end
    end
    return addKeyed(collections.entities, valid, options, resource)
end

function api.removeEntity(netIds, optionNames)
    return removeKeyed(collections.entities, ids(netIds), optionNames, owner())
end

function api.addLocalEntity(entities, options)
    local valid = {}
    for _, entity in ipairs(ids(entities)) do
        if type(entity) == "number" and DoesEntityExist(entity) then valid[#valid + 1] = entity end
    end
    return addKeyed(collections.localEntities, valid, options, owner())
end

function api.removeLocalEntity(entities, optionNames)
    return removeKeyed(collections.localEntities, ids(entities), optionNames, owner())
end

local function addZone(kind, data)
    if type(data) ~= "table" then error("zone data must be a table", 3) end
    data.resource = owner()
    data.options = normalizeOptions(data.options)
    for i = 1, #data.options do data.options[i].resource = data.resource end
    return Zones[kind](data).id
end

function api.addSphereZone(data) return addZone("sphere", data) end
function api.addBoxZone(data) return addZone("box", data) end
function api.addPolyZone(data) return addZone("poly", data) end
function api.zoneExists(id) return Zones.exists(id) end
function api.removeZone(id, suppressWarning)
    if Zones.remove(id) then return true end
    if not suppressWarning then
        print(("^3[pr_bridge:target] tentativa de remover zona inexistente (%s).^0"):format(tostring(id)))
    end
    return false
end

function api.disableTargeting(value)
    state.disabled = value == true
    if state.disabled then state.active = false end
    TriggerEvent("pr_bridge:target:stateChanged")
end

function api.isActive() return state.active end

function api.getTargetOptions(entity, entityType, model)
    if not entity then return collections end
    if entityType == 1 and IsPedAPlayer(entity) then return { global = collections.players } end
    local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or nil
    return {
        global = entityType == 1 and collections.peds or entityType == 2 and collections.vehicles or collections.objects,
        model = collections.models[model],
        entity = netId and collections.entities[netId] or nil,
        localEntity = collections.localEntities[entity],
    }
end

function api._state() return state end
function api._collections() return collections end
function api._zones() return Zones end

local public = {
    "addGlobalOption", "removeGlobalOption", "addGlobalObject", "removeGlobalObject",
    "addGlobalPed", "removeGlobalPed", "addGlobalPlayer", "removeGlobalPlayer",
    "addGlobalVehicle", "removeGlobalVehicle", "addModel", "removeModel",
    "addEntity", "removeEntity", "addLocalEntity", "removeLocalEntity",
    "addSphereZone", "addBoxZone", "addPolyZone", "zoneExists", "removeZone",
    "disableTargeting", "isActive", "getTargetOptions", "inspectModels",
}

for i = 1, #public do
    local name = public[i]
    exports(name, api[name])
end

RegisterNetEvent("pr_bridge:target:removeEntity", function(netIds)
    removeKeyed(collections.entities, ids(netIds), nil, GetCurrentResourceName())
end)

AddEventHandler("onClientResourceStop", function(resource)
    local globals = { collections.global, collections.peds, collections.vehicles, collections.objects, collections.players }
    for i = 1, #globals do
        local target = globals[i]
        for index = #target, 1, -1 do
            if target[index].resource == resource then table.remove(target, index) end
        end
    end

    local keyed = { collections.models, collections.entities, collections.localEntities }
    for i = 1, #keyed do
        for key, options in pairs(keyed[i]) do
            for index = #options, 1, -1 do
                if options[index].resource == resource then table.remove(options, index) end
            end
            if #options == 0 then keyed[i][key] = nil end
        end
    end
    Zones.removeResource(resource)
end)

CreateThread(function()
    while true do
        Wait(60000)
        for entity in pairs(collections.localEntities) do
            if not DoesEntityExist(entity) then collections.localEntities[entity] = nil end
        end
    end
end)

rawset(_G, singletonKey, api)
return api
