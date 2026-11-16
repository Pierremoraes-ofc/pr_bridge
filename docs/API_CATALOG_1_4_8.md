# PR Bridge — API e Providers 1.4.8

**Fonte:** [`pr_bridge`](https://github.com/Pierremoraes-ofc/pr_bridge) revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae`. **1333 entradas documentadas por assinatura/contexto** em 6 volumes, não uma afirmação de 1333 funções independentes disponíveis simultaneamente. Backends diferentes podem expor subconjuntos distintos. Consulte também a [documentação interativa no portfólio](https://pierremoraes-ofc.github.io/portifolio/#docs/pr_bridge).

## Índice da API

- [Volume 1 — 225 entradas](api-1.4.8/catalog-01.md) — ace, addcommand, addExports, addkeybind, alert, appearance, banking, cache, callback, collections.array, collections.heap, collections.lru, collections.map, collections.ringbuffer, collections.selector, collections.set
- [Volume 2 — 225 entradas](api-1.4.8/catalog-02.md) — collections.set, core, database, debug, devtools, doorlock, emotes, entities, environment, events, fivem.aliases, fivem.blips, fivem.devtools, fivem.drawtext, fivem.dui
- [Volume 3 — 225 entradas](api-1.4.8/catalog-03.md) — fivem.dui, fivem.gizmo, fivem.identifiers, fivem.instructionalButtons, fivem.net, fivem.objects, fivem.raycast, fivem.streaming, fivem.tuning, fivem.ui, fivem.vehicleCache, fivem.vehicleProperties, fivem.vehicleState, framework
- [Volume 4 — 225 entradas](api-1.4.8/catalog-04.md) — framework, frameworkRouting, fuel, garage, getLocales, github, ids, input, interact, interface, inventory
- [Volume 5 — 225 entradas](api-1.4.8/catalog-05.md) — inventory, jsonDraft, library, loadJsonRecovery, locale, locale.lua, logger, math, menu, minigame, notification, phone, player, points, police, prison, progressbar, progression.lua
- [Volume 6 — 208 entradas](api-1.4.8/catalog-06.md) — progression.lua, radial, recordJsonIncident, saveJsonBatch, saveJsonRecovery, setInterval, settings, string, table, target, textui_adapter, timer, translator, utils, vehicle_key, waitFor, weather, withJsonLock, wrapJsonMutations, zones

## Providers e Expansão

A API do consumidor é `pr_lib.*`, mas cada função pode depender do **contexto client/server**, do **provider real selecionado** em `ConfigBridge`, de uma **fachada de compatibilidade** ou de um **módulo opt-in**. A ordem de entradas de cada `ConfigBridge.frameworks`, `inventories`, `targets` e outras categorias define a prioridade de descoberta; `Config.Framework` é diferente de `Config.compatFramework` (roteamento da fachada ESX). `Config.compatServices` permite registrar um export real quando um backend não implementa operação essencial; não inventa implementações. Consulte [contratos por framework](../bridge/frameworks/COMPAT.md) e [roteamento e aliases](../bridge/compat/FRAMEWORK_ROUTING.md).

O `fxmanifest.lua` 1.4.8 utiliza aliases **estáticos** `provide('ox_lib')`, `provide('ox_target')`, `provide('es_extended')`, `provide('qb-core')` e `provide('qbx_core')`. Ajuste/comente aqueles que entram em conflito com cores/bibliotecas originais antes de iniciar o servidor. A fachada `pr_lib.appearance` delega operações a `forge-appearance` e retorna `nil, 'appearance_provider_unavailable'` quando não existe provider.

### Inicialização e leitura do resultado

```lua
-- fxmanifest.lua do consumidor
shared_scripts { '@pr_bridge/init.lua' }

-- server.lua (dentro de um evento/comando válido)
local source = source
local player = pr_lib.framework.GetPlayer(source)
print('GetPlayer:', player)

-- client.lua
local localPlayer = pr_lib.framework.GetPlayer()
print('GetPlayer client:', localPlayer)
```

### Adaptação de um provider

```lua
-- bridge/config.lua
ConfigBridge.frameworks = {
    { resource = 'qbx_core', folder = 'qbx' },
    { resource = 'qb-core', folder = 'qb' },
    { resource = 'meu_framework', folder = 'custom' },
}
-- O adapter deve cumprir os mesmos contratos da API pública.
```

**Tags:** Cada entrada preserva tags para filtragem no catálogo interativo; múltiplas tags selecionadas são combinadas por interseção (AND). **Exemplos:** Cada entrada demonstra a chamada e apresenta o retorno com `print`, mas exemplos de backends e IDs são didáticos — substitua pelos argumentos aceitos pela função e trate `nil`/`false` em operações críticas. Funções de módulos opt-in precisam de import explícito. Documentação histórica 1.3/1.4.2 permanece disponível como registro e não prevalece sobre a implementação 1.4.8.
