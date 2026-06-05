local DevLaser = {}

local RelationshipTypes = {
    [0] = "Companion",
    [1] = "Respect",
    [2] = "Like",
    [3] = "Neutral",
    [4] = "Dislike",
    [5] = "Hate",
    [255] = "Pedestrians",
}

local state = {
    active = false,
    threadRunning = false,
    suspended = false,
    gizmoActive = false,
    options = {},
    target = nil,
    buttonInstance = nil,
    frozen = {},
}

local function bridgeDebug(level, message)
    local debugApi = Bridge and Bridge.debug
    if not debugApi then return end

    local fn = debugApi[level]
    if type(fn) == "function" then
        fn(message)
    elseif type(debugApi) == "function" then
        debugApi(level, message)
    end
end

local function getDrawText()
    return PRDrawText
        or (Bridge and Bridge.fivem and (Bridge.fivem.drawtext or Bridge.fivem.drawText))
end

local function getInstructionalButtons()
    return PRInstructionalButtons
        or (Bridge and Bridge.fivem and (Bridge.fivem.instructionalButtons or Bridge.fivem.buttons))
end

local function getGizmo()
    return PRGizmo
        or (Bridge and Bridge.fivem and Bridge.fivem.gizmo)
end

local function round(value, digits)
    value = tonumber(value) or 0.0
    digits = tonumber(digits) or 2

    local mult = 10 ^ digits
    return math.floor(value * mult + 0.5) / mult
end

local function numberText(value, digits)
    return string.format(("%0." .. (digits or 2) .. "f"), tonumber(value) or 0.0)
end

local function vectorText(value, digits)
    digits = digits or 3
    if not value then return "0.000, 0.000, 0.000" end

    return ("%." .. digits .. "f, %." .. digits .. "f, %." .. digits .. "f"):format(
        tonumber(value.x) or 0.0,
        tonumber(value.y) or 0.0,
        tonumber(value.z) or 0.0
    )
end

local function vec3Text(value, digits)
    return ("vec3(%s)"):format(vectorText(value, digits or 3))
end

local function vec4Text(coords, heading, digits)
    digits = digits or 3
    coords = coords or vector3(0.0, 0.0, 0.0)

    return ("vec4(%s, %." .. digits .. "f)"):format(
        vectorText(coords, digits),
        tonumber(heading) or 0.0
    )
end

local function rawVec4Text(coords, heading, digits)
    digits = digits or 3
    coords = coords or vector3(0.0, 0.0, 0.0)

    return ("%s, %." .. digits .. "f"):format(
        vectorText(coords, digits),
        tonumber(heading) or 0.0
    )
end

local function isValidCoords(coords)
    if not coords or coords.x == nil or coords.y == nil or coords.z == nil then return false end

    local x = tonumber(coords.x) or 0.0
    local y = tonumber(coords.y) or 0.0
    local z = tonumber(coords.z) or 0.0

    return math.abs(x) > 0.001 or math.abs(y) > 0.001 or math.abs(z) > 0.001
end

local function entityExists(entity)
    return entity and entity ~= 0 and DoesEntityExist(entity)
end

local function getPedRelationshipType(value)
    return RelationshipTypes[tonumber(value) or -1] or "Unknown"
end

local function labelText(label, value)
    return ("~b~%s:~s~ %s"):format(label, value == nil and "N/A" or tostring(value))
end

local function rotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z,
    }

    return {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x),
    }
end

local function rayCastGamePlayCamera(distance)
    local currentRenderingCam = false
    if not IsGameplayCamRendering() then
        currentRenderingCam = GetRenderingCam()
    end

    local cameraRotation = not currentRenderingCam and GetGameplayCamRot() or GetCamRot(currentRenderingCam, 2)
    local cameraCoord = not currentRenderingCam and GetGameplayCamCoord() or GetCamCoord(currentRenderingCam)
    local direction = rotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance,
    }

    local _, hit, coords, _, entity = GetShapeTestResult(StartShapeTestRay(
        cameraCoord.x,
        cameraCoord.y,
        cameraCoord.z,
        destination.x,
        destination.y,
        destination.z,
        -1,
        PlayerPedId(),
        0
    ))

    return hit, coords, entity, cameraCoord, destination
end

local function canUseEntity(entity)
    if not entityExists(entity) then return false end
    if entity == PlayerPedId() then return false end

    return IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)
end

local function getEntityTypeName(entity)
    if not entityExists(entity) then return "none" end

    local entityType = GetEntityType(entity)
    if entityType == 1 then
        return IsPedAPlayer(entity) and "player" or "ped"
    end

    if entityType == 2 then return "vehicle" end
    if entityType == 3 then return "object" end

    if IsEntityAVehicle(entity) then return "vehicle" end
    if IsEntityAPed(entity) then return IsPedAPlayer(entity) and "player" or "ped" end
    if IsEntityAnObject(entity) then return "object" end

    return "entity"
end

local function getEntityName(entity, modelHash, entityType)
    local entities = rawget(_G, "Entities")
    local mappedName = type(entities) == "table" and entities[modelHash] or nil
    local archetype = GetEntityArchetypeName and GetEntityArchetypeName(entity) or nil

    if mappedName then return mappedName end
    if archetype and archetype ~= "" then return archetype end

    if entityType == "vehicle" then
        local display = GetDisplayNameFromVehicleModel(modelHash)
        local label = display and display ~= "" and GetLabelText(display) or nil

        if label and label ~= "" and label ~= "NULL" then return label end
        if display and display ~= "" then return display end
    end

    return "Unknown"
end

local function getNetworkData(entity)
    local networked = NetworkGetEntityIsNetworked(entity)
    local netId = networked and NetworkGetNetworkIdFromEntity(entity) or nil
    local ownerPlayer = networked and NetworkGetEntityOwner(entity) or nil
    local ownerServerId

    if type(ownerPlayer) == "number" and ownerPlayer >= 0 then
        ownerServerId = GetPlayerServerId(ownerPlayer)
    end

    return networked, netId, ownerPlayer, ownerServerId
end

local function buildEntityData(entity, hitCoords)
    if not canUseEntity(entity) then return nil end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local coords = GetEntityCoords(entity)
    local rotation = GetEntityRotation(entity, 2)
    local velocity = GetEntityVelocity(entity)
    local modelHash = GetEntityModel(entity)
    local entityType = getEntityTypeName(entity)
    local name = getEntityName(entity, modelHash, entityType)
    local networked, netId, ownerPlayer, ownerServerId = getNetworkData(entity)
    local distance = #(playerCoords - (hitCoords or coords))
    local frozen = IsEntityPositionFrozen(entity)

    local data = {
        entity = entity,
        type = entityType,
        modelHash = modelHash,
        model = modelHash,
        name = name,
        coords = coords,
        hitCoords = hitCoords,
        rotation = rotation,
        velocity = velocity,
        heading = GetEntityHeading(entity),
        distance = distance,
        health = GetEntityHealth(entity),
        maxHealth = GetEntityMaxHealth(entity),
        speedKmh = GetEntitySpeed(entity) * 3.6,
        speedMph = GetEntitySpeed(entity) * 2.23694,
        frozen = frozen,
        networked = networked,
        netId = netId,
        entityOwner = ownerPlayer,
        ownerPlayer = ownerPlayer,
        ownerServerId = ownerServerId,
    }

    if entityType == "ped" or entityType == "player" then
        local relationGroup = GetPedRelationshipGroupHash(entity)
        data.ped = {
            armour = GetPedArmour(entity),
            maxHealth = GetPedMaxHealth(entity),
            relationGroup = relationGroup,
            relationToPlayer = getPedRelationshipType(GetRelationshipBetweenPeds(relationGroup, PlayerPedId())),
        }
    elseif entityType == "vehicle" then
        data.vehicle = {
            plate = GetVehicleNumberPlateText(entity),
            rpm = GetVehicleCurrentRpm(entity),
            gear = GetVehicleCurrentGear(entity),
            acceleration = GetVehicleAcceleration(entity),
            bodyHealth = GetVehicleBodyHealth(entity),
            engineHealth = GetVehicleEngineHealth(entity),
        }
    end

    return data
end

local function drawEntityBoundingBox(entity, color)
    if not canUseEntity(entity) then return end

    local model = GetEntityModel(entity)
    local minDim, maxDim = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    local dim = {
        x = 0.5 * (maxDim.x - minDim.x),
        y = 0.5 * (maxDim.y - minDim.y),
        z = 0.5 * (maxDim.z - minDim.z),
    }

    local FUR = {
        x = position.x + dim.y * rightVector.x + dim.x * forwardVector.x + dim.z * upVector.x,
        y = position.y + dim.y * rightVector.y + dim.x * forwardVector.y + dim.z * upVector.y,
        z = 0,
    }

    local _, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z + 2 * dim.z

    local BLL = {
        x = position.x - dim.y * rightVector.x - dim.x * forwardVector.x - dim.z * upVector.x,
        y = position.y - dim.y * rightVector.y - dim.x * forwardVector.y - dim.z * upVector.y,
        z = 0,
    }

    local _, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    local edge1 = BLL
    local edge5 = FUR

    local edge2 = {
        x = edge1.x + 2 * dim.y * rightVector.x,
        y = edge1.y + 2 * dim.y * rightVector.y,
        z = edge1.z + 2 * dim.y * rightVector.z,
    }

    local edge3 = {
        x = edge2.x + 2 * dim.z * upVector.x,
        y = edge2.y + 2 * dim.z * upVector.y,
        z = edge2.z + 2 * dim.z * upVector.z,
    }

    local edge4 = {
        x = edge1.x + 2 * dim.z * upVector.x,
        y = edge1.y + 2 * dim.z * upVector.y,
        z = edge1.z + 2 * dim.z * upVector.z,
    }

    local edge6 = {
        x = edge5.x - 2 * dim.y * rightVector.x,
        y = edge5.y - 2 * dim.y * rightVector.y,
        z = edge5.z - 2 * dim.y * rightVector.z,
    }

    local edge7 = {
        x = edge6.x - 2 * dim.z * upVector.x,
        y = edge6.y - 2 * dim.z * upVector.y,
        z = edge6.z - 2 * dim.z * upVector.z,
    }

    local edge8 = {
        x = edge5.x - 2 * dim.z * upVector.x,
        y = edge5.y - 2 * dim.z * upVector.y,
        z = edge5.z - 2 * dim.z * upVector.z,
    }

    color = color or { r = 255, g = 255, b = 255, a = 255 }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

local function drawLaserSphere(coords, color)
    if not isValidCoords(coords) then return end

    DrawMarker(
        28,
        coords.x,
        coords.y,
        coords.z,
        0.0,
        0.0,
        0.0,
        0.0,
        180.0,
        0.0,
        0.10,
        0.10,
        0.10,
        color.r,
        color.g,
        color.b,
        color.a,
        false,
        true,
        2,
        nil,
        nil,
        false,
        false
    )
end

local function buildInfoPanelRows(data)
    if not data then return nil end

    return {
        leftTop = {
            { label = "model", value = data.name or "Unknown" },
            { label = "hash", value = data.modelHash or "N/A" },
        },
        leftBottom = {
            { label = "entity Id", value = data.entity or "N/A" },
            { label = "net Id", value = data.netId or "N/A" },
            { label = "entity owned", value = data.ownerServerId or data.ownerPlayer or "N/A" },
            { label = "health", value = ("%s/%s"):format(data.health or "N/A", data.maxHealth or "N/A") },
        },
        rightTop = {
            { label = "Coord vec3", value = vectorText(data.coords, 3) },
            { label = "Coord vec4", value = rawVec4Text(data.coords, data.heading, 3) },
        },
        rightBottom = {
            { label = "Rotation vec3", value = vectorText(data.rotation, 3) },
            { label = "Heading", value = numberText(data.heading, 2) },
            { label = "velocity", value = ("%s km/h | %s mp/h"):format(numberText(data.speedKmh, 1), numberText(data.speedMph, 1)) },
            { label = "Distance", value = ("%sm"):format(numberText(data.distance, 2)) },
        },
    }
end

