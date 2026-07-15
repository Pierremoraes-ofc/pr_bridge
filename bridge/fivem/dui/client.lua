local dui = {}
local DUI_BUILD = "2026-06-23-renderTargetState-safe"

local resourceName = GetCurrentResourceName()
local activeDuis = {}
local currentId = 0
local polyThread = false
local focused = false
local focusedCamera = nil
local focusedDui = nil
local DEFAULT_MOUSE_TOGGLE_KEY = 19

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

local function stopRenderTargetForInstance(instance)
    if type(instance) ~= "table" then return end

    local state = rawget(instance, "renderTargetState")
    if type(state) == "table" then
        state.active = false
    end
    instance.renderTargetState = nil

    local legacyState = rawget(instance, "renderTarget")
    if type(legacyState) == "table" then
        legacyState.active = false
        instance.renderTarget = nil
    end
end

CreateThread(function()
    Wait(0)
    debug("info", ("[pr_bridge:dui] client build=%s resource=%s"):format(DUI_BUILD, resourceName))
end)

local function encodeJson(value)
    if type(value) == "string" then return value end

    if type(json) == "table" and type(json.encode) == "function" then
        local ok, encoded = pcall(json.encode, value)
        if ok and encoded then return encoded end
    end

    return tostring(value)
end

local function waitUntil(predicate, timeout)
    local expires = GetGameTimer() + (timeout or 5000)

    repeat
        if predicate() then return true end
        Wait(0)
    until GetGameTimer() >= expires

    return predicate() == true
end

local function sanitizeName(value, fallback)
    value = tostring(value or fallback or "dui")
    value = value:gsub("[^%w_]", "_")

    if value == "" then return fallback or "dui" end
    return value
end

local function nextId(id)
    if type(id) == "string" and id ~= "" then return sanitizeName(id) end

    currentId = currentId + 1
    return sanitizeName(("%s_%s_%s"):format(resourceName, GetGameTimer(), currentId))
end

local function makeRuntimeName(kind, id)
    return sanitizeName(("pr_dui_%s_%s"):format(kind, id))
end

