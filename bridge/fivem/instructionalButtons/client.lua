local instructionalButtons = {}

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

local function waitForScaleform(handle, timeout)
    local expires = GetGameTimer() + (timeout or 5000)

    repeat
        if HasScaleformMovieLoaded(handle) then return true end
        Wait(0)
    until GetGameTimer() >= expires

    return HasScaleformMovieLoaded(handle) == true
end

local function normalizeButtons(buttons)
    if type(buttons) ~= "table" then return {} end
    if buttons[1] then return buttons end

    return { buttons }
end

local function callNumber(handle, method, value)
    CallScaleformMovieMethodWithNumber(handle, method, value)
end

local function firstControl(button)
    local control = button and (button.control or button.button or button.key or button.controls)

    if type(control) == "table" then
        for i = 1, #control do
            if type(control[i]) == "string" and control[i] ~= "" then
                return control[i]
            end
        end
    elseif type(control) == "string" and control ~= "" then
        return control
    end

    return "~INPUT_FRONTEND_ACCEPT~"
end

local function setSlot(handle, slot, button, clickable)
    button = button or {}

    BeginScaleformMovieMethod(handle, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(slot)
    ScaleformMovieMethodAddParamPlayerNameString(firstControl(button))
    ScaleformMovieMethodAddParamPlayerNameString(button.label or button.text or "Select")

    if clickable then
        ScaleformMovieMethodAddParamBool(button.clickable ~= false)
        ScaleformMovieMethodAddParamInt(tonumber(button.controlId) or 201)
    end

    EndScaleformMovieMethod()
end

function instructionalButtons.create(buttons, options)
    options = options or {}
    buttons = normalizeButtons(buttons)

    local clickable = options.clickable == true
    local handle = RequestScaleformMovieInstance("INSTRUCTIONAL_BUTTONS")

    if not waitForScaleform(handle, options.timeout or 5000) then
        debug("warn", "[pr_bridge] Timeout ao carregar scaleform INSTRUCTIONAL_BUTTONS.")
        return nil
    end

    local instance = {
        handle = handle,
        buttons = buttons,
        clickable = clickable,
        drawMode = options.drawMode or 0,
    }

    function instance:refresh()
        if not self.handle or not HasScaleformMovieLoaded(self.handle) then return false end

        CallScaleformMovieMethod(self.handle, "CLEAR_ALL")
        callNumber(self.handle, "TOGGLE_MOUSE_BUTTONS", self.clickable and 1 or 0)

        for i = 1, #self.buttons do
            setSlot(self.handle, i - 1, self.buttons[i], self.clickable)
        end

        CallScaleformMovieMethod(self.handle, "DRAW_INSTRUCTIONAL_BUTTONS")
        return true
    end

    function instance:draw()
        self:refresh()
        DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, 255, self.drawMode)
    end

    function instance:dispose()
        if self.clickable then
            callNumber(self.handle, "TOGGLE_MOUSE_BUTTONS", 0)
        end

        SetScaleformMovieAsNoLongerNeeded(self.handle)
    end

    instance:refresh()
    return instance
end

local function disableMouseCamera()
    SetMouseCursorActiveThisFrame()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 24, true)
end

function instructionalButtons.show(buttons, options)
    options = options or {}

    local instance = instructionalButtons.create(buttons, options)
    if not instance then return false, nil end

    local timeout = tonumber(options.duration or options.timeout) or 5000
    local expires = GetGameTimer() + timeout
    local pressedButton
    local pressedControl

    while GetGameTimer() < expires do
        Wait(0)

        if instance.clickable and options.disableMouseControls ~= false then
            disableMouseCamera()
        elseif instance.clickable then
            SetMouseCursorActiveThisFrame()
        end

        instance:draw()

        for i = 1, #instance.buttons do
            local button = instance.buttons[i]
            local controlId = tonumber(button.controlId)

            if controlId and IsControlJustReleased(button.inputGroup or 2, controlId) then
                pressedButton = button
                pressedControl = controlId
                break
            end
        end

        if pressedButton then break end
    end

    instance:dispose()

    return pressedButton ~= nil, pressedButton, pressedControl
end

function instructionalButtons.showSimple(label, control, options)
    options = options or {}
    options.clickable = false

    return instructionalButtons.show({
        label = label or "Select",
        control = control or "~INPUT_FRONTEND_ACCEPT~",
        controlId = options.controlId or 201,
        inputGroup = options.inputGroup or 2,
    }, options)
end

function instructionalButtons.showClickable(label, control, controlId, options)
    options = options or {}
    options.clickable = true

    return instructionalButtons.show({
        label = label or "Select",
        control = control or "~INPUT_FRONTEND_ACCEPT~",
        controlId = controlId or options.controlId or 201,
        inputGroup = options.inputGroup or 2,
        clickable = true,
    }, options)
end

return instructionalButtons
