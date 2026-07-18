--[[
    EditorCamera - Câmera orbital para ajuste com Gizmo
    Orbita ao redor de uma entidade alvo com controles de rotação e zoom
]]

local EditorCamera = {
    active = false,
    camera = nil,
    freecam = nil,
    target = nil,          -- Entidade alvo
    angleX = 0.0,          -- Ângulo horizontal (radianos)
    angleY = -0.3,         -- Ângulo vertical (radianos, -0.6 a 1.2)
    radius = 3.0,          -- Distância da câmera do alvo
    minRadius = 0.5,
    maxRadius = 8.0,
    isDragging = false,
    transitionInProgress = false,
    smoothFactor = 0.15,    -- Suavização de interpolação
}

local function getActiveGizmo()
    if _G then
        return _G.PRBridgeGizmo or _G.Gizmo
    end
end

local function norm(v)
    local d = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    if d == 0 then return vector3(0.0, 0.0, 0.0) end
    return vector3(v.x / d, v.y / d, v.z / d)
end

local function rotationToDirection(rotation)
    local x = math.rad(rotation.x)
    local z = math.rad(rotation.z)

    return vector3(
        -math.sin(z) * math.abs(math.cos(x)),
        math.cos(z) * math.abs(math.cos(x)),
        math.sin(x)
    )
end

-- ============================================================
-- POSIÇÃO DA CÂMERA
-- ============================================================

function EditorCamera.getCameraTargetPosition()
    if not EditorCamera.target or not DoesEntityExist(EditorCamera.target) then
        return nil
    end
    -- Se o Gizmo está ativo, focar no ponto do Gizmo
    local activeGizmo = getActiveGizmo()
    if activeGizmo and activeGizmo.entity and activeGizmo.getGizmoWorldPosition then
        local gizmoPos = activeGizmo.getGizmoWorldPosition()
        if gizmoPos then return gizmoPos end
    end
    return GetEntityCoords(EditorCamera.target)
end

function EditorCamera.updateCameraPosition()
    local targetPos = EditorCamera.getCameraTargetPosition()
    if not targetPos or not EditorCamera.camera then return end

    local r = math.max(EditorCamera.radius, EditorCamera.minRadius)

    -- Calcular posição da câmera usando coordenadas esféricas
    local cosY = math.cos(EditorCamera.angleX) * r
    local sinY = math.sin(EditorCamera.angleX) * r
    local height = math.sin(EditorCamera.angleY) * r

    local camPos = vector3(
        targetPos.x + cosY,
        targetPos.y + sinY,
        targetPos.z + 1.0 + height  -- +1.0 para elevar um pouco acima do chão
    )

    SetCamCoord(EditorCamera.camera, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(EditorCamera.camera, targetPos.x, targetPos.y, targetPos.z)
end

-- ============================================================
-- CONTROLES DA CÂMERA
-- ============================================================

function EditorCamera.handleCameraControls()
    if not EditorCamera.camera or EditorCamera.transitionInProgress then return end

    -- Atualizar estado de drag (botão direito do mouse - control 25)
    local wasDragging = EditorCamera.isDragging
    EditorCamera.isDragging = IsDisabledControlPressed(0, 25)

    -- Se começou a arrastar, parar de apontar a câmera
    if not wasDragging and EditorCamera.isDragging then
        StopCamPointing(EditorCamera.camera)
    end

    -- Desabilitar controles que interferem (mas deixar o mouse para o Gizmo)
    DisableControlAction(0, 1, true) -- Mouse X
    DisableControlAction(0, 2, true) -- Mouse Y
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 25, true) -- Aim
    HideHudComponentThisFrame(14) -- Esconder radar

    -- Rotação com botão direito
    if EditorCamera.isDragging then
        local mouseX = GetDisabledControlNormal(0, 1) * 8.0
        local mouseY = GetDisabledControlNormal(0, 2) * 8.0

        EditorCamera.angleX = EditorCamera.angleX - mouseX * 0.1
        EditorCamera.angleY = math.max(-0.6, math.min(1.2, EditorCamera.angleY + mouseY * 0.1))
        EditorCamera.updateCameraPosition()
    end

    -- Zoom com scroll
    local activeGizmo = getActiveGizmo()
    local precisionMode = activeGizmo and activeGizmo.isPrecisionMode and activeGizmo.isPrecisionMode()
    local xyzDrag = activeGizmo
        and activeGizmo.isDragging
        and activeGizmo.activeAxis == "xyz"

    if not precisionMode and not xyzDrag then
        if IsDisabledControlJustPressed(0, 241) then -- Scroll up
            if EditorCamera.radius > EditorCamera.minRadius then
                EditorCamera.radius = EditorCamera.radius - 0.4
                EditorCamera.updateCameraPosition()
            end
        end

        if IsDisabledControlJustPressed(0, 242) then -- Scroll down
            if EditorCamera.radius < EditorCamera.maxRadius then
                EditorCamera.radius = EditorCamera.radius + 0.4
                EditorCamera.updateCameraPosition()
            end
        end
    end
