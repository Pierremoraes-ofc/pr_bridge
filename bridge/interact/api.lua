local singletonKey = "__pr_bridge_interact_api"
local existing = rawget(_G, singletonKey)
if existing then return existing end

local api = {}
local records = {}
local nextId = 0
local disabled = false

local function owner()
    return GetInvokingResource() or GetCurrentResourceName()
end

local function optionList(options)
    if type(options) ~= "table" then error("interact options must be a table", 3) end
    if options.label or options.name or options.action or options.event or options.serverEvent then
        return { options }
    end
    return options
end

local function vector(value, fallback)
    if type(value) == "vector3" then return value end
    if type(value) == "table" then
        return vector3(tonumber(value.x or value[1]) or 0.0, tonumber(value.y or value[2]) or 0.0, tonumber(value.z or value[3]) or 0.0)
    end
    return fallback
end

local function create(data, kind)
    if type(data) ~= "table" then error("interact data must be a table", 3) end
    local options = optionList(data.options)
    nextId = nextId + 1
    local id = data.id ~= nil and data.id or nextId
    if records[id] then api.removeInteraction(id) end

    records[id] = {
        id = id,
        kind = kind,
        name = data.name or ("interaction:%s"):format(tostring(id)),
        resource = owner(),
        coords = vector(data.coords),
        entity = tonumber(data.entity),
        netId = tonumber(data.netId),
        bone = data.bone,
        offset = vector(data.offset, vector3(0.0, 0.0, 0.0)),
        distance = tonumber(data.distance) or (kind == "coords" and 10.0 or 8.0),
        interactDst = tonumber(data.interactDst) or 1.0,
        groups = data.groups,
        ignoreLos = data.ignoreLos == true,
        options = options,
        modelHashes = data.modelHashes,
    }
    return id
end

local function values(value)
    if type(value) ~= "table" then return { value } end
    return value
end

local function removeMatching(predicate, interactionId)
    local invoking = owner()
    for id, record in pairs(records) do
        if record.resource == invoking and predicate(record) and (interactionId == nil or id == interactionId or record.name == interactionId) then
            records[id] = nil
        end
    end
    return true
end

function api.addInteraction(data)
    if not data.coords then error("coords are required to add an interaction", 2) end
    return create(data, "coords")
end

function api.addLocalEntityInteraction(data)
    if not data.entity or not DoesEntityExist(data.entity) then error("a valid local entity is required", 2) end
    return create(data, data.bone and "bone" or "localEntity")
end

function api.addEntityInteraction(data)
    if not data.netId and data.entity and NetworkGetEntityIsNetworked(data.entity) then
        data.netId = NetworkGetNetworkIdFromEntity(data.entity)
    end
    if not data.netId then error("netId is required for a network entity interaction", 2) end
    return create(data, data.bone and "networkBone" or "networkEntity")
end

function api.addEntityBoneInteraction(data)
    if not data.entity or not data.bone then error("entity and bone are required", 2) end
    return create(data, "bone")
end

function api.addModelInteraction(data)
    local source = data.modelData or data.models or data.model
    if source == nil then error("modelData, models or model is required", 2) end
    if type(source) ~= "table" or source.model then source = { source } end
    local hashes = {}
    local offsets = {}
    for i = 1, #source do
        local entry = source[i]
        local model = type(entry) == "table" and entry.model or entry
        local hash = tonumber(model) or joaat(model)
        if IsModelValid(hash) then
            hashes[#hashes + 1] = hash
            if type(entry) == "table" and entry.offset then offsets[hash] = vector(entry.offset) end
        end
    end
    if #hashes == 0 then error("no valid models were provided", 2) end
    local copy = {}
    for key, value in pairs(data) do copy[key] = value end
    copy.modelHashes = hashes
    copy.modelOffsets = offsets
    local id = create(copy, "model")
    records[id].modelOffsets = offsets
    return id
end

function api.addGlobalVehicleInteraction(data) return create(data, "globalVehicle") end
function api.addGlobalPlayerInteraction(data) return create(data, "globalPlayer") end
api.addGlobalPlayerInteraction = api.addGlobalPlayerInteraction

function api.removeInteraction(id)
    local record = records[id]
    if record and record.resource == owner() then records[id] = nil end
    return true
end

function api.removeInteractionByEntity(entity)
    return removeMatching(function(record) return record.entity == entity end)
end

function api.removeInteractionOption(id, name)
    local record = records[id]
    if not record or record.resource ~= owner() then return false end
    if name == nil then records[id] = nil return true end
    for index = #record.options, 1, -1 do
        if record.options[index].name == name then table.remove(record.options, index) end
    end
    if #record.options == 0 then records[id] = nil end
    return true
end

function api.updateInteraction(id, options)
    local record = records[id]
    if not record or record.resource ~= owner() then return false end
    record.options = optionList(options)
    return true
end

function api.removeLocalEntityInteraction(entity, id)
    return removeMatching(function(record) return record.entity == entity and (record.kind == "localEntity" or record.kind == "bone") end, id)
end

function api.removeEntityInteraction(netId, id)
    return removeMatching(function(record) return record.netId == netId and (record.kind == "networkEntity" or record.kind == "networkBone") end, id)
end

function api.removeModelInteraction(models, id)
    local lookup = {}
    for _, model in ipairs(values(models)) do lookup[tonumber(model) or joaat(model)] = true end
    return removeMatching(function(record)
        if record.kind ~= "model" then return false end
        for i = 1, #(record.modelHashes or {}) do if lookup[record.modelHashes[i]] then return true end end
        return false
    end, id)
end

function api.removeGlobalVehicleInteraction(id)
    return removeMatching(function(record) return record.kind == "globalVehicle" end, id)
end

function api.removeGlobalPlayerInteraction(id)
    return removeMatching(function(record) return record.kind == "globalPlayer" end, id)
end

function api.disable(state)
    disabled = state == true
    LocalPlayer.state:set("interactionsDisabled", disabled, true)
    TriggerEvent("pr_bridge:interact:stateChanged", disabled)
    return true
end

function api._records() return records end
function api._disabled() return disabled end

local exported = {
    AddInteraction = "addInteraction",
    AddLocalEntityInteraction = "addLocalEntityInteraction",
    AddEntityInteraction = "addEntityInteraction",
    AddEntityBoneInteraction = "addEntityBoneInteraction",
    AddModelInteraction = "addModelInteraction",
    AddGlobalVehicleInteraction = "addGlobalVehicleInteraction",
    AddGlobalPlayerInteraction = "addGlobalPlayerInteraction",
    addGlobalPlayerInteraction = "addGlobalPlayerInteraction",
    RemoveInteraction = "removeInteraction",
    RemoveInteractionByEntity = "removeInteractionByEntity",
    RemoveInteractionOption = "removeInteractionOption",
    UpdateInteraction = "updateInteraction",
    RemoveLocalEntityInteraction = "removeLocalEntityInteraction",
    RemoveEntityInteraction = "removeEntityInteraction",
    RemoveModelInteraction = "removeModelInteraction",
    RemoveGlobalVehicleInteraction = "removeGlobalVehicleInteraction",
    RemoveGlobalPlayerInteraction = "removeGlobalPlayerInteraction",
    Disable = "disable",
}

for exportName, method in pairs(exported) do exports(exportName, api[method]) end

AddEventHandler("onClientResourceStop", function(resource)
    for id, record in pairs(records) do
        if record.resource == resource then records[id] = nil end
    end
end)

rawset(_G, singletonKey, api)
return api
