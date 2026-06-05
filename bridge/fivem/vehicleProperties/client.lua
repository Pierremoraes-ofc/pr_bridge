--[[
    Ported from ox_lib vehicleProperties.
    Original source: https://github.com/overextended/ox_lib
    License: LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>
]]

local vehicleProperties = {
    eventName = "pr_bridge:setVehicleProperties",
    stateBagName = "pr_bridge:setVehicleProperties",
}

local gameBuild = GetGameBuildNumber()

local function waitForStateBagEntity(bagName, timeout)
    if not GetEntityFromStateBagName then return 0 end

    local expires = GetGameTimer() + (timeout or 10000)

    repeat
        local entity = GetEntityFromStateBagName(bagName)
        if entity and entity > 0 then return entity end
        Wait(0)
    until GetGameTimer() >= expires

    return 0
end

local function unpackStateBagValue(value)
    if type(value) ~= "table" then return nil, false end
    if value.props then return value.props, value.fixVehicle == true end

    return value, false
end

local function getNet()
    if PRFivemNet then return PRFivemNet end
    return Bridge and Bridge.fivem and Bridge.fivem.net
end

local function cacheVehicle(entity, props)
    if not PRVehicleCache or type(props) ~= "table" then return end

    local net = getNet()
    local netId = net and net.getNetId and net.getNetId(entity) or nil

    PRVehicleCache.set(entity, {
        entity = entity,
        netId = netId,
        plate = props.plate,
        props = props,
        updatedAt = GetGameTimer(),
    })
end

local function setVehicleModIfPresent(vehicle, props, key, modType, customTires)
    local value = props[key]
    if value ~= nil then
        SetVehicleMod(vehicle, modType, value, customTires == true)
    end
end

