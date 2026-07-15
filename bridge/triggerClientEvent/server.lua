---@meta

local triggerClientEvent

---Dispara um evento de cliente (client event) para um ou mais jogadores de forma otimizada.
---Esta função realiza a serialização (msgpack) dos argumentos apenas uma vez, em vez de fazer por alvo,
---proporcionando ganhos significativos de desempenho ao disparar para múltiplos jogadores.
---@param eventName string O nome do evento a ser disparado
---@param targetIds number | number[] | string | string[] ID do jogador ou lista de IDs dos jogadores
---@param ... any Parâmetros adicionais enviados como argumentos do evento
function triggerClientEvent(eventName, targetIds, ...)
    local payload = msgpack.pack_args(...)
    local payloadLen = #payload

    if type(targetIds) == "table" then
        for i = 1, #targetIds do
            local target = targetIds[i]
            if target then
                TriggerClientEventInternal(eventName, tostring(target), payload, payloadLen)
            end
        end
        return
    end

    if targetIds then
        TriggerClientEventInternal(eventName, tostring(targetIds), payload, payloadLen)
    end
end

return triggerClientEvent
