# Complemento de APIs - fundação, cache e callbacks

Este complemento documenta APIs acrescentadas durante a preparação para remoção do `ox_lib`. Ele faz parte do catálogo principal `functions_datails.md`.

## Utilitários compartilhados

### `pr_lib.string.random(pattern, length?)`

Gera texto aleatório com padrão compatível:

- `1`: número de 0 a 9.
- `A`: letra maiúscula.
- `a`: letra minúscula.
- `.`: letra maiúscula ou número.
- `^`: trata o próximo caractere literalmente.

```lua
local plate = pr_lib.string.random("AAA-1111")
```

### `pr_lib.math.groupdigits(value, separator?)`

Formata grupos de milhar. O separador padrão é vírgula.

```lua
local money = pr_lib.math.groupdigits(1500000, ".") -- 1.500.000
```

### `pr_lib.table.matches(left, right)`

Compara profundamente duas tabelas, inclusive estruturas aninhadas e referências cíclicas.

### `pr_lib.table.freeze(value)` / `pr_lib.table.isfrozen(value)`

Cria proteção superficial contra escrita normal. Tabelas aninhadas continuam mutáveis se não forem congeladas separadamente.

### `pr_lib.timer(duration, onEnd?, async?)`

Cria e inicia um timer. Métodos disponíveis:

- `timer:start(async?)`
- `timer:pause()`
- `timer:play()`
- `timer:restart(async?)`
- `timer:forceEnd(triggerOnEnd?)`
- `timer:isPaused()`
- `timer:getTimeLeft("ms" | "s" | "m" | "h")`

### `pr_lib.setClipboard(value)` (Client)

Copia texto pela NUI nativa do `pr_bridge`, sem depender do `ox_lib`.

### `SetInterval` / `ClearInterval`

O `init.lua` publica os aliases globais apenas quando eles ainda não existem. As APIs `pr_lib.setInterval` e `pr_lib.clearInterval` permanecem disponíveis.

## Cache central e statebag-like

Somente o recurso host `pr_bridge` executa leituras automáticas. Recursos consumidores recebem atualizações leves e não criam scanners próprios.

### Leituras equivalentes

```lua
local ped = pr_lib.cache.ped
local vehicle = pr_lib.cache.state.vehicle
local coords = pr_lib.cache:get("coords")
```

Chaves automáticas: `playerId`, `serverId`, `ped`, `vehicle`, `seat`, `weapon`, `coords`, `interior`, `dead`, `entityCount` e `playerCount`.

### Escrita, TTL e invalidação

- `pr_lib.cache:set(key, value, ttl?)`
- `pr_lib.cache:get(key, fallback?)`
- `pr_lib.cache:has(key)`
- `pr_lib.cache:clear(key?)`
- `pr_lib.cache:clearPrefix(prefix)`
- `pr_lib.cache:remember(key, callback, ttl?)`

### Observação

`pr_lib.cache:onChange(key, callback)` e `pr_lib.onCache(key, callback)` retornam uma função de cancelamento e o id do listener. O callback recebe `(newValue, oldValue, key)`.

### Entidades

- `pr_lib.cache:getEntity(entityOrNetId)`
- `pr_lib.cache:getEntityState(entityOrNetId)`
- `pr_lib.cache:getEntities(kind?)`
- `pr_lib.cache:scanWorld()` (host)
- `pr_lib.cache:setWorldEnabled(enabled)`

Tipos aceitos em `getEntities`: `peds`, `vehicles` e `objects`. A leitura statebag-like não replica dados arbitrários em state bags.

### Métricas

`pr_lib.cache:getMetrics()` ou `pr_lib.getCacheMetrics()` retorna hits, misses, escritas, valores inalterados, evicções, listeners, falhas de listeners, entidades e varreduras.

### Convars

- `pr_bridge:cache:world` (padrão `true`)
- `pr_bridge:cache:worldInterval` (cliente `1500`, servidor `2000` ms)
- `pr_bridge:cache:playerInterval` (padrão `100` ms)
- `pr_bridge:cache:coordsInterval` (padrão `250` ms)
- `pr_bridge:cache:slowInterval` (padrão `500` ms)
- `pr_bridge:cache:serverPlayerInterval` (padrão `1000` ms)

## Callbacks reforçados (opt-in)

Ativação de homologação:

```cfg
setr pr_bridge:callback:secure true
```

Sem a convar, o protocolo legado continua ativo. O modo reforçado adiciona validação do source esperado, limite de pendências, limite de entrada por jogador, timeout, limpeza no drop/stop, erros protegidos e métricas.

APIs preservadas:

- Client: `trigger(name, cb, ...)`, `await(name, timeout, ...)`.
- Server legado: `triggerClient(source, name, cb, ...)`, `awaitClient(source, name, timeout, ...)`.
- Server sobrecarregado: `trigger(source, name, cb, ...)` ou `trigger(name, source, cb, ...)`.
- Server sobrecarregado: `await(source, name, timeout, ...)` ou `await(name, source, ...)`.
- Comuns: `register(name, handler)`, `cancel(id, reason?)`, `getPending()`, `getStats()`.

O modo reforçado protege também callbacks de resposta com `pcall`, limita pendências por jogador e limpa filas no `playerDropped` e `onResourceStop`.

Compatibilidade ox_lib:

- Client: `pr_lib.callback.ox(name, delay, cb, ...)` e `pr_lib.callback.ox.await(name, delay, ...)`.
- Server: `pr_lib.callback.ox(name, source, cb, ...)` e `pr_lib.callback.ox.await(name, source, ...)`.
- Server: a ordem ox_lib também é aceita diretamente por `pr_lib.callback(...)` e `pr_lib.callback.await(...)`.

Convars:

- `pr_bridge:callback:timeout` (padrão `10000` ms)
- `pr_bridge:callback:maxPending` (padrão `1024`)
- `pr_bridge:callback:maxPendingPerPlayer` (padrão `64`)
- `pr_bridge:callback:maxInboundPerPlayer` (padrão `32`)

## Entidades próximas

- `pr_lib.getNearbyVehicles(coords, radius?, includePlayerVehicle?)`
- `pr_lib.getClosestVehicle(coords, radius?, includePlayerVehicle?)`
- `pr_lib.getNearbyPlayers(coords, radius?, includePlayer?)`
- `pr_lib.getClosestPlayer(coords, radius?, includePlayer?)`

Os resultados preservam `.entity` e adicionam aliases `.vehicle`, `.ped` ou `.object` conforme o tipo.