local function hash(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return joaat(value) end
    return nil
end

local function getEntityFromNetId(netId, timeout)
    netId = tonumber(netId)
    if not netId or netId <= 0 then return nil end

    local function resolveEntity()
        if NetworkDoesNetworkIdExist and not NetworkDoesNetworkIdExist(netId) then return nil end
        if not NetworkDoesEntityExistWithNetworkId(netId) then return nil end

        local entity = NetworkGetEntityFromNetworkId(netId)
        if entity and entity > 0 and DoesEntityExist(entity) then return entity end

        return nil
    end

    return resolveEntity() or waitUntil(function()
        return resolveEntity()
    end, timeout or 3000) and resolveEntity()
end

local function toVector2(value, fallback)
    fallback = fallback or vector2(0.5, 0.5)
    if not value then return fallback end
    if value.x and value.y then return vector2(value.x + 0.0, value.y + 0.0) end
    if type(value) == "table" then return vector2((value[1] or fallback.x) + 0.0, (value[2] or fallback.y) + 0.0) end
    return fallback
end

local function toVector3(value, fallback)
    fallback = fallback or vector3(0.0, 0.0, 0.0)
    if not value then return fallback end
    if value.x and value.y and value.z then return vector3(value.x + 0.0, value.y + 0.0, value.z + 0.0) end

    if type(value) == "table" then
        return vector3(
            (value[1] or fallback.x) + 0.0,
            (value[2] or fallback.y) + 0.0,
            (value[3] or fallback.z) + 0.0
        )
    end

    return fallback
end

local function toVector4(value, fallback)
    fallback = fallback or vector4(255, 255, 255, 255)
    if not value then return fallback end

    return vector4(
        value.r or value.x or value[1] or fallback.x or 255,
        value.g or value.y or value[2] or fallback.y or 255,
        value.b or value.z or value[3] or fallback.z or 255,
        value.a or value.w or value[4] or fallback.w or 255
    )
end

local function colorChannels(value)
    local color = toVector4(value)

    return math.floor(color.x or color.r or 255),
        math.floor(color.y or color.g or 255),
        math.floor(color.z or color.b or 255),
        math.floor(color.w or color.a or 255)
end

local function normalizeUrl(url, ownerResource)
    if type(url) ~= "string" or url == "" then return nil end

    if url:find("^https?://") or url:find("^nui://") or url == "about:blank" then
        return url
    end

    ownerResource = ownerResource or resourceName
    url = url:gsub("^/", "")

    return ("https://cfx-nui-%s/%s"):format(ownerResource, url)
end

local function resolve(target)
    if type(target) == "table" and target.id and activeDuis[target.id] == target then
        return target
    end

    if type(target) == "table" and target.id then
        return activeDuis[target.id]
    end

    if target ~= nil then
        return activeDuis[tostring(target)]
    end

    return nil
end

local function normalizeSpriteOptions(options)
    options = options or {}

    local coords = toVector2(options.coords or options.position or {
        options.x or 0.5,
        options.y or 0.5,
    })

    return {
        coords = coords,
        width = tonumber(options.width or options.w) or 0.25,
        height = tonumber(options.height or options.h) or 0.25,
        rotation = tonumber(options.rotation or options.heading) or 0.0,
        color = options.color or { 255, 255, 255, options.alpha or 255 },
    }
end

local function clamp01(value)
    value = tonumber(value) or 0.0
    if value < 0.0 then return 0.0 end
    if value > 1.0 then return 1.0 end
    return value
end

local function projectWorldToScreen(coords)
    if not coords then return nil, nil end

    local ok, onScreen, screenX, screenY = pcall(GetScreenCoordFromWorldCoord, coords.x, coords.y, coords.z)
    if ok and onScreen then return screenX, screenY end

    return nil, nil
end

local function getProjectedBounds(points)
    local left, top, right, bottom
    local visible = 0

    for i = 1, #points do
        local sx, sy = projectWorldToScreen(points[i])

        if sx and sy then
            visible = visible + 1
            left = left and math.min(left, sx) or sx
            top = top and math.min(top, sy) or sy
            right = right and math.max(right, sx) or sx
            bottom = bottom and math.max(bottom, sy) or sy
        end
    end

    if visible == 0 or not left or not top or not right or not bottom then return nil end

    return {
        left = left,
        top = top,
        width = math.max(0.001, right - left),
        height = math.max(0.001, bottom - top),
    }
end

local function getEntityScreenBounds(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end

    local model = GetEntityModel(entity)
    local ok, minDim, maxDim = pcall(GetModelDimensions, model)
    if not ok or not minDim or not maxDim then return nil end

    local points = {}
    local index = 1

    for _, x in ipairs({ minDim.x, maxDim.x }) do
        for _, y in ipairs({ minDim.y, maxDim.y }) do
            for _, z in ipairs({ minDim.z, maxDim.z }) do
                points[index] = GetOffsetFromEntityInWorldCoords(entity, x, y, z)
                index = index + 1
            end
        end
    end

    return getProjectedBounds(points)
end

local function getPolyScreenBounds(poly)
    if type(poly) ~= "table" then return nil end

    if poly.p1 and poly.p2 and poly.p3 and poly.p4 then
        return getProjectedBounds({
            toVector3(poly.p1),
            toVector3(poly.p2),
            toVector3(poly.p3),
            toVector3(poly.p4),
        })
    end

    if not poly.pointA or not poly.pointB then return nil end

    return getProjectedBounds({
        vector3(poly.pointA.x, poly.pointA.y, poly.minZ),
        vector3(poly.pointA.x, poly.pointA.y, poly.maxZ),
        vector3(poly.pointB.x, poly.pointB.y, poly.minZ),
        vector3(poly.pointB.x, poly.pointB.y, poly.maxZ),
    })
end

local function getMouseBounds(instance)
    local mouse = instance and instance.mouse
    if not mouse then return { left = 0.0, top = 0.0, width = 1.0, height = 1.0 } end

    local bounds = mouse.bounds
    if type(bounds) == "table" then
        local coords = toVector2(bounds.coords or bounds.position or { bounds.x or bounds.left or 0.0, bounds.y or bounds.top or 0.0 })
        return {
            left = tonumber(bounds.left or bounds.x) or coords.x,
            top = tonumber(bounds.top or bounds.y) or coords.y,
            width = tonumber(bounds.width or bounds.w) or 1.0,
            height = tonumber(bounds.height or bounds.h) or 1.0,
        }
    end

    if (mouse.map == "sprite" or mouse.map == nil) and instance.sprite and instance.sprite.options then
        local sprite = instance.sprite.options
        return {
            left = sprite.coords.x - sprite.width * 0.5,
            top = sprite.coords.y - sprite.height * 0.5,
            width = sprite.width,
            height = sprite.height,
        }
    end

    if mouse.map == "poly" and instance.poly then
        return getPolyScreenBounds(instance.poly) or { left = 0.0, top = 0.0, width = 1.0, height = 1.0 }
    end

    if mouse.map == "entity" or (not mouse.map and instance.renderTargetState) then
        local entity = mouse.entity or (instance.renderTargetState and instance.renderTargetState.entity)

        if entity and DoesEntityExist(entity) then
            return getEntityScreenBounds(entity) or { left = 0.0, top = 0.0, width = 1.0, height = 1.0 }
        end
    end

    return { left = 0.0, top = 0.0, width = 1.0, height = 1.0 }
end

local function getMappedMousePosition(instance)
    if type(instance) ~= "table" then return nil, nil, false end

    local mouse = instance.mouse or {}
    local mx = GetDisabledControlNormal(0, 239)
    local my = GetDisabledControlNormal(0, 240)
    local bounds = getMouseBounds(instance)
    local width = tonumber(bounds.width) or 1.0
    local height = tonumber(bounds.height) or 1.0

    if width <= 0.0 then width = 1.0 end
    if height <= 0.0 then height = 1.0 end

    local relX = (mx - (bounds.left or 0.0)) / width
    local relY = (my - (bounds.top or 0.0)) / height
    local inside = relX >= 0.0 and relX <= 1.0 and relY >= 0.0 and relY <= 1.0

    if mouse.requireInside == true and not inside then return nil, nil, false end

    if mouse.clamp ~= false then
        relX = clamp01(relX)
        relY = clamp01(relY)
    end

    local duiWidth = math.max(1, tonumber(instance.width) or 1)
    local duiHeight = math.max(1, tonumber(instance.height) or 1)

    return math.floor(relX * (duiWidth - 1)), math.floor(relY * (duiHeight - 1)), inside
end
local function resolveColor(instance, overrideColor)
    local baseColor = overrideColor or (instance and instance.color) or { 255, 255, 255, 255 }
    local r, g, b, a = colorChannels(baseColor)

    if instance then
        if instance.opacity then
            a = math.floor(instance.opacity * 255)
        end
        if instance.brightness then
            r = math.min(255, math.floor(r * instance.brightness))
            g = math.min(255, math.floor(g * instance.brightness))
            b = math.min(255, math.floor(b * instance.brightness))
        end
    end

    return r, g, b, a
end

local function drawDuiSprite(instance, options)
    options = normalizeSpriteOptions(options)
    local r, g, b, a = resolveColor(instance, options.color)

    DrawSprite(
        instance.txd,
        instance.txn,
        options.coords.x,
        options.coords.y,
        options.width,
        options.height,
        options.rotation,
        r,
        g,
        b,
        a
    )
end

local function drawPolyPreview(pointA, pointB, minZ, maxZ, color)
    local r, g, b, a = colorChannels(color or { 0, 180, 90, 90 })

    DrawPoly(pointB.x, pointB.y, minZ, pointB.x, pointB.y, maxZ, pointA.x, pointA.y, maxZ, r, g, b, a)
    DrawPoly(pointB.x, pointB.y, minZ, pointA.x, pointA.y, maxZ, pointA.x, pointA.y, minZ, r, g, b, a)
end

local function drawPoly4Preview(p1, p2, p3, p4, color)
    local r, g, b, a = colorChannels(color or { 0, 180, 90, 90 })

    DrawPoly(p3.x, p3.y, p3.z, p2.x, p2.y, p2.z, p1.x, p1.y, p1.z, r, g, b, a)
    DrawPoly(p1.x, p1.y, p1.z, p4.x, p4.y, p4.z, p3.x, p3.y, p3.z, r, g, b, a)

    DrawPoly(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p3.x, p3.y, p3.z, r, g, b, a)
    DrawPoly(p3.x, p3.y, p3.z, p4.x, p4.y, p4.z, p1.x, p1.y, p1.z, r, g, b, a)
end

local function drawDuiOnArea(instance, poly)
    local r, g, b, a = resolveColor(instance, poly.color)
    
    if poly.p1 and poly.p2 and poly.p3 and poly.p4 then
        local p1 = toVector3(poly.p1)
        local p2 = toVector3(poly.p2)
        local p3 = toVector3(poly.p3)
        local p4 = toVector3(poly.p4)

        -- Front Face
        DrawSpritePoly(
            p3.x, p3.y, p3.z,
            p2.x, p2.y, p2.z,
            p1.x, p1.y, p1.z,
            r, g, b, a,
            instance.txd,
            instance.txn,
            1.0, 1.0, 1.0,
            1.0, 0.0, 1.0,
            0.0, 0.0, 1.0
        )

        DrawSpritePoly(
            p1.x, p1.y, p1.z,
            p4.x, p4.y, p4.z,
            p3.x, p3.y, p3.z,
            r, g, b, a,
            instance.txd,
            instance.txn,
            0.0, 0.0, 1.0,
            0.0, 1.0, 1.0,
            1.0, 1.0, 1.0
        )

        -- Back Face
        DrawSpritePoly(
            p1.x, p1.y, p1.z,
            p2.x, p2.y, p2.z,
            p3.x, p3.y, p3.z,
            r, g, b, a,
            instance.txd,
            instance.txn,
            0.0, 0.0, 1.0,
            1.0, 0.0, 1.0,
            1.0, 1.0, 1.0
        )

        DrawSpritePoly(
            p3.x, p3.y, p3.z,
            p4.x, p4.y, p4.z,
            p1.x, p1.y, p1.z,
            r, g, b, a,
            instance.txd,
            instance.txn,
            1.0, 1.0, 1.0,
            0.0, 1.0, 1.0,
            0.0, 0.0, 1.0
        )
    else
        local pointA = poly.pointA
        local pointB = poly.pointB
        local minZ = poly.minZ
        local maxZ = poly.maxZ

        DrawSpritePoly(
            pointB.x,
            pointB.y,
            minZ,
            pointB.x,
            pointB.y,
            maxZ,
            pointA.x,
            pointA.y,
            maxZ,
            r,
            g,
            b,
            a,
            instance.txd,
            instance.txn,
            1.0,
            1.0,
            1.0,
            1.0,
            0.0,
            1.0,
            0.0,
            0.0,
            1.0
        )

        DrawSpritePoly(
            pointA.x,
            pointA.y,
            maxZ,
            pointA.x,
            pointA.y,
            minZ,
            pointB.x,
            pointB.y,
            minZ,
            r,
            g,
            b,
            a,
            instance.txd,
            instance.txn,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0
        )
    end
end

local function shouldDrawPoly(poly, playerCoords, ped)
    local center = poly.center

    if not center then
        if poly.p1 and poly.p2 and poly.p3 and poly.p4 then
            center = (toVector3(poly.p1) + toVector3(poly.p2) + toVector3(poly.p3) + toVector3(poly.p4)) * 0.25
        else
            center = vector3(
                (poly.pointA.x + poly.pointB.x) * 0.5,
                (poly.pointA.y + poly.pointB.y) * 0.5,
                (poly.minZ + poly.maxZ) * 0.5
            )
        end

        poly.center = center
    end

    local renderDistance = tonumber(poly.renderDistance) or 35.0
    if #(playerCoords - center) > renderDistance then return false end

    if poly.occlusion == true then
        local ray = StartShapeTestRay(
            playerCoords.x,
            playerCoords.y,
            playerCoords.z,
            center.x,
            center.y,
            center.z,
            4294967295,
            ped,
            0
        )

        local _, hit, hitCoords = GetShapeTestResult(ray)

        if hit == 1 or hit == true then
            local hitDistance = #(playerCoords - hitCoords)
            local centerDistance = #(playerCoords - center)
            if hitDistance + 0.05 < centerDistance then return false end
        end
    end

    return true
end

local function ensurePolyThread()
    if polyThread then return end

    polyThread = true
    CreateThread(function()
        while true do
            local hasPoly = false
            local rendered = 0
            local maxPolys = 6
            local sleep = 1000
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)

            for _, instance in pairs(activeDuis) do
                local poly = instance.poly

                if instance.active and poly and poly.active then
                    hasPoly = true
                    maxPolys = tonumber(poly.maxRendered) or maxPolys

                    if rendered < maxPolys and shouldDrawPoly(poly, playerCoords, ped) then
                        sleep = 0
                        drawDuiOnArea(instance, poly)
                        rendered = rendered + 1
                    end
                end
            end

            if not hasPoly then
                polyThread = false
                return
            end

            Wait(sleep)
        end
    end)
end

local function showHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function rotationToDirection(rotation)
    local adjustedRotation = vector3(
        math.rad(rotation.x),
        math.rad(rotation.y),
        math.rad(rotation.z)
    )

    return vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
end

local function raycastFromCamera(distance, flags, ignoreEntity)
    distance = tonumber(distance) or 200.0
    flags = flags or 4294967295

    local camCoords = GetGameplayCamCoord()
    local camRotation = GetGameplayCamRot(2)
    local direction = rotationToDirection(camRotation)
    local destination = camCoords + direction * distance

    local ray = StartShapeTestRay(
        camCoords.x,
        camCoords.y,
        camCoords.z,
        destination.x,
        destination.y,
        destination.z,
        flags,
        ignoreEntity or PlayerPedId(),
        0
    )

    local _, hit, hitCoords, normal, entity = GetShapeTestResult(ray)
    if hit == 1 or hit == true then
        return hitCoords, entity, normal, true
    end

    return destination, entity, normal, false
end

local function bindInstanceMethods(instance)
    function instance:destroy()
        return dui.destroy(self.id)
    end

    function instance:remove()
        return dui.destroy(self.id)
    end

    function instance:setUrl(url)
        return dui.setUrl(self.id, url)
    end

    function instance:send(message)
        return dui.send(self.id, message)
    end

    function instance:sendMessage(message)
        return dui.send(self.id, message)
    end

    function instance:sendMouseMove(x, y)
        return dui.sendMouseMove(self.id, x, y)
    end

    function instance:sendMouseDown(button)
        return dui.sendMouseDown(self.id, button)
    end

    function instance:sendMouseUp(button)
        return dui.sendMouseUp(self.id, button)
    end

    function instance:sendMouseWheel(deltaX, deltaY)
        return dui.sendMouseWheel(self.id, deltaX, deltaY)
    end

    function instance:enableMouse(options)
        return dui.enableMouse(self.id, options)
    end

    function instance:disableMouse()
        return dui.disableMouse(self.id)
    end

    function instance:toggleMouse(state)
        return dui.toggleMouse(self.id, state)
    end

    function instance:drawSprite(options)
        return dui.drawSprite(self.id, options)
    end

    function instance:startSprite(options)
        return dui.startSprite(self.id, options)
    end

    function instance:stopSprite()
        return dui.stopSprite(self.id)
    end

    function instance:replaceTexture(options)
        return dui.replaceTexture(self.id, options)
    end

    function instance:removeReplaceTexture(options)
        return dui.removeReplaceTexture(self.id, options)
    end

    function instance:renderTarget(options)
        return dui.renderTarget(self.id, options)
    end

    function instance:stopRenderTarget()
        return dui.stopRenderTarget(self.id)
    end

    function instance:startPoly(options)
        return dui.startPoly(self.id, options)
    end

    function instance:stopPoly()
        return dui.stopPoly(self.id)
    end

    function instance:focus(options)
        return dui.focus(self.id, options)
    end

    function instance:setOpacity(opacity)
        return dui.setOpacity(self.id, opacity)
    end

    function instance:setBrightness(brightness)
        return dui.setBrightness(self.id, brightness)
    end
end

function dui.url(path, ownerResource)
    return normalizeUrl(path, ownerResource)
end

function dui.nuiUrl(path, ownerResource)
    return normalizeUrl(path, ownerResource)
end

function dui.create(options, width, height)
    if type(options) == "string" then
        options = {
            url = options,
            width = width,
            height = height,
        }
    end

    options = options or {}

    local url = normalizeUrl(options.url, options.resource or options.ownerResource)
    if not url then return nil, "invalid_url" end

    width = tonumber(options.width or options.w or width) or 1024
    height = tonumber(options.height or options.h or height) or 576

    if width <= 0 or height <= 0 then return nil, "invalid_size" end

    local id = nextId(options.id or options.name)
    if activeDuis[id] then
        if options.replace == false then return nil, "dui_exists" end
        dui.destroy(id)
    end

    local duiObject = CreateDui(url, width, height)
    if not duiObject then return nil, "create_failed" end

    if options.wait ~= false then
        local loaded = waitUntil(function()
            return IsDuiAvailable(duiObject)
        end, options.timeout or 5000)

        if not loaded then
            DestroyDui(duiObject)
            return nil, "dui_timeout"
        end
    end

    local handle = GetDuiHandle(duiObject)
    if not handle then
        DestroyDui(duiObject)
        return nil, "dui_handle_failed"
    end

    local txdName = options.txd or options.dict or makeRuntimeName("txd", id)
    local txnName = options.txn or options.texture or makeRuntimeName("txn", id)
    local runtimeTxd = CreateRuntimeTxd(txdName)
    local txdObject = CreateRuntimeTextureFromDuiHandle(runtimeTxd, txnName, handle)

    local instance = {
        id = id,
        type = "dui",
        active = true,
        url = url,
        width = width,
        height = height,
        duiObject = duiObject,
        duiHandle = handle,
        handle = handle,
        runtimeTxd = runtimeTxd,
        txdObject = txdObject,
        txd = txdName,
        txn = txnName,
        dictName = txdName,
        txtName = txnName,
        replacements = {},
        debug = options.debug == true,
    }

    bindInstanceMethods(instance)
    activeDuis[id] = instance

    if options.mouse == true or type(options.mouse) == "table" then
        dui.enableMouse(instance.id, options.mouse == true and {} or options.mouse)
    end

    if instance.debug then
        debug("info", ("[pr_bridge:dui] DUI criado id=%s url=%s txd=%s txn=%s"):format(id, url, txdName, txnName))
    end

    return instance
end

function dui.get(id)
    return resolve(id)
end

function dui.list()
    return activeDuis
end

function dui.destroy(target)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    instance.active = false

    if instance.sprite then instance.sprite.active = false end
    stopRenderTargetForInstance(instance)
    if instance.poly then instance.poly.active = false end
    if instance.mouse then dui.disableMouse(instance.id) end

    for i = 1, #instance.replacements do
        local replacement = instance.replacements[i]

        if replacement.active ~= false and type(RemoveReplaceTexture) == "function" then
            pcall(RemoveReplaceTexture, replacement.originalTxd, replacement.originalTxn)
        end

        replacement.active = false
    end

    if instance.duiObject then
        pcall(SetDuiUrl, instance.duiObject, "about:blank")
        pcall(DestroyDui, instance.duiObject)
    end

    activeDuis[instance.id] = nil

    if instance.debug then
        debug("info", ("[pr_bridge:dui] DUI destruido id=%s"):format(instance.id))
    end

    return true
end

function dui.setUrl(target, url)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    url = normalizeUrl(url)
    if not url then return false, "invalid_url" end

    instance.url = url
    SetDuiUrl(instance.duiObject, url)

    return true
end

function dui.send(target, message)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    SendDuiMessage(instance.duiObject, encodeJson(message))
    return true
end

dui.sendMessage = dui.send

function dui.sendMouseMove(target, x, y)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    SendDuiMouseMove(instance.duiObject, math.floor(tonumber(x) or 0), math.floor(tonumber(y) or 0))
    return true
end

function dui.sendMouseDown(target, button)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    SendDuiMouseDown(instance.duiObject, button or "left")
    return true
end

function dui.sendMouseUp(target, button)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    SendDuiMouseUp(instance.duiObject, button or "left")
    return true
end

function dui.sendMouseWheel(target, deltaX, deltaY)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    SendDuiMouseWheel(instance.duiObject, tonumber(deltaY) or 0, tonumber(deltaX) or 0)
    return true
end

function dui.drawSprite(target, options)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    drawDuiSprite(instance, options)
    return true
end

function dui.startSprite(target, options)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    instance.sprite = {
        active = true,
        options = normalizeSpriteOptions(options),
    }

    if instance.mouse and not instance.mouse.map then
        instance.mouse.map = "sprite"
    end

    CreateThread(function()
        while instance.active and instance.sprite and instance.sprite.active do
            drawDuiSprite(instance, instance.sprite.options)
            Wait(0)
        end
    end)

    return true
end

function dui.stopSprite(target)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    if instance.sprite then instance.sprite.active = false end
    instance.sprite = nil

    return true
end

local function applyReplaceTexture(instance, options)
    options = options or {}

    local originalTxd = options.originalTxd or options.txd or options.textureDict or options.dict or options[1]
    local originalTxn = options.originalTxn or options.txn or options.textureName or options.texture or options.name or options[2]

    if type(originalTxd) ~= "string" or originalTxd == "" then return false, "invalid_original_txd" end
    if type(originalTxn) ~= "string" or originalTxn == "" then return false, "invalid_original_txn" end

    AddReplaceTexture(originalTxd, originalTxn, instance.txd, instance.txn)

    instance.replacements[#instance.replacements + 1] = {
        originalTxd = originalTxd,
        originalTxn = originalTxn,
        txd = instance.txd,
        txn = instance.txn,
        active = true,
    }

    return true
end

function dui.replaceTexture(target, options)
    if type(target) == "table" and target.url and not target.duiObject then
        local replaceOptions = type(target.textureOptions) == "table" and target.textureOptions
            or type(target.replaceTexture) == "table" and target.replaceTexture
            or target
        local createOptions = {}

        for key, value in pairs(target) do
            createOptions[key] = value
        end

        if replaceOptions == target then
            createOptions.txd = target.runtimeTxd or target.duiTxd or target.duiDict
            createOptions.txn = target.runtimeTxn or target.duiTxn or target.duiTexture
            createOptions.dict = target.runtimeDict or target.duiDict
            createOptions.texture = target.runtimeTexture or target.duiTexture
        end

        local instance, err = dui.create(createOptions)
        if not instance then return nil, err end

        local ok, replaceErr = applyReplaceTexture(instance, replaceOptions)
        if not ok then
            dui.destroy(instance.id)
            return nil, replaceErr
        end

        return instance
    end

    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    return applyReplaceTexture(instance, options)
end

dui.createReplaceTexture = dui.replaceTexture
dui.createReplacement = dui.replaceTexture

function dui.removeReplaceTexture(target, options)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    options = options or {}
    local originalTxd = options.originalTxd or options.txd or options.textureDict or options.dict or options[1]
    local originalTxn = options.originalTxn or options.txn or options.textureName or options.texture or options.name or options[2]

    for i = #instance.replacements, 1, -1 do
        local replacement = instance.replacements[i]

        if (not originalTxd or replacement.originalTxd == originalTxd) and (not originalTxn or replacement.originalTxn == originalTxn) then
            if type(RemoveReplaceTexture) == "function" then
                pcall(RemoveReplaceTexture, replacement.originalTxd, replacement.originalTxn)
            end

            replacement.active = false
            table.remove(instance.replacements, i)
        end
    end

    return true
end

local function startRenderTarget(instance, options)
    options = options or {}

    local entity = options.entity
    if (not entity or entity == 0 or not DoesEntityExist(entity)) and (options.netId or options.entityNetId or options.networkId) then
        entity = getEntityFromNetId(options.netId or options.entityNetId or options.networkId, options.netTimeout or options.timeout)
    end

    local model = hash(options.model or options.modelHash or (entity and DoesEntityExist(entity) and GetEntityModel(entity)))
    local targetName = options.renderTarget or options.renderTargetName or options.name or "tvscreen"

    if type(targetName) ~= "string" or targetName == "" then return false, "invalid_render_target" end
    if not model then return false, "invalid_model" end

    if not IsNamedRendertargetRegistered(targetName) then
        RegisterNamedRendertarget(targetName, options.p16 == true)
    end

    LinkNamedRendertarget(model)

    local renderId = GetNamedRendertargetRenderId(targetName)
    if not renderId or renderId == -1 then return false, "render_target_not_found" end

    local sprite = normalizeSpriteOptions({
        coords = options.coords or { options.x or 0.5, options.y or 0.5 },
        width = options.spriteWidth or options.drawWidth or options.w or 1.0,
        height = options.spriteHeight or options.drawHeight or options.h or 1.0,
        rotation = options.rotation or 0.0,
        color = options.color or { 255, 255, 255, options.alpha or 255 },
    })

    instance.renderTargetState = {
        active = true,
        name = targetName,
        renderId = renderId,
        model = model,
        entity = entity,
        sprite = sprite,
        drawOrder = tonumber(options.drawOrder) or 4,
        renderDistance = tonumber(options.renderDistance) or nil,
    }

    if instance.mouse then
        if not instance.mouse.map then
            instance.mouse.map = "entity"
        end

        if not instance.mouse.entity and entity and DoesEntityExist(entity) then
            instance.mouse.entity = entity
        end
    end

    CreateThread(function()
        while instance.active and instance.renderTargetState and instance.renderTargetState.active do
            local rt = instance.renderTargetState
            local shouldDraw = true

            if rt.entity and rt.renderDistance and DoesEntityExist(rt.entity) then
                shouldDraw = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(rt.entity)) <= rt.renderDistance
            end

            if shouldDraw then
                SetTextRenderId(rt.renderId)
                SetScriptGfxDrawOrder(rt.drawOrder)
                drawDuiSprite(instance, rt.sprite)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                Wait(0)
            else
                Wait(500)
            end
        end

        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end)

    return true, renderId
