-- Host-only lifecycle. Also bind after a core/inventory starts late when PR
-- Bridge is providing its ox_lib dependency. Refreshes never duplicate hooks.
local subscriptions = {}
local function listen(name, callback, network)
    if network then RegisterNetEvent(name) end
    local handler = AddEventHandler(name, callback)
    subscriptions[#subscriptions + 1] = handler
end
local function configure()
    for _, handler in ipairs(subscriptions) do RemoveEventHandler(handler) end
    subscriptions = {}
    local framework = ActiveBridges and ActiveBridges.frameworks
    if IsDuplicityVersion() then
        if framework == 'qbx' or framework == 'qb' then
            listen('QBCore:Server:PlayerLoaded', function(player)
                local data = player and (player.PlayerData or player)
                if data and data.source then TriggerEvent('pr_bridge:server:OnPlayerLoaded', tonumber(data.source)) end
            end)
            listen('QBCore:Server:OnPlayerUnload', function(playerSource)
                TriggerEvent('pr_bridge:server:OnPlayerUnloaded', tonumber(playerSource))
            end)
        elseif framework == 'esx' then
            listen('esx:playerLoaded', function(playerSource) TriggerEvent('pr_bridge:server:OnPlayerLoaded', tonumber(playerSource)) end)
            listen('esx:playerLogout', function(playerSource) TriggerEvent('pr_bridge:server:OnPlayerUnloaded', tonumber(playerSource)) end)
        end
    else
        local function loaded() TriggerEvent('pr_bridge:client:OnPlayerLoaded') end
        local function unloaded() TriggerEvent('pr_bridge:client:OnPlayerUnloaded') end
        local function inventoryChanged()
            SetTimeout(0, function() TriggerEvent('pr_bridge:client:OnInventoryChanged') end)
        end
        if framework == 'qbx' or framework == 'qb' then
            listen('QBCore:Client:OnPlayerLoaded', loaded, true)
            listen('QBCore:Client:OnPlayerUnload', unloaded, true)
            listen('QBCore:Player:SetPlayerData', inventoryChanged, true)
        elseif framework == 'esx' then
            listen('esx:playerLoaded', loaded, true)
            listen('esx:onPlayerLogout', unloaded, true)
            listen('esx:addInventoryItem', inventoryChanged, true)
            listen('esx:removeInventoryItem', inventoryChanged, true)
        end
        if ActiveBridges and ActiveBridges.inventory == 'ox' then
            listen('ox_inventory:itemCount', inventoryChanged)
            listen('ox_inventory:updateInventory', inventoryChanged)
        end
    end
end
configure()
AddEventHandler('pr_bridge:backend:changed', function(category)
    if category == 'frameworks' or category == 'inventories' then configure() end
end)
