--[[
    Gizmo 3D - Sistema de manipulação visual de entidades
    Deobfuscado e limpo a 
    Suporta: Translação (eixos X/Y/Z e planos XY/XZ/YZ) e Rotação
]]

local Locales = {
    Gizmo = {
        Translate = "Gizmo translate",
        Rotate = "Gizmo rotate",
    }
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

local function getInstructionalButtons()
    return PRInstructionalButtons
        or (Bridge and Bridge.fivem and (Bridge.fivem.instructionalButtons or Bridge.fivem.buttons))
end

local function getDrawText()
    return PRDrawText
        or (Bridge and Bridge.fivem and (Bridge.fivem.drawtext or Bridge.fivem.drawText))
end

local function getEditorCamera()
    return PREditorCamera
        or (Bridge and Bridge.fivem and (Bridge.fivem.editorCamera or Bridge.fivem.editor_camera))
        or (_G and (_G.PRBridgeEditorCamera or _G.EditorCamera))
end

local function getStreaming()
    return PRStreaming
        or (Bridge and Bridge.fivem and Bridge.fivem.streaming)
end

local resourceName = GetCurrentResourceName()

local lastSafeErrorAt = {}

local function safeGizmoCall(label, callback)
    local ok, err = pcall(callback)
    if ok then return true end

    local now = GetGameTimer()
    if (now - (lastSafeErrorAt[label] or 0)) > 2500 then
        lastSafeErrorAt[label] = now
        bridgeDebug("error", ("[pr_bridge:gizmo] %s falhou: %s"):format(label, tostring(err)))
    end

    return false
end

-- ============================================================
-- CONFIGURAÇÃO
-- ============================================================

local GizmoConfig = {
    arrowLength         = 0.25,
    arrowHeadSize       = 0.04,
    rotationRingRadius  = 0.32,
    rotationRingSegments= 40,
    rotationPickSamples = 64,
    rotationPickThreshold = 0.03,
    rotationHandleSize  = 0.018,
    centerSquareSize    = 0.09,
    freeDragMinDistance = 0.6,
    freeDragMaxDistance = 8.0,
    freeDragDefaultDistance = 2.0,
    freeDragDistanceStep = 0.2,
    freeDragOrbitSensitivityX = 8.0,
    freeDragOrbitSensitivityY = 5.0,
    freeDragPlayerHeight = 0.75,
    rotationArcStart    = -0.12,
    rotationArcEnd      = math.pi + 0.12,
    lineThicknessPx     = 1.25,
    planeSize           = 0.24,
    planeOffset         = 0.09,
    lineAlpha = {
        normal = 150,
        hover  = 200,
        active = 200,
    },
    colors = {
        x  = { normal = {227, 39, 18},  hover = {255, 255, 0}, active = {255, 255, 255} },
        y  = { normal = {16, 224, 37},   hover = {255, 255, 0}, active = {255, 255, 255} },
        z  = { normal = {17, 77, 237},   hover = {255, 255, 0}, active = {255, 255, 255} },
        xy = { normal = {111, 141, 189}, hover = {255, 255, 0}, active = {255, 255, 255} },
        xz = { normal = {136, 181, 129}, hover = {255, 255, 0}, active = {255, 255, 255} },
        yz = { normal = {181, 129, 129}, hover = {255, 255, 0}, active = {255, 255, 255} },
        xyz = { normal = {235, 235, 235}, hover = {255, 255, 0}, active = {255, 255, 255} },
        dragLine = {178, 243, 0},
    },
    sensitivity = {
        translation  = 0.025,
        rotation     = 1.5,
        rotationDrag = 0.45,
    },
    screenPickThreshold = 0.015,
    dragLineLength      = 100.0,
    showKeybinds        = true,
    previewUpdateInterval = 150,
    focusBlockedControls = {
        1, 2, 24, 25, 21, 22, 30, 31, 32, 33, 34, 35, 44, 45, 47, 37,
        75, 140, 141, 142, 257, 263, 264, 12, 13, 14, 15, 16, 17, 18, 19,
        38, 200, 210, 243,
    },
    freeCameraBlockedControls = {
        24, 37, 140, 141, 142, 257, 263, 264,
    },
}

-- ============================================================
-- ESTADO GLOBAL DO GIZMO
-- ============================================================

local Gizmo = {
    _threadRunning = false,
    enabled        = false,
    entity         = nil,
    mode           = "translate",  -- "translate" ou "rotate"
    space          = "local",      -- "local" ou "global"
    activeAxis     = nil,
    hoveredAxis    = nil,
    isDragging     = false,
    lastMousePos   = { x = 0, y = 0 },
    originalAlpha  = nil,
    dragFree       = nil,
    dragPlane      = nil,
    dragAxis       = nil,
    dragStartPos   = nil,
    dragStartRot   = nil,
    rotationCenter       = nil,
    rotationStartAngle   = nil,
    rotationAccumulated  = 0,
    rotationLastPos      = nil,
    rotationStartRotation= nil,
    rotationPlaneNormal  = nil,
    updateCallback = nil,
    beforeTransformCallback = nil,
    offset         = nil,
    lastCoords     = nil,
    precisionKeys  = {
        rotXNegative = false,
        rotXPositive = false,
        rotYNegative = false,
        rotYPositive = false,
        rotZNegative = false,
        rotZPositive = false,
    },
    precisionLastAxis = nil,
    precisionMode = false,
    precisionSpeed = 1.0,
    precisionModeProvider = nil,
    onPrecisionModeChange = nil,
    handlePrecisionToggle = true,
    freeCameraMode = false,
    allowFreeCameraToggle = true,
    onFreeCameraModeChange = nil,
    useEditorCamera = true,
    editorCameraOwned = false,
    editorCameraRadius = 2.0,
    showPreview = false,
    previewTitle = "Gizmo Preview",
    previewLastText = nil,
    previewEntityText = nil,
    previewLastUpdate = 0,
    _keybindRenderer = nil,
    _keybindMode = nil,
}

-- ============================================================
-- FUNÇÕES MATEMÁTICAS AUXILIARES
-- ============================================================

local function sign(n)
    if n > 0 then return 1 elseif n < 0 then return -1 else return 0 end
end

local function vec3Normalize(v)
    local len = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    if len > 0 then
        return vector3(v.x / len, v.y / len, v.z / len)
    end
    return v
end

local function vec3Dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

local function vec3Cross(a, b)
    return vector3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
end

local function vec3LengthSq(v)
    return v.x * v.x + v.y * v.y + v.z * v.z
end

local function vec3Length(v)
    return math.sqrt(vec3LengthSq(v))
end

local function clampNumber(value, minValue, maxValue)
    value = tonumber(value) or minValue
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

local function vectorToOrbitAngles(direction)
    direction = vec3Normalize(direction)
    local yaw = math.atan(direction.y, direction.x)
    local pitch = math.asin(clampNumber(direction.z, -1.0, 1.0))
    return yaw, pitch
end

local function orbitAnglesToVector(yaw, pitch)
    local cosPitch = math.cos(pitch)
    return vector3(
        math.cos(yaw) * cosPitch,
        math.sin(yaw) * cosPitch,
        math.sin(pitch)
    )
end

local function getMouseLookInput()
    local x = GetDisabledControlNormal(0, 1)
    local y = GetDisabledControlNormal(0, 2)

    if math.abs(x) < 1e-5 then
        x = GetControlNormal(0, 1)
    end

    if math.abs(y) < 1e-5 then
        y = GetControlNormal(0, 2)
    end

    return x, y
end

--- Cria quaternion a partir de eixo e ângulo
local function axisAngleToQuat(axis, angle)
    local halfAngle = angle * 0.5
    local s = math.sin(halfAngle)
    return {
        w = math.cos(halfAngle),
        x = axis.x * s,
        y = axis.y * s,
        z = axis.z * s,
    }
end

--- Multiplica dois quaternions
local function quatMultiply(a, b)
    return {
        w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
        x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
        y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
        z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
    }
end

--- Quaternion para Euler (graus)
local function quatToEuler(q)
    local pitch = math.asin(2 * (q.w * q.x - q.y * q.z))
    local yaw   = math.atan(2 * (q.w * q.y + q.x * q.z), 1 - 2 * (q.x * q.x + q.y * q.y))
    local roll  = math.atan(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.x * q.x + q.z * q.z))
    return vector3(math.deg(pitch), math.deg(yaw), math.deg(roll))
end

--- Euler (graus) para Quaternion
local function eulerToQuat(euler)
    local rx = math.rad(euler.x)
    local ry = math.rad(euler.y)
    local rz = math.rad(euler.z)
    local cx, sx = math.cos(rx * 0.5), math.sin(rx * 0.5)
    local cy, sy = math.cos(ry * 0.5), math.sin(ry * 0.5)
    local cz, sz = math.cos(rz * 0.5), math.sin(rz * 0.5)
    return {
        w = cx * cy * cz + sx * sy * sz,
        x = sx * cy * cz - cx * sy * sz,
        y = cx * sy * cz + sx * cy * sz,
        z = cx * cy * sz - sx * sy * cz,
    }
end

--- Rejeitar vetor de uma normal (projeção num plano)
local function rejectFromNormal(v, normal)
    local d = vec3Dot(v, normal)
    return v - normal * d
end

--- Ângulo entre dois vetores projetados num plano
local function angleBetweenOnPlane(a, b, planeNormal)
    local projA = vec3Normalize(rejectFromNormal(a, planeNormal))
    local projB = vec3Normalize(rejectFromNormal(b, planeNormal))
    local dot = math.max(-1, math.min(1, vec3Dot(projA, projB)))
    local angle = math.acos(dot)
    local cross = vec3Cross(projA, projB)
    if vec3Dot(cross, planeNormal) < 0 then
        angle = -angle
    end
    return angle
end

--- Normalizar quaternion
local function quatNormalize(q)
    local len = math.sqrt(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w)
    if len == 0 then
        return { x = 0, y = 0, z = 0, w = 1 }
    end
    return { x = q.x / len, y = q.y / len, z = q.z / len, w = q.w / len }
end

--- Quaternion multiply (alternativa com w no final - usada em rotação)
local function quatMul2(a, b)
    return {
        x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
        y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
        z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
        w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
    }
end

-- ============================================================
-- FUNÇÕES DE CÂMERA / ENTIDADE
-- ============================================================

local function getEntityBasis(entity)
    local right, forward, up, pos = GetEntityMatrix(entity)
    return right, forward, up, pos
end

local function worldToLocal(entity, worldPos)
    local right, forward, up, pos = getEntityBasis(entity)
    local delta = worldPos - pos
    return vector3(vec3Dot(delta, right), vec3Dot(delta, forward), vec3Dot(delta, up))
end

local function localToWorld(entity, localPos)
    local right, forward, up, pos = getEntityBasis(entity)
    return pos + right * localPos.x + forward * localPos.y + up * localPos.z
end

