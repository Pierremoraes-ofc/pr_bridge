local apiPath = assert(arg[1], "informe o caminho de bridge/interact/api.lua")
local exported, handlers = {}, {}

function vector3(x, y, z) return { x = x, y = y, z = z } end
function DoesEntityExist(entity) return type(entity) == "number" and entity > 0 end
function NetworkGetEntityIsNetworked(entity) return entity == 22 end
function NetworkGetNetworkIdFromEntity(entity) return entity + 100 end
function NetworkDoesNetworkIdExist(netId) return netId == 122 end
function IsModelValid(hash) return type(hash) == "number" and hash ~= 0 end
function joaat(value)
    local hash = 0
    for i = 1, #value do hash = hash + value:byte(i) * i end
    return hash
end
function GetInvokingResource() return "consumer" end
function GetCurrentResourceName() return "pr_bridge" end
function TriggerEvent() end
function AddEventHandler(name, callback) handlers[name] = callback end
function exports(name, callback) exported[name] = callback end

LocalPlayer = { state = { set = function(self, key, value) self[key] = value end } }

local api = assert(loadfile(apiPath))()
local point = api.addInteraction({ id = "point", coords = vector3(1, 2, 3), options = { { name = "hello", label = "Hello" } } })
assert(point == "point" and api._records().point.kind == "coords")
assert(api._records().point.hide == false, "interacao comum nao deve ocultar a NUI")

local hiddenPoint = api.addInteraction({ id = "hidden", coords = vector3(4, 5, 6), hide = true, options = { { name = "secret", label = "Secret" } } })
assert(hiddenPoint == "hidden" and api._records().hidden.hide == true, "hide individual nao foi preservado")

local localId = api.addLocalEntityInteraction({ entity = 11, options = { label = "Local" } })
assert(api._records()[localId].entity == 11)

local netId = api.addEntityInteraction({ entity = 22, options = { label = "Network" } })
assert(api._records()[netId].netId == 122)

local modelId = api.addModelInteraction({ model = { model = "prop_test", offset = vector3(0, 1, 0) }, options = { label = "Model" } })
assert(#api._records()[modelId].modelHashes == 1)

local vehicleId = api.addGlobalVehicleInteraction({ options = { { name = "trunk", label = "Trunk" } } })
assert(api._records()[vehicleId].kind == "globalVehicle")
assert(api.removeInteractionOption(vehicleId, "trunk") == true and api._records()[vehicleId] == nil)

assert(type(exported.AddInteraction) == "function" and type(exported.AddGlobalVehicleInteraction) == "function")
assert(api.disable(true) == true and api._disabled() == true and LocalPlayer.state.interactionsDisabled == true)

print("INTERACT_NATIVE_TEST_OK records=" .. tostring(#api._records()))
