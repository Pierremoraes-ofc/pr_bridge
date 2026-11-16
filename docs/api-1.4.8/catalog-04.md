# PR Bridge 1.4.8 — Catálogo de funções (volume 4/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**225 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## framework

### `pr_lib.framework.GetPlayer()`

**Contexto:** `client`  
**Descrição:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayer()
print('GetPlayer:', result)
```

---

### `pr_lib.framework.GetPlayerData()`

**Contexto:** `client`  
**Descrição:** Obtém os dados puros de persistência do personagem do jogador (como nome, metadados, dinheiro, etc.).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `data` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerData()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerDob()`

**Contexto:** `client`  
**Descrição:** Retorna a data de nascimento registrada do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `dob` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerDob()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerGender()`

**Contexto:** `client`  
**Descrição:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `gender` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerGender()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerGroup()`

**Contexto:** `client`  
**Descrição:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `group` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerGroup()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerIdentifier()`

**Contexto:** `client`  
**Descrição:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `identifier` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerIdentifier()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerInventory()`

**Contexto:** `client`  
**Descrição:** Retorna o inventário bruto de itens carregados do jogador da forma normalizada pelo framework ativo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `inventory` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerInventory()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerJob()`

**Contexto:** `client`  
**Descrição:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `job` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerJob()
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerMetadata(key)`

**Contexto:** `client`  
**Descrição:** Obtém um valor guardado dentro dos metadados persistentes do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `metadata` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.getPlayerMetadata('example_key')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerMetadata(key)`

**Contexto:** `client`  
**Descrição:** Obtém um valor guardado dentro dos metadados persistentes do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `metadata` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerMetadata('example_key')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerName()`

**Contexto:** `client`  
**Descrição:** Obtém o nome em jogo (RP) do personagem do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerName()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o nome do recurso de framework ativo no servidor (ex: "qbx_core", "qb-core", "es_extended").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.framework.HasItem(itemName, count, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Verifica se o jogador possui o item com a quantidade especificada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `has` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.HasItem('example', 1, {}, false)
print('Resultado:', result)
```

---

### `pr_lib.framework.HideTextUI()`

**Contexto:** `client`  
**Descrição:** Exibe e oculta painéis TextUI flutuantes.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `hide` · `text` · `ui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.HideTextUI()
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.IsPlayerDead()`

**Contexto:** `client`  
**Descrição:** Retorna se o jogador local está em estado de morte/nocaute.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `is` · `player` · `dead` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.IsPlayerDead()
print('Resultado:', result)
```

---

### `pr_lib.framework.IsPlayerLoaded()`

**Contexto:** `client`  
**Descrição:** Retorna se o personagem local terminou de carregar completamente e já está ativo e spawnado no mapa.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `is` · `player` · `loaded` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.IsPlayerLoaded()
print('Resultado:', result)
```

---

### `pr_lib.framework.IsSessionReady()`

**Contexto:** `client`  
**Descrição:** Consulta qbx_core:IsPlayerLoaded(). IsPlayerLoaded mantém o contrato de personagem autenticado; IsSessionReady distingue a sessão pronta no mundo.  
**Arquivo de origem:** [`bridge/frameworks/qbx/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/frameworks/qbx/client.lua)  
**Tags:** `framework` · `client` · `framework qbx: prontidão do mundo` · `is` · `session` · `ready`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.IsSessionReady()
print('Resultado:', result)
```

---

### `pr_lib.framework.Notify(message, kind, duration)`

**Contexto:** `client`  
**Descrição:** Dispara uma notificação nativa simplificada baseada no framework carregado.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `notify` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.Notify('example', 'default', 1)
print('Resultado:', result)
```

---

### `pr_lib.framework.PlayerHasJob(jobName, grade)`

