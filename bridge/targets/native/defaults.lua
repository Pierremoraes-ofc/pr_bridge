if ActiveBridges["target"] ~= "native" then return true end
if GetConvarInt("pr_bridge:target:defaults", GetConvarInt("ox_target:defaults", 1)) ~= 1 then return true end

local api = PRCore.load("bridge.targets.native.api")
local doorBones = {
    [0] = { "door_dside_f", "seat_dside_f" },
    [1] = { "door_pside_f", "seat_pside_f" },
    [2] = { "door_dside_r", "seat_dside_r" },
    [3] = { "door_pside_r", "seat_pside_r" },
}

local function validDoor(entity, coords, door, offset)
    if not GetIsDoorValid(entity, door) or GetVehicleDoorLockStatus(entity) > 1
        or IsVehicleDoorDamaged(entity, door) or GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then return false end
    if offset then return true end

    local bones = doorBones[door]
    for i = 1, #(bones or {}) do
        local bone = GetEntityBoneIndexByName(entity, bones[i])
        if bone ~= -1 and #(coords - GetEntityBonePosition_2(entity, bone)) < (i == 1 and 0.5 or 0.72) then return true end
    end
    return false
end

local function toggleDoor(entity, door)
    if GetVehicleDoorLockStatus(entity) == 2 then return end
    if GetVehicleDoorAngleRatio(entity, door) > 0.0 then
        SetVehicleDoorShut(entity, door, false)
    else
        SetVehicleDoorOpen(entity, door, false, false)
    end
end

local function selectDoor(data, door)
    local entity = data.entity
    if NetworkGetEntityOwner(entity) == PlayerId() then return toggleDoor(entity, door) end
    TriggerServerEvent("pr_bridge:target:toggleEntityDoor", VehToNet(entity), door)
end

RegisterNetEvent("pr_bridge:target:toggleEntityDoor", function(netId, door)
    local vehicle = NetToVeh(netId)
    if vehicle and vehicle ~= 0 then toggleDoor(vehicle, door) end
end)

local labels = {
    [0] = "Abrir/fechar porta do motorista",
    [1] = "Abrir/fechar porta do passageiro",
    [2] = "Abrir/fechar porta traseira esquerda",
    [3] = "Abrir/fechar porta traseira direita",
}

local options = {}
for door = 0, 3 do
    local doorIndex = door
    options[#options + 1] = {
        name = ("pr_bridge:target:door:%d"):format(doorIndex),
        icon = "fa-solid fa-car-side",
        label = labels[doorIndex],
        bones = doorBones[doorIndex],
        distance = 2.0,
        canInteract = function(entity, _, coords) return validDoor(entity, coords, doorIndex, false) end,
        onSelect = function(data) selectDoor(data, doorIndex) end,
    }
end

options[#options + 1] = {
    name = "pr_bridge:target:hood",
    icon = "fa-solid fa-car",
    label = "Abrir/fechar capo",
    offset = vector3(0.5, 1.0, 0.5),
    distance = 2.0,
    canInteract = function(entity, _, coords) return validDoor(entity, coords, 4, true) end,
    onSelect = function(data) selectDoor(data, 4) end,
}

options[#options + 1] = {
    name = "pr_bridge:target:trunk",
    icon = "fa-solid fa-car-rear",
    label = "Abrir/fechar porta-malas",
    offset = vector3(0.5, 0.0, 0.5),
    distance = 2.0,
    canInteract = function(entity, _, coords) return validDoor(entity, coords, 5, true) end,
    onSelect = function(data) selectDoor(data, 5) end,
}

api.addGlobalVehicle(options)
return true
