# PR Bridge — Catálogo detalhado de funções

> Auditoria consolidada em 2026-09-03 a partir dos módulos Lua ativos, `API_FUNCTIONS.md`, do catálogo anterior e dos complementos técnicos.

Este documento contém **967 entradas por assinatura/contexto** e **820 caminhos funcionais únicos**. A mesma função pode aparecer em client e server quando os contratos ou a autoridade forem diferentes.

Caminhos com `*` ou `{client,server}` representam famílias de adapters selecionadas em tempo de execução.

## Como localizar uma função

Pesquise pelo caminho completo (`pr_lib...`), nome final, tag ou diretório. Todas as entradas usam Function, Detail, Related/Dependents, Directory, Context e Tags.

## Cobertura funcional encontrada

| Área | Estado encontrado | Evidência principal |
|---|:---:|---|
| Cache e invalidação | Implementado + teste | `bridge/cache/`, `tests/cache_shared_test.lua`, `pr_scriptTest/client.lua` |
| Target | Implementado + teste | `bridge/targets/`, `tests/target_native_test.lua`, `pr_scriptTest/client_target_hydrants.lua` |
| Interact | Implementado + teste | `bridge/interact/`, `tests/interact_native_test.lua`, `pr_scriptTest/client_interact_trunk.lua` |
| Foco NUI, mouse e fechamento | Implementado + exemplos | `interface/client/`, DUI, Gizmo e testes do `pr_scriptTest` |
| Input dialog e notify | Implementado + exemplos | `interface/client/modules/input.lua`, `notify.lua` e testes do `pr_scriptTest` |
| Progress bar e skill check | Implementado + comandos | `pr_scriptTest/client_progress.lua`, `client_skillcheck.lua`, `client_ox_compat_phase1.lua` |
| Registro, remoção e restart | Implementado nos módulos críticos | target/interact, cleanup ox e matriz de callbacks |
| Matriz de callbacks | Implementado + homologado | `pr_scriptTest/client_callback_matrix.lua`, `server_callback_matrix.lua` |

## Índice por módulo

