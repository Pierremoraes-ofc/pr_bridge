local drawtext = {}

local currentText = {
    active = false,
    text = nil,
    params = nil,
    thread = false,
}

local positions = {
    left = vec2(0.16, 0.50),
    ["left-center"] = vec2(0.16, 0.50),
    right = vec2(0.86, 0.50),
    ["right-center"] = vec2(0.86, 0.50),
    top = vec2(0.50, 0.08),
    ["top-center"] = vec2(0.50, 0.08),
    bottom = vec2(0.50, 0.92),
    ["bottom-center"] = vec2(0.50, 0.92),
    center = vec2(0.50, 0.50),
}

local function toVec2(value, fallback)
    if not value then return fallback or vec2(0.5, 0.5) end
    if value.x and value.y then return vec2(value.x, value.y) end
    return vec2(value[1] or 0.5, value[2] or 0.5)
end

local function toVec3(value, fallback)
    if not value then return fallback or vec3(0.0, 0.0, 0.0) end
    if value.x and value.y and value.z then return vec3(value.x, value.y, value.z) end
    return vec3(value[1] or 0.0, value[2] or 0.0, value[3] or 0.0)
end

local function toVec4(value, fallback)
    fallback = fallback or vec4(255, 255, 255, 255)
    if not value then return fallback end

    return vec4(
        value.r or value.x or value[1] or fallback.r or fallback.x or 255,
        value.g or value.y or value[2] or fallback.g or fallback.y or 255,
        value.b or value.z or value[3] or fallback.b or fallback.z or 255,
        value.a or value.w or value[4] or fallback.a or fallback.w or 255
    )
end

local function getColorChannels(color)
    color = toVec4(color)
    return math.floor(color.r or color.x or 255),
        math.floor(color.g or color.y or 255),
        math.floor(color.b or color.z or 255),
        math.floor(color.a or color.w or 255)
end

local function normalize2dParams(text, position, options)
    if type(position) == "table" then
        options = position
        position = options.position
    end

    options = options or {}

    local params = {}
    for key, value in pairs(options) do
        params[key] = value
    end

    params.text = text or params.text or ""
    params.coords = toVec2(params.coords or positions[position or params.position] or positions.right)
    params.scale = params.scale or 0.35
    params.font = params.font or 4
    params.color = toVec4(params.color)
    params.width = params.width or 0.0
    params.height = params.height or 0.0

    return params
end

local function normalizeScale2(value)
    if type(value) == "number" then return vec2(value, value) end
    if value and value.x and value.y then return vec2(value.x, value.y) end
    if type(value) == "table" then return vec2(value[1] or 0.35, value[2] or value[1] or 0.35) end
    return vec2(0.35, 0.35)
end

local function normalizeAlign(value)
    value = type(value) == "string" and value:lower() or "center"

    if value == "left" or value == "esquerda" then return "left" end
    if value == "right" or value == "direita" then return "right" end
    return "center"
end

local function applyTextAlign(align, wrapLeft, wrapRight)
    align = normalizeAlign(align)

    if align == "left" then
        SetTextCentre(false)
        SetTextJustification(1)
        SetTextWrap(wrapLeft or 0.0, wrapRight or 1.0)
    elseif align == "right" then
        SetTextCentre(false)
        SetTextJustification(2)
        SetTextWrap(wrapLeft or 0.0, wrapRight or 1.0)
    else
        SetTextCentre(true)
        SetTextJustification(0)
    end

    return align
end

function drawtext.drawText2d(params)
    if type(params) ~= "table" or not params.text then return false end

    local text = params.text
    local coords = toVec2(params.coords)
    local scale = params.scale or 0.35
    local font = params.font or 4
    local r, g, b, a = getColorChannels(params.color)
    local width = params.width or 1.0
    local height = params.height or 1.0

    SetTextScale(scale, scale)
    SetTextFont(font)
    SetTextColour(r, g, b, a)

    if params.enableDropShadow then
        SetTextDropShadow()
    end

    if params.enableOutline then
        SetTextOutline()
    end

    local align = params.align or params.alignment or (params.center == false and "left") or "center"
    applyTextAlign(align, params.wrapLeft, params.wrapRight)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(coords.x - width / 2, coords.y - height / 2 + 0.005)

    return true
end

function drawtext.drawText3d(params)
    if type(params) ~= "table" or not params.text or not params.coords then return false end

    local text = params.text
    local coords = toVec3(params.coords)
    local scale = normalizeScale2(params.scale)
    local font = params.font or 4
    local r, g, b, a = getColorChannels(params.color)

    SetTextScale(scale.x, scale.y)
    SetTextFont(font)
    SetTextColour(r, g, b, a)

    if params.enableDropShadow then
        SetTextDropShadow()
    end

    if params.enableOutline then
        SetTextOutline()
    end

    local align = params.align or params.alignment or (params.center == false and "left") or "center"
    applyTextAlign(align, params.wrapLeft, params.wrapRight)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)

    if params.drawRect == true then
        local factor = #text / 370
        DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, params.rectAlpha or 75)
    end

    ClearDrawOrigin()
    return true
end

local function ensureThread()
    if currentText.thread then return end

    currentText.thread = true
    CreateThread(function()
        while currentText.active do
            if currentText.params then
                drawtext.drawText2d(currentText.params)
            end

            Wait(0)
        end

        currentText.thread = false
    end)
end

function drawtext.show(text, position, options)
    currentText.text = text
    currentText.params = normalize2dParams(text, position, options)
    currentText.active = true
    ensureThread()
    return true
end

function drawtext.change(text, position, options)
    return drawtext.show(text, position, options)
end

function drawtext.hide()
    currentText.active = false
    currentText.text = nil
    currentText.params = nil
    return true
end

function drawtext.keyPressed(delay)
    CreateThread(function()
        Wait(delay or 500)
        drawtext.hide()
    end)
end

function drawtext.isOpen()
    return currentText.active == true, currentText.text
end

drawtext.draw2d = drawtext.drawText2d
drawtext.draw3d = drawtext.drawText3d
drawtext.DrawText2D = drawtext.drawText2d
drawtext.DrawText3D = drawtext.drawText3d
drawtext.DrawText2d = drawtext.drawText2d
drawtext.DrawText3d = drawtext.drawText3d
drawtext.DrawText = drawtext.show
drawtext.ChangeText = drawtext.change
drawtext.HideText = drawtext.hide
drawtext.KeyPressed = drawtext.keyPressed

RegisterNetEvent("pr_bridge:client:DrawText", function(text, position)
    drawtext.show(text, position)
end)

RegisterNetEvent("pr_bridge:client:ChangeText", function(text, position)
    drawtext.change(text, position)
end)

RegisterNetEvent("pr_bridge:client:HideText", function()
    drawtext.hide()
end)

RegisterNetEvent("pr_bridge:client:KeyPressed", function()
    drawtext.keyPressed()
end)

return drawtext
