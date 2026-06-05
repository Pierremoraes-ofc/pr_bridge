# Manipulação de Entidades (`pr_lib.fivem.objects`)

Este módulo substitui a necessidade de você fazer loops complexos de `FindFirstObject`/`FindNextObject` ou usar nativas demoradas para achar coisas ao redor do jogador.

### Coleta em Raio
Você pode buscar tudo que está perto passando uma coordenada e um raio de alcance.
*Ele retorna uma tabela ordenada do mais perto pro mais longe!*

```lua
-- Pega o veículo mais próximo num raio de 5 metros
local carro = pr_lib.fivem.objects.getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0)

-- Pega todos os Peds num raio de 10 metros
local peds = pr_lib.fivem.objects.getPedsInRadius(GetEntityCoords(PlayerPedId()), 10.0)

-- Pega Objetos do cenário pelo Model Hash
local props = pr_lib.fivem.objects.getByModelInRadius(`prop_v_stand`, GetEntityCoords(PlayerPedId()), 5.0)
```

### O que o Bridge retorna?
Ao usar essas funções, o Bridge não retorna só o `entity ID`. Ele devolve uma tabela recheada de informação útil mastigada:

```lua
for k, v in pairs(peds) do
    print(v.entity) -- ID do Ped
    print(v.model) -- Model Hash
    print(v.distance) -- Distância exata de você
    print(v.coords) -- vec3()
end
```
