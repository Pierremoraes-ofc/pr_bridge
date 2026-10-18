-- Optional global bootstrap; normal QB scripts can continue using GetCoreObject.
QBCore=exports.pr_bridge:getQBCoreObject()
if not IsDuplicityVersion() then
    AddEventHandler('QBCore:Player:SetPlayerData',function(data)
        if source~=65535 and GetInvokingResource()~='pr_bridge' then return end
        QBCore.PlayerData=data
    end)
end