local function getCameraInfo()
    local rot = GetFinalRenderedCamRot(2)
    local camPos = GetFinalRenderedCamCoord()

    local rx = math.rad(rot.x)
    local rz = math.rad(rot.z)

    local fwd = vec3Normalize(vector3(
        -math.sin(rz) * math.cos(rx),
         math.cos(rz) * math.cos(rx),
         math.sin(rx)
    ))

    local right = vec3Normalize(vector3(math.cos(rz), math.sin(rz), 0.0))
    local up = vec3Normalize(vec3Cross(right, fwd))

    return camPos, fwd, right, up
end

--- Pixel para ratio de tela
local function pixelToScreenRatio(px)
    local _, h = GetActiveScreenResolution()
    return (px or 3) / h
end

--- Desenhar linha 3D via coordenadas de tela
local function drawLine3D(from, to, r, g, b, a, thickness)
    local ok1, sx1, sy1 = GetScreenCoordFromWorldCoord(from.x, from.y, from.z)
    local ok2, sx2, sy2 = GetScreenCoordFromWorldCoord(to.x, to.y, to.z)
    if ok1 and ok2 then
        DrawLine_2d(sx1, sy1, sx2, sy2, pixelToScreenRatio(thickness), r, g, b, a)
    end
end

--- Ray da câmera a partir de coordenadas de tela (0-1)
local function screenToWorldRay(screenX, screenY)
    local camPos, fwd, right, up = getCameraInfo()
    local fov = GetFinalRenderedCamFov()
    local tanHalfFov = math.tan(fov * 0.5 * math.pi / 180.0)
    local w, h = GetActiveScreenResolution()
    local aspect = w / h

    local ndcX = (screenX - 0.5) * 2.0
    local ndcY = (0.5 - screenY) * 2.0

    local dir = vec3Normalize(fwd + right * (ndcX * tanHalfFov * aspect) + up * (ndcY * tanHalfFov))
    return camPos, dir
end

--- Interseção raio-plano
local function rayPlaneIntersect(rayOrigin, rayDir, planePoint, planeNormal)
    local denom = vec3Dot(rayDir, planeNormal)
    if math.abs(denom) < 1e-6 then return nil end
    local t = vec3Dot(planePoint - rayOrigin, planeNormal) / denom
    if t < 0 then return nil end
    return rayOrigin + rayDir * t
end

--- Determinar melhor plano de visualização para um eixo
local function bestViewPlane(camPos, targetPos)
    local dir = vec3Normalize(camPos - targetPos)
    local ax, ay, az = math.abs(dir.x), math.abs(dir.y), math.abs(dir.z)
    if ax > ay and ax > az then return "yz"
    elseif ay > az then return "xz"
    else return "xy" end
end

--- Obter quaternion de uma entidade
local function getEntityQuat(entity)
    local x, y, z, w = GetEntityQuaternion(entity)
    return { x = x, y = y, z = z, w = w }
end

--- Setar quaternion de uma entidade (com callback)
local function setEntityQuat(entity, q)
    SetEntityQuaternion(entity, q.x, q.y, q.z, q.w)
    if Gizmo.updateCallback then
        local coords = GetEntityCoords(Gizmo.entity)
        Gizmo.updateCallback(coords, Gizmo.lastCoords)
    end
end

-- ============================================================
-- MÉTODOS DO GIZMO
-- ============================================================

function Gizmo.getDisplayBasis()
    local xDir = Gizmo.getAxisDirection("x", false)
    local yDir = Gizmo.getAxisDirection("y", false)
    local zDir = Gizmo.getAxisDirection("z", false)
    return xDir, yDir, zDir
end

function Gizmo.getGizmoPosition()
    local pos = GetEntityCoords(Gizmo.entity)
    if Gizmo.offset and (Gizmo.offset.x ~= 0 or Gizmo.offset.y ~= 0 or Gizmo.offset.z ~= 0) then
        return localToWorld(Gizmo.entity, Gizmo.offset)
    end
    return pos
end

function Gizmo.setOffset(off)
    Gizmo.offset = off or vector3(0, 0, 0)
end

function Gizmo.getOffset()
    return Gizmo.offset or vector3(0, 0, 0)
end

function Gizmo.getGizmoWorldPosition()
    if not Gizmo.entity or not DoesEntityExist(Gizmo.entity) then return nil end
    return Gizmo.getGizmoPosition()
end

function Gizmo.focusEditorCamera(silent)
    if not Gizmo.useEditorCamera then return false end
    if not Gizmo.entity or not DoesEntityExist(Gizmo.entity) then return false end

    local editorCamera = getEditorCamera()
    if not editorCamera or type(editorCamera.start) ~= "function" then
        if not silent then
            bridgeDebug("warn", "[pr_bridge:gizmo] editorCamera indisponivel para foco.")
        end
        return false
    end

    local started = editorCamera.start(Gizmo.entity)
    if started == false then return false end

    Gizmo.editorCameraOwned = true

    if type(editorCamera.smoothTransitionToEntity) == "function" then
        editorCamera.smoothTransitionToEntity(Gizmo.entity, Gizmo.editorCameraRadius or 2.0)
    end

    return true
end

function Gizmo.releaseEditorCamera(silent)
    if not Gizmo.editorCameraOwned then return false end

    local editorCamera = getEditorCamera()
    if editorCamera and type(editorCamera.stop) == "function" then
        editorCamera.stop()
    elseif not silent then
        bridgeDebug("warn", "[pr_bridge:gizmo] editorCamera indisponivel para liberar foco.")
    end

    Gizmo.editorCameraOwned = false
    return true
end

local function optionEnabled(options, name, default)
    if options[name] == nil then return default end
    return options[name] ~= false
end

function Gizmo.start(entity, callback, offset, options)
    options = options or {}

    if type(offset) == "table" and offset.x == nil and offset[1] == nil and (offset.offset or offset.showPreview ~= nil or offset.precisionMode ~= nil or offset.freeCameraMode ~= nil or offset.allowFreeCameraToggle ~= nil or offset.useEditorCamera ~= nil or offset.editorCamera ~= nil) then
        options = offset
        offset = options.offset
    end

    Gizmo.enabled = true
    Gizmo.entity = entity
    Gizmo.mode = "translate"
    Gizmo.space = "local"
    Gizmo.activeAxis = nil
    Gizmo.hoveredAxis = nil
    Gizmo.isDragging = false
    Gizmo.dragFree = nil
    Gizmo.lastMousePos = { x = 0, y = 0 }
    Gizmo.originalAlpha = GetEntityAlpha(entity)
    Gizmo.dragPlane = nil
    Gizmo.dragStartPos = nil
    Gizmo.dragStartRot = nil
    Gizmo.rotationCenter = nil
    Gizmo.rotationStartAngle = nil
    Gizmo.rotationAccumulated = 0
    Gizmo.rotationLastPos = nil
    Gizmo.rotationStartRotation = nil
    Gizmo.updateCallback = callback or function() return true end
    Gizmo.beforeTransformCallback = nil
    Gizmo.offset = offset or vector3(0, 0, 0)
    Gizmo.precisionModeProvider = type(options.precisionModeProvider) == "function" and options.precisionModeProvider or nil
    Gizmo.onPrecisionModeChange = type(options.onPrecisionModeChange) == "function" and options.onPrecisionModeChange or nil
    Gizmo.handlePrecisionToggle = options.handlePrecisionToggle ~= false
    Gizmo.freeCameraMode = options.freeCameraMode == true
    Gizmo.allowFreeCameraToggle = options.allowFreeCameraToggle ~= false
    Gizmo.onFreeCameraModeChange = type(options.onFreeCameraModeChange) == "function" and options.onFreeCameraModeChange or nil
    Gizmo.useEditorCamera = optionEnabled(options, "useEditorCamera", optionEnabled(options, "editorCamera", true))
    Gizmo.editorCameraOwned = false
    Gizmo.editorCameraRadius = tonumber(options.editorCameraRadius) or 2.0
    Gizmo.showPreview = options.showPreview == true
    Gizmo.previewTitle = options.previewTitle or "Gizmo Preview"
    Gizmo.previewLastText = nil
    Gizmo.previewEntityText = nil
    Gizmo.previewLastUpdate = 0
    Gizmo.precisionSpeed = tonumber(options.precisionSpeed) or 1.0
    Gizmo.setPrecisionMode(options.precisionMode == true, true)
    Gizmo.invalidateKeybinds()
    if Gizmo.freeCameraMode then
        Gizmo.releaseEditorCamera(true)
    else
        Gizmo.focusEditorCamera(true)
    end

    bridgeDebug("info", ("[pr_bridge:gizmo] Editor iniciado. entity=%s preview=%s"):format(entity, tostring(Gizmo.showPreview)))

    if not Gizmo._threadRunning then
        Citizen.CreateThread(function()
            Gizmo._threadRunning = true
            while Gizmo.entity and DoesEntityExist(Gizmo.entity) do
                Citizen.Wait(0)
                safeGizmoCall("control locks", Gizmo.applyControlLocks)
                safeGizmoCall("precision toggle", Gizmo.handlePrecisionToggleInput)
                safeGizmoCall("precision speed", Gizmo.handlePrecisionSpeedInput)
                safeGizmoCall("update", Gizmo.update)
                if Gizmo.showPreview then
                    safeGizmoCall("preview", Gizmo.drawPreview)
                end
                if GizmoConfig.showKeybinds then
                    safeGizmoCall("instructional buttons", Gizmo.drawKeybinds)
                end
            end
            Gizmo._threadRunning = false
        end)
    end
end

function Gizmo.stop()
    Gizmo.hidePreview()
    Gizmo.invalidateKeybinds()
    Gizmo.releaseEditorCamera(true)
    Gizmo.enabled = false
    Gizmo.entity = nil
    Gizmo.activeAxis = nil
    Gizmo.hoveredAxis = nil
    Gizmo.isDragging = false
    Gizmo.dragFree = nil
    Gizmo.dragPlane = nil
    Gizmo.dragAxis = nil
    Gizmo.rotationCenter = nil
    Gizmo.rotationLastPos = nil
    Gizmo.rotationStartRotation = nil
    Gizmo.rotationPlaneNormal = nil
    Gizmo.updateCallback = nil
    Gizmo.beforeTransformCallback = nil
    Gizmo.offset = nil
    Gizmo.precisionModeProvider = nil
    Gizmo.onPrecisionModeChange = nil
    Gizmo.handlePrecisionToggle = true
    Gizmo.freeCameraMode = false
    Gizmo.allowFreeCameraToggle = true
    Gizmo.onFreeCameraModeChange = nil
    Gizmo.useEditorCamera = true
    Gizmo.editorCameraOwned = false
    Gizmo.editorCameraRadius = 2.0
    Gizmo.showPreview = false
    Gizmo.ResetPrecisionKeys()
    bridgeDebug("info", "[pr_bridge:gizmo] Editor finalizado.")
end

function Gizmo.setBeforeTransformCallback(callback)
    Gizmo.beforeTransformCallback = callback
end

function Gizmo.ResetPrecisionKeys()
    for key in pairs(Gizmo.precisionKeys or {}) do
        Gizmo.precisionKeys[key] = false
    end
    Gizmo.precisionLastAxis = nil
