# PR Bridge 1.4.8 — Catálogo de funções (volume 6/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**208 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## progression.lua

### `PRProgression.packet(session)`

**Contexto:** `shared`  
**Descrição:** Cria snapshot { token, revision, values, ack } com cópias defensivas.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `packet`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.packet({})
print('Resultado:', result)
```

---

### `PRProgression.receive(client, packet, maximum)`

**Contexto:** `shared`  
**Descrição:** Recebe snapshot, rejeita revisão antiga e reaplica alterações locais ainda não reconhecidas. maximum(name) informa o limite de cada atributo.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `receive`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.receive('example', 'example', 100)
print('Resultado:', result)
```

---

### `PRProgression.round(value)`

**Contexto:** `shared`  
**Descrição:** Arredonda número em quatro casas decimais.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `round`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.round({})
print('Retorno da operação:', result)
```

---

### `PRProgression.session(values, token, now)`

**Contexto:** `shared`  
**Descrição:** Cria ledger do servidor com cópia de valores, token único, budgets, ack e revisão inicial.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `session`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.session({}, 'example', GetGameTimer())
print('Resultado:', result)
```

---

### `PRProgression.snapshot(client)`

**Contexto:** `shared`  
**Descrição:** Retorna { token, counters } ou nil quando não há sessão carregada.  
**Arquivo de origem:** [`shared/progression.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/shared/progression.lua)  
**Tags:** `progression.lua` · `shared` · `progressão: utilitário compartilhado opt-in` · `snapshot`

**Exemplo de construção e uso:**

```lua
local result = PRProgression.snapshot('example')
print('Resultado:', result)
```

---

## radial

### `pr_lib.addRadialItem(items, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Adiciona um ou vários itens ao menu radial raiz ou a um submenu registrado. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addRadialItem({}, 'main_menu')
print('Resultado:', result)
```

---

### `pr_lib.clearRadialItems()`

**Contexto:** `client`  
**Descrição:** Limpa itens e submenus radiais pertencentes ao resource e fecha a interface ativa. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.clearRadialItems()
print('Retorno da operação:', result)
```

---

### `pr_lib.disableRadial(state)`

**Contexto:** `client`  
**Descrição:** Bloqueia/desbloqueia a abertura do menu radial; ao desativar, fecha qualquer menu aberto. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.disableRadial(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.getCurrentRadialId()`

**Contexto:** `client`  
**Descrição:** Retorna o id do submenu radial atualmente aberto via LocalPlayer.state. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getCurrentRadialId()
print('Resultado:', result)
```

---

### `pr_lib.hideRadial()`

**Contexto:** `client`  
**Descrição:** Fecha o menu radial atual e libera o foco NUI. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.hideRadial()
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.addRadialItem(items, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.AddRadialItem.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.addRadialItem({}, 'main_menu')
print('Resultado:', result)
```

---

### `pr_lib.interface.AddRadialItem(items, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Adiciona um ou vários itens ao menu radial raiz ou a um submenu registrado.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.AddRadialItem({}, 'main_menu')
print('Resultado:', result)
```

---

### `pr_lib.interface.clearRadialItems()`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.ClearRadialItems.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.clearRadialItems()
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.ClearRadialItems()`

**Contexto:** `client`  
**Descrição:** Limpa itens e submenus radiais pertencentes ao resource e fecha a interface ativa.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.ClearRadialItems()
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.disableRadial(state)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.DisableRadial.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.disableRadial(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.DisableRadial(state)`

**Contexto:** `client`  
**Descrição:** Bloqueia/desbloqueia a abertura do menu radial; ao desativar, fecha qualquer menu aberto.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.DisableRadial(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.getCurrentRadialId()`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.GetCurrentRadialId.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.getCurrentRadialId()
print('Resultado:', result)
```

---

### `pr_lib.interface.GetCurrentRadialId()`

**Contexto:** `client`  
**Descrição:** Retorna o id do submenu radial atualmente aberto via LocalPlayer.state.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.GetCurrentRadialId()
print('Resultado:', result)
```

---

### `pr_lib.interface.hideRadial()`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.HideRadial.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.hideRadial()
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.HideRadial()`

**Contexto:** `client`  
**Descrição:** Fecha o menu radial atual e libera o foco NUI.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.HideRadial()
print('Retorno da operação:', result)
```

---

### `pr_lib.interface.registerRadial(data)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.RegisterRadial.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.registerRadial({})
print('Resultado:', result)
```

---

### `pr_lib.interface.RegisterRadial(data)`

**Contexto:** `client`  
**Descrição:** Registra um submenu radial identificado por id e uma lista de items.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.RegisterRadial({})
print('Resultado:', result)
```

---

### `pr_lib.interface.removeRadialItem(id, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Alias lowercase de pr_lib.interface.RemoveRadialItem.  
**Arquivo de origem:** [`interface/client/ui.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/ui.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.removeRadialItem('example_id', 'main_menu')
print('Resultado:', result)
```

---

### `pr_lib.interface.RemoveRadialItem(id, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Remove um item radial pelo id no menu raiz ou submenu informado.  
**Arquivo de origem:** [`interface/client/modules/radial.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/radial.lua)  
**Tags:** `radial` · `interface` · `nui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.interface.RemoveRadialItem('example_id', 'main_menu')
print('Resultado:', result)
```

---

### `pr_lib.registerRadial(data)`

**Contexto:** `client`  
**Descrição:** Registra um submenu radial identificado por id e uma lista de items. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.registerRadial({})
print('Resultado:', result)
```

---

### `pr_lib.removeRadialItem(id, parentMenuId)`

**Contexto:** `client`  
**Descrição:** Remove um item radial pelo id no menu raiz ou submenu informado. Alias de conveniência no namespace raiz.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `radial` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.removeRadialItem('example_id', 'main_menu')
print('Resultado:', result)
```

---

## recordJsonIncident

### `pr_lib.recordJsonIncident(path, key, details)`

**Contexto:** `server`  
**Descrição:** Registra diagnóstico excepcional em path .. ".incidents.json", utilizando recuperação JSON; retorna sucesso/motivo e não envia dados financeiros aos clientes.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `recordJsonIncident` · `server` · `persistência json protegida` · `record` · `json` · `incident`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.recordJsonIncident('@my_resource/data/config.json', 'example_key', {})
print('Retorno da operação:', result)
```

---

## saveJsonBatch

### `pr_lib.saveJsonBatch(changes)`

**Contexto:** `server`  
**Descrição:** Recebe tabela path→value, trava os arquivos em ordem e tenta restaurar os anteriores se uma gravação posterior falhar. Retorna false, "reconciliation_required" se a restauração falhar. Não é transação de banco.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `saveJsonBatch` · `server` · `persistência json protegida` · `save` · `json` · `batch`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.saveJsonBatch({})
print('Retorno da operação:', result)
```

---

## saveJsonRecovery

### `pr_lib.saveJsonRecovery(path, value, options?)`

**Contexto:** `server`  
**Descrição:** Salva com lock, validação de JSON e backup. options.backup="on_failure" reduz backups em rotinas frequentes. Retorna sucesso e detalhes ou false e motivo. Não promete gravação atômica contra queda de energia.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `saveJsonRecovery` · `server` · `persistência json protegida` · `save` · `json` · `recovery`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.saveJsonRecovery('@my_resource/data/config.json', {}, {})
print('Retorno da operação:', result)
```

---

## setInterval

### `pr_lib.setInterval(callback, interval?, ...)`

**Contexto:** `client/server`  
**Descrição:** Cria intervalo local e retorna id; se callback for id numérico, altera atraso do intervalo existente. Pausa entre execuções e encerra no recurso.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `setInterval` · `client/server` · `entradas públicas antes ausentes do índice` · `set` · `interval`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.setInterval(function(value) print('Callback:', value) end, 1000)
print('Resultado:', result)
```

---

## settings

### `pr_lib.settings.get(domain, fallback?)`

**Contexto:** `client/server`  
**Descrição:** Retorna dados locais de locale ou interface, ou fallback. A tabela é referência interna somente para leitura; consumidores externos devem preferir cache.GetResourceState.  
**Arquivo de origem:** [`bridge/settings.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/settings.lua)  
**Tags:** `settings` · `client/server` · `configuração global em memória` · `get`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.settings.get('status')
print('Resultado:', result)
```

---

### `pr_lib.settings.snapshot(domain)`

**Contexto:** `client/server`  
**Descrição:** Retorna cópia defensiva do registro completo { epoch, revision, data } ou nil.  
**Arquivo de origem:** [`bridge/settings.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/settings.lua)  
**Tags:** `settings` · `client/server` · `configuração global em memória` · `snapshot`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.settings.snapshot('status')
print('Resultado:', result)
```

---

### `pr_lib.settings.publish(domain, data)`

**Contexto:** `server`  
**Descrição:** Publica locale ou interface com revisão/geração, atualiza cache e envia mudança aos clientes. Não existe no objeto settings de recursos consumidores; não substitui validação administrativa nem persistência.  
**Arquivo de origem:** [`bridge/settings.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/settings.lua)  
**Tags:** `settings` · `server` · `publicação de configuração global` · `publish`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.settings.publish('status', {})
print('Resultado:', result)
```

---

## string

### `pr_lib.string.random(pattern, length?)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “random” por meio da API pública do módulo `string`.  
**Arquivo de origem:** [`bridge/utils/strings.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/strings.lua)  
**Tags:** `string` · `random` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.string.random('AAA-111')
print('Resultado:', result)
```

---

## table

### `pr_lib.table.clone(value, seen)`

**Contexto:** `shared`  
**Descrição:** Gera uma cópia profunda (deep copy) de tabelas e metatabelas.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `clone` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.clone({}, {})
print('Resultado:', result)
```

---

### `pr_lib.table.contains(source, value)`

**Contexto:** `shared`  
**Descrição:** Verifica se a tabela possui determinado valor entre seus elementos indexados.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `contains` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.contains(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.table.Contains(source, value)`

**Contexto:** `shared`  
**Descrição:** Verifica se a tabela possui determinado valor entre seus elementos indexados.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `contains` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Contains(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.table.count(source)`

**Contexto:** `shared`  
**Descrição:** Conta o número absoluto de elementos em uma tabela (incluindo chaves associativas não numéricas).  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `count` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.count(source)
print('Resultado:', result)
```

---

### `pr_lib.table.Count(source)`

**Contexto:** `shared`  
**Descrição:** Conta o número absoluto de elementos em uma tabela (incluindo chaves associativas não numéricas).  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `count` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Count(source)
print('Resultado:', result)
```

---

### `pr_lib.table.DeepClone(value, seen)`

**Contexto:** `shared`  
**Descrição:** Gera uma cópia profunda (deep copy) de tabelas e metatabelas.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `deep` · `clone` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.DeepClone({}, {})
print('Resultado:', result)
```

---

### `pr_lib.table.freeze(value)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “freeze” por meio da API pública do módulo `table`.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `freeze` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.freeze({})
print('Retorno da operação:', result)
```

---

### `pr_lib.table.isfrozen(value)`

**Contexto:** `shared`  
**Descrição:** Verifica os dados ou a operação “isfrozen” e retorna o estado correspondente.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `isfrozen` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.isfrozen({})
print('Resultado:', result)
```

---

### `pr_lib.table.map(source, callback)`

**Contexto:** `shared`  
**Descrição:** Executa a projeção e mapeamento de chaves e valores a partir da execução do callback.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `map` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.map(source, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.table.Map(source, callback)`

**Contexto:** `shared`  
**Descrição:** Executa a projeção e mapeamento de chaves e valores a partir da execução do callback.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `map` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Map(source, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.table.matches(left, right)`

**Contexto:** `shared`  
**Descrição:** Compara recursivamente se duas tabelas possuem conteúdo exatamente idêntico.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `matches` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.matches(0, 100)
print('Resultado:', result)
```

---

### `pr_lib.table.Matches(left, right)`

**Contexto:** `shared`  
**Descrição:** Compara recursivamente se duas tabelas possuem conteúdo exatamente idêntico.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `matches` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Matches(0, 100)
print('Resultado:', result)
```

---

### `pr_lib.table.merge(target, source, override)`

**Contexto:** `shared`  
**Descrição:** Combina elementos de uma tabela de origem em uma tabela de destino.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `merge` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.merge(source, source, {})
print('Resultado:', result)
```

---

### `pr_lib.table.Merge(target, source, override)`

**Contexto:** `shared`  
**Descrição:** Combina elementos de uma tabela de origem em uma tabela de destino.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `merge` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Merge(source, source, {})
print('Resultado:', result)
```

---

### `pr_lib.table.shuffle(source, copy, random)`

**Contexto:** `shared`  
**Descrição:** Embaralha aleatoriamente a ordem dos elementos numéricos indexados da tabela.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `shuffle` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.shuffle(source, false, false)
print('Resultado:', result)
```

---

### `pr_lib.table.Shuffle(source, copy, random)`

**Contexto:** `shared`  
**Descrição:** Embaralha aleatoriamente a ordem dos elementos numéricos indexados da tabela.  
**Arquivo de origem:** [`bridge/utils/tables.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/tables.lua)  
**Tags:** `table` · `shuffle` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.table.Shuffle(source, false, false)
print('Resultado:', result)
```

---

## target

### `pr_lib.target.AddBoxZone(name, coords, size, rotation, options, debug)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação retangular tridimensional invisível (ou com renderização em debug) no mapa.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `box` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddBoxZone('example', 'example', 1, 1, {}, 'example')
print('Resultado:', result)
```

---

### `pr_lib.target.addBoxZone(parameters)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação retangular tridimensional invisível (ou com renderização em debug) no mapa.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `box` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addBoxZone({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addEntity(netIds, options)`

**Contexto:** `client`  
**Descrição:** Registra opções de interação via menu de alvo (olho/olhar) para uma entidade de rede (veículo, ped, objeto) baseada em sua ID de rede.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addEntity({ 1, 2 }, {})
print('Resultado:', result)
```

---

### `pr_lib.target.AddEntity(netIds, options)`

**Contexto:** `client`  
**Descrição:** Registra opções de interação via menu de alvo (olho/olhar) para uma entidade de rede (veículo, ped, objeto) baseada em sua ID de rede.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddEntity({ 1, 2 }, {})
print('Resultado:', result)
```

---

### `pr_lib.target.addGlobalObject(options)`

**Contexto:** `client`  
**Descrição:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `object` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalObject({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddGlobalObject(options)`

**Contexto:** `client`  
**Descrição:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `object` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalObject({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addGlobalOption(options)`

**Contexto:** `client`  
**Descrição:** Opções universais que se aplicam a qualquer elemento do mundo 3D focado pelo target.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `option` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalOption({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addGlobalPed(options)`

**Contexto:** `client`  
**Descrição:** Registra opções aplicadas a todos os peds (NPCs) do jogo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `ped` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalPed({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddGlobalPed(options)`

**Contexto:** `client`  
**Descrição:** Registra opções aplicadas a todos os peds (NPCs) do jogo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `ped` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalPed({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addGlobalPickup(options)`

**Contexto:** `client`  
**Descrição:** Registra opções globais que podem ser exibidas para pickups detectados pelo target nativo.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalPickup({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddGlobalPickup(options)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.addGlobalPickup.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalPickup({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addGlobalPlayer(options)`

**Contexto:** `client`  
**Descrição:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `player` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalPlayer({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddGlobalPlayer(options)`

**Contexto:** `client`  
**Descrição:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `player` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalPlayer({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addGlobalVehicle(options)`

**Contexto:** `client`  
**Descrição:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `vehicle` · `client` · `alvo` · `interação` · `zona` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addGlobalVehicle({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddGlobalVehicle(options)`

**Contexto:** `client`  
**Descrição:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `vehicle` · `client` · `alvo` · `interação` · `zona` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalVehicle({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addLocalEntity(entities, options)`

**Contexto:** `client`  
**Descrição:** Cria interações de alvo para entidades locais criadas unicamente no cliente.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `local` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addLocalEntity({}, {})
print('Resultado:', result)
```

---

### `pr_lib.target.AddLocalEntity(entities, options)`

**Contexto:** `client`  
**Descrição:** Cria interações de alvo para entidades locais criadas unicamente no cliente.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `local` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddLocalEntity({}, {})
print('Resultado:', result)
```

---

### `pr_lib.target.addModel(models, options)`

**Contexto:** `client`  
**Descrição:** Registra interações que estarão ativas globalmente para todos os objetos, peds ou veículos criados que utilizem o modelo 3D (hash/name) especificado (ex: lixeiras, hidrantes).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `model` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addModel('prop_ld_flow_bottle', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddModel(models, options)`

**Contexto:** `client`  
**Descrição:** Registra interações que estarão ativas globalmente para todos os objetos, peds ou veículos criados que utilizem o modelo 3D (hash/name) especificado (ex: lixeiras, hidrantes).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `model` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddModel('prop_ld_flow_bottle', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addPickup(pickups, options)`

**Contexto:** `client`  
**Descrição:** Registra opções em pickups específicos, normalizando handles/descriptors.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addPickup({}, {})
print('Resultado:', result)
```

---

### `pr_lib.target.AddPickup(pickups, options)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.addPickup.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddPickup({}, {})
print('Resultado:', result)
```

---

### `pr_lib.target.addPickupType(pickupTypes, options)`

**Contexto:** `client`  
**Descrição:** Registra opções por hash/tipo de pickup.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addPickupType('default', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddPickupType(pickupTypes, options)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.addPickupType.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddPickupType('default', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddPolyZone(name, points, thickness, options, debug)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação poligonal complexa contornando uma área.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `poly` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddPolyZone('example', 'example', 'example', {}, 'example')
print('Resultado:', result)
```

---

### `pr_lib.target.addPolyZone(parameters)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação poligonal complexa contornando uma área.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `poly` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addPolyZone({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.AddSphereZone(name, coords, radius, options, debug)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação esférica em coordenadas 3D.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `sphere` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddSphereZone('example:action', vector3(0.0, 0.0, 0.0), 1, {}, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.target.addSphereZone(parameters)`

**Contexto:** `client`  
**Descrição:** Cria uma zona de interação esférica em coordenadas 3D.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `sphere` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.addSphereZone({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.disableTargeting(state)`

**Contexto:** `client`  
**Descrição:** Ativa ou desativa temporariamente a possibilidade do jogador usar a tecla do target.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `disable` · `targeting` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.disableTargeting(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.target.DisableTargeting(state)`

**Contexto:** `client`  
**Descrição:** Ativa ou desativa temporariamente a possibilidade do jogador usar a tecla do target.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `disable` · `targeting` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.DisableTargeting(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.target.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Nome do recurso de target ativo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `get` · `resource` · `name` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.target.inspectModels(models)`

**Contexto:** `client`  
**Descrição:** Inspeciona e normaliza uma lista de modelos para uso no target nativo.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.inspectModels('prop_ld_flow_bottle')
print('Retorno da operação:', result)
```

---

### `pr_lib.target.InspectModels(models)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.inspectModels.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.InspectModels('prop_ld_flow_bottle')
print('Retorno da operação:', result)
```

---

### `pr_lib.target.removeEntity(netIds, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove opções específicas registradas na entidade de rede.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeEntity({ 1, 2 }, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveEntity(netIds, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove opções específicas registradas na entidade de rede.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveEntity({ 1, 2 }, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalObject(optionNames)`

**Contexto:** `client`  
**Descrição:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `object` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalObject({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalObject(optionNames)`

**Contexto:** `client`  
**Descrição:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `object` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalObject({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalOption(optionNames)`

**Contexto:** `client`  
**Descrição:** Opções universais que se aplicam a qualquer elemento do mundo 3D focado pelo target.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `option` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalOption({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalPed(optionNames)`

**Contexto:** `client`  
**Descrição:** Registra opções aplicadas a todos os peds (NPCs) do jogo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `ped` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalPed({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalPed(optionNames)`

**Contexto:** `client`  
**Descrição:** Registra opções aplicadas a todos os peds (NPCs) do jogo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `ped` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalPed({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalPickup(names)`

**Contexto:** `client`  
**Descrição:** Remove opções globais de pickup pelos nomes, dentro do registro do consumidor. Alias RemoveGlobalPickup.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalPickup({ 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalPickup(names)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.removeGlobalPickup.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalPickup({ 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalPlayer(optionNames)`

**Contexto:** `client`  
**Descrição:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `player` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalPlayer({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalPlayer(optionNames)`

**Contexto:** `client`  
**Descrição:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `player` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalPlayer({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeGlobalVehicle(optionNames)`

**Contexto:** `client`  
**Descrição:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `vehicle` · `client` · `alvo` · `interação` · `zona` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeGlobalVehicle({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalVehicle(optionNames)`

**Contexto:** `client`  
**Descrição:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `vehicle` · `client` · `alvo` · `interação` · `zona` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalVehicle({ 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeLocalEntity(entities, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove interações da entidade local.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `local` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeLocalEntity({}, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveLocalEntity(entities, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove interações da entidade local.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `local` · `entity` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveLocalEntity({}, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeModel(models, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove opções do modelo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `model` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeModel({ 'prop_ld_flow_bottle' }, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveModel(models, optionNames)`

**Contexto:** `client`  
**Descrição:** Remove opções do modelo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `model` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveModel({ 'prop_ld_flow_bottle' }, { 'open', 'close' })
print('Resultado:', result)
```

---

### `pr_lib.target.removePickup(pickups, names)`

**Contexto:** `client`  
**Descrição:** Remove opções e libera rastreamento quando não há mais opções desse registro. Alias RemovePickup.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removePickup({}, { 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemovePickup(pickups, names)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.removePickup.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemovePickup({}, { 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.removePickupType(pickupTypes, names)`

**Contexto:** `client`  
**Descrição:** Remove opções associadas aos tipos de pickup informados.  
**Arquivo de origem:** [`bridge/targets/native/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/native/client.lua)  
**Tags:** `target` · `pickup` · `native` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removePickupType({ 'pickup' }, { 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.RemovePickupType(pickupTypes, names)`

**Contexto:** `client`  
**Descrição:** Alias normalizado de pr_lib.target.removePickupType.  
**Arquivo de origem:** [`bridge/api_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/api_normalizer.lua)  
**Tags:** `target` · `alias` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemovePickupType({ 'pickup' }, { 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.removeZone(id)`

**Contexto:** `client`  
**Descrição:** Remove do sistema de alvos a zona de interação correspondente à ID informada.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.removeZone('example_id')
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveZone(id)`

**Contexto:** `client`  
**Descrição:** Remove do sistema de alvos a zona de interação correspondente à ID informada.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `zone` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveZone('example_id')
print('Resultado:', result)
```

---

### `pr_lib.target.AddGlobalOption(options)`

**Contexto:** `shared`  
**Descrição:** registra opções universais.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `add` · `global` · `option` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.AddGlobalOption({})
print('Retorno da operação:', result)
```

---

### `pr_lib.target.GetTargetOptions(...)`

**Contexto:** `shared`  
**Descrição:** retorna as coleções aplicáveis ao alvo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `get` · `options` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.GetTargetOptions()
print('Resultado:', result)
```

---

### `pr_lib.target.getTargetOptions(entity, entityType, model)`

**Contexto:** `shared`  
**Descrição:** retorna as coleções aplicáveis ao alvo.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `get` · `options` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.getTargetOptions(PlayerPedId(), PlayerPedId(), 'prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.target.isActive()`

**Contexto:** `shared`  
**Descrição:** informa se o target está ativo no cliente.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `is` · `active` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.isActive()
print('Resultado:', result)
```

---

### `pr_lib.target.IsActive()`

**Contexto:** `shared`  
**Descrição:** informa se o target está ativo no cliente.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `is` · `active` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.IsActive()
print('Resultado:', result)
```

---

### `pr_lib.target.RemoveGlobalOption(names)`

**Contexto:** `shared`  
**Descrição:** remove opções universais do recurso chamador. As opções aceitam filtros groups, items, bones, offset, canInteract, menus menuName/openMenu e ações onSelect/export/event/serverEvent/command. O detalhamento arquitetural, configuração visual e compatibilidade qtarget estão em docs/TARGET_NATIVE.md.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `remove` · `global` · `option` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.RemoveGlobalOption({ 'example' })
print('Resultado:', result)
```

---

### `pr_lib.target.zoneExists(id)`

**Contexto:** `shared`  
**Descrição:** verifica uma zona por ID ou nome.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `zone` · `exists` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.zoneExists('example_id')
print('Resultado:', result)
```

---

### `pr_lib.target.ZoneExists(id)`

**Contexto:** `shared`  
**Descrição:** verifica uma zona por ID ou nome.  
**Arquivo de origem:** [`bridge/targets/`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/targets/)  
**Tags:** `target` · `zone` · `exists` · `shared` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.target.ZoneExists('example_id')
print('Resultado:', result)
```

---

## textui_adapter

### `pr_lib.hideTextUI()`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `hide` · `text` · `ui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.hideTextUI()
print('Retorno da operação:', result)
```

---

### `pr_lib.isTextUIOpen()`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `is` · `text` · `uiopen` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.isTextUIOpen()
print('Resultado:', result)
```

---

### `pr_lib.showTextUI(text, options)`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `show` · `text` · `ui` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.showTextUI('Exemplo do PR Bridge', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.textuiBridge.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o recurso ativo de TextUI.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `bridge` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.textuiBridge.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.textuiBridge.hide()`

**Contexto:** `client`  
**Descrição:** Esconde o painel TextUI ativo.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `bridge` · `hide` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.textuiBridge.hide()
print('Retorno da operação:', result)
```

---

### `pr_lib.textuiBridge.Hide()`

**Contexto:** `client`  
**Descrição:** Esconde o painel TextUI ativo.  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `bridge` · `hide` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.textuiBridge.Hide()
print('Retorno da operação:', result)
```

---

### `pr_lib.textuiBridge.show(text)`

**Contexto:** `client`  
**Descrição:** Mostra um painel flutuante de texto na tela (geralmente no canto superior esquerdo ou centralizado).  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `bridge` · `show` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.textuiBridge.show('Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.textuiBridge.Show(text)`

**Contexto:** `client`  
**Descrição:** Mostra um painel flutuante de texto na tela (geralmente no canto superior esquerdo ou centralizado).  
**Arquivo de origem:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`  
**Tags:** `textui` · `adapter` · `bridge` · `show` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.textuiBridge.Show('Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

## timer

### `pr_lib.clearInterval(id)`

**Contexto:** `shared`  
**Descrição:** Cancela um intervalo criado por pr_lib.setInterval.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.clearInterval('example_id')
print('Resultado:', result)
```

---

### `pr_lib.setInterval(callback, interval, ...)`

**Contexto:** `shared`  
**Descrição:** Cria um intervalo recorrente e retorna seu identificador.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.setInterval(function(value) print('Callback:', value) end, 1000)
print('Resultado:', result)
```

---

### `pr_lib.timer(duration, onEnd?, async?)`

**Contexto:** `shared/client/server`  
**Descrição:** Executa os dados ou a operação “timer” por meio da API pública do módulo `utilitários_compartilhados`.  
**Arquivo de origem:** [`bridge/utils/timer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/timer.lua)  
**Tags:** `timer` · `shared/client/server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.timer(1, function(value) print('Callback:', value) end, false)
print('Retorno da operação:', result)
```

---

## translator

### `pr_lib.translator.showTranslatedNotify(title, description, notifyType, targetLang)`

**Contexto:** `client`  
**Descrição:** Traduz e exibe imediatamente um alerta de notificação com título e descrição localizados.  
**Arquivo de origem:** [`bridge/translator/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/client.lua)  
**Tags:** `translator` · `show` · `translated` · `notify` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.showTranslatedNotify('example', 'example', 'inform', 'en')
print('Resultado:', result)
```

---

### `pr_lib.translator.translate(text, targetLang)`

**Contexto:** `client`  
**Descrição:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.  
**Arquivo de origem:** [`bridge/translator/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/client.lua)  
**Tags:** `translator` · `translate` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translate(1, 'en')
print('Resultado:', result)
```

---

### `pr_lib.translator.translateBatch(strings, targetLang)`

**Contexto:** `client`  
**Descrição:** Executa a tradução em lote de uma lista de strings de forma otimizada paralelamente para minimizar latência.  
**Arquivo de origem:** [`bridge/translator/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/client.lua)  
**Tags:** `translator` · `translate` · `batch` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translateBatch({}, 'en')
print('Resultado:', result)
```

---

### `pr_lib.translator.translateMenu(menuData, targetLang)`

**Contexto:** `client`  
**Descrição:** Varre e traduz automaticamente todas as propriedades de título, descrição e opções de um objeto de menu (compatível com a estrutura de ox_lib menus) de forma dinâmica para a localidade do jogador antes de sua renderização.  
**Arquivo de origem:** [`bridge/translator/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/client.lua)  
**Tags:** `translator` · `translate` · `menu` · `client` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translateMenu({}, 'en')
print('Resultado:', result)
```

---

### `pr_lib.translator.translateText(text, targetLang)`

**Contexto:** `client`  
**Descrição:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.  
**Arquivo de origem:** [`bridge/translator/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/client.lua)  
**Tags:** `translator` · `translate` · `text` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translateText(1, 'en')
print('Resultado:', result)
```

---

### `pr_lib.translator.translate(text, targetLang, cb)`

**Contexto:** `server`  
**Descrição:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.  
**Arquivo de origem:** [`bridge/translator/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/server.lua)  
**Tags:** `translator` · `translate` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translate(1, 'en', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.translator.translateBatch(strings, targetLang, cb)`

**Contexto:** `server`  
**Descrição:** Executa a tradução em lote de uma lista de strings de forma otimizada paralelamente para minimizar latência.  
**Arquivo de origem:** [`bridge/translator/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/server.lua)  
**Tags:** `translator` · `translate` · `batch` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translateBatch({}, 'en', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.translator.translateText(text, targetLang, cb)`

**Contexto:** `server`  
**Descrição:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.  
**Arquivo de origem:** [`bridge/translator/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/translator/server.lua)  
**Tags:** `translator` · `translate` · `text` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.translator.translateText(1, 'en', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

## utils

### `pr_lib.utils.deepCopy(value, seen)`

**Contexto:** `shared`  
**Descrição:** Clona profundamente uma tabela Lua recursivamente, incluindo metatabelas e evitando referências circulares.  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `deep` · `copy` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.deepCopy({}, {})
print('Resultado:', result)
```

---

### `pr_lib.utils.dumpTable(value, depth, seen)`

**Contexto:** `shared`  
**Descrição:** Serializa uma tabela complexa em formato legível de texto para console (dump de depuração).  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `dump` · `table` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.dumpTable({}, 2, {})
print('Resultado:', result)
```

---

### `pr_lib.utils.ensureTable(value)`

**Contexto:** `shared`  
**Descrição:** Garante que o retorno seja sempre uma tabela Lua (caso seja nulo ou string, encapsula/converte).  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `ensure` · `table` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.ensureTable({})
print('Retorno da operação:', result)
```

---

### `pr_lib.utils.firstToUpper(value)`

**Contexto:** `shared`  
**Descrição:** Converte a primeira letra da string em maiúscula.  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `first` · `to` · `upper` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.firstToUpper({})
print('Retorno da operação:', result)
```

---

### `pr_lib.utils.hash(value)`

**Contexto:** `shared`  
**Descrição:** Converte uma string em um hash numérico nativo do GTA V (equivalente ao hash do Jenkins One-at-a-time).  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `hash` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.hash({})
print('Resultado:', result)
```

---

### `pr_lib.utils.round(value, decimals)`

**Contexto:** `shared`  
**Descrição:** Arredonda um número de ponto flutuante para a quantidade de casas decimais informada.  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `round` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.round({}, 2)
print('Resultado:', result)
```

---

### `pr_lib.utils.trim(value)`

**Contexto:** `shared`  
**Descrição:** Remove espaços em branco do início e do fim de uma string.  
**Arquivo de origem:** [`bridge/utils/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/utils/shared.lua)  
**Tags:** `utils` · `trim` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.utils.trim({})
print('Retorno da operação:', result)
```

---

## vehicle_key

### `pr_lib.vehicle_key.GetAllKeys(target)`

**Contexto:** `client`  
**Descrição:** Retorna a lista completa de placas de veículos das quais o jogador tem chaves guardadas.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `get` · `all` · `keys` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GetAllKeys(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Script de chaves ativo localmente.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `get` · `resource` · `name` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.GiveKey(plate)`

**Contexto:** `client`  
**Descrição:** Concede chaves permanentes ou temporárias de um veículo para o jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `give` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GiveKey('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GiveKeyItem(plate, vehicle)`

**Contexto:** `client`  
**Descrição:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `give` · `item` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GiveKeyItem('ABC1234', PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GiveKeyMenu(plate)`

**Contexto:** `client`  
**Descrição:** Abre o menu para emprestar ou entregar a chave do veículo correspondente à placa para o jogador mais próximo.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `give` · `menu` · `client` · `veículo` · `carro` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GiveKeyMenu('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GiveKeys(vehicle, plate)`

**Contexto:** `client`  
**Descrição:** Registra a chave localmente no chaveiro do veículo.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `give` · `keys` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GiveKeys(PlayerPedId(), 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GiveTempKeys(plate)`

**Contexto:** `client`  
**Descrição:** Concede chaves permanentes ou temporárias de um veículo para o jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `give` · `temp` · `keys` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.GiveTempKeys('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.HasKey(plate)`

**Contexto:** `client`  
**Descrição:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `has` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.HasKey('ABC1234')
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.HavePermanentKey(plate)`

**Contexto:** `client`  
**Descrição:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `have` · `permanent` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.HavePermanentKey('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.HaveTemporaryKey(plate)`

**Contexto:** `client`  
**Descrição:** Retorna se o jogador tem uma chave temporária/alugada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `have` · `temporary` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.HaveTemporaryKey('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.ManageKeysMenu()`

**Contexto:** `client`  
**Descrição:** Exibe o menu de chaveiro contendo todas as chaves do jogador para controle e exclusões.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `manage` · `keys` · `menu` · `client` · `veículo` · `carro` · `contexto` · `nui` · `interface`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.ManageKeysMenu()
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveKey(plate)`

**Contexto:** `client`  
**Descrição:** Revoga e retira a posse de chaves.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `remove` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.RemoveKey('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveKeyItem(plate)`

**Contexto:** `client`  
**Descrição:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `remove` · `item` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.RemoveKeyItem('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveKeys(vehicle, plate)`

**Contexto:** `client`  
**Descrição:** Remove as chaves locais do veículo.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `remove` · `keys` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.RemoveKeys(PlayerPedId(), 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveTempKeys(plate)`

**Contexto:** `client`  
**Descrição:** Revoga e retira a posse de chaves.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `remove` · `temp` · `keys` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.RemoveTempKeys('ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.ToggleLock()`

**Contexto:** `client`  
**Descrição:** Executa a ação local de chaveamento física do veículo (trancar/destrancar porta, tocar alarme e piscar setas).  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/client.lua`  
**Tags:** `vehicle` · `key` · `toggle` · `lock` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicle_key.ToggleLock()
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GetAllKeys(source)`

**Contexto:** `server`  
**Descrição:** Retorna a lista completa de placas de veículos das quais o jogador tem chaves guardadas.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `get` · `all` · `keys` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.GetAllKeys(source)
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.GiveKey(source, plate)`

**Contexto:** `server`  
**Descrição:** Concede chaves permanentes ou temporárias de um veículo para o jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `give` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.GiveKey(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.GiveKeyItem(source, plate, netId)`

**Contexto:** `server`  
**Descrição:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `give` · `item` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.GiveKeyItem(source, 'example', 0)
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.GiveTempKeys(source, plate)`

**Contexto:** `server`  
**Descrição:** Concede chaves permanentes ou temporárias de um veículo para o jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `give` · `temp` · `keys` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.GiveTempKeys(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.HasKey(source, plate)`

**Contexto:** `server`  
**Descrição:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `has` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.HasKey(source, 'ABC1234')
print('Resultado:', result)
```

---

### `pr_lib.vehicle_key.HavePermanentKey(source, plate)`

**Contexto:** `server`  
**Descrição:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `have` · `permanent` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.HavePermanentKey(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.HaveTemporaryKey(source, plate)`

**Contexto:** `server`  
**Descrição:** Retorna se o jogador tem uma chave temporária/alugada.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `have` · `temporary` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.HaveTemporaryKey(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveKey(source, plate)`

**Contexto:** `server`  
**Descrição:** Revoga e retira a posse de chaves.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `remove` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.RemoveKey(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveKeyItem(source, plate)`

**Contexto:** `server`  
**Descrição:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `remove` · `item` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.RemoveKeyItem(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicle_key.RemoveTempKeys(source, plate)`

**Contexto:** `server`  
**Descrição:** Revoga e retira a posse de chaves.  
**Arquivo de origem:** `pr_bridge/bridge/vehicle_key/*/server.lua`  
**Tags:** `vehicle` · `key` · `remove` · `temp` · `keys` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.vehicle_key.RemoveTempKeys(source, 'ABC1234')
print('Retorno da operação:', result)
```

---

## waitFor

### `pr_lib.waitFor(callback, message?, timeout?)`

**Contexto:** `client/server`  
**Descrição:** Consulta callback até resultado não-nil; timeout padrão 1000ms. No timeout lança message se fornecido, ou retorna false.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `waitFor` · `client/server` · `entradas públicas antes ausentes do índice` · `wait` · `for`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.waitFor(function(value) print('Callback:', value) end, 'Exemplo do PR Bridge', 1)
print('Retorno da operação:', result)
```

---

## weather

### `pr_lib.weather.GetCurrentRegion()`

**Contexto:** `client`  
**Descrição:** Consulta região atual do player no provider; retorna sucesso e resultado.  
**Arquivo de origem:** [`bridge/weather/renewed/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/client.lua)  
**Tags:** `weather` · `client` · `clima renewed: consultas no cliente` · `get` · `current` · `region`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetCurrentRegion()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetRegionalWeather()`

**Contexto:** `client`  
**Descrição:** Consulta clima da região atual pelo export GetCurrentRegionWeather; retorna sucesso e resultado.  
**Arquivo de origem:** [`bridge/weather/renewed/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/client.lua)  
**Tags:** `weather` · `client` · `clima renewed: consultas no cliente` · `get` · `regional`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetRegionalWeather()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetRegionFromCoords(coords)`

**Contexto:** `client`  
**Descrição:** Consulta a região de coordenadas específicas; retorna sucesso e resultado.  
**Arquivo de origem:** [`bridge/weather/renewed/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/client.lua)  
**Tags:** `weather` · `client` · `clima renewed: consultas no cliente` · `get` · `region` · `from` · `coords`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetRegionFromCoords(vector3(0.0, 0.0, 0.0))
print('Resultado:', result)
```

---

### `pr_lib.weather.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o recurso gerenciador de clima ativo (ex: "vSync", "cd_easytime").  
**Arquivo de origem:** `pr_bridge/bridge/weather/*/client.lua`  
**Tags:** `weather` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetSnapshot()`

**Contexto:** `client`  
**Descrição:** Consulta GetSnapshot do provider; retorna sucesso da chamada e resultado.  
**Arquivo de origem:** [`bridge/weather/renewed/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/client.lua)  
**Tags:** `weather` · `client` · `clima renewed: consultas no cliente` · `get` · `snapshot`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetSnapshot()
print('Resultado:', result)
```

---

### `pr_lib.weather.OnChange(fn)`

**Contexto:** `client`  
**Descrição:** Registra handler em pr_bridge:weather:changed e retorna handle; encerrar com RemoveEventHandler(handle). Não faz snapshot inicial.  
**Arquivo de origem:** [`bridge/weather/renewed/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/client.lua)  
**Tags:** `weather` · `client` · `clima renewed: consultas no cliente` · `on` · `change`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.OnChange(function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.ToggleSync(toggle)`

**Contexto:** `client`  
**Descrição:** Ativa ou congela a sincronização global de clima e hora locais para o jogador.  
**Arquivo de origem:** `pr_bridge/bridge/weather/*/client.lua`  
**Tags:** `weather` · `toggle` · `sync` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.ToggleSync(true)
print('Resultado:', result)
```

---

### `pr_lib.weather.AddWeatherEvent(weatherType, duration, index?)`

**Contexto:** `server`  
**Descrição:** Cria evento com duração normalizada; retorna sucesso/resultado ou false/motivo.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `server` · `clima renewed: administração no servidor` · `add` · `event`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.AddWeatherEvent('default', 1, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.addWeatherEvent(weatherType, duration, index)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.AddWeatherEvent.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.addWeatherEvent('default', 1, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.AddWeatherEvent(weatherType, duration, index)`

**Contexto:** `server`  
**Descrição:** Adiciona um evento de weather à sequência ativa.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.AddWeatherEvent('default', 1, 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.getRegionalWeather(regionId)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.GetRegionalWeather.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.getRegionalWeather(1)
print('Resultado:', result)
```

---

### `pr_lib.weather.GetRegionalWeather(regionId)`

**Contexto:** `server`  
**Descrição:** Obtém o weather de uma região específica.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetRegionalWeather(1)
print('Resultado:', result)
```

---

### `pr_lib.weather.getResourceName()`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.GetResourceName.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.getResourceName()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetResourceName()`

**Contexto:** `server`  
**Descrição:** Retorna o nome do resource de weather ativo para este adapter.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.weather.getState()`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.GetState.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.getState()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetState()`

**Contexto:** `server`  
**Descrição:** Retorna um snapshot normalizado do estado meteorológico, incluindo lista, weather atual e regiões.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetState()
print('Resultado:', result)
```

---

### `pr_lib.weather.getWeatherList()`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.GetWeatherList.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.getWeatherList()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetWeatherList()`

**Contexto:** `server`  
**Descrição:** Obtém a sequência/lista de eventos meteorológicos do provider.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetWeatherList()
print('Resultado:', result)
```

---

### `pr_lib.weather.getWeeklyForecast()`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.GetWeeklyForecast.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.getWeeklyForecast()
print('Resultado:', result)
```

---

### `pr_lib.weather.GetWeeklyForecast()`

**Contexto:** `server`  
**Descrição:** Obtém a previsão semanal exposta pelo provider.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.GetWeeklyForecast()
print('Resultado:', result)
```

---

### `pr_lib.weather.isStarted()`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.IsStarted.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.isStarted()
print('Resultado:', result)
```

---

### `pr_lib.weather.IsStarted()`

**Contexto:** `server`  
**Descrição:** Informa se o provider Renewed-Weathersync está iniciado.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.IsStarted()
print('Resultado:', result)
```

---

### `pr_lib.weather.RemoveWeatherEvent(index, match?)`

**Contexto:** `server`  
**Descrição:** Resolve evento e remove; quando não encontrado retorna true, "already_removed".  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `server` · `clima renewed: administração no servidor` · `remove` · `event`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.RemoveWeatherEvent(1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.removeWeatherEvent(index, match)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.RemoveWeatherEvent.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.removeWeatherEvent(1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.RemoveWeatherEvent(index, match)`

**Contexto:** `server`  
**Descrição:** Remove um evento meteorológico pelo índice/descritor.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.RemoveWeatherEvent(1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.SetEventTime(index, duration, match?)`

**Contexto:** `server`  
**Descrição:** Normaliza duração entre 1 e 1440, resolve índice/correspondência e tenta alterar ou recriar evento.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `server` · `clima renewed: administração no servidor` · `set` · `event` · `time`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetEventTime(1, 1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.setEventTime(index, duration, match)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.SetEventTime.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.setEventTime(1, 1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.SetEventTime(index, duration, match)`

**Contexto:** `server`  
**Descrição:** Atualiza a duração de um evento meteorológico existente.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetEventTime(1, 1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.setFreezeTime(enabled)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.SetFreezeTime.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.setFreezeTime(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.SetFreezeTime(enabled)`

**Contexto:** `server`  
**Descrição:** Ativa ou desativa o congelamento do relógio.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetFreezeTime(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.setTime(hour, minute)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.SetTime.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.setTime(12, 30)
print('Resultado:', result)
```

---

### `pr_lib.weather.SetTime(hour, minute)`

**Contexto:** `server`  
**Descrição:** Define hora e minuto no provider de weather.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetTime(12, 30)
print('Resultado:', result)
```

---

### `pr_lib.weather.setTimeScale(scale)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.SetTimeScale.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.setTimeScale(1.0)
print('Resultado:', result)
```

---

### `pr_lib.weather.SetTimeScale(scale)`

**Contexto:** `server`  
**Descrição:** Ajusta a escala de passagem do tempo.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetTimeScale(1.0)
print('Resultado:', result)
```

---

### `pr_lib.weather.SetWeatherType(index, weatherType, match?)`

**Contexto:** `server`  
**Descrição:** Altera evento por índice ou correspondência; cria evento quando necessário. Retorna sucesso/resultado ou false/motivo.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `server` · `clima renewed: administração no servidor` · `set` · `type`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetWeatherType(1, 'default', false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.setWeatherType(index, weatherType, match)`

**Contexto:** `server`  
**Descrição:** Alias lowercase de pr_lib.weather.SetWeatherType.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `alias` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.setWeatherType(1, 'default', false)
print('Retorno da operação:', result)
```

---

### `pr_lib.weather.SetWeatherType(index, weatherType, match)`

**Contexto:** `server`  
**Descrição:** Altera o tipo de weather em um índice/evento, criando ou ajustando a entrada quando necessário.  
**Arquivo de origem:** [`bridge/weather/renewed/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/weather/renewed/server.lua)  
**Tags:** `weather` · `renewed` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.weather.SetWeatherType(1, 'default', false)
print('Retorno da operação:', result)
```

---

## withJsonLock

### `pr_lib.withJsonLock(path, action, ...)`

**Contexto:** `server`  
**Descrição:** Executa action com lock local do arquivo. É reentrante na mesma corrotina; concorrência retorna false, "busy". Libera o lock mesmo em erro. Não é lock entre recursos.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `withJsonLock` · `server` · `persistência json protegida` · `with` · `json` · `lock`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.withJsonLock('@my_resource/data/config.json', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

## wrapJsonMutations

### `pr_lib.wrapJsonMutations(path, service, methods)`

**Contexto:** `server`  
**Descrição:** Substitui os métodos nomeados do serviço por wrappers de withJsonLock. methods é uma lista de nomes de funções existentes.  
**Arquivo de origem:** [`bridge/persistence.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/persistence.lua)  
**Tags:** `wrapJsonMutations` · `server` · `persistência json protegida` · `wrap` · `json` · `mutations`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.wrapJsonMutations('@my_resource/data/config.json', {}, {})
print('Retorno da operação:', result)
```

---

## zones

### `pr_lib.zones.box(data)`

**Contexto:** `client`  
**Descrição:** Cria uma zone box 3D com rotação.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.zones.box({})
print('Retorno da operação:', result)
```

---

### `pr_lib.zones.poly(data)`

**Contexto:** `client`  
**Descrição:** Cria uma zone poligonal com teste de ponto interno e espessura vertical.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.zones.poly({})
print('Retorno da operação:', result)
```

---

### `pr_lib.zones.sphere(data)`

**Contexto:** `client`  
**Descrição:** Cria uma zone esférica baseada no sistema de points.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.zones.sphere({})
print('Retorno da operação:', result)
```

---

