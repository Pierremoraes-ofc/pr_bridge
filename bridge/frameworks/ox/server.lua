local framework = {}
if ActiveBridges["frameworks"] ~= "ox" then return end

local Ox = require '@ox_core.lib.init'

Debug('SUCCESS', Lang:t('Debug.FrameworkDetected', { framework = 'OX Core' }))

function framework.RegisterCallback(name, cb)
    if PRCore and PRCore.callback then
        PRCore.callback.register(name, cb)
    end
end

function framework.GetPlayer(source)
    return Ox.GetPlayer(source)
end

function framework.getPlayerFromId(source)
    return Ox.GetPlayer(source)
end

function framework.GetIdentifier(source)
    local player = Ox.GetPlayer(source)
    return player and player.charId or nil
end

function framework.getPlayerSourceFromPlayer(Player)
    return Player.source
end

function framework.getPlayerName(source)
    local player = Ox.GetPlayer(source)
    if not player then return "Unknown" end
    return player.get('firstName') .. ' ' .. player.get('lastName')
end

function framework.GetCoords(source, withHeading)
    local ped = GetPlayerPed(source)
    if withHeading then
        local coords = GetEntityCoords(ped)
        return vec4(coords.x, coords.y, coords.z, GetEntityHeading(ped))
    else
        return GetEntityCoords(ped)
    end
end

function framework.getPlayerMoney(source, moneyWallet)
    if Bridge.inventory and Bridge.inventory.GetItemCount then
        if moneyWallet == 'money' or moneyWallet == 'cash' then
            return Bridge.inventory.GetItemCount(source, "money") or 0
        elseif moneyWallet == 'black_money' then
            return Bridge.inventory.GetItemCount(source, "black_money") or 0
        end
    end
    return 0
end

function framework.addPlayerMoney(source, moneyWallet, amount)
    if moneyWallet == 'money' or moneyWallet == 'cash' then
        if Bridge.inventory and Bridge.inventory.AddItem then
            Bridge.inventory.AddItem(source, 'money', amount)
        end
    end
end

function framework.getPlayerJob(source, dataType)
    local player = Ox.GetPlayer(source)
    if not player then return nil end
    local groupName, groupGrade = player.getGroupByType("job")
    if dataType == 'label' then
        return groupName
    elseif dataType == 'name' then
        return groupName
    elseif dataType == 'grade' then
        return groupGrade
    elseif dataType == 'gradeLabel' then
        return tostring(groupGrade)
    end
    return { name = groupName, grade = groupGrade }
end

return framework