end

function dui.renderTarget(target, options)
    if type(target) == "table" and target.url and not target.duiObject then
        local instance, err = dui.create(target)
        if not instance then return nil, err end

        local renderOptions = type(target.renderTargetOptions) == "table" and target.renderTargetOptions
            or type(target.renderTarget) == "table" and target.renderTarget
            or target
        local ok, rtErr = startRenderTarget(instance, renderOptions)
        if not ok then
            dui.destroy(instance.id)
            return nil, rtErr
        end

        return instance
    end

    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    return startRenderTarget(instance, options)
end

dui.createRenderTarget = dui.renderTarget

function dui.stopRenderTarget(target)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    stopRenderTargetForInstance(instance)

    return true
end

function dui.startPoly(target, options)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    options = options or {}

    local p1 = options.p1 or options.pointA or options.point1
    local p2 = options.p2 or options.pointB or options.point2
    local p3 = options.p3 or options.pointC or options.point3
    local p4 = options.p4 or options.pointD or options.point4

    if p1 and p2 and p3 and p4 then
        instance.poly = {
            active = true,
            p1 = toVector3(p1),
            p2 = toVector3(p2),
            p3 = toVector3(p3),
            p4 = toVector3(p4),
            color = options.color or { 255, 255, 255, options.alpha or 255 },
            renderDistance = tonumber(options.renderDistance) or 35.0,
            maxRendered = tonumber(options.maxRendered) or 6,
            occlusion = options.occlusion == true,
        }
    else
        local rawPointA = options.pointA or options.point1 or options.a or options[1]
        local rawPointB = options.pointB or options.point2 or options.b or options[2]

        if not rawPointA or not rawPointB then return false, "invalid_points" end

        local pointA = toVector3(rawPointA)
        local pointB = toVector3(rawPointB)

        local minZ = tonumber(options.minZ) or math.min(pointA.z, pointB.z)
        local maxZ = tonumber(options.maxZ) or math.max(pointA.z, pointB.z)

        if math.abs(maxZ - minZ) < 0.01 then
            maxZ = minZ + (tonumber(options.heightWorld) or 1.0)
        end

        instance.poly = {
            active = true,
            pointA = pointA,
            pointB = pointB,
            minZ = minZ,
            maxZ = maxZ,
            color = options.color or { 255, 255, 255, options.alpha or 255 },
            renderDistance = tonumber(options.renderDistance) or 35.0,
            maxRendered = tonumber(options.maxRendered) or 6,
            occlusion = options.occlusion == true,
        }
    end

    if instance.mouse and not instance.mouse.map then
        instance.mouse.map = "poly"
    end

    ensurePolyThread()
    return true
