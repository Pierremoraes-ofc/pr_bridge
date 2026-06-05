local devtools = {}

local activeSession = nil

local function debug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function encodeJson(value)
    if type(json) == "table" and type(json.encode) == "function" then
        local ok, encoded = pcall(json.encode, value)
        if ok and encoded then return encoded end
    end

    return tostring(value)
end

local function debugPlacementJson(event, payload)
    debug("info", ("[pr_bridge:devtools] placement_%s json=%s"):format(tostring(event), encodeJson(payload or {})))
end

local function getDrawText()
    return PRDrawText
        or (Bridge and Bridge.fivem and (Bridge.fivem.drawtext or Bridge.fivem.drawText))
end

local function getButtons()
    return PRInstructionalButtons
        or (Bridge and Bridge.fivem and (Bridge.fivem.instructionalButtons or Bridge.fivem.buttons))
end

local function getStreaming()
    return PRStreaming
        or (Bridge and Bridge.fivem and Bridge.fivem.streaming)
end

local function getEditorCamera()
    return PREditorCamera
        or (Bridge and Bridge.fivem and (Bridge.fivem.editorCamera or Bridge.fivem.editor_camera))
        or (_G and (_G.PRBridgeEditorCamera or _G.EditorCamera))
end

local function norm(v)
    local d = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    if d == 0 then return vector3(0.0, 0.0, 0.0) end
    return vector3(v.x / d, v.y / d, v.z / d)
end

local function round(value, digits)
    local mult = 10 ^ (digits or 2)
    return math.floor((tonumber(value) or 0.0) * mult + 0.5) / mult
end

local function rotationToDirection(rotation)
    local adjustedRotation = vector3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )

    return vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
end

local function modelHashFromName(modelName)
    if type(modelName) == "number" then return modelName end
    if type(modelName) == "string" then return joaat(modelName) end
    return nil
end

local function requestPlacementModel(modelName, timeout)
    local modelHash = modelHashFromName(modelName)
    if not modelHash or not IsModelInCdimage(modelHash) then return false, modelHash end

    if HasModelLoaded(modelHash) then return true, modelHash end

    local streaming = getStreaming()
    if streaming and streaming.requestModel then
        return streaming.requestModel(modelHash, timeout or 3000)
    end

    RequestModel(modelHash)
    local expires = GetGameTimer() + (timeout or 3000)

    repeat
        if HasModelLoaded(modelHash) then return true, modelHash end
        Wait(0)
    until GetGameTimer() >= expires

    return HasModelLoaded(modelHash), modelHash
end

local function getCameraPoints(cam, distance)
    distance = distance or 200.0

    if type(cam) == "table" then
        cam = cam.camera
    end

    if not cam then return nil, nil end

    local camCoords = GetCamCoord(cam)
    local camRot = GetCamRot(cam, 2)
    local camDir = rotationToDirection(camRot)

    return camCoords, camCoords + camDir * distance
end

local function getCameraRaycast(cam, ignoreEntity, flags, distance)
    flags = flags or 1
    distance = distance or 200.0

    local camCoords, destination = getCameraPoints(cam, distance)
    if not camCoords then return vector3(0.0, 0.0, 0.0), false, nil end

    local rayHandle = StartShapeTestRay(
        camCoords.x,
        camCoords.y,
        camCoords.z,
        destination.x,
        destination.y,
        destination.z,
        flags,
        ignoreEntity or -1,
        0
    )

    local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 or hit == true then
        return endCoords, true, entityHit
    end

    return destination, false, nil
end

local function getCameraCapsuleHit(cam, ignoreEntity, flags, distance, radius)
    flags = flags or -1
    distance = distance or 200.0
    radius = radius or 0.75

    local camCoords, destination = getCameraPoints(cam, distance)
    if not camCoords then return nil, false, nil end

    local rayHandle = StartShapeTestCapsule(
        camCoords.x,
        camCoords.y,
        camCoords.z,
        destination.x,
        destination.y,
        destination.z,
        radius,
        flags,
        ignoreEntity or -1,
        7
    )

    local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 or hit == true then
        return endCoords, true, entityHit
    end

    return nil, false, nil
end

local function getClosestVehicleAtPoint(coords, radius, ignoreEntity)
    if not coords then return nil end

    radius = radius or 2.5
    local offsets = { 0.0, 0.75, -0.75, 1.5, -1.5 }
    local flags = { 70, 127 }

    for i = 1, #offsets do
        for j = 1, #flags do
            local entity = GetClosestVehicle(coords.x, coords.y, coords.z + offsets[i], radius, 0, flags[j])
            if entity and entity ~= 0 and entity ~= ignoreEntity and DoesEntityExist(entity) then
                return entity
            end
        end
    end

    return nil
end

local function getGroundCoordsFromCamera(cam, ignoreEntity)
    local coords = getCameraRaycast(cam, ignoreEntity, 1, 200.0)
    return coords
end

local function getPlacementHitFromCamera(cam, ignoreEntity)
    local coords, hit, entityHit = getCameraRaycast(cam, ignoreEntity, -1, 200.0)
    if entityHit and entityHit ~= 0 and entityHit ~= ignoreEntity and DoesEntityExist(entityHit) then
        return coords, hit, entityHit
    end

    local capsuleCoords, capsuleHit, capsuleEntity = getCameraCapsuleHit(cam, ignoreEntity, -1, 200.0, 0.65)
    if capsuleEntity and capsuleEntity ~= 0 and capsuleEntity ~= ignoreEntity and DoesEntityExist(capsuleEntity) then
        return capsuleCoords or coords, capsuleHit or hit, capsuleEntity
    end

    if hit then
        local vehicle = getClosestVehicleAtPoint(coords, 2.5, ignoreEntity)
        if vehicle then
            return coords, hit, vehicle
        end
    end

    return coords, hit, nil
end

local function isPedPlacement(placementType)
    return placementType == "ped" or placementType == "npc" or placementType == "cloneped"
end

local function getFallbackGroundOffset()
    return 0.0
end

local function getModelGroundOffset(placementType, model)
    if isPedPlacement(placementType) then return 0.0 end

    local streaming = getStreaming()
    if streaming and streaming.getModelGroundOffset then
        local offset = streaming.getModelGroundOffset(model, 1500)
        if offset then return offset end
    end

    return getFallbackGroundOffset(placementType)
end

local function getFallbackModelDimensions(placementType, entityCentered)
    if placementType == "vehicle" or placementType == "slots" then
        return entityCentered and vector3(-1.45, -2.65, -0.65) or vector3(-1.45, -2.65, 0.0),
            entityCentered and vector3(1.45, 2.65, 1.15) or vector3(1.45, 2.65, 1.8)
    elseif placementType == "ped" or placementType == "npc" or placementType == "cloneped" then
        return entityCentered and vector3(-0.35, -0.35, -1.0) or vector3(-0.35, -0.35, 0.0),
            entityCentered and vector3(0.35, 0.35, 0.85) or vector3(0.35, 0.35, 1.85)
    end

    return entityCentered and vector3(-0.55, -0.55, -0.45) or vector3(-0.55, -0.55, 0.0),
        entityCentered and vector3(0.55, 0.55, 0.75) or vector3(0.55, 0.55, 1.2)
end

local function getWireframeModelDimensions(placementType, model, entityCentered)
    local streaming = getStreaming()
    if streaming and streaming.getModelDimensions and model then
        local minDim, maxDim = streaming.getModelDimensions(model, 1500)
        if minDim and maxDim then
            local width = math.abs((maxDim.x or 0.0) - (minDim.x or 0.0))
            local length = math.abs((maxDim.y or 0.0) - (minDim.y or 0.0))
            local height = math.abs((maxDim.z or 0.0) - (minDim.z or 0.0))

            if width > 0.01 and length > 0.01 and height > 0.01 then
                return minDim, maxDim
            end
        end
    end

    return getFallbackModelDimensions(placementType, entityCentered)
end

local function findGroundZ(coords, ignoreEntity)
    local streaming = getStreaming()
    if streaming and streaming.findGroundZ then
        local groundZ = streaming.findGroundZ(coords, {
            ignoreEntity = ignoreEntity,
            startOffset = 60.0,
            endOffset = -160.0,
            fallbackOffset = 1000.0,
        })

        if groundZ then return groundZ end
    end

    local startZ = coords.z + 60.0
    local endZ = coords.z - 160.0
    local rayHandle = StartShapeTestRay(
        coords.x,
        coords.y,
        startZ,
        coords.x,
        coords.y,
        endZ,
        1,
        ignoreEntity or -1,
        0
    )

    local _, hit, endCoords = GetShapeTestResult(rayHandle)
    if hit == 1 or hit == true then
        return endCoords.z
    end

    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1000.0, false)
    if found then return groundZ end

    return coords.z
end

local function pedAlignedCoords(coords, heightOffset, ignoreEntity, supportEntity, useSurfaceHit)
    local supportIsEntity = supportEntity and supportEntity ~= 0 and supportEntity ~= ignoreEntity and DoesEntityExist(supportEntity)
    local groundZ = (supportIsEntity or useSurfaceHit) and coords.z or findGroundZ(coords, ignoreEntity)

    return vector3(
        coords.x,
        coords.y,
        groundZ + (tonumber(heightOffset) or 0.0)
    ), groundZ, 0.0, supportIsEntity
end

local function groundAlignedCoords(coords, placementType, modelHash, heightOffset, ignoreEntity, supportEntity, useSurfaceHit)
    if isPedPlacement(placementType) then
        return pedAlignedCoords(coords, heightOffset, ignoreEntity, supportEntity, useSurfaceHit)
    end

    local supportIsEntity = supportEntity and supportEntity ~= 0 and supportEntity ~= ignoreEntity and DoesEntityExist(supportEntity)
    local groundZ = (supportIsEntity or useSurfaceHit) and coords.z or findGroundZ(coords, ignoreEntity)
    local modelOffset = getModelGroundOffset(placementType, modelHash)

    return vector3(
        coords.x,
        coords.y,
        groundZ + modelOffset + (tonumber(heightOffset) or 0.0)
    ), groundZ, modelOffset, supportIsEntity
end

local function pointGroundCoords(coords, heightOffset, ignoreEntity)
    local groundZ = findGroundZ(coords, ignoreEntity)
    return vector3(coords.x, coords.y, groundZ + (tonumber(heightOffset) or 0.0)), groundZ
end

local function setEntityOutline(entity, enabled)
    return entity, enabled
end

local function updateOutlinedEntity(currentEntity, nextEntity)
    if currentEntity == nextEntity then return currentEntity end

    if currentEntity and currentEntity ~= 0 then
        setEntityOutline(currentEntity, false)
    end

    if nextEntity and nextEntity ~= 0 and DoesEntityExist(nextEntity) then
        setEntityOutline(nextEntity, true)
        return nextEntity
    end

    return nil
end

local function drawModelWireframeAtCoords(placementType, coords, heading, r, g, b, a, entityCentered, model)
    if not coords then return end

    local minDim, maxDim = getWireframeModelDimensions(placementType, model, entityCentered)

    local rad = math.rad(heading or 0.0)
    local cosH = math.cos(rad)
    local sinH = math.sin(rad)

    local function worldPoint(x, y, z)
        return vector3(
            coords.x + (x * cosH - y * sinH),
            coords.y + (x * sinH + y * cosH),
            coords.z + z
        )
    end

    local corners = {
        worldPoint(minDim.x, minDim.y, minDim.z),
        worldPoint(maxDim.x, minDim.y, minDim.z),
        worldPoint(maxDim.x, maxDim.y, minDim.z),
        worldPoint(minDim.x, maxDim.y, minDim.z),
        worldPoint(minDim.x, minDim.y, maxDim.z),
        worldPoint(maxDim.x, minDim.y, maxDim.z),
        worldPoint(maxDim.x, maxDim.y, maxDim.z),
        worldPoint(minDim.x, maxDim.y, maxDim.z),
    }

    local edges = {
        { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 1 },
        { 5, 6 }, { 6, 7 }, { 7, 8 }, { 8, 5 },
        { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
    }

    for i = 1, #edges do
        local edge = edges[i]
        local aPoint = corners[edge[1]]
        local bPoint = corners[edge[2]]

        DrawLine(
            aPoint.x, aPoint.y, aPoint.z,
            bPoint.x, bPoint.y, bPoint.z,
            r or 34, g or 197, b or 94, a or 230
        )
    end
end

local function draw3DWall(p1, p2, height, r, g, b, a)
    local ax, ay, az = p1.x, p1.y, p1.z
    local bx, by, bz = p1.x, p1.y, p1.z + height
    local cx, cy, cz = p2.x, p2.y, p2.z
    local dx, dy, dz = p2.x, p2.y, p2.z + height

    DrawPoly(ax, ay, az, bx, by, bz, dx, dy, dz, r, g, b, a)
    DrawPoly(ax, ay, az, dx, dy, dz, cx, cy, cz, r, g, b, a)
    DrawPoly(ax, ay, az, dx, dy, dz, bx, by, bz, r, g, b, a)
    DrawPoly(ax, ay, az, cx, cy, cz, dx, dy, dz, r, g, b, a)
end

local function drawStatus(text)
    local drawtext = getDrawText()
    if drawtext and drawtext.drawText2d then
        drawtext.drawText2d({
            text = text,
            coords = vec2(0.015, 0.48),
            scale = 0.32,
            font = 4,
            color = vec4(255, 255, 255, 235),
            align = "left",
            wrapLeft = 0.015,
            wrapRight = 0.55,
            enableOutline = true,
        })
    end
end

local function controlButton(controlId, inputGroup)
    return GetControlInstructionalButton(inputGroup or 0, controlId, true)
end

local function createButtons(buttons)
    local buttonsApi = getButtons()
    if not buttonsApi or not buttonsApi.create then return nil end

    return buttonsApi.create(buttons, {
        clickable = false,
        drawMode = 0,
        timeout = 1000,
    })
end

local function disposeButtons(buttonInstance)
    if buttonInstance and buttonInstance.dispose then
        buttonInstance:dispose()
    end
end

local function isControlJustPressedAnyGroup(controlId, inputGroups)
    inputGroups = inputGroups or { 0 }

    for i = 1, #inputGroups do
        local inputGroup = inputGroups[i]
        if IsDisabledControlJustPressed(inputGroup, controlId) or IsControlJustPressed(inputGroup, controlId) then
            return true
        end
    end

    return false
end

local function isControlPressedAnyGroup(controlId, inputGroups)
    inputGroups = inputGroups or { 0 }

    for i = 1, #inputGroups do
        local inputGroup = inputGroups[i]
        if IsDisabledControlPressed(inputGroup, controlId) or IsControlPressed(inputGroup, controlId) then
            return true
        end
    end

    return false
end

local function consumeHoldControl(controlId, nextAt, initialDelay, repeatDelay, inputGroups)
    local now = GetGameTimer()

    if isControlJustPressedAnyGroup(controlId, inputGroups) then
        return true, now + initialDelay
    end

    if isControlPressedAnyGroup(controlId, inputGroups) and now >= nextAt then
        return true, now + repeatDelay
    end

    return false, nextAt
end

local function startEditorCamera(playerPed, options)
    local editorCamera = getEditorCamera()

    if not editorCamera or type(editorCamera.startFreecam) ~= "function" then
        debug("error", "[pr_bridge:devtools] editorCamera.startFreecam indisponivel.")
        return nil
    end

    options = options or {}
    options.playerPed = playerPed

    return editorCamera.startFreecam(options)
end

local function updateEditorCamera(cam, rotX, rotZ, moveSpeed)
    if type(cam) == "table" then
        local editorCamera = getEditorCamera()
        if editorCamera and type(editorCamera.updateFreecam) == "function" then
            editorCamera.updateFreecam(cam, moveSpeed)
            return cam.rotX, cam.rotZ
        end
    end

    return rotX, rotZ
end

local function cleanupCamera(cam, playerPed, frozen)
    if type(cam) == "table" then
        local editorCamera = getEditorCamera()
        if editorCamera and type(editorCamera.stopFreecam) == "function" then
            editorCamera.stopFreecam(cam)
        end
    elseif cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
    end

    if frozen and playerPed and DoesEntityExist(playerPed) then
        FreezeEntityPosition(playerPed, false)
    end
end

local function deleteEntity(entity, previewEntities)
    if not entity or entity == 0 then return false end
    if previewEntities and not previewEntities[entity] then return false end

    debug("info", ("[pr_bridge:devtools] deletando ghost registrado entity=%s"):format(tostring(entity)))

    local streaming = getStreaming()
    local deleted = false
    if streaming and streaming.deleteEntity then
        deleted = streaming.deleteEntity(entity)
    elseif entity and entity ~= 0 and DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
        deleted = true
    end

    if previewEntities then
        previewEntities[entity] = nil
    end

    return deleted
end

local function createPreviewEntity(placementType, modelName, coords, heading, options)
    options = options or {}
    if not coords then return nil end

    local createCoords = options.createCoords or coords
    local loaded, modelHash = requestPlacementModel(modelName, options.modelTimeout or options.timeout or 3000)
    if not loaded then return nil end

    local entity
    local ok, result = pcall(function()
        if placementType == "vehicle" or placementType == "slots" then
            return CreateVehicle(modelHash, createCoords.x, createCoords.y, createCoords.z, heading or 0.0, false, false)
        elseif isPedPlacement(placementType) then
            return CreatePed(options.pedType or 4, modelHash, createCoords.x, createCoords.y, createCoords.z, heading or 0.0, false, false)
        end

        return CreateObjectNoOffset(modelHash, createCoords.x, createCoords.y, createCoords.z, false, false, false)
    end)

    if ok then entity = result end

    if entity and entity ~= 0 and DoesEntityExist(entity) then
        pcall(function() SetEntityHeading(entity, heading or 0.0) end)
        pcall(function() SetEntityAlpha(entity, tonumber(options.alpha) or 150, false) end)
        pcall(function() SetEntityCollision(entity, options.collision == true, options.keepPhysics == true) end)
        pcall(function() SetEntityInvincible(entity, options.invincible ~= false) end)
        pcall(function() FreezeEntityPosition(entity, options.freeze ~= false) end)

        if isPedPlacement(placementType) then
            pcall(function() SetBlockingOfNonTemporaryEvents(entity, options.blockingEvents ~= false) end)
        end

        if createCoords.x ~= coords.x or createCoords.y ~= coords.y or createCoords.z ~= coords.z then
            if isPedPlacement(placementType) then
                pcall(function() SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false) end)
            else
                pcall(function() SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z, false, false, false) end)
            end
            pcall(function() SetEntityHeading(entity, heading or 0.0) end)
        end

        if options.releaseModel ~= false then
            pcall(function() SetModelAsNoLongerNeeded(modelHash) end)
        end

        return entity
    end

    debug("warn", ("[pr_bridge:devtools] Falha ao criar ghost local model=%s type=%s"):format(tostring(modelName), tostring(placementType)))

    return nil
