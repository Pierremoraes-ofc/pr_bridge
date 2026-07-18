local framework = {}


--- Retorna as coordenadas do player (compatível com ESX e QBCore)
--- @param source number
--- @param withHeading boolean incluir heading (rotação) ou não
function framework.GetCoords(source, withHeading)
    -- fallback (apenas natives)
    local ped = GetPlayerPed(source)
    if withHeading then
        return vec4(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, GetEntityHeading(ped))
    else
        return GetEntityCoords(ped)
    end
end

return framework
