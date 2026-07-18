local menus = {}

if ActiveBridges["menus"] ~= "ox_lib" then return end

Debug("SUCCESS", Lang:t("Debug.MenuDetected", { menu = "Ox Lib" }))

function menus.RegisterContext(context)
    return exports.ox_lib:registerContext(context)
end

function menus.ShowContext(id)
    return exports.ox_lib:showContext(id)
end

function menus.HideContext(onExit)
    return exports.ox_lib:hideContext(onExit)
end

function menus.GetOpenContextMenu()
    return exports.ox_lib:getOpenContextMenu()
end

function menus.RegisterMenu(data, cb)
    return exports.ox_lib:registerMenu(data, cb)
end

function menus.ShowMenu(id, startIndex)
    return exports.ox_lib:showMenu(id, startIndex)
end

function menus.HideMenu(onExit)
    return exports.ox_lib:hideMenu(onExit)
end

function menus.InputDialog(heading, rows, options)
    return exports.ox_lib:inputDialog(heading, rows, options)
end

function menus.AlertDialog(data, timeout)
    return exports.ox_lib:alertDialog(data, timeout)
end

return menus