end

function dui.poly(target, options)
    if type(target) == "table" and target.url and not target.duiObject then
        local instance, err = dui.create(target)
        if not instance then return nil, err end

        local polyOptions = type(target.polyOptions) == "table" and target.polyOptions
            or type(target.poly) == "table" and target.poly
            or target
        local ok, polyErr = dui.startPoly(instance.id, polyOptions)
        if not ok then
            dui.destroy(instance.id)
            return nil, polyErr
        end

        return instance
    end

    return dui.startPoly(target, options)
end

dui.createPoly = dui.poly

function dui.stopPoly(target)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    if instance.poly then instance.poly.active = false end
    if instance.mouse then dui.disableMouse(instance.id) end
    instance.poly = nil

    return true
end

local function setMouseState(instance, state)
    if type(instance) ~= "table" then return false, "mouse_not_enabled" end

    local mouse = instance.mouse
    if not mouse then return false, "mouse_not_enabled" end

    mouse.active = state == true

    if not mouse.active then
        pcall(SendDuiMouseUp, instance.duiObject, "left")
        pcall(SendDuiMouseUp, instance.duiObject, "right")
    end

    debug("info", ("[pr_bridge:dui] mouse %s id=%s toggleKey=%s"):format(
        mouse.active and "enabled" or "disabled",
        tostring(instance.id),
        tostring(mouse.toggleKey)
    ))

    return true
