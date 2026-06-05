# Vehicle Properties (`pr_lib.fivem.vehicleProperties`)

Diga adeus ao `QBCore.Functions.GetVehicleProperties` ou ao `ESX.Game.GetVehicleProperties`. O módulo `pr_lib.fivem.vehicleProperties` ou `pr_lib.vehicleProperties` foi portado e extremamente otimizado a partir do core do `ox_lib`.

Ele cataloga as modificações (incluindo cores customizadas hexadecimais de forma nativa), nível de dano (rodas furadas e portas arrancadas) e estado de trancamento, montando uma tabela única.

### Capturando Propriedades
```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
local props = pr_lib.fivem.vehicleProperties.get(vehicle)

print("Placa: " .. props.plate)
print("Cor 1 (R): " .. props.color1[1])
```

### Setando Propriedades
```lua
-- O 3o parametro "true" indica que o veículo será consertado fisicamente após aplicar as modificações.
pr_lib.fivem.vehicleProperties.set(vehicle, props, true)
```

> [!NOTE]
> Quando chamado no servidor, essa API envia a informação via evento de rede especificamente e unicamente para o atual *Network Owner* (dono do veículo), garantindo que as modificações físicas não apresentem *desync*. 

> [!TIP] Fallback com StateBags
> Em casos raros de *desync* grave, o sistema no `config.lua` possui a chave `Fivem.VehiclePropertiesStateBag`. Se ativada, as propriedades passarão a utilizar StateBags persistentes.