end

function EditorCamera.cursorLock()
    -- Manter o cursor travado no centro durante drag da câmera
    if EditorCamera.isDragging then
        -- O cursor é gerenciado pelo Gizmo
    end
end

-- ============================================================
-- START / STOP
-- ============================================================

function EditorCamera.start(targetEntity)
    if not targetEntity or not DoesEntityExist(targetEntity) then return false end

    if EditorCamera.active and EditorCamera.camera then
        EditorCamera.target = targetEntity
        EditorCamera.updateCameraPosition()
        return true
    end

    EditorCamera.target = targetEntity
    EditorCamera.active = true
    EditorCamera.angleX = 0.0
    EditorCamera.angleY = -0.3
    EditorCamera.radius = 3.0

    -- Criar câmera customizada
    local playerPos = GetEntityCoords(targetEntity)
    EditorCamera.camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        playerPos.x, playerPos.y, playerPos.z + 3.0,
        0.0, 0.0, 0.0, 60.0, false, 2
    )
    SetCamActive(EditorCamera.camera, true)
    RenderScriptCams(true, true, 500, true, false)
    EditorCamera.updateCameraPosition()

    -- Thread de controle da câmera
    Citizen.CreateThread(function()
        while EditorCamera.active and EditorCamera.camera do
            EditorCamera.handleCameraControls()
            EditorCamera.cursorLock()
            Citizen.Wait(1)
        end
    end)

    return true
end

function EditorCamera.stop()
    if not EditorCamera.active and EditorCamera.freecam and EditorCamera.freecam.active then
        return EditorCamera.stopFreecam(EditorCamera.freecam)
    end

    if not EditorCamera.active then return false end

    EditorCamera.active = false
    if EditorCamera.camera then
        SetCamActive(EditorCamera.camera, false)
        RenderScriptCams(false, true, 500, true, false)
        DestroyCam(EditorCamera.camera, false)
        EditorCamera.camera = nil
    end
    EditorCamera.target = nil
    EditorCamera.isDragging = false
    EditorCamera.transitionInProgress = false

    return true
end

function EditorCamera.startFreecam(options)
    options = options or {}

    if EditorCamera.freecam and EditorCamera.freecam.active then
        EditorCamera.stopFreecam(EditorCamera.freecam)
    end

    local playerPed = options.playerPed or PlayerPedId()
    local origin = options.coords
    if not origin then
        origin = playerPed and DoesEntityExist(playerPed) and GetEntityCoords(playerPed) or vector3(0.0, 0.0, 0.0)
    end

    local heading = tonumber(options.heading)
    if not heading then
        heading = playerPed and DoesEntityExist(playerPed) and GetEntityHeading(playerPed) or 0.0
    end

    local height = tonumber(options.cameraHeight) or 12.0
    local pitch = tonumber(options.cameraPitch) or -70.0
    local fov = tonumber(options.fov) or 60.0
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(cam, origin.x, origin.y, origin.z + height)
    SetCamRot(cam, pitch, 0.0, heading, 2)
    SetCamFov(cam, fov)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    EditorCamera.freecam = {
        active = true,
        camera = cam,
        rotX = pitch,
        rotZ = heading,
        moveSpeed = tonumber(options.moveSpeed) or 0.6,
        mouseSensitivity = tonumber(options.mouseSensitivity) or 8.0,
    }

    return EditorCamera.freecam
end

function EditorCamera.updateFreecam(state, moveSpeed)
    state = state or EditorCamera.freecam
    if not state or not state.active or not state.camera then return state end

    DisableAllControlActions(0)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 239, true)
    EnableControlAction(0, 240, true)
    EnableControlAction(0, 249, true)
    HideHudComponentThisFrame(14)

    local camCoords = GetCamCoord(state.camera)
    local camRot = GetCamRot(state.camera, 2)
    local forwardDir = rotationToDirection(camRot)
    local rightDir = rotationToDirection(vector3(camRot.x, camRot.y, camRot.z - 90.0))
    local forward = norm(vector3(forwardDir.x, forwardDir.y, 0.0))
    local right = norm(vector3(rightDir.x, rightDir.y, 0.0))
    local speed = tonumber(moveSpeed) or state.moveSpeed or 0.6
    local moveVec = vector3(0.0, 0.0, 0.0)

    if IsDisabledControlPressed(0, 32) then moveVec = moveVec + forward end
    if IsDisabledControlPressed(0, 31) then moveVec = moveVec - forward end
    if IsDisabledControlPressed(0, 34) then moveVec = moveVec - right end
    if IsDisabledControlPressed(0, 30) then moveVec = moveVec + right end

    local heightChange = 0.0
    if IsDisabledControlPressed(0, 44) then heightChange = -speed end
    if IsDisabledControlPressed(0, 38) then heightChange = speed end

    if moveVec.x ~= 0.0 or moveVec.y ~= 0.0 or moveVec.z ~= 0.0 then
        moveVec = norm(moveVec) * speed
    end

    local newCoords = camCoords + moveVec + vector3(0.0, 0.0, heightChange)
    SetCamCoord(state.camera, newCoords.x, newCoords.y, newCoords.z)

    local mouseX = GetDisabledControlNormal(0, 1)
    local mouseY = GetDisabledControlNormal(0, 2)
    local sensitivity = state.mouseSensitivity or 8.0

    state.rotZ = state.rotZ - (mouseX * sensitivity)
    state.rotX = math.max(-89.0, math.min(89.0, state.rotX - (mouseY * sensitivity)))
    SetCamRot(state.camera, state.rotX, 0.0, state.rotZ, 2)

    return state
