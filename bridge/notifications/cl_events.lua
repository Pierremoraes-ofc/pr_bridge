Bridge = Bridge or {}
Bridge.notify = Bridge.notify or {}

if IsDuplicityVersion() then
    ---Envia uma notificacao para um jogador especifico pelo servidor
    ---@param source number ID do jogador
    ---@param data NotificationData
    Bridge.notify.NotifyPlayer = function(source, data)
        if type(source) ~= "number" or source <= 0 then return end
        TriggerClientEvent("bridge:notify", source, data)
    end

    ---Envia uma notificacao para todos os jogadores conectados
    ---@param data NotificationData
    Bridge.notify.NotifyAll = function(data)
        TriggerClientEvent("bridge:notify", -1, data)
    end
else
    RegisterNetEvent("bridge:notify", function(data)
        if Bridge.notify and Bridge.notify.Notify then
            Bridge.notify.Notify(data)
        end
    end)
end
