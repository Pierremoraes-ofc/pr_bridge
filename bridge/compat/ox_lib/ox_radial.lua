-- Registered ox submenus allow items without ids and string export callbacks.
return function(ui, owner)
    local registerRadial, addRadialItem = ui.registerRadial, ui.addRadialItem
    local function items(input, menuId)
        if input.id then input = { input } end
        local result = {}
        for index, item in ipairs(input) do
            local copy = {}
            for key, value in pairs(item) do copy[key] = value end
            copy.id = copy.id or (menuId and (menuId .. ':' .. index))
            if type(item.onSelect) == 'string' then
                local name = item.onSelect
                copy.onSelect = function(...) return exports[owner][name](nil, ...) end
            end
            result[index] = copy
        end
        return result
    end
    return {
        registerRadial = function(data)
            local copy = {}
            for key, value in pairs(data) do copy[key] = value end
            copy.items = items(data.items, data.id)
            registerRadial(copy)
        end,
        addRadialItem = function(data, parent) addRadialItem(items(data, parent), parent) end,
    }
end
