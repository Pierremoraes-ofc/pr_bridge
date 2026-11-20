# pr_bridge
---

### Compatibilidade ox_lib / ox_target

A camada integrada de compatibilidade, a ordem de inicialização e os limites de homologação estão em [docs/OX_COMPATIBILITY.md](docs/OX_COMPATIBILITY.md). Não há recurso adicional de compatibilidade. Builds e testes offline aprovados; validação dentro do FiveM ainda pendente.

Os adaptadores e idiomas estão organizados em `bridge/compat/ox_lib/`.
`Config.compatOx_lib = true` mantém a compatibilidade ativa nesta base;
`false` impede a inicialização do host e a instalação nos consumidores.
Os caminhos públicos de `imports/` foram preservados. Veja o
[guia de ativação/desativação](bridge/compat/ox_lib/README.md), inclusive o
ajuste dos `provide` estáticos necessário para usar as bibliotecas originais.
### Fachada ESX

`compatFramework` seleciona o destino das chamadas ESX (`forge`/`auto`, `qbx`,
`qb`, `esx` ou `false`). A implementação está em `bridge/compat/esx/` e aceita
o objeto/export ESX e `@es_extended/imports.lua` sem exigir bridge no consumidor.
É uma implementação **parcial**, com erros explícitos para contratos ainda não
suportados; não é uma promessa de executar qualquer script ESX sem ajustes.
Veja [configuração e limites](bridge/compat/esx/README.md) e
[cobertura por função](bridge/compat/esx/COVERAGE.md).

### Usage as a library

`pr_bridge` core is standalone. It does not require `ox_lib`, `qb-core`, `qbx_core`, or any other resource to load. Those resources are only used by optional adapters when they are running.

Add `pr_bridge` to the resource manifest that will consume the bridge:

```lua
shared_scripts {
    "@pr_bridge/init.lua",
}
```

Then use the global `pr_lib` from client or server scripts:

```lua
pr_lib.notifications.Notify({
    title = "Status",
    description = "Tudo certo!",
    type = "success"
})
```

Debug helpers:

```lua
pr_lib.debug.info("Mensagem de debug")
pr_lib.debug.success("Bridge carregado")
pr_lib.debug.warn("Aviso controlado")
pr_lib.debug.error("Erro controlado")
```

Server notification helpers:

```lua
pr_lib.notifications.NotifyPlayer(source, data)
pr_lib.notifications.NotifyAll(data)
```

Cache helpers:

```lua
local player = pr_lib.cache.GetPlayer(source) -- server
local metadata = pr_lib.cache.GetMetadata(source, "hunger") -- server
local clientPlayer = pr_lib.cache.GetPlayer() -- client
local clientMetadata = pr_lib.cache.GetMetadata("hunger") -- client
```

Standalone loader helpers:

```lua
local module = pr_lib.load("@my_resource/path/to/module")
local data = pr_lib.loadJson("@my_resource/data/config")
```

Database helpers are server-side and auto-detect `oxmysql`, `ghmattimysql` or `mysql-async`.
Use `Config.Database = "auto"` or force one of those resource names/folders.

```lua
local rows = pr_lib.db.query("SELECT * FROM players WHERE citizenid = ?", { citizenid })
local player = pr_lib.db.single("SELECT * FROM players WHERE citizenid = ?", { citizenid })
local id = pr_lib.db.insert("INSERT INTO table_name (name) VALUES (?)", { "value" })

pr_lib.db.execute("UPDATE players SET metadata = ? WHERE citizenid = ?", { metadata, citizenid })
```

FiveM vehicle helpers:

```lua
local vehicle, netId = pr_lib.fivem.net.resolveVehicle(vehicleOrNetId)
local props = pr_lib.fivem.getVehicleProperties(vehicle)
pr_lib.fivem.setVehicleProperties(vehicle, props)

pr_lib.fivem.vehicleCache.set(vehicle, {
    netId = netId,
    plate = props.plate,
    props = props,
})

pr_lib.fivem.vehicleCache.setPersistentMeta(vehicle, {
    plate = props.plate,
    type = "player_vehicle",
    persistent = true,
})
```

Server-side vehicle property application sends a direct event to the network owner by default.
Use cache for heavy payloads and temporary work data. Use replicated statebags only for small metadata that clients must observe.
`Config.Fivem.VehiclePropertiesStateBag` is disabled by default and should only be enabled when that fallback is truly needed.

<br>
### 🚀 Supported Resources

| ✔️ Frameworks | 🎒 Inventories  | 🔔 Notifications      | 🎯 Targets    | 📱 Phones     | ⏳ Progressbars | ⛅ Weather             | ⛽ Fuel       | 🔑 Vehicle Keys   |
| ------------- | --------------- | --------------------- | ------------- | ------------- | ---------------- | ----------------------- | ------------- | ------------------ |
| NDCore        | ox_inventory    | ox_lib                | ox_target     | qs-smartphone | ox_lib           | Renewed-Weathersync     | cdn-fuel      | mm_carkeys         |
| ox_core       | qs-inventory    | qbx-core (lib)        | qbx-core (ox) | lb-phone      | qbx-core         | cd_easytime             | lc_fuel       | mri_Qcarkeys       |
| es_extended   | codem-inventory | es_extended           | qb-target     | okokPhone     | qb-core          | qb-weathersync          | LegacyFuel    | qb-vehiclekeys     |
| qbx-core      | origen_inventory| qb-core               |               | yseries       | es_extended      | default (GTA Native)    |               | qbx_vehiclekeys    |
| qb-core       | qb-inventory    | GTA Default           |               |               |                  |                         |               | wasabi_carlock     |

---


corrigir:
