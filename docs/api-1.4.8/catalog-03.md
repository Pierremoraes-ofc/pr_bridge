# PR Bridge 1.4.8 — Catálogo de funções (volume 3/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**225 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## fivem.dui

### `pr_lib.dui.destroy(target, id)`

**Contexto:** `server`  
**Descrição:** Fecha e apaga a instância DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `destroy` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.destroy(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.get(id)`

**Contexto:** `server`  
**Descrição:** Consultas de status e instâncias de DUIs server-side.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `get` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.get('example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.list()`

**Contexto:** `server`  
**Descrição:** Consultas de status e instâncias de DUIs server-side.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `list` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.list()
print('Resultado:', result)
```

---

### `pr_lib.dui.poly(target, options)`

**Contexto:** `server`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `poly` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.poly(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.poly4(target, options)`

**Contexto:** `server`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `poly4` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.poly4(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.remove(target, id)`

**Contexto:** `server`  
**Descrição:** Fecha e apaga a instância DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `remove` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.remove(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.renderTarget(target, options)`

**Contexto:** `server`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `render` · `target` · `server` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.renderTarget(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.replaceTexture(target, options)`

**Contexto:** `server`  
**Descrição:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `replace` · `texture` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.replaceTexture(source, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.send(target, id, message)`

**Contexto:** `server`  
**Descrição:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `send` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.send(source, 'example_id', 'example')
print('Resultado:', result)
```

---

### `pr_lib.dui.sendMessage(target, id, message)`

**Contexto:** `server`  
**Descrição:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `send` · `message` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMessage(source, 'example_id', 'example')
print('Resultado:', result)
```

---

### `pr_lib.dui.setBrightness(target, id, brightness)`

**Contexto:** `server`  
**Descrição:** Controla opacidade e brilho de renderização da textura.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `set` · `brightness` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setBrightness(source, 'example_id', 1.0)
print('Resultado:', result)
```

---

### `pr_lib.dui.setOpacity(target, id, opacity)`

**Contexto:** `server`  
**Descrição:** Controla opacidade e brilho de renderização da textura.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `set` · `opacity` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setOpacity(source, 'example_id', 1.0)
print('Resultado:', result)
```

---

### `pr_lib.dui.setUrl(target, id, url)`

**Contexto:** `server`  
**Descrição:** Redireciona o navegador DUI para outro endereço web.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `set` · `url` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setUrl(source, 'example_id', 'https://example.com')
print('Resultado:', result)
```

---

### `pr_lib.dui.startSprite(target, id, options)`

**Contexto:** `server`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `start` · `sprite` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.startSprite(source, 'example_id', {})
print('Resultado:', result)
```

---

### `pr_lib.dui.stopPoly(target, id)`

**Contexto:** `server`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `stop` · `poly` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopPoly(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.stopRenderTarget(target, id)`

**Contexto:** `server`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `stop` · `render` · `target` · `server` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopRenderTarget(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.stopSprite(target, id)`

**Contexto:** `server`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `stop` · `sprite` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopSprite(source, 'example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.sync(target)`

**Contexto:** `server`  
**Descrição:** Sincroniza DUIs ativas com novos jogadores conectados que entraram no escopo.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `sync` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sync(source)
print('Retorno da operação:', result)
```

---

## fivem.gizmo

### `pr_lib.gizmo.await(entity, callback, offset, options)`

**Contexto:** `client`  
**Descrição:** aguarda a decisão dentro de uma thread. Retorna o resultado no primeiro valor quando confirmado ou no segundo valor quando cancelado.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `await` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.await(1, function(value) print('Callback:', value) end, 1, {})
print('Resultado:', result)
```

---

### `pr_lib.gizmo.cancel(reason)`

**Contexto:** `client`  
**Descrição:** encerramento programático da sessão.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `cancel` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.cancel('Exemplo do PR Bridge')
print('Resultado:', result)
```

---

### `pr_lib.gizmo.confirm(reason)`

**Contexto:** `client`  
**Descrição:** encerramento programático da sessão.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `confirm` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.confirm('Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.gizmo.getResult()`

**Contexto:** `client`  
**Descrição:** consulta o estado e o último resultado padronizado. Consulte GIZMO.md para opções, controles, resultado, movimento livre em freecam e testes de compatibilidade.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `get` · `result` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.getResult()
print('Resultado:', result)
```

---

### `pr_lib.gizmo.isActive()`

**Contexto:** `client`  
**Descrição:** consulta o estado e o último resultado padronizado. Consulte GIZMO.md para opções, controles, resultado, movimento livre em freecam e testes de compatibilidade.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `is` · `active` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.isActive()
print('Resultado:', result)
```

---

### `pr_lib.gizmo.start(entity, callback, offset, options)`

**Contexto:** `client`  
**Descrição:** mantém a assinatura legada e inicia uma sessão autocontida com NUI Svelte, câmera, bloqueio de controles, precisão, confirmação e cancelamento. O HUD Svelte é informativo e não assume foco. Todos os comandos do modo atual são exibidos no Scaleform inferior não clicável e permanecem funcionais pelos keybinds remapeáveis.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `start` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.start(1, function(value) print('Callback:', value) end, 1, {})
print('Resultado:', result)
```

---

### `pr_lib.gizmo.stop()`

**Contexto:** `client`  
**Descrição:** encerramento programático da sessão.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `stop` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.stop()
print('Retorno da operação:', result)
```

---

### `pr_lib.gizmo.use(...)`

**Contexto:** `client`  
**Descrição:** aguarda a decisão dentro de uma thread. Retorna o resultado no primeiro valor quando confirmado ou no segundo valor quando cancelado.  
**Arquivo de origem:** [`bridge/fivem/gizmo/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/gizmo/client.lua)  
**Tags:** `gizmo` · `use` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.gizmo.use()
print('Retorno da operação:', result)
```

---

## fivem.identifiers

### `pr_lib.fivem.identifiers.getAll(source)`

**Contexto:** `server`  
**Descrição:** Varre e retorna uma tabela contendo todos os identificadores conhecidos do jogador logado (discord, license, license2, steam, fivem, ip, etc.) e determina qual licença deve ser tratada como principal (primaryLicense).  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `all` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.getAll(source)
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.GetAll(source)`

**Contexto:** `server`  
**Descrição:** Varre e retorna uma tabela contendo todos os identificadores conhecidos do jogador logado (discord, license, license2, steam, fivem, ip, etc.) e determina qual licença deve ser tratada como principal (primaryLicense).  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `all` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.GetAll(source)
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.getByType(source, identifierType)`

**Contexto:** `server`  
**Descrição:** Retorna o identificador específico de conexão de rede de um jogador chamando a API nativa (ex: identifierType pode ser "license", "discord", "steam", "ip").  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `by` · `type` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.getByType(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.GetByType(source, identifierType)`

**Contexto:** `server`  
**Descrição:** Retorna o identificador específico de conexão de rede de um jogador chamando a API nativa (ex: identifierType pode ser "license", "discord", "steam", "ip").  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `by` · `type` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.GetByType(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.getLicenseSet(source, extraLicenses)`

**Contexto:** `server`  
**Descrição:** Gera uma tabela contendo as licenças normais de identificação do jogador, permitindo mesclar chaves adicionais informadas.  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `license` · `set` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.getLicenseSet(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.GetLicenseSet(source, extraLicenses)`

**Contexto:** `server`  
**Descrição:** Gera uma tabela contendo as licenças normais de identificação do jogador, permitindo mesclar chaves adicionais informadas.  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `license` · `set` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.GetLicenseSet(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.getPrimaryLicense(source)`

**Contexto:** `server`  
**Descrição:** Retorna a licença Rockstar de prioridade primária do jogador local (license2 ou license).  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `primary` · `license` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.getPrimaryLicense(source)
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.GetPrimaryLicense(source)`

**Contexto:** `server`  
**Descrição:** Retorna a licença Rockstar de prioridade primária do jogador local (license2 ou license).  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `get` · `primary` · `license` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.GetPrimaryLicense(source)
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.has(source, identifier)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador especificado possui o identificador exato informado.  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `has` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.has(source, 'license:example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.identifiers.Has(source, identifier)`

**Contexto:** `server`  
**Descrição:** Verifica se o jogador especificado possui o identificador exato informado.  
**Arquivo de origem:** [`bridge/fivem/identifiers/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/identifiers/server.lua)  
**Tags:** `identifiers` · `has` · `server`

**Exemplo de construção e uso:**

```lua
local source = 1 -- substitua pelo source real recebido no servidor
local result = pr_lib.fivem.identifiers.Has(source, 'license:example')
print('Resultado:', result)
```

---

## fivem.instructionalButtons

### `pr_lib.fivem.instructionalButtons.create(buttons, options)`

**Contexto:** `client`  
**Descrição:** Inicializa e carrega a scaleform INSTRUCTIONAL_BUTTONS na memória, desenhando de forma customizada e retornando um manipulador de instância. A tabela buttons descreve o texto (label) e a tecla/controle correspondente (ex: "~INPUT_FRONTEND_ACCEPT~").  
**Arquivo de origem:** [`bridge/fivem/instructionalButtons/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/instructionalButtons/client.lua)  
**Tags:** `instructional` · `buttons` · `create` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.instructionalButtons.create('example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.instructionalButtons.show(buttons, options)`

**Contexto:** `client`  
**Descrição:** Cria e exibe dinamicamente o painel de botões na tela por um tempo limitado ou até que o jogador pressione uma tecla. Retorna se o usuário interagiu com algum botão.  
**Arquivo de origem:** [`bridge/fivem/instructionalButtons/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/instructionalButtons/client.lua)  
**Tags:** `instructional` · `buttons` · `show` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.instructionalButtons.show('example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.instructionalButtons.showClickable(label, control, controlId, options)`

**Contexto:** `client`  
**Descrição:** Cria um botão modal com interação direta pelo mouse. Durante a seleção, libera o foco de qualquer NUI Chromium, mantém o Scaleform estável entre os frames e retorna pressed, o botão selecionado e o controlId.  
**Arquivo de origem:** [`bridge/fivem/instructionalButtons/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/instructionalButtons/client.lua)  
**Tags:** `instructional` · `buttons` · `show` · `clickable` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.instructionalButtons.showClickable('example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.instructionalButtons.showSimple(label, control, options)`

**Contexto:** `client`  
**Descrição:** Exibe de forma rápida e simplificada um único botão informativo no canto da tela (ex: *"Confirmar"* associado ao botão enter).  
**Arquivo de origem:** [`bridge/fivem/instructionalButtons/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/instructionalButtons/client.lua)  
**Tags:** `instructional` · `buttons` · `show` · `simple` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.instructionalButtons.showSimple('example', 'example', {})
print('Resultado:', result)
```

---

## fivem.net

### `pr_lib.fivem.net.getEntity(netId, timeout)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `get` · `entity` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getEntity(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getNetId(entity)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `get` · `id` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getNetId(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `get` · `owner` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getOwner(PlayerPedId(), 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getVehicle(netId, timeout)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `get` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getVehicle(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.isValidNetId(netId)`

**Contexto:** `client`  
**Descrição:** Verifica os dados ou a operação “is valid net id” e retorna o estado correspondente.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `is` · `valid` · `id` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.isValidNetId(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “resolve vehicle” por meio da API pública do módulo `fivem.net`.  
**Arquivo de origem:** [`bridge/fivem/net/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/client.lua)  
**Tags:** `net` · `resolve` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.resolveVehicle(PlayerPedId(), 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getEntity(netId, timeout)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `get` · `entity` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getEntity(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getNetId(entity)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `get` · `id` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getNetId(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `get` · `owner` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getOwner(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.getVehicle(netId, timeout)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `get` · `vehicle` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.getVehicle(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.isValidNetId(netId)`

**Contexto:** `server`  
**Descrição:** Verifica os dados ou a operação “is valid net id” e retorna o estado correspondente.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `is` · `valid` · `id` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.isValidNetId(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “resolve vehicle” por meio da API pública do módulo `fivem.net`.  
**Arquivo de origem:** [`bridge/fivem/net/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/net/server.lua)  
**Tags:** `net` · `resolve` · `vehicle` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.net.resolveVehicle(0, 1)
print('Resultado:', result)
```

---

## fivem.objects

### `pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `find` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `find` · `in` · `radius` · `using` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findObjectsInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `find` · `vehicles` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `vehicle`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findVehiclesInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `find` · `vehicles` · `in` · `radius` · `using` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`

**Contexto:** `client`  
**Descrição:** Congela ou descongela a física de todas as entidades de determinado modelo 3D que estão dentro daquele raio.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `freeze` · `by` · `model` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.freezeByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Busca entidades filtradas por modelo específico e proximidade geográfica.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `by` · `model` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `by` · `pool` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getByPoolInRadius('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Busca entidades filtradas por modelo específico e proximidade geográfica.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `closest` · `by` · `model` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `closest` · `from` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestFromPool('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestObject(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `closest` · `object` · `client` · `obj` · `objeto` · `objetos` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestObject(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `closest` · `vehicle` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestVehicle(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `closest` · `vehicle` · `by` · `model` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestVehicleByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `networked` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getNetworkedObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `by` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsByPool('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `in` · `radius` · `using` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata peds (NPCs) próximos.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `peds` · `by` · `model` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPedsByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Resgata peds (NPCs) próximos.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `peds` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPedsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza pickups físicas de armas e colecionáveis do mundo GTA.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `pickups` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPickupsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPool(poolName)`

**Contexto:** `client`  
**Descrição:** Retorna entidades registradas no pool interno do FiveM.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPool('CVehicle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `pool` · `by` · `model` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolByModelInRadius('CVehicle', 'example', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `pool` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolInRadius('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolName(poolName)`

**Contexto:** `client`  
**Descrição:** Retorna entidades registradas no pool interno do FiveM.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `pool` · `name` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolName('CVehicle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `vehicles` · `by` · `model` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `vehicles` · `in` · `radius` · `client` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `vehicle`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/client.lua)  
**Tags:** `objects` · `get` · `vehicles` · `in` · `radius` · `using` · `pool` · `client` · `obj` · `objeto` · `objetos` · `object` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `find` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `find` · `in` · `radius` · `using` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findObjectsInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `find` · `vehicles` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `vehicle`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findVehiclesInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `find` · `vehicles` · `in` · `radius` · `using` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`

**Contexto:** `server`  
**Descrição:** Congela ou descongela a física de todas as entidades de determinado modelo 3D que estão dentro daquele raio.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `freeze` · `by` · `model` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.freezeByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, false)
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Busca entidades filtradas por modelo específico e proximidade geográfica.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `by` · `model` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `by` · `pool` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getByPoolInRadius('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Busca entidades filtradas por modelo específico e proximidade geográfica.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `closest` · `by` · `model` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `closest` · `from` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestFromPool('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestObject(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `closest` · `object` · `server` · `obj` · `objeto` · `objetos` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestObject(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `closest` · `vehicle` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestVehicle(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `closest` · `vehicle` · `by` · `model` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getClosestVehicleByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `networked` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getNetworkedObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `by` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsByPool('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `in` · `radius` · `using` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getObjectsInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata peds (NPCs) próximos.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `peds` · `by` · `model` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPedsByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Resgata peds (NPCs) próximos.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `peds` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPedsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza pickups físicas de armas e colecionáveis do mundo GTA.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `pickups` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPickupsInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPool(poolName)`

**Contexto:** `server`  
**Descrição:** Retorna entidades registradas no pool interno do FiveM.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPool('CVehicle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `pool` · `by` · `model` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolByModelInRadius('CVehicle', 'example', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `pool` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolInRadius('CVehicle', 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getPoolName(poolName)`

**Contexto:** `server`  
**Descrição:** Retorna entidades registradas no pool interno do FiveM.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `pool` · `name` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getPoolName('CVehicle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `vehicles` · `by` · `model` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `vehicles` · `in` · `radius` · `server` · `obj` · `objeto` · `objetos` · `object` · `pool` · `entidade` · `veículo` · `vehicle`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.  
**Arquivo de origem:** [`bridge/fivem/objects/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/objects/server.lua)  
**Tags:** `objects` · `get` · `vehicles` · `in` · `radius` · `using` · `pool` · `server` · `obj` · `objeto` · `objetos` · `object` · `entidade` · `veículo`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

## fivem.raycast

### `pr_lib.raycast.cam(flags, ignoreFlags, distance)`

**Contexto:** `client`  
**Descrição:** Atalho de raycast a partir da câmera usando a camada FiveM do bridge.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.raycast.cam(false, false, false)
print('Resultado:', result)
```

---

### `pr_lib.raycast.fromCamera(distance, flags, ignoreFlags, ignoreEntity)`

**Contexto:** `client`  
**Descrição:** Projeta um feixe de raycast tridimensional invisível a partir da câmera do jogador na direção de foco da mira até a distância máxima informada. Retorna se atingiu algo, as coordenadas de impacto, o vetor normal e a ID da entidade atingida (veículo, ped ou objeto).  
**Arquivo de origem:** [`bridge/fivem/raycast/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/raycast/client.lua)  
**Tags:** `raycast` · `from` · `camera` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.raycast.fromCamera(false, false, false, false)
print('Resultado:', result)
```

---

### `pr_lib.raycast.FromCamera(distance, flags, ignoreFlags, ignoreEntity)`

**Contexto:** `client`  
**Descrição:** Projeta um feixe de raycast tridimensional invisível a partir da câmera do jogador na direção de foco da mira até a distância máxima informada. Retorna se atingiu algo, as coordenadas de impacto, o vetor normal e a ID da entidade atingida (veículo, ped ou objeto).  
**Arquivo de origem:** [`bridge/fivem/raycast/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/raycast/client.lua)  
**Tags:** `raycast` · `from` · `camera` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.raycast.FromCamera(false, false, false, false)
print('Resultado:', result)
```

---

### `pr_lib.raycast.fromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`

**Contexto:** `client`  
**Descrição:** Dispara um feixe de raycast a partir de coordenadas absolutas de origem (origin) para um destino (destination).  
**Arquivo de origem:** [`bridge/fivem/raycast/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/raycast/client.lua)  
**Tags:** `raycast` · `from` · `coords` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.raycast.fromCoords('example', 'example', false, false, false)
print('Resultado:', result)
```

---

### `pr_lib.raycast.FromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`

**Contexto:** `client`  
**Descrição:** Dispara um feixe de raycast a partir de coordenadas absolutas de origem (origin) para um destino (destination).  
**Arquivo de origem:** [`bridge/fivem/raycast/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/raycast/client.lua)  
**Tags:** `raycast` · `from` · `coords` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.raycast.FromCoords('example', 'example', false, false, false)
print('Resultado:', result)
```

---

## fivem.streaming

### `pr_lib.fivem.streaming.configureEntity(entity, options)`

**Contexto:** `client`  
**Descrição:** Aplica opções de físicas, colisões, congelamento e persistência na entidade.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `configure` · `entity` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.configureEntity(PlayerPedId(), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.createEntity(placementType, model, coords, heading, options)`

**Contexto:** `client`  
**Descrição:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `create` · `entity` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.createEntity('example', 'example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.createObject(model, coords, options)`

**Contexto:** `client`  
**Descrição:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `create` · `object` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.createObject('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.createPed(model, coords, heading, options)`

**Contexto:** `client`  
**Descrição:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `create` · `ped` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.createPed('example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.createProp(model, coords, options)`

**Contexto:** `client`  
**Descrição:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `create` · `prop` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.createProp('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.createVehicle(model, coords, heading, options)`

**Contexto:** `client`  
**Descrição:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `create` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.createVehicle('example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.delete(entity)`

**Contexto:** `client`  
**Descrição:** Apaga uma entidade (ped, veículo ou objeto) local liberando memória.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `delete` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.delete(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.deleteEntity(entity)`

**Contexto:** `client`  
**Descrição:** Apaga uma entidade (ped, veículo ou objeto) local liberando memória.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `delete` · `entity` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.deleteEntity(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.findGroundZ(coords, options)`

**Contexto:** `client`  
**Descrição:** Varre verticalmente o mapa para obter as coordenadas Z precisas do solo abaixo da posição indicada.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `find` · `ground` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.findGroundZ(vector3(0.0, 0.0, 0.0), {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.getModelDimensions(model, timeout)`

**Contexto:** `client`  
**Descrição:** Retorna as dimensões de bounding box (mínimo e máximo) do modelo especificado.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `get` · `model` · `dimensions` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.getModelDimensions('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.getModelGroundOffset(model, timeout)`

**Contexto:** `client`  
**Descrição:** Calcula a compensação de altura vertical necessária para posicionar o objeto rente ao chão.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `get` · `model` · `ground` · `offset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.getModelGroundOffset('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.loadAnimDict(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `load` · `anim` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.loadAnimDict('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.loadWeaponAsset(model, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega modelos de armas de fogo nativas e suas propriedades.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `load` · `weapon` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.loadWeaponAsset('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.performAction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `perform` · `action` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.performAction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.PerformAction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `perform` · `action` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.PerformAction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.placeEntityProperly(entity, placementType, options)`

**Contexto:** `client`  
**Descrição:** Ajusta a altura e rotação de uma entidade para que ela fique alinhada corretamente com a superfície do solo.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `place` · `entity` · `properly` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.placeEntityProperly(PlayerPedId(), 'default', {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.playAction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `action` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.playAction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.PlayAction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `action` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.PlayAction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.playAnim(data, clip, duration, options)`

**Contexto:** `client`  
**Descrição:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `anim` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.playAnim({}, 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.PlayAnim(data, clip, duration, options)`

**Contexto:** `client`  
**Descrição:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `anim` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.PlayAnim({}, 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.playAnimation(data, clip, duration, options)`

**Contexto:** `client`  
**Descrição:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `animation` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.playAnimation({}, 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.PlayAnimation(data, clip, duration, options)`

**Contexto:** `client`  
**Descrição:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `animation` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.PlayAnimation({}, 'example', 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.playInteraction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `interaction` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.playInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.PlayInteraction(data)`

**Contexto:** `client`  
**Descrição:** APIs utilitárias para acionar ações cinemáticas combinadas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `play` · `interaction` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.PlayInteraction({})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.releaseAnimDict(animDict)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `anim` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseAnimDict({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.releaseAnimSet(animSet)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `anim` · `set` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseAnimSet('example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.releaseAudioBank(audioBank)`

**Contexto:** `client`  
**Descrição:** Carrega pacotes de efeitos sonoros e áudios nativos.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `audio` · `bank` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseAudioBank('example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.releaseModel(model)`

**Contexto:** `client`  
**Descrição:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `model` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseModel('prop_ld_flow_bottle')
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.releasePtfxAsset(asset)`

**Contexto:** `client`  
**Descrição:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `ptfx` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releasePtfxAsset('example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.releaseScaleformMovie(handle)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `scaleform` · `movie` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseScaleformMovie(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.releaseTextureDict(textureDict)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo texturas e imagens nativas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `texture` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseTextureDict('Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.releaseWeaponAsset(model)`

**Contexto:** `client`  
**Descrição:** Carrega modelos de armas de fogo nativas e suas propriedades.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `release` · `weapon` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.releaseWeaponAsset('prop_ld_flow_bottle')
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.streaming.requestAnimDict(animDict, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `anim` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestAnimDict({}, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestAnimDict(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `anim` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestAnimDict('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestAnimSet(animSet, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `anim` · `set` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestAnimSet('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestAnimSet(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `anim` · `set` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestAnimSet('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestAudioBank(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega pacotes de efeitos sonoros e áudios nativos.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `audio` · `bank` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestAudioBank('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestAudioBank(audioBank, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega pacotes de efeitos sonoros e áudios nativos.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `audio` · `bank` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestAudioBank('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestModel(model, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `model` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestModel('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestModel(model, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `model` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestModel('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestNamedPtfxAsset(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `named` · `ptfx` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestNamedPtfxAsset('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestPtfxAsset(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `ptfx` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestPtfxAsset('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestScaleformMovie(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `scaleform` · `movie` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestScaleformMovie('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestScaleformMovie(name, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `scaleform` · `movie` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestScaleformMovie('example:action', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.RequestStreamedTextureDict(asset, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo texturas e imagens nativas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `streamed` · `texture` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.RequestStreamedTextureDict('example', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestTextureDict(textureDict, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega dicionários contendo texturas e imagens nativas.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `texture` · `dict` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestTextureDict('Exemplo do PR Bridge', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.requestWeaponAsset(model, timeout)`

**Contexto:** `client`  
**Descrição:** Carrega modelos de armas de fogo nativas e suas propriedades.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `request` · `weapon` · `asset` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.requestWeaponAsset('prop_ld_flow_bottle', 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.setEntityTransform(entity, coords, heading, options)`

**Contexto:** `client`  
**Descrição:** Atualiza a posição e o ângulo horizontal de uma entidade de forma sincronizada.  
**Arquivo de origem:** [`bridge/fivem/streaming/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/client.lua)  
**Tags:** `streaming` · `set` · `entity` · `transform` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.setEntityTransform(1, 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.streaming.hash(model)`

**Contexto:** `server`  
**Descrição:** Retorna o hash numérico de um modelo 3D.  
**Arquivo de origem:** [`bridge/fivem/streaming/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/streaming/server.lua)  
**Tags:** `streaming` · `hash` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.streaming.hash('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

## fivem.tuning

### `pr_lib.fivem.tuning.apply(vehicle, props, options)`

**Contexto:** `client`  
**Descrição:** Aplica modificações físicas, cores e upgrades no veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `apply` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.apply(PlayerPedId(), {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.tuning.applyNetId(netId, props, options)`

**Contexto:** `client`  
**Descrição:** Envia comando para que clientes apliquem propriedades em um veículo baseado na sua ID de rede.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `apply` · `net` · `id` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.applyNetId(0, 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.get(vehicle)`

**Contexto:** `client`  
**Descrição:** Retorna uma tabela contendo todas as propriedades de customizações, modificações mecânicas, cores e níveis de integridade do veículo correspondente.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `get` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.get(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.repair(vehicle)`

**Contexto:** `client`  
**Descrição:** Conserta visualmente e mecanicamente o motor, carroceria e pneus do veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `repair` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.repair(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`

**Contexto:** `client`  
**Descrição:** Restaura o estado do veículo a partir de um snapshot salvo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `restore` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.restore('example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.setExtra(vehicle, extraId, state)`

**Contexto:** `client`  
**Descrição:** Ativa ou remove extras e acessórios nativos de carroceria instalados no veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `extra` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setExtra('example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.setFuel(vehicle, fuelLevel)`

**Contexto:** `client`  
**Descrição:** Altera diretamente o nível físico de combustível do motor do veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `fuel` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setFuel('example', 75.0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.setMod(vehicle, modType, modIndex, customTires)`

**Contexto:** `client`  
**Descrição:** Altera peças de modificação mecânica (como Motor, Transmissão, Suspensão) ou visual (aerofólios, capôs).  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `mod` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setMod('example', 'example', 1, 'example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.setNeon(vehicle, enabled, color)`

**Contexto:** `client`  
**Descrição:** Configura luzes de neons instaladas embaixo do chassi do veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `neon` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setNeon('example', false, '#ffffff')
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.setPlate(vehicle, plate)`

**Contexto:** `client`  
**Descrição:** Modifica a string exibida na placa física do veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `plate` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setPlate(PlayerPedId(), 'ABC1234')
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.tuning.setXenon(vehicle, enabled, color)`

**Contexto:** `client`  
**Descrição:** Configura faróis de Xenon e tonalidades de cores nos faróis do veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `set` · `xenon` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.setXenon('example', false, '#ffffff')
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.snapshot(vehicle)`

**Contexto:** `client`  
**Descrição:** Retorna tabela vazia para stubs do servidor.  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `snapshot` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.snapshot(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.toggleMod(vehicle, modType, state)`

**Contexto:** `client`  
**Descrição:** Liga ou desliga modificações de performance específicas (como Turbo).  
**Arquivo de origem:** [`bridge/fivem/tuning/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/client.lua)  
**Tags:** `tuning` · `toggle` · `mod` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.toggleMod(PlayerPedId(), 'default', false)
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.tuning.apply(vehicle, props, options)`

**Contexto:** `server`  
**Descrição:** Aplica modificações físicas, cores e upgrades no veículo.  
**Arquivo de origem:** [`bridge/fivem/tuning/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/server.lua)  
**Tags:** `tuning` · `apply` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.apply(0, {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.tuning.applyNetId(netId, props, target, options)`

**Contexto:** `server`  
**Descrição:** Envia comando para que clientes apliquem propriedades em um veículo baseado na sua ID de rede.  
**Arquivo de origem:** [`bridge/fivem/tuning/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/server.lua)  
**Tags:** `tuning` · `apply` · `net` · `id` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.applyNetId(0, 'example', source, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`

**Contexto:** `server`  
**Descrição:** Restaura o estado do veículo a partir de um snapshot salvo.  
**Arquivo de origem:** [`bridge/fivem/tuning/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/server.lua)  
**Tags:** `tuning` · `restore` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.restore('example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.tuning.snapshot()`

**Contexto:** `server`  
**Descrição:** Retorna tabela vazia para stubs do servidor.  
**Arquivo de origem:** [`bridge/fivem/tuning/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/tuning/server.lua)  
**Tags:** `tuning` · `snapshot` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.tuning.snapshot()
print('Resultado:', result)
```

---

## fivem.ui

### `pr_lib.setClipboard(value)`

**Contexto:** `client`  
**Descrição:** Define ou atualiza os dados ou a operação “set clipboard” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `set` · `clipboard` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.setClipboard({})
print('Retorno da operação:', result)
```

---

### `pr_lib.ui.draw2DText(text, x, y, scale, textColor, font)`

**Contexto:** `client`  
**Descrição:** Desenha na tela do jogador textos em coordenadas bidimensionais de proporção decimal (de 0.0 a 1.0).  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw2` · `dtext` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.draw2DText(1, 0.0, 0.0, 1.0, '#ffffff', 0)
print('Resultado:', result)
```

---

### `pr_lib.ui.Draw2DText(text, x, y, scale, textColor, font)`

**Contexto:** `client`  
**Descrição:** Desenha na tela do jogador textos em coordenadas bidimensionais de proporção decimal (de 0.0 a 1.0).  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw2` · `dtext` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.Draw2DText(1, 0.0, 0.0, 1.0, '#ffffff', 0)
print('Resultado:', result)
```

---

### `pr_lib.ui.draw3DText(text, coords, scale, textColor, font)`

**Contexto:** `client`  
**Descrição:** Desenha textos flutuantes projetados no mundo físico tridimensional em coordenadas GPS.  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw3` · `dtext` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.draw3DText(1, 'example', 1.0, '#ffffff', 0)
print('Resultado:', result)
```

---

### `pr_lib.ui.Draw3DText(text, coords, scale, textColor, font)`

**Contexto:** `client`  
**Descrição:** Desenha textos flutuantes projetados no mundo físico tridimensional em coordenadas GPS.  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw3` · `dtext` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.Draw3DText(1, 'example', 1.0, '#ffffff', 0)
print('Resultado:', result)
```

---

### `pr_lib.ui.drawRect(x, y, width, height, rectColor)`

**Contexto:** `client`  
**Descrição:** Desenha retângulos bidimensionais coloridos na HUD da tela do jogador local.  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw` · `rect` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.drawRect(0.0, 0.0, 200, 100, { 255, 255, 255, 255 })
print('Resultado:', result)
```

---

### `pr_lib.ui.DrawRect(x, y, width, height, rectColor)`

**Contexto:** `client`  
**Descrição:** Desenha retângulos bidimensionais coloridos na HUD da tela do jogador local.  
**Arquivo de origem:** [`bridge/fivem/ui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/ui/client.lua)  
**Tags:** `ui` · `draw` · `rect` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.ui.DrawRect(0.0, 0.0, 200, 100, { 255, 255, 255, 255 })
print('Resultado:', result)
```

---

## fivem.vehicleCache

### `pr_lib.fivem.vehicleCache.clear(vehicleOrNetId)`

**Contexto:** `shared`  
**Descrição:** Apaga o cache do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `clear` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.clear(PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleCache.clearAll()`

**Contexto:** `shared`  
**Descrição:** Limpa todo o cache de veículos na memória RAM do recurso.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `clear` · `all` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.clearAll()
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleCache.get(vehicleOrNetId)`

**Contexto:** `shared`  
**Descrição:** Retorna as informações em cache registradas para a ID da entidade do veículo ou ID de rede.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `get` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.get(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.getByPlate(plate)`

**Contexto:** `shared`  
**Descrição:** Recupera dados do veículo pesquisando pela sua placa de identificação.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `get` · `by` · `plate` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.getByPlate('ABC1234')
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.getPersistentMeta(vehicle)`

**Contexto:** `shared`  
**Descrição:** Obtém ou grava metadados persistentes que sobrevivem ao respawn do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `get` · `persistent` · `meta` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.getPersistentMeta(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.getState(vehicle, name)`

**Contexto:** `shared`  
**Descrição:** Consulta uma propriedade do State Bag (estado persistido de rede do FiveM) registrado no veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `get` · `state` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.getState(PlayerPedId(), 'example:action')
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.getStateKey(name)`

**Contexto:** `shared`  
**Descrição:** Gera a string do caminho da chave de estado.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `get` · `state` · `key` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.getStateKey('example:action')
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.set(vehicleOrNetId, data)`

**Contexto:** `shared`  
**Descrição:** Salva dados customizados no cache persistente do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `set` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.set(PlayerPedId(), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleCache.setPersistentMeta(vehicle, meta)`

**Contexto:** `shared`  
**Descrição:** Obtém ou grava metadados persistentes que sobrevivem ao respawn do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `set` · `persistent` · `meta` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.setPersistentMeta('example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleCache.setState(vehicle, name, value, replicated)`

**Contexto:** `shared`  
**Descrição:** Altera uma propriedade no State Bag do veículo, controlando se ela deve ser replicada para outros clientes.  
**Arquivo de origem:** [`bridge/fivem/vehicleCache/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleCache/shared.lua)  
**Tags:** `vehicle` · `cache` · `set` · `state` · `shared` · `invalidação` · `estado` · `memória` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleCache.setState('example', 'example', {}, 'example')
print('Resultado:', result)
```

---

## fivem.vehicleProperties

### `pr_lib.fivem.getVehicleProperties(vehicle)`

**Contexto:** `client`  
**Descrição:** Alias de compatibilidade para vehicleProperties.get.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `get` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.getVehicleProperties(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.setVehicleProperties(vehicle, props)`

**Contexto:** `client`  
**Descrição:** Alias de compatibilidade para vehicleProperties.set.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `set` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.setVehicleProperties(PlayerPedId(), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicleProperties.get(vehicle)`

**Contexto:** `client`  
**Descrição:** Obtém a tabela completa contendo as propriedades estéticas e mecânicas instaladas no veículo (compatível com ESX/QBCore).  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `get` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.get(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.vehicleProperties.GetVehicleProperties(vehicle)`

**Contexto:** `client`  
**Descrição:** Obtém a tabela completa contendo as propriedades estéticas e mecânicas instaladas no veículo (compatível com ESX/QBCore).  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `get` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.GetVehicleProperties(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.vehicleProperties.set(vehicle, props, fixVehicle)`

**Contexto:** `client`  
**Descrição:** Modifica as propriedades físicas gerais de customização de um veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `set` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.set(PlayerPedId(), {}, PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, fixVehicle)`

**Contexto:** `client`  
**Descrição:** Modifica as propriedades físicas gerais de customização de um veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/client.lua)  
**Tags:** `vehicle` · `properties` · `set` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.SetVehicleProperties(PlayerPedId(), {}, PlayerPedId())
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.setVehicleProperties(vehicle, props, options)`

**Contexto:** `server`  
**Descrição:** Alias de compatibilidade para vehicleProperties.set.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/server.lua)  
**Tags:** `vehicle` · `properties` · `set` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.setVehicleProperties(0, {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicleProperties.set(vehicle, props, options)`

**Contexto:** `server`  
**Descrição:** Modifica as propriedades físicas gerais de customização de um veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/server.lua)  
**Tags:** `vehicle` · `properties` · `set` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.set(0, {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.vehicleProperties.setNetId(netId, props, target, options)`

**Contexto:** `server`  
**Descrição:** Aplica propriedades sincronizadas via rede utilizando a ID de rede do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/server.lua)  
**Tags:** `vehicle` · `properties` · `set` · `net` · `id` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.setNetId(0, 'example', source, {})
print('Resultado:', result)
```

---

### `pr_lib.vehicleProperties.SetNetIdProperties(netId, props, target, options)`

**Contexto:** `server`  
**Descrição:** Aplica propriedades sincronizadas via rede utilizando a ID de rede do veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/server.lua)  
**Tags:** `vehicle` · `properties` · `set` · `net` · `id` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.SetNetIdProperties(0, 'example', source, {})
print('Resultado:', result)
```

---

### `pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, options)`

**Contexto:** `server`  
**Descrição:** Modifica as propriedades físicas gerais de customização de um veículo.  
**Arquivo de origem:** [`bridge/fivem/vehicleProperties/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleProperties/server.lua)  
**Tags:** `vehicle` · `properties` · `set` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.vehicleProperties.SetVehicleProperties(0, {}, {})
print('Retorno da operação:', result)
```

---

## fivem.vehicleState

### `pr_lib.fivem.vehicleState.channel(name, defaults)`

**Contexto:** `shared`  
**Descrição:** cria canal isolado com opções padrão. Estão pré-cadastrados mileage, keys, fueltech, suspension e dynamo.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `channel` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.channel('example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.clearWatchers()`

**Contexto:** `shared`  
**Descrição:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `clear` · `watchers` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.clearWatchers()
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleState.get(entity, channel, key, options)`

**Contexto:** `shared`  
**Descrição:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `get` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.get(1, 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.getMetrics()`

**Contexto:** `shared`  
**Descrição:** retorna leituras, escritas, rejeições, payloads excessivos, duplicatas, rate limits e handlers.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `get` · `metrics` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.getMetrics()
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.props.link(prop, vehicle, data, options)`

**Contexto:** `shared`  
**Descrição:** registra vínculo compacto do prop de rede com o netId do veículo pai. Opções suportadas  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `props` · `link` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.props.link('example', 'example', {}, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.registerChannel(name, defaults)`

**Contexto:** `shared`  
**Descrição:** cria canal isolado com opções padrão. Estão pré-cadastrados mileage, keys, fueltech, suspension e dynamo.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `register` · `channel` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.registerChannel('example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.remove(...)`

**Contexto:** `shared`  
**Descrição:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `remove` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.remove()
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleState.set(...)`

**Contexto:** `shared`  
**Descrição:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `set` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.set()
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicleState.setMany(entity, channel, values, options)`

**Contexto:** `shared`  
**Descrição:** valida todo o lote antes de gravá-lo.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `set` · `many` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.setMany(1, 'example', {}, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.snapshot(entity, channel, keys, options)`

**Contexto:** `shared`  
**Descrição:** retorna somente a lista explícita de chaves solicitadas.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `snapshot` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.snapshot(1, 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.unwatch(id)`

**Contexto:** `shared`  
**Descrição:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `unwatch` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.unwatch('example_id')
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.update(entity, channel, key, updater, options)`

**Contexto:** `shared`  
**Descrição:** altera um valor a partir do valor atual.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `update` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.update(1, 'example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.wait(entity, channel, key, predicate, timeout, options)`

**Contexto:** `shared`  
**Descrição:** aguarda valor esperado ou predicado sem loop de frame.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `wait` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.wait(1, 'example', 'example', function(value) print('Callback:', value) end, 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.watch(entity, channel, key, callback, options)`

**Contexto:** `shared`  
**Descrição:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `watch` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.watch(1, 'example', 'example', function(value) print('Callback:', value) end, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicleState.watchAny(channel, key, callback, options)`

**Contexto:** `shared`  
**Descrição:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.  
**Arquivo de origem:** [`bridge/fivem/vehicleState/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/vehicleState/shared.lua)  
**Tags:** `vehicle` · `state` · `watch` · `any` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicleState.watchAny('example', 'example', function(value) print('Callback:', value) end, {})
print('Resultado:', result)
```

---

## framework

### `pr_lib.framework.GetAccountBalance(account)`

**Contexto:** `client`  
**Descrição:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `account` · `balance` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetAccountBalance('cash')
print('Resultado:', result)
```

---

### `pr_lib.framework.getCharacterName()`

**Contexto:** `client`  
**Descrição:** Retorna o nome RP do personagem local.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `character` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.getCharacterName()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetClosestPlayer()`

**Contexto:** `client`  
**Descrição:** Retorna o ID da entidade ped e o ID de rede do jogador mais próximo do personagem local.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `closest` · `player` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetClosestPlayer()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetClosestVehicle()`

**Contexto:** `client`  
**Descrição:** Retorna o ID da entidade do veículo mais próximo.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `closest` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetClosestVehicle()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetItemCount(itemName, metadata, strict)`

**Contexto:** `client`  
**Descrição:** Retorna a contagem exata daquele item no inventário.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `item` · `count` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetItemCount('example', {}, false)
print('Resultado:', result)
```

---

### `pr_lib.framework.GetJobInfo()`

**Contexto:** `client`  
**Descrição:** Utilitários locais para resgatar dados do personagem sincronizados com o framework.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `job` · `info` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetJobInfo()
print('Resultado:', result)
```

---

### `pr_lib.framework.GetMoney(account)`

**Contexto:** `client`  
**Descrição:** Retorna o saldo financeiro do personagem local.  
**Arquivo de origem:** [`bridge/framework_normalizer.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/framework_normalizer.lua)  
**Tags:** `framework` · `get` · `money` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.framework.GetMoney('cash')
print('Resultado:', result)
```

---

