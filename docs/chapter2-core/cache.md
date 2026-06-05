# Cache API (`pr_lib.cache`)

A Cache API é, provavelmente, um dos trunfos de maior performance da bridge. 
Fazer buscas repetidas em metadados, ou checar cargos 60 vezes por segundo com `GetPlayer` em client-side devora performance inútil do FiveM. 
A Cache API cria uma sobre-vida nos dados para você acessá-los repetidamente a custo quase zero.

A API é exposta em `pr_lib.cache`.

## Função Base de Memória

### `.remember(key, callback, timeout)` (Alias: `.call()`)
Se a `key` já existir na memória RAM local, ele não roda o `callback`, ele apenas vomita o resultado da memória instantaneamente. Caso contrário, ele executa o bloco, salva o valor e limpa ele após o `timeout` (em ms).

```lua
-- Imagine isso dentro de um loop constante 0ms (Thread)
local money = pr_lib.cache.remember("player_cash", function()
    -- Esta query à framework só roda 1 vez por segundo, mesmo que a thread rode a 60 FPS.
    return pr_lib.framework.GetMoney("cash")
end, 1000)
```

## Manipulação Direta

### `.set(key, value)`
Seta um valor absoluto na chave de cache.
```lua
pr_lib.cache.set("my_status_var", true)
```

### `.get(key, fallback)`
Busca e, se for nil, devolve o `fallback`.
```lua
local status = pr_lib.cache.get("my_status_var", false)
```

### `.clear(key)` e `.clearPrefix(prefix)`
Limpa imediatamente dados pendentes.
```lua
pr_lib.cache.clear("player_cash")
pr_lib.cache.clearPrefix("player_") -- Invalida todas as chaves começando com player_
```

## Ajudantes Rápidos de Framework

O sistema de cache já tem atalhos poderosos prontos para você, tanto `Client` quanto `Server`:

### `.GetPlayer(source, timeout)`
Busca os dados vitais do jogador.
* **Server**: Informe o `source` numérico e um `timeout` de atualização. (Ex: `pr_lib.cache.GetPlayer(source, 1000)`)
* **Client**: O `source` pode ser vazio ou substituído pelo valor de `timeout` (Ex: `pr_lib.cache.GetPlayer(1000)`). Não usa ID, busca ele próprio.

### `.GetMetadata(source, metadataName, timeout)`
Para capturar metadados do player (fome, sede, stress, phone, bank, etc).
* **Server**: `pr_lib.cache.GetMetadata(source, "hunger", 1000)`
* **Client**: `pr_lib.cache.GetMetadata("hunger", 1000)`

### `.InvalidatePlayer(source)`
Usado para forçar imediata limpeza (refresh) dos caches em torno daquele Player. Perfeito após uma compra em loja para que a próxima verificação venha fresca.
* **Server**: `pr_lib.cache.InvalidatePlayer(source)`
* **Client**: `pr_lib.cache.InvalidatePlayer()`