end

function Gizmo.HasPrecisionRotationInput()
    local keys = Gizmo.precisionKeys or {}
    return keys.rotXNegative or keys.rotXPositive
        or keys.rotYNegative or keys.rotYPositive
        or keys.rotZNegative or keys.rotZPositive
end

function Gizmo.isPrecisionMode()
    if type(Gizmo.precisionModeProvider) == "function" then
        local ok, enabled = pcall(Gizmo.precisionModeProvider)
        if ok then return enabled == true end

        bridgeDebug("warn", ("[pr_bridge:gizmo] precisionModeProvider falhou: %s"):format(tostring(enabled)))
    end

    return Gizmo.precisionMode == true
end

function Gizmo.isFreeCameraMode()
    return Gizmo.freeCameraMode == true
end

function Gizmo.setFreeCameraMode(enabled, silent)
    if Gizmo.allowFreeCameraToggle == false and enabled == true then
        return false
    end

    local nextState = enabled == true
    local previous = Gizmo.freeCameraMode == true

    Gizmo.freeCameraMode = nextState
    Gizmo.isDragging = false
    Gizmo.activeAxis = nil
    Gizmo.hoveredAxis = nil
    Gizmo.dragPlane = nil
    Gizmo.dragFree = nil
    Gizmo.dragAxis = nil
    Gizmo.invalidateKeybinds()

    if nextState then
        Gizmo.setPrecisionMode(false, true)
        Gizmo.releaseEditorCamera(silent)
    else
        Gizmo.focusEditorCamera(silent)
    end

    if previous ~= nextState and type(Gizmo.onFreeCameraModeChange) == "function" then
        Gizmo.onFreeCameraModeChange(nextState, previous)
    end

    if not silent and previous ~= nextState then
        bridgeDebug("info", ("[pr_bridge:gizmo] freeCameraMode=%s"):format(tostring(nextState)))
    end

    return nextState
end

function Gizmo.toggleFreeCameraMode()
    return Gizmo.setFreeCameraMode(not Gizmo.isFreeCameraMode())
end

function Gizmo.applyControlLocks()
    local controls = Gizmo.isFreeCameraMode()
        and (GizmoConfig.freeCameraBlockedControls or {})
        or (GizmoConfig.focusBlockedControls or {})

    for i = 1, #controls do
        DisableControlAction(0, controls[i], true)
    end
end

function Gizmo.setPrecisionMode(enabled, silent)
    local nextState = enabled == true
    local previous = Gizmo.precisionMode == true

    Gizmo.precisionMode = nextState
    Gizmo.ResetPrecisionKeys()
    Gizmo.invalidateKeybinds()

    if previous ~= nextState and type(Gizmo.onPrecisionModeChange) == "function" then
        Gizmo.onPrecisionModeChange(nextState, previous)
    end

    if not silent and previous ~= nextState then
        bridgeDebug("info", ("[pr_bridge:gizmo] precisionMode=%s"):format(tostring(nextState)))
    end

    return nextState
end

function Gizmo.togglePrecisionMode()
    return Gizmo.setPrecisionMode(not Gizmo.isPrecisionMode())
end

function Gizmo.setPrecisionModeProvider(callback)
    Gizmo.precisionModeProvider = type(callback) == "function" and callback or nil
    Gizmo.invalidateKeybinds()
end

function Gizmo.getPrecisionSpeed()
    return tonumber(Gizmo.precisionSpeed) or 1.0
end

function Gizmo.setPrecisionSpeed(value)
    value = tonumber(value) or 1.0
    value = math.max(0.1, math.min(3.0, value))
    Gizmo.precisionSpeed = value
    return value
end

function Gizmo.adjustPrecisionSpeed(delta)
    return Gizmo.setPrecisionSpeed(Gizmo.getPrecisionSpeed() + (tonumber(delta) or 0.0))
end

local function isControlJustPressedAny(...)
    for i = 1, select("#", ...) do
        local controlId = select(i, ...)
        if IsDisabledControlJustPressed(0, controlId) or IsControlJustPressed(0, controlId) then
            return true
        end
    end

    return false
end

function Gizmo.handlePrecisionToggleInput()
    if Gizmo.handlePrecisionToggle == false then return end
    if Gizmo.isFreeCameraMode() then return end

    if isControlJustPressedAny(37) then
        Gizmo.togglePrecisionMode()
    end
end

function Gizmo.handlePrecisionSpeedInput()
    if not Gizmo.isPrecisionMode() then return end

    if isControlJustPressedAny(83, 314) then
        local speed = Gizmo.adjustPrecisionSpeed(0.1)
        bridgeDebug("info", ("[pr_bridge:gizmo] precisionSpeed=%.1f"):format(speed))
    elseif isControlJustPressedAny(84, 315) then
        local speed = Gizmo.adjustPrecisionSpeed(-0.1)
        bridgeDebug("info", ("[pr_bridge:gizmo] precisionSpeed=%.1f"):format(speed))
    end
end

function Gizmo.toggleMode()
    if Gizmo.mode == "rotate" then
        Gizmo.mode = "translate"
    else
        Gizmo.mode = "rotate"
    end

    Gizmo.activeAxis = nil
    Gizmo.hoveredAxis = nil
    Gizmo.isDragging = false
    Gizmo.dragFree = nil
    Gizmo.dragPlane = nil
    Gizmo.dragAxis = nil
    Gizmo.invalidateKeybinds()
    bridgeDebug("info", ("[pr_bridge:gizmo] mode=%s"):format(tostring(Gizmo.mode)))
    return Gizmo.mode
end


function Gizmo.getSpeedModifier()
    if IsDisabledControlPressed(0, 210) then return 0.1 end
    return 1.0
end

function Gizmo.getMousePosition()
    local mx, my = GetNuiCursorPosition()
    if mx > 1.0 or my > 1.0 then
        local w, h = GetActiveScreenResolution()
        mx, my = mx / w, my / h
    end
    return mx, my
end

function Gizmo.getAxisDirection(axis, keepSign)
    local dir
    if Gizmo.space == "global" then
        if axis == "x" then dir = vector3(1, 0, 0)
        elseif axis == "y" then dir = vector3(0, 1, 0)
        else dir = vector3(0, 0, 1) end
    else
        local right, forward, up = getEntityBasis(Gizmo.entity)
        if axis == "x" then dir = right
        elseif axis == "y" then dir = forward
        else dir = up end
    end

    if not keepSign then
        local camPos = GetFinalRenderedCamCoord()
        local gizmoPos = Gizmo.getGizmoPosition()
        local toCamera = vec3Normalize(camPos - gizmoPos)
        if vec3Dot(dir, toCamera) < 0 then
            dir = -dir
        end
    end
    return dir
end

function Gizmo.getPlaneNormal(plane)
    if Gizmo.space == "global" then
        if plane == "xy" then return vector3(0, 0, 1)
        elseif plane == "xz" then return vector3(0, 1, 0)
        else return vector3(1, 0, 0) end
    else
        local right, forward, up = getEntityBasis(Gizmo.entity)
        if plane == "xy" then return up
        elseif plane == "xz" then return forward
        else return right end
    end
end

function Gizmo.getRotationRingBasis(axis)
    if Gizmo.space == "global" then
        if axis == "x" then return vector3(0, 1, 0), vector3(0, 0, 1), vector3(1, 0, 0) end
        if axis == "y" then return vector3(1, 0, 0), vector3(0, 0, 1), vector3(0, 1, 0) end
        return vector3(1, 0, 0), vector3(0, 1, 0), vector3(0, 0, 1)
    end

    local right, forward, up = getEntityBasis(Gizmo.entity)
    if axis == "x" then return forward, up, right end
    if axis == "y" then return right, up, forward end
    return right, forward, up
end

function Gizmo.getColorAlpha(axisName, colorSet)
    local alpha = GizmoConfig.lineAlpha.normal
    if Gizmo.hoveredAxis == axisName then
        alpha = GizmoConfig.lineAlpha.hover
    elseif Gizmo.activeAxis == axisName then
        alpha = GizmoConfig.lineAlpha.active
    end
    return colorSet[1], colorSet[2], colorSet[3], alpha
end

-- ============================================================
-- PICKING (Detecção de mouse sobre eixos/planos/anéis)
-- ============================================================

function Gizmo.checkPointNearMouse(worldPoint, mx, my)
    local ok, sx, sy = GetScreenCoordFromWorldCoord(worldPoint.x, worldPoint.y, worldPoint.z)
    if not ok then return false, 999 end
    local dist = math.sqrt((mx - sx) ^ 2 + (my - sy) ^ 2)
    if dist > GizmoConfig.screenPickThreshold then return false, 999 end
    local camPos = GetFinalRenderedCamCoord()
    return true, #(worldPoint - camPos)
end

function Gizmo.checkLineSegment(from, to, mx, my, samples)
    samples = samples or 10
    local bestDist = 999
    local hit = false
    for i = 0, samples do
        local t = i / samples
        local p = from + (to - from) * t
        local ok, sx, sy = GetScreenCoordFromWorldCoord(p.x, p.y, p.z)
        if ok then
            local d = math.sqrt((mx - sx) ^ 2 + (my - sy) ^ 2)
            if d < GizmoConfig.screenPickThreshold then
                local camPos = GetFinalRenderedCamCoord()
                local worldDist = #(p - camPos)
                if bestDist > worldDist then
                    bestDist = worldDist
                    hit = true
                end
            end
        end
    end
    return hit, bestDist
end

function Gizmo.checkLineSegmentNearMouse(from, to, mx, my, threshold)
    local ok1, sx1, sy1 = GetScreenCoordFromWorldCoord(from.x, from.y, from.z)
    local ok2, sx2, sy2 = GetScreenCoordFromWorldCoord(to.x, to.y, to.z)
    if not ok1 or not ok2 then return false, 999 end

    local vx, vy = sx2 - sx1, sy2 - sy1
    local lenSq = vx * vx + vy * vy
    if lenSq <= 1e-8 then
        return Gizmo.checkPointNearMouse(from, mx, my)
    end

    local t = ((mx - sx1) * vx + (my - sy1) * vy) / lenSq
    t = math.max(0.0, math.min(1.0, t))

    local px, py = sx1 + vx * t, sy1 + vy * t
    local screenDist = math.sqrt((mx - px) ^ 2 + (my - py) ^ 2)
    if screenDist > (threshold or GizmoConfig.screenPickThreshold) then return false, 999 end

    local camPos = GetFinalRenderedCamCoord()
    local worldPoint = from + (to - from) * t
    return true, #(worldPoint - camPos)
end

