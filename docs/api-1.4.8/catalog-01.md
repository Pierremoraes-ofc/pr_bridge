# PR Bridge 1.4.8 — Catálogo de funções (volume 1/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**225 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## ace

### `pr_lib.ace.addAce(principal, aceName, allow)`

**Contexto:** `server`  
**Descrição:** Adiciona ou garante a existência de regras ACE dinamicamente (ex: conceder comandos administrativos).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `add` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.addAce('resource.my_resource', 'pr_bridge.developer', true)
print('Resultado:', result)
```

---

### `pr_lib.ace.addPrincipal(child, parent)`

**Contexto:** `server`  
**Descrição:** Vincula ou remove herança e hierarquia de principais do ACE (ex: herdar permissões de admin de um cargo superior).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `add` · `principal` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.addPrincipal(0, 0)
print('Resultado:', result)
```

---

### `pr_lib.ace.canAccess(source, options)`

**Contexto:** `server`  
**Descrição:** Verificação híbrida de permissão que analisa grupos de frameworks, empregos e permissões ACE configuradas no objeto options.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `can` · `access` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.canAccess(source, {})
print('Resultado:', result)
```

---

### `pr_lib.ace.discoverPermissions(options)`

**Contexto:** `server`  
**Descrição:** Alias de compatibilidade para de getPermissionCatalog..  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `discover` · `permissions` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.discoverPermissions({})
print('Retorno da operação:', result)
```

---

### `pr_lib.ace.ensureAce(principal, aceName)`

**Contexto:** `server`  
**Descrição:** Adiciona ou garante a existência de regras ACE dinamicamente (ex: conceder comandos administrativos).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `ensure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.ensureAce('resource.my_resource', 'pr_bridge.developer')
print('Resultado:', result)
```

---

### `pr_lib.ace.ensureCommandAce(principal, commandName)`

**Contexto:** `server`  
**Descrição:** Garante permissão ACE de execução de comando.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `ensure` · `command` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.ensureCommandAce('resource.my_resource', 'example_command')
print('Resultado:', result)
```

---

### `pr_lib.ace.getIdentifiers(source)`

**Contexto:** `server`  
**Descrição:** Retorna todos os identificadores conhecidos de rede do jogador (license, discord, ip, steam, etc.).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `get` · `identifiers` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.getIdentifiers(source)
print('Resultado:', result)
```

---

### `pr_lib.ace.getPermissionCatalog(options)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get permission catalog” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `get` · `permission` · `catalog` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.getPermissionCatalog({})
print('Resultado:', result)
```

---

### `pr_lib.ace.hasAce(source, aceName)`

**Contexto:** `server`  
**Descrição:** Consulta nativa se o jogador possui permissões no arquivo de configurações server.cfg baseada em ACE principal (ex: IsPlayerAceAllowed).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `has` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.hasAce(source, 'pr_bridge.developer')
print('Resultado:', result)
```

---

### `pr_lib.ace.hasCommandAce(source, commandName)`

**Contexto:** `server`  
**Descrição:** Retorna se o jogador tem permissão de execução de um comando do console nativo do FiveM.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `has` · `command` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.hasCommandAce(source, 'example_command')
print('Resultado:', result)
```

---

### `pr_lib.ace.hasFrameworkAccess(source, options)`

**Contexto:** `server`  
**Descrição:** Verificação híbrida de permissão que analisa grupos de frameworks, empregos e permissões ACE configuradas no objeto options.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `has` · `framework` · `access` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.hasFrameworkAccess(source, {})
print('Resultado:', result)
```

---

### `pr_lib.ace.hasIdentifier(source, identifier)`

