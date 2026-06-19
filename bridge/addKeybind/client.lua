local keybinds = {}

local keyAliases = {
    CTRL = "LCONTROL",
    CONTROL = "LCONTROL",
    LCTRL = "LCONTROL",
    RCTRL = "RCONTROL",
    SHIFT = "LSHIFT",
    LSHIFT = "LSHIFT",
    RSHIFT = "RSHIFT",
    ALT = "LMENU",
    LALT = "LMENU",
    RALT = "RMENU",
    ENTER = "RETURN",
    ESC = "ESCAPE",
    DEL = "DELETE",
    INS = "INSERT",
    PGUP = "PAGEUP",
    PGDN = "PAGEDOWN",
    SPACEBAR = "SPACE",
    [" "] = "SPACE",
    ["+"] = "PLUS",
    ["-"] = "MINUS",
    ["="] = "EQUALS",
    [","] = "COMMA",
    ["."] = "PERIOD",
    ["/"] = "SLASH",
    ["\\"] = "BACKSLASH",
    [";"] = "SEMICOLON",
    ["'"] = "APOSTROPHE",
    ["`"] = "GRAVE",
    ["["] = "LBRACKET",
    ["]"] = "RBRACKET",
}

local keybind_mt = {
    disabled = false,
    isPressed = false,
    defaultMapper = "keyboard",
}

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

local function trim(value)
    return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeKey(key)
    key = trim(key):upper()
    return keyAliases[key] or key
end