| Módulo | Entradas |
|---|---:|
| [`core`](#core) | 13 |
| [`locale`](#locale) | 8 |
| [`cache`](#cache) | 28 |
| [`debug`](#debug) | 9 |
| [`events`](#events) | 1 |
| [`framework`](#framework) | 109 |
| [`inventory`](#inventory) | 111 |
| [`notification`](#notification) | 11 |
| [`alert`](#alert) | 1 |
| [`menu`](#menu) | 22 |
| [`interface`](#interface) | 2 |
| [`textui_adapter`](#textui-adapter) | 8 |
| [`input`](#input) | 1 |
| [`target`](#target) | 50 |
| [`phone`](#phone) | 18 |
| [`progressbar`](#progressbar) | 4 |
| [`minigame`](#minigame) | 6 |
| [`weather`](#weather) | 2 |
| [`database`](#database) | 45 |
| [`fuel`](#fuel) | 3 |
| [`vehicle_key`](#vehicle-key) | 26 |
| [`banking`](#banking) | 10 |
| [`callback`](#callback) | 16 |
| [`ace`](#ace) | 24 |
| [`addcommand`](#addcommand) | 14 |
| [`addkeybind`](#addkeybind) | 3 |
| [`translator`](#translator) | 8 |
| [`github`](#github) | 3 |
| [`utils`](#utils) | 7 |
| [`math`](#math) | 41 |
| [`table`](#table) | 16 |
| [`ids`](#ids) | 2 |
| [`fivem.raycast`](#fivemraycast) | 4 |
| [`fivem.net`](#fivemnet) | 12 |
| [`fivem.ui`](#fivemui) | 7 |
| [`fivem.dui`](#fivemdui) | 60 |
| [`fivem.tuning`](#fivemtuning) | 17 |
| [`fivem.drawtext`](#fivemdrawtext) | 17 |
| [`fivem.vehicleProperties`](#fivemvehicleproperties) | 11 |
| [`fivem.streaming`](#fivemstreaming) | 49 |
| [`fivem.objects`](#fivemobjects) | 52 |
| [`fivem.vehicleCache`](#fivemvehiclecache) | 10 |
| [`fivem.blips`](#fivemblips) | 20 |
| [`fivem.identifiers`](#fivemidentifiers) | 10 |
| [`fivem.instructionalButtons`](#fiveminstructionalbuttons) | 4 |
| [`fivem.devtools`](#fivemdevtools) | 18 |
| [`fivem.aliases`](#fivemaliases) | 25 |
| [`fivem.vehicleState`](#fivemvehiclestate) | 15 |
| [`fivem.gizmo`](#fivemgizmo) | 8 |
| [`string`](#string) | 1 |
| [`timer`](#timer) | 1 |
| [`entities`](#entities) | 4 |

---

## core

### Function: **`pr_lib.checkDependency(resource, minimumVersion, printMessage)`**

**Detail:** Verifica se outro recurso dependência está rodando no servidor e se a versão instalada atende à restrição de versão mínima informada.

**Related/Dependents:** `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, check, dependency, shared

---

### Function: **`pr_lib.deleteJson(path)`**

**Detail:** Remove fisicamente o arquivo JSON correspondente ao caminho especificado.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, delete, json, shared

---

### Function: **`pr_lib.jsonExists(path)`**

**Detail:** Verifica de forma rápida a existência física de um arquivo no caminho JSON informado.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, json, exists, shared

---

### Function: **`pr_lib.load(path, env, optional)`**

**Detail:** Carrega e executa dinamicamente um chunk de código Lua a partir de um arquivo virtual ou real (path). Opcionalmente, permite passar um ambiente global customizado (env) para isolamento do escopo. Se optional for verdadeiro, o interpretador silencia erros de ausência do arquivo.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.loadFile`, `pr_lib.loadJson`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, load, shared

---

### Function: **`pr_lib.loadFile(resource, fileName, env, optional)`**

**Detail:** Carrega um arquivo específico (fileName) de um determinado recurso ativo do servidor (resource) no ambiente customizado (env). Silencia falhas de carregamento se optional for true.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadJson`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, load, file, shared

---

### Function: **`pr_lib.loadJson(path, optional)`**

**Detail:** Lê, decodifica e retorna uma tabela Lua a partir de um arquivo com formato JSON localizado em path.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadModule`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, load, json, shared

---

### Function: **`pr_lib.loadModule(path, env, optional)`**

**Detail:** Importa dinamicamente submódulos e bibliotecas da estrutura interna da pr_bridge.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, load, module, shared

---

### Function: **`pr_lib.mergeJson(path, changes, options)`**

**Detail:** Mescla recursivamente dados novos de uma tabela (changes) em um arquivo JSON existente no disco, preservando as chaves anteriores.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, merge, json, shared

---

### Function: **`pr_lib.readJson(path, optional)`**

**Detail:** Lê, decodifica e retorna uma tabela Lua a partir de um arquivo com formato JSON localizado em path.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, read, json, shared

---

### Function: **`pr_lib.saveJson(path, value, options)`**

**Detail:** Serializa uma tabela Lua (value) em formato JSON identado e legível, gravando-a no caminho (path).

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, save, json, shared

---

### Function: **`pr_lib.updateJson(path, changes, options)`**

**Detail:** Mescla recursivamente dados novos de uma tabela (changes) em um arquivo JSON existente no disco, preservando as chaves anteriores.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, update, json, shared

---

### Function: **`pr_lib.versionCheck(repository)`**

**Detail:** Executa uma checagem em background consultando a API do GitHub para verificar se a versão declarada no manifesto do recurso atual é inferior à última release pública (tag) do repositório informado.

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, version, check, shared

---

### Function: **`pr_lib.writeJson(path, value, options)`**

**Detail:** Serializa uma tabela Lua (value) em formato JSON identado e legível, gravando-a no caminho (path).

**Related/Dependents:** `pr_lib.checkDependency`, `pr_lib.deleteJson`, `pr_lib.jsonExists`, `pr_lib.load`, `pr_lib.loadFile`, `pr_lib.loadJson`

**Directory:** `pr_bridge/bridge/core.lua; pr_bridge/init.lua`

**Context:** Shared

**Tags:** core, write, json, shared

---

## locale

### Function: **`lang:clear()`**

**Detail:** clear() Remove todas as entradas de tradução carregadas.

**Related/Dependents:** `pr_lib.locale`, `lang:delete`, `lang:extend`, `lang:has`, `lang:locale`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, clear, shared

---

### Function: **`lang:delete(phraseTarget, prefix)`**

**Detail:** delete(phraseTarget, prefix) Apaga uma entrada específica de tradução.

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:extend`, `lang:has`, `lang:locale`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, delete, shared

---

### Function: **`lang:extend(phrases, prefix)`**

**Detail:** extend(phrases, prefix) Adiciona um conjunto de frases a um catálogo de tradução ativo sob um prefixo identificador de namespace.

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:delete`, `lang:has`, `lang:locale`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, extend, shared

---

### Function: **`lang:has(key)`**

**Detail:** has(key) Retorna um booleano que indica se a chave de tradução está mapeada na localidade ativa.

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:delete`, `lang:extend`, `lang:locale`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, has, shared

---

### Function: **`lang:locale(newLocale)`**

**Detail:** locale(newLocale) Altera dinamicamente o código de localidade atual do objeto de tradução (ex: para "pt", "en", "es").

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:delete`, `lang:extend`, `lang:has`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, shared

---

### Function: **`lang:replace(phrases)`**

**Detail:** replace(phrases) Substitui todas as frases de localização atuais por um novo dicionário.

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:delete`, `lang:extend`, `lang:has`, `lang:locale`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, replace, shared

---

### Function: **`lang:t(key, substitutions)`**

**Detail:** t(key, substitutions) Recupera a tradução associada à key. Permite a interpolação dinâmica substituindo variáveis no texto (ex: %{nome}).

**Related/Dependents:** `pr_lib.locale`, `lang:clear`, `lang:delete`, `lang:extend`, `lang:has`, `lang:locale`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, lang, shared

---

### Function: **`pr_lib.locale(invokingResource)`**

**Detail:** Inicia a ponte de internacionalização do recurso que invocou a biblioteca.

**Related/Dependents:** `lang:clear`, `lang:delete`, `lang:extend`, `lang:has`, `lang:locale`, `lang:replace`

**Directory:** `pr_bridge/bridge/locale.lua`

**Context:** Shared

**Tags:** locale, shared

---

## cache

### Function: **`pr_lib.cache(key, callback, timeout)`**

**Detail:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.

**Related/Dependents:** `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.call(key, callback, timeout)`**

**Detail:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, call, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.clear(key)`**

**Detail:** Limpa uma entrada de cache e notifica ouvintes ativos de alteração de estado.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, clear, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.clearPrefix(prefix)`**

**Detail:** Invalida em lote todas as chaves do cache que começarem com um determinado termo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, clear, prefix, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.get(key, fallback)`**

**Detail:** Busca um valor anteriormente guardado no cache. Se a chave não existir ou for nula, retorna o valor de fallback.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.GetMetadata`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.GetMetadata(source, metadata, timeout)`**

**Detail:** Recupera metadados específicos de um jogador a partir do cache temporário de curta duração.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetPlayer`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, metadata, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.GetPlayer(source, timeout)`**

**Detail:** Retorna o objeto do jogador do framework de forma ultra rápida usando cache em memória para diminuir chamadas repetidas de export.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, player, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.InvalidatePlayer(source)`**

**Detail:** Limpa todas as instâncias de cache associadas à ID do jogador informada.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, invalidate, player, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.onChange(key, callback)`**

**Detail:** Assina a alteração de uma chave de cache específica. O callback recebe (newValue, oldValue) quando o dado correspondente mudar.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, on, change, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.remember(key, callback, timeout)`**

**Detail:** Obtém o valor associado a uma chave. Caso não exista, executa a função de callback, persiste o seu retorno sob o tempo limite definido em timeout (milissegundos) e então entrega o dado retornado.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, remember, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.set(key, value)`**

**Detail:** Armazena um dado em memória RAM atrelado a uma chave de identificação de cache.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, set, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache.setShared(key, value, ttl?)`**

**Detail:** Grava uma chave compartilhada no cache central do pr_bridge e sincroniza o novo valor entre os recursos consumidores do mesmo contexto. Somente chaves autorizadas pelo cache central podem ser publicadas.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, set, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:clear(key?)`**

**Detail:** Limpa os dados ou a operação “clear” e os dados relacionados mantidos pelo módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, clear, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:clearPrefix(prefix)`**

**Detail:** Limpa os dados ou a operação “clear prefix” e os dados relacionados mantidos pelo módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, clear, prefix, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:get(key, fallback?)`**

**Detail:** Obtém os dados ou a operação “get” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:getEntities(kind?)`**

**Detail:** Obtém os dados ou a operação “get entities” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, entities, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:getEntity(entityOrNetId)`**

**Detail:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, entity, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:getEntityState(entityOrNetId)`**

**Detail:** Obtém os dados ou a operação “get entity state” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, entity, state, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:getMetrics()`**

**Detail:** Obtém os dados ou a operação “get metrics” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, get, metrics, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:has(key)`**

**Detail:** Verifica se os dados ou a operação “has” está disponível ou atende ao filtro informado.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, has, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:onChange(key, callback)`**

**Detail:** Executa os dados ou a operação “on change” por meio da API pública do módulo `cache`.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, on, change, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:remember(key, callback, ttl?)`**

**Detail:** Executa os dados ou a operação “remember” por meio da API pública do módulo `cache`.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, remember, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:scanWorld()`**

**Detail:** Executa os dados ou a operação “scan world” por meio da API pública do módulo `cache`.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, scan, world, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:set(key, value, ttl?)`**

**Detail:** Define ou atualiza os dados ou a operação “set” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, set, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:setShared(key, value, ttl?)`**

**Detail:** Define ou atualiza os dados ou a operação “set shared” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, set, shared, invalidação, estado, memória

---

### Function: **`pr_lib.cache:setWorldEnabled(enabled)`**

**Detail:** Define ou atualiza os dados ou a operação “set world enabled” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.cache`, `pr_lib.cache.call`, `pr_lib.cache.clear`, `pr_lib.cache.clearPrefix`, `pr_lib.cache.get`, `pr_lib.cache.GetMetadata`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Shared

**Tags:** cache, set, world, enabled, shared, invalidação, estado, memória

---

### Function: **`pr_lib.getCacheMetrics()`**

**Detail:** Obtém os dados ou a operação “get cache metrics” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.onCache`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Client

**Tags:** cache, get, metrics, client, invalidação, estado, memória

---

### Function: **`pr_lib.onCache(key, callback)`**

**Detail:** Executa os dados ou a operação “on cache” por meio da API pública do módulo `cache_central_e_statebag-like`.

**Related/Dependents:** `pr_lib.getCacheMetrics`

**Directory:** `pr_bridge/bridge/cache/shared.lua; pr_bridge/bridge/cache/central.lua`

**Context:** Client

**Tags:** cache, on, client, invalidação, estado, memória

---

## debug

### Function: **`pr_lib.debug(...)`**

**Detail:** Imprime dados formatados para console caso o nível de debug do recurso esteja ativado.

**Related/Dependents:** `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, shared

---

### Function: **`pr_lib.debug.error(...)`**

**Detail:** Imprime logs de erro formatados em vermelho no console.

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, error, shared

---

### Function: **`pr_lib.debug.info(...)`**

**Detail:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, info, shared

---

### Function: **`pr_lib.debug.isEnabled()`**

**Detail:** Retorna true se o console do recurso chamador estiver operando em modo verbose (depuração ativa).

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, is, enabled, shared

---

### Function: **`pr_lib.debug.log(...)`**

**Detail:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.setEnabled`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, log, shared

---

### Function: **`pr_lib.debug.setEnabled(state)`**

**Detail:** Habilita ou desabilita logs de debug em tempo de execução.

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.success`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, set, enabled, shared

---

### Function: **`pr_lib.debug.success(...)`**

**Detail:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, success, shared

---

### Function: **`pr_lib.debug.warn(...)`**

**Detail:** Exibe logs de alerta em amarelo no console do servidor/cliente.

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, warn, shared

---

### Function: **`pr_lib.debug.warning(...)`**

**Detail:** Exibe logs de alerta em amarelo no console do servidor/cliente.

**Related/Dependents:** `pr_lib.debug`, `pr_lib.debug.error`, `pr_lib.debug.info`, `pr_lib.debug.isEnabled`, `pr_lib.debug.log`, `pr_lib.debug.setEnabled`

**Directory:** `pr_bridge/bridge/debug.lua`

**Context:** Shared

**Tags:** debug, warning, shared

---

## events

### Function: **`pr_lib.triggerClientEvent(eventName, target, ...)`**

**Detail:** Dispara um evento de cliente para um ou mais jogadores de forma otimizada. Esta função realiza a serialização (msgpack) dos argumentos apenas uma vez, em vez de fazer por alvo, proporcionando ganhos significativos de desempenho ao disparar para múltiplos jogadores. O parâmetro target aceita um ID numérico, ou uma tabela contendo uma lista de IDs.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/bridge/triggerClientEvent/server.lua`

**Context:** Server

**Tags:** events, trigger, client, event, server

---

## framework

### Function: **`pr_lib.framework.AddAccountBalance(source, account, amount, reason)`**

**Detail:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.

**Related/Dependents:** `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, account, balance, server

---

### Function: **`pr_lib.framework.AddItem(source, itemName, count, metadata, slot)`**

**Detail:** Adiciona um item ao inventário do jogador, especificando metadados ou o slot preferencial.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, item, server

---

### Function: **`pr_lib.framework.AddJobAccountBalance(account, amount, reason)`**

**Detail:** Adiciona fundos à conta bancária de uma facção/empresa/sociedade.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, job, account, balance, server

---

### Function: **`pr_lib.framework.addMoney(src, amount, account, reason)`**

**Detail:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, money, server

---

### Function: **`pr_lib.framework.AddPlayerAccountBalance(source, account, amount, reason)`**

**Detail:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.addPlayerMoney`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, player, account, balance, server

---

### Function: **`pr_lib.framework.addPlayerMoney(source, account, amount, reason)`**

**Detail:** Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.AddPlayerToGang`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, player, money, server

---

### Function: **`pr_lib.framework.AddPlayerToGang(citizenid, gangName, grade)`**

**Detail:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, player, to, gang, server

---

### Function: **`pr_lib.framework.AddPlayerToJob(citizenid, jobName, grade)`**

**Detail:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, player, to, job, server

---

### Function: **`pr_lib.framework.addSocietyBalance(account, amount, reason)`**

**Detail:** Adiciona fundos à conta bancária de uma facção/empresa/sociedade.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, society, balance, server

---

### Function: **`pr_lib.framework.AddWeapon(source, data)`**

**Detail:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, add, weapon, server

---

### Function: **`pr_lib.framework.CanCarryItem(source, itemName, count, metadata)`**

**Detail:** Verifica se o inventário do jogador comporta o peso/slots adicionais daquele item específico.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, can, carry, item, server

---

### Function: **`pr_lib.framework.CheckItemValid(source, name, count)`**

**Detail:** Validação interna de segurança de consistência de item de inventário.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, check, item, valid, server

---

### Function: **`pr_lib.framework.ClearPlayerInventory(source)`**

**Detail:** Apaga todos os itens do inventário de um jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, clear, player, inventory, server

---

### Function: **`pr_lib.framework.CreateWeaponData(source, data, weaponData)`**

**Detail:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, create, weapon, data, server

---

### Function: **`pr_lib.framework.DeleteOwnedVehicle(plate)`**

**Detail:** Remove a persistência de propriedade de um veículo.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, delete, owned, vehicle, server, veículo, carro

---

### Function: **`pr_lib.framework.GetAccountBalance(account)`**

**Detail:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").

**Related/Dependents:** `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, account, balance, client

---

### Function: **`pr_lib.framework.GetAccountBalance(source, account)`**

**Detail:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, account, balance, server

---

### Function: **`pr_lib.framework.GetAllPlayers()`**

**Detail:** Retorna uma lista contendo todos os IDs de jogadores conectados no servidor.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, all, players, server

---

### Function: **`pr_lib.framework.getCharacterName()`**

**Detail:** Retorna o nome RP do personagem local.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, character, name, client

---

### Function: **`pr_lib.framework.GetClosestPlayer()`**

**Detail:** Retorna o ID da entidade ped e o ID de rede do jogador mais próximo do personagem local.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, closest, player, client

---

### Function: **`pr_lib.framework.GetClosestVehicle()`**

**Detail:** Retorna o ID da entidade do veículo mais próximo.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, closest, vehicle, client, veículo, carro

---

### Function: **`pr_lib.framework.GetCoords(source, withHeading)`**

**Detail:** Retorna um vector3 ou vector4 contendo as coordenadas globais tridimensionais e o ângulo (heading) da entidade do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, coords, server

---

### Function: **`pr_lib.framework.GetFrameworkGangs()`**

**Detail:** Obtém a lista geral de gangs/facções cadastradas no framework ativo quando o framework oferecer esse conceito.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, gangs, server

---

### Function: **`pr_lib.framework.GetFrameworkJobs()`**

**Detail:** Obtém a lista geral de empregos cadastrados no framework ativo.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, jobs, server

---

### Function: **`pr_lib.framework.GetIdentifier(source)`**

**Detail:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, identifier, server

---

### Function: **`pr_lib.framework.getItemByName(name)`**

**Detail:** Obtém a tabela de dados detalhada de um item pelo seu nome.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, by, name, server

---

### Function: **`pr_lib.framework.GetItemByName(source, itemName, metadata, slot)`**

**Detail:** Obtém a tabela de dados detalhada de um item pelo seu nome.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, by, name, server

---

### Function: **`pr_lib.framework.GetItemBySlot(source, slot)`**

**Detail:** Retorna os dados do item que ocupa o slot numérico informado.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, by, slot, server

---

### Function: **`pr_lib.framework.GetItemCount(itemName, metadata, strict)`**

**Detail:** Retorna a contagem exata daquele item no inventário.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetJobInfo`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, item, count, client

---

### Function: **`pr_lib.framework.GetItemCount(source, itemName, metadata, strict)`**

**Detail:** Retorna a contagem exata daquele item no inventário.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, count, server

---

### Function: **`pr_lib.framework.GetItemData(source, itemName, metadata, slot)`**

**Detail:** Obtém a tabela de dados detalhada de um item pelo seu nome.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, data, server

---

### Function: **`pr_lib.framework.GetItemLabel(itemName)`**

**Detail:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, item, label, server

---

### Function: **`pr_lib.framework.GetItemlabel(itemName)`**

**Detail:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, itemlabel, server

---

### Function: **`pr_lib.framework.GetJobAccountBalance(account)`**

**Detail:** Retorna o saldo bancário atual da conta corporativa da sociedade/facção.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, job, account, balance, server

---

### Function: **`pr_lib.framework.GetJobCount(jobName)`**

**Detail:** Obtém a quantidade de funcionários que estão online e em serviço para o emprego especificado.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, job, count, server

---

### Function: **`pr_lib.framework.GetJobInfo()`**

**Detail:** Utilitários locais para resgatar dados do personagem sincronizados com o framework.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, job, info, client

---

### Function: **`pr_lib.framework.GetMoney(account)`**

**Detail:** Retorna o saldo financeiro do personagem local.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, money, client

---

### Function: **`pr_lib.framework.GetOwnedVehicleData(plate)`**

**Detail:** Busca no banco de dados a estrutura de persistência associada a um veículo de proprietário baseado na placa.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, owned, vehicle, data, server, veículo, carro

---

### Function: **`pr_lib.framework.GetOwnedVehicleOwner(plate)`**

**Detail:** Retorna o identificador único (CitizenID/License) do dono do veículo.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, owned, vehicle, owner, server, veículo, carro

---

### Function: **`pr_lib.framework.GetPlayer()`**

**Detail:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, client

---

### Function: **`pr_lib.framework.GetPlayer(source)`**

**Detail:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, server

---

### Function: **`pr_lib.framework.GetPlayerAccountBalance(source, account)`**

**Detail:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, account, balance, server

---

### Function: **`pr_lib.framework.GetPlayerData()`**

**Detail:** Obtém os dados puros de persistência do personagem do jogador (como nome, metadados, dinheiro, etc.).

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, data, client

---

### Function: **`pr_lib.framework.GetPlayerData(source)`**

**Detail:** Obtém os dados puros de persistência do personagem do jogador (como nome, metadados, dinheiro, etc.).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, data, server

---

### Function: **`pr_lib.framework.GetPlayerDob()`**

**Detail:** Retorna a data de nascimento registrada do personagem.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, dob, client

---

### Function: **`pr_lib.framework.GetPlayerDob(source)`**

**Detail:** Retorna a data de nascimento registrada do personagem.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, dob, server

---

### Function: **`pr_lib.framework.getPlayerDOB(source)`**

**Detail:** Retorna a data de nascimento registrada do personagem.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, dob, server

---

### Function: **`pr_lib.framework.getPlayerFromId(source)`**

**Detail:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, from, id, server

---

### Function: **`pr_lib.framework.GetPlayerFromId(source)`**

**Detail:** Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (source) indicada.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, from, id, server

---

### Function: **`pr_lib.framework.GetPlayerFromIdentifier(identifier)`**

**Detail:** Recupera um jogador logado a partir de sua licença primária ou ID única de cidadão (CitizenID/Identifier).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, from, identifier, server

---

### Function: **`pr_lib.framework.GetPlayerGender()`**

**Detail:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, gender, client

---

### Function: **`pr_lib.framework.GetPlayerGender(source)`**

**Detail:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, gender, server

---

### Function: **`pr_lib.framework.GetPlayerGroup()`**

**Detail:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, group, client

---

### Function: **`pr_lib.framework.GetPlayerGroup(source)`**

**Detail:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, group, server

---

### Function: **`pr_lib.framework.getPlayerGroup(source)`**

**Detail:** Retorna o grupo de permissão de administração do jogador (ex: "user", "admin", "god").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, group, server

---

### Function: **`pr_lib.framework.getPlayerHeight(source)`**

**Detail:** Retorna a altura registrada do personagem no framework (normalmente usado em ESX).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, height, server

---

### Function: **`pr_lib.framework.GetPlayerIdentifier()`**

**Detail:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, identifier, client

---

### Function: **`pr_lib.framework.GetPlayerIdentifier(source)`**

**Detail:** Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, identifier, server

---

### Function: **`pr_lib.framework.GetPlayerInventory()`**

**Detail:** Retorna o inventário bruto de itens carregados do jogador da forma normalizada pelo framework ativo.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, inventory, client

---

### Function: **`pr_lib.framework.GetPlayerInventory(source)`**

**Detail:** Retorna o inventário bruto de itens carregados do jogador da forma normalizada pelo framework ativo.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, inventory, server

---

### Function: **`pr_lib.framework.GetPlayerJob()`**

**Detail:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, job, client

---

### Function: **`pr_lib.framework.GetPlayerJob(source)`**

**Detail:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, job, server

---

### Function: **`pr_lib.framework.getPlayerJob(source, dataType)`**

**Detail:** Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, job, server

---

### Function: **`pr_lib.framework.GetPlayerMetadata(key)`**

**Detail:** Obtém um valor guardado dentro dos metadados persistentes do personagem.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, metadata, client

---

### Function: **`pr_lib.framework.getPlayerMetadata(key)`**

**Detail:** Obtém um valor guardado dentro dos metadados persistentes do personagem.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, metadata, client

---

### Function: **`pr_lib.framework.GetPlayerMetadata(source, key)`**

**Detail:** Obtém um valor guardado dentro dos metadados persistentes do personagem.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, metadata, server

---

### Function: **`pr_lib.framework.getPlayerMetadata(source, key)`**

**Detail:** Obtém um valor guardado dentro dos metadados persistentes do personagem.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, metadata, server

---

### Function: **`pr_lib.framework.getPlayerMoney(source, account)`**

**Detail:** Obtém o saldo de dinheiro em uma conta específica (ex: "cash", "bank", "crypto").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, money, server

---

### Function: **`pr_lib.framework.GetPlayerName()`**

**Detail:** Obtém o nome em jogo (RP) do personagem do jogador.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, player, name, client

---

### Function: **`pr_lib.framework.GetPlayerName(source)`**

**Detail:** Obtém o nome em jogo (RP) do personagem do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, name, server

---

### Function: **`pr_lib.framework.getPlayerName(source)`**

**Detail:** Obtém o nome em jogo (RP) do personagem do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, name, server

---

### Function: **`pr_lib.framework.GetPlayerNameByIdentifier(identifier)`**

**Detail:** Recupera o nome do personagem do jogador offline ou online pelo seu identificador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, name, by, identifier, server

---

### Function: **`pr_lib.framework.getPlayerSex(source)`**

**Detail:** Retorna o gênero do personagem (retorna "m", "f" ou representação equivalente).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, sex, server

---

### Function: **`pr_lib.framework.getPlayerSourceFromPlayer(player)`**

**Detail:** Extrai a ID (source) do servidor a partir do objeto abstrato do jogador entregue pelo framework.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, player, source, from, server

---

### Function: **`pr_lib.framework.GetResourceName()`**

**Detail:** Retorna o nome do recurso de framework ativo no servidor (ex: "qbx_core", "qb-core", "es_extended").

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, get, resource, name, client

---

### Function: **`pr_lib.framework.GetResourceName()`**

**Detail:** Retorna o nome do recurso de framework ativo no servidor (ex: "qbx_core", "qb-core", "es_extended").

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, resource, name, server

---

### Function: **`pr_lib.framework.GetWeapon(source, name)`**

**Detail:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, get, weapon, server

---

### Function: **`pr_lib.framework.HasItem(itemName, count, metadata, strict)`**

**Detail:** Verifica se o jogador possui o item com a quantidade especificada.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, has, item, client

---

### Function: **`pr_lib.framework.HasItem(source, itemName, count, metadata, strict)`**

**Detail:** Verifica se o jogador possui o item com a quantidade especificada.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, has, item, server

---

### Function: **`pr_lib.framework.HideTextUI()`**

**Detail:** Exibe e oculta painéis TextUI flutuantes.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, hide, text, ui, client

---

### Function: **`pr_lib.framework.InsertOwnedVehicle(plate, owner, vehicle)`**

**Detail:** Grava um veículo na tabela de propriedade de veículos persistentes.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, insert, owned, vehicle, server, veículo, carro

---

### Function: **`pr_lib.framework.InventoryManagement(source, data)`**

**Detail:** API utilitária para gerenciamento em lote de estados do inventário.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, inventory, management, server

---

### Function: **`pr_lib.framework.IsPlayerDead()`**

**Detail:** Retorna se o jogador local está em estado de morte/nocaute.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, is, player, dead, client

---

### Function: **`pr_lib.framework.IsPlayerLoaded()`**

**Detail:** Retorna se o personagem local terminou de carregar completamente e já está ativo e spawnado no mapa.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, is, player, loaded, client

---

### Function: **`pr_lib.framework.Items(itemName)`**

**Detail:** Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, items, server

---

### Function: **`pr_lib.framework.Notify(message, kind, duration)`**

**Detail:** Dispara uma notificação nativa simplificada baseada no framework carregado.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, notify, client

---

### Function: **`pr_lib.framework.PlayerHasJob(jobName, grade)`**

**Detail:** Verifica se o jogador pertence a um determinado grupo de emprego, com verificação opcional do nível do cargo (grade).

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, player, has, job, client

---

### Function: **`pr_lib.framework.PlayerHasJob(source, jobName, grade)`**

**Detail:** Verifica se o jogador pertence a um determinado grupo de emprego, com verificação opcional do nível do cargo (grade).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, player, has, job, server

---

### Function: **`pr_lib.framework.RegisterCallback(name, callback)`**

**Detail:** Registra um server-callback que pode ser requisitado e retornado síncrona ou assincronamente pelo cliente.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, register, callback, server, request, resposta, timeout

---

### Function: **`pr_lib.framework.RegisterUsableItem(itemName, callback)`**

**Detail:** Associa uma função executada quando o jogador consome ou usa o item a partir do inventário.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, register, usable, item, server

---

### Function: **`pr_lib.framework.RemoveAccountBalance(source, account, amount, reason)`**

**Detail:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, account, balance, server

---

### Function: **`pr_lib.framework.RemoveItem(source, itemName, count, metadata, slot)`**

**Detail:** Remove um item do inventário do jogador.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, item, server

---

### Function: **`pr_lib.framework.RemoveJobAccountBalance(account, amount, reason)`**

**Detail:** Remove fundos da conta corporativa/sociedade de um emprego específico.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, job, account, balance, server

---

### Function: **`pr_lib.framework.RemovePlayerAccountBalance(source, account, amount, reason)`**

**Detail:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, player, account, balance, server

---

### Function: **`pr_lib.framework.RemovePlayerFromGang(citizenid, gangName)`**

**Detail:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, player, from, gang, server

---

### Function: **`pr_lib.framework.RemovePlayerFromJob(citizenid, jobName)`**

**Detail:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, player, from, job, server

---

### Function: **`pr_lib.framework.removePlayerMoney(source, account, amount, reason)`**

**Detail:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, player, money, server

---

### Function: **`pr_lib.framework.removeSocietyBalance(account, amount, reason)`**

**Detail:** Remove fundos da conta corporativa/sociedade de um emprego específico.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, society, balance, server

---

### Function: **`pr_lib.framework.RemoveWeapon(source, data)`**

**Detail:** Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, remove, weapon, server

---

### Function: **`pr_lib.framework.SetMetadata(source, slot, metadata)`**

**Detail:** Define dados e atributos internos customizados para um item em um slot específico.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, metadata, server

---

### Function: **`pr_lib.framework.SetPlayerDuty(source, onDuty)`**

**Detail:** Altera o estado de servico do emprego ativo do jogador (true para entrar em servico, false para sair).

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, duty, server

---

### Function: **`pr_lib.framework.SetPlayerJob(source, jobName, grade)`**

**Detail:** Altera o emprego e cargo do jogador remotamente.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, job, server

---

### Function: **`pr_lib.framework.SetPlayerMetadata(source, key, value)`**

**Detail:** Grava um valor nos metadados do jogador e sincroniza a alteração com o banco de dados e cliente.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, metadata, server

---

### Function: **`pr_lib.framework.setPlayerMetadata(source, key, value)`**

**Detail:** Grava um valor nos metadados do jogador e sincroniza a alteração com o banco de dados e cliente.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, metadata, server

---

### Function: **`pr_lib.framework.SetPlayerPrimaryGang(citizenid, gangName)`**

**Detail:** Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, primary, gang, server

---

### Function: **`pr_lib.framework.SetPlayerPrimaryJob(citizenid, jobName)`**

**Detail:** Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, set, player, primary, job, server

---

### Function: **`pr_lib.framework.ShowTextUI(text)`**

**Detail:** Exibe e oculta painéis TextUI flutuantes.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, show, text, ui, client

---

### Function: **`pr_lib.framework.takeMoney(src, amount, reason)`**

**Detail:** Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.

**Related/Dependents:** `pr_lib.framework.AddAccountBalance`, `pr_lib.framework.AddItem`, `pr_lib.framework.AddJobAccountBalance`, `pr_lib.framework.addMoney`, `pr_lib.framework.AddPlayerAccountBalance`, `pr_lib.framework.addPlayerMoney`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/server.lua`

**Context:** Server

**Tags:** framework, take, money, server

---

### Function: **`pr_lib.framework.toggleOutfit(wear, outfits)`**

**Detail:** Aplica ou remove partes de roupas integradas a sistemas de vestiários de frameworks.

**Related/Dependents:** `pr_lib.framework.GetAccountBalance`, `pr_lib.framework.getCharacterName`, `pr_lib.framework.GetClosestPlayer`, `pr_lib.framework.GetClosestVehicle`, `pr_lib.framework.GetItemCount`, `pr_lib.framework.GetJobInfo`

**Directory:** `pr_bridge/bridge/framework_normalizer.lua; pr_bridge/bridge/frameworks/*/client.lua`

**Context:** Client

**Tags:** framework, toggle, outfit, client

---

## inventory

### Function: **`pr_lib.inventory.AddItem(inv, item, count, metadata, slot, cb)`**

**Detail:** Adiciona um item a um inventário qualquer (inv pode ser o ID do jogador ou o ID de um baú/stash).

**Related/Dependents:** `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, add, item, server

---

### Function: **`pr_lib.inventory.AddItemIntoStash(id, item, amount, slot, metadata, slots, maxWeight)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, add, item, into, stash, server

---

### Function: **`pr_lib.inventory.AddStashItems(id, items)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, add, stash, items, server

---

### Function: **`pr_lib.inventory.AddTrunkItems(identifier, items)`**

**Detail:** Adiciona itens ao porta-malas de um veículo persistente.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, add, trunk, items, server

---

### Function: **`pr_lib.inventory.CanCarryAmount(inv, item)`**

**Detail:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryItem`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, can, carry, amount, server

---

### Function: **`pr_lib.inventory.CanCarryItem(inv, item, count, metadata)`**

**Detail:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryWeight`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, can, carry, item, server

---

### Function: **`pr_lib.inventory.CanCarryWeight(inv, weight)`**

**Detail:** Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, can, carry, weight, server

---

### Function: **`pr_lib.inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)`**

**Detail:** Retorna se o inventário suporta a troca física de um item por outro em termos de peso e capacidade restante.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, can, swap, item, server

---

### Function: **`pr_lib.inventory.CheckIfInventoryBlocked()`**

**Detail:** Desativa e bloqueia a abertura do inventário pelo jogador (útil em animações de algemas, etc.).

**Related/Dependents:** `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, check, if, blocked, client

---

### Function: **`pr_lib.inventory.CheckItemValid(source, name, count)`**

**Detail:** Validação interna de segurança de transação de inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, check, item, valid, server

---

### Function: **`pr_lib.inventory.ClearInventory(inv, keep)`**

**Detail:** Limpa todos os itens de um inventário, permitindo opcionalmente ignorar (preservar) itens informados na tabela keep.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, clear, server

---

### Function: **`pr_lib.inventory.ClearOtherInventory(type, id)`**

**Detail:** Limpa inventários secundários de baús.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, clear, other, server

---

### Function: **`pr_lib.inventory.ClearPlayerInventory(inv, keep)`**

**Detail:** Limpa todos os itens de um inventário, permitindo opcionalmente ignorar (preservar) itens informados na tabela keep.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, clear, player, server

---

### Function: **`pr_lib.inventory.ClearStash(id)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, clear, stash, server

---

### Function: **`pr_lib.inventory.closeInventory()`**

**Detail:** Lógicas de abertura, fechamento e status de exibição da UI do inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, close, client

---

### Function: **`pr_lib.inventory.ConfiscateInventory(source)`**

**Detail:** Usado para apreender o inventário do jogador temporariamente e depois restaurá-lo (útil para sistemas de prisão).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, confiscate, server

---

### Function: **`pr_lib.inventory.CreateDropFromPlayer(playerId)`**

**Detail:** Dropa todos os itens do inventário de um jogador no chão em um contêiner físico.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, create, drop, from, player, server

---

### Function: **`pr_lib.inventory.CreateTemporaryStash(properties)`**

**Detail:** Cria um baú em memória que é descartado após o encerramento do recurso ou limpeza.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, create, temporary, stash, server

---

### Function: **`pr_lib.inventory.CreateUsableItem(item, cb)`**

**Detail:** Registra lógica de ativação de itens consumíveis.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, create, usable, item, server

---

### Function: **`pr_lib.inventory.CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)`**

**Detail:** Cria um container de drop customizado no chão no mundo 3D.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, custom, drop, server

---

### Function: **`pr_lib.inventory.displayMetadata(metadata, value)`**

**Detail:** Registra formatação de exibição de metadados customizados na interface do inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, display, metadata, client

---

### Function: **`pr_lib.inventory.forceOpenInventory(playerId, invType, data)`**

**Detail:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, force, open, server

---

### Function: **`pr_lib.inventory.GetClientPlayerInventory()`**

**Detail:** Retorna a lista bruta de itens que estão atualmente na posse do jogador local.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, client, player

---

### Function: **`pr_lib.inventory.GetContainerFromSlot(inv, slotId)`**

**Detail:** Retorna dados de sub-recipientes/mochilas carregados no slot de inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, container, from, slot, server

---

### Function: **`pr_lib.inventory.getCurrentWeapon()`**

**Detail:** Resgata arma equipada e inventário bruto local do cliente.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.GetImagePath`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, current, weapon, client

---

### Function: **`pr_lib.inventory.GetCurrentWeapon(inv)`**

**Detail:** Retorna os dados da arma equipada ativa de um inventário de jogador.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, current, weapon, server

---

### Function: **`pr_lib.inventory.GetEmptySlot(inv)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, empty, slot, server

---

### Function: **`pr_lib.inventory.GetImagePath(item)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.getInventoryImg`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, image, path, client

---

### Function: **`pr_lib.inventory.GetImagePath(item)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, image, path, server

---

### Function: **`pr_lib.inventory.GetInventory(inv, owner)`**

**Detail:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, server

---

### Function: **`pr_lib.inventory.getInventoryImg(image)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, img, client

---

### Function: **`pr_lib.inventory.GetInventoryImg(image)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, img, client

---

### Function: **`pr_lib.inventory.getInventoryImg(image)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, img, server

---

### Function: **`pr_lib.inventory.GetInventoryImg(image)`**

**Detail:** Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, img, server

---

### Function: **`pr_lib.inventory.GetInventoryItems(inv, owner)`**

**Detail:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, items, server

---

### Function: **`pr_lib.inventory.GetItem(inv, item, metadata, returnsCount)`**

**Detail:** Busca os dados detalhados e integridade de um item pelo seu nome ou chave.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, server

---

### Function: **`pr_lib.inventory.GetItemByName(inv, item, metadata, returnsCount)`**

**Detail:** Busca os dados detalhados e integridade de um item pelo seu nome ou chave.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, by, name, server

---

### Function: **`pr_lib.inventory.GetItemBySlot(inv, slot)`**

**Detail:** Recupera dados do slot do inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, by, slot, server

---

### Function: **`pr_lib.inventory.GetItemCount(itemName, metadata, strict)`**

**Detail:** Verificações de estoque de itens.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, item, count, client

---

### Function: **`pr_lib.inventory.GetItemCount(inv, itemName, metadata, strict)`**

**Detail:** Verificações de estoque de itens.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, count, server

---

### Function: **`pr_lib.inventory.GetItemInfo(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, item, info, client

---

### Function: **`pr_lib.inventory.getItemInfo(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, item, info, client

---

### Function: **`pr_lib.inventory.GetItemInfo(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, info, server

---

### Function: **`pr_lib.inventory.getItemInfo(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, info, server

---

### Function: **`pr_lib.inventory.GetItemLabel(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, item, label, client

---

### Function: **`pr_lib.inventory.GetItemLabel(item)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, label, server

---

### Function: **`pr_lib.inventory.GetItemList()`**

**Detail:** Busca propriedades registradas locais dos itens.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, item, list, client

---

### Function: **`pr_lib.inventory.GetItemSlots(inv, item, metadata)`**

**Detail:** Retorna uma lista de números de slots que contêm o item pesquisado.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, item, slots, server

---

### Function: **`pr_lib.inventory.GetPlayerInventory()`**

**Detail:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, player, client

---

### Function: **`pr_lib.inventory.GetPlayerInventory(source)`**

**Detail:** Obtém a tabela geral contendo todos os dados e itens de um inventário específico.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, player, server

---

### Function: **`pr_lib.inventory.GetPlayerItems()`**

**Detail:** Retorna a lista bruta de itens que estão atualmente na posse do jogador local.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, player, items, client

---

### Function: **`pr_lib.inventory.GetPlayerMaxWeight()`**

**Detail:** Resgata propriedades de peso do jogador local.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, player, max, weight, client

---

### Function: **`pr_lib.inventory.GetPlayerWeight()`**

**Detail:** Resgata propriedades de peso do jogador local.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, player, weight, client

---

### Function: **`pr_lib.inventory.GetResourceName()`**

**Detail:** Retorna o nome do script de inventário ativo no servidor.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, resource, name, client

---

### Function: **`pr_lib.inventory.GetResourceName()`**

**Detail:** Retorna o nome do script de inventário ativo no servidor.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, resource, name, server

---

### Function: **`pr_lib.inventory.GetSlot(inv, slot)`**

**Detail:** Recupera dados do slot do inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slot, server

---

### Function: **`pr_lib.inventory.GetSlotForItem(inv, itemName, metadata)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slot, for, item, server

---

### Function: **`pr_lib.inventory.GetSlotIdsWithItem(itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, slot, ids, with, item, client

---

### Function: **`pr_lib.inventory.GetSlotIdsWithItem(inv, itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slot, ids, with, item, server

---

### Function: **`pr_lib.inventory.GetSlotIdWithItem(itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, slot, id, with, item, client

---

### Function: **`pr_lib.inventory.GetSlotIdWithItem(inv, itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slot, id, with, item, server

---

### Function: **`pr_lib.inventory.GetSlotsWithItem(itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, slots, with, item, client

---

### Function: **`pr_lib.inventory.GetSlotsWithItem(inv, itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slots, with, item, server

---

### Function: **`pr_lib.inventory.GetSlotWithItem(itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, slot, with, item, client

---

### Function: **`pr_lib.inventory.GetSlotWithItem(inv, itemName, metadata, strict)`**

**Detail:** Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, slot, with, item, server

---

### Function: **`pr_lib.inventory.GetStashItems(id)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, stash, items, server

---

### Function: **`pr_lib.inventory.GetTotalUsedSlots(source)`**

**Detail:** Retorna o número de slots ocupados no inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, total, used, slots, server

---

### Function: **`pr_lib.inventory.GetTotalWeight(items)`**

**Detail:** Calcula o peso total acumulado a partir de uma lista de itens.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, total, weight, server

---

### Function: **`pr_lib.inventory.getUserInventory()`**

**Detail:** Resgata arma equipada e inventário bruto local do cliente.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, user, client

---

### Function: **`pr_lib.inventory.GetWeaponAttachmentItems()`**

**Detail:** Retorna a lista de itens válidos que servem como acessórios de armas.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, get, weapon, attachment, items, server

---

### Function: **`pr_lib.inventory.GetWeaponList()`**

**Detail:** Retorna lista de armas estáticas cadastradas.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, get, weapon, list, client

---

### Function: **`pr_lib.inventory.giveItemToTarget(serverId, slotId, count)`**

**Detail:** Transfere um item do inventário local diretamente para o jogador próximo (serverId).

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, give, item, to, target, client, alvo, interação, zona

---

### Function: **`pr_lib.inventory.HasItem(item, count, metadata, strict)`**

**Detail:** Verificações de estoque de itens.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, has, item, client

---

### Function: **`pr_lib.inventory.HasItem(inv, item, count, metadata, strict)`**

**Detail:** Verificações de estoque de itens.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, has, item, server

---

### Function: **`pr_lib.inventory.InspectInventory(target, source)`**

**Detail:** Permite que o jogador source visualize e inspecione em tempo real o inventário do jogador target.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, inspect, server

---

### Function: **`pr_lib.inventory.isInventoryOpen()`**

**Detail:** Lógicas de abertura, fechamento e status de exibição da UI do inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, is, open, client

---

### Function: **`pr_lib.inventory.Items(itemName)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, items, client

---

### Function: **`pr_lib.inventory.Items(itemName)`**

**Detail:** Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, items, server

---

### Function: **`pr_lib.inventory.LoadInventory(source, identifier)`**

**Detail:** Força salvamento ou carregamento direto de estados de inventários no banco de dados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, load, server

---

### Function: **`pr_lib.inventory.openInventory(invType, data)`**

**Detail:** Lógicas de abertura, fechamento e status de exibição da UI do inventário.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, open, client

---

### Function: **`pr_lib.inventory.openNearbyInventory()`**

**Detail:** Abre o contêiner de drop/chão mais próximo.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, open, nearby, client

---

### Function: **`pr_lib.inventory.OpenPlayerInventory(src, target)`**

**Detail:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, open, player, server

---

### Function: **`pr_lib.inventory.OpenShop(src, shopTitle)`**

**Detail:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, open, shop, server

---

### Function: **`pr_lib.inventory.OpenStash(source, id)`**

**Detail:** Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, open, stash, server

---

### Function: **`pr_lib.inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)`**

**Detail:** Cria uma loja dinâmica acessível por alvo ou coordenadas.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, register, shop, server

---

### Function: **`pr_lib.inventory.RegisterStash(id, slots, weight)`**

**Detail:** Registra dinamicamente um novo baú (stash) no inventário com regras de permissão.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, register, stash, client

---

### Function: **`pr_lib.inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)`**

**Detail:** Registra dinamicamente um novo baú (stash) no inventário com regras de permissão.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, register, stash, server

---

### Function: **`pr_lib.inventory.RegisterUsableItem(item, cb, options)`**

**Detail:** Registra lógica de ativação de itens consumíveis.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, register, usable, item, server

---

### Function: **`pr_lib.inventory.RemoveItem(inv, item, count, metadata, slot)`**

**Detail:** Remove um item do inventário do jogador ou de um baú.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, remove, item, server

---

### Function: **`pr_lib.inventory.RemoveItemIntoStash(id, item, amount, slot, slots, maxWeight)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, remove, item, into, stash, server

---

### Function: **`pr_lib.inventory.ReturnInventory(source)`**

**Detail:** Usado para apreender o inventário do jogador temporariamente e depois restaurá-lo (útil para sistemas de prisão).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, return, server

---

### Function: **`pr_lib.inventory.SaveInventory(source, offline)`**

**Detail:** Força salvamento ou carregamento direto de estados de inventários no banco de dados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, save, server

---

### Function: **`pr_lib.inventory.Search(search, item, metadata)`**

**Detail:** Executa buscas avançadas utilizando seletores complexos (comportamento nativo do ox_inventory).

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, search, client

---

### Function: **`pr_lib.inventory.Search(inv, search, item, metadata)`**

**Detail:** Executa buscas avançadas utilizando seletores complexos (comportamento nativo do ox_inventory).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, search, server

---

### Function: **`pr_lib.inventory.SetDurability(inv, slot, durability)`**

**Detail:** Define a durabilidade (vida útil de 0 a 100) do item de um determinado slot.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, durability, server

---

### Function: **`pr_lib.inventory.setInClothing(state)`**

**Detail:** Desativa o acesso a itens quando o jogador está em animação de troca de roupa.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, set, in, clothing, client

---

### Function: **`pr_lib.inventory.setInventoryDisabled(state)`**

**Detail:** Desativa e bloqueia a abertura do inventário pelo jogador (útil em animações de algemas, etc.).

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, set, disabled, client

---

### Function: **`pr_lib.inventory.SetInventoryItems(source, item, amount)`**

**Detail:** APIs utilitárias para forçar estados de itens diretamente em slots.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, items, server

---

### Function: **`pr_lib.inventory.SetItemBySlot(source, slot, itemdata)`**

**Detail:** APIs utilitárias para forçar estados de itens diretamente em slots.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, item, by, slot, server

---

### Function: **`pr_lib.inventory.SetItemMetadata(inv, slot, metadata)`**

**Detail:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, item, metadata, server

---

### Function: **`pr_lib.inventory.setItemMetadata(inv, slot, metadata)`**

**Detail:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, item, metadata, server

---

### Function: **`pr_lib.inventory.SetMaxWeight(inv, maxWeight)`**

**Detail:** Redefine propriedades de limite de peso e contagem de slots de um baú/stash ou jogador.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, max, weight, server

---

### Function: **`pr_lib.inventory.SetMetadata(inv, slot, metadata)`**

**Detail:** Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, metadata, server

---

### Function: **`pr_lib.inventory.setPlayerInventory(player, data)`**

**Detail:** APIs utilitárias para forçar estados de itens diretamente em slots.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, player, server

---

### Function: **`pr_lib.inventory.SetSlotCount(inv, slots)`**

**Detail:** Redefine propriedades de limite de peso e contagem de slots de um baú/stash ou jogador.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, set, slot, count, server

---

### Function: **`pr_lib.inventory.setStashTarget(id, owner)`**

**Detail:** Registra ou define o proprietário temporário de baús.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, set, stash, target, client, alvo, interação, zona

---

### Function: **`pr_lib.inventory.UpdateStash(stashid, items)`**

**Detail:** Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, update, stash, server

---

### Function: **`pr_lib.inventory.UpdateVehicle(oldPlate, newPlate)`**

**Detail:** Transfere itens e baús de porta-malas/porta-luvas quando a placa de um veículo for alterada.

**Related/Dependents:** `pr_lib.inventory.AddItem`, `pr_lib.inventory.AddItemIntoStash`, `pr_lib.inventory.AddStashItems`, `pr_lib.inventory.AddTrunkItems`, `pr_lib.inventory.CanCarryAmount`, `pr_lib.inventory.CanCarryItem`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/server.lua`

**Context:** Server

**Tags:** inventory, update, vehicle, server, veículo, carro

---

### Function: **`pr_lib.inventory.useItem(data, cb)`**

**Detail:** Usa localmente um item ou aciona a tecla de atalho de um slot de arma/item.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, use, item, client

---

### Function: **`pr_lib.inventory.useSlot(slot)`**

**Detail:** Usa localmente um item ou aciona a tecla de atalho de um slot de arma/item.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, use, slot, client

---

### Function: **`pr_lib.inventory.weaponWheel(state)`**

**Detail:** Ativa ou desativa o menu circular nativo de armas do GTA V.

**Related/Dependents:** `pr_lib.inventory.CheckIfInventoryBlocked`, `pr_lib.inventory.closeInventory`, `pr_lib.inventory.displayMetadata`, `pr_lib.inventory.GetClientPlayerInventory`, `pr_lib.inventory.getCurrentWeapon`, `pr_lib.inventory.GetImagePath`

**Directory:** `pr_bridge/bridge/inventory_normalizer.lua; pr_bridge/bridge/inventories/*/client.lua`

**Context:** Client

**Tags:** inventory, weapon, wheel, client

---

## notification

### Function: **`pr_lib.hideNotifyBubble(id)`**

**Detail:** Fecha um balão privado ou global criado pelo cliente. No modo global, somente o jogador que criou aquela ID pode solicitar sua remoção.

**Related/Dependents:** `pr_lib.HideNotifyBubble`, `pr_lib.notify`, `pr_lib.notifyBubble`, `pr_lib.NotifyBubble`, `pr_lib.NotifyBubbleAll`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, hide, notify, bubble, client/server

---

### Function: **`pr_lib.HideNotifyBubble(id)`**

**Detail:** Fecha um balão privado ou global criado pelo cliente. No modo global, somente o jogador que criou aquela ID pode solicitar sua remoção.

**Related/Dependents:** `pr_lib.hideNotifyBubble`, `pr_lib.notify`, `pr_lib.notifyBubble`, `pr_lib.NotifyBubble`, `pr_lib.NotifyBubbleAll`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, hide, notify, bubble, client/server

---

### Function: **`pr_lib.Notify(data)`**

**Detail:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.

**Related/Dependents:** `pr_lib.notify.GetResourceName`, `pr_lib.notify.Notify`

**Directory:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client

**Tags:** notification, notify, client

---

### Function: **`pr_lib.notify(src, data, kind, duration)`**

**Detail:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).

**Related/Dependents:** `pr_lib.hideNotifyBubble`, `pr_lib.HideNotifyBubble`, `pr_lib.notifyBubble`, `pr_lib.NotifyBubble`, `pr_lib.NotifyBubbleAll`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, notify, client/server

---

### Function: **`pr_lib.notify.GetResourceName()`**

**Detail:** Retorna o script de notificação ativo (ex: "ox_lib", "okokNotify", "bulletin", etc.).

**Related/Dependents:** `pr_lib.notify.Notify`, `pr_lib.Notify`

**Directory:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client

**Tags:** notification, notify, get, resource, name, client

---

### Function: **`pr_lib.notify.GetResourceName()`**

**Detail:** Retorna o script de notificação ativo (ex: "ox_lib", "okokNotify", "bulletin", etc.).

**Related/Dependents:** `pr_lib.notify.Notify`

**Directory:** `pr_bridge/bridge/notifications/*/server.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Server

**Tags:** notification, notify, get, resource, name, server

---

### Function: **`pr_lib.notify.Notify(data, kind, duration)`**

**Detail:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).

**Related/Dependents:** `pr_lib.notify.GetResourceName`, `pr_lib.Notify`

**Directory:** `pr_bridge/bridge/notifications/*/client.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client

**Tags:** notification, notify, client

---

### Function: **`pr_lib.notify.Notify(src, data, kind, duration)`**

**Detail:** Envia uma notificação flutuante na tela. O parâmetro data pode ser uma string contendo a mensagem ou uma tabela com propriedades como title, description, type, icon, etc. kind e duration servem de fallback de tipo de notificação e tempo de duração (em ms).

**Related/Dependents:** `pr_lib.notify.GetResourceName`

**Directory:** `pr_bridge/bridge/notifications/*/server.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Server

**Tags:** notification, notify, server

---

### Function: **`pr_lib.notifyBubble(data, kind, duration)`**

**Detail:** Mostra um balão de fala responsivo ancorado acima de um ped. Por padrão visibility = "self", então somente o jogador local recebe e vê o balão. Com visibility = "all", a solicitação passa pelo servidor e todos os jogadores veem o mesmo balão ancorado no ped de quem o acionou. Retorna a ID do balão.

**Related/Dependents:** `pr_lib.hideNotifyBubble`, `pr_lib.HideNotifyBubble`, `pr_lib.notify`, `pr_lib.NotifyBubble`, `pr_lib.NotifyBubbleAll`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, notify, bubble, client/server

---

### Function: **`pr_lib.NotifyBubble(data, kind, duration)`**

**Detail:** Mostra um balão de fala responsivo ancorado acima de um ped. Por padrão visibility = "self", então somente o jogador local recebe e vê o balão. Com visibility = "all", a solicitação passa pelo servidor e todos os jogadores veem o mesmo balão ancorado no ped de quem o acionou. Retorna a ID do balão.

**Related/Dependents:** `pr_lib.hideNotifyBubble`, `pr_lib.HideNotifyBubble`, `pr_lib.notify`, `pr_lib.notifyBubble`, `pr_lib.NotifyBubbleAll`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, notify, bubble, client/server

---

### Function: **`pr_lib.NotifyBubbleAll(actorSource, data)`**

**Detail:** Envia o balão a todos os clientes e o ancora no ped de actorSource. Exige a origem do personagem para impedir que cada cliente mostre o balão sobre si mesmo.

**Related/Dependents:** `pr_lib.hideNotifyBubble`, `pr_lib.HideNotifyBubble`, `pr_lib.notify`, `pr_lib.notifyBubble`, `pr_lib.NotifyBubble`

**Directory:** `pr_bridge/bridge/notifications/*/{client,server}.lua; pr_bridge/interface/client/modules/notify.lua`

**Context:** Client/Server

**Tags:** notification, notify, bubble, all, client/server

---

## alert

### Function: **`pr_lib.alertDialog(data, timeout)`**

**Detail:** Atalhos da raiz para os diálogos nativos da interface do pr_bridge. Linhas numéricas aceitam step e precision; quando nenhum passo é informado, o campo aceita livremente valores decimais em vez de restringir a inteiros.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/interface/client/modules/alert.lua`

**Context:** Client

**Tags:** alert, dialog, client

---

## menu

### Function: **`pr_lib.getOpenContextMenu()`**

**Detail:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.

**Related/Dependents:** `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, get, open, context, client, contexto, nui, interface

---

### Function: **`pr_lib.hideContext(onExit)`**

**Detail:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, hide, context, client, contexto, nui, interface

---

### Function: **`pr_lib.hideMenu(onExit)`**

**Detail:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, hide, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.AlertDialog(data, timeout)`**

**Detail:** Exibe um modal pop-up de confirmação de tela cheia (ex: Sim/Não), aguardando e retornando a decisão do jogador.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, alert, dialog, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.alertDialog(data, timeout)`**

**Detail:** Executa os dados ou a operação “alert dialog” por meio da API pública do módulo `menu`.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.GetOpenContextMenu`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, alert, dialog, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.GetOpenContextMenu()`**

**Detail:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.getOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, get, open, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.getOpenContextMenu()`**

**Detail:** Obtém os dados ou a operação “get open context menu” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, get, open, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.HideContext(onExit)`**

**Detail:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, hide, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.hideContext(onExit)`**

**Detail:** Oculta os dados ou a operação “hide context” e restaura o estado visual relacionado.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, hide, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.HideMenu(onExit)`**

**Detail:** Exibe ou esconde o menu registrado sob a ID correspondente.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, hide, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.InputDialog(heading, rows, options)`**

**Detail:** Exibe uma caixa de diálogo na tela contendo formulários de entrada de dados (inputs, selects, etc.), retornando as respostas do usuário após o envio.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, input, dialog, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.inputDialog(heading, rows, options)`**

**Detail:** Executa os dados ou a operação “input dialog” por meio da API pública do módulo `menu`.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, input, dialog, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.RegisterContext(context)`**

**Detail:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, register, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.registerContext(context)`**

**Detail:** Registra os dados ou a operação “register context” no módulo ativo.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, register, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.RegisterMenu(data, cb)`**

**Detail:** Registra um menu contextual ou lista (baseado em ox_lib ou qb-menu). data descreve as opções e cb é acionado quando o menu é fechado ou atualizado.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, register, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.ShowContext(id)`**

**Detail:** Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, show, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.showContext(id)`**

**Detail:** Exibe os dados ou a operação “show context” ao jogador.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, show, context, client, contexto, nui, interface

---

### Function: **`pr_lib.menus.ShowMenu(id, startIndex)`**

**Detail:** Exibe ou esconde o menu registrado sob a ID correspondente.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, menus, show, client, contexto, nui, interface

---

### Function: **`pr_lib.registerContext(context)`**

**Detail:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, register, context, client, contexto, nui, interface

---

### Function: **`pr_lib.registerMenu(data, cb)`**

**Detail:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, register, client, contexto, nui, interface

---

### Function: **`pr_lib.showContext(id)`**

**Detail:** API nativa de contexto do pr_bridge, com estrutura 1:1 ao ox_lib.registerContext, mas renderizada pela NUI interna do bridge. Aceita campos como id, title, position, menu, canClose, searchPlaceholder, searchEmpty, options, onExit e onBack; cada opção pode usar title, description, icon, iconColor, iconAnimation, disabled, readOnly, metadata, progress, colorScheme, image, arrow, event, serverEvent, command, args, menu e onSelect. Funções onSelect ficam guardadas no runtime Lua e nunca são enviadas para a NUI. A lupa do cabeçalho filtra a lista atual por título, descrição, badge, tecla e metadata sem alterar os índices dos callbacks. O campo icon usa Bootstrap Icons e aceita nomes como person-fill, car-front-fill ou bi-geo-alt-fill; aliases comuns do formato anterior continuam convertidos para preservar compatibilidade.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, show, context, client, contexto, nui, interface

---

### Function: **`pr_lib.showMenu(id, startIndex)`**

**Detail:** Atalhos diretos para o adaptador de menu. Quando data.position não for informado, registerMenu usa o lado definido no painel visual global.

**Related/Dependents:** `pr_lib.getOpenContextMenu`, `pr_lib.hideContext`, `pr_lib.hideMenu`, `pr_lib.menus.AlertDialog`, `pr_lib.menus.alertDialog`, `pr_lib.menus.GetOpenContextMenu`

**Directory:** `pr_bridge/bridge/menus/*/client.lua; pr_bridge/interface/client/modules/context.lua`

**Context:** Client

**Tags:** menu, show, client, contexto, nui, interface

---

## interface

### Function: **`pr_lib.getVisualConfig()`**

**Detail:** Abre o painel administrativo global da interface e consulta sua configuração atual. A paleta, a opacidade e as posições de registerContext, metadata, alertDialog, inputDialog, registerMenu, notify, progress e TextUI ficam persistidas em interface/data/config.json e sincronizadas por state bag global. O comando /pr_ui_admin abre o mesmo painel; parentMenu pode apontar para um contexto pai e manter o botão de voltar.

**Related/Dependents:** `pr_lib.openVisualAdminMenu`

**Directory:** `pr_bridge/interface/client/ui.lua; pr_bridge/interface/client/host.lua; pr_bridge/interface/server/config.lua`

**Context:** Client

**Tags:** interface, get, visual, config, client

---

### Function: **`pr_lib.openVisualAdminMenu(parentMenu)`**

**Detail:** Abre o painel administrativo global da interface e consulta sua configuração atual. A paleta, a opacidade e as posições de registerContext, metadata, alertDialog, inputDialog, registerMenu, notify, progress e TextUI ficam persistidas em interface/data/config.json e sincronizadas por state bag global. O comando /pr_ui_admin abre o mesmo painel; parentMenu pode apontar para um contexto pai e manter o botão de voltar.

**Related/Dependents:** `pr_lib.getVisualConfig`

**Directory:** `pr_bridge/interface/client/ui.lua; pr_bridge/interface/client/host.lua; pr_bridge/interface/server/config.lua`

**Context:** Client

**Tags:** interface, open, visual, admin, menu, client, contexto, nui

---

## textui_adapter

### Function: **`pr_lib.hideTextUI()`**

**Detail:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.

**Related/Dependents:** `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, hide, text, ui, client

---

### Function: **`pr_lib.isTextUIOpen()`**

**Detail:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, is, text, uiopen, client

---

### Function: **`pr_lib.showTextUI(text, options)`**

**Detail:** Atalhos da raiz para os módulos nativos de notificação e TextUI do pr_bridge, sem sobrescrever o adaptador legado pr_lib.notify.

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, show, text, ui, client

---

### Function: **`pr_lib.textuiBridge.GetResourceName()`**

**Detail:** Retorna o recurso ativo de TextUI.

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, bridge, get, resource, name, client

---

### Function: **`pr_lib.textuiBridge.Hide()`**

**Detail:** Esconde o painel TextUI ativo.

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, bridge, hide, client

---

### Function: **`pr_lib.textuiBridge.hide()`**

**Detail:** Esconde o painel TextUI ativo.

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.Show`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, bridge, hide, client

---

### Function: **`pr_lib.textuiBridge.Show(text)`**

**Detail:** Mostra um painel flutuante de texto na tela (geralmente no canto superior esquerdo ou centralizado).

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, bridge, show, client

---

### Function: **`pr_lib.textuiBridge.show(text)`**

**Detail:** Mostra um painel flutuante de texto na tela (geralmente no canto superior esquerdo ou centralizado).

**Related/Dependents:** `pr_lib.hideTextUI`, `pr_lib.isTextUIOpen`, `pr_lib.showTextUI`, `pr_lib.textuiBridge.GetResourceName`, `pr_lib.textuiBridge.Hide`, `pr_lib.textuiBridge.hide`

**Directory:** `pr_bridge/bridge/textui/*/client.lua; pr_bridge/interface/client/modules/textui.lua`

**Context:** Client

**Tags:** textui, adapter, bridge, show, client

---

## input

### Function: **`pr_lib.inputDialog(heading, rows, options)`**

**Detail:** Atalhos da raiz para os diálogos nativos da interface do pr_bridge. Linhas numéricas aceitam step e precision; quando nenhum passo é informado, o campo aceita livremente valores decimais em vez de restringir a inteiros.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/interface/client/modules/input.lua`

**Context:** Client

**Tags:** input, dialog, client

---

## target

### Function: **`pr_lib.target.AddBoxZone(name, coords, size, rotation, options, debug)`**

**Detail:** Cria uma zona de interação retangular tridimensional invisível (ou com renderização em debug) no mapa.

**Related/Dependents:** `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, box, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addBoxZone(parameters)`**

**Detail:** Cria uma zona de interação retangular tridimensional invisível (ou com renderização em debug) no mapa.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, box, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addEntity(netIds, options)`**

**Detail:** Registra opções de interação via menu de alvo (olho/olhar) para uma entidade de rede (veículo, ped, objeto) baseada em sua ID de rede.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddEntity(netIds, options)`**

**Detail:** Registra opções de interação via menu de alvo (olho/olhar) para uma entidade de rede (veículo, ped, objeto) baseada em sua ID de rede.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addGlobalObject(options)`**

**Detail:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.AddGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, object, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddGlobalObject(options)`**

**Detail:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.addGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, object, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addGlobalOption(options)`**

**Detail:** Opções universais que se aplicam a qualquer elemento do mundo 3D focado pelo target.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, option, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddGlobalOption(options)`**

**Detail:** registra opções universais.

**Related/Dependents:** `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, add, global, option, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.addGlobalPed(options)`**

**Detail:** Registra opções aplicadas a todos os peds (NPCs) do jogo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, ped, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddGlobalPed(options)`**

**Detail:** Registra opções aplicadas a todos os peds (NPCs) do jogo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, ped, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addGlobalPlayer(options)`**

**Detail:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, player, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddGlobalPlayer(options)`**

**Detail:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, player, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addGlobalVehicle(options)`**

**Detail:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, vehicle, client, alvo, interação, zona, veículo, carro

---

### Function: **`pr_lib.target.AddGlobalVehicle(options)`**

**Detail:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, global, vehicle, client, alvo, interação, zona, veículo, carro

---

### Function: **`pr_lib.target.addLocalEntity(entities, options)`**

**Detail:** Cria interações de alvo para entidades locais criadas unicamente no cliente.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, local, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddLocalEntity(entities, options)`**

**Detail:** Cria interações de alvo para entidades locais criadas unicamente no cliente.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, local, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addModel(models, options)`**

**Detail:** Registra interações que estarão ativas globalmente para todos os objetos, peds ou veículos criados que utilizem o modelo 3D (hash/name) especificado (ex: lixeiras, hidrantes).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, model, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddModel(models, options)`**

**Detail:** Registra interações que estarão ativas globalmente para todos os objetos, peds ou veículos criados que utilizem o modelo 3D (hash/name) especificado (ex: lixeiras, hidrantes).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, model, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddPolyZone(name, points, thickness, options, debug)`**

**Detail:** Cria uma zona de interação poligonal complexa contornando uma área.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, poly, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addPolyZone(parameters)`**

**Detail:** Cria uma zona de interação poligonal complexa contornando uma área.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, poly, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.AddSphereZone(name, coords, radius, options, debug)`**

**Detail:** Cria uma zona de interação esférica em coordenadas 3D.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, sphere, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.addSphereZone(parameters)`**

**Detail:** Cria uma zona de interação esférica em coordenadas 3D.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, add, sphere, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.disableTargeting(state)`**

**Detail:** Ativa ou desativa temporariamente a possibilidade do jogador usar a tecla do target.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, disable, targeting, client, alvo, interação, zona

---

### Function: **`pr_lib.target.DisableTargeting(state)`**

**Detail:** Ativa ou desativa temporariamente a possibilidade do jogador usar a tecla do target.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, disable, targeting, client, alvo, interação, zona

---

### Function: **`pr_lib.target.FixOptions(options)`**

**Detail:** Normalização interna de parâmetros de callback de alvos.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, fix, options, client, alvo, interação, zona

---

### Function: **`pr_lib.target.GetResourceName()`**

**Detail:** Nome do recurso de target ativo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, get, resource, name, client, alvo, interação, zona

---

### Function: **`pr_lib.target.GetTargetOptions(...)`**

**Detail:** retorna as coleções aplicáveis ao alvo.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, get, options, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.getTargetOptions(entity, entityType, model)`**

**Detail:** retorna as coleções aplicáveis ao alvo.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, get, options, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.isActive()`**

**Detail:** informa se o target está ativo no cliente.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, is, active, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.IsActive()`**

**Detail:** informa se o target está ativo no cliente.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.RemoveGlobalOption`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, is, active, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.removeEntity(netIds, optionNames)`**

**Detail:** Remove opções específicas registradas na entidade de rede.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveEntity(netIds, optionNames)`**

**Detail:** Remove opções específicas registradas na entidade de rede.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeGlobalObject(optionNames)`**

**Detail:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, object, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveGlobalObject(optionNames)`**

**Detail:** Adiciona ou remove opções de interações aplicadas globalmente em todos os objetos físicos do GTA.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, object, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeGlobalOption(optionNames)`**

**Detail:** Opções universais que se aplicam a qualquer elemento do mundo 3D focado pelo target.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, option, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveGlobalOption(names)`**

**Detail:** remove opções universais do recurso chamador. As opções aceitam filtros groups, items, bones, offset, canInteract, menus menuName/openMenu e ações onSelect/export/event/serverEvent/command. O detalhamento arquitetural, configuração visual e compatibilidade qtarget estão em docs/TARGET_NATIVE.md.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.zoneExists`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, remove, global, option, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.removeGlobalPed(optionNames)`**

**Detail:** Registra opções aplicadas a todos os peds (NPCs) do jogo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, ped, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveGlobalPed(optionNames)`**

**Detail:** Registra opções aplicadas a todos os peds (NPCs) do jogo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, ped, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeGlobalPlayer(optionNames)`**

**Detail:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, player, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveGlobalPlayer(optionNames)`**

**Detail:** Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, player, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeGlobalVehicle(optionNames)`**

**Detail:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, vehicle, client, alvo, interação, zona, veículo, carro

---

### Function: **`pr_lib.target.RemoveGlobalVehicle(optionNames)`**

**Detail:** Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, global, vehicle, client, alvo, interação, zona, veículo, carro

---

### Function: **`pr_lib.target.removeLocalEntity(entities, optionNames)`**

**Detail:** Remove interações da entidade local.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, local, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveLocalEntity(entities, optionNames)`**

**Detail:** Remove interações da entidade local.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, local, entity, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeModel(models, optionNames)`**

**Detail:** Remove opções do modelo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, model, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveModel(models, optionNames)`**

**Detail:** Remove opções do modelo.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, model, client, alvo, interação, zona

---

### Function: **`pr_lib.target.removeZone(id)`**

**Detail:** Remove do sistema de alvos a zona de interação correspondente à ID informada.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.RemoveZone(id)`**

**Detail:** Remove do sistema de alvos a zona de interação correspondente à ID informada.

**Related/Dependents:** `pr_lib.target.AddBoxZone`, `pr_lib.target.addBoxZone`, `pr_lib.target.addEntity`, `pr_lib.target.AddEntity`, `pr_lib.target.addGlobalObject`, `pr_lib.target.AddGlobalObject`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Client

**Tags:** target, remove, zone, client, alvo, interação, zona

---

### Function: **`pr_lib.target.zoneExists(id)`**

**Detail:** verifica uma zona por ID ou nome.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, zone, exists, shared, alvo, interação, zona

---

### Function: **`pr_lib.target.ZoneExists(id)`**

**Detail:** verifica uma zona por ID ou nome.

**Related/Dependents:** `pr_lib.target.AddGlobalOption`, `pr_lib.target.GetTargetOptions`, `pr_lib.target.getTargetOptions`, `pr_lib.target.isActive`, `pr_lib.target.IsActive`, `pr_lib.target.RemoveGlobalOption`

**Directory:** `pr_bridge/bridge/targets/; pr_bridge/bridge/targets/native/api.lua`

**Context:** Shared

**Tags:** target, zone, exists, shared, alvo, interação, zona

---

## phone

### Function: **`pr_lib.phone.ClosePhone()`**

**Detail:** Força o fechamento imediato do celular.

**Related/Dependents:** `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, close, client

---

### Function: **`pr_lib.phone.CreateCall(name, number, image, anonymous)`**

**Detail:** Inicia a interface de discagem/ligação local no telefone.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, create, call, client

---

### Function: **`pr_lib.phone.EndCall()`**

**Detail:** Encerra a chamada ativa localmente.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, end, call, client

---

### Function: **`pr_lib.phone.GetCall()`**

**Detail:** Consultas de status de ligações ativas.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, get, call, client

---

### Function: **`pr_lib.phone.GetMetaFromSource(source)`**

**Detail:** Obtém metadados de mídia, contatos ou fotos salvos no celular do jogador.

**Related/Dependents:** `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, get, meta, from, source, server

---

### Function: **`pr_lib.phone.GetPhoneNames()`**

**Detail:** Lista de telefones cadastrados.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, get, names, server

---

### Function: **`pr_lib.phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)`**

**Detail:** Retorna o número de telefone do jogador com base no seu identificador.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, get, number, from, identifier, server

---

### Function: **`pr_lib.phone.HasEmailAccount(source)`**

**Detail:** Verifica se o jogador local criou ou possui uma conta ativa de e-mail no aplicativo.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, has, email, account, server

---

### Function: **`pr_lib.phone.InPhone()`**

**Detail:** Retorna true se o jogador local estiver ativamente com a interface gráfica do celular aberta.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.IsInCall`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, in, client

---

### Function: **`pr_lib.phone.IsInCall()`**

**Detail:** Consultas de status de ligações ativas.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCamera`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, is, in, call, client

---

### Function: **`pr_lib.phone.IsInCamera()`**

**Detail:** Retorna se o jogador está utilizando o aplicativo de foto/câmera do celular.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, is, in, camera, client

---

### Function: **`pr_lib.phone.IsInJobDuty(source)`**

**Detail:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.RemoveFromJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, is, in, job, duty, server

---

### Function: **`pr_lib.phone.RemoveFromJobDuty(source)`**

**Detail:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.SendNewMessageFromApp`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, remove, from, job, duty, server

---

### Function: **`pr_lib.phone.SendNewMessageFromApp(target, phoneNumber, message, appName)`**

**Detail:** Envia uma notificação/mensagem de texto simulada de um aplicativo (ex: WhatsApp, Bank) para o celular de destino.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, send, new, message, from, app, server

---

### Function: **`pr_lib.phone.SendSOSMessage(source, job, coords, messageType)`**

**Detail:** Envia uma notificação de chamado de emergência GPS para os celulares das facções militares/médicas em serviço.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, send, sosmessage, server

---

### Function: **`pr_lib.phone.SetCanOpenPhone(bool)`**

**Detail:** Bloqueia ou libera a capacidade do jogador de abrir a interface do telefone.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, set, can, open, client

---

### Function: **`pr_lib.phone.SetInJobDuty(source)`**

**Detail:** Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.

**Related/Dependents:** `pr_lib.phone.GetMetaFromSource`, `pr_lib.phone.GetPhoneNames`, `pr_lib.phone.GetPhoneNumberFromIdentifier`, `pr_lib.phone.HasEmailAccount`, `pr_lib.phone.IsInJobDuty`, `pr_lib.phone.RemoveFromJobDuty`

**Directory:** `pr_bridge/bridge/phones/*/server.lua`

**Context:** Server

**Tags:** phone, set, in, job, duty, server

---

### Function: **`pr_lib.phone.SetSOS(bool)`**

**Detail:** Ativa ou desativa alertas persistentes de GPS SOS locais.

**Related/Dependents:** `pr_lib.phone.ClosePhone`, `pr_lib.phone.CreateCall`, `pr_lib.phone.EndCall`, `pr_lib.phone.GetCall`, `pr_lib.phone.InPhone`, `pr_lib.phone.IsInCall`

**Directory:** `pr_bridge/bridge/phones/*/client.lua`

**Context:** Client

**Tags:** phone, set, sos, client

---

## progressbar

### Function: **`pr_lib.progress.doProgressbar(duration, label, anim)`**

**Detail:** Mostra uma barra de carregamento de progresso linear na tela com tempo especificado em duration (ms) executando opcionalmente uma animação no personagem (anim).

**Related/Dependents:** `pr_lib.progress.doProgressCircle`, `pr_lib.progress.progressCircle`, `pr_lib.progressCircle`

**Directory:** `pr_bridge/bridge/progressbar/*/client.lua`

**Context:** Client

**Tags:** progressbar, progress, do, client

---

### Function: **`pr_lib.progress.doProgressCircle(duration, label, anim)`**

**Detail:** Exibe um progresso circular real na NUI Svelte e preserva animação, props, bloqueios e cancelamento. As APIs pr_lib.progressCircle(data) e pr_lib.progress.progressCircle(data) aceitam o contrato do ox_lib, incluindo duration, label, position, canCancel, disable, anim, prop e color. O campo position aceita top/top-center, middle/center e bottom/bottom-center; quando informado na chamada ele prevalece sobre a posição global, e quando omitido o runtime Lua resolve e envia explicitamente a configuração administrativa persistida. Use /pr_progress_circle_test e /pr_progress_bar_test para homologar ambos usando a posição global configurada no painel; chamadas reais continuam podendo sobrescrever essa posição com position. A barra linear usa contorno branco nos segmentos e no indicador percentual.

**Related/Dependents:** `pr_lib.progress.doProgressbar`, `pr_lib.progress.progressCircle`, `pr_lib.progressCircle`

**Directory:** `pr_bridge/bridge/progressbar/*/client.lua`

**Context:** Client

**Tags:** progressbar, progress, do, circle, client

---

### Function: **`pr_lib.progress.progressCircle(data)`**

**Detail:** Executa os dados ou a operação “progress circle” por meio da API pública do módulo `progressbar`.

**Related/Dependents:** `pr_lib.progress.doProgressbar`, `pr_lib.progress.doProgressCircle`, `pr_lib.progressCircle`

**Directory:** `pr_bridge/bridge/progressbar/*/client.lua`

**Context:** Client

**Tags:** progressbar, progress, circle, client

---

### Function: **`pr_lib.progressCircle(data)`**

**Detail:** Executa os dados ou a operação “progress circle” por meio da API pública do módulo `outros_adaptadores_(pr_lib.banking,_pr_lib.callback,_pr_lib.ace,_pr_lib.progress,_pr_lib.weather)`.

**Related/Dependents:** `pr_lib.progress.doProgressbar`, `pr_lib.progress.doProgressCircle`, `pr_lib.progress.progressCircle`

**Directory:** `pr_bridge/bridge/progressbar/*/client.lua`

**Context:** Client

**Tags:** progressbar, progress, circle, client

---

## minigame

### Function: **`pr_lib.cancelSkillCheck()`**

**Detail:** Cancela o skill check ativo, fecha a NUI, libera o foco do teclado e faz a chamada em espera retornar false. A tecla ESC também cancela.

**Related/Dependents:** `pr_lib.minigame.CancelSkillCheck`, `pr_lib.minigame.SkillCheck`, `pr_lib.minigame.Start`, `pr_lib.minigames.Start`, `pr_lib.skillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, cancel, skill, check, client

---

### Function: **`pr_lib.minigame.CancelSkillCheck()`**

**Detail:** Cancela o skill check ativo, fecha a NUI, libera o foco do teclado e faz a chamada em espera retornar false. A tecla ESC também cancela.

**Related/Dependents:** `pr_lib.minigame.SkillCheck`, `pr_lib.minigame.Start`, `pr_lib.minigames.Start`, `pr_lib.cancelSkillCheck`, `pr_lib.skillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, cancel, skill, check, client

---

### Function: **`pr_lib.minigame.SkillCheck(...)`**

**Detail:** Executa o skill check nativo do pr_bridge. difficulties aceita nomes easy, medium e hard ou tabelas com areaSize e speedMultiplier; keys define as teclas válidas; options aceita label, timeout e position. A posição aceita top/top-center ou bottom/bottom-center, prevalece sobre a configuração global quando fornecida e usa a configuração administrativa quando omitida. Retorna um booleano após todas as etapas. Use /pr_skillcheck_top_test e /pr_skillcheck_bottom_test para homologar as duas posições.

**Related/Dependents:** `pr_lib.minigame.CancelSkillCheck`, `pr_lib.minigame.Start`, `pr_lib.minigames.Start`, `pr_lib.cancelSkillCheck`, `pr_lib.skillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, skill, check, client

---

### Function: **`pr_lib.minigame.Start(config, mode)`**

**Detail:** Executa o minigame ativo detectado pelo pr_bridge e retorna true em sucesso ou false em falha/cancelamento. O parametro config deve conter a configuracao do minigame, incluindo game e, quando aplicavel, dificultMinigame.vehiParked e dificultMinigame.vehiCarjack. O parametro mode seleciona qual dificuldade usar, por exemplo "parked" para veiculo estacionado ou "carjack" para roubo/abordagem. Adaptadores atuais: glitch-minigames, glitch-minigame, mhacking, ox_lib e fallback default.

**Related/Dependents:** `pr_lib.minigame.CancelSkillCheck`, `pr_lib.minigame.SkillCheck`, `pr_lib.minigames.Start`, `pr_lib.cancelSkillCheck`, `pr_lib.skillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, start, client

---

### Function: **`pr_lib.minigames.Start(config, mode)`**

**Detail:** Executa o minigame ativo detectado pelo pr_bridge e retorna true em sucesso ou false em falha/cancelamento. O parametro config deve conter a configuracao do minigame, incluindo game e, quando aplicavel, dificultMinigame.vehiParked e dificultMinigame.vehiCarjack. O parametro mode seleciona qual dificuldade usar, por exemplo "parked" para veiculo estacionado ou "carjack" para roubo/abordagem. Adaptadores atuais: glitch-minigames, glitch-minigame, mhacking, ox_lib e fallback default.

**Related/Dependents:** `pr_lib.minigame.CancelSkillCheck`, `pr_lib.minigame.SkillCheck`, `pr_lib.minigame.Start`, `pr_lib.cancelSkillCheck`, `pr_lib.skillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, minigames, start, client

---

### Function: **`pr_lib.skillCheck(difficulties, keys, options)`**

**Detail:** Executa o skill check nativo do pr_bridge. difficulties aceita nomes easy, medium e hard ou tabelas com areaSize e speedMultiplier; keys define as teclas válidas; options aceita label, timeout e position. A posição aceita top/top-center ou bottom/bottom-center, prevalece sobre a configuração global quando fornecida e usa a configuração administrativa quando omitida. Retorna um booleano após todas as etapas. Use /pr_skillcheck_top_test e /pr_skillcheck_bottom_test para homologar as duas posições.

**Related/Dependents:** `pr_lib.minigame.CancelSkillCheck`, `pr_lib.minigame.SkillCheck`, `pr_lib.minigame.Start`, `pr_lib.minigames.Start`, `pr_lib.cancelSkillCheck`

**Directory:** `pr_bridge/bridge/minigames/*/client.lua`

**Context:** Client

**Tags:** minigame, skill, check, client

---

## weather

### Function: **`pr_lib.weather.GetResourceName()`**

**Detail:** Retorna o recurso gerenciador de clima ativo (ex: "vSync", "cd_easytime").

**Related/Dependents:** `pr_lib.weather.ToggleSync`

**Directory:** `pr_bridge/bridge/weather/*/client.lua`

**Context:** Client

**Tags:** weather, get, resource, name, client

---

### Function: **`pr_lib.weather.ToggleSync(toggle)`**

**Detail:** Ativa ou congela a sincronização global de clima e hora locais para o jogador.

**Related/Dependents:** `pr_lib.weather.GetResourceName`

**Directory:** `pr_bridge/bridge/weather/*/client.lua`

**Context:** Client

**Tags:** weather, toggle, sync, client

---

## database

### Function: **`pr_lib.database.auto(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, auto, server

---

### Function: **`pr_lib.database.backup.create(options)`**

**Detail:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, backup, create, server

---

### Function: **`pr_lib.database.backup.export(options)`**

**Detail:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, backup, export, server

---

### Function: **`pr_lib.database.backup.run(options)`**

**Detail:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.createBackup`, `pr_lib.database.execute`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, backup, run, server

---

### Function: **`pr_lib.database.createBackup(options)`**

**Detail:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.execute`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, create, backup, server

---

### Function: **`pr_lib.database.execute(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, execute, client

---

### Function: **`pr_lib.database.execute(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.Execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, execute, server

---

### Function: **`pr_lib.database.Execute(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, execute, server

---

### Function: **`pr_lib.database.fetch(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, fetch, client

---

### Function: **`pr_lib.database.fetch(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, fetch, server

---

### Function: **`pr_lib.database.fetchAll(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, fetch, all, client

---

### Function: **`pr_lib.database.fetchAll(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, fetch, all, server

---

### Function: **`pr_lib.database.GetResourceName()`**

**Detail:** Retorna o recurso SQL de banco de dados ativo (ex: "oxmysql").

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.insert`, `pr_lib.database.isReady`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, get, resource, name, client

---

### Function: **`pr_lib.database.GetResourceName()`**

**Detail:** Retorna o recurso SQL de banco de dados ativo (ex: "oxmysql").

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, get, resource, name, server

---

### Function: **`pr_lib.database.insert(query, parameters, cb)`**

**Detail:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.isReady`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, insert, client

---

### Function: **`pr_lib.database.insert(query, parameters, cb)`**

**Detail:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, insert, server

---

### Function: **`pr_lib.database.Insert(query, parameters, cb)`**

**Detail:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, insert, server

---

### Function: **`pr_lib.database.isReady()`**

**Detail:** Retorna se a conexão inicial e o pool de conexões com o MySQL estão prontos para receber queries.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.query`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, is, ready, client

---

### Function: **`pr_lib.database.isReady()`**

**Detail:** Retorna se a conexão inicial e o pool de conexões com o MySQL estão prontos para receber queries.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, is, ready, server

---

### Function: **`pr_lib.database.Prepare(...)`**

**Detail:** Executa consultas preparadas e aceita um conjunto de parâmetros ou uma lista de conjuntos. No mysql-async e ghmattimysql, o pr_bridge preserva esse contrato por emulação segura sobre as APIs nativas.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, prepare, server

---

### Function: **`pr_lib.database.prepare(query, parameters, cb)`**

**Detail:** Executa consultas preparadas e aceita um conjunto de parâmetros ou uma lista de conjuntos. No mysql-async e ghmattimysql, o pr_bridge preserva esse contrato por emulação segura sobre as APIs nativas.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, prepare, server

---

### Function: **`pr_lib.database.query(query, parameters, cb)`**

**Detail:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, query, client

---

### Function: **`pr_lib.database.query(query, parameters, cb)`**

**Detail:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, query, server

---

### Function: **`pr_lib.database.RawExecute(...)`**

**Detail:** Executa escrita crua individual ou em lote e preserva o formato com affectedRows usado por consumidores compatíveis com oxmysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, raw, execute, server

---

### Function: **`pr_lib.database.rawExecute(query, parameters, cb)`**

**Detail:** Executa escrita crua individual ou em lote e preserva o formato com affectedRows usado por consumidores compatíveis com oxmysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, raw, execute, server

---

### Function: **`pr_lib.database.read(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, read, client

---

### Function: **`pr_lib.database.read(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, read, server

---

### Function: **`pr_lib.database.ready(cb)`**

**Detail:** Executa o callback assim que o adaptador selecionado estiver pronto; sem callback, retorna o estado atual.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, ready, server

---

### Function: **`pr_lib.database.run(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, run, client

---

### Function: **`pr_lib.database.run(query, parameters, cb)`**

**Detail:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, run, server

---

### Function: **`pr_lib.database.scalar(query, parameters, cb)`**

**Detail:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, scalar, client

---

### Function: **`pr_lib.database.scalar(query, parameters, cb)`**

**Detail:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, scalar, server

---

### Function: **`pr_lib.database.Scalar(query, parameters, cb)`**

**Detail:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, scalar, server

---

### Function: **`pr_lib.database.Select(query, parameters, cb)`**

**Detail:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, select, server

---

### Function: **`pr_lib.database.single(query, parameters, cb)`**

**Detail:** Executa a query e retorna uma tabela simples contendo as chaves da primeira linha encontrada (útil para buscar um único usuário).

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, single, client

---

### Function: **`pr_lib.database.single(query, parameters, cb)`**

**Detail:** Executa a query e retorna uma tabela simples contendo as chaves da primeira linha encontrada (útil para buscar um único usuário).

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, single, server

---

### Function: **`pr_lib.database.transaction(queries, parameters, cb)`**

**Detail:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, transaction, client

---

### Function: **`pr_lib.database.transaction(queries, parameters, cb)`**

**Detail:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, transaction, server

---

### Function: **`pr_lib.database.Transaction(queries, parameters, cb)`**

**Detail:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, transaction, server

---

### Function: **`pr_lib.database.update(query, parameters, cb)`**

**Detail:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, update, client

---

### Function: **`pr_lib.database.update(query, parameters, cb)`**

**Detail:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, update, server

---

### Function: **`pr_lib.database.Update(query, parameters, cb)`**

**Detail:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, update, server

---

### Function: **`pr_lib.database.write(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.execute`, `pr_lib.database.fetch`, `pr_lib.database.fetchAll`, `pr_lib.database.GetResourceName`, `pr_lib.database.insert`, `pr_lib.database.isReady`

**Directory:** `pr_bridge/bridge/database/*/client.lua`

**Context:** Client

**Tags:** database, write, client

---

### Function: **`pr_lib.database.write(query, parameters, cb)`**

**Detail:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, write, server

---

### Function: **`pr_lib.sqlBackup.create(options)`**

**Detail:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.

**Related/Dependents:** `pr_lib.database.auto`, `pr_lib.database.backup.create`, `pr_lib.database.backup.export`, `pr_lib.database.backup.run`, `pr_lib.database.createBackup`, `pr_lib.database.execute`

**Directory:** `pr_bridge/bridge/database/*/server.lua`

**Context:** Server

**Tags:** database, sql, backup, create, server

---

## fuel

### Function: **`pr_lib.fuel.GetFuel(vehicle)`**

**Detail:** Obtém a porcentagem ou volume de combustível atual de um veículo (de 0.0 a 100.0).

**Related/Dependents:** `pr_lib.fuel.GetResourceName`, `pr_lib.fuel.SetFuel`

**Directory:** `pr_bridge/bridge/fuel/*/client.lua`

**Context:** Client

**Tags:** fuel, get, client

---

### Function: **`pr_lib.fuel.GetResourceName()`**

**Detail:** Retorna o script de combustível ativo (ex: "ox_fuel", "legacyfuel").

**Related/Dependents:** `pr_lib.fuel.GetFuel`, `pr_lib.fuel.SetFuel`

**Directory:** `pr_bridge/bridge/fuel/*/client.lua`

**Context:** Client

**Tags:** fuel, get, resource, name, client

---

### Function: **`pr_lib.fuel.SetFuel(vehicle, amount, type)`**

**Detail:** Define a quantidade e tipo de combustível no veículo informado.

**Related/Dependents:** `pr_lib.fuel.GetFuel`, `pr_lib.fuel.GetResourceName`

**Directory:** `pr_bridge/bridge/fuel/*/client.lua`

**Context:** Client

**Tags:** fuel, set, client

---

## vehicle_key

### Function: **`pr_lib.vehicle_key.GetAllKeys(target)`**

**Detail:** Retorna a lista completa de placas de veículos das quais o jogador tem chaves guardadas.

**Related/Dependents:** `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, get, all, keys, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GetAllKeys(source)`**

**Detail:** Retorna a lista completa de placas de veículos das quais o jogador tem chaves guardadas.

**Related/Dependents:** `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, get, all, keys, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GetResourceName()`**

**Detail:** Script de chaves ativo localmente.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, get, resource, name, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveKey(plate)`**

**Detail:** Concede chaves permanentes ou temporárias de um veículo para o jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, give, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveKey(source, plate)`**

**Detail:** Concede chaves permanentes ou temporárias de um veículo para o jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, give, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveKeyItem(plate, vehicle)`**

**Detail:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, give, item, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveKeyItem(source, plate, netId)`**

**Detail:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, give, item, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveKeyMenu(plate)`**

**Detail:** Abre o menu para emprestar ou entregar a chave do veículo correspondente à placa para o jogador mais próximo.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeys`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, give, menu, client, veículo, carro, contexto, nui, interface

---

### Function: **`pr_lib.vehicle_key.GiveKeys(vehicle, plate)`**

**Detail:** Registra a chave localmente no chaveiro do veículo.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveTempKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, give, keys, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveTempKeys(plate)`**

**Detail:** Concede chaves permanentes ou temporárias de um veículo para o jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, give, temp, keys, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.GiveTempKeys(source, plate)`**

**Detail:** Concede chaves permanentes ou temporárias de um veículo para o jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, give, temp, keys, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HasKey(plate)`**

**Detail:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, has, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HasKey(source, plate)`**

**Detail:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HavePermanentKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, has, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HavePermanentKey(plate)`**

**Detail:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, have, permanent, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HavePermanentKey(source, plate)`**

**Detail:** Consulta se o jogador de ID source possui as chaves físicas de um veículo com a placa especificada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HaveTemporaryKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, have, permanent, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HaveTemporaryKey(plate)`**

**Detail:** Retorna se o jogador tem uma chave temporária/alugada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, have, temporary, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.HaveTemporaryKey(source, plate)`**

**Detail:** Retorna se o jogador tem uma chave temporária/alugada.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, have, temporary, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.ManageKeysMenu()`**

**Detail:** Exibe o menu de chaveiro contendo todas as chaves do jogador para controle e exclusões.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, manage, keys, menu, client, veículo, carro, contexto, nui, interface

---

### Function: **`pr_lib.vehicle_key.RemoveKey(plate)`**

**Detail:** Revoga e retira a posse de chaves.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, remove, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveKey(source, plate)`**

**Detail:** Revoga e retira a posse de chaves.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, remove, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveKeyItem(plate)`**

**Detail:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, remove, item, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveKeyItem(source, plate)`**

**Detail:** Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, remove, item, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveKeys(vehicle, plate)`**

**Detail:** Remove as chaves locais do veículo.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, remove, keys, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveTempKeys(plate)`**

**Detail:** Revoga e retira a posse de chaves.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, remove, temp, keys, client, veículo, carro

---

### Function: **`pr_lib.vehicle_key.RemoveTempKeys(source, plate)`**

**Detail:** Revoga e retira a posse de chaves.

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveTempKeys`, `pr_lib.vehicle_key.HasKey`, `pr_lib.vehicle_key.HavePermanentKey`

**Directory:** `pr_bridge/bridge/vehicle_key/*/server.lua`

**Context:** Server

**Tags:** vehicle, key, remove, temp, keys, server, veículo, carro

---

### Function: **`pr_lib.vehicle_key.ToggleLock()`**

**Detail:** Executa a ação local de chaveamento física do veículo (trancar/destrancar porta, tocar alarme e piscar setas).

**Related/Dependents:** `pr_lib.vehicle_key.GetAllKeys`, `pr_lib.vehicle_key.GetResourceName`, `pr_lib.vehicle_key.GiveKey`, `pr_lib.vehicle_key.GiveKeyItem`, `pr_lib.vehicle_key.GiveKeyMenu`, `pr_lib.vehicle_key.GiveKeys`

**Directory:** `pr_bridge/bridge/vehicle_key/*/client.lua`

**Context:** Client

**Tags:** vehicle, key, toggle, lock, client, veículo, carro

---

## banking

### Function: **`pr_lib.banking.AddAccountBalance(player, accountType, amount, reason)`**

**Detail:** Adiciona fundos à conta bancária de um jogador.

**Related/Dependents:** `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, add, account, balance, shared

---

### Function: **`pr_lib.banking.AddJobAccountBalance(account, amount, reason)`**

**Detail:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, add, job, account, balance, shared

---

### Function: **`pr_lib.banking.AddPlayerAccountBalance(player, accountType, amount, reason)`**

**Detail:** Adiciona fundos à conta bancária de um jogador.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, add, player, account, balance, shared

---

### Function: **`pr_lib.banking.GetAccountBalance(player, accountType)`**

**Detail:** Retorna o saldo de uma conta bancária de um jogador (ex: "personal", "savings").

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, get, account, balance, shared

---

### Function: **`pr_lib.banking.GetJobAccountBalance(account)`**

**Detail:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, get, job, account, balance, shared

---

### Function: **`pr_lib.banking.GetPlayerAccountBalance(player, accountType)`**

**Detail:** Retorna o saldo de uma conta bancária de um jogador (ex: "personal", "savings").

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetResourceName`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, get, player, account, balance, shared

---

### Function: **`pr_lib.banking.GetResourceName()`**

**Detail:** Retorna o recurso bancário ativo (ex: "okokBanking", "renewed_banking", etc.).

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, get, resource, name, shared

---

### Function: **`pr_lib.banking.RemoveAccountBalance(player, accountType, amount, reason)`**

**Detail:** Deduz dinheiro da conta bancária de um jogador.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, remove, account, balance, shared

---

### Function: **`pr_lib.banking.RemoveJobAccountBalance(account, amount, reason)`**

**Detail:** Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, remove, job, account, balance, shared

---

### Function: **`pr_lib.banking.RemovePlayerAccountBalance(player, accountType, amount, reason)`**

**Detail:** Deduz dinheiro da conta bancária de um jogador.

**Related/Dependents:** `pr_lib.banking.AddAccountBalance`, `pr_lib.banking.AddJobAccountBalance`, `pr_lib.banking.AddPlayerAccountBalance`, `pr_lib.banking.GetAccountBalance`, `pr_lib.banking.GetJobAccountBalance`, `pr_lib.banking.GetPlayerAccountBalance`

**Directory:** `pr_bridge/bridge/banking/*/{client,server}.lua`

**Context:** Shared

**Tags:** banking, remove, player, account, balance, shared

---

## callback

### Function: **`pr_lib.callback(...)`**

**Detail:** Executa os dados ou a operação “callback” por meio da API pública do módulo `callbacks_reforçados_(opt-in)`.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.await(name, timeout, ...)`**

**Detail:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.

**Related/Dependents:** `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, await, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.await(target, name, timeout, ...)`**

**Detail:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.

**Related/Dependents:** `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, await, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.awaitClient(target, name, timeout, ...)`**

**Detail:** Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (timeout em ms). Retorna os dados diretamente.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, await, client, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.cancel(requestId, reason?)`**

**Detail:** Cancela uma requisição pendente ativa.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, cancel, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.cancel(requestId, reason?)`**

**Detail:** Cancela uma requisição pendente ativa.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, cancel, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.getPending()`**

**Detail:** Retorna a lista de requisições de callback aguardando resposta.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, get, pending, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.getPending()`**

**Detail:** Retorna a lista de requisições de callback aguardando resposta.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, get, pending, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.getStats()`**

**Detail:** Retorna pendências, limites, timeouts, rejeições, respostas forjadas, cancelamentos e erros protegidos.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, get, stats, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.getStats()`**

**Detail:** Retorna pendências, limites, timeouts, rejeições, respostas forjadas, cancelamentos e erros protegidos.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, get, stats, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.ox(name, delay, cb, ...)`**

**Detail:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox.await`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, ox, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.ox(...)`**

**Detail:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, ox, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.ox.await(name, delay, ...)`**

**Detail:** Disponibiliza as ordens do ox_lib; no cliente também aplica o delay por evento.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.trigger`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, ox, await, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.trigger(name, cb, ...)`**

**Detail:** Dispara uma chamada assíncrona que executa um bloco de código no ambiente oposto (Server para Client, ou vice-versa) e executa a função cb entregando o resultado assim que a resposta for enviada.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`, `pr_lib.callback.ox.await`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Client

**Tags:** callback, trigger, client, request, resposta, timeout

---

### Function: **`pr_lib.callback.trigger(target, name, cb, ...)`**

**Detail:** Dispara uma chamada assíncrona que executa um bloco de código no ambiente oposto (Server para Client, ou vice-versa) e executa a função cb entregando o resultado assim que a resposta for enviada.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, trigger, server, request, resposta, timeout

---

### Function: **`pr_lib.callback.triggerClient(target, name, cb, ...)`**

**Detail:** Dispara um callback direcionado ao cliente do jogador target.

**Related/Dependents:** `pr_lib.callback.await`, `pr_lib.callback.awaitClient`, `pr_lib.callback.cancel`, `pr_lib.callback.getPending`, `pr_lib.callback.getStats`, `pr_lib.callback.ox`

**Directory:** `pr_bridge/bridge/callback/{client,server,secure_client,secure_server}.lua`

**Context:** Server

**Tags:** callback, trigger, client, server, request, resposta, timeout

---

## ace

### Function: **`pr_lib.ace.addAce(principal, aceName, allow)`**

**Detail:** Adiciona ou garante a existência de regras ACE dinamicamente (ex: conceder comandos administrativos).

**Related/Dependents:** `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, add, server

---

### Function: **`pr_lib.ace.addPrincipal(child, parent)`**

**Detail:** Vincula ou remove herança e hierarquia de principais do ACE (ex: herdar permissões de admin de um cargo superior).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, add, principal, server

---

### Function: **`pr_lib.ace.canAccess(source, options)`**

**Detail:** Verificação híbrida de permissão que analisa grupos de frameworks, empregos e permissões ACE configuradas no objeto options.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, can, access, server

---

### Function: **`pr_lib.ace.discoverPermissions(options)`**

**Detail:** Alias de compatibilidade para de getPermissionCatalog..

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, discover, permissions, server

---

### Function: **`pr_lib.ace.ensureAce(principal, aceName)`**

**Detail:** Adiciona ou garante a existência de regras ACE dinamicamente (ex: conceder comandos administrativos).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureCommandAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, ensure, server

---

### Function: **`pr_lib.ace.ensureCommandAce(principal, commandName)`**

**Detail:** Garante permissão ACE de execução de comando.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.getIdentifiers`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, ensure, command, server

---

### Function: **`pr_lib.ace.getIdentifiers(source)`**

**Detail:** Retorna todos os identificadores conhecidos de rede do jogador (license, discord, ip, steam, etc.).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, get, identifiers, server

---

### Function: **`pr_lib.ace.getPermissionCatalog(options)`**

**Detail:** Obtém os dados ou a operação “get permission catalog” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, get, permission, catalog, server

---

### Function: **`pr_lib.ace.hasAce(source, aceName)`**

**Detail:** Consulta nativa se o jogador possui permissões no arquivo de configurações server.cfg baseada em ACE principal (ex: IsPlayerAceAllowed).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, has, server

---

### Function: **`pr_lib.ace.hasCommandAce(source, commandName)`**

**Detail:** Retorna se o jogador tem permissão de execução de um comando do console nativo do FiveM.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, has, command, server

---

### Function: **`pr_lib.ace.hasFrameworkAccess(source, options)`**

**Detail:** Verificação híbrida de permissão que analisa grupos de frameworks, empregos e permissões ACE configuradas no objeto options.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, has, framework, access, server

---

### Function: **`pr_lib.ace.hasIdentifier(source, identifier)`**

**Detail:** Verifica se um jogador possui um identificador específico.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, has, identifier, server

---

### Function: **`pr_lib.ace.hasIdentifierAce(source, aceName)`**

**Detail:** Verifica se o identificador específico do jogador está explicitamente autorizado no ACE.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, has, identifier, server

---

### Function: **`pr_lib.ace.inWhitelist(source, whitelistName)`**

**Detail:** Verifica se o jogador está em uma whitelist do ACE correspondente ao nome da licença.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, in, whitelist, server

---

### Function: **`pr_lib.ace.isCommandAllowed(source, commandName)`**

**Detail:** Retorna se o jogador tem permissão de execução de um comando do console nativo do FiveM.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, is, command, allowed, server

---

### Function: **`pr_lib.ace.isIdentifierAceAllowed(source, aceName)`**

**Detail:** Verifica se o identificador específico do jogador está explicitamente autorizado no ACE.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, is, identifier, allowed, server

---

### Function: **`pr_lib.ace.isPlayerAceAllowed(source, aceName)`**

**Detail:** Consulta nativa se o jogador possui permissões no arquivo de configurações server.cfg baseada em ACE principal (ex: IsPlayerAceAllowed).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, is, player, allowed, server

---

### Function: **`pr_lib.ace.isWhitelisted(source, whitelistName)`**

**Detail:** Verifica se o jogador está em uma whitelist do ACE correspondente ao nome da licença.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, is, whitelisted, server

---

### Function: **`pr_lib.ace.listPermissions(options)`**

**Detail:** Alias de compatibilidade para de getPermissionCatalog..

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, list, permissions, server

---

### Function: **`pr_lib.ace.parseConvarList(raw)`**

**Detail:** Parser interno de strings de convars.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, parse, convar, list, server

---

### Function: **`pr_lib.ace.registerPermission(name, options)`**

**Detail:** Registra os dados ou a operação “register permission” no módulo ativo.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, register, permission, server

---

### Function: **`pr_lib.ace.removeAce(principal, aceName, allow)`**

**Detail:** Apaga ou altera regras ACE de permissão.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, remove, server

---

### Function: **`pr_lib.ace.removePrincipal(child, parent)`**

**Detail:** Vincula ou remove herança e hierarquia de principais do ACE (ex: herdar permissões de admin de um cargo superior).

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, remove, principal, server

---

### Function: **`pr_lib.ace.unregisterPermission(name)`**

**Detail:** Executa os dados ou a operação “unregister permission” por meio da API pública do módulo `ace`.

**Related/Dependents:** `pr_lib.ace.addAce`, `pr_lib.ace.addPrincipal`, `pr_lib.ace.canAccess`, `pr_lib.ace.discoverPermissions`, `pr_lib.ace.ensureAce`, `pr_lib.ace.ensureCommandAce`

**Directory:** `pr_bridge/bridge/ace/server.lua`

**Context:** Server

**Tags:** ace, unregister, permission, server

---

## addcommand

### Function: **`pr_lib.addCommand(commandName, properties, callback)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, client

---

### Function: **`pr_lib.addCommand(commandName, properties, callback)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, server

---

### Function: **`pr_lib.addCommand.add(commandName, properties, cb)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, client

---

### Function: **`pr_lib.addCommand.add(commandName, properties, cb)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, server

---

### Function: **`pr_lib.addCommand.addCommand(commandName, properties, cb)`**

**Detail:** Alias de compatibilidade para add.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, client

---

### Function: **`pr_lib.addCommand.addCommand(commandName, properties, cb)`**

**Detail:** Alias de compatibilidade para add.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, server

---

### Function: **`pr_lib.addCommand.getSuggestions()`**

**Detail:** Obtém os dados ou a operação “get suggestions” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, get, suggestions, client

---

### Function: **`pr_lib.addCommand.getSuggestions()`**

**Detail:** Obtém os dados ou a operação “get suggestions” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, get, suggestions, server

---

### Function: **`pr_lib.addCommand.hasSuggestion(commandName)`**

**Detail:** Verifica se os dados ou a operação “has suggestion” está disponível ou atende ao filtro informado.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, has, suggestion, client

---

### Function: **`pr_lib.addCommand.hasSuggestion(commandName)`**

**Detail:** Verifica se os dados ou a operação “has suggestion” está disponível ou atende ao filtro informado.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.register`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, has, suggestion, server

---

### Function: **`pr_lib.addCommand.register(commandName, properties, cb)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, register, client

---

### Function: **`pr_lib.addCommand.register(commandName, properties, cb)`**

**Detail:** API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.sendSuggestions`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, register, server

---

### Function: **`pr_lib.addCommand.sendSuggestions(target?)`**

**Detail:** Executa os dados ou a operação “send suggestions” por meio da API pública do módulo `addcommand`.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`

**Directory:** `pr_bridge/bridge/addCommand/client.lua`

**Context:** Client

**Tags:** addcommand, add, command, send, suggestions, client

---

### Function: **`pr_lib.addCommand.sendSuggestions(target?)`**

**Detail:** Executa os dados ou a operação “send suggestions” por meio da API pública do módulo `addcommand`.

**Related/Dependents:** `pr_lib.addCommand`, `pr_lib.addCommand.add`, `pr_lib.addCommand.addCommand`, `pr_lib.addCommand.getSuggestions`, `pr_lib.addCommand.hasSuggestion`, `pr_lib.addCommand.register`

**Directory:** `pr_bridge/bridge/addCommand/server.lua`

**Context:** Server

**Tags:** addcommand, add, command, send, suggestions, server

---

## addkeybind

### Function: **`pr_lib.addKeybind(data)`**

**Detail:** Registra mapeamentos de teclas nativas do GTA V listados em Configurações > Teclas > FiveM. O objeto data define nome, descrição, tecla padrão (defaultKey ou keys), combinações e callbacks onPressed/onReleased. Teclas simples preservam o name como comando, seguindo o contrato nativo do FiveM e do ox_lib; combinações usam comandos internos compactos.

**Related/Dependents:** `pr_lib.addKeybind.get`, `pr_lib.addKeybind.remove`

**Directory:** `pr_bridge/bridge/addKeybind/client.lua`

**Context:** Client

**Tags:** addkeybind, add, keybind, client

---

### Function: **`pr_lib.addKeybind.get(name)`**

**Detail:** Obtém o objeto mapeador de tecla registrado.

**Related/Dependents:** `pr_lib.addKeybind`, `pr_lib.addKeybind.remove`

**Directory:** `pr_bridge/bridge/addKeybind/client.lua`

**Context:** Client

**Tags:** addkeybind, add, keybind, get, client

---

### Function: **`pr_lib.addKeybind.remove(name)`**

**Detail:** Remove e desativa permanentemente o mapeamento de teclas associado.

**Related/Dependents:** `pr_lib.addKeybind`, `pr_lib.addKeybind.get`

**Directory:** `pr_bridge/bridge/addKeybind/client.lua`

**Context:** Client

**Tags:** addkeybind, add, keybind, remove, client

---

## translator

### Function: **`pr_lib.translator.showTranslatedNotify(title, description, notifyType, targetLang)`**

**Detail:** Traduz e exibe imediatamente um alerta de notificação com título e descrição localizados.

**Related/Dependents:** `pr_lib.translator.translate`, `pr_lib.translator.translateBatch`, `pr_lib.translator.translateMenu`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/client.lua`

**Context:** Client

**Tags:** translator, show, translated, notify, client

---

### Function: **`pr_lib.translator.translate(text, targetLang)`**

**Detail:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.

**Related/Dependents:** `pr_lib.translator.showTranslatedNotify`, `pr_lib.translator.translateBatch`, `pr_lib.translator.translateMenu`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/client.lua`

**Context:** Client

**Tags:** translator, translate, client

---

### Function: **`pr_lib.translator.translate(text, targetLang, cb)`**

**Detail:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.

**Related/Dependents:** `pr_lib.translator.translateBatch`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/server.lua`

**Context:** Server

**Tags:** translator, translate, server

---

### Function: **`pr_lib.translator.translateBatch(strings, targetLang)`**

**Detail:** Executa a tradução em lote de uma lista de strings de forma otimizada paralelamente para minimizar latência.

**Related/Dependents:** `pr_lib.translator.showTranslatedNotify`, `pr_lib.translator.translate`, `pr_lib.translator.translateMenu`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/client.lua`

**Context:** Client

**Tags:** translator, translate, batch, client

---

### Function: **`pr_lib.translator.translateBatch(strings, targetLang, cb)`**

**Detail:** Executa a tradução em lote de uma lista de strings de forma otimizada paralelamente para minimizar latência.

**Related/Dependents:** `pr_lib.translator.translate`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/server.lua`

**Context:** Server

**Tags:** translator, translate, batch, server

---

### Function: **`pr_lib.translator.translateMenu(menuData, targetLang)`**

**Detail:** Varre e traduz automaticamente todas as propriedades de título, descrição e opções de um objeto de menu (compatível com a estrutura de ox_lib menus) de forma dinâmica para a localidade do jogador antes de sua renderização.

**Related/Dependents:** `pr_lib.translator.showTranslatedNotify`, `pr_lib.translator.translate`, `pr_lib.translator.translateBatch`, `pr_lib.translator.translateText`

**Directory:** `pr_bridge/bridge/translator/client.lua`

**Context:** Client

**Tags:** translator, translate, menu, client, contexto, nui, interface

---

### Function: **`pr_lib.translator.translateText(text, targetLang)`**

**Detail:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.

**Related/Dependents:** `pr_lib.translator.showTranslatedNotify`, `pr_lib.translator.translate`, `pr_lib.translator.translateBatch`, `pr_lib.translator.translateMenu`

**Directory:** `pr_bridge/bridge/translator/client.lua`

**Context:** Client

**Tags:** translator, translate, text, client

---

### Function: **`pr_lib.translator.translateText(text, targetLang, cb)`**

**Detail:** Traduz um texto individual (text) para o idioma informado (targetLang) de forma assíncrona, retornando o resultado no callback cb e em uma Promise.

**Related/Dependents:** `pr_lib.translator.translate`, `pr_lib.translator.translateBatch`

**Directory:** `pr_bridge/bridge/translator/server.lua`

**Context:** Server

**Tags:** translator, translate, text, server

---

## github

### Function: **`pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`**

**Detail:** Executa os dados ou a operação “check dependency” por meio da API pública do módulo `github`.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/bridge/github/client.lua`

**Context:** Client

**Tags:** github, check, dependency, client

---

### Function: **`pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`**

**Detail:** Executa os dados ou a operação “check dependency” por meio da API pública do módulo `github`.

**Related/Dependents:** `pr_lib.github.versionCheck`

**Directory:** `pr_bridge/bridge/github/server.lua`

**Context:** Server

**Tags:** github, check, dependency, server

---

### Function: **`pr_lib.github.versionCheck(repository)`**

**Detail:** Executa os dados ou a operação “version check” por meio da API pública do módulo `github`.

**Related/Dependents:** `pr_lib.github.checkDependency`

**Directory:** `pr_bridge/bridge/github/server.lua`

**Context:** Server

**Tags:** github, version, check, server

---

## utils

### Function: **`pr_lib.utils.deepCopy(value, seen)`**

**Detail:** Clona profundamente uma tabela Lua recursivamente, incluindo metatabelas e evitando referências circulares.

**Related/Dependents:** `pr_lib.utils.dumpTable`, `pr_lib.utils.ensureTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.hash`, `pr_lib.utils.round`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, deep, copy, shared

---

### Function: **`pr_lib.utils.dumpTable(value, depth, seen)`**

**Detail:** Serializa uma tabela complexa em formato legível de texto para console (dump de depuração).

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.ensureTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.hash`, `pr_lib.utils.round`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, dump, table, shared

---

### Function: **`pr_lib.utils.ensureTable(value)`**

**Detail:** Garante que o retorno seja sempre uma tabela Lua (caso seja nulo ou string, encapsula/converte).

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.dumpTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.hash`, `pr_lib.utils.round`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, ensure, table, shared

---

### Function: **`pr_lib.utils.firstToUpper(value)`**

**Detail:** Converte a primeira letra da string em maiúscula.

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.dumpTable`, `pr_lib.utils.ensureTable`, `pr_lib.utils.hash`, `pr_lib.utils.round`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, first, to, upper, shared

---

### Function: **`pr_lib.utils.hash(value)`**

**Detail:** Converte uma string em um hash numérico nativo do GTA V (equivalente ao hash do Jenkins One-at-a-time).

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.dumpTable`, `pr_lib.utils.ensureTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.round`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, hash, shared

---

### Function: **`pr_lib.utils.round(value, decimals)`**

**Detail:** Arredonda um número de ponto flutuante para a quantidade de casas decimais informada.

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.dumpTable`, `pr_lib.utils.ensureTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.hash`, `pr_lib.utils.trim`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, round, shared

---

### Function: **`pr_lib.utils.trim(value)`**

**Detail:** Remove espaços em branco do início e do fim de uma string.

**Related/Dependents:** `pr_lib.utils.deepCopy`, `pr_lib.utils.dumpTable`, `pr_lib.utils.ensureTable`, `pr_lib.utils.firstToUpper`, `pr_lib.utils.hash`, `pr_lib.utils.round`

**Directory:** `pr_bridge/bridge/utils/shared.lua`

**Context:** Shared

**Tags:** utils, trim, shared

---

## math

### Function: **`pr_lib.math.almostEqual(a, b, epsilon)`**

**Detail:** Compara números de ponto flutuante considerando tolerâncias de arredondamento.

**Related/Dependents:** `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, almost, equal, shared

---

### Function: **`pr_lib.math.AlmostEqual(a, b, epsilon)`**

**Detail:** Compara números de ponto flutuante considerando tolerâncias de arredondamento.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, almost, equal, shared

---

### Function: **`pr_lib.math.clamp(value, minimum, maximum)`**

**Detail:** Limita um número dentro do intervalo especificado entre minimum e maximum.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, clamp, shared

---

### Function: **`pr_lib.math.Clamp(value, minimum, maximum)`**

**Detail:** Limita um número dentro do intervalo especificado entre minimum e maximum.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, clamp, shared

---

### Function: **`pr_lib.math.Deg2Rad(value)`**

**Detail:** Conversores de ângulos trigonométricos entre graus e radianos.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.degToRad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, deg2, rad, shared

---

### Function: **`pr_lib.math.degToRad(value)`**

**Detail:** Conversores de ângulos trigonométricos entre graus e radianos.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.distance2D`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, deg, to, rad, shared

---

### Function: **`pr_lib.math.distance2D(x1, y1, x2, y2)`**

**Detail:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, distance2, shared

---

### Function: **`pr_lib.math.Distance2D(x1, y1, x2, y2)`**

**Detail:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, distance2, shared

---

### Function: **`pr_lib.math.distance3D(x1, y1, z1, x2, y2, z2)`**

**Detail:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, distance3, shared

---

### Function: **`pr_lib.math.Distance3D(x1, y1, z1, x2, y2, z2)`**

**Detail:** Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, distance3, shared

---

### Function: **`pr_lib.math.groupdigits(value, separator?)`**

**Detail:** Executa os dados ou a operação “groupdigits” por meio da API pública do módulo `math`.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, groupdigits, shared

---

### Function: **`pr_lib.math.hexToRGB(value)`**

**Detail:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, hex, to, rgb, shared

---

### Function: **`pr_lib.math.HexToRGB(value)`**

**Detail:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, hex, to, rgb, shared

---

### Function: **`pr_lib.math.hexToRGBA(value)`**

**Detail:** Converte cores de string hexadecimal (ex: "#FF5500") em vetores de cores RGB ou RGBA com canais individuais.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, hex, to, rgba, shared

---

### Function: **`pr_lib.math.HexToRGBA(value)`**

**Detail:** Executa os dados ou a operação “hex to rgba” por meio da API pública do módulo `math`.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, hex, to, rgba, shared

---

### Function: **`pr_lib.math.inverseLerp(startValue, finishValue, value)`**

**Detail:** Retorna o fator decimal linear correspondente ao valor dentro do intervalo.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, inverse, lerp, shared

---

### Function: **`pr_lib.math.InverseLerp(startValue, finishValue, value)`**

**Detail:** Retorna o fator decimal linear correspondente ao valor dentro do intervalo.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, inverse, lerp, shared

---

### Function: **`pr_lib.math.length2(x, y)`**

**Detail:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, length2, shared

---

### Function: **`pr_lib.math.Length2(x, y)`**

**Detail:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, length2, shared

---

### Function: **`pr_lib.math.length3(x, y, z)`**

**Detail:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, length3, shared

---

### Function: **`pr_lib.math.Length3(x, y, z)`**

**Detail:** Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, length3, shared

---

### Function: **`pr_lib.math.Lerp(startValue, finishValue, duration)`**

**Detail:** Executa uma interpolação linear simples entre dois valores baseada no fator decimal.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, lerp, shared

---

### Function: **`pr_lib.math.lerp(startValue, finishValue, factor)`**

**Detail:** Executa uma interpolação linear simples entre dois valores baseada no fator decimal.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, lerp, shared

---

### Function: **`pr_lib.math.map(value, inMin, inMax, outMin, outMax)`**

**Detail:** Mapeia de forma linear um valor de um intervalo de entrada para outro de saída.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, map, shared

---

### Function: **`pr_lib.math.Map(value, inMin, inMax, outMin, outMax)`**

**Detail:** Mapeia de forma linear um valor de um intervalo de entrada para outro de saída.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, map, shared

---

### Function: **`pr_lib.math.normalToRotation(input)`**

**Detail:** Converte um vetor normal de superfície em um vetor tridimensional de rotação (Pitch, Roll, Yaw).

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, normal, to, rotation, shared

---

### Function: **`pr_lib.math.NormalToRotation(input)`**

**Detail:** Converte um vetor normal de superfície em um vetor tridimensional de rotação (Pitch, Roll, Yaw).

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, normal, to, rotation, shared

---

### Function: **`pr_lib.math.parse(value, minimum, maximum, shouldRound)`**

**Detail:** Processa e valida a consistência de um número dentro de restrições.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, parse, shared

---

### Function: **`pr_lib.math.ParseNumber(value, minimum, maximum, shouldRound)`**

**Detail:** Processa e valida a consistência de um número dentro de restrições.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, parse, number, shared

---

### Function: **`pr_lib.math.Rad2Deg(value)`**

**Detail:** Conversores de ângulos trigonométricos entre graus e radianos.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, rad2, deg, shared

---

### Function: **`pr_lib.math.radToDeg(value)`**

**Detail:** Conversores de ângulos trigonométricos entre graus e radianos.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, rad, to, deg, shared

---

### Function: **`pr_lib.math.round(value, places)`**

**Detail:** Arredonda números de ponto flutuante.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, round, shared

---

### Function: **`pr_lib.math.Round(value, places)`**

**Detail:** Arredonda números de ponto flutuante.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, round, shared

---

### Function: **`pr_lib.math.sign(value)`**

**Detail:** Retorna -1 se o número for negativo, 1 se for positivo e 0 se for nulo.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, sign, shared

---

### Function: **`pr_lib.math.Sign(value)`**

**Detail:** Retorna -1 se o número for negativo, 1 se for positivo e 0 se for nulo.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, sign, shared

---

### Function: **`pr_lib.math.toHex(value, upper)`**

**Detail:** Converte um número inteiro para uma string hexadecimal.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, hex, shared

---

### Function: **`pr_lib.math.ToHex(value, upper)`**

**Detail:** Converte um número inteiro para uma string hexadecimal.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, hex, shared

---

### Function: **`pr_lib.math.toScalars(value, minimum, maximum, shouldRound)`**

**Detail:** Processa tabelas ou tipos vetoriais normais do FiveM aplicando constraints matemáticas de limites.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, scalars, shared

---

### Function: **`pr_lib.math.ToScalars(value, minimum, maximum, shouldRound)`**

**Detail:** Executa os dados ou a operação “to scalars” por meio da API pública do módulo `math`.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, scalars, shared

---

### Function: **`pr_lib.math.toVector(value, minimum, maximum, shouldRound)`**

**Detail:** Processa tabelas ou tipos vetoriais normais do FiveM aplicando constraints matemáticas de limites.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, vector, shared

---

### Function: **`pr_lib.math.ToVector(value, minimum, maximum, shouldRound)`**

**Detail:** Executa os dados ou a operação “to vector” por meio da API pública do módulo `math`.

**Related/Dependents:** `pr_lib.math.almostEqual`, `pr_lib.math.AlmostEqual`, `pr_lib.math.clamp`, `pr_lib.math.Clamp`, `pr_lib.math.Deg2Rad`, `pr_lib.math.degToRad`

**Directory:** `pr_bridge/bridge/utils/numbers.lua`

**Context:** Shared

**Tags:** math, to, vector, shared

---

## table

### Function: **`pr_lib.table.clone(value, seen)`**

**Detail:** Gera uma cópia profunda (deep copy) de tabelas e metatabelas.

**Related/Dependents:** `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, clone, shared

---

### Function: **`pr_lib.table.contains(source, value)`**

**Detail:** Verifica se a tabela possui determinado valor entre seus elementos indexados.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, contains, shared

---

### Function: **`pr_lib.table.Contains(source, value)`**

**Detail:** Verifica se a tabela possui determinado valor entre seus elementos indexados.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, contains, shared

---

### Function: **`pr_lib.table.count(source)`**

**Detail:** Conta o número absoluto de elementos em uma tabela (incluindo chaves associativas não numéricas).

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, count, shared

---

### Function: **`pr_lib.table.Count(source)`**

**Detail:** Conta o número absoluto de elementos em uma tabela (incluindo chaves associativas não numéricas).

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.DeepClone`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, count, shared

---

### Function: **`pr_lib.table.DeepClone(value, seen)`**

**Detail:** Gera uma cópia profunda (deep copy) de tabelas e metatabelas.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.freeze`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, deep, clone, shared

---

### Function: **`pr_lib.table.freeze(value)`**

**Detail:** Executa os dados ou a operação “freeze” por meio da API pública do módulo `table`.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, freeze, shared

---

### Function: **`pr_lib.table.isfrozen(value)`**

**Detail:** Verifica os dados ou a operação “isfrozen” e retorna o estado correspondente.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, isfrozen, shared

---

### Function: **`pr_lib.table.map(source, callback)`**

**Detail:** Executa a projeção e mapeamento de chaves e valores a partir da execução do callback.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, map, shared

---

### Function: **`pr_lib.table.Map(source, callback)`**

**Detail:** Executa a projeção e mapeamento de chaves e valores a partir da execução do callback.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, map, shared

---

### Function: **`pr_lib.table.matches(left, right)`**

**Detail:** Compara recursivamente se duas tabelas possuem conteúdo exatamente idêntico.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, matches, shared

---

### Function: **`pr_lib.table.Matches(left, right)`**

**Detail:** Compara recursivamente se duas tabelas possuem conteúdo exatamente idêntico.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, matches, shared

---

### Function: **`pr_lib.table.merge(target, source, override)`**

**Detail:** Combina elementos de uma tabela de origem em uma tabela de destino.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, merge, shared

---

### Function: **`pr_lib.table.Merge(target, source, override)`**

**Detail:** Combina elementos de uma tabela de origem em uma tabela de destino.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, merge, shared

---

### Function: **`pr_lib.table.shuffle(source, copy, random)`**

**Detail:** Embaralha aleatoriamente a ordem dos elementos numéricos indexados da tabela.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, shuffle, shared

---

### Function: **`pr_lib.table.Shuffle(source, copy, random)`**

**Detail:** Embaralha aleatoriamente a ordem dos elementos numéricos indexados da tabela.

**Related/Dependents:** `pr_lib.table.clone`, `pr_lib.table.contains`, `pr_lib.table.Contains`, `pr_lib.table.count`, `pr_lib.table.Count`, `pr_lib.table.DeepClone`

**Directory:** `pr_bridge/bridge/utils/tables.lua`

**Context:** Shared

**Tags:** table, shuffle, shared

---

## ids

### Function: **`pr_lib.ids.createUniqueId(registry, length, pattern)`**

**Detail:** Gera uma string aleatória baseada no padrão (pattern ex: "ALPHANUMERIC") com o comprimento fornecido, garantindo sua exclusividade comparando com uma tabela de registros existentes (registry).

**Related/Dependents:** `pr_lib.ids.CreateUniqueId`

**Directory:** `pr_bridge/bridge/utils/ids.lua`

**Context:** Shared

**Tags:** ids, create, unique, id, shared

---

### Function: **`pr_lib.ids.CreateUniqueId(registry, length, pattern)`**

**Detail:** Gera uma string aleatória baseada no padrão (pattern ex: "ALPHANUMERIC") com o comprimento fornecido, garantindo sua exclusividade comparando com uma tabela de registros existentes (registry).

**Related/Dependents:** `pr_lib.ids.createUniqueId`

**Directory:** `pr_bridge/bridge/utils/ids.lua`

**Context:** Shared

**Tags:** ids, create, unique, id, shared

---

## fivem.raycast

### Function: **`pr_lib.raycast.fromCamera(distance, flags, ignoreFlags, ignoreEntity)`**

**Detail:** Projeta um feixe de raycast tridimensional invisível a partir da câmera do jogador na direção de foco da mira até a distância máxima informada. Retorna se atingiu algo, as coordenadas de impacto, o vetor normal e a ID da entidade atingida (veículo, ped ou objeto).

**Related/Dependents:** `pr_lib.raycast.FromCamera`, `pr_lib.raycast.fromCoords`, `pr_lib.raycast.FromCoords`

**Directory:** `pr_bridge/bridge/fivem/raycast/client.lua`

**Context:** Client

**Tags:** raycast, from, camera, client

---

### Function: **`pr_lib.raycast.FromCamera(distance, flags, ignoreFlags, ignoreEntity)`**

**Detail:** Projeta um feixe de raycast tridimensional invisível a partir da câmera do jogador na direção de foco da mira até a distância máxima informada. Retorna se atingiu algo, as coordenadas de impacto, o vetor normal e a ID da entidade atingida (veículo, ped ou objeto).

**Related/Dependents:** `pr_lib.raycast.fromCamera`, `pr_lib.raycast.fromCoords`, `pr_lib.raycast.FromCoords`

**Directory:** `pr_bridge/bridge/fivem/raycast/client.lua`

**Context:** Client

**Tags:** raycast, from, camera, client

---

### Function: **`pr_lib.raycast.fromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`**

**Detail:** Dispara um feixe de raycast a partir de coordenadas absolutas de origem (origin) para um destino (destination).

**Related/Dependents:** `pr_lib.raycast.fromCamera`, `pr_lib.raycast.FromCamera`, `pr_lib.raycast.FromCoords`

**Directory:** `pr_bridge/bridge/fivem/raycast/client.lua`

**Context:** Client

**Tags:** raycast, from, coords, client

---

### Function: **`pr_lib.raycast.FromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`**

**Detail:** Dispara um feixe de raycast a partir de coordenadas absolutas de origem (origin) para um destino (destination).

**Related/Dependents:** `pr_lib.raycast.fromCamera`, `pr_lib.raycast.FromCamera`, `pr_lib.raycast.fromCoords`

**Directory:** `pr_bridge/bridge/fivem/raycast/client.lua`

**Context:** Client

**Tags:** raycast, from, coords, client

---

## fivem.net

### Function: **`pr_lib.fivem.net.getEntity(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, get, entity, client

---

### Function: **`pr_lib.fivem.net.getEntity(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, get, entity, server

---

### Function: **`pr_lib.fivem.net.getNetId(entity)`**

**Detail:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, get, id, client

---

### Function: **`pr_lib.fivem.net.getNetId(entity)`**

**Detail:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, get, id, server

---

### Function: **`pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`**

**Detail:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, get, owner, client

---

### Function: **`pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`**

**Detail:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, get, owner, server

---

### Function: **`pr_lib.fivem.net.getVehicle(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, get, vehicle, client, veículo, carro

---

### Function: **`pr_lib.fivem.net.getVehicle(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.isValidNetId`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, get, vehicle, server, veículo, carro

---

### Function: **`pr_lib.fivem.net.isValidNetId(netId)`**

**Detail:** Verifica os dados ou a operação “is valid net id” e retorna o estado correspondente.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, is, valid, id, client

---

### Function: **`pr_lib.fivem.net.isValidNetId(netId)`**

**Detail:** Verifica os dados ou a operação “is valid net id” e retorna o estado correspondente.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.resolveVehicle`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, is, valid, id, server

---

### Function: **`pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`**

**Detail:** Executa os dados ou a operação “resolve vehicle” por meio da API pública do módulo `fivem.net`.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`

**Directory:** `pr_bridge/bridge/fivem/net/client.lua`

**Context:** Client

**Tags:** net, resolve, vehicle, client, veículo, carro

---

### Function: **`pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`**

**Detail:** Executa os dados ou a operação “resolve vehicle” por meio da API pública do módulo `fivem.net`.

**Related/Dependents:** `pr_lib.fivem.net.getEntity`, `pr_lib.fivem.net.getNetId`, `pr_lib.fivem.net.getOwner`, `pr_lib.fivem.net.getVehicle`, `pr_lib.fivem.net.isValidNetId`

**Directory:** `pr_bridge/bridge/fivem/net/server.lua`

**Context:** Server

**Tags:** net, resolve, vehicle, server, veículo, carro

---

## fivem.ui

### Function: **`pr_lib.setClipboard(value)`**

**Detail:** Define ou atualiza os dados ou a operação “set clipboard” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.Draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.ui.DrawRect`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, set, clipboard, client

---

### Function: **`pr_lib.ui.draw2DText(text, x, y, scale, textColor, font)`**

**Detail:** Desenha na tela do jogador textos em coordenadas bidimensionais de proporção decimal (de 0.0 a 1.0).

**Related/Dependents:** `pr_lib.ui.Draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.ui.DrawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw2, dtext, client

---

### Function: **`pr_lib.ui.Draw2DText(text, x, y, scale, textColor, font)`**

**Detail:** Desenha na tela do jogador textos em coordenadas bidimensionais de proporção decimal (de 0.0 a 1.0).

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.ui.DrawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw2, dtext, client

---

### Function: **`pr_lib.ui.draw3DText(text, coords, scale, textColor, font)`**

**Detail:** Desenha textos flutuantes projetados no mundo físico tridimensional em coordenadas GPS.

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.Draw2DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.ui.DrawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw3, dtext, client

---

### Function: **`pr_lib.ui.Draw3DText(text, coords, scale, textColor, font)`**

**Detail:** Desenha textos flutuantes projetados no mundo físico tridimensional em coordenadas GPS.

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.Draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.ui.DrawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw3, dtext, client

---

### Function: **`pr_lib.ui.drawRect(x, y, width, height, rectColor)`**

**Detail:** Desenha retângulos bidimensionais coloridos na HUD da tela do jogador local.

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.Draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.DrawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw, rect, client

---

### Function: **`pr_lib.ui.DrawRect(x, y, width, height, rectColor)`**

**Detail:** Desenha retângulos bidimensionais coloridos na HUD da tela do jogador local.

**Related/Dependents:** `pr_lib.ui.draw2DText`, `pr_lib.ui.Draw2DText`, `pr_lib.ui.draw3DText`, `pr_lib.ui.Draw3DText`, `pr_lib.ui.drawRect`, `pr_lib.setClipboard`

**Directory:** `pr_bridge/bridge/fivem/ui/client.lua`

**Context:** Client

**Tags:** ui, draw, rect, client

---

## fivem.dui

### Function: **`pr_lib.dui.clear(target)`**

**Detail:** Força limpeza de texturas.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, clear, server

---

### Function: **`pr_lib.dui.create(options, width, height)`**

**Detail:** Comanda sincronizadamente que clientes em target carreguem uma nova instância do navegador DUI.

**Related/Dependents:** `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, client

---

### Function: **`pr_lib.dui.create(target, options)`**

**Detail:** Comanda sincronizadamente que clientes em target carreguem uma nova instância do navegador DUI.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, server

---

### Function: **`pr_lib.dui.createPoly(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, poly, client

---

### Function: **`pr_lib.dui.createPoly(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, poly, server

---

### Function: **`pr_lib.dui.createPoly4(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, poly4, server

---

### Function: **`pr_lib.dui.createRenderTarget(target, options)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, render, target, client, alvo, interação, zona

---

### Function: **`pr_lib.dui.createRenderTarget(target, options)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, render, target, server, alvo, interação, zona

---

### Function: **`pr_lib.dui.createReplacement(target, options)`**

**Detail:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, replacement, client

---

### Function: **`pr_lib.dui.createReplaceTexture(target, options)`**

**Detail:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createSprite`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, replace, texture, client

---

### Function: **`pr_lib.dui.createReplaceTexture(target, options)`**

**Detail:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, replace, texture, server

---

### Function: **`pr_lib.dui.createSprite(options)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.destroy`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, create, sprite, client

---

### Function: **`pr_lib.dui.createSprite(target, options)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, create, sprite, server

---

### Function: **`pr_lib.dui.destroy(target)`**

**Detail:** Fecha e apaga a instância DUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, destroy, client

---

### Function: **`pr_lib.dui.destroy(target, id)`**

**Detail:** Fecha e apaga a instância DUI.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, destroy, server

---

### Function: **`pr_lib.dui.disableMouse(target)`**

**Detail:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, disable, mouse, client

---

### Function: **`pr_lib.dui.drawSprite(target, options)`**

**Detail:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, draw, sprite, client

---

### Function: **`pr_lib.dui.enableMouse(target, options)`**

**Detail:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, enable, mouse, client

---

### Function: **`pr_lib.dui.focus(target, options)`**

**Detail:** Foca o controle de teclado e mouse do jogador para interagir diretamente com o navegador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, focus, client

---

### Function: **`pr_lib.dui.get(id)`**

**Detail:** Consultas de status e instâncias de DUIs server-side.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, get, client

---

### Function: **`pr_lib.dui.get(id)`**

**Detail:** Consultas de status e instâncias de DUIs server-side.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, get, server

---

### Function: **`pr_lib.dui.list()`**

**Detail:** Consultas de status e instâncias de DUIs server-side.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, list, client

---

### Function: **`pr_lib.dui.list()`**

**Detail:** Consultas de status e instâncias de DUIs server-side.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, list, server

---

### Function: **`pr_lib.dui.nuiUrl(path, ownerResource)`**

**Detail:** Gera endereços locais válidos apontando para páginas HTML e assets de recursos NUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, nui, url, client

---

### Function: **`pr_lib.dui.poly(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, poly, client

---

### Function: **`pr_lib.dui.poly(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, poly, server

---

### Function: **`pr_lib.dui.poly4(target, options)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, poly4, server

---

### Function: **`pr_lib.dui.remove(target, id)`**

**Detail:** Fecha e apaga a instância DUI.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, remove, server

---

### Function: **`pr_lib.dui.removeReplaceTexture(target, options)`**

**Detail:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, remove, replace, texture, client

---

### Function: **`pr_lib.dui.renderTarget(target, options)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, render, target, client, alvo, interação, zona

---

### Function: **`pr_lib.dui.renderTarget(target, options)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, render, target, server, alvo, interação, zona

---

### Function: **`pr_lib.dui.replaceTexture(target, options)`**

**Detail:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, replace, texture, client

---

### Function: **`pr_lib.dui.replaceTexture(target, options)`**

**Detail:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, replace, texture, server

---

### Function: **`pr_lib.dui.send(target, message)`**

**Detail:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, client

---

### Function: **`pr_lib.dui.send(target, id, message)`**

**Detail:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, send, server

---

### Function: **`pr_lib.dui.sendMessage(target, message)`**

**Detail:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, message, client

---

### Function: **`pr_lib.dui.sendMessage(target, id, message)`**

**Detail:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, send, message, server

---

### Function: **`pr_lib.dui.sendMouseDown(target, button)`**

**Detail:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, mouse, down, client

---

### Function: **`pr_lib.dui.sendMouseMove(target, x, y)`**

**Detail:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, mouse, move, client

---

### Function: **`pr_lib.dui.sendMouseUp(target, button)`**

**Detail:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, mouse, up, client

---

### Function: **`pr_lib.dui.sendMouseWheel(target, deltaX, deltaY)`**

**Detail:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, send, mouse, wheel, client

---

### Function: **`pr_lib.dui.setBrightness(target, brightness)`**

**Detail:** Controla opacidade e brilho de renderização da textura.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, set, brightness, client

---

### Function: **`pr_lib.dui.setBrightness(target, id, brightness)`**

**Detail:** Controla opacidade e brilho de renderização da textura.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, set, brightness, server

---

### Function: **`pr_lib.dui.setOpacity(target, opacity)`**

**Detail:** Controla opacidade e brilho de renderização da textura.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, set, opacity, client

---

### Function: **`pr_lib.dui.setOpacity(target, id, opacity)`**

**Detail:** Controla opacidade e brilho de renderização da textura.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, set, opacity, server

---

### Function: **`pr_lib.dui.setUrl(target, url)`**

**Detail:** Redireciona o navegador DUI para outro endereço web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, set, url, client

---

### Function: **`pr_lib.dui.setUrl(target, id, url)`**

**Detail:** Redireciona o navegador DUI para outro endereço web.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, set, url, server

---

### Function: **`pr_lib.dui.startPoly(target, options)`**

**Detail:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, start, poly, client

---

### Function: **`pr_lib.dui.startSprite(target, options)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, start, sprite, client

---

### Function: **`pr_lib.dui.startSprite(target, id, options)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, start, sprite, server

---

### Function: **`pr_lib.dui.stopPoly(target)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, stop, poly, client

---

### Function: **`pr_lib.dui.stopPoly(target, id)`**

**Detail:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, stop, poly, server

---

### Function: **`pr_lib.dui.stopRenderTarget(target)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, stop, render, target, client, alvo, interação, zona

---

### Function: **`pr_lib.dui.stopRenderTarget(target, id)`**

**Detail:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, stop, render, target, server, alvo, interação, zona

---

### Function: **`pr_lib.dui.stopSprite(target)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, stop, sprite, client

---

### Function: **`pr_lib.dui.stopSprite(target, id)`**

**Detail:** Desenha texturas DUI em elementos gráficos 2D.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, stop, sprite, server

---

### Function: **`pr_lib.dui.sync(target)`**

**Detail:** Sincroniza DUIs ativas com novos jogadores conectados que entraram no escopo.

**Related/Dependents:** `pr_lib.dui.clear`, `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createPoly4`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplaceTexture`

**Directory:** `pr_bridge/bridge/fivem/dui/server.lua`

**Context:** Server

**Tags:** dui, sync, server

---

### Function: **`pr_lib.dui.toggleMouse(target, state)`**

**Detail:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, toggle, mouse, client

---

### Function: **`pr_lib.dui.unfocus()`**

**Detail:** Foca o controle de teclado e mouse do jogador para interagir diretamente com o navegador.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, unfocus, client

---

### Function: **`pr_lib.dui.url(path, ownerResource)`**

**Detail:** Gera endereços locais válidos apontando para páginas HTML e assets de recursos NUI.

**Related/Dependents:** `pr_lib.dui.create`, `pr_lib.dui.createPoly`, `pr_lib.dui.createRenderTarget`, `pr_lib.dui.createReplacement`, `pr_lib.dui.createReplaceTexture`, `pr_lib.dui.createSprite`

**Directory:** `pr_bridge/bridge/fivem/dui/client.lua`

**Context:** Client

**Tags:** dui, url, client

---

## fivem.tuning

### Function: **`pr_lib.fivem.tuning.apply(vehicle, props, options)`**

**Detail:** Aplica modificações físicas, cores e upgrades no veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, apply, client

---

### Function: **`pr_lib.fivem.tuning.apply(vehicle, props, options)`**

**Detail:** Aplica modificações físicas, cores e upgrades no veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.snapshot`

**Directory:** `pr_bridge/bridge/fivem/tuning/server.lua`

**Context:** Server

**Tags:** tuning, apply, server

---

### Function: **`pr_lib.fivem.tuning.applyNetId(netId, props, options)`**

**Detail:** Envia comando para que clientes apliquem propriedades em um veículo baseado na sua ID de rede.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, apply, net, id, client

---

### Function: **`pr_lib.fivem.tuning.applyNetId(netId, props, target, options)`**

**Detail:** Envia comando para que clientes apliquem propriedades em um veículo baseado na sua ID de rede.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.snapshot`

**Directory:** `pr_bridge/bridge/fivem/tuning/server.lua`

**Context:** Server

**Tags:** tuning, apply, net, id, server

---

### Function: **`pr_lib.fivem.tuning.get(vehicle)`**

**Detail:** Retorna uma tabela contendo todas as propriedades de customizações, modificações mecânicas, cores e níveis de integridade do veículo correspondente.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, get, client

---

### Function: **`pr_lib.fivem.tuning.repair(vehicle)`**

**Detail:** Conserta visualmente e mecanicamente o motor, carroceria e pneus do veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, repair, client

---

### Function: **`pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`**

**Detail:** Restaura o estado do veículo a partir de um snapshot salvo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.setExtra`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, restore, client

---

### Function: **`pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`**

**Detail:** Restaura o estado do veículo a partir de um snapshot salvo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.snapshot`

**Directory:** `pr_bridge/bridge/fivem/tuning/server.lua`

**Context:** Server

**Tags:** tuning, restore, server

---

### Function: **`pr_lib.fivem.tuning.setExtra(vehicle, extraId, state)`**

**Detail:** Ativa ou remove extras e acessórios nativos de carroceria instalados no veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setFuel`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, extra, client

---

### Function: **`pr_lib.fivem.tuning.setFuel(vehicle, fuelLevel)`**

**Detail:** Altera diretamente o nível físico de combustível do motor do veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, fuel, client

---

### Function: **`pr_lib.fivem.tuning.setMod(vehicle, modType, modIndex, customTires)`**

**Detail:** Altera peças de modificação mecânica (como Motor, Transmissão, Suspensão) ou visual (aerofólios, capôs).

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, mod, client

---

### Function: **`pr_lib.fivem.tuning.setNeon(vehicle, enabled, color)`**

**Detail:** Configura luzes de neons instaladas embaixo do chassi do veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, neon, client

---

### Function: **`pr_lib.fivem.tuning.setPlate(vehicle, plate)`**

**Detail:** Modifica a string exibida na placa física do veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, plate, client

---

### Function: **`pr_lib.fivem.tuning.setXenon(vehicle, enabled, color)`**

**Detail:** Configura faróis de Xenon e tonalidades de cores nos faróis do veículo.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, set, xenon, client

---

### Function: **`pr_lib.fivem.tuning.snapshot(vehicle)`**

**Detail:** Retorna tabela vazia para stubs do servidor.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, snapshot, client

---

### Function: **`pr_lib.fivem.tuning.snapshot()`**

**Detail:** Retorna tabela vazia para stubs do servidor.

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.restore`

**Directory:** `pr_bridge/bridge/fivem/tuning/server.lua`

**Context:** Server

**Tags:** tuning, snapshot, server

---

### Function: **`pr_lib.fivem.tuning.toggleMod(vehicle, modType, state)`**

**Detail:** Liga ou desliga modificações de performance específicas (como Turbo).

**Related/Dependents:** `pr_lib.fivem.tuning.apply`, `pr_lib.fivem.tuning.applyNetId`, `pr_lib.fivem.tuning.get`, `pr_lib.fivem.tuning.repair`, `pr_lib.fivem.tuning.restore`, `pr_lib.fivem.tuning.setExtra`

**Directory:** `pr_bridge/bridge/fivem/tuning/client.lua`

**Context:** Client

**Tags:** tuning, toggle, mod, client

---

## fivem.drawtext

### Function: **`pr_lib.drawtext.change(text, position, options)`**

**Detail:** Altera o texto ou propriedades do painel DrawText ativo na tela.

**Related/Dependents:** `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, change, client

---

### Function: **`pr_lib.drawtext.ChangeText(text, position, options)`**

**Detail:** Altera o texto ou propriedades do painel DrawText ativo na tela.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, change, text, client

---

### Function: **`pr_lib.drawtext.draw2d(params)`**

**Detail:** Métodos de desenho 2D.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw2d, client

---

### Function: **`pr_lib.drawtext.draw3d(params)`**

**Detail:** Métodos de desenho de textos tridimensionais.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw3d, client

---

### Function: **`pr_lib.drawtext.DrawText(text, position, options)`**

**Detail:** Exibe textos flutuantes formatados.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.drawText2d`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text, client

---

### Function: **`pr_lib.drawtext.drawText2d(params)`**

**Detail:** Métodos de desenho 2D.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.DrawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text2d, client

---

### Function: **`pr_lib.drawtext.DrawText2d(params)`**

**Detail:** Métodos de desenho 2D.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text2d, client

---

### Function: **`pr_lib.drawtext.DrawText2D(params)`**

**Detail:** Métodos de desenho 2D.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text2, client

---

### Function: **`pr_lib.drawtext.drawText3d(params)`**

**Detail:** Métodos de desenho de textos tridimensionais.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text3d, client

---

### Function: **`pr_lib.drawtext.DrawText3d(params)`**

**Detail:** Métodos de desenho de textos tridimensionais.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text3d, client

---

### Function: **`pr_lib.drawtext.DrawText3D(params)`**

**Detail:** Métodos de desenho de textos tridimensionais.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, draw, text3, client

---

### Function: **`pr_lib.drawtext.hide()`**

**Detail:** Apaga o painel de texto.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, hide, client

---

### Function: **`pr_lib.drawtext.HideText()`**

**Detail:** Apaga o painel de texto.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, hide, text, client

---

### Function: **`pr_lib.drawtext.isOpen()`**

**Detail:** Retorna se há algum painel de DrawText ativo na tela.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, is, open, client

---

### Function: **`pr_lib.drawtext.keyPressed(delay)`**

**Detail:** Registra o acionamento de teclas de atalho de interações DrawText com debounce (delay).

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, key, pressed, client

---

### Function: **`pr_lib.drawtext.KeyPressed(delay)`**

**Detail:** Registra o acionamento de teclas de atalho de interações DrawText com debounce (delay).

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, key, pressed, client

---

### Function: **`pr_lib.drawtext.show(text, position, options)`**

**Detail:** Exibe textos flutuantes formatados.

**Related/Dependents:** `pr_lib.drawtext.change`, `pr_lib.drawtext.ChangeText`, `pr_lib.drawtext.draw2d`, `pr_lib.drawtext.draw3d`, `pr_lib.drawtext.DrawText`, `pr_lib.drawtext.drawText2d`

**Directory:** `pr_bridge/bridge/fivem/drawtext/client.lua`

**Context:** Client

**Tags:** drawtext, show, client

---

## fivem.vehicleProperties

### Function: **`pr_lib.fivem.getVehicleProperties(vehicle)`**

**Detail:** Alias de compatibilidade para vehicleProperties.get.

**Related/Dependents:** `pr_lib.vehicleProperties.get`, `pr_lib.vehicleProperties.GetVehicleProperties`, `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, get, client, veículo, carro

---

### Function: **`pr_lib.fivem.setVehicleProperties(vehicle, props)`**

**Detail:** Alias de compatibilidade para vehicleProperties.set.

**Related/Dependents:** `pr_lib.vehicleProperties.get`, `pr_lib.vehicleProperties.GetVehicleProperties`, `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.getVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, set, client, veículo, carro

---

### Function: **`pr_lib.fivem.setVehicleProperties(vehicle, props, options)`**

**Detail:** Alias de compatibilidade para vehicleProperties.set.

**Related/Dependents:** `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.setNetId`, `pr_lib.vehicleProperties.SetNetIdProperties`, `pr_lib.vehicleProperties.SetVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/server.lua`

**Context:** Server

**Tags:** vehicle, properties, set, server, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.get(vehicle)`**

**Detail:** Obtém a tabela completa contendo as propriedades estéticas e mecânicas instaladas no veículo (compatível com ESX/QBCore).

**Related/Dependents:** `pr_lib.vehicleProperties.GetVehicleProperties`, `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.getVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, get, client, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.GetVehicleProperties(vehicle)`**

**Detail:** Obtém a tabela completa contendo as propriedades estéticas e mecânicas instaladas no veículo (compatível com ESX/QBCore).

**Related/Dependents:** `pr_lib.vehicleProperties.get`, `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.getVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, get, client, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.set(vehicle, props, fixVehicle)`**

**Detail:** Modifica as propriedades físicas gerais de customização de um veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.get`, `pr_lib.vehicleProperties.GetVehicleProperties`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.getVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, set, client, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.set(vehicle, props, options)`**

**Detail:** Modifica as propriedades físicas gerais de customização de um veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.setNetId`, `pr_lib.vehicleProperties.SetNetIdProperties`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/server.lua`

**Context:** Server

**Tags:** vehicle, properties, set, server, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.setNetId(netId, props, target, options)`**

**Detail:** Aplica propriedades sincronizadas via rede utilizando a ID de rede do veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.SetNetIdProperties`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/server.lua`

**Context:** Server

**Tags:** vehicle, properties, set, net, id, server, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.SetNetIdProperties(netId, props, target, options)`**

**Detail:** Aplica propriedades sincronizadas via rede utilizando a ID de rede do veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.setNetId`, `pr_lib.vehicleProperties.SetVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/server.lua`

**Context:** Server

**Tags:** vehicle, properties, set, net, id, server, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, fixVehicle)`**

**Detail:** Modifica as propriedades físicas gerais de customização de um veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.get`, `pr_lib.vehicleProperties.GetVehicleProperties`, `pr_lib.vehicleProperties.set`, `pr_lib.fivem.getVehicleProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/client.lua`

**Context:** Client

**Tags:** vehicle, properties, set, client, veículo, carro

---

### Function: **`pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, options)`**

**Detail:** Modifica as propriedades físicas gerais de customização de um veículo.

**Related/Dependents:** `pr_lib.vehicleProperties.set`, `pr_lib.vehicleProperties.setNetId`, `pr_lib.vehicleProperties.SetNetIdProperties`, `pr_lib.fivem.setVehicleProperties`

**Directory:** `pr_bridge/bridge/fivem/vehicleProperties/server.lua`

**Context:** Server

**Tags:** vehicle, properties, set, server, veículo, carro

---

## fivem.streaming

### Function: **`pr_lib.fivem.streaming.configureEntity(entity, options)`**

**Detail:** Aplica opções de físicas, colisões, congelamento e persistência na entidade.

**Related/Dependents:** `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, configure, entity, client

---

### Function: **`pr_lib.fivem.streaming.createEntity(placementType, model, coords, heading, options)`**

**Detail:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, create, entity, client

---

### Function: **`pr_lib.fivem.streaming.createObject(model, coords, options)`**

**Detail:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, create, object, client

---

### Function: **`pr_lib.fivem.streaming.createPed(model, coords, heading, options)`**

**Detail:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, create, ped, client

---

### Function: **`pr_lib.fivem.streaming.createProp(model, coords, options)`**

**Detail:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createVehicle`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, create, prop, client

---

### Function: **`pr_lib.fivem.streaming.createVehicle(model, coords, heading, options)`**

**Detail:** APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.delete`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, create, vehicle, client, veículo, carro

---

### Function: **`pr_lib.fivem.streaming.delete(entity)`**

**Detail:** Apaga uma entidade (ped, veículo ou objeto) local liberando memória.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, delete, client

---

### Function: **`pr_lib.fivem.streaming.deleteEntity(entity)`**

**Detail:** Apaga uma entidade (ped, veículo ou objeto) local liberando memória.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, delete, entity, client

---

### Function: **`pr_lib.fivem.streaming.findGroundZ(coords, options)`**

**Detail:** Varre verticalmente o mapa para obter as coordenadas Z precisas do solo abaixo da posição indicada.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, find, ground, client

---

### Function: **`pr_lib.fivem.streaming.getModelDimensions(model, timeout)`**

**Detail:** Retorna as dimensões de bounding box (mínimo e máximo) do modelo especificado.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, get, model, dimensions, client

---

### Function: **`pr_lib.fivem.streaming.getModelGroundOffset(model, timeout)`**

**Detail:** Calcula a compensação de altura vertical necessária para posicionar o objeto rente ao chão.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, get, model, ground, offset, client

---

### Function: **`pr_lib.fivem.streaming.hash(model)`**

**Detail:** Retorna o hash numérico de um modelo 3D.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/bridge/fivem/streaming/server.lua`

**Context:** Server

**Tags:** streaming, hash, server

---

### Function: **`pr_lib.fivem.streaming.loadAnimDict(asset, timeout)`**

**Detail:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, load, anim, dict, client

---

### Function: **`pr_lib.fivem.streaming.loadWeaponAsset(model, timeout)`**

**Detail:** Carrega modelos de armas de fogo nativas e suas propriedades.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, load, weapon, asset, client

---

### Function: **`pr_lib.fivem.streaming.performAction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, perform, action, client

---

### Function: **`pr_lib.fivem.streaming.PerformAction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, perform, action, client

---

### Function: **`pr_lib.fivem.streaming.placeEntityProperly(entity, placementType, options)`**

**Detail:** Ajusta a altura e rotação de uma entidade para que ela fique alinhada corretamente com a superfície do solo.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, place, entity, properly, client

---

### Function: **`pr_lib.fivem.streaming.playAction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, action, client

---

### Function: **`pr_lib.fivem.streaming.PlayAction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, action, client

---

### Function: **`pr_lib.fivem.streaming.playAnim(data, clip, duration, options)`**

**Detail:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, anim, client

---

### Function: **`pr_lib.fivem.streaming.PlayAnim(data, clip, duration, options)`**

**Detail:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, anim, client

---

### Function: **`pr_lib.fivem.streaming.playAnimation(data, clip, duration, options)`**

**Detail:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, animation, client

---

### Function: **`pr_lib.fivem.streaming.PlayAnimation(data, clip, duration, options)`**

**Detail:** Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, animation, client

---

### Function: **`pr_lib.fivem.streaming.playInteraction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, interaction, client

---

### Function: **`pr_lib.fivem.streaming.PlayInteraction(data)`**

**Detail:** APIs utilitárias para acionar ações cinemáticas combinadas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, play, interaction, client

---

### Function: **`pr_lib.fivem.streaming.releaseAnimDict(animDict)`**

**Detail:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, anim, dict, client

---

### Function: **`pr_lib.fivem.streaming.releaseAnimSet(animSet)`**

**Detail:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, anim, set, client

---

### Function: **`pr_lib.fivem.streaming.releaseAudioBank(audioBank)`**

**Detail:** Carrega pacotes de efeitos sonoros e áudios nativos.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, audio, bank, client

---

### Function: **`pr_lib.fivem.streaming.releaseModel(model)`**

**Detail:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, model, client

---

### Function: **`pr_lib.fivem.streaming.releasePtfxAsset(asset)`**

**Detail:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, ptfx, asset, client

---

### Function: **`pr_lib.fivem.streaming.releaseScaleformMovie(handle)`**

**Detail:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, scaleform, movie, client

---

### Function: **`pr_lib.fivem.streaming.releaseTextureDict(textureDict)`**

**Detail:** Carrega dicionários contendo texturas e imagens nativas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, texture, dict, client

---

### Function: **`pr_lib.fivem.streaming.releaseWeaponAsset(model)`**

**Detail:** Carrega modelos de armas de fogo nativas e suas propriedades.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, release, weapon, asset, client

---

### Function: **`pr_lib.fivem.streaming.requestAnimDict(animDict, timeout)`**

**Detail:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, anim, dict, client

---

### Function: **`pr_lib.fivem.streaming.RequestAnimDict(asset, timeout)`**

**Detail:** Carrega dicionários contendo arquivos de animações esqueléticas para peds.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, anim, dict, client

---

### Function: **`pr_lib.fivem.streaming.requestAnimSet(animSet, timeout)`**

**Detail:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, anim, set, client

---

### Function: **`pr_lib.fivem.streaming.RequestAnimSet(asset, timeout)`**

**Detail:** Carrega arquivos de sets de animações de postura/caminhar (walkstyles).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, anim, set, client

---

### Function: **`pr_lib.fivem.streaming.RequestAudioBank(asset, timeout)`**

**Detail:** Carrega pacotes de efeitos sonoros e áudios nativos.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, audio, bank, client

---

### Function: **`pr_lib.fivem.streaming.requestAudioBank(audioBank, timeout)`**

**Detail:** Carrega pacotes de efeitos sonoros e áudios nativos.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, audio, bank, client

---

### Function: **`pr_lib.fivem.streaming.requestModel(model, timeout)`**

**Detail:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, model, client

---

### Function: **`pr_lib.fivem.streaming.RequestModel(model, timeout)`**

**Detail:** Carrega e retém na memória de vídeo do jogo o modelo 3D informado (model), liberando-o da memória após o uso.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, model, client

---

### Function: **`pr_lib.fivem.streaming.RequestNamedPtfxAsset(asset, timeout)`**

**Detail:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, named, ptfx, asset, client

---

### Function: **`pr_lib.fivem.streaming.requestPtfxAsset(asset, timeout)`**

**Detail:** Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, ptfx, asset, client

---

### Function: **`pr_lib.fivem.streaming.RequestScaleformMovie(asset, timeout)`**

**Detail:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, scaleform, movie, client

---

### Function: **`pr_lib.fivem.streaming.requestScaleformMovie(name, timeout)`**

**Detail:** Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, scaleform, movie, client

---

### Function: **`pr_lib.fivem.streaming.RequestStreamedTextureDict(asset, timeout)`**

**Detail:** Carrega dicionários contendo texturas e imagens nativas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, streamed, texture, dict, client

---

### Function: **`pr_lib.fivem.streaming.requestTextureDict(textureDict, timeout)`**

**Detail:** Carrega dicionários contendo texturas e imagens nativas.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, texture, dict, client

---

### Function: **`pr_lib.fivem.streaming.requestWeaponAsset(model, timeout)`**

**Detail:** Carrega modelos de armas de fogo nativas e suas propriedades.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, request, weapon, asset, client

---

### Function: **`pr_lib.fivem.streaming.setEntityTransform(entity, coords, heading, options)`**

**Detail:** Atualiza a posição e o ângulo horizontal de uma entidade de forma sincronizada.

**Related/Dependents:** `pr_lib.fivem.streaming.configureEntity`, `pr_lib.fivem.streaming.createEntity`, `pr_lib.fivem.streaming.createObject`, `pr_lib.fivem.streaming.createPed`, `pr_lib.fivem.streaming.createProp`, `pr_lib.fivem.streaming.createVehicle`

**Directory:** `pr_bridge/bridge/fivem/streaming/client.lua`

**Context:** Client

**Tags:** streaming, set, entity, transform, client

---

## fivem.objects

### Function: **`pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, find, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, find, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, find, in, radius, using, pool, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, find, in, radius, using, pool, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, find, vehicles, in, radius, client, obj, objeto, objetos, object, pool, entidade, veículo, vehicle

---

### Function: **`pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, find, vehicles, in, radius, server, obj, objeto, objetos, object, pool, entidade, veículo, vehicle

---

### Function: **`pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, find, vehicles, in, radius, using, pool, client, obj, objeto, objetos, object, entidade, veículo

---

### Function: **`pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, find, vehicles, in, radius, using, pool, server, obj, objeto, objetos, object, entidade, veículo

---

### Function: **`pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`**

**Detail:** Congela ou descongela a física de todas as entidades de determinado modelo 3D que estão dentro daquele raio.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, freeze, by, model, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`**

**Detail:** Congela ou descongela a física de todas as entidades de determinado modelo 3D que estão dentro daquele raio.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.getByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, freeze, by, model, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`**

**Detail:** Busca entidades filtradas por modelo específico e proximidade geográfica.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, by, model, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`**

**Detail:** Busca entidades filtradas por modelo específico e proximidade geográfica.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByPoolInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, by, model, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, by, pool, in, radius, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, by, pool, in, radius, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`**

**Detail:** Busca entidades filtradas por modelo específico e proximidade geográfica.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, closest, by, model, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`**

**Detail:** Busca entidades filtradas por modelo específico e proximidade geográfica.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, closest, by, model, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, closest, from, pool, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, closest, from, pool, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestObject(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, closest, object, client, obj, objeto, objetos, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestObject(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, closest, object, server, obj, objeto, objetos, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, closest, vehicle, client, obj, objeto, objetos, object, pool, entidade, veículo, carro

---

### Function: **`pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, closest, vehicle, server, obj, objeto, objetos, object, pool, entidade, veículo, carro

---

### Function: **`pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, closest, vehicle, by, model, client, obj, objeto, objetos, object, pool, entidade, veículo

---

### Function: **`pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, closest, vehicle, by, model, server, obj, objeto, objetos, object, pool, entidade, veículo

---

### Function: **`pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, networked, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, networked, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, by, pool, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, by, pool, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, in, radius, using, pool, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`**

**Detail:** Resgata e lista todos os objetos físicos gerados dentro do raio informado.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, in, radius, using, pool, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`**

**Detail:** Resgata peds (NPCs) próximos.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, peds, by, model, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`**

**Detail:** Resgata peds (NPCs) próximos.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, peds, by, model, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`**

**Detail:** Resgata peds (NPCs) próximos.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, peds, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`**

**Detail:** Resgata peds (NPCs) próximos.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, peds, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`**

**Detail:** Localiza pickups físicas de armas e colecionáveis do mundo GTA.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, pickups, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`**

**Detail:** Localiza pickups físicas de armas e colecionáveis do mundo GTA.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, pickups, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getPool(poolName)`**

**Detail:** Retorna entidades registradas no pool interno do FiveM.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, pool, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPool(poolName)`**

**Detail:** Retorna entidades registradas no pool interno do FiveM.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, pool, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, pool, by, model, in, radius, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, pool, by, model, in, radius, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, pool, in, radius, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`**

**Detail:** Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: "CPed", "CVehicle", "CObject").

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, pool, in, radius, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolName(poolName)`**

**Detail:** Retorna entidades registradas no pool interno do FiveM.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, pool, name, client, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getPoolName(poolName)`**

**Detail:** Retorna entidades registradas no pool interno do FiveM.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, pool, name, server, obj, objeto, objetos, object, entidade

---

### Function: **`pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, vehicles, by, model, in, radius, client, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, vehicles, by, model, in, radius, server, obj, objeto, objetos, object, pool, entidade

---

### Function: **`pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, vehicles, in, radius, client, obj, objeto, objetos, object, pool, entidade, veículo, vehicle

---

### Function: **`pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, vehicles, in, radius, server, obj, objeto, objetos, object, pool, entidade, veículo, vehicle

---

### Function: **`pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/client.lua`

**Context:** Client

**Tags:** objects, get, vehicles, in, radius, using, pool, client, obj, objeto, objetos, object, entidade, veículo

---

### Function: **`pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`**

**Detail:** Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.

**Related/Dependents:** `pr_lib.fivem.objects.findObjectsInRadius`, `pr_lib.fivem.objects.findObjectsInRadiusUsingPool`, `pr_lib.fivem.objects.findVehiclesInRadius`, `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool`, `pr_lib.fivem.objects.freezeByModelInRadius`, `pr_lib.fivem.objects.getByModelInRadius`

**Directory:** `pr_bridge/bridge/fivem/objects/server.lua`

**Context:** Server

**Tags:** objects, get, vehicles, in, radius, using, pool, server, obj, objeto, objetos, object, entidade, veículo

---

## fivem.vehicleCache

### Function: **`pr_lib.fivem.vehicleCache.clear(vehicleOrNetId)`**

**Detail:** Apaga o cache do veículo.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, clear, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.clearAll()`**

**Detail:** Limpa todo o cache de veículos na memória RAM do recurso.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, clear, all, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.get(vehicleOrNetId)`**

**Detail:** Retorna as informações em cache registradas para a ID da entidade do veículo ou ID de rede.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, get, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.getByPlate(plate)`**

**Detail:** Recupera dados do veículo pesquisando pela sua placa de identificação.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, get, by, plate, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.getPersistentMeta(vehicle)`**

**Detail:** Obtém ou grava metadados persistentes que sobrevivem ao respawn do veículo.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getState`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, get, persistent, meta, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.getState(vehicle, name)`**

**Detail:** Consulta uma propriedade do State Bag (estado persistido de rede do FiveM) registrado no veículo.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getStateKey`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, get, state, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.getStateKey(name)`**

**Detail:** Gera a string do caminho da chave de estado.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, get, state, key, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.set(vehicleOrNetId, data)`**

**Detail:** Salva dados customizados no cache persistente do veículo.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, set, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.setPersistentMeta(vehicle, meta)`**

**Detail:** Obtém ou grava metadados persistentes que sobrevivem ao respawn do veículo.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, set, persistent, meta, shared, invalidação, estado, memória, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleCache.setState(vehicle, name, value, replicated)`**

**Detail:** Altera uma propriedade no State Bag do veículo, controlando se ela deve ser replicada para outros clientes.

**Related/Dependents:** `pr_lib.fivem.vehicleCache.clear`, `pr_lib.fivem.vehicleCache.clearAll`, `pr_lib.fivem.vehicleCache.get`, `pr_lib.fivem.vehicleCache.getByPlate`, `pr_lib.fivem.vehicleCache.getPersistentMeta`, `pr_lib.fivem.vehicleCache.getState`

**Directory:** `pr_bridge/bridge/fivem/vehicleCache/shared.lua`

**Context:** Shared

**Tags:** vehicle, cache, set, state, shared, invalidação, estado, memória, veículo, carro

---

## fivem.blips

### Function: **`pr_lib.fivem.blips.describe(value, colorId)`**

**Detail:** Retorna um dicionário contendo ID, nome do sprite, link da imagem correspondente e dados da cor formatados.

**Related/Dependents:** `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, describe, shared

---

### Function: **`pr_lib.fivem.blips.getAssetImageUrl(kind, value)`**

**Detail:** Gerador de URL generico para imagens de assets, incluindo prop e object.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, asset, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getBlipImageUrl(value)`**

**Detail:** Gera uma URL externa direta contendo a imagem .png do blip correspondente.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, blip, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getCheckpointImageUrl(checkpointId)`**

**Detail:** Retornam URLs contendo imagens demonstrativas de checkponts e marcadores 3D.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, checkpoint, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getColorInfo(colorId)`**

**Detail:** Retorna as propriedades de cor do blip do radar (nome e hexadecimal de cor) a partir de seu ID numérico original.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getImageUrl`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, color, info, shared

---

### Function: **`pr_lib.fivem.blips.getImageUrl(value)`**

**Detail:** Gera uma URL externa direta contendo a imagem .png do blip correspondente.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getMarkerImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getMarkerImageUrl(markerId)`**

**Detail:** Retornam URLs contendo imagens demonstrativas de checkponts e marcadores 3D.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, marker, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getObjectImageUrl(model)`**

**Detail:** Monta a URL de preview de props no padrao [prop_name]-[hash].jpg, por exemplo prop_streetlight_08-1847069612.jpg.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, object, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getPedImageUrl(model)`**

**Detail:** Retorna a URL contendo a imagem de demonstração do modelo do ped.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, ped, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getPropHashId(model)`**

**Detail:** Calcula o hash/ID unsigned do modelo com GetHashKey/joaat, usado no nome dos arquivos de props da Rage MP.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, prop, hash, id, shared

---

### Function: **`pr_lib.fivem.blips.getPropImageUrl(model)`**

**Detail:** Monta a URL de preview de props no padrao [prop_name]-[hash].jpg, por exemplo prop_streetlight_08-1847069612.jpg.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, prop, image, url, shared

---

### Function: **`pr_lib.fivem.blips.getSprite(value)`**

**Detail:** Retorna as informações do Blip (ícone do mapa) pelo seu ID numérico ou nome amigável registrado.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, sprite, shared

---

### Function: **`pr_lib.fivem.blips.getSpriteId(value)`**

**Detail:** Converte e recupera nomes ou IDs numéricos equivalentes de sprites de blips do radar.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, sprite, id, shared

---

### Function: **`pr_lib.fivem.blips.getSpriteName(value)`**

**Detail:** Converte e recupera nomes ou IDs numéricos equivalentes de sprites de blips do radar.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, sprite, name, shared

---

### Function: **`pr_lib.fivem.blips.getVehicleImageUrl(model)`**

**Detail:** Retorna a URL contendo a imagem do veículo.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, vehicle, image, url, shared, veículo, carro

---

### Function: **`pr_lib.fivem.blips.getWeaponImageUrl(model)`**

**Detail:** Retorna a URL contendo a imagem da arma de fogo.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, get, weapon, image, url, shared

---

### Function: **`pr_lib.fivem.blips.listColors()`**

**Detail:** Retorna a lista completa indexada de sprites e cores originais suportados nativamente pelo FiveM.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, list, colors, shared

---

### Function: **`pr_lib.fivem.blips.listSprites()`**

**Detail:** Retorna a lista completa indexada de sprites e cores originais suportados nativamente pelo FiveM.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, list, sprites, shared

---

### Function: **`pr_lib.fivem.blips.setDocsBaseUrl(url)`**

**Detail:** Permite atualizar o caminho do servidor de documentação base do FiveM de onde as imagens de assets são baixadas.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, set, docs, base, url, shared

---

### Function: **`pr_lib.fivem.blips.setRagePropsBaseUrl(url)`**

**Detail:** Ajusta a URL base usada para imagens de props da Rage MP. Padrao: https://cdn.rage.mp/public/odb/imgs.

**Related/Dependents:** `pr_lib.fivem.blips.describe`, `pr_lib.fivem.blips.getAssetImageUrl`, `pr_lib.fivem.blips.getBlipImageUrl`, `pr_lib.fivem.blips.getCheckpointImageUrl`, `pr_lib.fivem.blips.getColorInfo`, `pr_lib.fivem.blips.getImageUrl`

**Directory:** `pr_bridge/bridge/fivem/blips/shared.lua`

**Context:** Shared

**Tags:** blips, set, rage, props, base, url, shared

---

## fivem.identifiers

### Function: **`pr_lib.fivem.identifiers.getAll(source)`**

**Detail:** Varre e retorna uma tabela contendo todos os identificadores conhecidos do jogador logado (discord, license, license2, steam, fivem, ip, etc.) e determina qual licença deve ser tratada como principal (primaryLicense).

**Related/Dependents:** `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, all, server

---

### Function: **`pr_lib.fivem.identifiers.GetAll(source)`**

**Detail:** Varre e retorna uma tabela contendo todos os identificadores conhecidos do jogador logado (discord, license, license2, steam, fivem, ip, etc.) e determina qual licença deve ser tratada como principal (primaryLicense).

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, all, server

---

### Function: **`pr_lib.fivem.identifiers.getByType(source, identifierType)`**

**Detail:** Retorna o identificador específico de conexão de rede de um jogador chamando a API nativa (ex: identifierType pode ser "license", "discord", "steam", "ip").

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, by, type, server

---

### Function: **`pr_lib.fivem.identifiers.GetByType(source, identifierType)`**

**Detail:** Retorna o identificador específico de conexão de rede de um jogador chamando a API nativa (ex: identifierType pode ser "license", "discord", "steam", "ip").

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, by, type, server

---

### Function: **`pr_lib.fivem.identifiers.getLicenseSet(source, extraLicenses)`**

**Detail:** Gera uma tabela contendo as licenças normais de identificação do jogador, permitindo mesclar chaves adicionais informadas.

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.GetLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, license, set, server

---

### Function: **`pr_lib.fivem.identifiers.GetLicenseSet(source, extraLicenses)`**

**Detail:** Gera uma tabela contendo as licenças normais de identificação do jogador, permitindo mesclar chaves adicionais informadas.

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.getPrimaryLicense`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, license, set, server

---

### Function: **`pr_lib.fivem.identifiers.getPrimaryLicense(source)`**

**Detail:** Retorna a licença Rockstar de prioridade primária do jogador local (license2 ou license).

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, primary, license, server

---

### Function: **`pr_lib.fivem.identifiers.GetPrimaryLicense(source)`**

**Detail:** Retorna a licença Rockstar de prioridade primária do jogador local (license2 ou license).

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, get, primary, license, server

---

### Function: **`pr_lib.fivem.identifiers.has(source, identifier)`**

**Detail:** Verifica se o jogador especificado possui o identificador exato informado.

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, has, server

---

### Function: **`pr_lib.fivem.identifiers.Has(source, identifier)`**

**Detail:** Verifica se o jogador especificado possui o identificador exato informado.

**Related/Dependents:** `pr_lib.fivem.identifiers.getAll`, `pr_lib.fivem.identifiers.GetAll`, `pr_lib.fivem.identifiers.getByType`, `pr_lib.fivem.identifiers.GetByType`, `pr_lib.fivem.identifiers.getLicenseSet`, `pr_lib.fivem.identifiers.GetLicenseSet`

**Directory:** `pr_bridge/bridge/fivem/identifiers/server.lua`

**Context:** Server

**Tags:** identifiers, has, server

---

## fivem.instructionalButtons

### Function: **`pr_lib.fivem.instructionalButtons.create(buttons, options)`**

**Detail:** Inicializa e carrega a scaleform INSTRUCTIONAL_BUTTONS na memória, desenhando de forma customizada e retornando um manipulador de instância. A tabela buttons descreve o texto (label) e a tecla/controle correspondente (ex: "~INPUT_FRONTEND_ACCEPT~").

**Related/Dependents:** `pr_lib.fivem.instructionalButtons.show`, `pr_lib.fivem.instructionalButtons.showClickable`, `pr_lib.fivem.instructionalButtons.showSimple`

**Directory:** `pr_bridge/bridge/fivem/instructionalButtons/client.lua`

**Context:** Client

**Tags:** instructional, buttons, create, client

---

### Function: **`pr_lib.fivem.instructionalButtons.show(buttons, options)`**

**Detail:** Cria e exibe dinamicamente o painel de botões na tela por um tempo limitado ou até que o jogador pressione uma tecla. Retorna se o usuário interagiu com algum botão.

**Related/Dependents:** `pr_lib.fivem.instructionalButtons.create`, `pr_lib.fivem.instructionalButtons.showClickable`, `pr_lib.fivem.instructionalButtons.showSimple`

**Directory:** `pr_bridge/bridge/fivem/instructionalButtons/client.lua`

**Context:** Client

**Tags:** instructional, buttons, show, client

---

### Function: **`pr_lib.fivem.instructionalButtons.showClickable(label, control, controlId, options)`**

**Detail:** Cria um botão modal com interação direta pelo mouse. Durante a seleção, libera o foco de qualquer NUI Chromium, mantém o Scaleform estável entre os frames e retorna pressed, o botão selecionado e o controlId.

**Related/Dependents:** `pr_lib.fivem.instructionalButtons.create`, `pr_lib.fivem.instructionalButtons.show`, `pr_lib.fivem.instructionalButtons.showSimple`

**Directory:** `pr_bridge/bridge/fivem/instructionalButtons/client.lua`

**Context:** Client

**Tags:** instructional, buttons, show, clickable, client

---

### Function: **`pr_lib.fivem.instructionalButtons.showSimple(label, control, options)`**

**Detail:** Exibe de forma rápida e simplificada um único botão informativo no canto da tela (ex: *"Confirmar"* associado ao botão enter).

**Related/Dependents:** `pr_lib.fivem.instructionalButtons.create`, `pr_lib.fivem.instructionalButtons.show`, `pr_lib.fivem.instructionalButtons.showClickable`

**Directory:** `pr_bridge/bridge/fivem/instructionalButtons/client.lua`

**Context:** Client

**Tags:** instructional, buttons, show, simple, client

---

## fivem.devtools

### Function: **`pr_lib.devtools.createPlacement(placementType, modelName, maxSlots, cb, options)`**

**Detail:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.

**Related/Dependents:** `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, create, placement, client

---

### Function: **`pr_lib.devtools.createPolyzone(options, cb)`**

**Detail:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, create, polyzone, client

---

### Function: **`pr_lib.devtools.createSphereZone(options, cb)`**

**Detail:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, create, sphere, zone, client

---

### Function: **`pr_lib.devtools.drawModelBoxAtCoords(options)`**

**Detail:** Desenha o wireframe/drawbox de um modelo em coordenadas informadas. Deve ser chamado por frame enquanto o debug ou preview estiver ativo.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, model, box, at, coords, client

---

### Function: **`pr_lib.devtools.DrawModelBoxAtCoords(options)`**

**Detail:** Executa os dados ou a operação “draw model box at coords” por meio da API pública do módulo `fivem.devtools`.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, model, box, at, coords, client

---

### Function: **`pr_lib.devtools.drawPedBox(coords, heading, model, options)`**

**Detail:** Desenha o wireframe/drawbox de um modelo em coordenadas informadas. Deve ser chamado por frame enquanto o debug ou preview estiver ativo.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.DrawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, ped, box, client

---

### Function: **`pr_lib.devtools.DrawPedBox(coords, heading, model, options)`**

**Detail:** Executa os dados ou a operação “draw ped box” por meio da API pública do módulo `fivem.devtools`.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, ped, box, client

---

### Function: **`pr_lib.devtools.drawPolyzone3D(options, cb)`**

**Detail:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, polyzone3, client

---

### Function: **`pr_lib.devtools.DrawPolyzone3D(options, cb)`**

**Detail:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, polyzone3, client

---

### Function: **`pr_lib.devtools.drawSphereZone(options, cb)`**

**Detail:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, sphere, zone, client

---

### Function: **`pr_lib.devtools.drawSphereZone3D(options, cb)`**

**Detail:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, sphere, zone3, client

---

### Function: **`pr_lib.devtools.DrawSphereZone3D(options, cb)`**

**Detail:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, draw, sphere, zone3, client

---

### Function: **`pr_lib.devtools.placeObject(modelName, maxSlots, cb, options)`**

**Detail:** Inicia modos de colocação específicos para objetos, peds e veículos.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, place, object, client

---

### Function: **`pr_lib.devtools.placePed(modelName, maxSlots, cb, options)`**

**Detail:** Inicia modos de colocação específicos para objetos, peds e veículos.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, place, ped, client

---

### Function: **`pr_lib.devtools.placeVehicle(modelName, maxSlots, cb, options)`**

**Detail:** Inicia modos de colocação específicos para objetos, peds e veículos.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, place, vehicle, client, veículo, carro

---

### Function: **`pr_lib.devtools.startEntityPlacement(placementType, modelName, maxSlots, cb, options)`**

**Detail:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, start, entity, placement, client

---

### Function: **`pr_lib.devtools.StartEntityPlacement(placementType, modelName, maxSlots, cb, options)`**

**Detail:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, start, entity, placement, client

---

### Function: **`pr_lib.devtools.stop()`**

**Detail:** Encerra imediatamente qualquer modo de criação ou posicionamento de entidades ou zonas em andamento.

**Related/Dependents:** `pr_lib.devtools.createPlacement`, `pr_lib.devtools.createPolyzone`, `pr_lib.devtools.createSphereZone`, `pr_lib.devtools.drawModelBoxAtCoords`, `pr_lib.devtools.DrawModelBoxAtCoords`, `pr_lib.devtools.drawPedBox`

**Directory:** `pr_bridge/bridge/fivem/devtools/client.lua`

**Context:** Client

**Tags:** devtools, stop, client

---

## fivem.aliases

### Function: **`pr_lib.fivem.vehicle.findClosest(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, find, closest, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.findClosest(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, find, closest, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, find, in, radius, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, find, in, radius, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getEntity(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, get, entity, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getEntity(netId, timeout)`**

**Detail:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, get, entity, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getNetId(entity)`**

**Detail:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, get, net, id, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getNetId(entity)`**

**Detail:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, get, net, id, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getOwner(entity)`**

**Detail:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getProperties`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, get, owner, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getOwner(entity)`**

**Detail:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getVehicle`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, get, owner, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getProperties(vehicle)`**

**Detail:** Obtém os dados ou a operação “get properties” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, get, properties, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`**

**Detail:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, get, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`**

**Detail:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.resolve`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, get, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`**

**Detail:** Executa os dados ou a operação “resolve” por meio da API pública do módulo `fivem.vehicle`.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, resolve, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`**

**Detail:** Executa os dados ou a operação “resolve” por meio da API pública do módulo `fivem.vehicle`.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, resolve, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.setProperties(vehicle, props)`**

**Detail:** Define ou atualiza os dados ou a operação “set properties” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicle, set, properties, client, veículo, carro

---

### Function: **`pr_lib.fivem.vehicle.setProperties(vehicle, props, options)`**

**Detail:** Define ou atualiza os dados ou a operação “set properties” usando a autoridade do módulo.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicle, set, properties, server, veículo, carro

---

### Function: **`pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find by model in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicles, find, by, model, in, radius, client, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find by model in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicles, find, by, model, in, radius, server, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findClosest(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicles, find, closest, client, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findClosest(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicles, find, closest, server, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest by model” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicles, find, closest, by, model, client, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find closest by model” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicles, find, closest, by, model, server, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getProperties`

**Directory:** `pr_bridge/bridge/fivem/client.lua`

**Context:** Client

**Tags:** aliases, vehicles, find, in, radius, client, veículo, vehicle, carro

---

### Function: **`pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`**

**Detail:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.

**Related/Dependents:** `pr_lib.fivem.vehicle.findClosest`, `pr_lib.fivem.vehicle.findInRadius`, `pr_lib.fivem.vehicle.getEntity`, `pr_lib.fivem.vehicle.getNetId`, `pr_lib.fivem.vehicle.getOwner`, `pr_lib.fivem.vehicle.getVehicle`

**Directory:** `pr_bridge/bridge/fivem/server.lua`

**Context:** Server

**Tags:** aliases, vehicles, find, in, radius, server, veículo, vehicle, carro

---

## fivem.vehicleState

### Function: **`pr_lib.fivem.vehicleState.channel(name, defaults)`**

**Detail:** cria canal isolado com opções padrão. Estão pré-cadastrados mileage, keys, fueltech, suspension e dynamo.

**Related/Dependents:** `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, channel, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.clearWatchers()`**

**Detail:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, clear, watchers, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.get(entity, channel, key, options)`**

**Detail:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, get, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.getMetrics()`**

**Detail:** retorna leituras, escritas, rejeições, payloads excessivos, duplicatas, rate limits e handlers.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, get, metrics, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.props.link(prop, vehicle, data, options)`**

**Detail:** registra vínculo compacto do prop de rede com o netId do veículo pai. Opções suportadas

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.registerChannel`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, props, link, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.registerChannel(name, defaults)`**

**Detail:** cria canal isolado com opções padrão. Estão pré-cadastrados mileage, keys, fueltech, suspension e dynamo.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.remove`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, register, channel, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.remove(...)`**

**Detail:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, remove, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.set(...)`**

**Detail:** lê, grava ou remove uma chave validada. Escrita replicada usa autoridade do servidor por padrão nos canais oficiais.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, set, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.setMany(entity, channel, values, options)`**

**Detail:** valida todo o lote antes de gravá-lo.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, set, many, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.snapshot(entity, channel, keys, options)`**

**Detail:** retorna somente a lista explícita de chaves solicitadas.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, snapshot, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.unwatch(id)`**

**Detail:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, unwatch, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.update(entity, channel, key, updater, options)`**

**Detail:** altera um valor a partir do valor atual.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, update, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.wait(entity, channel, key, predicate, timeout, options)`**

**Detail:** aguarda valor esperado ou predicado sem loop de frame.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, wait, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.watch(entity, channel, key, callback, options)`**

**Detail:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, watch, shared, veículo, carro

---

### Function: **`pr_lib.fivem.vehicleState.watchAny(channel, key, callback, options)`**

**Detail:** observa uma chave exata em uma entidade ou em todas as entidades do tipo do escopo. Handlers são liberados no encerramento do recurso.

**Related/Dependents:** `pr_lib.fivem.vehicleState.channel`, `pr_lib.fivem.vehicleState.clearWatchers`, `pr_lib.fivem.vehicleState.get`, `pr_lib.fivem.vehicleState.getMetrics`, `pr_lib.fivem.vehicleState.props.link`, `pr_lib.fivem.vehicleState.registerChannel`

**Directory:** `pr_bridge/bridge/fivem/vehicleState/shared.lua`

**Context:** Shared

**Tags:** vehicle, state, watch, any, shared, veículo, carro

---

## fivem.gizmo

### Function: **`pr_lib.gizmo.await(entity, callback, offset, options)`**

**Detail:** aguarda a decisão dentro de uma thread. Retorna o resultado no primeiro valor quando confirmado ou no segundo valor quando cancelado.

**Related/Dependents:** `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, await, client

---

### Function: **`pr_lib.gizmo.cancel(reason)`**

**Detail:** encerramento programático da sessão.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, cancel, client

---

### Function: **`pr_lib.gizmo.confirm(reason)`**

**Detail:** encerramento programático da sessão.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, confirm, client

---

### Function: **`pr_lib.gizmo.getResult()`**

**Detail:** consulta o estado e o último resultado padronizado. Consulte GIZMO.md para opções, controles, resultado, movimento livre em freecam e testes de compatibilidade.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, get, result, client

---

### Function: **`pr_lib.gizmo.isActive()`**

**Detail:** consulta o estado e o último resultado padronizado. Consulte GIZMO.md para opções, controles, resultado, movimento livre em freecam e testes de compatibilidade.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.start`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, is, active, client

---

### Function: **`pr_lib.gizmo.start(entity, callback, offset, options)`**

**Detail:** mantém a assinatura legada e inicia uma sessão autocontida com NUI Svelte, câmera, bloqueio de controles, precisão, confirmação e cancelamento. O HUD Svelte é informativo e não assume foco. Todos os comandos do modo atual são exibidos no Scaleform inferior não clicável e permanecem funcionais pelos keybinds remapeáveis.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.stop`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, start, client

---

### Function: **`pr_lib.gizmo.stop()`**

**Detail:** encerramento programático da sessão.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, stop, client

---

### Function: **`pr_lib.gizmo.use(...)`**

**Detail:** aguarda a decisão dentro de uma thread. Retorna o resultado no primeiro valor quando confirmado ou no segundo valor quando cancelado.

**Related/Dependents:** `pr_lib.gizmo.await`, `pr_lib.gizmo.cancel`, `pr_lib.gizmo.confirm`, `pr_lib.gizmo.getResult`, `pr_lib.gizmo.isActive`, `pr_lib.gizmo.start`

**Directory:** `pr_bridge/bridge/fivem/gizmo/client.lua`

**Context:** Client

**Tags:** gizmo, use, client

---

## string

### Function: **`pr_lib.string.random(pattern, length?)`**

**Detail:** Executa os dados ou a operação “random” por meio da API pública do módulo `string`.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/bridge/utils/strings.lua`

**Context:** Shared

**Tags:** string, random, shared

---

## timer

### Function: **`pr_lib.timer(duration, onEnd?, async?)`**

**Detail:** Executa os dados ou a operação “timer” por meio da API pública do módulo `utilitários_compartilhados`.

**Related/Dependents:** Nenhuma dependência pública direta catalogada.

**Directory:** `pr_bridge/bridge/utils/timer.lua`

**Context:** Shared/Client/Server

**Tags:** timer, shared/client/server

---

## entities

### Function: **`pr_lib.getClosestPlayer(coords, radius?, includePlayer?)`**

**Detail:** Obtém os dados ou a operação “get closest player” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.getClosestVehicle`, `pr_lib.getNearbyPlayers`, `pr_lib.getNearbyVehicles`

**Directory:** `pr_bridge/bridge/compat/entities_client.lua`

**Context:** Client

**Tags:** entities, get, closest, player, client

---

### Function: **`pr_lib.getClosestVehicle(coords, radius?, includePlayerVehicle?)`**

**Detail:** Obtém os dados ou a operação “get closest vehicle” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.getClosestPlayer`, `pr_lib.getNearbyPlayers`, `pr_lib.getNearbyVehicles`

**Directory:** `pr_bridge/bridge/compat/entities_client.lua`

**Context:** Client

**Tags:** entities, get, closest, vehicle, client, veículo, carro

---

### Function: **`pr_lib.getNearbyPlayers(coords, radius?, includePlayer?)`**

**Detail:** Obtém os dados ou a operação “get nearby players” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.getClosestPlayer`, `pr_lib.getClosestVehicle`, `pr_lib.getNearbyVehicles`

**Directory:** `pr_bridge/bridge/compat/entities_client.lua`

**Context:** Client

**Tags:** entities, get, nearby, players, client

---

### Function: **`pr_lib.getNearbyVehicles(coords, radius?, includePlayerVehicle?)`**

**Detail:** Obtém os dados ou a operação “get nearby vehicles” usando a ponte normalizada do módulo.

**Related/Dependents:** `pr_lib.getClosestPlayer`, `pr_lib.getClosestVehicle`, `pr_lib.getNearbyPlayers`

**Directory:** `pr_bridge/bridge/compat/entities_client.lua`

**Context:** Client

**Tags:** entities, get, nearby, vehicles, client, veículo, vehicle, carro

---

## Aliases de módulos

Aliases não são contabilizados como funções independentes.

| Alias | Referência canônica |
|---|---|
| `pr_lib.db` | `pr_lib.database` |
| `pr_lib.sql` | `pr_lib.database` |
| `pr_lib.inventories` | `pr_lib.inventory` |
| `pr_lib.notifications` | `pr_lib.notify` |
| `pr_lib.notification` | `pr_lib.notify` |
| `pr_lib.menu` | `pr_lib.menus` |
| `pr_lib.targets` | `pr_lib.target` |
| `pr_lib.phones` | `pr_lib.phone` |
| `pr_lib.progressbar` | `pr_lib.progress` |
| `pr_lib.minigames` | `pr_lib.minigame` |
| `pr_lib.textUIAdapter` | `pr_lib.textuiAdapter` |
| `pr_lib.textuiBridge` | `pr_lib.textuiAdapter` |
| `pr_lib.textUIBridge` | `pr_lib.textuiAdapter` |
| `pr_lib.bank` | `pr_lib.banking` |
| `pr_lib.vehicleKey` | `pr_lib.vehicle_key` |
| `pr_lib.vehicleKeys` | `pr_lib.vehicle_key` |
| `pr_lib.drawtext` | `pr_lib.fivem.drawtext` |
| `pr_lib.drawText` | `pr_lib.fivem.drawText` |
| `pr_lib.textui` | `pr_lib.fivem.textui` |
| `pr_lib.textUI` | `pr_lib.fivem.textUI` |
| `pr_lib.dui` | `pr_lib.fivem.dui` |
| `pr_lib.duis` | `pr_lib.fivem.duis` |
| `pr_lib.raycast` | `pr_lib.fivem.raycast` |
| `pr_lib.ui` | `pr_lib.fivem.ui` |
| `pr_lib.ace` | `pr_lib.fivem.ace` |
| `pr_lib.permissions` | `pr_lib.fivem.permissions` |
| `pr_lib.identifiers` | `pr_lib.fivem.identifiers` |
| `pr_lib.identifier` | `pr_lib.fivem.identifier` |
| `pr_lib.addKeybind` | `pr_lib.fivem.addKeybind` |
| `pr_lib.keybind` | `pr_lib.fivem.keybind` |
| `pr_lib.keybinds` | `pr_lib.fivem.keybinds` |
| `pr_lib.addCommand` | `pr_lib.fivem.addCommand` |
| `pr_lib.command` | `pr_lib.fivem.command` |
| `pr_lib.commands` | `pr_lib.fivem.commands` |
| `pr_lib.editorCamera` | `pr_lib.fivem.editorCamera` |
| `pr_lib.gizmo` | `pr_lib.fivem.gizmo` |
| `pr_lib.devlaser` | `pr_lib.fivem.devlaser` |
| `pr_lib.devLaser` | `pr_lib.fivem.devLaser` |
| `pr_lib.devtools` | `pr_lib.fivem.devtools` |
| `pr_lib.devTools` | `pr_lib.fivem.devTools` |
| `pr_lib.developerTools` | `pr_lib.fivem.developerTools` |
| `pr_lib.vehicleProperties` | `pr_lib.fivem.vehicleProperties` |
| `pr_lib.sqlBackup` | `pr_lib.database.backup` |

## Manutenção do catálogo

Toda API pública nova ou alterada deve atualizar este catálogo, `API_FUNCTIONS.md` e `__types.lua` quando aplicável. Funções interativas devem possuir exemplo no `pr_scriptTest`; mudanças de lifecycle devem cobrir registro, remoção e restart.