function vehicleProperties.get(vehicle)
    local net = getNet()

    if net and net.resolveVehicle then
        vehicle = net.resolveVehicle(vehicle, 1000)
    end

    if type(vehicle) ~= "number" or not DoesEntityExist(vehicle) then return nil end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local paintType1 = GetVehicleModColor_1(vehicle)
    local paintType2 = GetVehicleModColor_2(vehicle)

    if GetIsVehiclePrimaryColourCustom(vehicle) then
        colorPrimary = { GetVehicleCustomPrimaryColour(vehicle) }
    end

    if GetIsVehicleSecondaryColourCustom(vehicle) then
        colorSecondary = { GetVehicleCustomSecondaryColour(vehicle) }
    end

    local extras = {}

    for i = 1, 15 do
        if DoesExtraExist(vehicle, i) then
            extras[i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
        end
    end

    local damage = {
        windows = {},
        doors = {},
        tyres = {},
    }

    local windows = 0

    for i = 0, 7 do
        RollUpWindow(vehicle, i)

        if not IsVehicleWindowIntact(vehicle, i) then
            windows = windows + 1
            damage.windows[windows] = i
        end
    end

    local doors = 0

    for i = 0, 5 do
        if IsVehicleDoorDamaged(vehicle, i) then
            doors = doors + 1
            damage.doors[doors] = i
        end
    end

    for i = 0, 7 do
        if IsVehicleTyreBurst(vehicle, i, false) then
            damage.tyres[i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
        end
    end

    local neons = {}

    for i = 0, 3 do
        neons[i + 1] = IsVehicleNeonLightEnabled(vehicle, i)
    end

    local props = {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        lockState = GetVehicleDoorLockStatus(vehicle),
        bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
        engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
        tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
        fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
        oilLevel = math.floor(GetVehicleOilLevel(vehicle) + 0.5),
        dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),
        paintType1 = paintType1,
        paintType2 = paintType2,
        color1 = colorPrimary,
        color2 = colorSecondary,
        pearlescentColor = pearlescentColor,
        interiorColor = GetVehicleInteriorColor(vehicle),
        dashboardColor = GetVehicleDashboardColour(vehicle),
        wheelColor = wheelColor,
        wheelWidth = GetVehicleWheelWidth(vehicle),
        wheelSize = GetVehicleWheelSize(vehicle),
        wheels = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        xenonColor = GetVehicleXenonLightsColor(vehicle),
        neonEnabled = neons,
        neonColor = { GetVehicleNeonLightsColour(vehicle) },
        extras = extras,
        tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },
        modSpoilers = GetVehicleMod(vehicle, 0),
        modFrontBumper = GetVehicleMod(vehicle, 1),
        modRearBumper = GetVehicleMod(vehicle, 2),
        modSideSkirt = GetVehicleMod(vehicle, 3),
        modExhaust = GetVehicleMod(vehicle, 4),
        modFrame = GetVehicleMod(vehicle, 5),
        modGrille = GetVehicleMod(vehicle, 6),
        modHood = GetVehicleMod(vehicle, 7),
        modFender = GetVehicleMod(vehicle, 8),
        modRightFender = GetVehicleMod(vehicle, 9),
        modRoof = GetVehicleMod(vehicle, 10),
        modEngine = GetVehicleMod(vehicle, 11),
        modBrakes = GetVehicleMod(vehicle, 12),
        modTransmission = GetVehicleMod(vehicle, 13),
        modHorns = GetVehicleMod(vehicle, 14),
        modSuspension = GetVehicleMod(vehicle, 15),
        modArmor = GetVehicleMod(vehicle, 16),
        modNitrous = GetVehicleMod(vehicle, 17),
        modTurbo = IsToggleModOn(vehicle, 18),
        modSubwoofer = IsToggleModOn(vehicle, 19),
        modSmokeEnabled = IsToggleModOn(vehicle, 20),
        modHydraulics = IsToggleModOn(vehicle, 21),
        modXenon = IsToggleModOn(vehicle, 22),
        modFrontWheels = GetVehicleMod(vehicle, 23),
        modBackWheels = GetVehicleMod(vehicle, 24),
        modCustomTiresF = GetVehicleModVariation(vehicle, 23),
        modCustomTiresR = GetVehicleModVariation(vehicle, 24),
        modPlateHolder = GetVehicleMod(vehicle, 25),
        modVanityPlate = GetVehicleMod(vehicle, 26),
        modTrimA = GetVehicleMod(vehicle, 27),
        modOrnaments = GetVehicleMod(vehicle, 28),
        modDashboard = GetVehicleMod(vehicle, 29),
        modDial = GetVehicleMod(vehicle, 30),
        modDoorSpeaker = GetVehicleMod(vehicle, 31),
        modSeats = GetVehicleMod(vehicle, 32),
        modSteeringWheel = GetVehicleMod(vehicle, 33),
        modShifterLeavers = GetVehicleMod(vehicle, 34),
        modAPlate = GetVehicleMod(vehicle, 35),
        modSpeakers = GetVehicleMod(vehicle, 36),
        modTrunk = GetVehicleMod(vehicle, 37),
        modHydrolic = GetVehicleMod(vehicle, 38),
        modEngineBlock = GetVehicleMod(vehicle, 39),
        modAirFilter = GetVehicleMod(vehicle, 40),
        modStruts = GetVehicleMod(vehicle, 41),
        modArchCover = GetVehicleMod(vehicle, 42),
        modAerials = GetVehicleMod(vehicle, 43),
        modTrimB = GetVehicleMod(vehicle, 44),
        modTank = GetVehicleMod(vehicle, 45),
        modWindows = GetVehicleMod(vehicle, 46),
        modDoorR = GetVehicleMod(vehicle, 47),
        modLivery = GetVehicleMod(vehicle, 48),
        modRoofLivery = GetVehicleRoofLivery(vehicle),
        modLightbar = GetVehicleMod(vehicle, 49),
        livery = GetVehicleLivery(vehicle),
        windows = damage.windows,
        doors = damage.doors,
        tyres = damage.tyres,
        bulletProofTyres = GetVehicleTyresCanBurst(vehicle),
        driftTyres = gameBuild >= 2372 and GetDriftTyresEnabled(vehicle),
    }

    cacheVehicle(vehicle, props)

    return props
end