end

local function updatePreviewEntity(entity, coords, heading, placementType, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    options = options or {}
    local streaming = getStreaming()
    local noOffset = options.noOffset
    if noOffset == nil then
        noOffset = not isPedPlacement(placementType)
    end

    if streaming and streaming.setEntityTransform then
        streaming.setEntityTransform(entity, coords, heading, {
            noOffset = noOffset,
            placeProperly = options.placeProperly == true,
            placementType = placementType,
            restoreCollision = options.restoreCollision,
            restoreFreeze = options.restoreFreeze,
        })
    else
        if noOffset then
            SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z, false, false, false)
        else
            SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        end
        SetEntityHeading(entity, heading or 0.0)
    end

    return true
end

local function getPlacementIndexByEntity(sessionGhosts, entity, previewEntities)
    if not entity or entity == 0 then return nil end
    if previewEntities and not previewEntities[entity] then return nil end

    for i = 1, #sessionGhosts do
        if sessionGhosts[i] == entity then
            return i
        end
    end

    return nil
end

local function getClosestPlacementIndex(points, coords, maxDistance)
    if not coords then return nil end

    local closestIndex
    local closestDistance = tonumber(maxDistance) or 2.5

    for i = 1, #points do
        local point = points[i]
        if point then
            local dx = (point.x or 0.0) - coords.x
            local dy = (point.y or 0.0) - coords.y
            local dz = (point.z or 0.0) - coords.z
            local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

            if distance <= closestDistance then
                closestDistance = distance
                closestIndex = i
            end
        end
    end

    return closestIndex
end

local function removePlacementAt(points, sessionGhosts, index, previewEntities)
    if not index or index < 1 or index > #points then return false end

    local entity = sessionGhosts[index]
    if entity and entity ~= 0 then
        deleteEntity(entity, previewEntities)
    end

    table.remove(points, index)
    if #sessionGhosts >= index then
        table.remove(sessionGhosts, index)
    end

    return true
end

local function formatPlacement(coords, heading, modelName, placementType, heightOffset, groundZ, supportEntity, supportIsEntity)
    return {
        x = round(coords.x, 2),
        y = round(coords.y, 2),
        z = round(coords.z, 2),
        heading = round(heading, 2),
        model = modelName,
        type = placementType,
        heightOffset = round(heightOffset or 0.0, 3),
        groundZ = groundZ and round(groundZ, 3) or nil,
        support = supportIsEntity and "entity" or "ground",
        supportEntity = supportIsEntity and supportEntity or nil,
    }
end

function devtools.stop()
    if not activeSession then return false end
    activeSession.active = false
    return true
end

