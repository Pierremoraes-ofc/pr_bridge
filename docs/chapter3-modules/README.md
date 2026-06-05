# Módulos de Integração (Adapters)

O grande diferencial do `pr_bridge` é fornecer tabelas fixas que abstraem funções do seu recurso para o Framework/Inventário detectado no servidor. 

Em vez de verificar se o servidor usa `qb-core` e depois chamar `QBCore.Functions.GetPlayer(source)`, você usa apenas `pr_lib.framework.GetPlayer(source)` e o bridge cuida do resto!

## Principais Adapters Globais

### Frameworks (`pr_lib.framework`)
Mapeado nativamente para `ND_Core`, `ox_core`, `es_extended`, `qbx_core`, e `qb-core`.
* **`.GetPlayer(source)`**: Traz o objeto do jogador padronizado.
* **`.GetMoney(source, account)`**: Retorna saldo.
* **`.RemoveMoney(source, account, amount)`**: Remove dinheiro.
* **`.AddMoney(source, account, amount)`**: Adiciona dinheiro.
* **`.GetJobInfo(source)`**: Traz tabela de emprego atual e level.
* **`.getPlayerMetadata(source, key)`**: Retorna metadados como fome, sede ou stress (recomendado usar `pr_lib.cache.GetMetadata` que envolve essa função com alta performance).

### Inventários (`pr_lib.inventory`)
Mapeado para `ox_inventory`, `qs-inventory`, `codem-inventory`, `origen_inventory`, `qb-inventory`.
* **`.AddItem(source, item, count, metadata)`**
* **`.RemoveItem(source, item, count, metadata)`**
* **`.GetItemCount(source, item)`**
* **`.HasItem(source, item, count)`**

## Módulos de Tela (Client)

### Targets (`pr_lib.target` / `pr_lib.targets`)
* `ox_target`, `qbx-core`, `qb-target`
```lua
pr_lib.target.AddBoxZone(...)
pr_lib.target.AddTargetEntity(...)
```

### Telefones (`pr_lib.phone` / `pr_lib.phones`)
* `qs-smartphone-pro`, `lb-phone`, `okokPhone`, `yseries`
Funções universais para mandar emails ou SMS a partir do sistema.

### Progresso (`pr_lib.progress` / `pr_lib.progressbar`)
Módulo unificado para barras de tarefas.
```lua
local success = pr_lib.progress.doProgressbar(
    5000, 
    "Assaltando a lojinha...", 
    { "amb@world_human_clipboard@male@idle_a", "idle_c" }
)
```

### Context Menus (`pr_lib.menus` / `pr_lib.menu`)
Exportação padrão da estrutura do `ox_lib` para menus. 
```lua
pr_lib.menus.RegisterContext(...)
pr_lib.menus.ShowContext(...)
```

---

*Todos esses módulos respeitam a ordem de detecção do `config.lua` e adaptam as funções de acordo.*
