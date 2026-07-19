---UI nativa: RegisterContext → Renderer → NUI host → Vue

local BRIDGE = "pr_bridge"
local resourceName = GetCurrentResourceName()
local MenuAdapter = Bridge.menus

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

local function clone(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for key, entry in pairs(value) do copy[key] = clone(entry) end
    return copy
end

local function getGlobalConfig()
    return clone(GlobalState.pr_bridge_ui_config or {})
end

local function saveGlobalConfig(config)
    local ok, saved = Bridge.callback.await("pr_bridge:ui:saveConfig", 10000, config)
    if not ok then
        UI.Notify({ title = "pr_bridge", description = tostring(saved or "save_failed"), type = "error" })
        return false
    end

    UI.Notify({ title = "pr_bridge", description = "Configuracao visual salva.", type = "success" })
    return true
end

function UI.GetVisualConfig()
    return getGlobalConfig()
end

UI.getVisualConfig = UI.GetVisualConfig

local function menuPosition()
    local layout = getGlobalConfig().layout or {}
    return layout.registerMenu == "left" and "top-left" or "top-right"
end

function UI.RegisterMenu(data, callback)
    if not MenuAdapter or type(MenuAdapter.RegisterMenu) ~= "function" then return false end

    local payload = clone(data or {})
    payload.position = payload.position or menuPosition()
    return MenuAdapter.RegisterMenu(payload, callback)
end

UI.registerMenu = UI.RegisterMenu

function UI.ShowMenu(id, startIndex)
    if not MenuAdapter or type(MenuAdapter.ShowMenu) ~= "function" then return false end
    return MenuAdapter.ShowMenu(id, startIndex)
end

UI.showMenu = UI.ShowMenu

function UI.HideMenu(onExit)
    if not MenuAdapter or type(MenuAdapter.HideMenu) ~= "function" then return false end
    return MenuAdapter.HideMenu(onExit)
end

UI.hideMenu = UI.HideMenu

local function openPaletteEditor()
    local config = getGlobalConfig()
    local palette = config.palette or {}
    local values = UI.InputDialog("Paleta global", {
        { type = "color", label = "Cor primaria", default = palette.primary or "#ff7a1a", required = true },
        { type = "color", label = "Primaria em destaque", default = palette.primaryHover or "#ff8c2a", required = true },
        { type = "color", label = "Sucesso", default = palette.success or "#10b981", required = true },
        { type = "color", label = "Aviso", default = palette.warning or "#f59e0b", required = true },
        { type = "color", label = "Erro", default = palette.error or "#ef4444", required = true },
        { type = "color", label = "Informacao", default = palette.info or "#3b82f6", required = true },
        { type = "color", label = "Texto principal", default = palette.text or "#ffffff", required = true },
        { type = "color", label = "Texto secundario", default = palette.textMuted or "#8e8e9f", required = true },
        { type = "color", label = "Superficie", default = palette.surface or "#0c0c0f", required = true },
        { type = "number", label = "Opacidade", default = palette.surfaceOpacity or 0.82, min = 0.15, max = 1.0, step = 0.01, precision = 2, required = true },
        { type = "color", label = "Bordas", default = palette.border or "#2d2d35", required = true },
    }, { size = "md", allowCancel = true })

    if not values then return end
    config.palette = {
        primary = values[1], primaryHover = values[2], success = values[3], warning = values[4],
        error = values[5], info = values[6], text = values[7], textMuted = values[8],
        surface = values[9], surfaceOpacity = values[10], border = values[11],
    }
    saveGlobalConfig(config)
end

local function layoutOptions(values)
    local options = {}
    for i = 1, #values do options[i] = { value = values[i], label = values[i] } end
    return options
end

local function openLayoutEditor()
    local config = getGlobalConfig()
    local layout = config.layout or {}
    local values = UI.InputDialog("Posicoes globais", {
        { type = "select", label = "RegisterContext", default = layout.registerContext or "right", options = layoutOptions({ "left", "right" }), required = true },
        { type = "select", label = "Metadata", default = layout.metadata or "right", options = layoutOptions({ "left", "right" }), required = true },
        { type = "select", label = "AlertDialog", default = layout.alertDialog or "center", options = layoutOptions({ "left", "center", "right" }), required = true },
        { type = "select", label = "InputDialog", default = layout.inputDialog or "center", options = layoutOptions({ "left", "center", "right" }), required = true },
        { type = "select", label = "RegisterMenu", default = layout.registerMenu or "right", options = layoutOptions({ "left", "right" }), required = true },
        { type = "select", label = "Notify", default = layout.notify or "top-right", options = layoutOptions({ "top-left", "top-center", "top-right", "center-left", "center-right", "bottom-left", "bottom-center", "bottom-right" }), required = true },
        { type = "select", label = "ProgressBar", default = layout.progressBar or "bottom-center", options = layoutOptions({ "top-center", "bottom-center" }), required = true },
        { type = "select", label = "ShowTextUI", default = layout.showTextUI or "right-center", options = layoutOptions({ "left-center", "right-center", "top-center", "bottom-center" }), required = true },
    }, { size = "md", allowCancel = true })

    if not values then return end
    config.layout = {
        registerContext = values[1], metadata = values[2], alertDialog = values[3],
        inputDialog = values[4], registerMenu = values[5], notify = values[6],
        progressBar = values[7], showTextUI = values[8],
    }
    saveGlobalConfig(config)
end

function UI.OpenVisualAdminMenu(parentMenu)
    CreateThread(function()
        local allowed = Bridge.callback.await("pr_bridge:ui:isAdmin", 10000)
        if not allowed then
            UI.Notify({ title = "pr_bridge", description = "Acesso negado.", type = "error" })
            return
        end

        local id = ("pr_bridge_visual_admin_%s"):format(resourceName)
        UI.RegisterContext({
            id = id,
            title = "Interface global",
            menu = parentMenu,
            options = {
                { title = "Paleta de cores", description = "Cores e opacidade usadas por todos os componentes.", icon = "palette-fill", onSelect = openPaletteEditor },
                { title = "Posicoes", description = "Lado dos menus, metadata, notificacoes e indicadores.", icon = "layout-sidebar-inset", onSelect = openLayoutEditor },
                {
                    title = "Restaurar padrao",
                    description = "Restaura a paleta e todas as posicoes originais.",
                    icon = "arrow-counterclockwise",
                    onSelect = function()
                        CreateThread(function()
                            local ok, result = Bridge.callback.await("pr_bridge:ui:resetConfig", 10000)
                            UI.Notify({
                                title = "pr_bridge",
                                description = ok and "Configuracao restaurada." or tostring(result or "reset_failed"),
                                type = ok and "success" or "error",
                            })
                        end)
                    end,
                },
            },
        })
        UI.ShowContext(id)
    end)
end

UI.openVisualAdminMenu = UI.OpenVisualAdminMenu

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
    RegisterNetEvent("pr_bridge:ui:openAdmin", function()
        UI.OpenVisualAdminMenu()
    end)

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
                        title = "Interface global",
                        description = "Paleta, opacidade e posicoes dos componentes.",
                        icon = "palette-fill",
                        onSelect = function()
                            UI.OpenVisualAdminMenu("pr_context_test_main")
                        end,
                    },
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
                                local values = UI.InputDialog("Todos os tipos de campo", {
                                    {
                                        type = "input",
                                        label = "Texto",
                                        description = "Input simples com limite de caracteres.",
                                        placeholder = "Digite um texto...",
                                        icon = "type",
                                        required = true,
                                        minLength = 3,
                                        maxLength = 40,
                                    },
                                    {
                                        type = "input",
                                        label = "Senha",
                                        placeholder = "Digite uma senha...",
                                        password = true,
                                        icon = "key-fill",
                                    },
                                    {
                                        type = "number",
                                        label = "Numero decimal",
                                        description = "Aceita valores fracionados como 0.8 e 0.9.",
                                        default = 0.9,
                                        min = 0.0,
                                        max = 10.0,
                                        precision = 2,
                                        step = 0.1,
                                    },
                                    {
                                        type = "checkbox",
                                        label = "Checkbox",
                                        checked = true,
                                    },
                                    {
                                        type = "select",
                                        label = "Dropdown",
                                        description = "Selecao simples com opcao de limpar.",
                                        placeholder = "Selecione uma opcao",
                                        default = "option_2",
                                        clearable = true,
                                        searchable = true,
                                        options = {
                                            { value = "option_1", label = "Opcao 1" },
                                            { value = "option_2", label = "Opcao 2" },
                                            { value = "option_3", label = "Opcao 3" },
                                        },
                                    },
                                    {
                                        type = "multi-select",
                                        label = "Selecao multipla",
                                        description = "Permite selecionar no maximo duas opcoes.",
                                        default = { "alpha" },
                                        maxSelectedValues = 2,
                                        options = {
                                            { value = "alpha", label = "Alpha" },
                                            { value = "bravo", label = "Bravo" },
                                            { value = "charlie", label = "Charlie" },
                                        },
                                    },
                                    {
                                        type = "slider",
                                        label = "Slider",
                                        default = 35,
                                        min = 0,
                                        max = 100,
                                        step = 5,
                                    },
                                    {
                                        type = "color",
                                        label = "Seletor de cor",
                                        description = "Cor no formato hexadecimal.",
                                        default = "#ff7a1a",
                                        format = "hex",
                                    },
                                    {
                                        type = "date",
                                        label = "Data",
                                        default = true,
                                        format = "DD/MM/YYYY",
                                        returnString = true,
                                        clearable = true,
                                    },
                                    {
                                        type = "date-range",
                                        label = "Intervalo de datas",
                                        default = { "2026-07-19", "2026-07-26" },
                                        format = "DD/MM/YYYY",
                                        returnString = true,
                                    },
                                    {
                                        type = "time",
                                        label = "Horario",
                                        default = "14:30",
                                        format = "24",
                                        clearable = true,
                                    },
                                    {
                                        type = "textarea",
                                        label = "Texto longo",
                                        description = "Textarea com limite e redimensionamento.",
                                        placeholder = "Escreva uma observacao...",
                                        autosize = true,
                                        minLength = 5,
                                        maxLength = 240,
                                    },
                                    {
                                        type = "input",
                                        label = "Campo desativado",
                                        default = "Somente leitura visual",
                                        disabled = true,
                                    },
                                }, {
                                    allowCancel = true,
                                    size = "md",
                                })
                                UI.Notify({
                                    title = "Input",
                                    description = values and ("Campos retornados: " .. tostring(#values)) or "Cancelado",
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