function devtools.drawPolyzone3D(options, cb)
    if type(options) == "function" then
        cb = options
        options = {}
    end

    options = options or {}
    cb = cb or options.callback

    if activeSession then
        debug("warn", "[pr_bridge:devtools] Ja existe uma ferramenta ativa.")
        return false
    end

    local playerPed = PlayerPedId()
    local freezePlayer = options.freezePlayer ~= false
    local points = {}
    local buttonInstance = createButtons({
        { label = "Add", control = controlButton(24), controlId = 24, inputGroup = 0 },
        { label = "Undo", control = controlButton(25), controlId = 25, inputGroup = 0 },
        { label = "Save", control = controlButton(191), controlId = 191, inputGroup = 0 },
        { label = "Cancel", control = controlButton(177), controlId = 177, inputGroup = 0 },
        { label = "Move", control = controlButton(32), controlId = 32, inputGroup = 0 },
        { label = "Up", control = controlButton(38), controlId = 38, inputGroup = 0 },
        { label = "Down", control = controlButton(44), controlId = 44, inputGroup = 0 },
    })

    if freezePlayer then FreezeEntityPosition(playerPed, true) end

    local cam, rotX, rotZ = startEditorCamera(playerPed, options)
    if not cam then
        if freezePlayer then FreezeEntityPosition(playerPed, false) end
        disposeButtons(buttonInstance)
        if cb then cb(nil) end
        return false
    end

    local moveSpeed = tonumber(options.moveSpeed) or 0.6
    local wallHeight = tonumber(options.wallHeight) or 2.5
    local minPoints = tonumber(options.minPoints) or 3

    activeSession = { active = true, type = "polyzone" }
    debug("info", "[pr_bridge:devtools] drawPolyzone3D iniciado.")

    CreateThread(function()
        local result

        while activeSession and activeSession.active do
            Wait(0)

            rotX, rotZ = updateEditorCamera(cam, rotX, rotZ, moveSpeed)
            local targetCoords = getGroundCoordsFromCamera(cam)
            local count = #points

            DrawMarker(28, targetCoords.x, targetCoords.y, targetCoords.z + 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 180, false, false, 2, false, nil, nil, false)

            for i = 1, count do
                local point = points[i]
                DrawMarker(28, point.x, point.y, point.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 200, false, false, 2, false, nil, nil, false)

                local nextPoint = points[i + 1]
                if not nextPoint and count >= minPoints then
                    nextPoint = points[1]
                elseif not nextPoint then
                    nextPoint = targetCoords
                end

                if nextPoint then
                    local r, g, b, a = 0, 255, 0, 150
                    if nextPoint == targetCoords then
                        r, g, b, a = 255, 0, 0, 100
                    end

                    draw3DWall(point, nextPoint, wallHeight, r, g, b, a)
                    for h = 0, 3 do
                        local offsetZ = (wallHeight / 3) * h
                        DrawLine(point.x, point.y, point.z + offsetZ, nextPoint.x, nextPoint.y, nextPoint.z + offsetZ, r, g, b, 200)
                    end
                end
            end

            drawStatus(("Polyzone points: %s | LMB add | RMB undo | ENTER save | BACKSPACE cancel"):format(count))
            if buttonInstance and buttonInstance.draw then buttonInstance:draw() end

            local leftClicked = IsDisabledControlJustPressed(0, 24)
            local rightClicked = IsDisabledControlJustPressed(0, 25)

            if leftClicked then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                points[#points + 1] = {
                    x = round(targetCoords.x, 2),
                    y = round(targetCoords.y, 2),
                    z = round(targetCoords.z, 2),
                }
            elseif rightClicked and #points > 0 then
                PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                table.remove(points, #points)
            end

            if IsDisabledControlJustPressed(0, 191) and not leftClicked then
                if #points >= minPoints then
                    result = points
                    PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    activeSession.active = false
                else
                    debug("warn", ("[pr_bridge:devtools] Polyzone precisa de ao menos %s pontos."):format(minPoints))
                end
            elseif IsDisabledControlJustPressed(0, 177) and not rightClicked then
                PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                activeSession.active = false
            end
        end

        cleanupCamera(cam, playerPed, freezePlayer)
        disposeButtons(buttonInstance)
        activeSession = nil

        if cb then cb(result) end
        debug(result and "success" or "info", ("[pr_bridge:devtools] drawPolyzone3D finalizado. points=%s"):format(result and #result or 0))
    end)

    return true
end

function devtools.drawSphereZone3D(options, cb)
    if type(options) == "function" then
        cb = options
        options = {}
    end

    options = options or {}
    cb = cb or options.callback

    if activeSession then
        debug("warn", "[pr_bridge:devtools] Ja existe uma ferramenta ativa.")
        return false
    end

    local playerPed = PlayerPedId()
    local freezePlayer = options.freezePlayer ~= false
    local buttonInstance = createButtons({
        { label = "Set", control = controlButton(24), controlId = 24, inputGroup = 0 },
        { label = "Move", control = controlButton(25), controlId = 25, inputGroup = 0 },
        { label = "Save", control = controlButton(191), controlId = 191, inputGroup = 0 },
        { label = "Cancel", control = controlButton(177), controlId = 177, inputGroup = 0 },
        { label = "Radius+", control = controlButton(241), controlId = 241, inputGroup = 0 },
        { label = "Radius-", control = controlButton(242), controlId = 242, inputGroup = 0 },
        { label = "Ground", control = controlButton(47), controlId = 47, inputGroup = 0 },
    })

    if freezePlayer then FreezeEntityPosition(playerPed, true) end

    local cam, rotX, rotZ = startEditorCamera(playerPed, options)
    if not cam then
        if freezePlayer then FreezeEntityPosition(playerPed, false) end
        disposeButtons(buttonInstance)
        if cb then cb(nil) end
        return false
    end

    local moveSpeed = tonumber(options.moveSpeed) or 0.6
    local radius = tonumber(options.radius) or 2.0
    local minRadius = tonumber(options.minRadius) or 0.25
    local maxRadius = tonumber(options.maxRadius) or 200.0
    local radiusStep = tonumber(options.radiusStep) or 0.25
    local heightOffset = tonumber(options.heightOffset) or 0.0
    local centerLocked = false
    local centerCoords = nil

    activeSession = { active = true, type = "spherezone" }
    debug("info", "[pr_bridge:devtools] drawSphereZone3D iniciado.")

    CreateThread(function()
        local result

        while activeSession and activeSession.active do
            Wait(0)

            rotX, rotZ = updateEditorCamera(cam, rotX, rotZ, moveSpeed)

            if IsDisabledControlJustPressed(0, 241) then
                radius = math.min(maxRadius, radius + radiusStep)
            elseif IsDisabledControlJustPressed(0, 242) then
                radius = math.max(minRadius, radius - radiusStep)
            elseif IsDisabledControlJustPressed(0, 47) then
                heightOffset = 0.0
                if centerCoords then
                    centerCoords = pointGroundCoords(centerCoords, heightOffset)
                end
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end

            local aimCoords = getGroundCoordsFromCamera(cam)
            local previewCoords = pointGroundCoords(aimCoords, heightOffset)

            if not centerLocked or not centerCoords then
                centerCoords = previewCoords
            end

            DrawMarker(28, centerCoords.x, centerCoords.y, centerCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius * 2.0, radius * 2.0, radius * 2.0, 0, 255, 0, 85, false, false, 2, false, nil, nil, false)
            DrawMarker(1, centerCoords.x, centerCoords.y, centerCoords.z - 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius * 2.0, radius * 2.0, 0.08, 0, 255, 0, 70, false, false, 2, false, nil, nil, false)
            DrawMarker(28, previewCoords.x, previewCoords.y, previewCoords.z + 0.12, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 255, 255, 160, false, false, 2, false, nil, nil, false)

            drawStatus(("Sphere zone | radius: %.2fm | center: %s | LMB set | RMB move | ENTER save"):format(radius, centerLocked and "locked" or "aim"))
            if buttonInstance and buttonInstance.draw then buttonInstance:draw() end

            local leftClicked = IsDisabledControlJustPressed(0, 24)
            local rightClicked = IsDisabledControlJustPressed(0, 25)

            if leftClicked then
                centerCoords = previewCoords
                centerLocked = true
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            elseif rightClicked then
                centerLocked = false
                PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end

            if IsDisabledControlJustPressed(0, 191) and not leftClicked then
                result = {
                    type = "sphere",
                    coords = {
                        x = round(centerCoords.x, 2),
                        y = round(centerCoords.y, 2),
                        z = round(centerCoords.z, 2),
                    },
                    radius = round(radius, 2),
                }
                PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                activeSession.active = false
            elseif IsDisabledControlJustPressed(0, 177) and not rightClicked then
                PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                activeSession.active = false
            end
        end

        cleanupCamera(cam, playerPed, freezePlayer)
        disposeButtons(buttonInstance)
        activeSession = nil

        if cb then cb(result) end
        debug(result and "success" or "info", ("[pr_bridge:devtools] drawSphereZone3D finalizado. radius=%s"):format(result and result.radius or 0))
    end)

    return true
end

function devtools.startEntityPlacement(placementType, modelName, maxSlots, cb, options)
    options = options or {}
    placementType = placementType or options.type or "object"
    modelName = modelName or options.model or (placementType == "vehicle" and "pounder" or placementType == "ped" and "a_m_m_business_01" or "prop_barrel_02a")
    maxSlots = tonumber(maxSlots or options.maxSlots)
    if maxSlots and maxSlots < 0 then maxSlots = 0 end

    local unlimitedSlots = maxSlots == nil or maxSlots == 0
    local singleSlot = maxSlots == 1
    local maxSlotsLabel = unlimitedSlots and "unlimited" or tostring(maxSlots)

    cb = cb or options.callback

    if activeSession then
        debug("warn", "[pr_bridge:devtools] Ja existe uma ferramenta ativa.")
        return false
    end

    local playerPed = PlayerPedId()
    local freezePlayer = options.freezePlayer ~= false
    local modelHash = type(modelName) == "number" and modelName or joaat(modelName)
    local previewEnabled = options.preview ~= false

    if freezePlayer then FreezeEntityPosition(playerPed, true) end

    local cam, rotX, rotZ = startEditorCamera(playerPed, options)
    if not cam then
        if freezePlayer then FreezeEntityPosition(playerPed, false) end
        if cb then cb(nil) end
        return false
    end

    local moveSpeed = tonumber(options.moveSpeed) or 0.6
    local pedCoords = GetEntityCoords(playerPed)
    local spawnCoords = pedCoords + GetEntityForwardVector(playerPed) * 3.0
    local ghostCreateCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 25.0)
    local currentHeading = tonumber(options.heading) or 0.0
    local heightOffset = tonumber(options.heightOffset) or 0.0
    local heightStep = tonumber(options.heightStep) or 0.01
    local heightInitialDelay = tonumber(options.heightInitialDelay) or 180
    local heightRepeatDelay = tonumber(options.heightRepeatDelay) or 55
    local nextHeightUpAt = 0
    local nextHeightDownAt = 0
    local deleteAimDistance = tonumber(options.deleteAimDistance) or 2.5
    local points = {}
    local sessionGhosts = {}
    local previewEntities = {}
    local outlinedEntity = nil
    local ghostEntity = nil
    local buttonInstance = createButtons({
        { label = "Place", control = controlButton(24), controlId = 24, inputGroup = 0 },
        { label = "Undo", control = controlButton(25), controlId = 25, inputGroup = 0 },
        { label = "Save", control = controlButton(191), controlId = 191, inputGroup = 0 },
        { label = "Cancel", control = controlButton(177), controlId = 177, inputGroup = 0 },
        { label = "Z+", control = controlButton(172, 2), controlId = 172, inputGroup = 2 },
        { label = "Z-", control = controlButton(173, 2), controlId = 173, inputGroup = 2 },
        { label = "Ground", control = controlButton(47), controlId = 47, inputGroup = 0 },
        { label = "Del Aim", control = controlButton(348), controlId = 348, inputGroup = 0 },
    })

    if previewEnabled then
        ghostEntity = createPreviewEntity(placementType, modelName, spawnCoords, currentHeading, {
            alpha = options.previewAlpha or 150,
            collision = false,
            freeze = true,
            invincible = true,
            placeProperly = false,
            modelTimeout = options.modelTimeout or 3000,
            createCoords = ghostCreateCoords,
        })
        if ghostEntity then previewEntities[ghostEntity] = true end

        if not ghostEntity then
            debug("warn", ("[pr_bridge:devtools] Preview real indisponivel para model=%s. Usando wireframe."):format(tostring(modelName)))
        end
    end

    local function cleanup()
        outlinedEntity = updateOutlinedEntity(outlinedEntity, nil)

        deleteEntity(ghostEntity, previewEntities)
        for i = 1, #sessionGhosts do
            deleteEntity(sessionGhosts[i], previewEntities)
        end

        cleanupCamera(cam, playerPed, freezePlayer)
        disposeButtons(buttonInstance)
    end

    local function upsertPlacement(index, placed, coords, heading)
        points[index] = placed

        if previewEnabled then
            local staticGhost = sessionGhosts[index]
            if not updatePreviewEntity(staticGhost, coords, heading, placementType, {
                placeProperly = false,
                restoreCollision = false,
                restoreFreeze = true,
            }) then
                staticGhost = createPreviewEntity(placementType, modelName, coords, heading, {
                    alpha = options.staticPreviewAlpha or 105,
                    collision = false,
                    freeze = true,
                    invincible = true,
                    placeProperly = false,
                    modelTimeout = options.modelTimeout or 3000,
                    createCoords = ghostCreateCoords,
                })
                if staticGhost then previewEntities[staticGhost] = true end
                sessionGhosts[index] = staticGhost
            end
        else
            sessionGhosts[index] = nil
        end

        return true
    end

    local function addOrUpdatePlacement(placed, coords, heading)
        if singleSlot then
            upsertPlacement(1, placed, coords, heading)
            return true, 1, "updated"
        end

        if not unlimitedSlots and #points >= maxSlots then
            return false, nil, "limit"
        end

        local index = #points + 1
        upsertPlacement(index, placed, coords, heading)
        return true, index, "added"
    end

    activeSession = { active = true, type = "placement" }
    debug("info", ("[pr_bridge:devtools] startEntityPlacement iniciado type=%s model=%s maxSlots=%s"):format(placementType, tostring(modelName), maxSlotsLabel))

    CreateThread(function()
        local result
        local ok, err = xpcall(function()

        while activeSession and activeSession.active do
            Wait(0)

            rotX, rotZ = updateEditorCamera(cam, rotX, rotZ, moveSpeed)

            if IsDisabledControlJustPressed(0, 15) then
                currentHeading = (currentHeading + 10.0) % 360.0
            elseif IsDisabledControlJustPressed(0, 16) then
                currentHeading = (currentHeading - 10.0) % 360.0
            end

            local heightUp
            local heightDown
            heightUp, nextHeightUpAt = consumeHoldControl(172, nextHeightUpAt, heightInitialDelay, heightRepeatDelay, { 0, 2 })
            heightDown, nextHeightDownAt = consumeHoldControl(173, nextHeightDownAt, heightInitialDelay, heightRepeatDelay, { 0, 2 })

            if heightUp and not heightDown then
                heightOffset = heightOffset + heightStep
            elseif heightDown and not heightUp then
                heightOffset = heightOffset - heightStep
            elseif IsDisabledControlJustPressed(0, 47) then
                heightOffset = 0.0
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end

            local aimCoords, surfaceHit, supportEntity = getPlacementHitFromCamera(cam, ghostEntity)
            local selectedPlacementIndex = getPlacementIndexByEntity(sessionGhosts, supportEntity, previewEntities)
            if not selectedPlacementIndex then
                selectedPlacementIndex = getClosestPlacementIndex(points, aimCoords, deleteAimDistance)
            end

            outlinedEntity = updateOutlinedEntity(outlinedEntity, nil)

            local placementSupportEntity = selectedPlacementIndex and nil or supportEntity
            local placementSurfaceHit = selectedPlacementIndex and false or surfaceHit

            local targetCoords, groundZ, _, supportIsEntity = groundAlignedCoords(
                aimCoords,
                placementType,
                modelHash,
                heightOffset,
                ghostEntity,
                placementSupportEntity,
                placementSurfaceHit
            )

            local previewMoved = updatePreviewEntity(ghostEntity, targetCoords, currentHeading, placementType, {
                placeProperly = false,
                restoreCollision = false,
                restoreFreeze = true,
            })

            if not previewMoved then
                drawModelWireframeAtCoords(placementType, targetCoords, currentHeading, 34, 197, 94, 245, nil, modelHash)
            else
                drawModelWireframeAtCoords(placementType, targetCoords, currentHeading, 34, 197, 94, 135, nil, modelHash)
            end

            if not selectedPlacementIndex and supportIsEntity then
                DrawMarker(28, aimCoords.x, aimCoords.y, aimCoords.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.35, 34, 197, 94, 210, false, false, 2, false, nil, nil, false)
            end

            DrawMarker(1, targetCoords.x, targetCoords.y, targetCoords.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.2, 2.2, 0.45, 147, 51, 234, 120, false, false, 2, false, nil, nil, false)

            for i = 1, #points do
                local point = points[i]
                local r, g, b, a = 34, 197, 94, 170
                if selectedPlacementIndex == i then
                    r, g, b, a = 255, 80, 80, 245
                end

                drawModelWireframeAtCoords(
                    placementType,
                    vector3(point.x, point.y, point.z),
                    point.heading,
                    r, g, b, a,
                    nil,
                    modelHash
                )

                DrawMarker(1, point.x, point.y, point.z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.6, 1.6, 0.35, 34, 197, 94, 100, false, false, 2, false, nil, nil, false)
            end

            local slotsText = unlimitedSlots and ("%s/unlimited"):format(#points) or ("%s/%s"):format(#points, maxSlots)

            drawStatus(("Placement %s | placed: %s | heading: %.2f | zOffset: %.3f | support: %s | middle delete"):format(
                placementType,
                slotsText,
                currentHeading,
                heightOffset,
                selectedPlacementIndex and "saved" or (supportIsEntity and "entity" or "ground")
            ))
            if buttonInstance and buttonInstance.draw then buttonInstance:draw() end

            local leftClicked = IsDisabledControlJustPressed(0, 24)
            local rightClicked = IsDisabledControlJustPressed(0, 25)
            local middleClicked = IsDisabledControlJustPressed(0, 348) or IsControlJustPressed(0, 348)

            if middleClicked and selectedPlacementIndex then
                PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", true)
                removePlacementAt(points, sessionGhosts, selectedPlacementIndex, previewEntities)
                outlinedEntity = updateOutlinedEntity(outlinedEntity, nil)
                debug("info", ("[pr_bridge:devtools] Placement removido por middle button. index=%s remaining=%s"):format(selectedPlacementIndex, #points))
            elseif leftClicked then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                local placed = formatPlacement(targetCoords, currentHeading, modelName, placementType, heightOffset, groundZ, supportEntity, supportIsEntity)

                local added, index, reason = addOrUpdatePlacement(placed, targetCoords, currentHeading)
                if added then
                    debugPlacementJson("item", {
                        action = reason,
                        index = index,
                        type = placementType,
                        model = modelName,
                        data = placed,
                    })
                    debug("info", ("[pr_bridge:devtools] Placement %s. index=%s model=%s support=%s ENTER salva."):format(reason, tostring(index), tostring(modelName), tostring(placed.support)))
                else
                    debug("warn", ("[pr_bridge:devtools] Limite de posicionamentos atingido. maxSlots=%s"):format(maxSlotsLabel))
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                end
            elseif rightClicked and #points > 0 then
                PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                removePlacementAt(points, sessionGhosts, #points, previewEntities)
            end

            if IsDisabledControlJustPressed(0, 191) and not leftClicked then
                if singleSlot then
                    result = points[1] or formatPlacement(targetCoords, currentHeading, modelName, placementType, heightOffset, groundZ, supportEntity, supportIsEntity)
                    debugPlacementJson("save", {
                        action = "save",
                        type = placementType,
                        model = modelName,
                        count = result and 1 or 0,
                        data = result,
                    })
                    activeSession.active = false
                elseif #points > 0 then
                    result = points
                    debugPlacementJson("save", {
                        action = "save",
                        type = placementType,
                        model = modelName,
                        count = #points,
                        data = result,
                    })
                    activeSession.active = false
                else
                    debug("warn", "[pr_bridge:devtools] Posicione pelo menos um item antes de salvar.")
                end
            elseif IsDisabledControlJustPressed(0, 177) and not rightClicked then
                PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                activeSession.active = false
            end
        end
        end, function(err)
            return tostring(err)
        end)

        cleanup()
        activeSession = nil

        if not ok then
            debug("error", ("[pr_bridge:devtools] startEntityPlacement erro tratado: %s"):format(tostring(err)))
            if cb then cb(nil) end
            return
        end

        if cb then cb(result) end
        debug(result and "success" or "info", ("[pr_bridge:devtools] startEntityPlacement finalizado type=%s"):format(placementType))
    end)

    return true
end

function devtools.placeVehicle(modelName, maxSlots, cb, options)
    return devtools.startEntityPlacement("vehicle", modelName or "pounder", maxSlots, cb, options)
end

function devtools.placePed(modelName, maxSlots, cb, options)
    return devtools.startEntityPlacement("ped", modelName or "a_m_m_business_01", maxSlots, cb, options)
end

function devtools.placeObject(modelName, maxSlots, cb, options)
    return devtools.startEntityPlacement("object", modelName or "prop_barrel_02a", maxSlots, cb, options)
end

devtools.DrawPolyzone3D = devtools.drawPolyzone3D
devtools.DrawSphereZone3D = devtools.drawSphereZone3D
devtools.StartEntityPlacement = devtools.startEntityPlacement
devtools.createPolyzone = devtools.drawPolyzone3D
devtools.createSphereZone = devtools.drawSphereZone3D
devtools.drawSphereZone = devtools.drawSphereZone3D
devtools.createPlacement = devtools.startEntityPlacement

if _G then
    _G.PRBridgeDevTools = devtools
end

return devtools