end

local function sendMouseFrame(instance)
    local mouse = instance and instance.mouse
    if not mouse or not mouse.active or not instance.duiObject then return end

    if type(IsDuiAvailable) == "function" then
        local ok, available = pcall(IsDuiAvailable, instance.duiObject)
        if not ok or not available then return end
    end

    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 14, true)
    DisableControlAction(0, 15, true)
    SetMouseCursorActiveThisFrame()

    local px, py = getMappedMousePosition(instance)
    if not px or not py then return end

    pcall(SendDuiMouseMove, instance.duiObject, px, py)

    if IsDisabledControlJustPressed(0, 24) then pcall(SendDuiMouseDown, instance.duiObject, "left") end
    if IsDisabledControlJustReleased(0, 24) then pcall(SendDuiMouseUp, instance.duiObject, "left") end
    if IsDisabledControlJustPressed(0, 25) then pcall(SendDuiMouseDown, instance.duiObject, "right") end
    if IsDisabledControlJustReleased(0, 25) then pcall(SendDuiMouseUp, instance.duiObject, "right") end
    if IsDisabledControlJustPressed(0, 14) then pcall(SendDuiMouseWheel, instance.duiObject, 0, -120) end
    if IsDisabledControlJustPressed(0, 15) then pcall(SendDuiMouseWheel, instance.duiObject, 0, 120) end
end

function dui.enableMouse(target, options)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    options = options or {}
    if options == true then options = {} end

    if instance.mouse then
        instance.mouse.enabled = false
        instance.mouse.active = false
    end

    local entity = options.entity or options.targetEntity or options.object or options.prop
    local mouseState = {
        enabled = true,
        active = options.startActive == true or options.active == true,
        toggleKey = tonumber(options.toggleKey or options.key or options.control) or DEFAULT_MOUSE_TOGGLE_KEY,
        helpText = options.helpText,
        map = options.map or options.mode or options.type,
        entity = entity,
        bounds = options.bounds or options.rect or options.area,
        clamp = options.clamp,
        requireInside = options.requireInside == true,
        thread = true,
    }

    instance.mouse = mouseState

    CreateThread(function()
        while instance.active and instance.mouse == mouseState and mouseState.enabled do
            Wait(0)

            if not instance.active or instance.mouse ~= mouseState or not mouseState.enabled then break end

            local toggleKey = mouseState.toggleKey or DEFAULT_MOUSE_TOGGLE_KEY
            DisableControlAction(0, toggleKey, true)

            if IsDisabledControlJustReleased(0, toggleKey) or IsControlJustReleased(0, toggleKey) then
                setMouseState(instance, not mouseState.active)
                Wait(150)

                if not instance.active or instance.mouse ~= mouseState or not mouseState.enabled then break end
            end

            if mouseState.helpText and mouseState.active then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(mouseState.helpText)
                EndTextCommandDisplayHelp(0, false, false, -1)
            end

            sendMouseFrame(instance)
        end

        mouseState.thread = false
    end)

    debug("info", ("[pr_bridge:dui] mouse watcher enabled id=%s toggleKey=%s active=%s map=%s"):format(
        tostring(instance.id),
        tostring(mouseState.toggleKey),
        tostring(mouseState.active),
        tostring(mouseState.map or "auto")
    ))

    return true
end

function dui.disableMouse(target)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    local mouse = instance.mouse
    if mouse then
        setMouseState(instance, false)
        mouse.enabled = false
        mouse.thread = false
        instance.mouse = nil
    end

    return true
end

function dui.toggleMouse(target, state)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end
    if not instance.mouse then
        local ok, err = dui.enableMouse(instance.id, { startActive = state == nil and true or state == true })
        if not ok then return false, err end
        return true
    end

    return setMouseState(instance, state == nil and not instance.mouse.active or state == true)
end

function dui.setOpacity(target, opacity)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    instance.opacity = clamp01(opacity)
    pcall(SendDuiMessage, instance.duiObject, encodeJson({
        action = "setDuiOpacity",
        opacity = instance.opacity
    }))
    return true
end

function dui.setBrightness(target, brightness)
    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end

    instance.brightness = tonumber(brightness) or 1.0
    if instance.brightness < 0.0 then instance.brightness = 0.0 end
    pcall(SendDuiMessage, instance.duiObject, encodeJson({
        action = "setDuiBrightness",
        brightness = instance.brightness
    }))
    return true
end
function dui.focus(target, options)
    if focused then return false, "already_focused" end

    local instance = resolve(target)
    if not instance then return false, "dui_not_found" end
    if not IsDuiAvailable(instance.duiObject) then return false, "dui_not_available" end

    options = options or {}
    focused = true
    focusedDui = instance

    local entity = options.entity
    local cameraCoords = options.cameraCoords and toVector3(options.cameraCoords)
    local lookAt = options.lookAt and toVector3(options.lookAt)

    if entity and DoesEntityExist(entity) and options.camera ~= false then
        cameraCoords = cameraCoords or GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.45, 0.35)
        lookAt = lookAt or GetEntityCoords(entity)
    end

    if cameraCoords and lookAt then
        focusedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(focusedCamera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
        PointCamAtCoord(focusedCamera, lookAt.x, lookAt.y, lookAt.z)
        SetCamActive(focusedCamera, true)
        RenderScriptCams(true, false, 0, true, true)
    end

    if options.freezePed ~= false then
        FreezeEntityPosition(PlayerPedId(), true)
    end

    CreateThread(function()
        while focused and focusedDui == instance do
            Wait(0)

            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            SetMouseCursorActiveThisFrame()

            local mx = GetDisabledControlNormal(0, 239)
            local my = GetDisabledControlNormal(0, 240)
            local px = math.floor(mx * instance.width)
            local py = math.floor(my * instance.height)

            SendDuiMouseMove(instance.duiObject, px, py)

            if IsDisabledControlJustPressed(0, 24) then SendDuiMouseDown(instance.duiObject, "left") end
            if IsDisabledControlJustReleased(0, 24) then SendDuiMouseUp(instance.duiObject, "left") end
            if IsDisabledControlJustPressed(0, 25) then SendDuiMouseDown(instance.duiObject, "right") end
            if IsDisabledControlJustReleased(0, 25) then SendDuiMouseUp(instance.duiObject, "right") end
            if IsDisabledControlJustPressed(0, 14) then SendDuiMouseWheel(instance.duiObject, 0, -120) end
            if IsDisabledControlJustPressed(0, 15) then SendDuiMouseWheel(instance.duiObject, 0, 120) end

            if IsDisabledControlJustPressed(0, options.closeControl or 177) or IsDisabledControlJustPressed(0, 200) then
                dui.unfocus()
            end
        end
    end)

    return true
end

function dui.unfocus()
    if not focused then return false end

    focused = false
    focusedDui = nil

    if focusedCamera then
        SetCamActive(focusedCamera, false)
        DestroyCam(focusedCamera, false)
        RenderScriptCams(false, false, 1, true, true)
        focusedCamera = nil
    end

    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)

    return true
end

dui.builder = {}

