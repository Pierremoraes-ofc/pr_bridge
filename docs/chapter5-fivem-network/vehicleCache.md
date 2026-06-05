# Vehicle Cache & Statebags (`pr_lib.fivem.vehicleCache`)

Manter controle de centenas de veículos no mapa consome CPU. A API `vehicleCache` permite que você acesse dados (como placa, NetID, Jobs donos do veículo) de forma imediata da memória cache gerada automaticamente no `client`.

Toda vez que a `vehicleProperties` ou `tuning` encosta em um carro, o cache (`store`) é atualizado.

### Buscas Locais
```lua
local data = pr_lib.fivem.vehicleCache.get(vehicleID)
-- ou
local data = pr_lib.fivem.vehicleCache.get(netId)
-- ou
local data = pr_lib.fivem.vehicleCache.getByPlate("ABC-1234")

if data then
    print("Ultima atualizacao de properties:", data.updatedAt)
end
```

### Statebags customizadas de Veículo
A engine já possui injetores que usam prefixos automáticos para não conflitar com outros scripts:

```lua
-- Seta um valor pra ser lido na rede toda (replicated = true)
pr_lib.fivem.vehicleCache.setState(vehicle, "trunk_open", true, true)

local isAberto = pr_lib.fivem.vehicleCache.getState(vehicle, "trunk_open")
```

### Metadados Persistentes
Se precisar guardar quem é o Dono do carro, facção, etc., de forma unificada:

```lua
-- SetPersistentMeta padroniza chaves fundamentais: id, owner, citizenid, type, job, garage
pr_lib.fivem.vehicleCache.setPersistentMeta(vehicle, {
    owner = "Pierre",
    job = "police",
    persistent = true
})

local meta = pr_lib.fivem.vehicleCache.getPersistentMeta(vehicle)
```