**Contexto:** `server`  
**Descrição:** Verifica se um jogador possui um identificador específico.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `has` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.hasIdentifier(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.ace.hasIdentifierAce(source, aceName)`

**Contexto:** `server`  
**Descrição:** Verifica se o identificador específico do jogador está explicitamente autorizado no ACE.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `has` · `identifier` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.hasIdentifierAce(source, 'pr_bridge.developer')
print('Resultado:', result)
```

---

### `pr_lib.ace.inWhitelist(source, whitelistName)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador está em uma whitelist do ACE correspondente ao nome da licença.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `in` · `whitelist` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.inWhitelist(source, 'my_whitelist')
print('Resultado:', result)
```

---

### `pr_lib.ace.isCommandAllowed(source, commandName)`

**Contexto:** `server`  
**Descrição:** Retorna se o jogador tem permissão de execução de um comando do console nativo do FiveM.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `is` · `command` · `allowed` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.isCommandAllowed(source, 'example_command')
print('Resultado:', result)
```

---

### `pr_lib.ace.isIdentifierAceAllowed(source, aceName)`

**Contexto:** `server`  
**Descrição:** Verifica se o identificador específico do jogador está explicitamente autorizado no ACE.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `is` · `identifier` · `allowed` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.isIdentifierAceAllowed(source, 'pr_bridge.developer')
print('Resultado:', result)
```

---

### `pr_lib.ace.isPlayerAceAllowed(source, aceName)`

**Contexto:** `server`  
**Descrição:** Consulta nativa se o jogador possui permissões no arquivo de configurações server.cfg baseada em ACE principal (ex: IsPlayerAceAllowed).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `is` · `player` · `allowed` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.isPlayerAceAllowed(source, 'pr_bridge.developer')
print('Resultado:', result)
```

---

### `pr_lib.ace.isWhitelisted(source, whitelistName)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador está em uma whitelist do ACE correspondente ao nome da licença.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `is` · `whitelisted` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.ace.isWhitelisted(source, 'my_whitelist')
print('Resultado:', result)
```

---

### `pr_lib.ace.listPermissions(options)`

**Contexto:** `server`  
**Descrição:** Alias de compatibilidade para de getPermissionCatalog..  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `list` · `permissions` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.listPermissions({})
print('Resultado:', result)
```

---

### `pr_lib.ace.parseConvarList(raw)`

**Contexto:** `server`  
**Descrição:** Parser interno de strings de convars.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `parse` · `convar` · `list` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.parseConvarList(false)
print('Resultado:', result)
```

---

### `pr_lib.ace.registerPermission(name, options)`

**Contexto:** `server`  
**Descrição:** Registra os dados ou a operação “register permission” no módulo ativo.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `register` · `permission` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.registerPermission('example:action', {})
print('Resultado:', result)
```

---

### `pr_lib.ace.removeAce(principal, aceName, allow)`

**Contexto:** `server`  
**Descrição:** Apaga ou altera regras ACE de permissão.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `remove` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.removeAce('resource.my_resource', 'pr_bridge.developer', true)
print('Resultado:', result)
```

---

### `pr_lib.ace.removePrincipal(child, parent)`

**Contexto:** `server`  
**Descrição:** Vincula ou remove herança e hierarquia de principais do ACE (ex: herdar permissões de admin de um cargo superior).  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `remove` · `principal` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.removePrincipal(0, 0)
print('Resultado:', result)
```

---

### `pr_lib.ace.unregisterPermission(name)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “unregister permission” por meio da API pública do módulo `ace`.  
**Arquivo de origem:** [`bridge/ace/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/ace/server.lua)  
**Tags:** `ace` · `unregister` · `permission` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ace.unregisterPermission('example:action')
print('Retorno da operação:', result)
```

---

## addcommand

### `pr_lib.addCommand.add(commandName, properties, cb)`

**Contexto:** `client`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.add('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.addCommand(commandName, properties, cb)`

**Contexto:** `client`  
**Descrição:** Alias de compatibilidade para add.  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.addCommand('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.getSuggestions()`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get suggestions” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `get` · `suggestions` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.getSuggestions()
print('Resultado:', result)
```

---

### `pr_lib.addCommand.hasSuggestion(commandName)`

**Contexto:** `client`  
**Descrição:** Verifica se os dados ou a operação “has suggestion” está disponível ou atende ao filtro informado.  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `has` · `suggestion` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.hasSuggestion('example_command')
print('Resultado:', result)
```

---

### `pr_lib.addCommand.register(commandName, properties, cb)`

**Contexto:** `client`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `register` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.register('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.sendSuggestions(target?)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “send suggestions” por meio da API pública do módulo `addcommand`.  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `send` · `suggestions` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.sendSuggestions(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.addCommand(commandName, properties, callback)`

**Contexto:** `client`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/client.lua)  
**Tags:** `addcommand` · `add` · `command` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.add(commandName, properties, cb)`

**Contexto:** `server`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.add('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.addCommand(commandName, properties, cb)`

**Contexto:** `server`  
**Descrição:** Alias de compatibilidade para add.  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.addCommand('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.getSuggestions()`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get suggestions” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `get` · `suggestions` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.getSuggestions()
print('Resultado:', result)
```

---

### `pr_lib.addCommand.hasSuggestion(commandName)`

**Contexto:** `server`  
**Descrição:** Verifica se os dados ou a operação “has suggestion” está disponível ou atende ao filtro informado.  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `has` · `suggestion` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.hasSuggestion('example_command')
print('Resultado:', result)
```

---

### `pr_lib.addCommand.register(commandName, properties, cb)`

**Contexto:** `server`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `register` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.register('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.addCommand.sendSuggestions(target?)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “send suggestions” por meio da API pública do módulo `addcommand`.  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `send` · `suggestions` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand.sendSuggestions(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.addCommand(commandName, properties, callback)`

**Contexto:** `server`  
**Descrição:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").  
**Arquivo de origem:** [`bridge/addCommand/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addCommand/server.lua)  
**Tags:** `addcommand` · `add` · `command` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addCommand('example_command', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

## addExports

### `pr_lib.addExports(name, callback?)`

**Contexto:** `client/server`  
**Descrição:** Registra export no recurso consumidor; aceita mapa nome→função, nome/função, função/nome, função inferível ou nome global. Retorna true ou false/motivo. Aliases addExport/AddExport/AddExports.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** `addExports` · `client/server` · `entradas públicas antes ausentes do índice` · `add` · `exports`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addExports('example:action', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

## addkeybind

### `pr_lib.addKeybind.get(name)`

**Contexto:** `client`  
**Descrição:** Obtém o objeto mapeador de tecla registrado.  
**Arquivo de origem:** [`bridge/addKeybind/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addKeybind/client.lua)  
**Tags:** `addkeybind` · `add` · `keybind` · `get` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addKeybind.get('example:action')
print('Resultado:', result)
```

---

### `pr_lib.addKeybind.remove(name)`

**Contexto:** `client`  
**Descrição:** Remove e desativa permanentemente o mapeamento de teclas associado.  
**Arquivo de origem:** [`bridge/addKeybind/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addKeybind/client.lua)  
**Tags:** `addkeybind` · `add` · `keybind` · `remove` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addKeybind.remove('example:action')
print('Retorno da operação:', result)
```

---

### `pr_lib.addKeybind(data)`

**Contexto:** `client`  
**Descrição:** Registra mapeamentos de teclas nativas do GTA V listados em Configurações > Teclas > FiveM. O objeto data define nome, descrição, tecla padrão (defaultKey ou keys), combinações e callbacks onPressed/onReleased. Teclas simples preservam o name como comando, seguindo o contrato nativo do FiveM e do ox_lib; combinações usam comandos internos compactos.  
**Arquivo de origem:** [`bridge/addKeybind/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/addKeybind/client.lua)  
**Tags:** `addkeybind` · `add` · `keybind` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addKeybind({})
print('Retorno da operação:', result)
```

---

## alert

### `pr_lib.alertDialog(data, timeout)`

**Contexto:** `client`  
**Descrição:** Atalhos da raiz para os diálogos nativos da interface do pr_bridge. Linhas numéricas aceitam step e precision; quando nenhum passo é informado, o campo aceita livremente valores decimais em vez de restringir a inteiros.  
**Arquivo de origem:** [`interface/client/modules/alert.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/interface/client/modules/alert.lua)  
**Tags:** `alert` · `dialog` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.alertDialog({}, 1)
print('Retorno da operação:', result)
```

---

## appearance

### `pr_lib.appearance.GetBaseDecorations(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'GetBaseDecorations' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getbasedecorations`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export GetBaseDecorations do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.GetBaseDecorations(table.unpack(args))
print('GetBaseDecorations:', result, err)
```

---

### `pr_lib.appearance.getPedAppearance(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedAppearance' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedappearance`

**Exemplo de construção e uso:**

```lua
local ped = PlayerPedId()
local result, err = pr_lib.appearance.getPedAppearance(ped)
print('getPedAppearance:', result, err)
```

---

### `pr_lib.appearance.getPedComponents(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedComponents' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedcomponents`

**Exemplo de construção e uso:**

```lua
local ped = PlayerPedId()
local result, err = pr_lib.appearance.getPedComponents(ped)
print('getPedComponents:', result, err)
```

---

### `pr_lib.appearance.getPedFaceFeatures(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedFaceFeatures' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedfacefeatures`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export getPedFaceFeatures do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.getPedFaceFeatures(table.unpack(args))
print('getPedFaceFeatures:', result, err)
```

---

### `pr_lib.appearance.getPedHair(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedHair' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedhair`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export getPedHair do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.getPedHair(table.unpack(args))
print('getPedHair:', result, err)
```

---

### `pr_lib.appearance.getPedHeadBlend(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedHeadBlend' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedheadblend`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export getPedHeadBlend do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.getPedHeadBlend(table.unpack(args))
print('getPedHeadBlend:', result, err)
```

---

### `pr_lib.appearance.getPedHeadOverlays(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedHeadOverlays' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedheadoverlays`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export getPedHeadOverlays do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.getPedHeadOverlays(table.unpack(args))
print('getPedHeadOverlays:', result, err)
```

---

### `pr_lib.appearance.getPedModel(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedModel' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedmodel`

**Exemplo de construção e uso:**

```lua
local ped = PlayerPedId()
local result, err = pr_lib.appearance.getPedModel(ped)
print('getPedModel:', result, err)
```

---

### `pr_lib.appearance.getPedProps(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'getPedProps' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `leitura` · `getpedprops`

**Exemplo de construção e uso:**

```lua
local ped = PlayerPedId()
local result, err = pr_lib.appearance.getPedProps(ped)
print('getPedProps:', result, err)
```

---

### `pr_lib.appearance.getProvider()`

**Contexto:** `client`  
**Descrição:** Informa o resource `forge-appearance` quando está iniciado e disponível. A disponibilidade é cacheada e invalidada por eventos de start/stop; nil indica provider ausente ou ainda inicializando.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `aparência` · `disponibilidade`

**Exemplo de construção e uso:**

```lua
local provider = pr_lib.appearance.getProvider()
print('Provider de aparência:', provider or 'indisponível')
```

---

### `pr_lib.appearance.OpenAdminMenu(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'OpenAdminMenu' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `openadminmenu`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export OpenAdminMenu do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.OpenAdminMenu(table.unpack(args))
print('OpenAdminMenu:', result, err)
```

---

### `pr_lib.appearance.Reapply(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'Reapply' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `reapply`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export Reapply do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.Reapply(table.unpack(args))
print('Reapply:', result, err)
```

---

### `pr_lib.appearance.setPedAppearance(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedAppearance' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedappearance`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedAppearance do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedAppearance(table.unpack(args))
print('setPedAppearance:', result, err)
```

---

### `pr_lib.appearance.setPedComponent(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedComponent' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedcomponent`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedComponent do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedComponent(table.unpack(args))
print('setPedComponent:', result, err)
```

---

### `pr_lib.appearance.setPedComponents(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedComponents' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedcomponents`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedComponents do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedComponents(table.unpack(args))
print('setPedComponents:', result, err)
```

---

### `pr_lib.appearance.setPedEyeColor(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedEyeColor' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedeyecolor`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedEyeColor do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedEyeColor(table.unpack(args))
print('setPedEyeColor:', result, err)
```

---

### `pr_lib.appearance.setPedFaceFeatures(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedFaceFeatures' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedfacefeatures`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedFaceFeatures do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedFaceFeatures(table.unpack(args))
print('setPedFaceFeatures:', result, err)
```

---

### `pr_lib.appearance.setPedHair(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedHair' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedhair`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedHair do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedHair(table.unpack(args))
print('setPedHair:', result, err)
```

---

### `pr_lib.appearance.setPedHeadBlend(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedHeadBlend' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedheadblend`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedHeadBlend do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedHeadBlend(table.unpack(args))
print('setPedHeadBlend:', result, err)
```

---

### `pr_lib.appearance.setPedHeadOverlays(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedHeadOverlays' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedheadoverlays`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedHeadOverlays do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedHeadOverlays(table.unpack(args))
print('setPedHeadOverlays:', result, err)
```

---

### `pr_lib.appearance.setPedProp(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedProp' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedprop`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedProp do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedProp(table.unpack(args))
print('setPedProp:', result, err)
```

---

### `pr_lib.appearance.setPedProps(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedProps' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedprops`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedProps do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedProps(table.unpack(args))
print('setPedProps:', result, err)
```

---

### `pr_lib.appearance.setPedTattoos(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPedTattoos' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setpedtattoos`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPedTattoos do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPedTattoos(table.unpack(args))
print('setPedTattoos:', result, err)
```

---

### `pr_lib.appearance.setPlayerAppearance(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPlayerAppearance' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setplayerappearance`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPlayerAppearance do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPlayerAppearance(table.unpack(args))
print('setPlayerAppearance:', result, err)
```

---

### `pr_lib.appearance.setPlayerModel(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'setPlayerModel' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `setplayermodel`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export setPlayerModel do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.setPlayerModel(table.unpack(args))
print('setPlayerModel:', result, err)
```

---

### `pr_lib.appearance.startPlayerCustomization(...)`

**Contexto:** `client`  
**Descrição:** Encaminha a operação 'startPlayerCustomization' do contrato client ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `client` · `provider` · `forge-appearance` · `escrita` · `startplayercustomization`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export startPlayerCustomization do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.startPlayerCustomization(table.unpack(args))
print('startPlayerCustomization:', result, err)
```

---

### `pr_lib.appearance.AppearanceInkStorage(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'AppearanceInkStorage' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `leitura` · `appearanceinkstorage`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export AppearanceInkStorage do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.AppearanceInkStorage(table.unpack(args))
print('AppearanceInkStorage:', result, err)
```

---

### `pr_lib.appearance.ClothingCatalogImage(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ClothingCatalogImage' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `leitura` · `clothingcatalogimage`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ClothingCatalogImage do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ClothingCatalogImage(table.unpack(args))
print('ClothingCatalogImage:', result, err)
```

---

### `pr_lib.appearance.ClothingCatalogReference(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ClothingCatalogReference' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `leitura` · `clothingcatalogreference`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ClothingCatalogReference do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ClothingCatalogReference(table.unpack(args))
print('ClothingCatalogReference:', result, err)
```

---

### `pr_lib.appearance.getProvider()`

**Contexto:** `server`  
**Descrição:** Informa o resource `forge-appearance` quando está iniciado e disponível. A disponibilidade é cacheada e invalidada por eventos de start/stop; nil indica provider ausente ou ainda inicializando.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `aparência` · `disponibilidade`

**Exemplo de construção e uso:**

```lua
local provider = pr_lib.appearance.getProvider()
print('Provider de aparência:', provider or 'indisponível')
```

---

### `pr_lib.appearance.ImageGenerationBegin(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ImageGenerationBegin' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `escrita` · `imagegenerationbegin`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ImageGenerationBegin do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ImageGenerationBegin(table.unpack(args))
print('ImageGenerationBegin:', result, err)
```

---

### `pr_lib.appearance.ImageGenerationCheck(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ImageGenerationCheck' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `leitura` · `imagegenerationcheck`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ImageGenerationCheck do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ImageGenerationCheck(table.unpack(args))
print('ImageGenerationCheck:', result, err)
```

---

### `pr_lib.appearance.ImageGenerationFail(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ImageGenerationFail' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `escrita` · `imagegenerationfail`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ImageGenerationFail do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ImageGenerationFail(table.unpack(args))
print('ImageGenerationFail:', result, err)
```

---

### `pr_lib.appearance.ImageGenerationFinish(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'ImageGenerationFinish' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para alteração, valide permissões e os argumentos exigidos antes de executar.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `escrita` · `imagegenerationfinish`

**Exemplo de construção e uso:**

```lua
-- Complete os parâmetros segundo o export ImageGenerationFinish do forge-appearance.
local args = {} -- parâmetros do contrato do provider
local result, err = pr_lib.appearance.ImageGenerationFinish(table.unpack(args))
print('ImageGenerationFinish:', result, err)
```

---

### `pr_lib.appearance.IsAppearanceAdmin(...)`

**Contexto:** `server`  
**Descrição:** Encaminha a operação 'IsAppearanceAdmin' do contrato server ao resource forge-appearance. A assinatura dos argumentos é definida pelo export do provider, não pelo PR Bridge; sem ele, retorna nil, 'appearance_provider_unavailable'. Para leitura, consulte o resultado retornado pelo provider.  
**Arquivo de origem:** [`bridge/appearance/api.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/appearance/api.lua)  
**Tags:** `appearance` · `server` · `provider` · `forge-appearance` · `leitura` · `isappearanceadmin`

**Exemplo de construção e uso:**

```lua
local source = source -- ID do jogador obtido pelo comando/evento
local result, err = pr_lib.appearance.IsAppearanceAdmin(source)
print('Permissão de aparência:', result, err)
```

---

## banking

### `pr_lib.banking.AddAccountBalance(player, accountType, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Adiciona fundos à conta bancária de um jogador.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `add` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.AddAccountBalance(PlayerPedId(), 'example', 1, 'example')
print('Resultado:', result)
```

---

### `pr_lib.banking.AddJobAccountBalance(account, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `add` · `job` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.AddJobAccountBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.banking.AddPlayerAccountBalance(player, accountType, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Adiciona fundos à conta bancária de um jogador.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `add` · `player` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.AddPlayerAccountBalance(PlayerPedId(), 'example', 1, 'example')
print('Resultado:', result)
```

---

### `pr_lib.banking.GetAccountBalance(player, accountType)`

**Contexto:** `shared`  
**Descrição:** Retorna o saldo de uma conta bancária de um jogador (ex: "personal", "savings").  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `get` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.GetAccountBalance(PlayerPedId(), 'example')
print('Resultado:', result)
```

---

### `pr_lib.banking.GetJobAccountBalance(account)`

**Contexto:** `shared`  
**Descrição:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `get` · `job` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.GetJobAccountBalance('cash')
print('Resultado:', result)
```

---

### `pr_lib.banking.GetPlayerAccountBalance(player, accountType)`

**Contexto:** `shared`  
**Descrição:** Retorna o saldo de uma conta bancária de um jogador (ex: "personal", "savings").  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `get` · `player` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.GetPlayerAccountBalance(PlayerPedId(), 'example')
print('Resultado:', result)
```

---

### `pr_lib.banking.GetResourceName()`

**Contexto:** `shared`  
**Descrição:** Retorna o recurso bancário ativo (ex: "okokBanking", "renewed_banking", etc.).  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `get` · `resource` · `name` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.banking.RemoveAccountBalance(player, accountType, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Deduz dinheiro da conta bancária de um jogador.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `remove` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.RemoveAccountBalance(PlayerPedId(), 'example', 1, 'example')
print('Resultado:', result)
```

---

### `pr_lib.banking.RemoveJobAccountBalance(account, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `remove` · `job` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.RemoveJobAccountBalance('cash', 1, 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.banking.RemovePlayerAccountBalance(player, accountType, amount, reason)`

**Contexto:** `shared`  
**Descrição:** Deduz dinheiro da conta bancária de um jogador.  
**Arquivo de origem:** `pr_bridge/bridge/banking/*/{client,server}.lua`  
**Tags:** `banking` · `remove` · `player` · `account` · `balance` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.banking.RemovePlayerAccountBalance(PlayerPedId(), 'example', 1, 'example')
print('Resultado:', result)
```

---

## cache

### `player:get(field)`

**Contexto:** `client`  
**Descrição:** Retorna campo do provider de inventário ou do cache local, conforme o campo solicitado.  
**Arquivo de origem:** [`bridge/cache/player_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/player_client.lua)  
**Tags:** `cache` · `client` · `métodos da instância de estado local` · `get`

**Exemplo de construção e uso:**

```lua
local player = pr_lib.player.new()
local result = player:get('example')
print('Resultado:', result)
```

---

### `player:set(field, value)`

**Contexto:** `client`  
**Descrição:** Delega campos de inventário a ox_inventory:SetPlayerState e demais campos ao cache local. Provider parado retorna false.  
**Arquivo de origem:** [`bridge/cache/player_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/player_client.lua)  
**Tags:** `cache` · `client` · `métodos da instância de estado local` · `set`

**Exemplo de construção e uso:**

```lua
local player = pr_lib.player.new()
local result = player:set('example', {})
print('Resultado:', result)
```

---

### `player:setr(field, value)`

**Contexto:** `client`  
**Descrição:** Alias de set na facade: não garante replicação pela rede.  
**Arquivo de origem:** [`bridge/cache/player_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/player_client.lua)  
**Tags:** `cache` · `client` · `métodos da instância de estado local` · `setr`

**Exemplo de construção e uso:**

```lua
local player = pr_lib.player.new()
local result = player:setr('example', {})
print('Resultado:', result)
```

---

### `pr_lib.getCacheMetrics()`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get cache metrics” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `metrics` · `client` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getCacheMetrics()
print('Resultado:', result)
```

---

### `pr_lib.onCache(key, callback)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “on cache” por meio da API pública do módulo `cache_central_e_statebag-like`.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `on` · `client` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.onCache('example_key', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.GetResourceState(resource, key)`

**Contexto:** `client/server`  
**Descrição:** Consulta cópia defensiva de dados anteriormente publicados sob resource + domain no cache local. Não consulta exports do produtor no momento da leitura, não faz snapshot inicial nem cria replicação automática.  
**Arquivo de origem:** [`bridge/cache/resources.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/resources.lua)  
**Tags:** `cache` · `client/server` · `cache entre recursos` · `get` · `resource` · `state`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.GetResourceState('my_resource', 'example_key')
print('Resultado:', result)
```

---

### `pr_lib.cache.OnResourceState(resource, key, callback)`

**Contexto:** `client/server`  
**Descrição:** Registra observador de mudanças do domínio no cache local e retorna handle/função de cancelamento conforme onChange. Não entrega snapshot inicial; faça GetResourceState separadamente quando necessário.  
**Arquivo de origem:** [`bridge/cache/resources.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/resources.lua)  
**Tags:** `cache` · `client/server` · `cache entre recursos` · `on` · `resource` · `state`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.OnResourceState('my_resource', 'example_key', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.SetResourceState(resource, domain, data)`

**Contexto:** `client/server`  
**Descrição:** Publica explicitamente um estado de domínio no cache, criando uma cópia defensiva. Não faz coleta automática de recursos nem substitui replicação explícita quando ela for necessária.  
**Arquivo de origem:** [`bridge/cache/resources.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/resources.lua)  
**Tags:** `cache` · `client/server` · `cache` · `provider` · `estado` · `publicação`

**Exemplo de construção e uso:**

```lua
local resource = GetCurrentResourceName()
local result = pr_lib.cache.SetResourceState(resource, 'status', { ready = true })
print('Publicação no cache:', result)
```

---

### `pr_lib.cache:clear(key?)`

**Contexto:** `shared`  
**Descrição:** Limpa os dados ou a operação “clear” e os dados relacionados mantidos pelo módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `clear` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:clear('example_key')
print('Retorno da operação:', result)
```

---

### `pr_lib.cache:clearPrefix(prefix)`

**Contexto:** `shared`  
**Descrição:** Limpa os dados ou a operação “clear prefix” e os dados relacionados mantidos pelo módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `clear` · `prefix` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:clearPrefix('example:')
print('Resultado:', result)
```

---

### `pr_lib.cache:get(key, fallback?)`

**Contexto:** `shared`  
**Descrição:** Obtém os dados ou a operação “get” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:get('example')
print('Resultado:', result)
```

---

### `pr_lib.cache:getEntities(kind?)`

**Contexto:** `shared`  
**Descrição:** Obtém os dados ou a operação “get entities” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `entities` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:getEntities()
print('Resultado:', result)
```

---

### `pr_lib.cache:getEntity(entityOrNetId)`

**Contexto:** `shared`  
**Descrição:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `entity` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:getEntity(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.cache:getEntityState(entityOrNetId)`

**Contexto:** `shared`  
**Descrição:** Obtém os dados ou a operação “get entity state” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `entity` · `state` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:getEntityState(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.cache:getMetrics()`

**Contexto:** `shared`  
**Descrição:** Obtém os dados ou a operação “get metrics” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `metrics` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:getMetrics()
print('Resultado:', result)
```

---

### `pr_lib.cache:has(key)`

**Contexto:** `shared`  
**Descrição:** Verifica se os dados ou a operação “has” está disponível ou atende ao filtro informado.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `has` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:has('example_key')
print('Resultado:', result)
```

---

### `pr_lib.cache:onChange(key, callback)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “on change” por meio da API pública do módulo `cache`.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `on` · `change` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:onChange('example_key', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache:remember(key, callback, ttl?)`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “remember” por meio da API pública do módulo `cache`.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `remember` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:remember('example', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.cache:scanWorld()`

**Contexto:** `shared`  
**Descrição:** Executa os dados ou a operação “scan world” por meio da API pública do módulo `cache`.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `scan` · `world` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:scanWorld()
print('Retorno da operação:', result)
```

---

### `pr_lib.cache:set(key, value, ttl?)`

**Contexto:** `shared`  
**Descrição:** Define ou atualiza os dados ou a operação “set” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `set` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:set('example', {})
print('Resultado:', result)
```

---

### `pr_lib.cache:setShared(key, value, ttl?)`

**Contexto:** `shared`  
**Descrição:** Define ou atualiza os dados ou a operação “set shared” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `set` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:setShared('example', {})
print('Resultado:', result)
```

---

### `pr_lib.cache:setWorldEnabled(enabled)`

**Contexto:** `shared`  
**Descrição:** Define ou atualiza os dados ou a operação “set world enabled” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `set` · `world` · `enabled` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache:setWorldEnabled(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.call(key, callback, timeout)`

**Contexto:** `shared`  
**Descrição:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `call` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.call('example_key', function(value) print('Callback:', value) end, 1)
print('Resultado:', result)
```

---

### `pr_lib.cache.clear(key)`

**Contexto:** `shared`  
**Descrição:** Limpa uma entrada de cache e notifica ouvintes ativos de alteração de estado.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `clear` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.clear('example_key')
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.clearPrefix(prefix)`

**Contexto:** `shared`  
**Descrição:** Invalida em lote todas as chaves do cache que começarem com um determinado termo.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `clear` · `prefix` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.clearPrefix('example:')
print('Resultado:', result)
```

---

### `pr_lib.cache.get(key, fallback)`

**Contexto:** `shared`  
**Descrição:** Busca um valor anteriormente guardado no cache. Se a chave não existir ou for nula, retorna o valor de fallback.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.get('example', {})
print('Resultado:', result)
```

---

### `pr_lib.cache.GetMetadata(source, metadata, timeout)`

**Contexto:** `shared`  
**Descrição:** Recupera metadados específicos de um jogador a partir do cache temporário de curta duração.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `metadata` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.GetMetadata(source, {}, 1)
print('Resultado:', result)
```

---

### `pr_lib.cache.GetPlayer(source, timeout)`

**Contexto:** `shared`  
**Descrição:** Retorna o objeto do jogador do framework de forma ultra rápida usando cache em memória para diminuir chamadas repetidas de export.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `get` · `player` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.GetPlayer(source, 1)
print('Resultado:', result)
```

---

### `pr_lib.cache.InvalidatePlayer(source)`

**Contexto:** `shared`  
**Descrição:** Limpa todas as instâncias de cache associadas à ID do jogador informada.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `invalidate` · `player` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.InvalidatePlayer(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.onChange(key, callback)`

**Contexto:** `shared`  
**Descrição:** Assina a alteração de uma chave de cache específica. O callback recebe (newValue, oldValue) quando o dado correspondente mudar.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `on` · `change` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.onChange('example_key', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.remember(key, callback, timeout)`

**Contexto:** `shared`  
**Descrição:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `remember` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.remember('example_key', function(value) print('Callback:', value) end, 1)
print('Resultado:', result)
```

---

### `pr_lib.cache.set(key, value)`

**Contexto:** `shared`  
**Descrição:** Armazena um dado em memória RAM atrelado a uma chave de identificação de cache.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `set` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.set('example_key', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.cache.setShared(key, value, ttl?)`

**Contexto:** `shared`  
**Descrição:** Grava uma chave compartilhada no cache central do pr_bridge e sincroniza o novo valor entre os recursos consumidores do mesmo contexto. Somente chaves autorizadas pelo cache central podem ser publicadas.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `set` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache.setShared('example', {})
print('Resultado:', result)
```

---

### `pr_lib.cache(key, callback, timeout)`

**Contexto:** `shared`  
**Descrição:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.  
**Arquivo de origem:** [`bridge/cache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/cache/shared.lua)  
**Tags:** `cache` · `shared` · `invalidação` · `estado` · `memória`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.cache('example_key', function(value) print('Callback:', value) end, 1)
print('Retorno da operação:', result)
```

---

## callback

### `pr_lib.callback.await(name, timeout, ...)`

**Contexto:** `client`  
**Descrição:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `await` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.await('example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.awaitOx(name, delay, ...)`

**Contexto:** `client`  
**Descrição:** OX-compatible await helper with client-side per-event cooldown/rate limiting.  
**Arquivo de origem:** [`bridge/callback/secure_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_client.lua)  
**Tags:** `callback` · `secure` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.awaitOx('example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.call(name, delay, cb, ...)`

**Contexto:** `client`  
**Descrição:** Compatibility call helper with optional per-event delay; awaits when cb is nil/false and triggers asynchronously when cb is a function.  
**Arquivo de origem:** [`bridge/callback/secure_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_client.lua)  
**Tags:** `callback` · `secure` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.call('example:action', 1, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.callback.cancel(requestId, reason?)`

**Contexto:** `client`  
**Descrição:** Cancela uma requisição pendente ativa.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `cancel` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.cancel('example')
print('Resultado:', result)
```

---

### `pr_lib.callback.getPending()`

**Contexto:** `client`  
**Descrição:** Retorna a lista de requisições de callback aguardando resposta.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `get` · `pending` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.getPending()
print('Resultado:', result)
```

---

### `pr_lib.callback.getStats()`

**Contexto:** `client`  
**Descrição:** Retorna pendências, limites, timeouts, rejeições, respostas forjadas, cancelamentos e erros protegidos.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `get` · `stats` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.getStats()
print('Resultado:', result)
```

---

### `pr_lib.callback.ox.await(name, delay, ...)`

**Contexto:** `client`  
**Descrição:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `ox` · `await` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.ox.await('example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.ox(name, delay, cb, ...)`

**Contexto:** `client`  
**Descrição:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `ox` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.ox('example:action', 1, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.callback.register(name, handler)`

**Contexto:** `client`  
**Descrição:** Registers a secure client callback endpoint that can be invoked by the server and replies through the PR Bridge callback envelope.  
**Arquivo de origem:** [`bridge/callback/secure_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_client.lua)  
**Tags:** `callback` · `secure` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.register('example:action', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.callback.trigger(name, cb, ...)`

**Contexto:** `client`  
**Descrição:** Dispara uma chamada assíncrona que executa um bloco de código no ambiente oposto (Server para Client, ou vice-versa) e executa a função cb entregando o resultado assim que a resposta for enviada.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `trigger` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.trigger('example:action', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.callback(...)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “callback” por meio da API pública do módulo `callbacks_reforçados_(opt-in)`.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `client` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback()
print('Resultado:', result)
```

---

### `pr_lib.callback.await(target, name, timeout, ...)`

**Contexto:** `server`  
**Descrição:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `await` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.await(source, 'example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.awaitClient(target, name, timeout, ...)`

**Contexto:** `server`  
**Descrição:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `await` · `client` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.awaitClient(source, 'example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.awaitLegacy(target, name, timeout, ...)`

**Contexto:** `server`  
**Descrição:** Compatibility alias that points to awaitClient.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.awaitLegacy(source, 'example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.callback.awaitOx(name, target, ...)`

**Contexto:** `server`  
**Descrição:** OX-compatible server helper that awaits a callback response from the target client.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.awaitOx('example:action', source)
print('Resultado:', result)
```

---

### `pr_lib.callback.callOx(name, target, cb, ...)`

**Contexto:** `server`  
**Descrição:** OX-compatible server callback helper; awaits when cb is nil/false or triggers asynchronously with cb.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.callOx('example:action', source, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.callback.cancel(requestId, reason?)`

**Contexto:** `server`  
**Descrição:** Cancela uma requisição pendente ativa.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `cancel` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.cancel('example')
print('Resultado:', result)
```

---

### `pr_lib.callback.getPending()`

**Contexto:** `server`  
**Descrição:** Retorna a lista de requisições de callback aguardando resposta.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `get` · `pending` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.getPending()
print('Resultado:', result)
```

---

### `pr_lib.callback.getStats()`

**Contexto:** `server`  
**Descrição:** Retorna pendências, limites, timeouts, rejeições, respostas forjadas, cancelamentos e erros protegidos.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `get` · `stats` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.getStats()
print('Resultado:', result)
```

---

### `pr_lib.callback.ox.await(name, target, ...)`

**Contexto:** `server`  
**Descrição:** OX-compatible await alias exposed under callback.ox.await.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.ox.await('example:action', source)
print('Resultado:', result)
```

---

### `pr_lib.callback.ox(...)`

**Contexto:** `server`  
**Descrição:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `ox` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.ox()
print('Retorno da operação:', result)
```

---

### `pr_lib.callback.ox(name, target, cb, ...)`

**Contexto:** `server`  
**Descrição:** Callable OX-compatible callback facade on the server.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.ox('example:action', source, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.callback.register(name, handler)`

**Contexto:** `server`  
**Descrição:** Registers a secure server callback endpoint. The handler receives source first and is protected by inbound concurrency limits.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.register('example:action', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.callback.trigger(target, name, cb, ...)`

**Contexto:** `server`  
**Descrição:** Dispara uma chamada assíncrona que executa um bloco de código no ambiente oposto (Server para Client, ou vice-versa) e executa a função cb entregando o resultado assim que a resposta for enviada.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `trigger` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.trigger(source, 'example:action', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.callback.triggerClient(target, name, cb, ...)`

**Contexto:** `server`  
**Descrição:** Dispara um callback direcionado ao cliente do jogador target.  
**Arquivo de origem:** [`bridge/callback/{client,server,secure_client,secure_server}.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/{client,server,secure_client,secure_server}.lua)  
**Tags:** `callback` · `trigger` · `client` · `server` · `request` · `resposta` · `timeout`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.triggerClient(source, 'example:action', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.callback(first, second, third, ...)`

**Contexto:** `server`  
**Descrição:** Callable callback facade; dispatches through the secure server trigger contract.  
**Arquivo de origem:** [`bridge/callback/secure_server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/callback/secure_server.lua)  
**Tags:** `callback` · `secure` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback('example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.callback.getMode()`

**Contexto:** `shared`  
**Descrição:** Retorna o modo atual do sistema de callback (legacy ou secure).  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.callback.getMode()
print('Resultado:', result)
```

---

## collections.array

### `pr_lib.collections.array:at(index)`

**Contexto:** `shared`  
**Descrição:** Obtém o item localizado no índice solicitado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `at`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:at(1)
print('at:', result)
```

---

### `pr_lib.collections.array:every(testFn)`

**Contexto:** `shared`  
**Descrição:** Retorna true quando todos os elementos satisfazem o predicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `every`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
print('every:', result)
local result = pr_lib.collections.array:every(function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.collections.array:fill(value, start, endIndex)`

**Contexto:** `shared`  
**Descrição:** Preenche um intervalo da sequência com o valor informado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `fill`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:fill(42, 1, 3)
print('fill:', result)
```

---

### `pr_lib.collections.array:filter(testFn)`

**Contexto:** `shared`  
**Descrição:** Retorna nova sequência contendo somente itens aprovados pelo predicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `filter`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
print('filter:', result)
local result = pr_lib.collections.array:filter(function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.collections.array:find(testFn, last)`

**Contexto:** `shared`  
**Descrição:** Localiza o primeiro item aceito pelo predicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `find`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
print('find:', result)
local result = pr_lib.collections.array:find(function(value) print('Callback:', value) end, 'example')
print('Resultado:', result)
```

---

### `pr_lib.collections.array:findIndex(testFn, last)`

**Contexto:** `shared`  
**Descrição:** Encontra o índice do item aprovado pelo predicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `findindex`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
print('findIndex:', result)
local result = pr_lib.collections.array:findIndex(function(value) print('Callback:', value) end, 'example')
print('Resultado:', result)
```

---

### `pr_lib.collections.array:forEach(cb)`

**Contexto:** `shared`  
**Descrição:** Executa o callback para cada elemento da coleção. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `foreach`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:forEach(function(item) print('Item:', item) end)
print('forEach:', result)
```

---

### `pr_lib.collections.array:includes(element, fromIndex)`

**Contexto:** `shared`  
**Descrição:** Verifica se o valor informado existe na coleção. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `includes`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:includes(10, 1)
print('includes:', result)
```

---

### `pr_lib.collections.array:indexOf(value, last)`

**Contexto:** `shared`  
**Descrição:** Localiza o índice do valor informado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `indexof`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:indexOf(42, false)
print('indexOf:', result)
```

---

### `pr_lib.collections.array:join(seperator)`

**Contexto:** `shared`  
**Descrição:** Concatena os elementos usando o separador. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `join`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:join(', ')
print('join:', result)
```

---

### `pr_lib.collections.array:map(cb)`

**Contexto:** `shared`  
**Descrição:** Transforma cada elemento e cria uma nova coleção. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `map`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:map(function(item) print('Item:', item) end)
print('map:', result)
```

---

### `pr_lib.collections.array:merge(...)`

**Contexto:** `shared`  
**Descrição:** Cria uma nova sequência combinando outras coleções. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `merge`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:merge(40, 50)
print('merge:', result)
```

---

### `pr_lib.collections.array:pop()`

**Contexto:** `shared`  
**Descrição:** Remove e retorna o último elemento. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `pop`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:pop()
print('pop:', result)
```

---

### `pr_lib.collections.array:push(...)`

**Contexto:** `shared`  
**Descrição:** Insere um ou mais elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `push`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:push(40, 50)
print('push:', result)
```

---

### `pr_lib.collections.array:reduce(reducer, initialValue, reverse)`

**Contexto:** `shared`  
**Descrição:** Acumula os itens conforme o callback e valor inicial. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `reduce`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:reduce(function(sum, item) return sum + item end, 0, false)
print('reduce:', result)
```

---

### `pr_lib.collections.array:reverse()`

**Contexto:** `shared`  
**Descrição:** Inverte a ordem dos itens. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `reverse`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:reverse()
print('reverse:', result)
```

---

### `pr_lib.collections.array:shift()`

**Contexto:** `shared`  
**Descrição:** Remove o primeiro item. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `shift`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:shift()
print('shift:', result)
```

---

### `pr_lib.collections.array:slice(start, finish)`

**Contexto:** `shared`  
**Descrição:** Obtém uma fatia da sequência. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `slice`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:slice(1, 2)
print('slice:', result)
```

---

### `pr_lib.collections.array:toReversed()`

**Contexto:** `shared`  
**Descrição:** Retorna uma cópia com elementos em ordem inversa. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `toreversed`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:toReversed()
print('toReversed:', result)
```

---

### `pr_lib.collections.array:unshift(...)`

**Contexto:** `shared`  
**Descrição:** Insere elemento no início da sequência. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `unshift`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.array:new(10, 20, 30)
local result = collection:unshift(40, 50)
print('unshift:', result)
```

---

### `pr_lib.collections.array.from(iter)`

**Contexto:** `shared`  
**Descrição:** Constrói uma coleção a partir de uma tabela, iterador ou sequência. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre o construtor/objeto do tipo.  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `from`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.collections.array.from({1, 2, 3})
print('from:', result)
```

---

### `pr_lib.collections.array.isArray(tbl)`

**Contexto:** `shared`  
**Descrição:** Confirma se uma tabela/instância tem semântica de array. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre o construtor/objeto do tipo.  
**Arquivo de origem:** [`bridge/collections/array.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/array.lua)  
**Tags:** `collections.array` · `shared` · `collections` · `estrutura de dados` · `array` · `isarray`

**Exemplo de construção e uso:**

```lua
print('isArray:', result)
local result = pr_lib.collections.array.isArray('example')
print('Resultado:', result)
```

---

## collections.heap

### `pr_lib.collections.heap:clear()`

**Contexto:** `shared`  
**Descrição:** Remove todos os elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `clear`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:clear()
print('clear:', result)
```

---

### `pr_lib.collections.heap:drain()`

**Contexto:** `shared`  
**Descrição:** Consome entradas remanescentes conforme a semântica do heap. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `drain`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:drain()
print('drain:', result)
```

---

### `pr_lib.collections.heap:isEmpty()`

**Contexto:** `shared`  
**Descrição:** Verifica se a coleção está vazia. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `isempty`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:isEmpty()
print('isEmpty:', result)
```

---

### `pr_lib.collections.heap:peek()`

**Contexto:** `shared`  
**Descrição:** Consulta a próxima entrada sem removê-la. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `peek`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:peek()
print('peek:', result)
```

---

### `pr_lib.collections.heap:pop()`

**Contexto:** `shared`  
**Descrição:** Remove e retorna o último elemento. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `pop`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:pop()
print('pop:', result)
```

---

### `pr_lib.collections.heap:push(...)`

**Contexto:** `shared`  
**Descrição:** Insere um ou mais elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `push`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:push(3, 1, 2)
print('push:', result)
```

---

### `pr_lib.collections.heap:size()`

**Contexto:** `shared`  
**Descrição:** Retorna a quantidade de elementos atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/heap.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/heap.lua)  
**Tags:** `collections.heap` · `shared` · `collections` · `estrutura de dados` · `heap` · `size`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.heap:new(function(a, b) return a < b end)
local result = collection:size()
print('size:', result)
```

---

## collections.lru

### `pr_lib.collections.lru:capacity()`

**Contexto:** `shared`  
**Descrição:** Retorna a capacidade definida para a estrutura. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `capacity`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:capacity()
print('capacity:', result)
```

---

### `pr_lib.collections.lru:clear()`

**Contexto:** `shared`  
**Descrição:** Remove todos os elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `clear`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:clear()
print('clear:', result)
```

---

### `pr_lib.collections.lru:delete(key)`

**Contexto:** `shared`  
**Descrição:** Remove o par de chave/valor. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `delete`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:delete('a')
print('delete:', result)
```

---

### `pr_lib.collections.lru:each()`

**Contexto:** `shared`  
**Descrição:** Executa a operação 'each' da coleção lru. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `each`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:each()
print('each:', result)
```

---

### `pr_lib.collections.lru:get(key)`

**Contexto:** `shared`  
**Descrição:** Obtém o elemento indexado pelo identificador informado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `get`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
-- A chave/posição deve existir na instância para retornar um valor
local result = collection:get('a')
print('get:', result)
```

---

### `pr_lib.collections.lru:has(key)`

**Contexto:** `shared`  
**Descrição:** Verifica a presença do elemento/chave. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `has`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:has('a')
print('has:', result)
```

---

### `pr_lib.collections.lru:peek(key)`

**Contexto:** `shared`  
**Descrição:** Consulta a próxima entrada sem removê-la. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `peek`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:peek('a')
print('peek:', result)
```

---

### `pr_lib.collections.lru:set(key, value)`

**Contexto:** `shared`  
**Descrição:** Grava ou atualiza valor na chave, mantendo semântica do mapa/cache. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `set`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:set('a', 42)
print('set:', result)
```

---

### `pr_lib.collections.lru:size()`

**Contexto:** `shared`  
**Descrição:** Retorna a quantidade de elementos atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/lru.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/lru.lua)  
**Tags:** `collections.lru` · `shared` · `collections` · `estrutura de dados` · `lru` · `size`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.lru:new(16)
local result = collection:size()
print('size:', result)
```

---

## collections.map

### `pr_lib.collections.map:clear()`

**Contexto:** `shared`  
**Descrição:** Remove todos os elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `clear`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:clear()
print('clear:', result)
```

---

### `pr_lib.collections.map:delete(key)`

**Contexto:** `shared`  
**Descrição:** Remove o par de chave/valor. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `delete`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:delete('a')
print('delete:', result)
```

---

### `pr_lib.collections.map:entries()`

**Contexto:** `shared`  
**Descrição:** Obtém uma sequência/iterador de pares chave/valor. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `entries`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:entries()
print('entries:', result)
```

---

### `pr_lib.collections.map:get(key)`

**Contexto:** `shared`  
**Descrição:** Obtém o elemento indexado pelo identificador informado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `get`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
-- A chave/posição deve existir na instância para retornar um valor
local result = collection:get('a')
print('get:', result)
```

---

### `pr_lib.collections.map:has(key)`

**Contexto:** `shared`  
**Descrição:** Verifica a presença do elemento/chave. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `has`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:has('a')
print('has:', result)
```

---

### `pr_lib.collections.map:isEmpty()`

**Contexto:** `shared`  
**Descrição:** Verifica se a coleção está vazia. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `isempty`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:isEmpty()
print('isEmpty:', result)
```

---

### `pr_lib.collections.map:keys()`

**Contexto:** `shared`  
**Descrição:** Obtém as chaves atualmente armazenadas. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `keys`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:keys()
print('keys:', result)
```

---

### `pr_lib.collections.map:set(key, value)`

**Contexto:** `shared`  
**Descrição:** Grava ou atualiza valor na chave, mantendo semântica do mapa/cache. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `set`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:set('a', 42)
print('set:', result)
```

---

### `pr_lib.collections.map:size()`

**Contexto:** `shared`  
**Descrição:** Retorna a quantidade de elementos atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `size`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:size()
print('size:', result)
```

---

### `pr_lib.collections.map:toArray()`

**Contexto:** `shared`  
**Descrição:** Converte os valores para uma sequência Lua. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `toarray`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:toArray()
print('toArray:', result)
```

---

### `pr_lib.collections.map:toTable()`

**Contexto:** `shared`  
**Descrição:** Converte a estrutura para uma tabela Lua regular. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `totable`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:toTable()
print('toTable:', result)
```

---

### `pr_lib.collections.map:values()`

**Contexto:** `shared`  
**Descrição:** Obtém os valores atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/map.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/map.lua)  
**Tags:** `collections.map` · `shared` · `collections` · `estrutura de dados` · `map` · `values`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.map:new({ a = 10, b = 20 })
local result = collection:values()
print('values:', result)
```

---

## collections.ringbuffer

### `pr_lib.collections.ringbuffer:capacity()`

**Contexto:** `shared`  
**Descrição:** Retorna a capacidade definida para a estrutura. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `capacity`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:capacity()
print('capacity:', result)
```

---

### `pr_lib.collections.ringbuffer:clear()`

**Contexto:** `shared`  
**Descrição:** Remove todos os elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `clear`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:clear()
print('clear:', result)
```

---

### `pr_lib.collections.ringbuffer:each()`

**Contexto:** `shared`  
**Descrição:** Executa a operação 'each' da coleção ringbuffer. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `each`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:each()
print('each:', result)
```

---

### `pr_lib.collections.ringbuffer:get(i)`

**Contexto:** `shared`  
**Descrição:** Obtém o elemento indexado pelo identificador informado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `get`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
-- A chave/posição deve existir na instância para retornar um valor
local result = collection:get(1)
print('get:', result)
```

---

### `pr_lib.collections.ringbuffer:isEmpty()`

**Contexto:** `shared`  
**Descrição:** Verifica se a coleção está vazia. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `isempty`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:isEmpty()
print('isEmpty:', result)
```

---

### `pr_lib.collections.ringbuffer:isFull()`

**Contexto:** `shared`  
**Descrição:** Indica se a capacidade do buffer foi atingida. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `isfull`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:isFull()
print('isFull:', result)
```

---

### `pr_lib.collections.ringbuffer:push(value)`

**Contexto:** `shared`  
**Descrição:** Insere um ou mais elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `push`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:push(42)
print('push:', result)
```

---

### `pr_lib.collections.ringbuffer:size()`

**Contexto:** `shared`  
**Descrição:** Retorna a quantidade de elementos atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `size`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:size()
print('size:', result)
```

---

### `pr_lib.collections.ringbuffer:toArray()`

**Contexto:** `shared`  
**Descrição:** Converte os valores para uma sequência Lua. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/ringbuffer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/ringbuffer.lua)  
**Tags:** `collections.ringbuffer` · `shared` · `collections` · `estrutura de dados` · `ringbuffer` · `toarray`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.ringbuffer:new(5)
local result = collection:toArray()
print('toArray:', result)
```

---

## collections.selector

### `pr_lib.collections.selector:addSet(setName, items)`

**Contexto:** `shared`  
**Descrição:** Registra conjunto com nome e itens. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `addset`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:addSet('default', {{ 2, 'common' }})
print('addSet:', result)
```

---

### `pr_lib.collections.selector:getAllSets()`

**Contexto:** `shared`  
**Descrição:** Consulta os conjuntos disponíveis. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getallsets`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getAllSets()
print('getAllSets:', result)
```

---

### `pr_lib.collections.selector:getRandom(setName)`

**Contexto:** `shared`  
**Descrição:** Seleciona uma entrada aleatória do conjunto indicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getrandom`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getRandom('default')
print('getRandom:', result)
```

---

### `pr_lib.collections.selector:getRandomAmount(setName, count)`

**Contexto:** `shared`  
**Descrição:** Retorna múltiplas entradas aleatórias. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getrandomamount`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getRandomAmount('default', 2)
print('getRandomAmount:', result)
```

---

### `pr_lib.collections.selector:getRandomWeighted(setName)`

**Contexto:** `shared`  
**Descrição:** Seleciona entrada conforme peso probabilístico configurado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getrandomweighted`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getRandomWeighted('default')
print('getRandomWeighted:', result)
```

---

### `pr_lib.collections.selector:getRandomWeightedAmount(setName, count)`

**Contexto:** `shared`  
**Descrição:** Retorna múltiplas entradas ponderadas. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getrandomweightedamount`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getRandomWeightedAmount('default', 2)
print('getRandomWeightedAmount:', result)
```

---

### `pr_lib.collections.selector:getSet(setName)`

**Contexto:** `shared`  
**Descrição:** Obtém um conjunto registrado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `getset`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:getSet('default')
print('getSet:', result)
```

---

### `pr_lib.collections.selector:removeSet(setName)`

**Contexto:** `shared`  
**Descrição:** Remove o conjunto indicado. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `removeset`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:removeSet('default')
print('removeSet:', result)
```

---

### `pr_lib.collections.selector:updateSet(setName, newItems)`

**Contexto:** `shared`  
**Descrição:** Substitui/atualiza os itens do conjunto. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/selector.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/selector.lua)  
**Tags:** `collections.selector` · `shared` · `collections` · `estrutura de dados` · `selector` · `updateset`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.selector:new({ { 1, 'common' }, { 3, 'rare' } })
local result = collection:updateSet('default', {{ 1, 'new' }})
print('updateSet:', result)
```

---

## collections.set

### `pr_lib.collections.set:add(value)`

**Contexto:** `shared`  
**Descrição:** Adiciona elemento ao conjunto, sem repetir. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `add`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:add(42)
print('add:', result)
```

---

### `pr_lib.collections.set:clear()`

**Contexto:** `shared`  
**Descrição:** Remove todos os elementos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `clear`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:clear()
print('clear:', result)
```

---

### `pr_lib.collections.set:difference(other)`

**Contexto:** `shared`  
**Descrição:** Calcula a diferença de conjuntos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `difference`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:difference(pr_lib.collections.set:new('b', 'c'))
print('difference:', result)
```

---

### `pr_lib.collections.set:each()`

**Contexto:** `shared`  
**Descrição:** Executa a operação 'each' da coleção set. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `each`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:each()
print('each:', result)
```

---

### `pr_lib.collections.set:equals(other)`

**Contexto:** `shared`  
**Descrição:** Compara igualdade entre os conjuntos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `equals`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:equals(pr_lib.collections.set:new('b', 'c'))
print('equals:', result)
```

---

### `pr_lib.collections.set:has(value)`

**Contexto:** `shared`  
**Descrição:** Verifica a presença do elemento/chave. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `has`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:has(42)
print('has:', result)
```

---

### `pr_lib.collections.set:intersection(other)`

**Contexto:** `shared`  
**Descrição:** Calcula valores presentes em ambos os conjuntos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `intersection`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:intersection(pr_lib.collections.set:new('b', 'c'))
print('intersection:', result)
```

---

### `pr_lib.collections.set:isEmpty()`

**Contexto:** `shared`  
**Descrição:** Verifica se a coleção está vazia. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `isempty`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:isEmpty()
print('isEmpty:', result)
```

---