function dui.builder.startPoly(options)
    options = options or {}

    local pointA
    local pointB
    local maxSize = tonumber(options.maxSize) or 50.0
    local rayDistance = tonumber(options.rayDistance) or 200.0
    local previewColor = options.previewColor or { 0, 180, 90, 90 }
    local markerColor = options.markerColor or { 0, 220, 120, 180 }
    local ped = PlayerPedId()

    while true do
        Wait(0)

        DisableControlAction(0, 38, true)
        DisableControlAction(0, 177, true)
        DisableControlAction(0, 200, true)

        local hitCoords = raycastFromCamera(rayDistance, options.flags or 4294967295, ped)
        local mr, mg, mb, ma = colorChannels(markerColor)

        DrawMarker(
            28,
            hitCoords.x,
            hitCoords.y,
            hitCoords.z,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.08,
            0.08,
            0.08,
            mr,
            mg,
            mb,
            ma,
            false,
            false,
            2,
            false,
            nil,
            nil,
            false
        )

        if pointA then
            pointB = hitCoords
            drawPolyPreview(pointA, pointB, math.min(pointA.z, pointB.z), math.max(pointA.z, pointB.z), previewColor)
            showHelp("Pressione ~INPUT_CONTEXT~ para definir o segundo ponto. ~INPUT_FRONTEND_CANCEL~ cancela.")
        else
            showHelp("Pressione ~INPUT_CONTEXT~ para definir o primeiro ponto. ~INPUT_FRONTEND_CANCEL~ cancela.")
        end

        if IsDisabledControlJustReleased(0, 38) then
            if not pointA then
                pointA = hitCoords
            else
                pointB = hitCoords

                if #(pointA - pointB) > maxSize then
                    pointA = nil
                    pointB = nil
                    debug("warn", ("[pr_bridge:dui] Area poly maior que %.2fm. Tente novamente."):format(maxSize))
                else
                    local minZ = math.min(pointA.z, pointB.z)
                    local maxZ = math.max(pointA.z, pointB.z)

                    return true, {
                        pointA = pointA,
                        pointB = pointB,
                        minZ = minZ,
                        maxZ = maxZ,
                    }
                end
            end

            Wait(150)
        end

        if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) then
            return false, "cancelled"
        end
    end
end

function dui.builder.createPoly(options)
    options = options or {}

    local ok, placement = dui.builder.startPoly(options.builder or options)
    if not ok then return nil, placement end

    for key, value in pairs(placement) do
        options[key] = value
    end

    return dui.createPoly(options)
end

function dui.builder.startPoly4(options)
    options = options or {}

    local p1, p2, p3, p4
    local maxSize = tonumber(options.maxSize) or 50.0
    local rayDistance = tonumber(options.rayDistance) or 200.0
    local previewColor = options.previewColor or { 0, 180, 90, 90 }
    local markerColor = options.markerColor or { 0, 220, 120, 180 }
    local ped = PlayerPedId()

    while true do
        Wait(0)

        DisableControlAction(0, 38, true)
        DisableControlAction(0, 177, true)
        DisableControlAction(0, 200, true)

        local hitCoords, _, _, hit = raycastFromCamera(rayDistance, options.flags or 4294967295, ped)
        local mr, mg, mb, ma = colorChannels(markerColor)

        DrawMarker(
            28,
            hitCoords.x,
            hitCoords.y,
            hitCoords.z,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.08,
            0.08,
            0.08,
            mr,
            mg,
            mb,
            ma,
            false,
            false,
            2,
            false,
            nil,
            nil,
            false
        )

        -- Draw markers on already selected points and lines/previews
        if p1 then
            DrawMarker(28, p1.x, p1.y, p1.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.08, 0.08, 255, 0, 0, 180, false, false, 2, false, nil, nil, false)
        end
        if p2 then
            DrawMarker(28, p2.x, p2.y, p2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.08, 0.08, 0, 255, 0, 180, false, false, 2, false, nil, nil, false)
        end
        if p3 then
            DrawMarker(28, p3.x, p3.y, p3.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.08, 0.08, 0, 0, 255, 180, false, false, 2, false, nil, nil, false)
        end

        if p1 and not p2 then
            DrawLine(p1.x, p1.y, p1.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 255, 0, 255)
            showHelp("Ponto 1 definido. Mire e pressione ~INPUT_CONTEXT~ para definir o ponto 2 (Superior Direito). ~INPUT_FRONTEND_CANCEL~ cancela.")
        elseif p1 and p2 and not p3 then
            DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 0, 255, 0, 255)
            DrawLine(p2.x, p2.y, p2.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 255, 0, 255)
            showHelp("Ponto 2 definido. Mire e pressione ~INPUT_CONTEXT~ para definir o ponto 3 (Inferior Direito). ~INPUT_FRONTEND_CANCEL~ cancela.")
        elseif p1 and p2 and p3 then
            DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 0, 255, 0, 255)
            DrawLine(p2.x, p2.y, p2.z, p3.x, p3.y, p3.z, 0, 255, 0, 255)
            DrawLine(p3.x, p3.y, p3.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 255, 0, 255)
            DrawLine(hitCoords.x, hitCoords.y, hitCoords.z, p1.x, p1.y, p1.z, 255, 255, 0, 255)
            drawPoly4Preview(p1, p2, p3, hitCoords, previewColor)
            showHelp("Ponto 3 definido. Mire e pressione ~INPUT_CONTEXT~ para definir o ponto 4 (Inferior Esquerdo). ~INPUT_FRONTEND_CANCEL~ cancela.")
        else
            showHelp("Mire e pressione ~INPUT_CONTEXT~ para definir o ponto 1 (Superior Esquerdo). ~INPUT_FRONTEND_CANCEL~ cancela.")
        end

        if IsDisabledControlJustReleased(0, 38) then
            if not p1 then
                p1 = hitCoords
            elseif not p2 then
                p2 = hitCoords
            elseif not p3 then
                p3 = hitCoords
            else
                p4 = hitCoords

                -- Validate max size between adjacent points
                if #(p1 - p2) > maxSize or #(p2 - p3) > maxSize or #(p3 - p4) > maxSize or #(p4 - p1) > maxSize then
                    p1 = nil
                    p2 = nil
                    p3 = nil
                    p4 = nil
                    debug("warn", ("[pr_bridge:dui] Um dos lados do poligono excede o limite de %.2fm. Tente novamente."):format(maxSize))
                else
                    return true, {
                        p1 = p1,
                        p2 = p2,
                        p3 = p3,
                        p4 = p4,
                    }
                end
            end

            Wait(150)
        end

        if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) then
            return false, "cancelled"
        end
    end
end

function dui.builder.createPoly4(options)
    options = options or {}

    local ok, placement = dui.builder.startPoly4(options.builder or options)
    if not ok then return nil, placement end

    for key, value in pairs(placement) do
        options[key] = value
    end

    return dui.poly(options)
end

function dui.builder.entityRenderTarget(entity, options)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil, "invalid_entity" end

    options = options or {}
    local netId

    if NetworkGetEntityIsNetworked(entity) then
        netId = NetworkGetNetworkIdFromEntity(entity)
    end

    return {
        entity = entity,
        netId = netId,
        model = GetEntityModel(entity),
        renderTarget = options.renderTarget or options.renderTargetName or "tvscreen",
        renderDistance = options.renderDistance or 35.0,
    }
end

function dui.builder.textureReplacement(textureDict, textureName, options)
    options = options or {}

    return {
        txd = textureDict,
        txn = textureName,
        width = options.width,
        height = options.height,
    }
end

