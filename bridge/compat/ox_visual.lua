-- ox_lib owns one visible menu/dialog/text UI globally, even when several
-- consumers register callbacks. Keep their handlers isolated, not their state.
return function(owner, uiForOwner)
    local registered = { context = {}, menu = {} }
    local active, methods = {}, {}
    local function current(kind)
        local entry = active[kind]
        if not entry then return end
        if kind == 'context' and not entry.ui.getOpenContextMenu() then active[kind] = nil; return end
        if kind == 'menu' and not entry.ui.getOpenMenu() then active[kind] = nil; return end
        return entry
    end
    local function close(kind, ...)
        local entry = current(kind)
        if not entry then return end
        active[kind] = nil
        local name = ({ context = 'hideContext', menu = 'hideMenu', input = 'closeInputDialog', alert = 'closeAlertDialog', text = 'hideTextUI' })[kind]
        return entry.ui[name](...)
    end
    methods.registerContext = function(data)
        local resource = owner()
        local ui = uiForOwner(resource)
        ui.registerContext(data)
        if data.id then registered.context[data.id] = { owner = resource, ui = ui }
        else for _, entry in pairs(data) do registered.context[entry.id] = { owner = resource, ui = ui } end end
    end
    methods.registerMenu = function(data, callback)
        local resource = owner()
        local ui = uiForOwner(resource)
        ui.registerMenu(data, callback)
        registered.menu[data.id] = { owner = resource, ui = ui }
    end
    local function show(kind, id, ...)
        local entry = assert(registered[kind][id], 'Unknown ' .. kind .. ': ' .. tostring(id))
        close('context', false)
        close('menu', false)
        active[kind] = entry
        return entry.ui[kind == 'context' and 'showContext' or 'showMenu'](id, ...)
    end
    methods.showContext = function(...) return show('context', ...) end
    methods.showMenu = function(...) return show('menu', ...) end
    methods.hideContext = function(...) close('context', ...) end
    methods.hideMenu = function(...) close('menu', ...) end
    methods.getOpenContextMenu = function() local entry = current('context'); return entry and entry.ui.getOpenContextMenu() end
    methods.getOpenMenu = function() local entry = current('menu'); return entry and entry.ui.getOpenMenu() end
    methods.setMenuOptions = function(id, ...)
        local entry = assert(registered.menu[id], 'Unknown menu: ' .. tostring(id))
        return entry.ui.setMenuOptions(id, ...)
    end
    local function dialog(kind, name, ...)
        if active[kind] then return nil end
        local resource = owner()
        local entry = { owner = resource, ui = uiForOwner(resource) }
        active[kind] = entry
        local result = table.pack(pcall(entry.ui[name], ...))
        if active[kind] == entry then active[kind] = nil end
        if not result[1] then error(result[2], 2) end
        return table.unpack(result, 2, result.n)
    end
    methods.inputDialog = function(...) return dialog('input', 'inputDialog', ...) end
    methods.alertDialog = function(...) return dialog('alert', 'alertDialog', ...) end
    methods.closeInputDialog = function() close('input') end
    methods.closeAlertDialog = function(...) close('alert', ...) end
    methods.showTextUI = function(...)
        close('text')
        local resource = owner()
        local entry = { owner = resource, ui = uiForOwner(resource) }
        active.text = entry
        entry.ui.showTextUI(...)
    end
    methods.hideTextUI = function() close('text') end
    methods.isTextUIOpen = function()
        local entry = current('text')
        if entry then return entry.ui.isTextUIOpen() end
        return false
    end
    local function cleanup(resource)
        for kind, registry in pairs(registered) do
            for id, entry in pairs(registry) do if entry.owner == resource then registry[id] = nil end end
        end
        for kind, entry in pairs(active) do if entry.owner == resource then close(kind, false) end end
    end
    return methods, cleanup
end
