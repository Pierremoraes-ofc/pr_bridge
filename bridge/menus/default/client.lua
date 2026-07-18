local menus = {}
local registeredContexts = {}

local function notifyUnavailable(title)
    if Bridge.notify and Bridge.notify.Notify then
        Bridge.notify.Notify({
            title = title or "Menu",
            description = "Nenhum sistema de menu foi detectado.",
            type = "error"
        })
    end
end

function menus.RegisterContext(context)
    if type(context) == "table" then
        if context.id then
            registeredContexts[context.id] = context
        else
            for i = 1, #context do
                if context[i].id then
                    registeredContexts[context[i].id] = context[i]
                end
            end
        end
    end

    return false
end

function menus.ShowContext(id)
    local context = registeredContexts[id]
    notifyUnavailable(context and context.title or "Menu")
    return false
end

function menus.HideContext()
    return false
end

function menus.GetOpenContextMenu()
    return nil
end

function menus.RegisterMenu()
    return false
end

function menus.ShowMenu()
    notifyUnavailable("Menu")
    return false
end

function menus.HideMenu()
    return false
end

function menus.InputDialog()
    notifyUnavailable("Input")
    return nil
end

function menus.AlertDialog()
    notifyUnavailable("Alert")
    return nil
end

return menus