local commonPropTextures = {
    ["prop_busstop_05"] = "prop_valet_04",
    ["prop_tv_flat_01"] = "tvscreen",
    ["prop_tv_flat_02"] = "tvscreen",
    ["prop_tv_flat_03"] = "tvscreen",
    ["prop_tv_03"] = "tvscreen",
    ["prop_monitor_01a"] = "tvscreen",
    ["prop_monitor_02"] = "tvscreen",
    ["prop_laptop_01"] = "laptop_screen",
    ["prop_laptop_01a"] = "laptop_screen",
    ["prop_phone_ingame"] = "phone_screen",
    ["hei_heist_str_avenger_pc"] = "avenger_pc_screen",
}

function dui.builder.startIdentifyPropTexture(options)
    options = options or {}
    local ped = PlayerPedId()
    local rayDistance = tonumber(options.rayDistance) or 150.0
    local markerColor = options.markerColor or { 0, 220, 120, 180 }
    
    local targetEntity
    local targetModelName
    local targetModelHash

    while true do
        Wait(0)

        DisableControlAction(0, 38, true) -- E
        DisableControlAction(0, 177, true) -- BACKSPACE
        DisableControlAction(0, 200, true) -- ESC

        local hitCoords, entity, _, hit = raycastFromCamera(rayDistance, options.flags or 4294967295, ped)
        
        local color = { r = 255, g = 255, b = 255, a = 200 }
        local valid = false

        if (hit == 1 or hit == true) and entity and entity ~= 0 and DoesEntityExist(entity) and IsEntityAnObject(entity) then
            valid = true
            targetEntity = entity
            targetModelHash = GetEntityModel(entity)
            targetModelName = GetEntityArchetypeName(entity)
            color = { r = 0, g = 255, b = 0, a = 200 }
            
            showHelp("Mire em um prop. Pressione ~INPUT_CONTEXT~ para selecionar ~y~" .. targetModelName .. "~s~. ~INPUT_FRONTEND_CANCEL~ cancela.")
        else
            showHelp("Mire em um prop/objeto para identificar. ~INPUT_FRONTEND_CANCEL~ cancela.")
        end

        local playerCoords = GetEntityCoords(ped)
        DrawLine(playerCoords.x, playerCoords.y, playerCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, color.r, color.g, color.b, color.a)
        
        local mr, mg, mb, ma = colorChannels(markerColor)
        DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.08, 0.08, mr, mg, mb, ma, false, false, 2, false, nil, nil, false)

        if IsDisabledControlJustReleased(0, 38) and valid then
            local defaultTxn = commonPropTextures[targetModelName] or targetModelName
            AddTextEntry("PR_DUI_TX_INPUT", "Confirme ou digite o nome da textura original:")
            DisplayOnscreenKeyboard(1, "PR_DUI_TX_INPUT", "", defaultTxn, "", "", "", 64)
            
            while UpdateOnscreenKeyboard() == 0 do
                Wait(0)
            end
            
            if UpdateOnscreenKeyboard() == 1 then
                local txn = GetOnscreenKeyboardResult()
                if txn and txn ~= "" then
                    return true, {
                        entity = targetEntity,
                        txd = targetModelName,
                        txn = txn,
                        model = targetModelHash
                    }
                else
                    debug("warn", "[pr_bridge:dui] Nome da textura invalido.")
                end
            else
                debug("info", "[pr_bridge:dui] Input de textura cancelado.")
            end
            
            Wait(150)
        end

        if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) then
            return false, "cancelled"
        end
    end
end

function dui.builder.createReplaceTextureInteractive(options)
    options = options or {}
    
    local ok, target = dui.builder.startIdentifyPropTexture(options.builder or options)
    if not ok then return nil, target end
    
    options.originalTxd = target.txd
    options.originalTxn = target.txn
    
    local screen, err = dui.replaceTexture(options)
    if not screen then return nil, err end
    
    return screen, target
end

function dui.createSprite(options)
    local instance, err = dui.create(options)
    if not instance then return nil, err end

    local ok, spriteErr = dui.startSprite(instance.id, options.sprite or options)
    if not ok then
        dui.destroy(instance.id)
        return nil, spriteErr
    end

    return instance
end

local function isForThisResource(owner)
    return owner == resourceName
end

RegisterNetEvent("pr_bridge:client:dui:create", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.create(options)
end)

RegisterNetEvent("pr_bridge:client:dui:createSprite", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.createSprite(options or {})
end)

RegisterNetEvent("pr_bridge:client:dui:createRenderTarget", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.createRenderTarget(options or {})
end)

RegisterNetEvent("pr_bridge:client:dui:createReplaceTexture", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.createReplaceTexture(options or {})
end)

RegisterNetEvent("pr_bridge:client:dui:createPoly", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.createPoly(options or {})
end)

RegisterNetEvent("pr_bridge:client:dui:destroy", function(owner, id)
    if not isForThisResource(owner) then return end
    dui.destroy(id)
end)

RegisterNetEvent("pr_bridge:client:dui:setUrl", function(owner, id, url)
    if not isForThisResource(owner) then return end
    dui.setUrl(id, url)
end)

RegisterNetEvent("pr_bridge:client:dui:send", function(owner, id, message)
    if not isForThisResource(owner) then return end
    dui.send(id, message)
end)

RegisterNetEvent("pr_bridge:client:dui:startSprite", function(owner, id, options)
    if not isForThisResource(owner) then return end
    dui.startSprite(id, options)
end)

RegisterNetEvent("pr_bridge:client:dui:stopSprite", function(owner, id)
    if not isForThisResource(owner) then return end
    dui.stopSprite(id)
end)

RegisterNetEvent("pr_bridge:client:dui:stopRenderTarget", function(owner, id)
    if not isForThisResource(owner) then return end
    dui.stopRenderTarget(id)
end)

RegisterNetEvent("pr_bridge:client:dui:stopPoly", function(owner, id)
    if not isForThisResource(owner) then return end
    dui.stopPoly(id)
end)

RegisterNetEvent("pr_bridge:client:dui:setOpacity", function(owner, id, opacity)
    if not isForThisResource(owner) then return end
    dui.setOpacity(id, opacity)
end)

RegisterNetEvent("pr_bridge:client:dui:setBrightness", function(owner, id, brightness)
    if not isForThisResource(owner) then return end
    dui.setBrightness(id, brightness)
end)

RegisterNetEvent("pr_bridge:client:dui:createPoly4", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.builder.createPoly4(options or {})
end)

RegisterNetEvent("pr_bridge:client:dui:stopPoly4", function(owner, id)
    if not isForThisResource(owner) then return end
    dui.stopPoly(id)
end)

RegisterNetEvent("pr_bridge:client:dui:createReplaceTextureInteractive", function(owner, options)
    if not isForThisResource(owner) then return end
    dui.builder.createReplaceTextureInteractive(options or {})
end)

CreateThread(function()
    Wait(500)
    TriggerServerEvent("pr_bridge:server:dui:ready", resourceName)
end)

AddEventHandler("onResourceStop", function(stoppedResource)
    if stoppedResource ~= resourceName then return end

    for id in pairs(activeDuis) do
        dui.destroy(id)
    end

    dui.unfocus()
end)

return dui