function Gizmo.checkPlane(mx, my, center, planeName)
    local xDir, yDir, zDir = Gizmo.getDisplayBasis()
    local u, v
    if planeName == "xy" then u, v = xDir, yDir
    elseif planeName == "xz" then u, v = xDir, zDir
    else u, v = yDir, zDir end

    local planeNormal = vec3Normalize(vec3Cross(u, v))
    local halfSize = GizmoConfig.planeSize * 0.5
    local planeCenter = center + u * (GizmoConfig.planeOffset + halfSize) + v * (GizmoConfig.planeOffset + halfSize)

    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hit = rayPlaneIntersect(rayOrigin, rayDir, planeCenter, planeNormal)
    if not hit then return false, 999 end

    local delta = hit - center
    local uNorm = vec3Normalize(u)
    local vNorm = vec3Normalize(v)
    local uProj = vec3Dot(delta, uNorm)
    local vProj = vec3Dot(delta, vNorm)

    if uProj < GizmoConfig.planeOffset then return false, 999 end

    local camPos = GetFinalRenderedCamCoord()
    return true, #(hit - camPos)
end

function Gizmo.checkCenterSquare(mx, my, center)
    local camPos, camFwd, camRight, camUp = getCameraInfo()
    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hit = rayPlaneIntersect(rayOrigin, rayDir, center, camFwd)
    if not hit then return false, 999 end

    local delta = hit - center
    local halfSize = (GizmoConfig.centerSquareSize or 0.09) * 0.5
    local rightProj = vec3Dot(delta, vec3Normalize(camRight))
    local upProj = vec3Dot(delta, vec3Normalize(camUp))

    if math.abs(rightProj) > halfSize or math.abs(upProj) > halfSize then
        return false, 999
    end

    return true, #(hit - camPos)
end

-- ============================================================
-- HOVER
-- ============================================================

function Gizmo.updateHover(mx, my)
    if Gizmo.isDragging then return end
    local gizmoPos = Gizmo.getGizmoPosition()
    local candidates = {}

    if Gizmo.mode == "translate" then
        local function addCandidate(axis, distance, priority)
            table.insert(candidates, { axis = axis, distance = distance, priority = priority or 10 })
        end

        -- Movimento livre 3D
        local ok, dist = Gizmo.checkCenterSquare(mx, my, gizmoPos)
        if ok then addCandidate("xyz", dist, 0) end

        -- Eixos
        for _, axis in ipairs({"x", "y", "z"}) do
            local dir = Gizmo.getAxisDirection(axis, false)
            local tip = gizmoPos + dir * GizmoConfig.arrowLength
            local hit, d = Gizmo.checkLineSegment(gizmoPos, tip, mx, my)
            if hit then addCandidate(axis, d, 1) end
        end

        -- Planos
        for _, plane in ipairs({"xy", "xz", "yz"}) do
            local hit, d = Gizmo.checkPlane(mx, my, gizmoPos, plane)
            if hit then addCandidate(plane, d, 2) end
        end
    elseif Gizmo.mode == "rotate" then
        local radius = GizmoConfig.rotationRingRadius
        local samples = GizmoConfig.rotationPickSamples

        for _, axis in ipairs({ "x", "y", "z" }) do
            local a1, a2 = Gizmo.getRotationRingBasis(axis)
            local prevPoint = nil
            local bestDist = 999
            for j = 0, samples do
                local t = GizmoConfig.rotationArcStart + ((GizmoConfig.rotationArcEnd - GizmoConfig.rotationArcStart) * (j / samples))
                local p = gizmoPos + (a1 * math.cos(t) + a2 * math.sin(t)) * radius
                if prevPoint then
                    local ok, d = Gizmo.checkLineSegmentNearMouse(prevPoint, p, mx, my, GizmoConfig.rotationPickThreshold)
                    if ok and bestDist > d then bestDist = d end
                end
                prevPoint = p
            end
            if bestDist < 999 then
                table.insert(candidates, { axis = axis, distance = bestDist })
            end
        end
    end

    table.sort(candidates, function(a, b)
        local ap = a.priority or 10
        local bp = b.priority or 10
        if ap ~= bp then return ap < bp end
        return a.distance < b.distance
    end)
    Gizmo.hoveredAxis = (candidates[1] and candidates[1].axis) or nil
end

-- ============================================================
-- DRAGGING - TRANSLAÇÃO
-- ============================================================

function Gizmo.beginAxisDrag(axis, mx, my)
    local gizmoPos = Gizmo.getGizmoPosition()
    local dir = vec3Normalize(Gizmo.getAxisDirection(axis, false))

    local camPos, camFwd, camRight, camUp = getCameraInfo()
    local perpToDir = vec3Cross(camFwd, dir)
    if vec3LengthSq(perpToDir) < 1e-6 then
        perpToDir = vec3Cross(camUp, dir)
    end
    if vec3LengthSq(perpToDir) < 1e-6 then
        perpToDir = vec3Cross(camRight, dir)
    end
    local planeNormal = vec3Normalize(vec3Cross(dir, vec3Normalize(perpToDir)))

    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, gizmoPos, planeNormal)

    Gizmo.dragAxis = {
        axis = axis,
        dir = dir,
        n = planeNormal,
        startPos = gizmoPos,
        startHit = hitPoint or gizmoPos,
        startEntityPos = GetEntityCoords(Gizmo.entity),
    }
end

function Gizmo.setCoords(x, y, z)
    if Gizmo.updateCallback then
        local newPos = vec3(x, y, z)
        local lastPos = Gizmo.lastCoords or vec3(x, y, z)
        local result = Gizmo.updateCallback(newPos, lastPos)
        if not result then return false end
    end
    SetEntityCoordsNoOffset(Gizmo.entity, x, y, z)
    return true
end

local function getEntityModelSafe(entity)
    local ok, model = pcall(GetEntityModel, entity)
    if ok then return model end

    bridgeDebug("warn", ("[pr_bridge:gizmo] GetEntityModel falhou ao alinhar no chao: %s"):format(tostring(model)))
    return nil
end

local function getEntityGroundOffset(entity)
    if IsEntityAPed(entity) then return 0.0 end
    if IsEntityAVehicle(entity) then return 0.0 end

    local streaming = getStreaming()
    if not streaming or not streaming.getModelGroundOffset then return 0.0 end

    local model = getEntityModelSafe(entity)
    if not model then return 0.0 end

    return streaming.getModelGroundOffset(model, 1500) or 0.0
end

function Gizmo.placeEntityOnGround()
    if not Gizmo.entity or not DoesEntityExist(Gizmo.entity) then return false end

    local entity = Gizmo.entity
    local coords = GetEntityCoords(entity)
    local streaming = getStreaming()
    local groundZ = nil

    if streaming and streaming.findGroundZ then
        groundZ = streaming.findGroundZ(coords, {
            ignoreEntity = entity,
            flags = 1 | 2 | 16,
            startOffset = 60.0,
            endOffset = -160.0,
            fallbackOffset = 1000.0,
        })
    end

    if not groundZ then
        local found, fallbackZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1000.0, false)
        groundZ = found and fallbackZ or coords.z
    end

    Gizmo.lastCoords = coords

    local targetZ = groundZ + getEntityGroundOffset(entity)
    local moved = Gizmo.setCoords(coords.x, coords.y, targetZ)
    if not moved then return false end

    if IsEntityAVehicle(entity) then
        pcall(SetVehicleOnGroundProperly, entity)
    end

    bridgeDebug("info", ("[pr_bridge:gizmo] Ground aplicado. entity=%s z=%.3f"):format(tostring(entity), targetZ))
    return true
end

function Gizmo.updateAxisDrag(mx, my)
    if not Gizmo.dragAxis then return end
    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, Gizmo.dragAxis.startPos, Gizmo.dragAxis.n)
    if not hitPoint then hitPoint = Gizmo.dragAxis.startHit end

    local delta = hitPoint - Gizmo.dragAxis.startHit
    local projected = vec3Dot(delta, Gizmo.dragAxis.dir)
    local speedMod = Gizmo.getSpeedModifier()
    projected = projected * speedMod

    local newGizmoPos = Gizmo.dragAxis.startPos + Gizmo.dragAxis.dir * projected

    local offsetWorld = localToWorld(Gizmo.entity, Gizmo.offset)
    local entityPos = GetEntityCoords(Gizmo.entity)
    local offsetDelta = offsetWorld - entityPos
    local finalPos = newGizmoPos - offsetDelta

    Gizmo.setCoords(finalPos.x, finalPos.y, finalPos.z)
end

function Gizmo.beginPlaneDrag(plane, mx, my)
    local gizmoPos = Gizmo.getGizmoPosition()
    local xDir, yDir, zDir = Gizmo.getDisplayBasis()

    local u, v
    if plane == "xy" then u, v = xDir, yDir
    elseif plane == "xz" then u, v = xDir, zDir
    else u, v = yDir, zDir end

    local planeNormal = vec3Normalize(vec3Cross(u, v))
    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, gizmoPos, planeNormal)

    Gizmo.dragPlane = {
        u = u, v = v, n = planeNormal,
        startHit = hitPoint or gizmoPos,
        startPos = gizmoPos,
        startEntityPos = GetEntityCoords(Gizmo.entity),
        axis = plane,
    }
end

function Gizmo.beginFreeDrag(mx, my)
    local gizmoPos = Gizmo.getGizmoPosition()
    local _, camFwd = getCameraInfo()
    local playerPed = PlayerPedId()
    local playerPos = (playerPed and playerPed ~= 0 and DoesEntityExist(playerPed)) and GetEntityCoords(playerPed) or gizmoPos
    local playerAnchor = playerPos + vector3(0.0, 0.0, GizmoConfig.freeDragPlayerHeight or 0.75)
    local rel = gizmoPos - playerAnchor
    local distance = vec3Length(rel)
    local minDistance = GizmoConfig.freeDragMinDistance or 0.6
    local maxDistance = GizmoConfig.freeDragMaxDistance or 8.0

    if distance < minDistance then
        distance = GizmoConfig.freeDragDefaultDistance or 2.0
        rel = vec3Normalize(camFwd) * distance
    end

    distance = clampNumber(distance, minDistance, maxDistance)
    local yaw, pitch = vectorToOrbitAngles(rel)
    local cameraYaw, cameraPitch = vectorToOrbitAngles(camFwd)

    Gizmo.dragPlane = nil
    Gizmo.dragFree = {
        yaw = yaw,
        pitch = pitch,
        cameraYawOffset = yaw - cameraYaw,
        cameraPitchOffset = pitch - cameraPitch,
        lastCameraYaw = cameraYaw,
        lastCameraPitch = cameraPitch,
        distance = distance,
        minDistance = minDistance,
        maxDistance = maxDistance,
        startPos = gizmoPos,
        startEntityPos = GetEntityCoords(Gizmo.entity),
        startPlayerPos = playerPos,
        startPlayerAnchor = playerAnchor,
        axis = "xyz",
    }
end

function Gizmo.updateFreeDrag(mx, my)
    if not Gizmo.dragFree then return end

    local drag = Gizmo.dragFree
    local _, camFwd = getCameraInfo()
    local cameraYaw, cameraPitch = vectorToOrbitAngles(camFwd)
    local cameraChanged = math.abs(cameraYaw - (drag.lastCameraYaw or cameraYaw)) > 0.0005
        or math.abs(cameraPitch - (drag.lastCameraPitch or cameraPitch)) > 0.0005
    local orbitSpeedX = GizmoConfig.freeDragOrbitSensitivityX or 8.0
    local orbitSpeedY = GizmoConfig.freeDragOrbitSensitivityY or 5.0
    local distanceStep = GizmoConfig.freeDragDistanceStep or 0.2

    if IsDisabledControlJustPressed(0, 241) or IsControlJustPressed(0, 241) then
        drag.distance = clampNumber((drag.distance or 0.0) - distanceStep, drag.minDistance, drag.maxDistance)
    elseif IsDisabledControlJustPressed(0, 242) or IsControlJustPressed(0, 242) then
        drag.distance = clampNumber((drag.distance or 0.0) + distanceStep, drag.minDistance, drag.maxDistance)
    end

    if cameraChanged then
        drag.yaw = cameraYaw + (drag.cameraYawOffset or 0.0)
        drag.pitch = clampNumber(cameraPitch + (drag.cameraPitchOffset or 0.0), -1.15, 1.15)
    else
        local mouseX, mouseY = getMouseLookInput()
        if math.abs(mouseX) > 1e-5 or math.abs(mouseY) > 1e-5 then
            drag.yaw = (drag.yaw or 0.0) - mouseX * orbitSpeedX
            drag.pitch = clampNumber((drag.pitch or 0.0) + mouseY * orbitSpeedY, -1.15, 1.15)
        end
    end

    drag.lastCameraYaw = cameraYaw
    drag.lastCameraPitch = cameraPitch

    local playerPed = PlayerPedId()
    local playerPos = (playerPed and playerPed ~= 0 and DoesEntityExist(playerPed)) and GetEntityCoords(playerPed) or drag.startPlayerPos
    local playerAnchor = playerPos + vector3(0.0, 0.0, GizmoConfig.freeDragPlayerHeight or 0.75)
    local direction = orbitAnglesToVector(drag.yaw or 0.0, drag.pitch or 0.0)
    local newGizmoPos = playerAnchor + direction * (drag.distance or GizmoConfig.freeDragDefaultDistance or 2.0)

    local offsetWorld = localToWorld(Gizmo.entity, Gizmo.offset)
    local entityPos = GetEntityCoords(Gizmo.entity)
    local offsetDelta = offsetWorld - entityPos
    local finalPos = newGizmoPos - offsetDelta

    Gizmo.setCoords(finalPos.x, finalPos.y, finalPos.z)
end

function Gizmo.updatePlaneDrag(mx, my)
    if not Gizmo.dragPlane then return end
    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, Gizmo.dragPlane.startPos, Gizmo.dragPlane.n)
    if not hitPoint then hitPoint = Gizmo.dragPlane.startHit end

    local delta = hitPoint - Gizmo.dragPlane.startHit
    local uDir = vec3Normalize(Gizmo.dragPlane.u)
    local vDir = vec3Normalize(Gizmo.dragPlane.v)
    local speedMod = Gizmo.getSpeedModifier()

    local uProj = vec3Dot(delta, uDir) * speedMod
    local vProj = vec3Dot(delta, vDir) * speedMod
    local movement = uDir * uProj + vDir * vProj

    local newGizmoPos = Gizmo.dragPlane.startPos + movement
    local offsetWorld = localToWorld(Gizmo.entity, Gizmo.offset)
    local entityPos = GetEntityCoords(Gizmo.entity)
    local offsetDelta = offsetWorld - entityPos
    local finalPos = newGizmoPos - offsetDelta

    Gizmo.setCoords(finalPos.x, finalPos.y, finalPos.z)
end

-- ============================================================
-- DRAGGING - ROTAÇÃO
-- ============================================================

function Gizmo.beginRotationDrag(axis, mx, my)
    local gizmoPos = Gizmo.getGizmoPosition()

    local _, _, planeNormal = Gizmo.getRotationRingBasis(axis)

    planeNormal = vec3Normalize(planeNormal)
    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, gizmoPos, planeNormal)
    if not hitPoint then return end

    Gizmo.rotationCenter = gizmoPos
    Gizmo.rotationPlaneNormal = planeNormal
    Gizmo.activeAxis = axis
    Gizmo.rotationStartPos = hitPoint
    Gizmo.rotationLastPos = hitPoint
end

function Gizmo.updateRotationDrag(mx, my)
    if not Gizmo.rotationCenter or not Gizmo.rotationPlaneNormal then return end

    local rayOrigin, rayDir = screenToWorldRay(mx, my)
    local hitPoint = rayPlaneIntersect(rayOrigin, rayDir, Gizmo.rotationCenter, Gizmo.rotationPlaneNormal)
    if not hitPoint or not Gizmo.rotationLastPos then return end

    local fromCenter = vec3Normalize(Gizmo.rotationLastPos - Gizmo.rotationCenter)
    local toCenter = vec3Normalize(hitPoint - Gizmo.rotationCenter)
    local angle = angleBetweenOnPlane(fromCenter, toCenter, Gizmo.rotationPlaneNormal)

    if math.abs(angle) <= 5e-4 then return end

    local adjustedAngle = math.rad(math.deg(angle) * GizmoConfig.sensitivity.rotationDrag)
    adjustedAngle = adjustedAngle * Gizmo.getSpeedModifier()

    local entityPos = GetEntityCoords(Gizmo.entity)
    local gizmoPosBeforeRot = Gizmo.getGizmoPosition()
    local currentQuat = getEntityQuat(Gizmo.entity)

    if Gizmo.space == "global" then
        local rotQuat = axisAngleToQuat(Gizmo.rotationPlaneNormal, adjustedAngle)
        local newQuat = quatNormalize(quatMul2(rotQuat, currentQuat))
        setEntityQuat(Gizmo.entity, newQuat)

        -- Compensar offset
        if Gizmo.offset and (Gizmo.offset.x ~= 0 or Gizmo.offset.y ~= 0 or Gizmo.offset.z ~= 0) then
            local newGizmoPos = localToWorld(Gizmo.entity, Gizmo.offset)
            local drift = newGizmoPos - gizmoPosBeforeRot
            local curPos = GetEntityCoords(Gizmo.entity)
            local fixedPos = curPos - drift
            Gizmo.setCoords(fixedPos.x, fixedPos.y, fixedPos.z)
        end
    else
        local localAxis
        if Gizmo.activeAxis == "x" then localAxis = vector3(1, 0, 0)
        elseif Gizmo.activeAxis == "y" then localAxis = vector3(0, 1, 0)
        else localAxis = vector3(0, 0, 1) end

        local rotQuat = axisAngleToQuat(localAxis, adjustedAngle)
        local newQuat = quatNormalize(quatMul2(currentQuat, rotQuat))
        setEntityQuat(Gizmo.entity, newQuat)

        if Gizmo.offset and (Gizmo.offset.x ~= 0 or Gizmo.offset.y ~= 0 or Gizmo.offset.z ~= 0) then
            local newGizmoPos = localToWorld(Gizmo.entity, Gizmo.offset)
            local drift = newGizmoPos - gizmoPosBeforeRot
            local curPos = GetEntityCoords(Gizmo.entity)
            local fixedPos = curPos - drift
            Gizmo.setCoords(fixedPos.x, fixedPos.y, fixedPos.z)
        end
    end

    Gizmo.rotationLastPos = hitPoint
end

-- ============================================================
-- DESENHO
-- ============================================================

function Gizmo.drawArrow(origin, axis, colorSet)
    local dir = Gizmo.getAxisDirection(axis, false)
    local tip = origin + dir * GizmoConfig.arrowLength

    local r, g, b, a = Gizmo.getColorAlpha(axis, colorSet.normal)
    if Gizmo.hoveredAxis == axis then
        r, g, b = colorSet.hover[1], colorSet.hover[2], colorSet.hover[3]
    elseif Gizmo.activeAxis == axis then
        r, g, b = colorSet.active[1], colorSet.active[2], colorSet.active[3]
    end

    -- Linha principal
    drawLine3D(origin, tip, r, g, b, 255, 1.25)

    -- Cabeça da seta
    local headSize = GizmoConfig.arrowHeadSize
    local headBase = tip - dir * headSize

    local perp1, perp2
    if math.abs(dir.z) > 0.9 then
        perp1 = vec3Normalize(vec3Cross(dir, vector3(1, 0, 0)))
    else
        perp1 = vec3Normalize(vec3Cross(dir, vector3(0, 0, 1)))
    end
    perp2 = vec3Normalize(vec3Cross(dir, perp1))

    local adjustedTip = origin + dir * (GizmoConfig.arrowLength - 0.005)
    local halfHead = headSize * 0.3
    for i = 0, 5 do
        local angle = (i * math.pi) / 6.0
        local offset = vec3Normalize(perp1 * math.cos(angle) + perp2 * math.sin(angle)) * halfHead
        drawLine3D(adjustedTip, headBase + offset, r, g, b, 255, 1.25)
        drawLine3D(adjustedTip, headBase - offset, r, g, b, 255, 1.25)
    end
end

function Gizmo.drawPlaneSquare(origin, plane, colorSet, isFacing)
    local r, g, b, a = Gizmo.getColorAlpha(plane, colorSet.normal)
    if Gizmo.hoveredAxis == plane then
        r, g, b = colorSet.hover[1], colorSet.hover[2], colorSet.hover[3]
    elseif Gizmo.activeAxis == plane then
        r, g, b = colorSet.active[1], colorSet.active[2], colorSet.active[3]
    end

    local size = GizmoConfig.planeSize
    local off = GizmoConfig.planeOffset
    local thickness = GizmoConfig.lineThicknessPx or 4

    if isFacing then
        thickness = thickness * 1.5
        a = math.min(255, a * 1.3)
    end

    local xDir, yDir, zDir = Gizmo.getDisplayBasis()
    local u, v
    if plane == "xy" then u, v = xDir, yDir
    elseif plane == "xz" then u, v = xDir, zDir
    else u, v = yDir, zDir end

    local corner = origin + u * off + v * off
    local p1 = corner + u * size
    local p2 = corner + u * size + v * size
    local p3 = corner + v * size

    drawLine3D(corner, p1, r, g, b, a, 1)
    drawLine3D(p1, p2, r, g, b, a, 1)
    drawLine3D(p2, p3, r, g, b, a, 1)
    drawLine3D(p3, corner, r, g, b, a, 1)
end