function vehicleProperties.set(vehicle, props, fixVehicle)
    local net = getNet()

    if net and net.resolveVehicle then
        vehicle = net.resolveVehicle(vehicle, 1000)
    end

    if type(vehicle) ~= "number" or not DoesEntityExist(vehicle) then
        if Debug then
            Debug("WARNING", ("Unable to set vehicle properties for '%s' (entity does not exist)."):format(tostring(vehicle)))
        end

        return false
    end

    if type(props) ~= "table" then return false end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleModKit(vehicle, 0)

    if props.extras then
        for id, disable in pairs(props.extras) do
            SetVehicleExtra(vehicle, tonumber(id), disable == 1)
        end
    end

    if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
    if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if props.lockState ~= nil then SetVehicleDoorsLocked(vehicle, props.lockState) end
    if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
    if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if props.oilLevel then SetVehicleOilLevel(vehicle, props.oilLevel + 0.0) end
    if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end

    if props.color1 then
        if type(props.color1) == "number" then
            ClearVehicleCustomPrimaryColour(vehicle)
            SetVehicleColours(vehicle, props.color1, colorSecondary)
        else
            if props.paintType1 then SetVehicleModColor_1(vehicle, props.paintType1, 0, props.pearlescentColor or 0) end
            SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
        end
    end

    if props.color2 then
        if type(props.color2) == "number" then
            ClearVehicleCustomSecondaryColour(vehicle)
            local primary = type(props.color1) == "number" and props.color1 or colorPrimary
            SetVehicleColours(vehicle, primary, props.color2)
        else
            if props.paintType2 then SetVehicleModColor_2(vehicle, props.paintType2, 0) end
            SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
        end
    end

    if props.pearlescentColor or props.wheelColor then
        SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
    end

    if props.interiorColor then SetVehicleInteriorColor(vehicle, props.interiorColor) end
    if props.dashboardColor then SetVehicleDashboardColor(vehicle, props.dashboardColor) end
    if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
    if props.wheelSize then SetVehicleWheelSize(vehicle, props.wheelSize) end
    if props.wheelWidth then SetVehicleWheelWidth(vehicle, props.wheelWidth) end
    if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

    if props.neonEnabled then
        for i = 1, #props.neonEnabled do
            SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
        end
    end

    if props.windows then
        for i = 1, #props.windows do
            RemoveVehicleWindow(vehicle, props.windows[i])
        end
    end

    if props.doors then
        for i = 1, #props.doors do
            SetVehicleDoorBroken(vehicle, props.doors[i], true)
        end
    end

    if props.tyres then
        for tyre, state in pairs(props.tyres) do
            SetVehicleTyreBurst(vehicle, tonumber(tyre), state == 2, 1000.0)
        end
    end

    if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
    if props.modSmokeEnabled ~= nil then ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled) end
    if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end

    setVehicleModIfPresent(vehicle, props, "modSpoilers", 0)
    setVehicleModIfPresent(vehicle, props, "modFrontBumper", 1)
    setVehicleModIfPresent(vehicle, props, "modRearBumper", 2)
    setVehicleModIfPresent(vehicle, props, "modSideSkirt", 3)
    setVehicleModIfPresent(vehicle, props, "modExhaust", 4)
    setVehicleModIfPresent(vehicle, props, "modFrame", 5)
    setVehicleModIfPresent(vehicle, props, "modGrille", 6)
    setVehicleModIfPresent(vehicle, props, "modHood", 7)
    setVehicleModIfPresent(vehicle, props, "modFender", 8)
    setVehicleModIfPresent(vehicle, props, "modRightFender", 9)
    setVehicleModIfPresent(vehicle, props, "modRoof", 10)
    setVehicleModIfPresent(vehicle, props, "modEngine", 11)
    setVehicleModIfPresent(vehicle, props, "modBrakes", 12)
    setVehicleModIfPresent(vehicle, props, "modTransmission", 13)
    setVehicleModIfPresent(vehicle, props, "modHorns", 14)
    setVehicleModIfPresent(vehicle, props, "modSuspension", 15)
    setVehicleModIfPresent(vehicle, props, "modArmor", 16)
    setVehicleModIfPresent(vehicle, props, "modNitrous", 17)

    if props.modTurbo ~= nil then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
    if props.modSubwoofer ~= nil then ToggleVehicleMod(vehicle, 19, props.modSubwoofer) end
    if props.modHydraulics ~= nil then ToggleVehicleMod(vehicle, 21, props.modHydraulics) end
    if props.modXenon ~= nil then ToggleVehicleMod(vehicle, 22, props.modXenon) end
    if props.xenonColor then SetVehicleXenonLightsColor(vehicle, props.xenonColor) end

    setVehicleModIfPresent(vehicle, props, "modFrontWheels", 23, props.modCustomTiresF)
    setVehicleModIfPresent(vehicle, props, "modBackWheels", 24, props.modCustomTiresR)
    setVehicleModIfPresent(vehicle, props, "modPlateHolder", 25)
    setVehicleModIfPresent(vehicle, props, "modVanityPlate", 26)
    setVehicleModIfPresent(vehicle, props, "modTrimA", 27)
    setVehicleModIfPresent(vehicle, props, "modOrnaments", 28)
    setVehicleModIfPresent(vehicle, props, "modDashboard", 29)
    setVehicleModIfPresent(vehicle, props, "modDial", 30)
    setVehicleModIfPresent(vehicle, props, "modDoorSpeaker", 31)
    setVehicleModIfPresent(vehicle, props, "modSeats", 32)
    setVehicleModIfPresent(vehicle, props, "modSteeringWheel", 33)
    setVehicleModIfPresent(vehicle, props, "modShifterLeavers", 34)
    setVehicleModIfPresent(vehicle, props, "modAPlate", 35)
    setVehicleModIfPresent(vehicle, props, "modSpeakers", 36)
    setVehicleModIfPresent(vehicle, props, "modTrunk", 37)
    setVehicleModIfPresent(vehicle, props, "modHydrolic", 38)
    setVehicleModIfPresent(vehicle, props, "modEngineBlock", 39)
    setVehicleModIfPresent(vehicle, props, "modAirFilter", 40)
    setVehicleModIfPresent(vehicle, props, "modStruts", 41)
    setVehicleModIfPresent(vehicle, props, "modArchCover", 42)
    setVehicleModIfPresent(vehicle, props, "modAerials", 43)
    setVehicleModIfPresent(vehicle, props, "modTrimB", 44)
    setVehicleModIfPresent(vehicle, props, "modTank", 45)
    setVehicleModIfPresent(vehicle, props, "modWindows", 46)
    setVehicleModIfPresent(vehicle, props, "modDoorR", 47)
    setVehicleModIfPresent(vehicle, props, "modLivery", 48)

    if props.modRoofLivery then SetVehicleRoofLivery(vehicle, props.modRoofLivery) end
    if props.modLightbar then SetVehicleMod(vehicle, 49, props.modLightbar, false) end
    if props.livery then SetVehicleLivery(vehicle, props.livery) end
    if props.bulletProofTyres ~= nil then SetVehicleTyresCanBurst(vehicle, props.bulletProofTyres) end
    if gameBuild >= 2372 and props.driftTyres ~= nil then SetDriftTyresEnabled(vehicle, props.driftTyres) end
    if fixVehicle then SetVehicleFixed(vehicle) end

    cacheVehicle(vehicle, props)

    return not NetworkGetEntityIsNetworked(vehicle) or NetworkGetEntityOwner(vehicle) == PlayerId()
end

RegisterNetEvent(vehicleProperties.eventName, function(netId, props, fixVehicle)
    local net = getNet()
    local vehicle = net and net.getVehicle and net.getVehicle(netId, 1000)

    if vehicle and vehicle > 0 then
        vehicleProperties.set(vehicle, props, fixVehicle == true)
    end
end)

if Config and Config.Fivem and Config.Fivem.VehiclePropertiesStateBag then
    AddStateBagChangeHandler(vehicleProperties.stateBagName, "", function(bagName, _, value)
        local props, fixVehicle = unpackStateBagValue(value)
        if not props then return end

        while NetworkIsInTutorialSession() do Wait(0) end

        local entity = waitForStateBagEntity(bagName, 10000)
        if entity <= 0 then return end

        vehicleProperties.set(entity, props, fixVehicle)
        Wait(200)

        if NetworkGetEntityOwner(entity) == PlayerId() then
            vehicleProperties.set(entity, props, fixVehicle)
            Entity(entity).state:set(vehicleProperties.stateBagName, nil, true)
        end
    end)
end

vehicleProperties.GetVehicleProperties = vehicleProperties.get
vehicleProperties.SetVehicleProperties = vehicleProperties.set

return vehicleProperties
