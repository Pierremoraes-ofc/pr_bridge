-- Catalog views use real inventory items; identifiers never create inventory state.
return function(E,C)
    C.state.weaponFacts=C.state.weaponFacts or PRCore.load('bridge.compat.esx.weapon_data')
    local facts=C.state.weaponFacts
    local I=C.bridge.inventory
    -- Server Items omits client.component in ox_inventory. Read only the
    -- installed inventory's trusted configuration, with Forge's active overlay.
    local function componentCatalog()
        local definitions={}
        local function merge(input) for name,item in pairs(input or {}) do
            if type(item)=='table' and item.client and type(item.client.component)=='table' then definitions[name]=item end
        end end
        merge(C.invoke(I,'Items'))
        if C.context=='server' then
            local ok,source=pcall(LoadResourceFile,'ox_inventory','data/weapons.lua')
            if ok and source then
                local chunk=load(source,'@@ox_inventory/data/weapons.lua','t',_ENV)
                local loaded,config=pcall(chunk or function() return nil end)
                if loaded and type(config)=='table' then merge(config.Components) end
            end
            if GetResourceState('forge-core')=='started' then
                local read,contents=pcall(LoadResourceFile,'forge-core','data/weapon_inventory.json')
                if read and contents then
                    local parsed,config=pcall(json.decode,contents)
                    if parsed and type(config)=='table' then merge(config.components) end
                end
            end
        end
        return definitions
    end
    local function hashesMatch(item,hash)
        for _,value in ipairs(item.client.component) do if (type(value)=='string' and joaat(value) or value)==hash then return true end end
        return false
    end
    function C.componentItem(weapon,alias)
        local component=E.GetWeaponComponent(weapon,alias);if not component then return end
        local selected
        local definitions=componentCatalog()
        local explicit=(Config.compatESXComponentItems or {})[weapon:upper()]
        explicit=explicit and explicit[alias]
        for name,definition in pairs(definitions) do
            local active=C.invoke(I,'Items',name)
            if active and active.component and not active.disabled and hashesMatch(definition,component.hash) and (not explicit or explicit==name) then
                if selected then C.unsupported('weapon component '..alias,'ambiguous native item; configure compatESXComponentItems') end
                selected={name=name,hash=component.hash,type=active.type or definition.type}
            end
        end
        if not selected then C.unsupported('weapon component '..alias,'no verified native attachment item/hash mapping') end
        return selected
    end
    local function componentNames(weapon,components,resolve)
        if #components==0 then return {} end
        local definition=facts[weapon] or {};local result={}
        for _,name in ipairs(components) do
            local native=resolve(name);local alias
            if native then for _,component in ipairs(definition.components or {}) do
                if hashesMatch(native,component.hash) then alias=component.name;break end
            end end
            if not alias then C.unsupported('weapon loadout','attachment '..tostring(name)..' has no ESX alias for '..weapon) end
            result[#result+1]=alias
        end;return result
    end
    function C.weaponCatalog()
        local names,byName={},{}
        for name,item in pairs(C.invoke(I,'Items') or {}) do
            if type(name)=='string' and type(item)=='table' and not item.disabled
                and (item.weapon or item.type=='weapon' or name:upper():match('^WEAPON_')) then
                local key=name:upper();local known=facts[key] or {};local tints={}
                for tint=0,known.tintMax or -1 do tints[tint]='Tint '..tint end
                local definition={name=key,label=item.label or key,components=C.copy(known.components or {}),
                    tints=tints,throwable=item.throwable or known.throwable,itemName=name,hash=item.hash or joaat(key)}
                byName[key]=definition;names[#names+1]=key
            end
        end
        table.sort(names);local list,hashes={},{}
        for index,name in ipairs(names) do list[index]=byName[name];hashes[list[index].hash]=list[index] end
        return list,byName,hashes
    end
    C.define(E,'GetWeaponList',function(byHash) local list,_,hashes=C.weaponCatalog();return byHash and hashes or list end)
    C.define(E,'GetWeapon',function(name)
        assert(type(name)=='string','Invalid weapon name');name=name:upper()
        for index,item in ipairs(C.weaponCatalog()) do if item.name==name then return index,item end end
        error('[PR Bridge ESX] weapon is not defined in the active inventory: '..name)
    end)
    C.define(E,'GetWeaponFromHash',function(hash)
        if type(hash)=='string' then hash=joaat(hash) end
        local _,_,hashes=C.weaponCatalog();return hashes[hash]
    end)
    C.define(E,'GetWeaponLabel',function(name) local _,item=E.GetWeapon(name);return item.label end)
    C.define(E,'GetWeaponComponent',function(name,component)
        local _,weapon=E.GetWeapon(name)
        for _,entry in ipairs(weapon.components) do if entry.name==component then
            local result=C.copy(entry);result.label=entry.label or entry.name;return result
        end end
    end)
    function C.weaponSlots(source, inventory, definitions)
        local result,byName={},{}
        inventory=inventory or C.readInventory(source)
        for _,item in pairs(inventory or {}) do
            if type(item.name)=='string' then
                local definition=C.itemDefinition(item.name,definitions)
                if next(definition)~=nil and not definition.disabled and (definition.weapon or definition.type=='weapon' or item.name:upper():match('^WEAPON_')) then
                    result[#result+1]=C.copy(item);byName[item.name]=definition
                end
            end
        end
        table.sort(result,function(a,b) return (a.slot or 0)<(b.slot or 0) end);return result,byName
    end
    function C.loadout(source,minimal,inventory,definitions)
        local result={}
        local slots,byName=C.weaponSlots(source,inventory,definitions)
        local serverComponents
        local function resolveComponent(name)
            local native=C.itemDefinition(name,definitions)
            if native.client and type(native.client.component)=='table' then return native end
            -- Only legacy server attachment conversion needs the trusted files.
            -- Resolve them once per loadout, never once per weapon or shot.
            if C.context=='server' then
                if not serverComponents then serverComponents=componentCatalog() end
                return serverComponents[name]
            end
        end
        for _,slot in ipairs(slots) do
            local meta=slot.metadata or slot.info or {};local name=slot.name:upper()
            local components=componentNames(name,meta.components or {},resolveComponent)
            local entry={name=name,label=byName[slot.name].label or name,ammo=meta.ammo or 0,tintIndex=meta.tint or 0,components=components}
            if minimal then
                result[name]={ammo=entry.ammo}
                if entry.tintIndex>0 then result[name].tintIndex=entry.tintIndex end
                if #components>0 then result[name].components=components end
            else result[#result+1]=entry end
        end;return result
    end
    if C.context~='server' then return end
    function C.attachPlayerWeapons(id,fn,methods)
        local function ox()
            local kind=ActiveBridges.inventories or ActiveBridges.inventory
            if kind~='ox' then C.unsupported('xPlayer weapon metadata','only the verified ox_inventory schema is supported') end
        end
        local function slotFor(name)
            ox();local selected
            for _,slot in ipairs(C.weaponSlots(id)) do if slot.name:upper()==name:upper() then
                if selected then C.unsupported('xPlayer weapon mutation','multiple weapons of this model; an ESX name cannot choose a serial/slot safely') end
                selected=slot
            end end;return selected
        end
        local function update(name,key,value)
            local slot=slotFor(name);if not slot then return false end
            local metadata=C.copy(slot.metadata or {});metadata[key]=value
            if C.invoke(I,'SetMetadata',id,slot.slot,metadata)==false then return false end
            local updated=C.invoke(I,'GetSlot',id,slot.slot)
            if not updated or not updated.metadata then return false end
            if type(value)=='table' then
                local actual=updated.metadata[key];if type(actual)~='table' or #actual~=#value then return false end
                for index,item in ipairs(value) do if actual[index]~=item then return false end end
            elseif updated.metadata[key]~=value then return false end
            if key~='components' then TriggerClientEvent('pr_bridge:esx:weaponUpdated',id,slot.slot,slot.name,key,value) end
            return true
        end
        fn('getLoadout',function(minimal) return C.loadout(id,minimal) end)
        fn('getWeapon',function(name)
            for index,weapon in ipairs(C.loadout(id)) do if weapon.name==name:upper() then return index,weapon end end
        end)
        fn('hasWeapon',function(name) local _,weapon=methods.getWeapon(name);return weapon~=nil end)
        fn('addWeapon',function(name,ammo)
            ox();ammo=C.amount(ammo);local _,definition=E.GetWeapon(name)
            if definition.throwable then C.unsupported('xPlayer.addWeapon','counted throwable items require a count/slot policy, not firearm ammo metadata') end
            if methods.hasWeapon(name) then return false end
            return C.invoke(I,'AddItem',id,definition.itemName,1,{ammo=ammo})
        end)
        fn('removeWeapon',function(name)
            local slot=slotFor(name);if not slot then return false end
            return C.invoke(I,'RemoveItem',id,slot.name,1,slot.metadata,slot.slot)
        end)
        local function firearm(name)
            local _,definition=E.GetWeapon(name)
            if definition.throwable then C.unsupported('weapon ammo','counted throwable items cannot use firearm ammo metadata') end
        end
        fn('updateWeaponAmmo',function(name,ammo) firearm(name);return update(name,'ammo',C.amount(ammo)) end)
        fn('addWeaponAmmo',function(name,ammo)
            firearm(name);ammo=C.amount(ammo);local slot=slotFor(name);if not slot then return false end
            return update(name,'ammo',C.amount((slot.metadata or {}).ammo or 0)+ammo)
        end)
        fn('removeWeaponAmmo',function(name,ammo)
            firearm(name);ammo=C.amount(ammo);local slot=slotFor(name);if not slot then return false end
            return update(name,'ammo',math.max(0,C.amount((slot.metadata or {}).ammo or 0)-ammo))
        end)
        fn('setWeaponTint',function(name,tint)
            tint=C.amount(tint);local _,definition=E.GetWeapon(name)
            if not definition.tints[tint] then return false end;return update(name,'tint',tint)
        end)
        fn('getWeaponTint',function(name) local _,weapon=methods.getWeapon(name);return weapon and weapon.tintIndex or 0 end)
        fn('hasWeaponComponent',function(name,alias)
            local _,weapon=methods.getWeapon(name);if not weapon then return false end
            for _,component in ipairs(weapon.components) do if component==alias then return true end end;return false
        end)
        local function attachment(name,alias,add)
            local slot=slotFor(name);if not slot then return false end
            if not E.GetWeaponComponent(name,alias) then return false end
            local component=C.componentItem(name,alias)
            local components=C.copy((slot.metadata or {}).components or {});local found
            for index,item in ipairs(components) do if item==component.name then found=index;break end end
            if add and found or not add and not found then return false end
            if add then
                for _,item in ipairs(components) do local existing=C.invoke(I,'Items',item)
                    if component.type and existing and existing.type==component.type then return false end
                end
                components[#components+1]=component.name
            else table.remove(components,found) end
            if not update(name,'components',components) then return false end
            TriggerClientEvent('pr_bridge:esx:weaponAttachment',id,slot.slot,slot.name,component.hash,add)
            return true
        end
        fn('addWeaponComponent',function(name,alias) return attachment(name,alias,true) end)
        fn('removeWeaponComponent',function(name,alias) return attachment(name,alias,false) end)
    end
end