function Gizmo.drawCenterSquare(origin)
    local colorSet = GizmoConfig.colors.xyz
    local r, g, b, a = Gizmo.getColorAlpha("xyz", colorSet.normal)
    if Gizmo.hoveredAxis == "xyz" then
        r, g, b = colorSet.hover[1], colorSet.hover[2], colorSet.hover[3]
    elseif Gizmo.activeAxis == "xyz" then
        r, g, b = colorSet.active[1], colorSet.active[2], colorSet.active[3]
    end

    local _, camFwd, camRight, camUp = getCameraInfo()
    local size = GizmoConfig.centerSquareSize or 0.09
    local half = size * 0.5
    local center = origin - vec3Normalize(camFwd) * 0.004
    local right = vec3Normalize(camRight)
    local up = vec3Normalize(camUp)
    local thickness = (Gizmo.hoveredAxis == "xyz" or Gizmo.activeAxis == "xyz") and 2.2 or 1.4

    local p1 = center - right * half - up * half
    local p2 = center + right * half - up * half
    local p3 = center + right * half + up * half
    local p4 = center - right * half + up * half

    drawLine3D(p1, p2, r, g, b, a, thickness)
    drawLine3D(p2, p3, r, g, b, a, thickness)
    drawLine3D(p3, p4, r, g, b, a, thickness)
    drawLine3D(p4, p1, r, g, b, a, thickness)
    drawLine3D(p1, p3, r, g, b, math.floor(a * 0.7), 1.0)
    drawLine3D(p2, p4, r, g, b, math.floor(a * 0.7), 1.0)
end

function Gizmo.drawRotationHandle(point, color)
    local camPos = GetFinalRenderedCamCoord()
    local toCamera = vec3Normalize(camPos - point)
    local camRight, camUp
    do
        local _, _, right, up = getCameraInfo()
        camRight, camUp = right, up
    end

    local size = GizmoConfig.rotationHandleSize
    DrawLine(
        point.x - camRight.x * size, point.y - camRight.y * size, point.z - camRight.z * size,
        point.x + camRight.x * size, point.y + camRight.y * size, point.z + camRight.z * size,
        color[1], color[2], color[3], 255
    )
    DrawLine(
        point.x - camUp.x * size, point.y - camUp.y * size, point.z - camUp.z * size,
        point.x + camUp.x * size, point.y + camUp.y * size, point.z + camUp.z * size,
        color[1], color[2], color[3], 255
    )
    DrawLine(
        point.x - toCamera.x * size, point.y - toCamera.y * size, point.z - toCamera.z * size,
        point.x + toCamera.x * size, point.y + toCamera.y * size, point.z + toCamera.z * size,
        color[1], color[2], color[3], 255
    )
end

function Gizmo.drawRotationArrow(origin, dir, color)
    dir = vec3Normalize(dir)
    local camPos = GetFinalRenderedCamCoord()
    local toCamera = vec3Normalize(camPos - origin)
    local side = vec3Normalize(vec3Cross(dir, toCamera))
    if vec3LengthSq(side) < 1e-6 then side = vector3(0.0, 0.0, 1.0) end

    local tip = origin + dir * 0.03
    local base = origin - dir * 0.018
    local wing = 0.018

    DrawLine(base.x, base.y, base.z, tip.x, tip.y, tip.z, color[1], color[2], color[3], 255)
    DrawLine(tip.x, tip.y, tip.z, base.x + side.x * wing, base.y + side.y * wing, base.z + side.z * wing, color[1], color[2], color[3], 255)
    DrawLine(tip.x, tip.y, tip.z, base.x - side.x * wing, base.y - side.y * wing, base.z - side.z * wing, color[1], color[2], color[3], 255)
end

function Gizmo.drawRotationAxisGuides(origin)
    local radius = GizmoConfig.rotationRingRadius
    local guides = {
        { axis = "x", dir = Gizmo.getAxisDirection("x", true), color = GizmoConfig.colors.x.normal },
        { axis = "y", dir = Gizmo.getAxisDirection("y", true), color = GizmoConfig.colors.y.normal },
        { axis = "z", dir = Gizmo.getAxisDirection("z", true), color = GizmoConfig.colors.z.normal },
    }

    for _, guide in ipairs(guides) do
        local dir = vec3Normalize(guide.dir)
        local endPoint = origin + dir * radius
        DrawLine(origin.x, origin.y, origin.z, endPoint.x, endPoint.y, endPoint.z, guide.color[1], guide.color[2], guide.color[3], 210)
        Gizmo.drawRotationArrow(endPoint, dir, guide.color)
    end

    Gizmo.drawRotationHandle(origin, { 235, 235, 235 })
end

function Gizmo.drawRotationRing(origin, axis, colorSet, distance)
    local r, g, b, a = Gizmo.getColorAlpha(axis, colorSet.normal)
    if Gizmo.hoveredAxis == axis then
        r, g, b = colorSet.hover[1], colorSet.hover[2], colorSet.hover[3]
    elseif Gizmo.activeAxis == axis then
        r, g, b = colorSet.active[1], colorSet.active[2], colorSet.active[3]
    end

    local radius = GizmoConfig.rotationRingRadius
    local segments = GizmoConfig.rotationRingSegments
    local thickness = GizmoConfig.lineThicknessPx or 3
    if Gizmo.hoveredAxis == axis or Gizmo.activeAxis == axis then
        thickness = thickness * 1.65
    end

    local a1, a2 = Gizmo.getRotationRingBasis(axis)

    local prevPoint = nil
    for i = 0, segments do
        local t = GizmoConfig.rotationArcStart + ((GizmoConfig.rotationArcEnd - GizmoConfig.rotationArcStart) * (i / segments))
        local point = origin + (a1 * math.cos(t) + a2 * math.sin(t)) * radius
        if prevPoint then
            drawLine3D(prevPoint, point, r, g, b, a, thickness)
        end
        prevPoint = point
    end

    local startPoint = origin + (a1 * math.cos(GizmoConfig.rotationArcStart) + a2 * math.sin(GizmoConfig.rotationArcStart)) * radius
    local midPoint = origin + (a1 * math.cos((GizmoConfig.rotationArcStart + GizmoConfig.rotationArcEnd) * 0.5) + a2 * math.sin((GizmoConfig.rotationArcStart + GizmoConfig.rotationArcEnd) * 0.5)) * radius
    local endPoint = origin + (a1 * math.cos(GizmoConfig.rotationArcEnd) + a2 * math.sin(GizmoConfig.rotationArcEnd)) * radius

    Gizmo.drawRotationHandle(startPoint, { r, g, b })
    Gizmo.drawRotationHandle(midPoint, { r, g, b })
    Gizmo.drawRotationArrow(endPoint, a2, { r, g, b })
end

function Gizmo.drawDragLine()
    if not Gizmo.isDragging or not Gizmo.activeAxis then return end
    local gizmoPos = Gizmo.getGizmoPosition()
    local c = GizmoConfig.colors.dragLine

    if Gizmo.mode == "translate" then
        local ax = Gizmo.activeAxis
        if ax == "x" or ax == "y" or ax == "z" then
            local dir = Gizmo.getAxisDirection(ax, false)
            local lineLen = GizmoConfig.dragLineLength
            local p1 = gizmoPos - dir * lineLen
            local p2 = gizmoPos + dir * lineLen
            DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, c[1], c[2], c[3], 255)

            -- Crosshair no centro
            local s = 0.05
            DrawLine(gizmoPos.x - s, gizmoPos.y, gizmoPos.z, gizmoPos.x + s, gizmoPos.y, gizmoPos.z, c[1], c[2], c[3], 255)
            DrawLine(gizmoPos.x, gizmoPos.y - s, gizmoPos.z, gizmoPos.x, gizmoPos.y + s, gizmoPos.z, c[1], c[2], c[3], 255)
            DrawLine(gizmoPos.x, gizmoPos.y, gizmoPos.z - s, gizmoPos.x, gizmoPos.y, gizmoPos.z + s, c[1], c[2], c[3], 255)
        end
    end
end

function Gizmo.handleTranslation(dx, dy)
    local gizmoPos = Gizmo.getGizmoPosition()
    local camPos, camFwd, camRight, camUp = getCameraInfo()

    local distToGizmo = #(gizmoPos - camPos)
    local speed = distToGizmo * GizmoConfig.sensitivity.translation * 100
    speed = speed * Gizmo.getSpeedModifier()

    local ax = Gizmo.activeAxis
        if ax == "center" or ax == "xyz" then
            local newPos = vector3(
                gizmoPos.x + camRight.x * dx * speed,
                gizmoPos.y + camRight.y * dx * speed,
                gizmoPos.z + camRight.z * dx * speed
            )
            newPos = newPos + camUp * (-dy * speed)
            local offsetWorld = localToWorld(Gizmo.entity, Gizmo.offset)
            local entityPos = GetEntityCoords(Gizmo.entity)
        local offsetDelta = offsetWorld - entityPos
        local finalPos = newPos - offsetDelta
        Gizmo.setCoords(finalPos.x, finalPos.y, finalPos.z)
    elseif ax == "x" or ax == "y" or ax == "z" then
        local dir = Gizmo.getAxisDirection(ax, false)
        local rightProj = vec3Dot(camRight, dir)
        local upProj = vec3Dot(camUp, dir)
        local movement = 0
        if math.abs(rightProj) > math.abs(upProj) then
            movement = dx * speed * rightProj
        else
            movement = -dy * speed * upProj
        end
        local newPos = gizmoPos + dir * movement
        local offsetWorld = localToWorld(Gizmo.entity, Gizmo.offset)
        local entityPos = GetEntityCoords(Gizmo.entity)
        local offsetDelta = offsetWorld - entityPos
        local finalPos = newPos - offsetDelta
        Gizmo.setCoords(finalPos.x, finalPos.y, finalPos.z)
    elseif ax == "xy" or ax == "xz" or ax == "yz" then
        Gizmo.updatePlaneDrag(Gizmo.lastMousePos.x + dx, Gizmo.lastMousePos.y + dy)
    end
end

function Gizmo.draw()
    local gizmoPos = Gizmo.getGizmoPosition()
    local camPos = GetFinalRenderedCamCoord()

    if Gizmo.mode == "translate" then
        -- Determinar melhor plano de visualização e ordenar planos por distância
        local bestPlane = bestViewPlane(camPos, gizmoPos)
        local planes = {}
        for _, p in ipairs({"xy", "xz", "yz"}) do
            local n = Gizmo.getPlaneNormal(p)
            local planePos = gizmoPos + n * GizmoConfig.planeOffset
            table.insert(planes, {
                plane = p,
                distance = #(planePos - camPos),
                isFacing = (p == bestPlane),
            })
        end
        table.sort(planes, function(a, b) return a.distance > b.distance end)

        -- Desenhar planos (de trás para frente)
        for _, pInfo in ipairs(planes) do
            Gizmo.drawPlaneSquare(gizmoPos, pInfo.plane, GizmoConfig.colors[pInfo.plane], pInfo.isFacing)
        end

        -- Desenhar setas
        Gizmo.drawArrow(gizmoPos, "x", GizmoConfig.colors.x)
        Gizmo.drawArrow(gizmoPos, "y", GizmoConfig.colors.y)
        Gizmo.drawArrow(gizmoPos, "z", GizmoConfig.colors.z)
        Gizmo.drawCenterSquare(gizmoPos)
        Gizmo.drawDragLine()
    elseif Gizmo.mode == "rotate" then
        -- Ordenar anéis por distância média
        local ringOrder = {}
        Gizmo.drawRotationAxisGuides(gizmoPos)
        for _, axis in ipairs({"x", "y", "z"}) do
            local totalDist = 0
            local samples = 8

            local a1, a2 = Gizmo.getRotationRingBasis(axis)

            for j = 0, samples - 1 do
                local t = GizmoConfig.rotationArcStart + ((GizmoConfig.rotationArcEnd - GizmoConfig.rotationArcStart) * (j / samples))
                local p = gizmoPos + (a1 * math.cos(t) + a2 * math.sin(t)) * GizmoConfig.rotationRingRadius
                totalDist = totalDist + #(p - camPos)
            end
            table.insert(ringOrder, { axis = axis, distance = totalDist / samples })
        end
        table.sort(ringOrder, function(a, b) return a.distance > b.distance end)

        for _, r in ipairs(ringOrder) do
            Gizmo.drawRotationRing(gizmoPos, r.axis, GizmoConfig.colors[r.axis], r.distance)
        end
    end
end

-- ============================================================
-- MAIN UPDATE
-- ============================================================

function Gizmo.update()
    if not DoesEntityExist(Gizmo.entity) then return end

    if Gizmo.isPrecisionMode() then
        Gizmo.isDragging = false
        Gizmo.activeAxis = nil
        Gizmo.hoveredAxis = nil
        Gizmo.draw()
        return
    end

    SetMouseCursorActiveThisFrame()
    local mx, my = Gizmo.getMousePosition()
    Gizmo.updateHover(mx, my)

    -- Início do drag
    if IsDisabledControlJustPressed(0, 24) then
        Gizmo.lastCoords = GetEntityCoords(Gizmo.entity)
        if Gizmo.hoveredAxis then
            local clickedAxis = Gizmo.hoveredAxis
            if Gizmo.mode == "translate" and clickedAxis == "xyz" and not Gizmo.isFreeCameraMode() then
                Gizmo.setFreeCameraMode(true)
            end

            if Gizmo.beforeTransformCallback then
                Gizmo.beforeTransformCallback()
            end
            Gizmo.isDragging = true
            Gizmo.activeAxis = clickedAxis
            Gizmo.lastMousePos = { x = mx, y = my }

            if Gizmo.mode == "translate" then
                local ax = Gizmo.activeAxis
                if ax == "xyz" then
                    Gizmo.beginFreeDrag(mx, my)
                    Gizmo.dragAxis = nil
                elseif ax == "xy" or ax == "xz" or ax == "yz" then
                    Gizmo.beginPlaneDrag(ax, mx, my)
                    Gizmo.dragAxis = nil
                elseif ax == "x" or ax == "y" or ax == "z" then
                    Gizmo.beginAxisDrag(ax, mx, my)
                    Gizmo.dragPlane = nil
                else
                    Gizmo.dragPlane = nil
                    Gizmo.dragAxis = nil
                end
            else
                Gizmo.beginRotationDrag(Gizmo.activeAxis, mx, my)
            end
        end
    end

    -- Fim do drag
    if IsDisabledControlJustReleased(0, 24) then
        Gizmo.isDragging = false
        Gizmo.activeAxis = nil
        Gizmo.dragFree = nil
        Gizmo.dragPlane = nil
        Gizmo.dragAxis = nil
        Gizmo.rotationCenter = nil
        Gizmo.rotationLastPos = nil
        Gizmo.rotationStartRotation = nil
        Gizmo.rotationPlaneNormal = nil
    end

    -- Atualizar drag
    if Gizmo.isDragging and Gizmo.activeAxis then
        local dx = mx - Gizmo.lastMousePos.x
        local dy = my - Gizmo.lastMousePos.y

        if Gizmo.mode == "translate" then
            local ax = Gizmo.activeAxis
            if ax == "x" or ax == "y" or ax == "z" then
                Gizmo.updateAxisDrag(mx, my)
            elseif ax == "xyz" then
                Gizmo.updateFreeDrag(mx, my)
            elseif ax == "xy" or ax == "xz" or ax == "yz" then
                Gizmo.updatePlaneDrag(mx, my)
            else
                Gizmo.handleTranslation(dx, dy)
            end
        else
            Gizmo.updateRotationDrag(mx, my)
        end

        Gizmo.lastMousePos = { x = mx, y = my }
    end

    Gizmo.draw()
end

function Gizmo.HandlePropControls(offsetForward, offsetRight, offsetZ, rotX, rotY, rotZ, manualZ, precisionMode, speedMultiplier)
    -- Libera câmera
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    SetPauseMenuActive(false)

    -- Bloqueios básicos
    DisableControlAction(0, 140257, true)   
    DisableControlAction(0, 263, true)      
    DisableControlAction(0, 264, true)      
    DisableControlAction(0, 44, true)       -- Q
    DisableControlAction(0, 38, true)       -- E
    DisableControlAction(0, 174, true)      -- Arrow Left
    DisableControlAction(0, 175, true)      -- Arrow Right
    DisableControlAction(0, 172, true)      -- Arrow Up
    DisableControlAction(0, 173, true)      -- Arrow Down
    DisableControlAction(0, 83, true)       -- =
    DisableControlAction(0, 84, true)       -- -
    DisableControlAction(0, 314, true)      -- Numpad +
    DisableControlAction(0, 315, true)      -- Numpad -

    local baseSpeed = IsControlPressed(0, 21) and 0.04 or 0.015
    local speed = baseSpeed * (speedMultiplier or 1.0)
    local rotSpeed = (IsControlPressed(0, 21) and 3.0 or 1.0) * (speedMultiplier or 1.0)

    if precisionMode then
        -- trava movimento do player
        DisableControlAction(0, 32, true) -- W
        DisableControlAction(0, 31, true) -- S
        DisableControlAction(0, 34, true) -- A
        DisableControlAction(0, 35, true) -- D
        DisableControlAction(0, 30, true) -- MoveLeftRight
        DisableControlAction(0, 31, true) -- MoveUpDown

        -- movimentação precisa
        if IsDisabledControlPressed(0, 32) then offsetForward = math.min(offsetForward + speed, 4.0) end
        if IsDisabledControlPressed(0, 31) then offsetForward = math.max(offsetForward - speed, -4.0) end
        if IsDisabledControlPressed(0, 34) then offsetRight = offsetRight - speed end
        if IsDisabledControlPressed(0, 35) then offsetRight = offsetRight + speed end

        if IsDisabledControlPressed(0, 241) then offsetZ = offsetZ + speed; manualZ = true end
        if IsDisabledControlPressed(0, 242) then offsetZ = offsetZ - speed; manualZ = true end
        if IsDisabledControlPressed(0, 348) then offsetZ = 0.0; manualZ = false end

        -- Rotação Z (Yaw) com Q/E
        local rotation = Gizmo.HandlePrecisionRotation(vector3(rotX, rotY, rotZ), rotSpeed)
        rotX, rotY, rotZ = rotation.x, rotation.y, rotation.z

        -- Rotação Y (Roll) com Arrow Left/Right

        -- Rotação X (Pitch) com Num 4/Num 6
    else
        -- modo normal (sem travar player)
        if IsControlPressed(0, 241) then offsetZ = offsetZ + speed; manualZ = true end
        if IsControlPressed(0, 242) then offsetZ = offsetZ - speed; manualZ = true end
        if IsControlPressed(0, 348) then offsetZ = 0.0; manualZ = false end

        if IsControlPressed(0, 44) then rotZ = rotZ + rotSpeed end
        if IsControlPressed(0, 38) then rotZ = rotZ - rotSpeed end

        if IsControlPressed(0, 174) then rotY = rotY - rotSpeed end
        if IsControlPressed(0, 175) then rotY = rotY + rotSpeed end

        if IsControlPressed(0, 172) then rotX = rotX - rotSpeed end
        if IsControlPressed(0, 173) then rotX = rotX + rotSpeed end
    end

    return offsetForward, offsetRight, offsetZ, rotX, rotY, rotZ, manualZ
end

function Gizmo.HandlePrecisionRotation(rotation, rotSpeed, normalizeFn)
    local keys = Gizmo.precisionKeys or {}
    local normalize = normalizeFn or function(value) return value end
    local rotated = false
    local activeAxis = Gizmo.precisionLastAxis

    if activeAxis == "x" and not (keys.rotXNegative or keys.rotXPositive) then
        activeAxis = nil
    elseif activeAxis == "y" and not (keys.rotYNegative or keys.rotYPositive) then
        activeAxis = nil
    elseif activeAxis == "z" and not (keys.rotZNegative or keys.rotZPositive) then
        activeAxis = nil
    end

    if not activeAxis then
        if keys.rotXNegative or keys.rotXPositive then
            activeAxis = "x"
        elseif keys.rotYNegative or keys.rotYPositive then
            activeAxis = "y"
        elseif keys.rotZNegative or keys.rotZPositive then
            activeAxis = "z"
        end
        Gizmo.precisionLastAxis = activeAxis
    end

    if activeAxis == "z" and keys.rotZPositive then
        rotation = vector3(rotation.x, rotation.y, normalize(rotation.z + rotSpeed))
        rotated = true
    end
    if activeAxis == "z" and keys.rotZNegative then
        rotation = vector3(rotation.x, rotation.y, normalize(rotation.z - rotSpeed))
        rotated = true
    end

    if activeAxis == "y" and keys.rotYNegative then
        rotation = vector3(rotation.x, normalize(rotation.y - rotSpeed), rotation.z)
        rotated = true
    end
    if activeAxis == "y" and keys.rotYPositive then
        rotation = vector3(rotation.x, normalize(rotation.y + rotSpeed), rotation.z)
        rotated = true
    end

    if activeAxis == "x" and keys.rotXNegative then
        rotation = vector3(normalize(rotation.x - rotSpeed), rotation.y, rotation.z)
        rotated = true
    end
    if activeAxis == "x" and keys.rotXPositive then
        rotation = vector3(normalize(rotation.x + rotSpeed), rotation.y, rotation.z)
        rotated = true
    end

    return rotation, rotated
end

local function formatNumber(value, decimals)
    return string.format(("%." .. (decimals or 3) .. "f"), tonumber(value) or 0.0)
end

local function formatVector(value, decimals)
    if not value then return "0.000, 0.000, 0.000" end

    return ("%s, %s, %s"):format(
        formatNumber(value.x, decimals),
        formatNumber(value.y, decimals),
        formatNumber(value.z, decimals)
    )
end

function Gizmo.getPreviewData()
    if not Gizmo.entity or not DoesEntityExist(Gizmo.entity) then return nil end

    local netId = nil
    if NetworkGetEntityIsNetworked(Gizmo.entity) then
        netId = NetworkGetNetworkIdFromEntity(Gizmo.entity)
    end

    return {
        title = Gizmo.previewTitle or "Gizmo Preview",
        entity = Gizmo.entity,
        netId = netId,
        model = GetEntityModel(Gizmo.entity),
        mode = Gizmo.mode,
        space = Gizmo.space,
        precision = Gizmo.isPrecisionMode(),
        freeCamera = Gizmo.isFreeCameraMode(),
        precisionSpeed = Gizmo.getPrecisionSpeed(),
        activeAxis = Gizmo.activeAxis,
        hoveredAxis = Gizmo.hoveredAxis,
        dragging = Gizmo.isDragging == true,
        coords = GetEntityCoords(Gizmo.entity),
        rotation = GetEntityRotation(Gizmo.entity, 2),
        gizmoCoords = Gizmo.getGizmoWorldPosition(),
    }