**Contexto:** `client`  
**Descrição:** Verifica se o jogador pertence a um determinado grupo de emprego, com verificação opcional do nível do cargo (grade).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `player` · `has` · `job` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.PlayerHasJob('police', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.ShowTextUI(text)`

**Contexto:** `client`  
**Descrição:** Exibe e oculta painéis TextUI flutuantes.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `show` · `text` · `ui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.ShowTextUI('Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.toggleOutfit(wear, outfits)`

**Contexto:** `client`  
**Descrição:** Aplica ou remove partes de roupas integradas a sistemas de vestiários de frameworks.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `toggle` · `outfit` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.toggleOutfit(true, {})
print('Resultado:', result)
```

---

### `pr_lib.framework.GetVehiclesByHash(model?)`

**Contexto:** `client/server`  
**Descrição:** Retorna definição por hash/nome de modelo ou catálogo completo quando sem argumento. QBX consulta o catálogo autoritativo qbx_core; QB usa Shared.Vehicles; outros adapters têm fallback vazio.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `client/server` · `framework: identidade` · `catálogo e sessão` · `get` · `vehicles` · `by` · `hash`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetVehiclesByHash('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.framework.AddAccountBalance(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.AddAccountBalance(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddItem(source, itemName, count, metadata, slot)`

**Contexto:** `server`  
**Descrição:** Adiciona um item ao inventário do jogador, especificando metadados ou o slot preferencial.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.AddItem(source, 'water', 1, {}, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddJobAccountBalance(account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Adiciona fundos à conta bancária de uma facção/empresa/sociedade.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `job` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.AddJobAccountBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.addMoney(src, amount, account, reason)`

**Contexto:** `server`  
**Descrição:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `money` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.addMoney(source, 1, 'cash', 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddPlayerAccountBalance(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `player` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.AddPlayerAccountBalance(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.addPlayerMoney(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `player` · `money` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.addPlayerMoney(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddPlayerToGang(citizenid, gangName, grade)`

**Contexto:** `server`  
**Descrição:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `player` · `to` · `gang` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.AddPlayerToGang('license:example', 'police', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddPlayerToJob(citizenid, jobName, grade)`

**Contexto:** `server`  
**Descrição:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `player` · `to` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.AddPlayerToJob('license:example', 'police', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.addSocietyBalance(account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Adiciona fundos à conta bancária de uma facção/empresa/sociedade.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `society` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.addSocietyBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddWeapon(source, data)`

**Contexto:** `server`  
**Descrição:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `add` · `weapon` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.AddWeapon(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.CanCarryItem(source, itemName, count, metadata)`

**Contexto:** `server`  
**Descrição:** Verifica se o inventário do jogador comporta o peso/slots adicionais daquele item específico.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `can` · `carry` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.CanCarryItem(source, 'water', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.framework.ClearPlayerInventory(source)`

**Contexto:** `server`  
**Descrição:** Apaga todos os itens do inventário de um jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `clear` · `player` · `inventory` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.ClearPlayerInventory(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.CreateWeaponData(source, data, weaponData)`

**Contexto:** `server`  
**Descrição:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `create` · `weapon` · `data` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.CreateWeaponData(source, {}, {})
print('Resultado:', result)
```

---

### `pr_lib.framework.DeleteOwnedVehicle(plate)`

**Contexto:** `server`  
**Descrição:** Remove a persistência de propriedade de um veículo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `delete` · `owned` · `vehicle` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.DeleteOwnedVehicle('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.GetAccountBalance(source, account)`

**Contexto:** `server`  
**Descrição:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetAccountBalance(source, 'cash')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetAllPlayers()`

**Contexto:** `server`  
**Descrição:** Retorna uma lista contendo todos os IDs de jogadores conectados no servidor.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `all` · `players` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetAllPlayers()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetCoords(source, withHeading)`

**Contexto:** `server`  
**Descrição:** Retorna um vector3 ou vector4 contendo as coordenadas globais tridimensionais e o ângulo (heading) da entidade do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `coords` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetCoords(source, false)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetFrameworkGangs()`

**Contexto:** `server`  
**Descrição:** Obtém a lista geral de gangs/facções cadastradas no framework ativo quando o framework oferecer esse conceito.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `gangs` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetFrameworkGangs()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetFrameworkJobs()`

**Contexto:** `server`  
**Descrição:** Obtém a lista geral de empregos cadastrados no framework ativo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `jobs` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetFrameworkJobs()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetIdentifier(source)`

**Contexto:** `server`  
**Descrição:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetIdentifier(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getItemByName(name)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela de dados detalhada de um item pelo seu nome.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `by` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.getItemByName('example:action')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemByName(source, itemName, metadata, slot)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela de dados detalhada de um item pelo seu nome.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `by` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetItemByName(source, 'water', {}, 1)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemBySlot(source, slot)`

**Contexto:** `server`  
**Descrição:** Retorna os dados do item que ocupa o slot numérico informado.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `by` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetItemBySlot(source, 1)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemCount(source, itemName, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Retorna a contagem exata daquele item no inventário.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `count` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetItemCount(source, 'example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemData(source, itemName, metadata, slot)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela de dados detalhada de um item pelo seu nome.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `data` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetItemData(source, 'water', {}, 1)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemlabel(itemName)`

**Contexto:** `server`  
**Descrição:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `itemlabel` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetItemlabel('water')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemLabel(itemName)`

**Contexto:** `server`  
**Descrição:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `label` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetItemLabel('water')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetJobAccountBalance(account)`

**Contexto:** `server`  
**Descrição:** Retorna o saldo bancário atual da conta corporativa da sociedade/facção.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `job` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetJobAccountBalance('cash')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetJobCount(jobName)`

**Contexto:** `server`  
**Descrição:** Obtém a quantidade de funcionários que estão online e em serviço para o emprego especificado.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `job` · `count` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetJobCount('police')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetOfflinePlayer(identifier)`

**Contexto:** `server`  
**Descrição:** Consulta jogador offline através de qbx_core:GetOfflinePlayer(identifier), sem fingir que ele está conectado.  
**Arquivo de origem:** [`bridge/frameworks/qbx/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/frameworks/qbx/server.lua)  
**Tags:** `framework` · `server` · `framework qbx: jogador offline` · `get` · `offline` · `player`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetOfflinePlayer('license:example')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetOwnedVehicleData(plate)`

**Contexto:** `server`  
**Descrição:** Busca no banco de dados a estrutura de persistência associada a um veículo de proprietário baseado na placa.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `owned` · `vehicle` · `data` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetOwnedVehicleData('ABC1234')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetOwnedVehicleOwner(plate)`

**Contexto:** `server`  
**Descrição:** Retorna o identificador único (CitizenID/License) do dono do veículo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `owned` · `vehicle` · `owner` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetOwnedVehicleOwner('ABC1234')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayer(source)`

**Contexto:** `server`  
**Descrição:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local source = source -- ID do jogador
local result = pr_lib.framework.GetPlayer(source)
print('GetPlayer:', result)
```

---

### `pr_lib.framework.GetPlayerAccountBalance(source, account)`

**Contexto:** `server`  
**Descrição:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerAccountBalance(source, 'cash')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerData(source)`

**Contexto:** `server`  
**Descrição:** Obtém os dados puros de persistência do personagem do jogador (como nome, metadados, dinheiro, etc.).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `data` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerData(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerDOB(source)`

**Contexto:** `server`  
**Descrição:** Retorna a data de nascimento registrada do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `dob` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerDOB(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerDob(source)`

**Contexto:** `server`  
**Descrição:** Retorna a data de nascimento registrada do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `dob` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerDob(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerFromId(source)`

**Contexto:** `server`  
**Descrição:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `from` · `id` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerFromId(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerFromId(source)`

**Contexto:** `server`  
**Descrição:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `from` · `id` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerFromId(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerFromIdentifier(identifier)`

**Contexto:** `server`  
**Descrição:** Recupera um jogador logado a partir de sua licença primária ou ID única de cidadão (CitizenID/Identifier).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `from` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerFromIdentifier('license:example')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerGender(source)`

**Contexto:** `server`  
**Descrição:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `gender` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerGender(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerGroup(source)`

**Contexto:** `server`  
**Descrição:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `group` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerGroup(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerGroup(source)`

**Contexto:** `server`  
**Descrição:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `group` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerGroup(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerHeight(source)`

**Contexto:** `server`  
**Descrição:** Retorna a altura registrada do personagem no framework (normalmente usado em ESX).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `height` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerHeight(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerIdentifier(source)`

**Contexto:** `server`  
**Descrição:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerIdentifier(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerInventory(source)`

**Contexto:** `server`  
**Descrição:** Retorna o inventário bruto de itens carregados do jogador da forma normalizada pelo framework ativo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `inventory` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerInventory(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerJob(source, dataType)`

**Contexto:** `server`  
**Descrição:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerJob(source, 'default')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerJob(source)`

**Contexto:** `server`  
**Descrição:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerJob(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerMetadata(source, key)`

**Contexto:** `server`  
**Descrição:** Obtém um valor guardado dentro dos metadados persistentes do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerMetadata(source, 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerMetadata(source, key)`

**Contexto:** `server`  
**Descrição:** Obtém um valor guardado dentro dos metadados persistentes do personagem.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerMetadata(source, 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerMoney(source, account)`

**Contexto:** `server`  
**Descrição:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `money` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerMoney(source, 'cash')
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerName(source)`

**Contexto:** `server`  
**Descrição:** Obtém o nome em jogo (RP) do personagem do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerName(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerName(source)`

**Contexto:** `server`  
**Descrição:** Obtém o nome em jogo (RP) do personagem do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetPlayerName(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerNameByIdentifier(identifier)`

**Contexto:** `server`  
**Descrição:** Recupera o nome do personagem do jogador offline ou online pelo seu identificador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `name` · `by` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerNameByIdentifier('license:example')
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerSex(source)`

**Contexto:** `server`  
**Descrição:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `sex` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.getPlayerSex(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.getPlayerSourceFromPlayer(player)`

**Contexto:** `server`  
**Descrição:** Extrai a ID (source) do servidor a partir do objeto abstrato do jogador entregue pelo framework.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `player` · `source` · `from` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.getPlayerSourceFromPlayer(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetResourceName()`

**Contexto:** `server`  
**Descrição:** Retorna o nome do recurso de framework ativo no servidor (ex: "qbx_core", "qb-core", "es_extended").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `resource` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetWeapon(source, name)`

**Contexto:** `server`  
**Descrição:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `weapon` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.GetWeapon(source, 'example:action')
print('Resultado:', result)
```

---

### `pr_lib.framework.HasItem(source, itemName, count, metadata, strict)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador possui o item com a quantidade especificada.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `has` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.HasItem(source, 'example', 1, {}, false)
print('Resultado:', result)
```

---

### `pr_lib.framework.InsertOwnedVehicle(plate, owner, vehicle)`

**Contexto:** `server`  
**Descrição:** Grava um veículo na tabela de propriedade de veículos persistentes.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `insert` · `owned` · `vehicle` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.InsertOwnedVehicle('example', 'my_resource', 'example')
print('Resultado:', result)
```

---

### `pr_lib.framework.InventoryManagement(source, data)`

**Contexto:** `server`  
**Descrição:** API utilitária para gerenciamento em lote de estados do inventário.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `inventory` · `management` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.InventoryManagement(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.Items(itemName)`

**Contexto:** `server`  
**Descrição:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.Items('water')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.PlayerHasJob(source, jobName, grade)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador pertence a um determinado grupo de emprego, com verificação opcional do nível do cargo (grade).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `player` · `has` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.PlayerHasJob(source, 'police', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RegisterCallback(name, callback)`

**Contexto:** `server`  
**Descrição:** Registra um server-callback que pode ser requisitado e retornado síncrona ou assincronamente pelo cliente.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `register` · `callback` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.RegisterCallback('example:action', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.framework.RegisterUsableItem(itemName, callback)`

**Contexto:** `server`  
**Descrição:** Associa uma função executada quando o jogador consome ou usa o item a partir do inventário.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `register` · `usable` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.RegisterUsableItem('water', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.framework.RemoveAccountBalance(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.RemoveAccountBalance(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemoveItem(source, itemName, count, metadata, slot)`

**Contexto:** `server`  
**Descrição:** Remove um item do inventário do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.RemoveItem(source, 'water', 1, {}, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemoveJobAccountBalance(account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Remove fundos da conta corporativa/sociedade de um emprego específico.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `job` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.RemoveJobAccountBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemovePlayerAccountBalance(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `player` · `account` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.RemovePlayerAccountBalance(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemovePlayerFromGang(citizenid, gangName)`

**Contexto:** `server`  
**Descrição:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `player` · `from` · `gang` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.RemovePlayerFromGang('license:example', 'police')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemovePlayerFromJob(citizenid, jobName)`

**Contexto:** `server`  
**Descrição:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `player` · `from` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.RemovePlayerFromJob('license:example', 'police')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.removePlayerMoney(source, account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `player` · `money` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.removePlayerMoney(source, 'cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.removeSocietyBalance(account, amount, reason)`

**Contexto:** `server`  
**Descrição:** Remove fundos da conta corporativa/sociedade de um emprego específico.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `society` · `balance` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.removeSocietyBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.RemoveWeapon(source, data)`

**Contexto:** `server`  
**Descrição:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `remove` · `weapon` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.RemoveWeapon(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetMetadata(source, slot, metadata)`

**Contexto:** `server`  
**Descrição:** Define dados e atributos internos customizados para um item em um slot específico.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.SetMetadata(source, 1, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetPlayerDuty(source, onDuty)`

**Contexto:** `server`  
**Descrição:** Altera o estado de servico do emprego ativo do jogador (true para entrar em servico, false para sair).  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `duty` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.SetPlayerDuty(source, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetPlayerJob(source, jobName, grade)`

**Contexto:** `server`  
**Descrição:** Altera o emprego e cargo do jogador remotamente.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.SetPlayerJob(source, 'police', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.setPlayerMetadata(source, key, value)`

**Contexto:** `server`  
**Descrição:** Grava um valor nos metadados do jogador e sincroniza a alteração com o banco de dados e cliente.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.setPlayerMetadata(source, 'example_key', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetPlayerMetadata(source, key, value)`

**Contexto:** `server`  
**Descrição:** Grava um valor nos metadados do jogador e sincroniza a alteração com o banco de dados e cliente.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `metadata` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.SetPlayerMetadata(source, 'example_key', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetPlayerPrimaryGang(citizenid, gangName)`

**Contexto:** `server`  
**Descrição:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `primary` · `gang` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.SetPlayerPrimaryGang('license:example', 'police')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.SetPlayerPrimaryJob(citizenid, jobName)`

**Contexto:** `server`  
**Descrição:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `set` · `player` · `primary` · `job` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.SetPlayerPrimaryJob('license:example', 'police')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.takeMoney(src, amount, reason)`

**Contexto:** `server`  
**Descrição:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `take` · `money` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.framework.takeMoney(source, 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.framework.AddPlayerStatus(source, status, amount)`

**Contexto:** `shared`  
**Descrição:** Incrementa um status normalizado do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.AddPlayerStatus(source, 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPhoneProfile(source)`

**Contexto:** `shared`  
**Descrição:** Obtém o perfil/identidade de telefone normalizado do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPhoneProfile(source)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetPlayerStatus(source, status)`

**Contexto:** `shared`  
**Descrição:** Lê um status normalizado do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetPlayerStatus(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetVehicleData(model)`

**Contexto:** `shared`  
**Descrição:** Retorna dados normalizados do veículo/modelo no framework ativo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetVehicleData('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.framework.GetVehiclesByHash(model)`

**Contexto:** `shared`  
**Descrição:** Normaliza a consulta de dados de veículos por model/hash no framework ativo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetVehiclesByHash('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.framework.SetPlayerStatus(source, status, value)`

**Contexto:** `shared`  
**Descrição:** Define um status normalizado do jogador.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.SetPlayerStatus(source, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.framework.SetVehiclePersistence(vehicle, enabled)`

**Contexto:** `shared`  
**Descrição:** Altera o estado de persistência de uma entidade veículo quando suportado.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.SetVehiclePersistence(PlayerPedId(), false)
print('Retorno da operação:', result)
```

---

## frameworkRouting

### `pr_lib.frameworkRouting.assertAllowed(source, owner)`

**Contexto:** `shared`  
**Descrição:** Verifica se o consumidor pode adquirir uma fachada de framework; lê declarações pr_bridge_framework do manifesto e bloqueia compatibilidade incorreta contra um core nativo. Pode lançar erro.  
**Arquivo de origem:** [`bridge/compat/framework_routing.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/framework_routing.lua)  
**Tags:** `frameworkRouting` · `shared` · `provider` · `framework` · `segurança` · `contrato`

**Exemplo de construção e uso:**

```lua
local consumer = GetCurrentResourceName()
local ok, err = pcall(pr_lib.frameworkRouting.assertAllowed, 'esx', consumer)
print('Permitido:', ok, err)
```

---

### `pr_lib.frameworkRouting.forget(owner)`

**Contexto:** `shared`  
**Descrição:** Invalida o cache de declarações de framework de um resource consumidor; usado em lifecycle/stop para evitar estado antigo.  
**Arquivo de origem:** [`bridge/compat/framework_routing.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/framework_routing.lua)  
**Tags:** `frameworkRouting` · `shared` · `provider` · `framework` · `lifecycle`

**Exemplo de construção e uso:**

```lua
local consumer = GetCurrentResourceName()
pr_lib.frameworkRouting.forget(consumer)
print('Declarações invalidadas:', consumer)
```

---

### `pr_lib.frameworkRouting.getActive()`

**Contexto:** `shared`  
**Descrição:** Retorna o backend de framework selecionado pelo PR Bridge, ou 'default'. Diferencia o core realmente ativo dos aliases estáticos anunciados por `provide`.   
**Arquivo de origem:** [`bridge/compat/framework_routing.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/framework_routing.lua)  
**Tags:** `frameworkRouting` · `shared` · `provider` · `framework` · `roteamento` · `native`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.frameworkRouting.getActive()
print('Framework ativo:', result)
```

---

### `pr_lib.frameworkRouting.isNative(name)`

**Contexto:** `shared`  
**Descrição:** Normaliza um nome/alias e verifica se é o core nativo selecionado. Em um backend QBX, o adaptador QB pode também ser considerado nativo para compatibilidade.  
**Arquivo de origem:** [`bridge/compat/framework_routing.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/framework_routing.lua)  
**Tags:** `frameworkRouting` · `shared` · `provider` · `framework` · `native` · `compatibilidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.frameworkRouting.isNative('qb')
print('QB é nativo/compatível?', result)
```

---

### `pr_lib.frameworkRouting.select(supported)`

**Contexto:** `shared`  
**Descrição:** Escolhe um único destino dentre uma lista de frameworks aceitos pelo consumidor, dando prioridade ao core realmente ativo; só considera fachadas quando permitido em Config.compatFramework. Retorna nome canônico ou nil.  
**Arquivo de origem:** [`bridge/compat/framework_routing.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/framework_routing.lua)  
**Tags:** `frameworkRouting` · `shared` · `provider` · `framework` · `roteamento` · `seleção`

**Exemplo de construção e uso:**

```lua
local supported = { 'qb', 'esx' }
local result = pr_lib.frameworkRouting.select(supported)
print('Rota selecionada:', result)
```

---

## fuel

### `pr_lib.fuel.GetFuel(vehicle)`

**Contexto:** `client`  
**Descrição:** Obtém a porcentagem ou volume de combustível atual de um veículo (de 0.0 a 100.0).  
**Arquivo de origem:** `pr_bridge/bridge/fuel/*/client.lua`  
**Tags:** `fuel` · `get` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fuel.GetFuel(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fuel.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o script de combustível ativo (ex: "ox_fuel", "legacyfuel").  
**Arquivo de origem:** `pr_bridge/bridge/fuel/*/client.lua`  
**Tags:** `fuel` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fuel.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.fuel.SetFuel(vehicle, amount, type)`

**Contexto:** `client`  
**Descrição:** Define a quantidade e tipo de combustível no veículo informado.  
**Arquivo de origem:** `pr_bridge/bridge/fuel/*/client.lua`  
**Tags:** `fuel` · `set` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fuel.SetFuel(PlayerPedId(), 1, 'default')
print('Retorno da operação:', result)
```

---

## garage

### `pr_lib.garage.commitPropertyGarageDraft(options)`

**Contexto:** `client`  
**Descrição:** Confirma um draft de garagem de propriedade e normaliza o resultado.  
**Arquivo de origem:** [`bridge/garages/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.commitPropertyGarageDraft({})
print('Retorno da operação:', result)
```

---

### `pr_lib.garage.createPropertyGarage(options, done)`

**Contexto:** `client`  
**Descrição:** Inicia criação de garagem de propriedade no provider ativo e entrega o draft/resultado ao callback.  
**Arquivo de origem:** [`bridge/garages/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.createPropertyGarage({}, 'example')
print('Resultado:', result)
```

---

### `pr_lib.garage.getProvider()`

**Contexto:** `client`  
**Descrição:** Seleciona provider iniciado entre forge-garage, jg-advancedgarages, qbx_garages e qb-garages; respeita pr_bridge:garage ou auto. Retorna nome ou nil.  
**Arquivo de origem:** [`bridge/garages/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.getProvider()
print('Resultado:', result)
```

---

### `pr_lib.garage.registerProperty(options)`

**Contexto:** `client`  
**Descrição:** Registra a integração client de uma garagem de propriedade no provider ativo.  
**Arquivo de origem:** [`bridge/garages/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.registerProperty({})
print('Resultado:', result)
```

---

### `pr_lib.garage.unregisterProperty(handle)`

**Contexto:** `client`  
**Descrição:** Remove target/zone/registro client criado para uma garagem de propriedade.  
**Arquivo de origem:** [`bridge/garages/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.unregisterProperty(0)
print('Resultado:', result)
```

---

### `pr_lib.garage.getProvider()`

**Contexto:** `server`  
**Descrição:** Retorna o provider de garagem detectado/forçado no server.  
**Arquivo de origem:** [`bridge/garages/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/server.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.getProvider()
print('Resultado:', result)
```

---

### `pr_lib.garage.registerProperty(options)`

**Contexto:** `server`  
**Descrição:** Registra a garagem de propriedade no provider server quando necessário.  
**Arquivo de origem:** [`bridge/garages/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/server.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.registerProperty({})
print('Resultado:', result)
```

---

### `pr_lib.garage.validateLink(propertyId, data)`

**Contexto:** `server`  
**Descrição:** Valida server-side se os dados persistidos de garagem pertencem à propriedade/provider esperado.  
**Arquivo de origem:** [`bridge/garages/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/garages/server.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.garage.validateLink('example', {})
print('Resultado:', result)
```

---

## getLocales

### `pr_lib.getLocales(invokingResource?)`

**Contexto:** `client/server`  
**Descrição:** Retorna getAll() da instância locale do consumidor ou do recurso explicitado.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `getLocales` · `client/server` · `entradas públicas antes ausentes do índice` · `get` · `locales`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getLocales('my_resource')
print('Resultado:', result)
```

---

## github

### `pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “check dependency” por meio da API pública do módulo `github`.  
**Arquivo de origem:** [`bridge/github/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/github/client.lua)  
**Tags:** `github` · `check` · `dependency` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.github.checkDependency('example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “check dependency” por meio da API pública do módulo `github`.  
**Arquivo de origem:** [`bridge/github/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/github/server.lua)  
**Tags:** `github` · `check` · `dependency` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.github.checkDependency('example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.github.versionCheck(repository)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “version check” por meio da API pública do módulo `github`.  
**Arquivo de origem:** [`bridge/github/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/github/server.lua)  
**Tags:** `github` · `version` · `check` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.github.versionCheck('Pierremoraes-ofc/pr_bridge')
print('Resultado:', result)
```

---

## ids

### `pr_lib.ids.createUniqueId(registry, length, pattern)`

**Contexto:** `shared`  
**Descrição:** Gera uma string aleatória baseada no padrão (pattern ex: "ALPHANUMERIC") com o comprimento fornecido, garantindo sua exclusividade comparando com uma tabela de registros existentes (registry).  
**Arquivo de origem:** [`bridge/utils/ids.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/ids.lua)  
**Tags:** `ids` · `create` · `unique` · `id` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ids.createUniqueId({}, 8, 'AAA-111')
print('Resultado:', result)
```

---

### `pr_lib.ids.CreateUniqueId(registry, length, pattern)`

**Contexto:** `shared`  
**Descrição:** Gera uma string aleatória baseada no padrão (pattern ex: "ALPHANUMERIC") com o comprimento fornecido, garantindo sua exclusividade comparando com uma tabela de registros existentes (registry).  
**Arquivo de origem:** [`bridge/utils/ids.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/ids.lua)  
**Tags:** `ids` · `create` · `unique` · `id` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ids.CreateUniqueId({}, 8, 'AAA-111')
print('Resultado:', result)
```

---

## input

### `pr_lib.inputDialog(heading, rows, options)`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os diálogos nativos da interface do pr_bridge. Linhas numéricas aceitam step e precision; quando nenhum passo é informado, o campo aceita livremente valores decimais em vez de restringir a inteiros.  
**Arquivo de origem:** [`interface/client/modules/input.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/input.lua)  
**Tags:** `input` · `dialog` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inputDialog('example', 'example', {})
print('Resultado:', result)
```

---

## interact

### `pr_lib.interact.addEntityBoneInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddEntityBoneInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addEntityBoneInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddEntityBoneInteraction(data)`

**Contexto:** `client`  
**Descrição:** Cria uma interação ancorada em um bone específico de uma entidade.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddEntityBoneInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addEntityInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddEntityInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addEntityInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddEntityInteraction(data)`

**Contexto:** `client`  
**Descrição:** Cria uma interação ligada a uma entidade de rede usando netId, convertendo entity para network id quando possível.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddEntityInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addGlobalPlayerInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddGlobalPlayerInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addGlobalPlayerInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddGlobalPlayerInteraction(data)`

**Contexto:** `client`  
**Descrição:** Registra opções de interação aplicáveis globalmente aos outros jogadores próximos.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddGlobalPlayerInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addGlobalVehicleInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddGlobalVehicleInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addGlobalVehicleInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddGlobalVehicleInteraction(data)`

**Contexto:** `client`  
**Descrição:** Registra opções de interação aplicáveis globalmente aos veículos próximos.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddGlobalVehicleInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddInteraction(data)`

**Contexto:** `client`  
**Descrição:** Cria uma interação persistente em coordenadas do mundo e a registra no runtime central do PR Bridge.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addLocalEntityInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddLocalEntityInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addLocalEntityInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddLocalEntityInteraction(data)`

**Contexto:** `client`  
**Descrição:** Cria uma interação ligada a uma entidade local; quando bone é informado, a posição acompanha o osso da entidade.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddLocalEntityInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.addModelInteraction(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.AddModelInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.addModelInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.AddModelInteraction(data)`

**Contexto:** `client`  
**Descrição:** Cria interações para um ou vários modelos e permite offsets específicos por modelo.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.AddModelInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.disable(state)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.Disable.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.disable(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.Disable(state)`

**Contexto:** `client`  
**Descrição:** Ativa ou desativa globalmente o runtime de interact para o jogador local e replica interactionsDisabled no state bag.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.Disable(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.RemoveEntityInteraction(netId, id)`

**Contexto:** `client`  
**Descrição:** Remove interação de entidade de rede pelo netId, opcionalmente filtrando pelo id/nome.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveEntityInteraction(0, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveGlobalPlayerInteraction(id)`

**Contexto:** `client`  
**Descrição:** Remove registros globais de jogador pertencentes ao resource atual.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveGlobalPlayerInteraction('example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveGlobalVehicleInteraction(id)`

**Contexto:** `client`  
**Descrição:** Remove registros globais de veículo pertencentes ao resource atual.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveGlobalVehicleInteraction('example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.removeInteraction(id)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.RemoveInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.removeInteraction('example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveInteraction(id)`

**Contexto:** `client`  
**Descrição:** Remove uma interação pelo id, respeitando o resource proprietário do registro.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveInteraction('example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.removeInteractionByEntity(entity)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.RemoveInteractionByEntity.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.removeInteractionByEntity(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.RemoveInteractionByEntity(entity)`

**Contexto:** `client`  
**Descrição:** Remove interações pertencentes ao resource atual que estejam ligadas à entidade informada.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveInteractionByEntity(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.interact.removeInteractionOption(id, name)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.RemoveInteractionOption.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.removeInteractionOption('example_id', 'example')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveInteractionOption(id, name)`

**Contexto:** `client`  
**Descrição:** Remove uma opção específica pelo name; remove o registro inteiro se nenhuma opção restar.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveInteractionOption('example_id', 'example')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveLocalEntityInteraction(entity, id)`

**Contexto:** `client`  
**Descrição:** Remove interação de entidade local, opcionalmente filtrando também pelo id/nome do registro.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveLocalEntityInteraction(1, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.RemoveModelInteraction(models, id)`

**Contexto:** `client`  
**Descrição:** Remove interações de modelos informados, opcionalmente filtrando pelo id/nome.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.RemoveModelInteraction({ 'prop_ld_flow_bottle' }, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.interact.updateInteraction(id, options)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interact.UpdateInteraction.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.updateInteraction('example_id', {})
print('Resultado:', result)
```

---

### `pr_lib.interact.UpdateInteraction(id, options)`

**Contexto:** `client`  
**Descrição:** Substitui a lista de opções de uma interação já registrada.  
**Arquivo de origem:** [`bridge/interact/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/interact/client.lua)  
**Tags:** `interact` · `nui` · `world` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interact.UpdateInteraction('example_id', {})
print('Resultado:', result)
```

---

## interface

### `pr_lib.getVisualConfig()`

**Contexto:** `client`  
**Descrição:** Abre o painel administrativo global da interface e consulta sua configuração atual. A paleta, a opacidade e as posições de registerContext, metadata, alertDialog, inputDialog, registerMenu, notify, progress e TextUI ficam persistidas em interface/data/config.json e sincronizadas por state bag global. O comando /pr_ui_admin abre o mesmo painel; parentMenu pode apontar para um contexto pai e manter o botão de voltar.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `interface` · `get` · `visual` · `config` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getVisualConfig()
print('Resultado:', result)
```

---

### `pr_lib.openVisualAdminMenu(parentMenu)`

**Contexto:** `client`  
**Descrição:** Abre o painel administrativo global da interface e consulta sua configuração atual. A paleta, a opacidade e as posições de registerContext, metadata, alertDialog, inputDialog, registerMenu, notify, progress e TextUI ficam persistidas em interface/data/config.json e sincronizadas por state bag global. O comando /pr_ui_admin abre o mesmo painel; parentMenu pode apontar para um contexto pai e manter o botão de voltar.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `interface` · `open` · `visual` · `admin` · `menu` · `client` · `contexto` · `nui`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.openVisualAdminMenu('main_menu')
print('Resultado:', result)
```

---

## inventory

### `pr_lib.inventory.closeInventory()`

**Contexto:** `client`  
**Descrição:** Lógicas de abertura, fechamento e status de exibição da UI do inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `close` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.closeInventory()
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.displayMetadata(metadata, value)`

**Contexto:** `client`  
**Descrição:** Registra formatação de exibição de metadados customizados na interface do inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `display` · `metadata` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.displayMetadata({}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.getCurrentWeapon()`

**Contexto:** `client`  
**Descrição:** Resgata arma equipada e inventário bruto local do cliente.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `current` · `weapon` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.getCurrentWeapon()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetImagePath(item)`

**Contexto:** `client`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `image` · `path` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetImagePath('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.getInventoryImg(image)`

**Contexto:** `client`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `img` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.getInventoryImg('example.png')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetInventoryImg(image)`

**Contexto:** `client`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `img` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetInventoryImg('example.png')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemCount(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Verificações de estoque de itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `count` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemCount('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.getItemInfo(item)`

**Contexto:** `client`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `info` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.getItemInfo('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemInfo(item)`

**Contexto:** `client`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `info` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemInfo('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemLabel(item)`

**Contexto:** `client`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `label` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemLabel('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemList()`

**Contexto:** `client`  
**Descrição:** Busca propriedades registradas locais dos itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `list` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemList()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetPlayerInventory()`

**Contexto:** `client`  
**Descrição:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `player` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetPlayerInventory()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetPlayerItems()`

**Contexto:** `client`  
**Descrição:** Retorna a lista bruta de itens que estão atualmente na posse do jogador local.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `player` · `items` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetPlayerItems()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetPlayerMaxWeight()`

**Contexto:** `client`  
**Descrição:** Resgata propriedades de peso do jogador local.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `player` · `max` · `weight` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetPlayerMaxWeight()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetPlayerWeight()`

**Contexto:** `client`  
**Descrição:** Resgata propriedades de peso do jogador local.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `player` · `weight` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetPlayerWeight()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o nome do script de inventário ativo no servidor.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotIdsWithItem(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `ids` · `with` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotIdsWithItem('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotIdWithItem(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `id` · `with` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotIdWithItem('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotsWithItem(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slots` · `with` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotsWithItem('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetSlotWithItem(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `slot` · `with` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetSlotWithItem('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.giveItemToTarget(serverId, slotId, count)`

**Contexto:** `client`  
**Descrição:** Transfere um item do inventário local diretamente para o jogador próximo (serverId).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `give` · `item` · `to` · `target` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.giveItemToTarget('example', 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.HasItem(item, count, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Verificações de estoque de itens.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `has` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.HasItem('example', 1, {}, false)
print('Resultado:', result)
```

---

### `pr_lib.inventory.Items(itemName)`

**Contexto:** `client`  
**Descrição:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `items` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.Items('water')
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.openInventory(invType, data)`

**Contexto:** `client`  
**Descrição:** Lógicas de abertura, fechamento e status de exibição da UI do inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `open` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.openInventory('default', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.openNearbyInventory()`

**Contexto:** `client`  
**Descrição:** Abre o contêiner de drop/chão mais próximo.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `open` · `nearby` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.openNearbyInventory()
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.RegisterStash(id, slots, weight)`

**Contexto:** `client`  
**Descrição:** Registra dinamicamente um novo baú (stash) no inventário com regras de permissão.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `register` · `stash` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.RegisterStash('example_id', 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.Search(search, item, metadata)`

**Contexto:** `client`  
**Descrição:** Executa buscas avançadas utilizando seletores complexos (comportamento nativo do ox_inventory).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `search` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.Search('example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.setStashTarget(id, owner)`

**Contexto:** `client`  
**Descrição:** Registra ou define o proprietário temporário de baús.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `set` · `stash` · `target` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.setStashTarget('example_id', 'my_resource')
print('Resultado:', result)
```

---

### `pr_lib.inventory.useItem(data, cb)`

**Contexto:** `client`  
**Descrição:** Usa localmente um item ou aciona a tecla de atalho de um slot de arma/item.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `use` · `item` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.useItem({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.useSlot(slot)`

**Contexto:** `client`  
**Descrição:** Usa localmente um item ou aciona a tecla de atalho de um slot de arma/item.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `use` · `slot` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.useSlot(1)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.weaponWheel(state)`

**Contexto:** `client`  
**Descrição:** Ativa ou desativa o menu circular nativo de armas do GTA V.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `weapon` · `wheel` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.weaponWheel(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.AddItem(inv, item, count, metadata, slot, cb)`

**Contexto:** `server`  
**Descrição:** Adiciona um item a um inventário qualquer (inv pode ser o ID do jogador ou o ID de um baú/stash).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `add` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.AddItem(source, 'example', 1, {}, 'example', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.inventory.AddItemIntoStash(id, item, amount, slot, metadata, slots, maxWeight)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `add` · `item` · `into` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.AddItemIntoStash('example_id', 'example', 1, 'example', {}, 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.AddStashItems(id, items)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `add` · `stash` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.AddStashItems('example_id', {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.AddTrunkItems(identifier, items)`

**Contexto:** `server`  
**Descrição:** Adiciona itens ao porta-malas de um veículo persistente.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `add` · `trunk` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.AddTrunkItems('license:example', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.CanCarryAmount(inv, item)`

**Contexto:** `server`  
**Descrição:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `can` · `carry` · `amount` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CanCarryAmount(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.CanCarryItem(inv, item, count, metadata)`

**Contexto:** `server`  
**Descrição:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `can` · `carry` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CanCarryItem(source, 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.CanCarryWeight(inv, weight)`

**Contexto:** `server`  
**Descrição:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `can` · `carry` · `weight` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CanCarryWeight(source, 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)`

**Contexto:** `server`  
**Descrição:** Retorna se o inventário suporta a troca física de um item por outro em termos de peso e capacidade restante.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `can` · `swap` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CanSwapItem(source, 'example', 1, 'example', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.CheckItemValid(source, name, count)`

**Contexto:** `server`  
**Descrição:** Validação interna de segurança de transação de inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `check` · `item` · `valid` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.CheckItemValid(source, 'example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.ClearInventory(inv, keep)`

**Contexto:** `server`  
**Descrição:** Limpa todos os itens de um inventário, permitindo opcionalmente ignorar (preservar) itens informados na tabela keep.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `clear` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.ClearInventory(source, {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.ClearOtherInventory(type, id)`

**Contexto:** `server`  
**Descrição:** Limpa inventários secundários de baús.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `clear` · `other` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.ClearOtherInventory('example', 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.inventory.ClearPlayerInventory(inv, keep)`

**Contexto:** `server`  
**Descrição:** Limpa todos os itens de um inventário, permitindo opcionalmente ignorar (preservar) itens informados na tabela keep.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `clear` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.ClearPlayerInventory(source, {})
print('Resultado:', result)
```

---

### `pr_lib.inventory.ClearStash(id)`

**Contexto:** `server`  
**Descrição:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `clear` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.ClearStash('example_id')
print('Resultado:', result)
```

---

### `pr_lib.inventory.ConfiscateInventory(source)`

**Contexto:** `server`  
**Descrição:** Usado para apreender o inventário do jogador temporariamente e depois restaurá-lo (útil para sistemas de prisão).  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `confiscate` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.ConfiscateInventory(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.CreateDropFromPlayer(playerId)`

**Contexto:** `server`  
**Descrição:** Dropa todos os itens do inventário de um jogador no chão em um contêiner físico.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `create` · `drop` · `from` · `player` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.CreateDropFromPlayer(source)
print('Resultado:', result)
```

---

### `pr_lib.inventory.CreateTemporaryStash(properties)`

**Contexto:** `server`  
**Descrição:** Cria um baú em memória que é descartado após o encerramento do recurso ou limpeza.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `create` · `temporary` · `stash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CreateTemporaryStash({})
print('Resultado:', result)
```

---

### `pr_lib.inventory.CreateUsableItem(item, cb)`

**Contexto:** `server`  
**Descrição:** Registra lógica de ativação de itens consumíveis.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `create` · `usable` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CreateUsableItem('water', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.inventory.CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)`

**Contexto:** `server`  
**Descrição:** Cria um container de drop customizado no chão no mundo 3D.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `custom` · `drop` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.CustomDrop('example:', {}, 'example', 'example', 1, 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.forceOpenInventory(playerId, invType, data)`

**Contexto:** `server`  
**Descrição:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `force` · `open` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.inventory.forceOpenInventory(source, 'default', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.inventory.GetContainerFromSlot(inv, slotId)`

**Contexto:** `server`  
**Descrição:** Retorna dados de sub-recipientes/mochilas carregados no slot de inventário.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `container` · `from` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetContainerFromSlot(source, 'example')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetCurrentWeapon(inv)`

**Contexto:** `server`  
**Descrição:** Retorna os dados da arma equipada ativa de um inventário de jogador.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `current` · `weapon` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetCurrentWeapon(source)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetEmptySlot(inv)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `empty` · `slot` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetEmptySlot(source)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetImagePath(item)`

**Contexto:** `server`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `image` · `path` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetImagePath('water')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetInventory(inv, owner)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetInventory(source, 'my_resource')
print('Resultado:', result)
```

---

### `pr_lib.inventory.getInventoryImg(image)`

**Contexto:** `server`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `img` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.getInventoryImg('example.png')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetInventoryImg(image)`

**Contexto:** `server`  
**Descrição:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `img` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetInventoryImg('example.png')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetInventoryItems(inv, owner)`

**Contexto:** `server`  
**Descrição:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `items` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetInventoryItems(source, 'my_resource')
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItem(inv, item, metadata, returnsCount)`

**Contexto:** `server`  
**Descrição:** Busca os dados detalhados e integridade de um item pelo seu nome ou chave.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItem(source, 'example', {}, 1)
print('Resultado:', result)
```

---

### `pr_lib.inventory.GetItemByName(inv, item, metadata, returnsCount)`

**Contexto:** `server`  
**Descrição:** Busca os dados detalhados e integridade de um item pelo seu nome ou chave.  
**Arquivo de origem:** [`bridge/inventory_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/inventory_normalizer.lua)  
**Tags:** `inventory` · `get` · `item` · `by` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.inventory.GetItemByName(source, 'example', {}, 1)
print('Resultado:', result)
```

---

