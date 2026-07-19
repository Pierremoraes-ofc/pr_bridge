---UI nativa: RegisterContext → Renderer → NUI host → Vue

local BRIDGE = "pr_bridge"
local resourceName = GetCurrentResourceName()

local Renderer = PRCore.load("@pr_bridge/interface/client/renderer", _ENV)
local Context = PRCore.load("@pr_bridge/interface/client/modules/context", _ENV)(Renderer)
local Alert = PRCore.load("@pr_bridge/interface/client/modules/alert", _ENV)(Renderer)
local Input = PRCore.load("@pr_bridge/interface/client/modules/input", _ENV)(Renderer)
local Notify = PRCore.load("@pr_bridge/interface/client/modules/notify", _ENV)(Renderer)
local TextUI = PRCore.load("@pr_bridge/interface/client/modules/textui", _ENV)(Renderer)

local UI = {
    renderer = Renderer,
    modules = {
        context = Context,
        alert = Alert,
        input = Input,
        notify = Notify,
        textui = TextUI,
    },

    RegisterContext = Context.RegisterContext,
    registerContext = Context.registerContext,
    ShowContext = Context.ShowContext,
    showContext = Context.showContext,
    HideContext = Context.HideContext,
    hideContext = Context.hideContext,
    GetOpenContextMenu = Context.GetOpenContextMenu,
    getOpenContextMenu = Context.getOpenContextMenu,

    AlertDialog = Alert.AlertDialog,
    alertDialog = Alert.AlertDialog,
    InputDialog = Input.InputDialog,
    inputDialog = Input.InputDialog,
    Notify = Notify.Notify,
    notify = Notify.Notify,
    ShowTextUI = TextUI.ShowTextUI,
    showTextUI = TextUI.ShowTextUI,
    HideTextUI = TextUI.HideTextUI,
    hideTextUI = TextUI.HideTextUI,
    IsTextUIOpen = TextUI.IsTextUIOpen,
    isTextUIOpen = TextUI.IsTextUIOpen,
}

AddEventHandler("pr_bridge:ui:context:select", function(owner, id, index)
    if owner ~= resourceName then return end
    Context.HandleSelect(id, index)
end)

AddEventHandler("pr_bridge:ui:context:close", function(owner)
    if owner ~= resourceName then return end
    Context.HandleClose()
end)

AddEventHandler("pr_bridge:ui:context:back", function(owner)
    if owner ~= resourceName then return end
    Context.HandleBack()
end)

AddEventHandler("pr_bridge:ui:alert:result", function(owner, result)
    if owner ~= resourceName then return end
    Alert.HandleResult(result)
end)

AddEventHandler("pr_bridge:ui:alert:close", function(owner)
    if owner ~= resourceName then return end
    Alert.HandleClose()
end)

AddEventHandler("pr_bridge:ui:input:submit", function(owner, values)
    if owner ~= resourceName then return end
    Input.HandleSubmit(values)
end)

AddEventHandler("pr_bridge:ui:input:close", function(owner)
    if owner ~= resourceName then return end
    Input.HandleClose()
end)

if resourceName == BRIDGE then
    Bridge.addCommand("pr_context_test", {
        help = "Abre o menu de teste da interface nativa do pr_bridge",
    }, function()
        Bridge.debug.info("[pr_interface] Comando /pr_context_test executado via Bridge.addCommand.")

        UI.RegisterContext({
            {
                id = "pr_context_test_main",
                title = "pr_bridge Interface",
                options = {
                    {
                        title = "Notificação",
                        description = "Dispara Notify nativo",
                        icon = "bell",
                        onSelect = function()
                            UI.Notify({
                                title = "pr_bridge",
                                description = "Notify da interface nativa",
                                type = "success",
                            })
                        end,
                    },
                    {
                        title = "Alert Dialog",
                        description = "Abre um alerta",
                        icon = "circle-info",
                        onSelect = function()
                            CreateThread(function()
                                local result = UI.AlertDialog({
                                    header = "Confirmar",
                                    content = "Interface nativa funcionando?",
                                    centered = true,
                                    cancel = true,
                                })
                                UI.Notify({
                                    title = "Alert",
                                    description = "Resultado: " .. tostring(result),
                                    type = "info",
                                })
                            end)
                        end,
                    },
                    {
                        title = "Input Dialog",
                        description = "Abre um formulário",
                        icon = "keyboard",
                        onSelect = function()
                            CreateThread(function()
                                local values = UI.InputDialog("Dados", {
                                    { type = "input", label = "Nome", placeholder = "Digite...", required = true },
                                    { type = "number", label = "Idade", default = 18, min = 1, max = 120 },
                                })
                                UI.Notify({
                                    title = "Input",
                                    description = values and ("Nome: " .. tostring(values[1])) or "Cancelado",
                                    type = values and "success" or "error",
                                })
                            end)
                        end,
                    },
                    {
                        title = "Submenu",
                        description = "Stack de contexts",
                        icon = "folder",
                        menu = "pr_context_test_sub",
                    },
                    {
                        title = "TextUI",
                        description = "Mostra TextUI por 3s",
                        icon = "hand",
                        onSelect = function()
                            UI.ShowTextUI("[E] Interagir", { position = "right-center", icon = "hand" })
                            SetTimeout(3000, function()
                                UI.HideTextUI()
                            end)
                        end,
                    },
                },
            },
            {
                id = "pr_context_test_sub",
                title = "Submenu",
                menu = "pr_context_test_main",
                options = {
                    {
                        title = "Item do submenu",
                        description = "Fecha ao selecionar",
                        icon = "check",
                        onSelect = function()
                            UI.Notify({ title = "Submenu", description = "Item selecionado", type = "info" })
                        end,
                    },
                },
            },
        })
        UI.ShowContext("pr_context_test_main")
    end)
end

return UI
