# PR Bridge 1.4.8 — Catálogo de funções (volume 5/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**225 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## inventory

### `pr_lib.inventory.GetItemBySlot(inv, slot)`

**Contexto:** `server`  
**Descrição:** Recupera dados do slot do inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `by` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemBySlot(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemCount(inv, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Verificações de estoque de itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `count` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemCount(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.getItemInfo(item)`

**Contexto:** `server`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `info` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.getItemInfo('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemInfo(item)`

**Contexto:** `server`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `info` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemInfo('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemLabel(item)`

**Contexto:** `server`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `label` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemLabel('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemSlots(inv, item, metadata)`

**Contexto:** `server`  
**Descrição:** Retorna uma lista de números de slots que contêm o item pesquisado.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `slots` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemSlots(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetPlayerInventory(source)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.GetPlayerInventory(source)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetResourceName()`

**Contexto:** `server`  
**Descrição:** Retorna o nome do script de inventário ativo no servidor.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `resource` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlot(inv, slot)`

**Contexto:** `server`  
**Descrição:** Recupera dados do slot do inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlot(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotForItem(inv, itemName, metadata)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `for` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotForItem(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotIdsWithItem(inv, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `ids` · `with` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotIdsWithItem(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotIdWithItem(inv, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `id` · `with` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotIdWithItem(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotsWithItem(inv, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slots` · `with` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotsWithItem(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotWithItem(inv, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `with` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotWithItem(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetStashItems(id)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `stash` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetStashItems('example_id')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetTotalUsedSlots(source)`

**Contexto:** `server`  
**Descrição:** Retorna o número de slots ocupados no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `total` · `used` · `slots` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.GetTotalUsedSlots(source)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetTotalWeight(items)`

**Contexto:** `server`  
**Descrição:** Calcula o peso total acumulado a partir de uma lista de itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `total` · `weight` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetTotalWeight({})
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetWeaponAttachmentItems()`

**Contexto:** `server`  
**Descrição:** Retorna a lista de itens válidos que servem como acessórios de armas.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `weapon` · `attachment` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetWeaponAttachmentItems()
print('Resultado:', result)
```

---

### `pr_lib.inventory.HasItem(inv, item, count, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Verificações de estoque de itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `has` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.HasItem(source, 'example', 1, {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.InspectInventory(target, source)`

**Contexto:** `server`  
**Descrição:** Permite que o jogador source visualize e inspecione em tempo real o inventário do jogador target.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `inspect` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.InspectInventory(source, source)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.Items(itemName)`

**Contexto:** `server`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.Items('water')
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.LoadInventory(source, identifier)`

**Contexto:** `server`  
**Descrição:** Força salvamento ou carregamento direto de estados de inventários no banco de dados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `load` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.LoadInventory(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.OpenPlayerInventory(src, target)`

**Contexto:** `server`  
**Descrição:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `open` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.OpenPlayerInventory(source, source)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.OpenShop(src, shopTitle)`

**Contexto:** `server`  
**Descrição:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `open` · `shop` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.OpenShop(source, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.OpenStash(source, id)`

**Contexto:** `server`  
**Descrição:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `open` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.OpenStash(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)`

**Contexto:** `server`  
**Descrição:** Cria uma loja dinâmica acessível por alvo ou coordenadas.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `register` · `shop` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RegisterShop('Loja', {}, vector3(0.0, 0.0, 0.0), {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)`

**Contexto:** `server`  
**Descrição:** Registra dinamicamente um novo baú (stash) no inventário com regras de permissão.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `register` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RegisterStash('example_id', 'example', 'example', 1, 'my_resource', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.RegisterUsableItem(item, cb, options)`

**Contexto:** `server`  
**Descrição:** Registra lógica de ativação de itens consumíveis.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `register` · `usable` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RegisterUsableItem('water', function(value) print('Callback:', value) end, {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.RemoveItem(inv, item, count, metadata, slot)`

**Contexto:** `server`  
**Descrição:** Remove um item do inventário do jogador ou de um baú.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `remove` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RemoveItem(source, 'example', 1, {}, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.RemoveItemIntoStash(id, item, amount, slot, slots, maxWeight)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `remove` · `item` · `into` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RemoveItemIntoStash('example_id', 'example', 1, 'example', 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.ReturnInventory(source)`

**Contexto:** `server`  
**Descrição:** Usado para apreender o inventário do jogador temporariamente e depois restaurá-lo (útil para sistemas de prisão).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `return` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.ReturnInventory(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.SaveInventory(source, offline)`

**Contexto:** `server`  
**Descrição:** Força salvamento ou carregamento direto de estados de inventários no banco de dados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `save` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.SaveInventory(source, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.Search(inv, search, item, metadata)`

**Contexto:** `server`  
**Descrição:** Executa buscas avançadas utilizando seletores complexos (comportamento nativo do ox_inventory).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `search` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.Search(source, 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetDurability(inv, slot, durability)`

**Contexto:** `server`  
**Descrição:** Define a durabilidade (vida útil de 0 a 100) do item de um determinado slot.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `durability` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.SetDurability(source, 'example', 100)
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetInventoryItems(source, item, amount)`

**Contexto:** `server`  
**Descrição:** APIs utilitárias para forçar estados de itens diretamente em slots.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.SetInventoryItems(source, 'water', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.SetItemBySlot(source, slot, itemdata)`

**Contexto:** `server`  
**Descrição:** APIs utilitárias para forçar estados de itens diretamente em slots.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `item` · `by` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.SetItemBySlot(source, 1, 'water')
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.setItemMetadata(inv, slot, metadata)`

**Contexto:** `server`  
**Descrição:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `item` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.setItemMetadata(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetItemMetadata(inv, slot, metadata)`

**Contexto:** `server`  
**Descrição:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `item` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.SetItemMetadata(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetMaxWeight(inv, maxWeight)`

**Contexto:** `server`  
**Descrição:** Redefine propriedades de limite de peso e contagem de slots de um baú/stash ou jogador.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `max` · `weight` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.SetMaxWeight(source, 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetMetadata(inv, slot, metadata)`

**Contexto:** `server`  
**Descrição:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.SetMetadata(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.setPlayerInventory(player, data)`

**Contexto:** `server`  
**Descrição:** APIs utilitárias para forçar estados de itens diretamente em slots.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.setPlayerInventory(source, {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.SetSlotCount(inv, slots)`

**Contexto:** `server`  
**Descrição:** Redefine propriedades de limite de peso e contagem de slots de um baú/stash ou jogador.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `slot` · `count` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.SetSlotCount(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.UpdateStash(stashid, items)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `update` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.UpdateStash('example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.UpdateVehicle(oldPlate, newPlate)`

**Contexto:** `server`  
**Descrição:** Transfere itens e baús de porta-malas/porta-luvas quando a placa de um veículo for alterada.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `update` · `vehicle` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.UpdateVehicle('ABC1234', 'ABC1234')
print('Retorno da operação:', result)
```

---

## jsonDraft

### `pr_lib.jsonDraft(value, branches?)`

**Contexto:** `server`  
**Descrição:** Cria cópia profunda do valor, ou copia somente as ramificações selecionadas; não salva. Útil para validar uma edição antes de publicar o estado.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `jsonDraft` · `server` · `persistência json protegida` · `json` · `draft`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.jsonDraft({}, {})
print('Retorno da operação:', result)
```

---

## library

### `pr_lib.library.requestModel(asset, timeout?)`

**Contexto:** `client`  
**Descrição:** Solicita e valida o carregamento do asset pela mesma camada nativa de streaming de PR Bridge; usa timeout padrão do loader e lança erro quando o asset não carrega. Disponível somente no client.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `client` · `library` · `assets` · `streaming` · `client`

**Exemplo de construção e uso:**

```lua
local asset = 'prop_ld_flow_bottle'
local result = pr_lib.library.requestModel(asset, 5000)
print('Asset carregado:', result)
```

---

### `pr_lib.library.requestScaleformMovie(asset, timeout?)`

**Contexto:** `client`  
**Descrição:** Solicita e valida o carregamento do asset pela mesma camada nativa de streaming de PR Bridge; usa timeout padrão do loader e lança erro quando o asset não carrega. Disponível somente no client.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `client` · `library` · `assets` · `streaming` · `client`

**Exemplo de construção e uso:**

```lua
local asset = 'instructional_buttons'
local result = pr_lib.library.requestScaleformMovie(asset, 5000)
print('Asset carregado:', result)
```

---

### `pr_lib.library.requestStreamedTextureDict(asset, timeout?)`

**Contexto:** `client`  
**Descrição:** Solicita e valida o carregamento do asset pela mesma camada nativa de streaming de PR Bridge; usa timeout padrão do loader e lança erro quando o asset não carrega. Disponível somente no client.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `client` · `library` · `assets` · `streaming` · `client`

**Exemplo de construção e uso:**

```lua
local asset = 'commonmenu'
local result = pr_lib.library.requestStreamedTextureDict(asset, 5000)
print('Asset carregado:', result)
```

---

### `pr_lib.library.getLocaleKey()`

**Contexto:** `shared`  
**Descrição:** Consulta o identificador de idioma no módulo local de configurações do consumidor.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `shared` · `library` · `locale` · `configuração`

**Exemplo de construção e uso:**

```lua
local locale = pr_lib.library.getLocaleKey()
print('Idioma atual:', locale)
```

---

### `pr_lib.library.hasLoaded()`

**Contexto:** `shared`  
**Descrição:** Confirma que a biblioteca canônica lazy foi inicializada no consumidor; não indica que todos os módulos opcionais foram carregados.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `shared` · `library` · `lazy` · `initialization`

**Exemplo de construção e uso:**

```lua
local ready = pr_lib.library.hasLoaded()
print('Biblioteca pronta:', ready)
```

---

### `pr_lib.library.module(path)`

**Contexto:** `shared`  
**Descrição:** Carrega um módulo de forma lazy a partir de um caminho relativo à raiz pr_bridge; mantém cache local e falha explicitamente para import inválido.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `shared` · `library` · `modules` · `lazy`

**Exemplo de construção e uso:**

```lua
local module = pr_lib.library.module('bridge/utils/numbers')
print('Módulo carregado:', type(module))
```

---

### `pr_lib.library.setLocale(key)`

**Contexto:** `shared`  
**Descrição:** Solicita a atualização do idioma na camada de localeSettings do consumidor. Requer chave/idioma suportado pelo sistema de localização.  
**Arquivo de origem:** [`bridge/library/init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/library/init.lua)  
**Tags:** `library` · `shared` · `library` · `locale` · `configuração`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.library.setLocale('pt-br')
print('Alteração de idioma:', result)
```

---

## loadJsonRecovery

### `pr_lib.loadJsonRecovery(path)`

**Contexto:** `server`  
**Descrição:** Carrega JSON primário válido ou o arquivo .bak; recuperação retorna também "recovered_backup". Se ambos estiverem corrompidos, lança erro e não sobrescreve com defaults.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `loadJsonRecovery` · `server` · `persistência json protegida` · `load` · `json` · `recovery`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.loadJsonRecovery('@my_resource/data/config.json')
print('Resultado:', result)
```

---

## locale

### `lang:clear()`

**Contexto:** `shared`  
**Descrição:** clear() Remove todas as entradas de tradução carregadas.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `clear` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:clear()
print('Retorno da operação:', result)
```

---

### `lang:delete(phraseTarget, prefix)`

**Contexto:** `shared`  
**Descrição:** delete(phraseTarget, prefix) Apaga uma entrada específica de tradução.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `delete` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:delete('hello', 'example:')
print('Resultado:', result)
```

---

### `lang:extend(phrases, prefix)`

**Contexto:** `shared`  
**Descrição:** extend(phrases, prefix) Adiciona um conjunto de frases a um catálogo de tradução ativo sob um prefixo identificador de namespace.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `extend` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:extend({ hello = 'Olá' }, 'example:')
print('Resultado:', result)
```

---

### `lang:has(key)`

**Contexto:** `shared`  
**Descrição:** has(key) Retorna um booleano que indica se a chave de tradução está mapeada na localidade ativa.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `has` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:has('example_key')
print('Resultado:', result)
```

---

### `lang:locale(newLocale)`

**Contexto:** `shared`  
**Descrição:** locale(newLocale) Altera dinamicamente o código de localidade atual do objeto de tradução (ex: para "pt", "en", "es").  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:locale('pt-br')
print('Retorno da operação:', result)
```

---

### `lang:replace(phrases)`

**Contexto:** `shared`  
**Descrição:** replace(phrases) Substitui todas as frases de localização atuais por um novo dicionário.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `replace` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:replace({ hello = 'Olá' })
print('Resultado:', result)
```

---

### `lang:t(key, substitutions)`

**Contexto:** `shared`  
**Descrição:** t(key, substitutions) Recupera a tradução associada à key. Permite a interpolação dinâmica substituindo variáveis no texto (ex: %{nome}).  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `lang` · `shared`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:t('example', {})
print('Resultado:', result)
```

---

### `pr_lib.getLocales(invokingResource)`

**Contexto:** `shared`  
**Descrição:** Retorna informações de locale disponíveis para o resource consumidor.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getLocales('my_resource')
print('Resultado:', result)
```

---

### `pr_lib.locale(invokingResource)`

**Contexto:** `shared`  
**Descrição:** Inicia a ponte de internacionalização do recurso que invocou a biblioteca.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.locale('my_resource')
print('Retorno da operação:', result)
```

---

## locale.lua

### `lang:getAll()`

**Contexto:** `client/server`  
**Descrição:** Retorna tabela das frases da instância locale; permite encaminhar as traduções para a NUI do consumidor.  
**Arquivo de origem:** [`bridge/locale.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/locale.lua)  
**Tags:** `locale.lua` · `client/server` · `locale: snapshot das traduções` · `get` · `all`

**Exemplo de construção e uso:**

```lua
local lang = pr_lib.locale(GetCurrentResourceName())
local result = lang:getAll()
print('Resultado:', result)
```

---

## logger

### `pr_lib.logger(source, event, message, tag?)`

**Contexto:** `client/server`  
**Descrição:** Imprime log com nome do recurso, evento e tag opcional; source é parâmetro de compatibilidade e não altera o texto.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `logger` · `client/server` · `entradas públicas antes ausentes do índice`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.logger(GetPlayerServerId(PlayerId()), 'example', 'example')
print('Resultado:', result)
```

---

## math

### `pr_lib.math.almostEqual(a, b, epsilon)`

**Contexto:** `shared`  
**Descrição:** Compara números de ponto flutuante considerando tolerâncias de arredondamento.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `almost` · `equal` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.almostEqual(1, 2, 0.001)
print('Resultado:', result)
```

---

### `pr_lib.math.AlmostEqual(a, b, epsilon)`

**Contexto:** `shared`  
**Descrição:** Compara números de ponto flutuante considerando tolerâncias de arredondamento.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `almost` · `equal` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.AlmostEqual(1, 2, 0.001)
print('Resultado:', result)
```

---

### `pr_lib.math.clamp(value, minimum, maximum)`

**Contexto:** `shared`  
**Descrição:** Limita um número dentro do intervalo especificado entre minimum e maximum.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `clamp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.clamp({}, 1, 100)
print('Resultado:', result)
```

---

### `pr_lib.math.Clamp(value, minimum, maximum)`

**Contexto:** `shared`  
**Descrição:** Limita um número dentro do intervalo especificado entre minimum e maximum.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `clamp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Clamp({}, 1, 100)
print('Resultado:', result)
```

---

### `pr_lib.math.Deg2Rad(value)`

**Contexto:** `shared`  
**Descrição:** Conversores de ângulos trigonométricos entre graus e radianos.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `deg2` · `rad` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Deg2Rad({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.degToRad(value)`

**Contexto:** `shared`  
**Descrição:** Conversores de ângulos trigonométricos entre graus e radianos.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `deg` · `to` · `rad` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.degToRad({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.distance2D(x1, y1, x2, y2)`

**Contexto:** `shared`  
**Descrição:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `distance2` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.distance2D(0.0, 0.0, 1.0, 1.0)
print('Resultado:', result)
```

---

### `pr_lib.math.Distance2D(x1, y1, x2, y2)`

**Contexto:** `shared`  
**Descrição:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `distance2` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Distance2D(0.0, 0.0, 1.0, 1.0)
print('Resultado:', result)
```

---

### `pr_lib.math.distance3D(x1, y1, z1, x2, y2, z2)`

**Contexto:** `shared`  
**Descrição:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `distance3` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.distance3D(0.0, 0.0, 0.0, 1.0, 1.0, 1.0)
print('Resultado:', result)
```

---

### `pr_lib.math.Distance3D(x1, y1, z1, x2, y2, z2)`

**Contexto:** `shared`  
**Descrição:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `distance3` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Distance3D(0.0, 0.0, 0.0, 1.0, 1.0, 1.0)
print('Resultado:', result)
```

---

### `pr_lib.math.groupdigits(value, separator?)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “groupdigits” por meio da API pública do módulo `math`.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `groupdigits` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.groupdigits({})
print('Resultado:', result)
```

---

### `pr_lib.math.hexToRGB(value)`

**Contexto:** `shared`  
**Descrição:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `hex` · `to` · `rgb` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.hexToRGB({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.HexToRGB(value)`

**Contexto:** `shared`  
**Descrição:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `hex` · `to` · `rgb` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.HexToRGB({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.hexToRGBA(value)`

**Contexto:** `shared`  
**Descrição:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `hex` · `to` · `rgba` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.hexToRGBA({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.HexToRGBA(value)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “hex to rgba” por meio da API pública do módulo `math`.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `hex` · `to` · `rgba` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.HexToRGBA({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.inverseLerp(startValue, finishValue, value)`

**Contexto:** `shared`  
**Descrição:** Retorna o fator decimal linear correspondente ao valor dentro do intervalo.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `inverse` · `lerp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.inverseLerp(0, 100, {})
print('Resultado:', result)
```

---

### `pr_lib.math.InverseLerp(startValue, finishValue, value)`

**Contexto:** `shared`  
**Descrição:** Retorna o fator decimal linear correspondente ao valor dentro do intervalo.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `inverse` · `lerp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.InverseLerp(0, 100, {})
print('Resultado:', result)
```

---

### `pr_lib.math.length2(x, y)`

**Contexto:** `shared`  
**Descrição:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `length2` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.length2(0.0, 0.0)
print('Resultado:', result)
```

---

### `pr_lib.math.Length2(x, y)`

**Contexto:** `shared`  
**Descrição:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `length2` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Length2(0.0, 0.0)
print('Resultado:', result)
```

---

### `pr_lib.math.length3(x, y, z)`

**Contexto:** `shared`  
**Descrição:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `length3` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.length3(0.0, 0.0, 0.0)
print('Resultado:', result)
```

---

### `pr_lib.math.Length3(x, y, z)`

**Contexto:** `shared`  
**Descrição:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `length3` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Length3(0.0, 0.0, 0.0)
print('Resultado:', result)
```

---

### `pr_lib.math.Lerp(startValue, finishValue, duration)`

**Contexto:** `shared`  
**Descrição:** Executa uma interpolação linear simples entre dois valores baseada no fator decimal.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `lerp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Lerp(0, 100, 1)
print('Resultado:', result)
```

---

### `pr_lib.math.lerp(startValue, finishValue, factor)`

**Contexto:** `shared`  
**Descrição:** Executa uma interpolação linear simples entre dois valores baseada no fator decimal.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `lerp` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.lerp(0, 100, 1.0)
print('Resultado:', result)
```

---

### `pr_lib.math.map(value, inMin, inMax, outMin, outMax)`

**Contexto:** `shared`  
**Descrição:** Mapeia de forma linear um valor de um intervalo de entrada para outro de saída.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `map` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.map({}, 'example', 1, 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.math.Map(value, inMin, inMax, outMin, outMax)`

**Contexto:** `shared`  
**Descrição:** Mapeia de forma linear um valor de um intervalo de entrada para outro de saída.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `map` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Map({}, 'example', 1, 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.math.normalToRotation(input)`

**Contexto:** `shared`  
**Descrição:** Converte um vetor normal de superfície em um vetor tridimensional de rotação (Pitch, Roll, Yaw).  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `normal` · `to` · `rotation` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.normalToRotation({})
print('Resultado:', result)
```

---

### `pr_lib.math.NormalToRotation(input)`

**Contexto:** `shared`  
**Descrição:** Converte um vetor normal de superfície em um vetor tridimensional de rotação (Pitch, Roll, Yaw).  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `normal` · `to` · `rotation` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.NormalToRotation({})
print('Resultado:', result)
```

---

### `pr_lib.math.parse(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Processa e valida a consistência de um número dentro de restrições.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `parse` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.parse({}, 1, 100, true)
print('Resultado:', result)
```

---

### `pr_lib.math.ParseNumber(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Processa e valida a consistência de um número dentro de restrições.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `parse` · `number` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.ParseNumber({}, 1, 100, true)
print('Resultado:', result)
```

---

### `pr_lib.math.Rad2Deg(value)`

**Contexto:** `shared`  
**Descrição:** Conversores de ângulos trigonométricos entre graus e radianos.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `rad2` · `deg` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Rad2Deg({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.radToDeg(value)`

**Contexto:** `shared`  
**Descrição:** Conversores de ângulos trigonométricos entre graus e radianos.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `rad` · `to` · `deg` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.radToDeg({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.round(value, places)`

**Contexto:** `shared`  
**Descrição:** Arredonda números de ponto flutuante.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `round` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.round({}, 2)
print('Resultado:', result)
```

---

### `pr_lib.math.Round(value, places)`

**Contexto:** `shared`  
**Descrição:** Arredonda números de ponto flutuante.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `round` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Round({}, 2)
print('Resultado:', result)
```

---

### `pr_lib.math.sign(value)`

**Contexto:** `shared`  
**Descrição:** Retorna -1 se o número for negativo, 1 se for positivo e 0 se for nulo.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `sign` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.sign({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.Sign(value)`

**Contexto:** `shared`  
**Descrição:** Retorna -1 se o número for negativo, 1 se for positivo e 0 se for nulo.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `sign` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.Sign({})
print('Retorno da operação:', result)
```

---

### `pr_lib.math.toHex(value, upper)`

**Contexto:** `shared`  
**Descrição:** Converte um número inteiro para uma string hexadecimal.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `hex` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.toHex({}, 100)
print('Resultado:', result)
```

---

### `pr_lib.math.ToHex(value, upper)`

**Contexto:** `shared`  
**Descrição:** Converte um número inteiro para uma string hexadecimal.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `hex` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.ToHex({}, 100)
print('Resultado:', result)
```

---

### `pr_lib.math.toScalars(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Processa tabelas ou tipos vetoriais normais do FiveM aplicando constraints matemáticas de limites.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `scalars` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.toScalars({}, 1, 100, true)
print('Resultado:', result)
```

---

### `pr_lib.math.ToScalars(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “to scalars” por meio da API pública do módulo `math`.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `scalars` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.ToScalars({}, 1, 100, true)
print('Resultado:', result)
```

---

### `pr_lib.math.toVector(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Processa tabelas ou tipos vetoriais normais do FiveM aplicando constraints matemáticas de limites.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `vector` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.toVector({}, 1, 100, true)
print('Resultado:', result)
```

---

### `pr_lib.math.ToVector(value, minimum, maximum, shouldRound)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “to vector” por meio da API pública do módulo `math`.  
**Arquivo de origem:** [`bridge/utils/numbers.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/numbers.lua)  
**Tags:** `math` · `to` · `vector` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.math.ToVector({}, 1, 100, true)
print('Resultado:', result)
```

---

## menu

### `pr_lib.getOpenContextMenu()`

**Contexto:** `client`  
**Descrição:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `get` · `open` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getOpenContextMenu()
print('Resultado:', result)
```

---

### `pr_lib.hideContext(onExit)`

**Contexto:** `client`  
**Descrição:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `hide` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.hideContext(function() print('Menu encerrado') end)
print('Resultado:', result)
```

---

### `pr_lib.hideMenu(onExit)`

**Contexto:** `client`  
**Descrição:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `hide` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.hideMenu(function() print('Menu encerrado') end)
print('Resultado:', result)
```

---

### `pr_lib.menus.alertDialog(data, timeout)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “alert dialog” por meio da API pública do módulo `menu`.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `alert` · `dialog` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.alertDialog({}, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.menus.AlertDialog(data, timeout)`

**Contexto:** `client`  
**Descrição:** Exibe um modal pop-up de confirmação de tela cheia (ex: Sim/Não), aguardando e retornando a decisão do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `alert` · `dialog` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.AlertDialog({}, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.menus.getOpenContextMenu()`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get open context menu” usando a ponte normalizada do módulo.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `get` · `open` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.getOpenContextMenu()
print('Resultado:', result)
```

---

### `pr_lib.menus.GetOpenContextMenu()`

**Contexto:** `client`  
**Descrição:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `get` · `open` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.GetOpenContextMenu()
print('Resultado:', result)
```

---

### `pr_lib.menus.hideContext(onExit)`

**Contexto:** `client`  
**Descrição:** Oculta os dados ou a operação “hide context” e restaura o estado visual relacionado.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `hide` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.hideContext(function() print('Menu encerrado') end)
print('Resultado:', result)
```

---

### `pr_lib.menus.HideContext(onExit)`

**Contexto:** `client`  
**Descrição:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `hide` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.HideContext(function() print('Menu encerrado') end)
print('Resultado:', result)
```

---

### `pr_lib.menus.HideMenu(onExit)`

**Contexto:** `client`  
**Descrição:** Exibe ou esconde o menu registrado sob a ID correspondente.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `hide` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.HideMenu(function() print('Menu encerrado') end)
print('Resultado:', result)
```

---

### `pr_lib.menus.inputDialog(heading, rows, options)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “input dialog” por meio da API pública do módulo `menu`.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `input` · `dialog` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.inputDialog('example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.menus.InputDialog(heading, rows, options)`

**Contexto:** `client`  
**Descrição:** Exibe uma caixa de diálogo na tela contendo formulários de entrada de dados (inputs, selects, etc.), retornando as respostas do usuário após o envio.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `input` · `dialog` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.InputDialog('example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.menus.registerContext(context)`

**Contexto:** `client`  
**Descrição:** Registra os dados ou a operação “register context” no módulo ativo.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `register` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.registerContext('Exemplo do PR Bridge')
print('Resultado:', result)
```

---

### `pr_lib.menus.RegisterContext(context)`

**Contexto:** `client`  
**Descrição:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `register` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.RegisterContext('Exemplo do PR Bridge')
print('Resultado:', result)
```

---

### `pr_lib.menus.RegisterMenu(data, cb)`

**Contexto:** `client`  
**Descrição:** Registra um menu contextual ou lista (baseado em ox_lib ou qb-menu). data descreve as opções e cb é acionado quando o menu é fechado ou atualizado.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `register` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.RegisterMenu({}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.menus.showContext(id)`

**Contexto:** `client`  
**Descrição:** Exibe os dados ou a operação “show context” ao jogador.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `show` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.showContext('example_id')
print('Resultado:', result)
```

---

### `pr_lib.menus.ShowContext(id)`

**Contexto:** `client`  
**Descrição:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `show` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.ShowContext('example_id')
print('Resultado:', result)
```

---

### `pr_lib.menus.ShowMenu(id, startIndex)`

**Contexto:** `client`  
**Descrição:** Exibe ou esconde o menu registrado sob a ID correspondente.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `menus` · `show` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.menus.ShowMenu('example_id', 1)
print('Resultado:', result)
```

---

### `pr_lib.registerContext(context)`

**Contexto:** `client`  
**Descrição:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `register` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.registerContext('Exemplo do PR Bridge')
print('Resultado:', result)
```

---

### `pr_lib.registerMenu(data, cb)`

**Contexto:** `client`  
**Descrição:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `register` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.registerMenu({}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.showContext(id)`

**Contexto:** `client`  
**Descrição:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `show` · `context` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.showContext('example_id')
print('Resultado:', result)
```

---

### `pr_lib.showMenu(id, startIndex)`

**Contexto:** `client`  
**Descrição:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.  
**Arquivo de origem:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`  
**Tags:** `menu` · `show` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.showMenu('example_id', 1)
print('Resultado:', result)
```

---

## minigame

### `pr_lib.cancelSkillCheck()`

**Contexto:** `client`  
**Descrição:** Cancela o skill check ativo, fecha a NUI, libera o foco do teclado e faz a chamada em espera retornar false. A tecla ESC também cancela.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `cancel` · `skill` · `check` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cancelSkillCheck()
print('Resultado:', result)
```

---

### `pr_lib.minigame.CancelSkillCheck()`

**Contexto:** `client`  
**Descrição:** Cancela o skill check ativo, fecha a NUI, libera o foco do teclado e faz a chamada em espera retornar false. A tecla ESC também cancela.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `cancel` · `skill` · `check` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.minigame.CancelSkillCheck()
print('Resultado:', result)
```

---

### `pr_lib.minigame.SkillCheck(...)`

**Contexto:** `client`  
**Descrição:** Executa o skill check nativo do pr_bridge. difficulties aceita nomes easy, medium e hard ou tabelas com areaSize e speedMultiplier; keys define as teclas válidas; options aceita label, timeout e position. A posição aceita top/top-center ou bottom/bottom-center, prevalece sobre a configuração global quando fornecida e usa a configuração administrativa quando omitida. Retorna um booleano após todas as etapas. Use /pr_skillcheck_top_test e /pr_skillcheck_bottom_test para homologar as duas posições.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `skill` · `check` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.minigame.SkillCheck()
print('Retorno da operação:', result)
```

---

### `pr_lib.minigame.Start(config, mode)`

**Contexto:** `client`  
**Descrição:** Executa o minigame ativo detectado pelo pr_bridge e retorna true em sucesso ou false em falha/cancelamento. O parametro config deve conter a configuracao do minigame, incluindo game e, quando aplicavel, dificultMinigame.vehiParked e dificultMinigame.vehiCarjack. O parametro mode seleciona qual dificuldade usar, por exemplo "parked" para veiculo estacionado ou "carjack" para roubo/abordagem. Adaptadores atuais: glitch-minigames, glitch-minigame, mhacking, ox_lib e fallback default.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `start` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.minigame.Start({}, 'default')
print('Resultado:', result)
```

---

### `pr_lib.minigames.Start(config, mode)`

**Contexto:** `client`  
**Descrição:** Executa o minigame ativo detectado pelo pr_bridge e retorna true em sucesso ou false em falha/cancelamento. O parametro config deve conter a configuracao do minigame, incluindo game e, quando aplicavel, dificultMinigame.vehiParked e dificultMinigame.vehiCarjack. O parametro mode seleciona qual dificuldade usar, por exemplo "parked" para veiculo estacionado ou "carjack" para roubo/abordagem. Adaptadores atuais: glitch-minigames, glitch-minigame, mhacking, ox_lib e fallback default.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `minigames` · `start` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.minigames.Start({}, 'default')
print('Resultado:', result)
```

---

### `pr_lib.skillCheck(difficulties, keys, options)`

**Contexto:** `client`  
**Descrição:** Executa o skill check nativo do pr_bridge. difficulties aceita nomes easy, medium e hard ou tabelas com areaSize e speedMultiplier; keys define as teclas válidas; options aceita label, timeout e position. A posição aceita top/top-center ou bottom/bottom-center, prevalece sobre a configuração global quando fornecida e usa a configuração administrativa quando omitida. Retorna um booleano após todas as etapas. Use /pr_skillcheck_top_test e /pr_skillcheck_bottom_test para homologar as duas posições.  
**Arquivo de origem:** `pr_bridge/bridge/minigames/*/client.lua`  
**Tags:** `minigame` · `skill` · `check` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.skillCheck('example', 'example', {})
print('Resultado:', result)
```

---

## notification

### `pr_lib.notify.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o script de notificação ativo (ex: "ox_lib", "okokNotify", "bulletin", etc.).  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.notify.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.notify.Notify(data, kind, duration)`

**Contexto:** `client`  
**Descrição:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.notify.Notify({}, 'default', 1)
print('Resultado:', result)
```

---

### `pr_lib.Notify(data)`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.Notify({})
print('Retorno da operação:', result)
```

---

### `pr_lib.hideNotifyBubble(id)`

**Contexto:** `client/server`  
**Descrição:** Fecha um balão privado ou global criado pelo cliente. No modo global, somente o jogador que criou aquela ID pode solicitar sua remoção.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `hide` · `notify` · `bubble` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.hideNotifyBubble('example_id')
print('Resultado:', result)
```

---

### `pr_lib.HideNotifyBubble(id)`

**Contexto:** `client/server`  
**Descrição:** Fecha um balão privado ou global criado pelo cliente. No modo global, somente o jogador que criou aquela ID pode solicitar sua remoção.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `hide` · `notify` · `bubble` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.HideNotifyBubble('example_id')
print('Resultado:', result)
```

---

### `pr_lib.notify(src, data, kind, duration)`

**Contexto:** `client/server`  
**Descrição:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.notify(GetPlayerServerId(PlayerId()), {}, 'default', 1)
print('Resultado:', result)
```

---

### `pr_lib.notifyBubble(data, kind, duration)`

**Contexto:** `client/server`  
**Descrição:** Mostra um balão de fala responsivo ancorado acima de um ped. Por padrão visibility = "self", então somente o jogador local recebe e vê o balão. Com visibility = "all", a solicitação passa pelo servidor e todos os jogadores veem o mesmo balão ancorado no ped de quem o acionou. Retorna a ID do balão.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `bubble` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.notifyBubble({}, 'default', 1)
print('Resultado:', result)
```

---

### `pr_lib.NotifyBubble(data, kind, duration)`

**Contexto:** `client/server`  
**Descrição:** Mostra um balão de fala responsivo ancorado acima de um ped. Por padrão visibility = "self", então somente o jogador local recebe e vê o balão. Com visibility = "all", a solicitação passa pelo servidor e todos os jogadores veem o mesmo balão ancorado no ped de quem o acionou. Retorna a ID do balão.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `bubble` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.NotifyBubble({}, 'default', 1)
print('Resultado:', result)
```

---

### `pr_lib.NotifyBubbleAll(actorSource, data)`

**Contexto:** `client/server`  
**Descrição:** Envia o balão a todos os clientes e o ancora no ped de actorSource. Exige a origem do personagem para impedir que cada cliente mostre o balão sobre si mesmo.  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `bubble` · `all` · `client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.NotifyBubbleAll('example', {})
print('Resultado:', result)
```

---

### `pr_lib.notify.GetResourceName()`

**Contexto:** `server`  
**Descrição:** Retorna o script de notificação ativo (ex: "ox_lib", "okokNotify", "bulletin", etc.).  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/server.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `get` · `resource` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.notify.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.notify.Notify(src, data, kind, duration)`

**Contexto:** `server`  
**Descrição:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).  
**Arquivo de origem:** `pr_bridge/bridge/notifications/*/server.lua; pr_bridge/interface/client/modules/notify.lua`  
**Tags:** `notification` · `notify` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.notify.Notify(source, {}, 'default', 1)
print('Resultado:', result)
```

---

## phone

### `pr_lib.phone.ClosePhone()`

**Contexto:** `client`  
**Descrição:** Força o fechamento imediato do celular.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `close` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.ClosePhone()
print('Retorno da operação:', result)
```

---

### `pr_lib.phone.CreateCall(name, number, image, anonymous)`

**Contexto:** `client`  
**Descrição:** Inicia a interface de discagem/ligação local no telefone.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `create` · `call` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.CreateCall('example', 1, 'example.png', false)
print('Resultado:', result)
```

---

### `pr_lib.phone.EndCall()`

**Contexto:** `client`  
**Descrição:** Encerra a chamada ativa localmente.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `end` · `call` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.EndCall()
print('Retorno da operação:', result)
```

---

### `pr_lib.phone.GetCall()`

**Contexto:** `client`  
**Descrição:** Consultas de status de ligações ativas.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `get` · `call` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.GetCall()
print('Resultado:', result)
```

---

### `pr_lib.phone.InPhone()`

**Contexto:** `client`  
**Descrição:** Retorna true se o jogador local estiver ativamente com a interface gráfica do celular aberta.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `in` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.InPhone()
print('Retorno da operação:', result)
```

---

### `pr_lib.phone.IsInCall()`

**Contexto:** `client`  
**Descrição:** Consultas de status de ligações ativas.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `is` · `in` · `call` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.IsInCall()
print('Resultado:', result)
```

---

### `pr_lib.phone.IsInCamera()`

**Contexto:** `client`  
**Descrição:** Retorna se o jogador está utilizando o aplicativo de foto/câmera do celular.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `is` · `in` · `camera` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.IsInCamera()
print('Resultado:', result)
```

---

### `pr_lib.phone.SetCanOpenPhone(bool)`

**Contexto:** `client`  
**Descrição:** Bloqueia ou libera a capacidade do jogador de abrir a interface do telefone.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `set` · `can` · `open` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.SetCanOpenPhone(false)
print('Resultado:', result)
```

---

### `pr_lib.phone.SetSOS(bool)`

**Contexto:** `client`  
**Descrição:** Ativa ou desativa alertas persistentes de GPS SOS locais.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/client.lua`  
**Tags:** `phone` · `set` · `sos` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.SetSOS(false)
print('Resultado:', result)
```

---

### `pr_lib.phone.GetActiveContext(source)`

**Contexto:** `server`  
**Descrição:** Obtém getActivePhoneContext do forge-npwd para source válido. Retorna tabela ou nil quando indisponível; não consulta aparelho aleatório pelo dono do personagem.  
**Arquivo de origem:** [`bridge/phones/default/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/phones/default/server.lua)  
**Tags:** `phone` · `server` · `telefone ativo: forge npwd` · `get` · `active` · `context`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.GetActiveContext(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.GetActiveDeviceId(source)`

**Contexto:** `server`  
**Descrição:** Retorna deviceId do aparelho atualmente ativo ou nil.  
**Arquivo de origem:** [`bridge/phones/default/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/phones/default/server.lua)  
**Tags:** `phone` · `server` · `telefone ativo: forge npwd` · `get` · `active` · `device` · `id`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.GetActiveDeviceId(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.GetActiveOwnerIdentifier(source)`

**Contexto:** `server`  
**Descrição:** Retorna ownerIdentifier do aparelho atualmente ativo ou nil.  
**Arquivo de origem:** [`bridge/phones/default/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/phones/default/server.lua)  
**Tags:** `phone` · `server` · `telefone ativo: forge npwd` · `get` · `active` · `owner` · `identifier`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.GetActiveOwnerIdentifier(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.GetMetaFromSource(source)`

**Contexto:** `server`  
**Descrição:** Obtém metadados de mídia, contatos ou fotos salvos no celular do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `get` · `meta` · `from` · `source` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.GetMetaFromSource(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.GetPhoneNames()`

**Contexto:** `server`  
**Descrição:** Lista de telefones cadastrados.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `get` · `names` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.GetPhoneNames()
print('Resultado:', result)
```

---

### `pr_lib.phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)`

**Contexto:** `server`  
**Descrição:** Retorna o número de telefone do jogador com base no seu identificador.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `get` · `number` · `from` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.GetPhoneNumberFromIdentifier(source, true)
print('Resultado:', result)
```

---

### `pr_lib.phone.HasEmailAccount(source)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador local criou ou possui uma conta ativa de e-mail no aplicativo.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `has` · `email` · `account` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.HasEmailAccount(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.IsInJobDuty(source)`

**Contexto:** `server`  
**Descrição:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `is` · `in` · `job` · `duty` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.IsInJobDuty(source)
print('Resultado:', result)
```

---

### `pr_lib.phone.RemoveFromJobDuty(source)`

**Contexto:** `server`  
**Descrição:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `remove` · `from` · `job` · `duty` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.RemoveFromJobDuty(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.phone.SendNewMessageFromApp(target, phoneNumber, message, appName)`

**Contexto:** `server`  
**Descrição:** Envia uma notificação/mensagem de texto simulada de um aplicativo (ex: WhatsApp, Bank) para o celular de destino.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `send` · `new` · `message` · `from` · `app` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.phone.SendNewMessageFromApp(source, '555-0100', 'example', 'example_app')
print('Resultado:', result)
```

---

### `pr_lib.phone.SendSOSMessage(source, job, coords, messageType)`

**Contexto:** `server`  
**Descrição:** Envia uma notificação de chamado de emergência GPS para os celulares das facções militares/médicas em serviço.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `send` · `sosmessage` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.SendSOSMessage(source, 'example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.phone.SetInJobDuty(source)`

**Contexto:** `server`  
**Descrição:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.  
**Arquivo de origem:** `pr_bridge/bridge/phones/*/server.lua`  
**Tags:** `phone` · `set` · `in` · `job` · `duty` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.phone.SetInJobDuty(source)
print('Retorno da operação:', result)
```

---

## player

### `pr_lib.player.new()`

**Contexto:** `client`  
**Descrição:** Cria facade com métodos player:get(field), player:set(field, value) e player:setr(field, value). Campos de inventário são lidos do provider ox_inventory e escritos por SetPlayerState; outros campos usam cache local.  
**Arquivo de origem:** [`bridge/cache/player_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/player_client.lua)  
**Tags:** `player` · `client` · `estado local do jogador` · `new`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.player.new()
print('Resultado:', result)
```

---

## points

### `pr_lib.points.getAllPoints()`

**Contexto:** `client`  
**Descrição:** Retorna os points ativos do resource consumidor.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.points.getAllPoints()
print('Resultado:', result)
```

---

### `pr_lib.points.getClosestPoint(filter)`

**Contexto:** `client`  
**Descrição:** Localiza o point ativo mais próximo, opcionalmente filtrado.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.points.getClosestPoint('example')
print('Resultado:', result)
```

---

### `pr_lib.points.new(data, distance, extraData)`

**Contexto:** `client`  
**Descrição:** Cria um point com onEnter/onExit/nearby e rastreamento de distância.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.points.new({}, false, {})
print('Resultado:', result)
```

---

## police

### `pr_lib.police.addKeybind(key, command, description)`

**Contexto:** `client`  
**Descrição:** Registra mapeamento de teclado para comando.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `add` · `keybind`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.addKeybind('example_key', 'example:action', 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.police.getCharInfo(key)`

**Contexto:** `client`  
**Descrição:** Retorna campo de PlayerData.charinfo do personagem local.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `get` · `char` · `info`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getCharInfo('example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getMetadata(key)`

**Contexto:** `client`  
**Descrição:** Retorna campo de PlayerData.metadata do personagem local.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `get` · `metadata`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getMetadata('example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayer()`

**Contexto:** `client`  
**Descrição:** Retorna PlayerPedId, não o objeto PlayerData do servidor.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `get` · `player`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getPlayer()
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayerData()`

**Contexto:** `client`  
**Descrição:** Retorna dados do personagem local através de framework.GetPlayerData, ou tabela vazia.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `get` · `player` · `data`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getPlayerData()
print('Resultado:', result)
```

---

### `pr_lib.police.isDead()`

**Contexto:** `client`  
**Descrição:** Considera isdead/inlaststand e natives de morte/saúde do ped.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `is` · `dead`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.isDead()
print('Resultado:', result)
```

---

### `pr_lib.police.notify(message, kind?, duration?)`

**Contexto:** `client`  
**Descrição:** Exibe notificação via menus.notify ou pr_lib.Notify, normalizando info para inform.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `notify`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.notify('example')
print('Resultado:', result)
```

---

### `pr_lib.police.requestAnim(dict)`

**Contexto:** `client`  
**Descrição:** Solicita dicionário por pr_lib.requestAnimDict e retorna se carregou.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `request` · `anim`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.requestAnim({})
print('Resultado:', result)
```

---

### `pr_lib.police.requestModel(model)`

**Contexto:** `client`  
**Descrição:** Solicita modelo por pr_lib.requestModel protegido e retorna se carregou.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client` · `compatibilidade policial: cliente` · `request` · `model`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.requestModel('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.police.callback(name, ...)`

**Contexto:** `client/server`  
**Descrição:** Consulta pr_lib.callback.await com timeout fixo de 10000ms.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `callback`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.callback('example:action')
print('Resultado:', result)
```

---

### `pr_lib.police.debug(...)`

**Contexto:** `client/server`  
**Descrição:** Log com tag do recurso; só escreve quando Config.Debug está habilitado.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `debug`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.debug()
print('Retorno da operação:', result)
```

---

### `pr_lib.police.error(...)`

**Contexto:** `client/server`  
**Descrição:** Log de erro com tag do recurso; não lança exceção.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `error`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.error()
print('Retorno da operação:', result)
```

---

### `pr_lib.police.getIdentifier(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna citizenid do PlayerData; source é usado somente no servidor.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `identifier`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getIdentifier(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJob(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna tabela job ou tabela vazia.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJob(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJobData(source?, key?)`

**Contexto:** `client/server`  
**Descrição:** Servidor: source/key; cliente: key. Sem key retorna job inteiro; caso contrário retorna seu campo.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `data`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobData(GetPlayerServerId(PlayerId()), 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getJobDuty(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna se job.onduty é true.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `duty`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobDuty(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJobGradeName(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna nome do grau, inclusive tabela job.grade; fallback de catálogo no servidor.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `grade` · `name`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobGradeName(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJobGradePay(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna job.payment ou 0.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `grade` · `pay`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobGradePay(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJobName(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna job.name.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `name`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobName(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getJobType(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna job.type.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `job` · `type`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobType(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayerName(source?)`

**Contexto:** `client/server`  
**Descrição:** Monta nome completo a partir de charinfo. Alias getName.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `player` · `name`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getPlayerName(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.getVehicleDefinition(model)`

**Contexto:** `client/server`  
**Descrição:** Aceita nome/hash/tabela com modelo e consulta catálogo QBX/QB; retorna definição ou nil.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `get` · `vehicle` · `definition`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getVehicleDefinition('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.police.info(...)`

**Contexto:** `client/server`  
**Descrição:** Log informativo com tag do recurso.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `info`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.info()
print('Retorno da operação:', result)
```

---

### `pr_lib.police.isBoss(source?)`

**Contexto:** `client/server`  
**Descrição:** Retorna se job.isboss é true.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `is` · `boss`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.isBoss(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.police.registerCallback(name, handler)`

**Contexto:** `client/server`  
**Descrição:** Delega o registro a pr_lib.callback.register.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `register` · `callback`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.registerCallback('example:action', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.police.warn(...)`

**Contexto:** `client/server`  
**Descrição:** Log de aviso com tag do recurso.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `client/server` · `compatibilidade policial: compartilhado` · `warn`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.warn()
print('Retorno da operação:', result)
```

---

### `pr_lib.police.addMoney(source, account, amount, reason?)`

**Contexto:** `server`  
**Descrição:** Delega a framework.addPlayerMoney; conta padrão cash.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `add` · `money`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.addMoney(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.police.getAllPlayers()`

**Contexto:** `server`  
**Descrição:** Retorna lista de sources numéricos conectados.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `all` · `players`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getAllPlayers()
print('Resultado:', result)
```

---

### `pr_lib.police.getCharInfo(source, key)`

**Contexto:** `server`  
**Descrição:** Retorna campo de PlayerData.charinfo.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `char` · `info`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.getCharInfo(source, 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getJobCount(name)`

**Contexto:** `server`  
**Descrição:** Conta jogadores em serviço com job.name correspondente.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `job` · `count`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobCount('example:action')
print('Resultado:', result)
```

---

### `pr_lib.police.getJobTypeCount(name)`

**Contexto:** `server`  
**Descrição:** Conta jogadores em serviço com job.type correspondente.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `job` · `type` · `count`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getJobTypeCount('example:action')
print('Resultado:', result)
```

---

### `pr_lib.police.getMetadata(source, key)`

**Contexto:** `server`  
**Descrição:** Retorna campo de PlayerData.metadata.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `metadata`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.getMetadata(source, 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayer(source)`

**Contexto:** `server`  
**Descrição:** Aceita objeto de player ou source e consulta framework.GetPlayer.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `player`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.getPlayer(source)
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayerByIdentifier(identifier)`

**Contexto:** `server`  
**Descrição:** Procura jogador por identificador; fallback offline usa qbx_core.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `player` · `by` · `identifier`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getPlayerByIdentifier('license:example')
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayerData(source)`

**Contexto:** `server`  
**Descrição:** Retorna PlayerData do objeto/source/identificador ou tabela vazia.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `player` · `data`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.getPlayerData(source)
print('Resultado:', result)
```

---

### `pr_lib.police.getPlayerNameByIdentifier(identifier)`

**Contexto:** `server`  
**Descrição:** Retorna nome completo do jogador online/offline encontrado.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `player` · `name` · `by` · `identifier`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getPlayerNameByIdentifier('license:example')
print('Resultado:', result)
```

---

### `pr_lib.police.getSharedJob(name)`

**Contexto:** `server`  
**Descrição:** Consulta catálogo de empregos pelo export qbx_core:GetJobs.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `shared` · `job`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getSharedJob('example:action')
print('Resultado:', result)
```

---

### `pr_lib.police.getSharedJobData(name, key)`

**Contexto:** `server`  
**Descrição:** Retorna campo do emprego compartilhado.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `shared` · `job` · `data`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getSharedJobData('example:action', 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.getSharedJobGrade(name, grade)`

**Contexto:** `server`  
**Descrição:** Retorna grau com chave numérica ou string no catálogo QBX.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `shared` · `job` · `grade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getSharedJobGrade('example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.police.getSharedJobGradeData(name, grade, key)`

**Contexto:** `server`  
**Descrição:** Retorna campo do grau compartilhado.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `get` · `shared` · `job` · `grade` · `data`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.police.getSharedJobGradeData('example:action', 1, 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.police.notify(source, message, kind?, duration?)`

**Contexto:** `server`  
**Descrição:** Envia evento de notificação do consumidor para o cliente indicado.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `notify`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.notify(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.police.removeMoney(source, account, amount, reason?)`

**Contexto:** `server`  
**Descrição:** Delega a framework.removePlayerMoney; conta padrão cash.  
**Arquivo de origem:** [`bridge/compat/police.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/police.lua)  
**Tags:** `police` · `server` · `compatibilidade policial: servidor` · `remove` · `money`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.police.removeMoney(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

## prison

### `prison.getStatus(src)`

**Contexto:** `server`  
**Descrição:** Delega a GetPrisonStatus; retorna resultado/motivo ou nil, "prison_unavailable".  
**Arquivo de origem:** [`bridge/prison/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/prison/server.lua)  
**Tags:** `prison` · `server` · `prisão: módulo opt-in` · `get` · `status`

**Exemplo de construção e uso:**

```lua
local prison = pr_lib.loadModule('@pr_bridge/bridge/prison/server')
local source = 1 -- substitua pelo source real recebido no servidor
local result = prison.getStatus(source)
print('Resultado:', result)
```

---

### `prison.isAvailable()`

**Contexto:** `server`  
**Descrição:** Retorna se xt-prison está iniciado.  
**Arquivo de origem:** [`bridge/prison/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/prison/server.lua)  
**Tags:** `prison` · `server` · `prisão: módulo opt-in` · `is` · `available`

**Exemplo de construção e uso:**

```lua
local prison = pr_lib.loadModule('@pr_bridge/bridge/prison/server')
local result = prison.isAvailable()
print('Resultado:', result)
```

---

### `prison.jail(src, sentence)`

**Contexto:** `server`  
**Descrição:** Delega a JailPlayer; validação de autorização/sentença continua no consumidor e provider.  
**Arquivo de origem:** [`bridge/prison/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/prison/server.lua)  
**Tags:** `prison` · `server` · `prisão: módulo opt-in` · `jail`

**Exemplo de construção e uso:**

```lua
local prison = pr_lib.loadModule('@pr_bridge/bridge/prison/server')
local source = 1 -- substitua pelo source real recebido no servidor
local result = prison.jail(source, 'example')
print('Resultado:', result)
```

---

### `prison.release(src)`

**Contexto:** `server`  
**Descrição:** Delega a ReleasePlayer, propagando resultado/motivo.  
**Arquivo de origem:** [`bridge/prison/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/prison/server.lua)  
**Tags:** `prison` · `server` · `prisão: módulo opt-in` · `release`

**Exemplo de construção e uso:**

```lua
local prison = pr_lib.loadModule('@pr_bridge/bridge/prison/server')
local source = 1 -- substitua pelo source real recebido no servidor
local result = prison.release(source)
print('Retorno da operação:', result)
```

---

## progressbar

### `pr_lib.progress.doProgressbar(duration, label, anim)`

**Contexto:** `client`  
**Descrição:** Mostra uma barra de carregamento de progresso linear na tela com tempo especificado em duration (ms) executando opcionalmente uma animação no personagem (anim).  
**Arquivo de origem:** `pr_bridge/bridge/progressbar/*/client.lua`  
**Tags:** `progressbar` · `progress` · `do` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.progress.doProgressbar(1, 'example', 'idle')
print('Resultado:', result)
```

---

### `pr_lib.progress.doProgressCircle(duration, label, anim)`

**Contexto:** `client`  
**Descrição:** Exibe um progresso circular real na NUI Svelte e preserva animação, props, bloqueios e cancelamento. As APIs pr_lib.progressCircle(data) e pr_lib.progress.progressCircle(data) aceitam o contrato do ox_lib, incluindo duration, label, position, canCancel, disable, anim, prop e color. O campo position aceita top/top-center, middle/center e bottom/bottom-center; quando informado na chamada ele prevalece sobre a posição global, e quando omitido o runtime Lua resolve e envia explicitamente a configuração administrativa persistida. Use /pr_progress_circle_test e /pr_progress_bar_test para homologar ambos usando a posição global configurada no painel; chamadas reais continuam podendo sobrescrever essa posição com position. A barra linear usa contorno branco nos segmentos e no indicador percentual.  
**Arquivo de origem:** `pr_bridge/bridge/progressbar/*/client.lua`  
**Tags:** `progressbar` · `progress` · `do` · `circle` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.progress.doProgressCircle(1, 'example', 'idle')
print('Resultado:', result)
```

---

### `pr_lib.progress.progressCircle(data)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “progress circle” por meio da API pública do módulo `progressbar`.  
**Arquivo de origem:** `pr_bridge/bridge/progressbar/*/client.lua`  
**Tags:** `progressbar` · `progress` · `circle` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.progress.progressCircle({})
print('Retorno da operação:', result)
```

---

### `pr_lib.progressCircle(data)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “progress circle” por meio da API pública do módulo `outros_adaptadores_(pr_lib.banking,_pr_lib.callback,_pr_lib.ace,_pr_lib.progress,_pr_lib.weather)`.  
**Arquivo de origem:** `pr_bridge/bridge/progressbar/*/client.lua`  
**Tags:** `progressbar` · `progress` · `circle` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.progressCircle({})
print('Retorno da operação:', result)
```

---

## progression.lua

### `PRProgression.accept(session, packet, resolve, now)`

**Contexto:** `shared`  
**Descrição:** Valida lote inteiro antes de alterar: sessão, contadores, regras, direção e orçamento. Contadores cumulativos tornam retries idempotentes; retorna sucesso e alterações ou false/motivo.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `accept`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.accept({}, 'example', 'example', GetGameTimer())
print('Resultado:', result)
```

---

### `PRProgression.change(session, name, delta, maximum)`

**Contexto:** `shared`  
**Descrição:** Aplica alteração limitada, marca dirty/revisão e retorna delta realmente aplicado.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `change`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.change({}, 'example', 'example', 100)
print('Resultado:', result)
```

---

### `PRProgression.client()`

**Contexto:** `shared`  
**Descrição:** Cria ledger do cliente com valores, counters, ack e revisão -1.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `client`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.client()
print('Retorno da operação:', result)
```

---

### `PRProgression.clientChange(client, name, delta, maximum)`

**Contexto:** `shared`  
**Descrição:** Aplica previsão local com limite e soma counters cumulativos; sem token retorna false, "not_loaded".  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `client` · `change`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.clientChange('example', 'example', 'example', 100)
print('Resultado:', result)
```

---

### `PRProgression.copy(value)`

**Contexto:** `shared`  
**Descrição:** Copia profundamente tabelas.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `copy`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.copy({})
print('Resultado:', result)
```

---

### `PRProgression.number(value)`

**Contexto:** `shared`  
**Descrição:** Converte número finito; NaN e infinitos retornam nil.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `number`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.number({})
print('Retorno da operação:', result)
```

---

