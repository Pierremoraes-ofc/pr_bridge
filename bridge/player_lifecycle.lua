-- Host-only normalized lifecycle; loaded once by the pr_bridge manifest.
local framework = ActiveBridges and ActiveBridges.frameworks
if IsDuplicityVersion() then
    if framework == 'qbx' or framework == 'qb' then
        AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
            local data = player and (player.PlayerData or player)
            if data and data.source then TriggerEvent('pr_bridge:server:OnPlayerLoaded', tonumber(data.source)) end
        end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerSource)
            TriggerEvent('pr_bridge:server:OnPlayerUnloaded', tonumber(playerSource))
        end)
    elseif framework == 'esx' then
        AddEventHandler('esx:playerLoaded', function(playerSource) TriggerEvent('pr_bridge:server:OnPlayerLoaded', tonumber(playerSource)) end)
        AddEventHandler('esx:playerLogout', function(playerSource) TriggerEvent('pr_bridge:server:OnPlayerUnloaded', tonumber(playerSource)) end)
    end
else
    local function loaded() TriggerEvent('pr_bridge:client:OnPlayerLoaded') end
    local function unloaded() TriggerEvent('pr_bridge:client:OnPlayerUnloaded') end
    local function inventoryChanged()
        SetTimeout(0, function() TriggerEvent('pr_bridge:client:OnInventoryChanged') end)
    end
    if framework == 'qbx' or framework == 'qb' then
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', loaded)
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', unloaded)
        RegisterNetEvent('QBCore:Player:SetPlayerData', inventoryChanged)
    elseif framework == 'esx' then
        RegisterNetEvent('esx:playerLoaded', loaded)
        RegisterNetEvent('esx:onPlayerLogout', unloaded)
        RegisterNetEvent('esx:addInventoryItem', inventoryChanged)
        RegisterNetEvent('esx:removeInventoryItem', inventoryChanged)

    end
    if ActiveBridges and ActiveBridges.inventory == 'ox' then
        AddEventHandler('ox_inventory:itemCount', inventoryChanged)
        AddEventHandler('ox_inventory:updateInventory', inventoryChanged)
    end
end