local function rowsToColumns(rows)
    local labels = {}
    local values = {}

    for i = 1, #(rows or {}) do
        labels[#labels + 1] = ("~b~%s:~s~"):format(rows[i].label)
        values[#values + 1] = tostring(rows[i].value == nil and "N/A" or rows[i].value)
    end

    return table.concat(labels, "\n"), table.concat(values, "\n")
end

local function buildInfoPanels(data)
    local rows = buildInfoPanelRows(data)
    if not rows then return nil end

    local function rowsToText(section)
        local lines = {}

        for i = 1, #(section or {}) do
            lines[#lines + 1] = labelText(section[i].label, section[i].value)
        end

        return table.concat(lines, "\n")
    end

    local left = ("%s\n%s"):format(rowsToText(rows.leftTop), rowsToText(rows.leftBottom))
    local right = ("%s\n%s"):format(rowsToText(rows.rightTop), rowsToText(rows.rightBottom))

    return left, right
end

local function cleanText(text)
    if not text then return "" end

    return tostring(text)
        :gsub("~[a-zA-Z0-9]~", "")
        :gsub("~s~", "")
end

local function drawTextAtHit(coords, text, color)
    if not text or not isValidCoords(coords) then return end

    local drawtext = getDrawText()
    local textCoords = vec3(coords.x, coords.y, coords.z + 0.18)
    color = color or vec4(255, 255, 255, 235)

    if drawtext and drawtext.drawText3d then
        drawtext.drawText3d({
            text = text,
            coords = textCoords,
            scale = 0.28,
            font = 4,
            color = color,
            enableOutline = true,
            align = "center",
            drawRect = false,
        })
        return
    end

    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextColour(color.r or color.x or 255, color.g or color.y or 255, color.b or color.z or 255, color.a or color.w or 235)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(textCoords.x, textCoords.y, textCoords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function drawHitText(coords)
    drawTextAtHit(coords, vec3Text(coords, 3), vec4(255, 255, 255, 235))
end

local function drawScreenText(text, coords, align, wrapLeft, wrapRight, scale)
    if not text then return end

    local drawtext = getDrawText()
    scale = scale or 0.34

    if drawtext and drawtext.drawText2d then
        drawtext.drawText2d({
            text = text,
            coords = coords,
            scale = scale,
            font = 4,
            color = vec4(255, 255, 255, 235),
            enableOutline = true,
            align = align,
            wrapLeft = wrapLeft,
            wrapRight = wrapRight,
            width = 0.0,
            height = 0.0,
        })
        return
    end

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 235)
    SetTextOutline()

    if align == "right" then
        SetTextCentre(false)
        SetTextJustification(2)
        SetTextWrap(wrapLeft or 0.55, wrapRight or 0.985)
    else
        SetTextCentre(false)
        SetTextJustification(1)
        SetTextWrap(wrapLeft or 0.015, wrapRight or 0.45)
    end

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(coords.x, coords.y)
end

local function drawEntityInfoPanels(data)
    local rows = buildInfoPanelRows(data)
    if not rows then return end

    local leftLabelsTop, leftValuesTop = rowsToColumns(rows.leftTop)
    local leftLabelsBottom, leftValuesBottom = rowsToColumns(rows.leftBottom)
    local rightLabelsTop, rightValuesTop = rowsToColumns(rows.rightTop)
    local rightLabelsBottom, rightValuesBottom = rowsToColumns(rows.rightBottom)

    local scale = 0.34

    drawScreenText(leftLabelsTop, vec2(0.015, 0.045), "left", 0.015, 0.18, scale)
    drawScreenText(leftValuesTop, vec2(0.485, 0.045), "right", 0.18, 0.485, scale)
    drawScreenText(leftLabelsBottom, vec2(0.015, 0.105), "left", 0.015, 0.18, scale)
    drawScreenText(leftValuesBottom, vec2(0.485, 0.105), "right", 0.18, 0.485, scale)

    drawScreenText(rightLabelsTop, vec2(0.55, 0.045), "left", 0.55, 0.69, scale)
    drawScreenText(rightValuesTop, vec2(0.985, 0.045), "right", 0.69, 0.985, scale)
    drawScreenText(rightLabelsBottom, vec2(0.55, 0.105), "left", 0.55, 0.69, scale)
    drawScreenText(rightValuesBottom, vec2(0.985, 0.105), "right", 0.69, 0.985, scale)
end

local function controlButton(controlId, inputGroup)
    return GetControlInstructionalButton(inputGroup or 0, controlId, true)
end

local function disposeButtons()
    if state.buttonInstance and state.buttonInstance.dispose then
        state.buttonInstance:dispose()
    end

    state.buttonInstance = nil
end

local function ensureButtons()
    if state.buttonInstance then return state.buttonInstance end

    local buttonsApi = getInstructionalButtons()
    if not buttonsApi or not buttonsApi.create then return nil end

    state.buttonInstance = buttonsApi.create({
        { label = "Delete", control = controlButton(38), controlId = 38, inputGroup = 0 },
        { label = "Freeze", control = controlButton(47), controlId = 47, inputGroup = 0 },
        { label = "Move", control = controlButton(244), controlId = 244, inputGroup = 0 },
        { label = "Print Debug", control = controlButton(74), controlId = 74, inputGroup = 0 },
    }, {
        clickable = false,
        drawMode = 0,
    })

    return state.buttonInstance
end

local function drawButtons()
    local instance = ensureButtons()
    if instance and instance.draw then
        instance:draw()
    end
end

local function printEntityDebug(data)
    if not data then return false end

    local leftText, rightText = buildInfoPanels(data)
    local text = ("[pr_bridge:devlaser:print]\n%s\n\n%s"):format(cleanText(leftText), cleanText(rightText))

    bridgeDebug("info", text)
    return true
end

local function stopMoveMode(silent)
    if not state.gizmoActive then return false end

    local gizmo = getGizmo()
    if gizmo and gizmo.stop then
        gizmo.stop()
    end

    state.gizmoActive = false
    state.suspended = false

    if not silent then
        bridgeDebug("info", "[pr_bridge:devlaser] move finalizado.")
    end

    return true
end

local function requestControl(entity, timeout)
    if not entityExists(entity) then return false end
    if NetworkHasControlOfEntity(entity) then return true end

    timeout = timeout or 1000
    local expires = GetGameTimer() + timeout

    repeat
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    until NetworkHasControlOfEntity(entity) or GetGameTimer() >= expires

    return NetworkHasControlOfEntity(entity)
end

local function deleteEntity(entity)
    if not canUseEntity(entity) then return false end

    requestControl(entity, 1500)
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)

    return not DoesEntityExist(entity)
end

local function toggleFreeze(entity)
    if not canUseEntity(entity) then return false end

    state.frozen[entity] = not state.frozen[entity]
    FreezeEntityPosition(entity, state.frozen[entity])

    return state.frozen[entity]
end

local function wasControlReleased(controlId)
    return IsControlJustReleased(0, controlId)
        or IsDisabledControlJustReleased(0, controlId)
        or IsControlJustReleased(2, controlId)
        or IsDisabledControlJustReleased(2, controlId)
end

local function isRightMouseActive()
    return IsControlPressed(0, 25)
        or IsDisabledControlPressed(0, 25)
        or IsControlJustReleased(0, 25)
        or IsDisabledControlJustReleased(0, 25)
        or IsControlPressed(2, 25)
        or IsDisabledControlPressed(2, 25)
        or IsControlJustReleased(2, 25)
        or IsDisabledControlJustReleased(2, 25)
end

local function isConfirmReleased()
    return wasControlReleased(201)
end

local function isCancelReleased()
    if isRightMouseActive() then return false end

    return wasControlReleased(177) or wasControlReleased(202)
end

local function runThread()
    state.threadRunning = true

    while state.active do
        Wait(0)

        if state.suspended then
            if state.gizmoActive and (isConfirmReleased() or isCancelReleased()) then
                stopMoveMode()
            end
        else

            local playerPed = PlayerPedId()
            local position = GetEntityCoords(playerPed)
            local hit, coords, entity = rayCastGamePlayCamera(state.options.distance or 1000.0)
            local color = { r = 255, g = 255, b = 255, a = 200 }
            local validTarget = (hit == 1 or hit == true) and canUseEntity(entity)

            if validTarget then
                color = { r = 0, g = 255, b = 0, a = 200 }

                local data = buildEntityData(entity, coords)
                state.target = {
                    hit = true,
                    coords = coords,
                    entity = entity,
                    data = data,
                }

                drawEntityBoundingBox(entity, color)
                drawHitText(coords)
                drawEntityInfoPanels(data)

                if IsControlJustReleased(0, 47) then
                    local frozen = toggleFreeze(entity)
                    bridgeDebug("info", ("[pr_bridge:devlaser] freeze entity=%s state=%s"):format(tostring(entity), tostring(frozen)))
                end

                if IsControlJustReleased(0, 38) then
                    local deleted = deleteEntity(entity)
                    bridgeDebug(deleted and "success" or "error", ("[pr_bridge:devlaser] delete entity=%s deleted=%s"):format(tostring(entity), tostring(deleted)))
                end

                if IsControlJustReleased(0, 244) then
                    DevLaser.moveWithGizmo(entity)
                end

                if IsControlJustReleased(0, 74) then
                    printEntityDebug(data)
                end
            else
                state.target = {
                    hit = hit == 1 or hit == true,
                    coords = coords,
                    entity = 0,
                    data = nil,
                }

                if (hit == 1 or hit == true) and isValidCoords(coords) then
                    drawHitText(coords)
                end
            end

            if isValidCoords(position) and isValidCoords(coords) then
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                drawLaserSphere(coords, color)
            end

            drawButtons()

            if isCancelReleased() then
                DevLaser.stop()
                break
            end
        end
    end

    state.threadRunning = false
end

function DevLaser.inspectEntity(entity)
    return buildEntityData(entity, state.target and state.target.coords)
end

function DevLaser.getTarget()
    return state.target
end

function DevLaser.requestControl(entity, timeout)
    return requestControl(entity, timeout)
end

function DevLaser.logEntityAction(action, entity, value, extra)
    local payload = {
        action = action,
        entity = entity,
        value = value,
        extra = extra,
    }

    bridgeDebug("info", ("[pr_bridge:devlaser] action=%s entity=%s value=%s"):format(tostring(action), tostring(entity), tostring(value)))
    return payload
end

function DevLaser.moveWithGizmo(entity)
    if not canUseEntity(entity) then
        bridgeDebug("warn", "[pr_bridge:devlaser] move sem entity valida.")
        return false
    end

    local gizmo = getGizmo()
    if not gizmo or not gizmo.start then
        bridgeDebug("warn", "[pr_bridge:devlaser] gizmo indisponivel para move.")
        return false
    end

    requestControl(entity, 1500)
    disposeButtons()

    state.suspended = true
    state.gizmoActive = true
    state.target = {
        hit = true,
        coords = GetEntityCoords(entity),
        entity = entity,
        data = buildEntityData(entity, GetEntityCoords(entity)),
    }

    gizmo.start(entity, function()
        return true
    end, nil, {
        showPreview = true,
        previewTitle = "DevLaser Move",
        precisionMode = false,
        freeCameraMode = false,
        allowFreeCameraToggle = true,
        useEditorCamera = true,
        editorCameraRadius = 2.0,
    })

    bridgeDebug("info", ("[pr_bridge:devlaser] move iniciado entity=%s. ENTER ou BACKSPACE finaliza."):format(tostring(entity)))
    return true
end

function DevLaser.isActive()
    return state.active == true
end

function DevLaser.start(options)
    options = options or {}

    if state.active then
        state.options = options
        bridgeDebug("info", "[pr_bridge:devlaser] DevLaser ja estava ativo; opcoes atualizadas.")
        return true
    end

    state.options = options
    state.active = true
    state.suspended = false
    state.gizmoActive = false
    state.target = nil

    bridgeDebug("info", ("[pr_bridge:devlaser] iniciado distance=%s flags=-1 admin-mode"):format(tostring(options.distance or 1000.0)))

    if not state.threadRunning then
        CreateThread(runThread)
    end

    return true
end

function DevLaser.stop(silent)
    if not state.active then return false end

    if state.gizmoActive then
        stopMoveMode(true)
    end

    state.active = false
    state.suspended = false
    state.gizmoActive = false
    state.target = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    disposeButtons()

    if not silent then
        bridgeDebug("info", "[pr_bridge:devlaser] parado.")
    end

    if state.options and type(state.options.onStop) == "function" then
        pcall(state.options.onStop)
    end

    return true
end

function DevLaser.toggle(options)
    if state.active then
        return DevLaser.stop()
    end

    return DevLaser.start(options)
end

DevLaser.Start = DevLaser.start
DevLaser.Stop = DevLaser.stop
DevLaser.Toggle = DevLaser.toggle
DevLaser.IsActive = DevLaser.isActive
DevLaser.GetTarget = DevLaser.getTarget
DevLaser.InspectEntity = DevLaser.inspectEntity
DevLaser.MoveWithGizmo = DevLaser.moveWithGizmo

return DevLaser
