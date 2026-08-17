local modulePath = assert(arg[1], "informe o caminho de bridge/addKeybind/client.lua")
local commands = {}
local mappings = {}
local timeoutCallbacks = {}
local pressed = 0
local released = 0

Bridge = { debug = {} }

function IsPauseMenuActive() return false end
function GetControlInstructionalButton(_, hash) return ("x_%s"):format(hash) end
function joaat(value)
    local hash = 0
    for index = 1, #value do hash = (hash * 33 + value:byte(index)) & 0xffffffff end
    return hash
end
function RegisterCommand(name, callback)
    commands[name] = callback
end
function RegisterKeyMapping(command, description, mapper, key)
    mappings[#mappings + 1] = { command = command, description = description, mapper = mapper, key = key }
end
function SetTimeout(_, callback)
    timeoutCallbacks[#timeoutCallbacks + 1] = callback
end
function TriggerEvent() end

local addKeybind = assert(loadfile(modulePath))()
local target = assert(addKeybind({
    name = "pr_bridge_native_target",
    description = "Target",
    defaultKey = "RMENU",
    onPressed = function() pressed = pressed + 1 end,
    onReleased = function() released = released + 1 end,
}))

assert(mappings[1].command == "+pr_bridge_native_target", "comando simples nao preservou o name")
assert(mappings[1].description == "Target", "descricao incorreta")
assert(mappings[1].mapper == "keyboard", "mapper incorreto")
assert(mappings[1].key == "RMENU", "tecla incorreta")
assert(type(commands["+pr_bridge_native_target"]) == "function", "comando de pressionar ausente")
assert(type(commands["-pr_bridge_native_target"]) == "function", "comando de soltar ausente")

commands["+pr_bridge_native_target"]()
commands["-pr_bridge_native_target"]()
assert(pressed == 1 and released == 1, "callbacks simples nao executaram")
assert(target.isPressed == false, "estado final da tecla incorreto")

local beforeCombo = #mappings
local comboRuns = 0
assert(addKeybind({
    name = "combo_test",
    description = "Combo Test",
    defaultKey = { "CTRL", "Z", "F1" },
    onPressed = function() comboRuns = comboRuns + 1 end,
}))

assert(#mappings == beforeCombo + 3, "combo nao registrou todas as teclas")
local comboCommands = {}
for index = beforeCombo + 1, #mappings do
    local command = mappings[index].command
    assert(#command <= 24, "nome compacto excedeu o limite esperado")
    comboCommands[#comboCommands + 1] = command
end
for index = 1, #comboCommands do commands[comboCommands[index]]() end
assert(comboRuns == 1, "combo nao executou ao pressionar todas as teclas")
for index = 1, #comboCommands do
    local releaseCommand = comboCommands[index]:gsub("^%+", "-")
    commands[releaseCommand]()
end

local radialBefore = #mappings
assert(addKeybind({
    name = "pr_bridge_radial",
    description = "Menu radial",
    defaultKey = "F1",
}))
assert(#mappings == radialBefore + 1, "radial nao registrou mapping")
assert(mappings[#mappings].command == "+pr_bridge_radial", "comando radial incorreto")
assert(mappings[#mappings].key == "F1", "tecla radial incorreta")

for index = 1, #timeoutCallbacks do timeoutCallbacks[index]() end
print(("ADD_KEYBIND_TEST_OK mappings=%d commands=%d"):format(#mappings, (function()
    local count = 0
    for _ in pairs(commands) do count = count + 1 end
    return count
end)()))
