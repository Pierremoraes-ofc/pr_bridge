local zonePath, apiPath = ...
assert(type(zonePath) == "string" and type(apiPath) == "string", "paths are required")

function vector3(x, y, z) return { x = x, y = y, z = z } end
function GetConvar(_, fallback) return fallback end
function GetInvokingResource() return "test_resource" end
function GetCurrentResourceName() return "pr_bridge" end
function joaat(value)
    local hash = 0
    for i = 1, #value do hash = (hash * 33 + value:byte(i)) % 2147483647 end
    return hash
end

local Zones = assert(loadfile(zonePath))()
local sphere = Zones.sphere({ name = "sphere", coords = vector3(10, 10, 10), radius = 2 })
assert(sphere:contains(vector3(11, 10, 10)))
assert(not sphere:contains(vector3(13, 10, 10)))
assert(Zones.exists("sphere") and Zones.get("sphere").id == sphere.id)

local box = Zones.box({ name = "box", coords = vector3(0, 0, 0), size = vector3(4, 2, 2), rotation = 90 })
assert(box:contains(vector3(0, 1.5, 0)))
assert(not box:contains(vector3(1.5, 0, 0)))

local poly = Zones.poly({
    name = "poly", thickness = 4,
    points = { vector3(0, 0, 5), vector3(4, 0, 5), vector3(4, 4, 5), vector3(0, 4, 5) },
})
assert(poly:contains(vector3(2, 2, 5)))
assert(not poly:contains(vector3(5, 2, 5)))
assert(not poly:contains(vector3(2, 2, 8)))
assert(#Zones.getNearby(vector3(2, 2, 5)) >= 2)

local replaced = Zones.sphere({ name = "sphere", coords = vector3(30, 30, 0), radius = 1 })
assert(replaced.id ~= sphere.id and not Zones.exists(sphere.id) and Zones.exists("sphere"))

local registeredExports = {}
function exports(name, callback) registeredExports[name] = callback end
function NetworkDoesNetworkIdExist(id) return id == 7 end
function TriggerServerEvent() end
function DoesEntityExist(entity) return entity == 11 end
function NetworkGetEntityIsNetworked() return false end
function IsPedAPlayer() return false end
function AddEventHandler() end
function RegisterNetEvent() end
function CreateThread() end
function GetInvokingResource() return "consumer" end

PRCore = {
    load = function(name)
        assert(name == "bridge.targets.native.zones")
        return Zones
    end,
}

local api = assert(loadfile(apiPath))()
local sameApi = assert(loadfile(apiPath))()
assert(sameApi == api, "native target api must be a singleton")
assert(sameApi._collections() == api._collections(), "native target collections must be shared")
assert(api.addGlobalOption({ name = "global", label = "Global" }))
assert(#api._collections().global == 1)
api.addGlobalOption({ name = "global", label = "Replaced" })
assert(#api._collections().global == 1 and api._collections().global[1].label == "Replaced")

api.addModel({ "vehicle_test", 123 }, { name = "model", label = "Model" })
assert(api._collections().models[123] and #api._collections().models[123] == 1)
local modelAudit = api.inspectModels({ "vehicle_test", 123 })
assert(#modelAudit == 2)
assert(modelAudit[1].hash == joaat("vehicle_test") and modelAudit[1].count == 1)
assert(modelAudit[2].hash == 123 and modelAudit[2].count == 1 and modelAudit[2].names[1] == "model")
api.addEntity({ 7, 8 }, { name = "network", label = "Network" })
assert(api._collections().entities[7] and not api._collections().entities[8])
api.addLocalEntity({ 11, 12 }, { name = "local", label = "Local" })
assert(api._collections().localEntities[11] and not api._collections().localEntities[12])

local zoneId = api.addBoxZone({ coords = vector3(50, 50, 0), size = vector3(2, 2, 2), options = { name = "zone", label = "Zone" } })
assert(api.zoneExists(zoneId))
assert(api.removeZone(zoneId) and not api.zoneExists(zoneId))
assert(type(registeredExports.addBoxZone) == "function" and type(registeredExports.disableTargeting) == "function" and type(registeredExports.inspectModels) == "function")

print("target_native_test: ok")
