-- Private PR integration; never called by construction. Real conversion is a separate operational gate.
return function(ports)
assert(type(ports.inventory)=='table' and type(ports.inventory.readItemsFile)=='function' and type(ports.inventory.writeItemsFile)=='function','explicit inventory file ports required')
assert(type(ports.scheduler)=='table' and type(ports.scheduler.createThread)=='function' and type(ports.scheduler.wait)=='function','explicit scheduler required')
assert(type(ports.trim)=='function' and type(ports.log)=='function','explicit trim/logger required')
-- Item conversion borrowed from ox_inventory: https://github.com/overextended/ox_inventory/blob/52d99285eef1dc7df31c084679db3fdf6b1c0150/modules/items/server.lua#L115-L217
-- Copyright (c) 2023 Overextended

return {
    convertItems = function(ItemList, items)
        local dump = {}
        local count = 0
        local ignoreList = {
            "weapon_",
            "pistol_",
            "pistol50_",
            "revolver_",
            "smg_",
            "combatpdw_",
            "shotgun_",
            "rifle_",
            "carbine_",
            "gusenberg_",
            "sniper_",
            "snipermax_",
            "tint_",
            "_ammo"
        }

        local function checkIgnoredNames(name)
            for i = 1, #ignoreList do
                if string.find(name, ignoreList[i]) then
                    return true
                end
            end
            return false
        end

        for k, item in pairs(items) do
            if type(item) == 'table' then
                if not item.name then item.name = k end

                if not ItemList[item.name] and not checkIgnoredNames(item.name) then
                    item.close = item.shouldClose == nil and true or item.shouldClose
                    item.stack = not item.unique and true
                    item.description = item.description
                    item.weight = item.weight or 0
                    dump[k] = item
                    count = count + 1
                end
            end
        end

        if table.type(dump) ~= 'empty' then
            local file = {ports.trim(ports.inventory.readItemsFile())}
            file[1] = file[1]:gsub('}$', '')

            local itemFormat = [[

    [%q] = {
        label = %q,
        weight = %s,
        stack = %s,
        close = %s,
        description = %q,
        client = {
            status = {
                hunger = %s,
                thirst = %s,
                stress = %s
            },
            image = %q,
        }
    },
]]

            local fileSize = #file

            for _, item in pairs(dump) do
                if not ItemList[item.name] then
                    fileSize = fileSize + 1

                    ---@todo cry
                    local itemStr = itemFormat:format(item.name, item.label, item.weight, item.stack, item.close, item.description or 'nil', item.hunger or 'nil', item.thirst or 'nil', item.stress or 'nil', item.image or 'nil')
                    -- temporary solution for nil values
                    itemStr = itemStr:gsub('[%s]-[%w]+ = "?nil"?,?', '')
                    -- temporary solution for empty status table
                    itemStr = itemStr:gsub('[%s]-[%w]+ = %{[%s]+%},?', '')
                    -- temporary solution for empty client table
                    itemStr = itemStr:gsub('[%s]-[%w]+ = %{[%s]+%},?', '')
                    file[fileSize] = itemStr
                    ItemList[item.name] = item
                end
            end

            file[fileSize+1] = '}'

            ports.inventory.writeItemsFile(table.concat(file), -1)
            ports.scheduler.createThread(function()
                ports.scheduler.wait(1000)
                ports.log('^2[warning]^7 '..count..' items have been added to ox_inventory')
                ports.log('^2[warning]^7 You MUST restart the resource to load the new items.')
            end)
        end
    end
}

end