end

function EditorCamera.getFreecamTargetCoords(state, options)
    state = state or EditorCamera.freecam
    options = options or {}

    if not state or not state.camera then
        return nil, false, nil
    end

    local camCoords = GetCamCoord(state.camera)
    local camRot = GetCamRot(state.camera, 2)
    local camDir = rotationToDirection(camRot)
    local distance = tonumber(options.distance) or 200.0
    local destination = camCoords + camDir * distance
    local rayHandle = StartShapeTestRay(
        camCoords.x,
        camCoords.y,
        camCoords.z,
        destination.x,
        destination.y,
        destination.z,
        options.flags or 1,
        options.ignoreEntity or -1,
        0
    )

    local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
    if hit == 1 or hit == true then
        return endCoords, true, entityHit
    end

    return destination, false, nil
end

function EditorCamera.stopFreecam(state)
    state = state or EditorCamera.freecam
    if not state or not state.camera then return false end

    state.active = false
    SetCamActive(state.camera, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(state.camera, false)

    if state == EditorCamera.freecam then
        EditorCamera.freecam = nil
    end

    return true
end

function EditorCamera.isFreecamActive()
    return EditorCamera.freecam ~= nil and EditorCamera.freecam.active == true
end

-- ============================================================
-- TRANSIÇÃO SUAVE PARA ENTIDADE
-- ============================================================

function EditorCamera.smoothTransitionToEntity(entity, targetRadius)
    if EditorCamera.transitionInProgress then return end
    EditorCamera.transitionInProgress = true

    targetRadius = targetRadius or 2.0
    local startRadius = EditorCamera.radius
    local startAngleX = EditorCamera.angleX
    local startAngleY = EditorCamera.angleY
    local targetAngleX = 0.0
    local targetAngleY = -0.3
    local duration = 400
    local startTime = GetGameTimer()

    Citizen.CreateThread(function()
        while true do
            local elapsed = GetGameTimer() - startTime
            if elapsed >= duration or EditorCamera.isDragging then break end

            -- Smoothstep interpolation
            local t = math.min(elapsed / duration, 1.0)
            t = t * t * (3.0 - 2.0 * t)

            EditorCamera.radius = startRadius + (targetRadius - startRadius) * t
            EditorCamera.angleX = startAngleX + (targetAngleX - startAngleX) * t
            EditorCamera.angleY = startAngleY + (targetAngleY - startAngleY) * t

            local targetPos = EditorCamera.getCameraTargetPosition()
            if targetPos then
                EditorCamera.updateCameraPosition()
            end

            Citizen.Wait(1)
        end

        EditorCamera.radius = targetRadius
        EditorCamera.angleX = targetAngleX
        EditorCamera.angleY = targetAngleY
        EditorCamera.updateCameraPosition()
        EditorCamera.transitionInProgress = false
    end)
end

-- ============================================================
-- MIRROR - Espelhar offset no eixo X
-- ============================================================

--- Espelha o offset do hitch/gizmo no eixo X local da entidade
--- Se o offset é (0.5, -1.0, 0.2), vira (-0.5, -1.0, 0.2)
function MirrorOffset(offset)
    if not offset then return vector3(0, 0, 0) end
    return vector3(-offset.x, offset.y, offset.z)
end

--- Espelha a rotação no eixo X (inverte yaw e roll mantendo pitch)
function MirrorRotation(rot)
    if not rot then return vector3(0, 0, 0) end
    return vector3(rot.x, -rot.y, -rot.z)
end

if _G then
    _G.PRBridgeEditorCamera = EditorCamera
    _G.EditorCamera = _G.EditorCamera or EditorCamera
end

return EditorCamera