end

function Gizmo.buildPreviewText()
    local data = Gizmo.getPreviewData()
    if not data then return nil end

    return ("%s\nModo: %s | Espaco: %s | Precision: %s | Camera: %s | Speed: %.1f\nEntity: %s | Axis: %s | Hover: %s | Drag: %s\nCoords: %s\nRot: %s\nGizmo: %s"):format(
        data.title,
        data.mode or "N/A",
        data.space or "N/A",
        data.precision and "on" or "off",
        data.freeCamera and "player" or "focus",
        data.precisionSpeed or 1.0,
        data.entity or "N/A",
        data.activeAxis or "none",
        data.hoveredAxis or "none",
        tostring(data.dragging),
        formatVector(data.coords, 3),
        formatVector(data.rotation, 2),
        formatVector(data.gizmoCoords, 3)
    )
end

function Gizmo.buildEntityInfoText()
    local data = Gizmo.getPreviewData()
    if not data then return nil end

    return ("Entity: %s | NetId: %s\nModel: %s\nCoords: %s\nRot: %s\nMode: %s | Camera: %s | Precision: %s | Speed: %.1f"):format(
        data.entity or "N/A",
        data.netId or "local",
        data.model or "N/A",
        formatVector(data.coords, 3),
        formatVector(data.rotation, 2),
        data.mode or "N/A",
        data.freeCamera and "player" or "focus",
        data.precision and "on" or "off",
        data.precisionSpeed or 1.0
    )
end

function Gizmo.drawPreview(force)
    local textApi = getDrawText()
    if not textApi or not textApi.drawText2d then return end

    local now = GetGameTimer()
    if force or (now - (Gizmo.previewLastUpdate or 0)) >= (GizmoConfig.previewUpdateInterval or 150) then
        local text = Gizmo.buildPreviewText()
        if text then
            Gizmo.previewLastUpdate = now
            Gizmo.previewLastText = text
        end

        Gizmo.previewEntityText = Gizmo.buildEntityInfoText()
    end

    if not Gizmo.previewLastText then return end

    textApi.drawText2d({
        text = Gizmo.previewLastText,
        coords = vec2(0.72, 0.50),
        scale = 0.28,
        font = 4,
        color = vec4(255, 255, 255, 230),
        width = 0.0,
        height = 0.0,
        align = "left",
        wrapLeft = 0.70,
        wrapRight = 0.98,
        enableDropShadow = true,
        enableOutline = true,
    })

    if textApi.drawText3d and Gizmo.previewEntityText and Gizmo.entity and DoesEntityExist(Gizmo.entity) then
        local coords = Gizmo.getGizmoWorldPosition() or GetEntityCoords(Gizmo.entity)
        textApi.drawText3d({
            text = Gizmo.previewEntityText,
            coords = coords + vector3(0.0, 0.0, 0.55),
            scale = vec2(0.28, 0.28),
            font = 4,
            color = vec4(255, 255, 255, 245),
            align = "left",
            wrapLeft = 0.0,
            wrapRight = 1.0,
            enableDropShadow = true,
            enableOutline = true,
        })
    end
end

function Gizmo.hidePreview()
    Gizmo.previewLastText = nil
    Gizmo.previewEntityText = nil
    Gizmo.previewLastUpdate = 0
end

-- ============================================================
-- KEYBINDS
-- ============================================================

local function getKeybindButton(commandName)
    local hash = GetHashKey("+" .. commandName)
    hash = hash | 2147483648
    return GetControlInstructionalButton(2, hash, true)
end

local function freeCameraCommandName()
    return "prBridgeGizmoFreeCamera" .. resourceName
end

local function modeCommandName()
    return "kqGizmoRotation" .. resourceName
end

local function groundCommandName()
    return "prBridgeGizmoGround" .. resourceName
end

local function controlButton(controlId, inputGroup)
    return GetControlInstructionalButton(inputGroup or 2, controlId, true)
end

local function buildMouseKeybinds()
    return "mouse", {
        { label = "OK", control = controlButton(201), controlId = 201 },
        { label = "Drag", control = controlButton(24), controlId = 24 },
        { label = "Cam", control = controlButton(25), controlId = 25 },
        { label = "Zoom+", control = controlButton(241), controlId = 241 },
        { label = "Zoom-", control = controlButton(242), controlId = 242 },
        { label = "Mode", control = getKeybindButton(modeCommandName()) },
        { label = "Ground", control = getKeybindButton(groundCommandName()) },
        { label = "Prec", control = controlButton(37), controlId = 37 },
        { label = Gizmo.isFreeCameraMode() and "Focus" or "Free", control = getKeybindButton(freeCameraCommandName()) },
    }
end

local function buildPrecisionKeybinds()
    return "precision", {
        { label = "OK", control = controlButton(201), controlId = 201 },
        { label = "Move", control = controlButton(32), controlId = 32 },
        { label = "Pit+", control = controlButton(172), controlId = 172 },
        { label = "Pit-", control = controlButton(173), controlId = 173 },
        { label = "Roll-", control = controlButton(174), controlId = 174 },
        { label = "Roll+", control = controlButton(175), controlId = 175 },
        { label = "Yaw+", control = controlButton(44), controlId = 44 },
        { label = "Yaw-", control = controlButton(38), controlId = 38 },
        { label = "Spd+", control = controlButton(83), controlId = 83 },
        { label = "Spd-", control = controlButton(84), controlId = 84 },
        { label = "Cam", control = controlButton(25), controlId = 25 },
        { label = "Ground", control = getKeybindButton(groundCommandName()) },
        { label = "Mouse", control = controlButton(37), controlId = 37 },
        { label = "Free", control = getKeybindButton(freeCameraCommandName()) },
    }
end

local function buildFreeCameraKeybinds()
    return "freecamera", {
        { label = "Focus", control = getKeybindButton(freeCameraCommandName()) },
        { label = "Ground", control = getKeybindButton(groundCommandName()) },
        { label = "Confirm", control = controlButton(201), controlId = 201 },
    }
end

function Gizmo.invalidateKeybinds()
    if Gizmo._keybindRenderer and Gizmo._keybindRenderer.dispose then
        Gizmo._keybindRenderer:dispose()
    end

    Gizmo._keybindRenderer = nil
    Gizmo._keybindMode = nil
end

function Gizmo.drawKeybinds()
    local buttonsApi = getInstructionalButtons()
    if not buttonsApi or not buttonsApi.create then return end

    local mode, buttons

    if Gizmo.isFreeCameraMode() then
        mode, buttons = buildFreeCameraKeybinds()
    elseif Gizmo.isPrecisionMode() then
        mode, buttons = buildPrecisionKeybinds()
    else
        mode, buttons = buildMouseKeybinds()
    end

    if type(buttons) ~= "table" then
        bridgeDebug("warn", ("[pr_bridge:gizmo] instructionalButtons sem lista valida. mode=%s"):format(tostring(mode)))
        return
    end

    if Gizmo._keybindRenderer and Gizmo._keybindRenderer.handle and not HasScaleformMovieLoaded(Gizmo._keybindRenderer.handle) then
        Gizmo.invalidateKeybinds()
    end

    if not Gizmo._keybindRenderer or Gizmo._keybindMode ~= mode then
        Gizmo.invalidateKeybinds()
        Gizmo._keybindRenderer = buttonsApi.create(buttons, {
            clickable = false,
            timeout = 1000,
            drawMode = 0,
        })
        Gizmo._keybindMode = mode
        bridgeDebug(Gizmo._keybindRenderer and "info" or "warn", ("[pr_bridge:gizmo] instructionalButtons mode=%s renderer=%s slots=%s"):format(
            mode,
            Gizmo._keybindRenderer and "ok" or "nil",
            #buttons
        ))
    end

    if Gizmo._keybindRenderer and Gizmo._keybindRenderer.draw then
        Gizmo._keybindRenderer:draw()
    end
end

-- Registrar comandos de tecla
local resName = GetCurrentResourceName()

local function registerPrecisionRotationKey(commandName, stateKey, axisName, defaultKey)
    RegisterCommand("+" .. commandName .. resName, function()
        if not (Gizmo.isPrecisionMode() and Gizmo.entity) then return end
        Gizmo.precisionKeys[stateKey] = true
        Gizmo.precisionLastAxis = axisName
    end, false)

    RegisterCommand("-" .. commandName .. resName, function()
        Gizmo.precisionKeys[stateKey] = false
        if axisName == Gizmo.precisionLastAxis then
            Gizmo.precisionLastAxis = nil
        end
    end, false)

    RegisterKeyMapping("+" .. commandName .. resName, Locales['Gizmo']['Rotate'], "keyboard", defaultKey)
end

registerPrecisionRotationKey("prBridgePrecisionRotZPositive", "rotZPositive", "z", "Q")
registerPrecisionRotationKey("prBridgePrecisionRotZNegative", "rotZNegative", "z", "E")
registerPrecisionRotationKey("prBridgePrecisionRotYNegative", "rotYNegative", "y", "LEFT")
registerPrecisionRotationKey("prBridgePrecisionRotYPositive", "rotYPositive", "y", "RIGHT")
registerPrecisionRotationKey("prBridgePrecisionRotXNegativeNew", "rotXNegative", "x", "UP")
registerPrecisionRotationKey("prBridgePrecisionRotXPositiveNew", "rotXPositive", "x", "DOWN")

RegisterCommand("+kqGizmoRotation" .. resName, function()
    if not Gizmo.entity then return end
    Gizmo.toggleMode()
end, false)

RegisterCommand("-kqGizmoRotation" .. resName, function() end, false)

RegisterKeyMapping("+kqGizmoRotation" .. resName, "Gizmo move/rotate", "keyboard", "R")

RegisterCommand("+" .. freeCameraCommandName(), function()
    if not Gizmo.entity or Gizmo.allowFreeCameraToggle == false then return end
    Gizmo.toggleFreeCameraMode()
end, false)

RegisterCommand("-" .. freeCameraCommandName(), function() end, false)

RegisterKeyMapping("+" .. freeCameraCommandName(), "Gizmo freecam/focus", "keyboard", "F")

RegisterCommand("+" .. groundCommandName(), function()
    if not Gizmo.entity then return end
    Gizmo.placeEntityOnGround()
end, false)

RegisterCommand("-" .. groundCommandName(), function() end, false)

RegisterKeyMapping("+" .. groundCommandName(), "Gizmo ground", "keyboard", "G")

Gizmo.config = GizmoConfig

if _G then
    _G.PRBridgeGizmo = Gizmo
    _G.Gizmo = _G.Gizmo or Gizmo
end

return Gizmo