local function addNormalizedKey(keys, key)
    key = normalizeKey(key)
    if key ~= "" then keys[#keys + 1] = key end
end

local function parseComboString(value)
    local raw = trim(value)
    local keys = {}

    if raw == "" then return keys end
    if keyAliases[raw] or keyAliases[raw:upper()] then
        addNormalizedKey(keys, raw)
        return keys
    end

    local buffer = ""
    local i = 1

    while i <= #raw do
        local char = raw:sub(i, i)

        if char == "+" then
            addNormalizedKey(keys, buffer)
            buffer = ""

            local nextIndex = i + 1
            while nextIndex <= #raw and raw:sub(nextIndex, nextIndex):match("%s") do
                nextIndex = nextIndex + 1
            end

            if nextIndex > #raw then
                addNormalizedKey(keys, "+")
                i = nextIndex
            elseif raw:sub(nextIndex, nextIndex) == "+" then
                addNormalizedKey(keys, "+")
                i = nextIndex + 1
            else
                i = i + 1
            end
        else
            buffer = buffer .. char
            i = i + 1
        end
    end

    addNormalizedKey(keys, buffer)
    return keys
end

local function normalizeCombo(value)
    local keys = {}

    if type(value) == "table" then
        for i = 1, #value do
            addNormalizedKey(keys, value[i])
        end
    elseif type(value) == "string" then
        keys = parseComboString(value)
    end

    return keys
end

local function commandSafeName(name)
    return trim(name):lower():gsub("[^%w_%-]", "_")
end

local function comboToString(keys)
    return table.concat(keys or {}, " + ")
end

local function collectInlineCombo(data, firstKey)
    if type(firstKey) ~= "string" or #data == 0 then return firstKey end

    local keys = { firstKey }
    for i = 1, #data do
        keys[#keys + 1] = data[i]
    end

    return keys
end

local function allPressed(bind, comboIndex)
    local combo = bind.combos[comboIndex]
    if not combo then return false end

    for i = 1, #combo.keys do
        if not combo.pressed[i] then return false end
    end

    return true
end

local function anyPressed(bind)
    for comboIndex = 1, #bind.combos do
        local combo = bind.combos[comboIndex]
        for i = 1, #combo.pressed do
            if combo.pressed[i] then return true end
        end
    end

    return false
end

local function callHandler(bind, handler)
    if type(handler) ~= "function" then return end

    local ok, err = pcall(handler, bind)
    if not ok then
        debug("warn", ("[pr_bridge] addKeybind '%s' falhou: %s"):format(bind.name or "unknown", tostring(err)))
    end
end

local function pressPart(bind, comboIndex, keyIndex)
    if bind.disabled or IsPauseMenuActive() then return end

    local combo = bind.combos[comboIndex]
    if not combo then return end

    combo.pressed[keyIndex] = true

    if not bind.isPressed and allPressed(bind, comboIndex) then
        bind.isPressed = true
        bind.currentCombo = comboIndex
        callHandler(bind, bind.onPressed)
    end
end

local function releasePart(bind, comboIndex, keyIndex)
    local combo = bind.combos[comboIndex]
    if not combo then return end

    combo.pressed[keyIndex] = false

    if bind.isPressed and bind.currentCombo == comboIndex then
        bind.isPressed = false
        bind.currentCombo = nil
        callHandler(bind, bind.onReleased)
    elseif bind.isPressed and not anyPressed(bind) then
        bind.isPressed = false
        bind.currentCombo = nil
        callHandler(bind, bind.onReleased)
    end
end

function keybind_mt:__index(index)
    if index == "currentKey" then return self:getCurrentKey() end
    return keybind_mt[index]
end

function keybind_mt:getCurrentKey()
    local combo = self.combos[self.currentCombo or 1]
    return combo and combo.label or self.defaultKey or ""
end

function keybind_mt:isControlPressed()
    return self.isPressed == true
end

function keybind_mt:disable(toggle)
    self.disabled = toggle == true
end

function keybind_mt:destroy()
    self.disabled = true
    keybinds[self.name] = nil
end

local function registerCombo(bind, comboIndex, keys, mapper)
    local combo = {
        keys = keys,
        label = comboToString(keys),
        pressed = {},
    }

    bind.combos[comboIndex] = combo

    for keyIndex = 1, #keys do
        local commandName = ("pr_bridge_keybind_%s_%s_%s"):format(bind.safeName, comboIndex, keyIndex)
        local description = keyIndex == #keys and bind.description or ("%s [%s]"):format(bind.description, combo.label)

        RegisterCommand("+" .. commandName, function()
            pressPart(bind, comboIndex, keyIndex)
        end, false)

        RegisterCommand("-" .. commandName, function()
            releasePart(bind, comboIndex, keyIndex)
        end, false)

        RegisterKeyMapping("+" .. commandName, description, mapper or bind.defaultMapper or "keyboard", keys[keyIndex])

        SetTimeout(500, function()
            TriggerEvent("chat:removeSuggestion", ("/+%s"):format(commandName))
            TriggerEvent("chat:removeSuggestion", ("/-%s"):format(commandName))
        end)
    end
end

local function createKeybind(data)
    if type(data) ~= "table" then return false, "invalid_data" end
    if type(data.name) ~= "string" or data.name == "" then return false, "missing_name" end

    local primaryCombo = data.keys or data.combo or collectInlineCombo(data, data.defaultKey or data.key)
    local keys = normalizeCombo(primaryCombo)
    if #keys == 0 then return false, "missing_key" end

    local bind = setmetatable(data, keybind_mt)
    bind.safeName = commandSafeName(data.name)
    bind.description = data.description or data.name
    bind.defaultMapper = data.defaultMapper or "keyboard"
    bind.defaultKey = comboToString(keys)
    bind.disabled = data.disabled == true
    bind.isPressed = false
    bind.currentCombo = nil
    bind.combos = {}

    keybinds[bind.name] = bind
    registerCombo(bind, 1, keys, bind.defaultMapper)

    local secondaryKeys = normalizeCombo(data.secondaryKey or data.secondaryKeys or data.secondaryCombo)
    if #secondaryKeys > 0 then
        registerCombo(bind, 2, secondaryKeys, data.secondaryMapper or bind.defaultMapper)
    end

    return bind
end

local addKeybind = setmetatable({
    list = keybinds,
}, {
    __call = function(_, data)
        return createKeybind(data)
    end,
})

function addKeybind.get(name)
    return keybinds[name]
end

function addKeybind.remove(name)
    local bind = keybinds[name]
    if not bind then return false end

    bind:destroy()
    return true
end

return addKeybind
