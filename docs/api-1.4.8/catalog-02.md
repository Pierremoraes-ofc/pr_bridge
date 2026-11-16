# PR Bridge 1.4.8 — Catálogo de funções (volume 2/6)

> Fonte: `pr_bridge` revisão `59fbcb60eddeb15aac35b62061c5ef5c330623ae` e documentação do projeto. Os módulos opcionais e os providers ativos determinam quais métodos estão disponíveis. Exemplos são construções demonstrativas que precisam de parâmetros reais, permissões e validação no servidor.

**225 entradas por assinatura e contexto neste volume.** [Índice](../API_CATALOG_1_4_8.md)

## collections.set

### `pr_lib.collections.set:isSubsetOf(other)`

**Contexto:** `shared`  
**Descrição:** Verifica se o conjunto é subconjunto do outro. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `issubsetof`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:isSubsetOf(pr_lib.collections.set:new('b', 'c'))
print('isSubsetOf:', result)
```

---

### `pr_lib.collections.set:remove(value)`

**Contexto:** `shared`  
**Descrição:** Remove elemento do conjunto. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `remove`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:remove(42)
print('remove:', result)
```

---

### `pr_lib.collections.set:size()`

**Contexto:** `shared`  
**Descrição:** Retorna a quantidade de elementos atualmente armazenados. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `size`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:size()
print('size:', result)
```

---

### `pr_lib.collections.set:toArray()`

**Contexto:** `shared`  
**Descrição:** Converte os valores para uma sequência Lua. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `toarray`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:toArray()
print('toArray:', result)
```

---

### `pr_lib.collections.set:union(other)`

**Contexto:** `shared`  
**Descrição:** Cria/retorna a união de dois conjuntos. API de coleção Lua da biblioteca canônica PR, carregada sob demanda; este método atua sobre uma instância criada com :new().  
**Arquivo de origem:** [`bridge/collections/set.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/collections/set.lua)  
**Tags:** `collections.set` · `shared` · `collections` · `estrutura de dados` · `set` · `union`

**Exemplo de construção e uso:**

```lua
local collection = pr_lib.collections.set:new('a', 'b')
local result = collection:union(pr_lib.collections.set:new('b', 'c'))
print('union:', result)
```

---

## core

### `pr_lib.addExports(name, callback)`

**Contexto:** `shared`  
**Descrição:** Registra export(s) no resource consumidor a partir de uma função ou mapa de callbacks.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.addExports('example:action', function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.checkDependency(resource, minimumVersion, printMessage)`

**Contexto:** `shared`  
**Descrição:** Verifica se outro recurso dependência está rodando no servidor e se a versão instalada atende à restrição de versão mínima informada.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `check` · `dependency` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.checkDependency('example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.deleteJson(path)`

**Contexto:** `shared`  
**Descrição:** Remove fisicamente o arquivo JSON correspondente ao caminho especificado.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `delete` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.deleteJson('@my_resource/data/config.json')
print('Retorno da operação:', result)
```

---

### `pr_lib.jsonExists(path)`

**Contexto:** `shared`  
**Descrição:** Verifica de forma rápida a existência física de um arquivo no caminho JSON informado.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `json` · `exists` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.jsonExists('@my_resource/data/config.json')
print('Retorno da operação:', result)
```

---

### `pr_lib.load(path, env, optional)`

**Contexto:** `shared`  
**Descrição:** Carrega e executa dinamicamente um chunk de código Lua a partir de um arquivo virtual ou real (path). Opcionalmente, permite passar um ambiente global customizado (env) para isolamento do escopo. Se optional for verdadeiro, o interpretador silencia erros de ausência do arquivo.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `load` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.load('example', 'example', false)
print('Resultado:', result)
```

---

### `pr_lib.loadFile(resource, fileName, env, optional)`

**Contexto:** `shared`  
**Descrição:** Carrega um arquivo específico (fileName) de um determinado recurso ativo do servidor (resource) no ambiente customizado (env). Silencia falhas de carregamento se optional for true.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `load` · `file` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.loadFile('example', 'example', 'example', false)
print('Resultado:', result)
```

---

### `pr_lib.loadJson(path, optional)`

**Contexto:** `shared`  
**Descrição:** Lê, decodifica e retorna uma tabela Lua a partir de um arquivo com formato JSON localizado em path.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `load` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.loadJson('@my_resource/data/config.json', false)
print('Resultado:', result)
```

---

### `pr_lib.loadModule(path, env, optional)`

**Contexto:** `shared`  
**Descrição:** Importa dinamicamente submódulos e bibliotecas da estrutura interna da pr_bridge.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `load` · `module` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.loadModule('example', 'example', false)
print('Resultado:', result)
```

---

### `pr_lib.logger(source, event, message, tag)`

**Contexto:** `shared`  
**Descrição:** Helper de logging padronizado para recursos consumidores.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.logger(source, 'example', 'example', 'example')
print('Resultado:', result)
```

---

### `pr_lib.mergeJson(path, changes, options)`

**Contexto:** `shared`  
**Descrição:** Mescla recursivamente dados novos de uma tabela (changes) em um arquivo JSON existente no disco, preservando as chaves anteriores.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `merge` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.mergeJson('@my_resource/data/config.json', {}, {})
print('Resultado:', result)
```

---

### `pr_lib.readJson(path, optional)`

**Contexto:** `shared`  
**Descrição:** Lê, decodifica e retorna uma tabela Lua a partir de um arquivo com formato JSON localizado em path.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `read` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.readJson('@my_resource/data/config.json', false)
print('Resultado:', result)
```

---

### `pr_lib.saveJson(path, value, options)`

**Contexto:** `shared`  
**Descrição:** Serializa value com json.encode e grava no recurso/caminho resolvido. Retorna true e detalhes somente para retorno nativo true/1; falhas retornam false e motivo. Não garante indentação nem backup; no servidor, use saveJsonRecovery para proteção adicional.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `save` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.saveJson('@my_resource/data/config.json', {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.updateJson(path, changes, options)`

**Contexto:** `shared`  
**Descrição:** Mescla recursivamente dados novos de uma tabela (changes) em um arquivo JSON existente no disco, preservando as chaves anteriores.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `update` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.updateJson('@my_resource/data/config.json', {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.versionCheck(repository)`

**Contexto:** `shared`  
**Descrição:** Executa uma checagem em background consultando a API do GitHub para verificar se a versão declarada no manifesto do recurso atual é inferior à última release pública (tag) do repositório informado.  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `version` · `check` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.versionCheck('Pierremoraes-ofc/pr_bridge')
print('Resultado:', result)
```

---

### `pr_lib.waitFor(callback, message, timeout)`

**Contexto:** `shared`  
**Descrição:** Aguarda uma condição/callback até obter resultado ou atingir timeout.  
**Arquivo de origem:** [`init.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/init.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.waitFor(function(value) print('Callback:', value) end, 'Exemplo do PR Bridge', 1)
print('Retorno da operação:', result)
```

---

### `pr_lib.writeJson(path, value, options)`

**Contexto:** `shared`  
**Descrição:** Serializa uma tabela Lua (value) em formato JSON identado e legível, gravando-a no caminho (path).  
**Arquivo de origem:** [`bridge/core.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/core.lua)  
**Tags:** `core` · `write` · `json` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.writeJson('@my_resource/data/config.json', {}, {})
print('Retorno da operação:', result)
```

---

## database

### `pr_lib.database.execute(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `execute` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.execute('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.fetch(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `fetch` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.fetch('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.fetchAll(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `fetch` · `all` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.fetchAll('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.GetResourceName()`

**Contexto:** `client`  
**Descrição:** Retorna o recurso SQL de banco de dados ativo (ex: "oxmysql").  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `get` · `resource` · `name` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.database.insert(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `insert` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.insert('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.isReady()`

**Contexto:** `client`  
**Descrição:** Retorna se a conexão inicial e o pool de conexões com o MySQL estão prontos para receber queries.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `is` · `ready` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.isReady()
print('Resultado:', result)
```

---

### `pr_lib.database.query(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `query` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.query('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.read(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `read` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.read('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.run(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `run` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.run('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.scalar(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `scalar` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.scalar('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.single(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa a query e retorna uma tabela simples contendo as chaves da primeira linha encontrada (útil para buscar um único usuário).  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `single` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.single('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.transaction(queries, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `transaction` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.transaction({}, {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.update(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `update` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.update('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.write(query, parameters, cb)`

**Contexto:** `client`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/client.lua`  
**Tags:** `database` · `write` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.write('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.auto(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `auto` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.auto('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.backup.create(options)`

**Contexto:** `server`  
**Descrição:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `backup` · `create` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.backup.create({})
print('Resultado:', result)
```

---

### `pr_lib.database.backup.export(options)`

**Contexto:** `server`  
**Descrição:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `backup` · `export` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.backup.export({})
print('Retorno da operação:', result)
```

---

### `pr_lib.database.backup.run(options)`

**Contexto:** `server`  
**Descrição:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `backup` · `run` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.backup.run({})
print('Retorno da operação:', result)
```

---

### `pr_lib.database.createBackup(options)`

**Contexto:** `server`  
**Descrição:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `create` · `backup` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.createBackup({})
print('Resultado:', result)
```

---

### `pr_lib.database.execute(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `execute` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.execute('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.Execute(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `execute` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Execute('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.fetch(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `fetch` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.fetch('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.fetchAll(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `fetch` · `all` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.fetchAll('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.GetResourceName()`

**Contexto:** `server`  
**Descrição:** Retorna o recurso SQL de banco de dados ativo (ex: "oxmysql").  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `get` · `resource` · `name` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.GetResourceName()
print('Resultado:', result)
```

---

### `pr_lib.database.insert(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `insert` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.insert('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.Insert(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `insert` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Insert('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.isReady()`

**Contexto:** `server`  
**Descrição:** Retorna se a conexão inicial e o pool de conexões com o MySQL estão prontos para receber queries.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `is` · `ready` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.isReady()
print('Resultado:', result)
```

---

### `pr_lib.database.Prepare(...)`

**Contexto:** `server`  
**Descrição:** Executa consultas preparadas e aceita um conjunto de parâmetros ou uma lista de conjuntos. No mysql-async e ghmattimysql, o pr_bridge preserva esse contrato por emulação segura sobre as APIs nativas.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `prepare` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Prepare()
print('Retorno da operação:', result)
```

---

### `pr_lib.database.prepare(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa consultas preparadas e aceita um conjunto de parâmetros ou uma lista de conjuntos. No mysql-async e ghmattimysql, o pr_bridge preserva esse contrato por emulação segura sobre as APIs nativas.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `prepare` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.prepare('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.query(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `query` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.query('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.RawExecute(...)`

**Contexto:** `server`  
**Descrição:** Executa escrita crua individual ou em lote e preserva o formato com affectedRows usado por consumidores compatíveis com oxmysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `raw` · `execute` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.RawExecute()
print('Retorno da operação:', result)
```

---

### `pr_lib.database.rawExecute(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa escrita crua individual ou em lote e preserva o formato com affectedRows usado por consumidores compatíveis com oxmysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `raw` · `execute` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.rawExecute('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.read(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `read` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.read('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.ready(cb)`

**Contexto:** `server`  
**Descrição:** Executa o callback assim que o adaptador selecionado estiver pronto; sem callback, retorna o estado atual.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `ready` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.ready(function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.run(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `run` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.run('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.scalar(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `scalar` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.scalar('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.Scalar(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens COUNT(*) ou valores de colunas únicas).  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `scalar` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Scalar('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.Select(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `select` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Select('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.single(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa a query e retorna uma tabela simples contendo as chaves da primeira linha encontrada (útil para buscar um único usuário).  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `single` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.single('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.database.transaction(queries, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `transaction` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.transaction({}, {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.Transaction(queries, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `transaction` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Transaction({}, {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.update(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `update` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.update('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.Update(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `update` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.Update('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.database.write(query, parameters, cb)`

**Contexto:** `server`  
**Descrição:** Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `write` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.database.write('SELECT 1', {}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.sqlBackup.create(options)`

**Contexto:** `server`  
**Descrição:** Exporta tabelas e dados em formato de arquivo .sql gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro options permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (schema), dados (inserts) ou ambos.  
**Arquivo de origem:** `pr_bridge/bridge/database/*/server.lua`  
**Tags:** `database` · `sql` · `backup` · `create` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.sqlBackup.create({})
print('Resultado:', result)
```

---

## debug

### `pr_lib.debug.error(...)`

**Contexto:** `shared`  
**Descrição:** Imprime logs de erro formatados em vermelho no console.  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `error` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.error()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.info(...)`

**Contexto:** `shared`  
**Descrição:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `info` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.info()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.isEnabled()`

**Contexto:** `shared`  
**Descrição:** Retorna true se o console do recurso chamador estiver operando em modo verbose (depuração ativa).  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `is` · `enabled` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.isEnabled()
print('Resultado:', result)
```

---

### `pr_lib.debug.log(...)`

**Contexto:** `shared`  
**Descrição:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `log` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.log()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.setEnabled(state)`

**Contexto:** `shared`  
**Descrição:** Habilita ou desabilita logs de debug em tempo de execução.  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `set` · `enabled` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.setEnabled(false)
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.success(...)`

**Contexto:** `shared`  
**Descrição:** Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `success` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.success()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.warn(...)`

**Contexto:** `shared`  
**Descrição:** Exibe logs de alerta em amarelo no console do servidor/cliente.  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `warn` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.warn()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug.warning(...)`

**Contexto:** `shared`  
**Descrição:** Exibe logs de alerta em amarelo no console do servidor/cliente.  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `warning` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug.warning()
print('Retorno da operação:', result)
```

---

### `pr_lib.debug(...)`

**Contexto:** `shared`  
**Descrição:** Imprime dados formatados para console caso o nível de debug do recurso esteja ativado.  
**Arquivo de origem:** [`bridge/debug.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/debug.lua)  
**Tags:** `debug` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.debug()
print('Retorno da operação:', result)
```

---

## devtools

### `pr_lib.devtools.placeAnimatedPed(modelName, maxSlots, animations, cb, options?)`

**Contexto:** `client`  
**Descrição:** Posiciona NPC com cenário ou animação selecionável; retorna pontos com x/y/z/heading e animation/animationLabel. Usa referência da superfície, calibra origem e preserva pose. Guias visuais ficam desligadas por padrão. Alias PlaceAnimatedPed.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `client` · `posicionador: npc animado` · `place` · `animated` · `ped`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.placeAnimatedPed('example', 1, 'example', function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

## doorlock

### `doorlock.ensureRegistration(ids)`

**Contexto:** `client`  
**Descrição:** Agenda registro de portas tradicionais no DoorSystem; aguarda física e preserva mudanças de estado recebidas durante a consulta. Portas slide/rotate ficam com o provider.  
**Arquivo de origem:** [`bridge/doorlock/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/client.lua)  
**Tags:** `doorlock` · `client` · `portas: módulo opt-in no cliente` · `ensure` · `registration`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/client')
local result = doorlock.ensureRegistration('example')
print('Resultado:', result)
```

---

### `doorlock.snapshot()`

**Contexto:** `client`  
**Descrição:** Consulta ox_doorlock:getDoors via callback com timeout de 15000ms.  
**Arquivo de origem:** [`bridge/doorlock/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/client.lua)  
**Tags:** `doorlock` · `client` · `portas: módulo opt-in no cliente` · `snapshot`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/client')
local result = doorlock.snapshot()
print('Resultado:', result)
```

---

### `doorlock.catalog()`

**Contexto:** `server`  
**Descrição:** Consulta getAllDoors do ox_doorlock.  
**Arquivo de origem:** [`bridge/doorlock/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/server.lua)  
**Tags:** `doorlock` · `server` · `portas: módulo opt-in no servidor` · `catalog`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/server')
local result = doorlock.catalog()
print('Retorno da operação:', result)
```

---

### `doorlock.ensure(name, definition, group, access?)`

**Contexto:** `server`  
**Descrição:** Reutiliza porta do mesmo grupo ou cria com geometria validada; mantém transformações/tipo já salvos. Detecta provider carregando registro do banco e evita duplicação por nome.  
**Arquivo de origem:** [`bridge/doorlock/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/server.lua)  
**Tags:** `doorlock` · `server` · `portas: módulo opt-in no servidor` · `ensure`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/server')
local result = doorlock.ensure('example', {}, 'example')
print('Resultado:', result)
```

---

### `doorlock.getByName(name)`

**Contexto:** `server`  
**Descrição:** Consulta getDoorFromName do ox_doorlock; retorna resultado ou nil/motivo.  
**Arquivo de origem:** [`bridge/doorlock/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/server.lua)  
**Tags:** `doorlock` · `server` · `portas: módulo opt-in no servidor` · `get` · `by` · `name`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/server')
local result = doorlock.getByName('example:action')
print('Resultado:', result)
```

---

### `doorlock.setState(name, locked)`

**Contexto:** `server`  
**Descrição:** Altera estado como evento local do servidor e confirma resultado no provider; retorna false/motivo se não aplicado. Não substituir a ACL do consumidor.  
**Arquivo de origem:** [`bridge/doorlock/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/doorlock/server.lua)  
**Tags:** `doorlock` · `server` · `portas: módulo opt-in no servidor` · `set` · `state`

**Exemplo de construção e uso:**

```lua
local doorlock = pr_lib.loadModule('@pr_bridge/bridge/doorlock/server')
local result = doorlock.setState('example:action', false)
print('Retorno da operação:', result)
```

---

## emotes

### `emotes.beginSession(models)`

**Contexto:** `client`  
**Descrição:** Registra ped, modelos permitidos e objetos já existentes antes da animação, para limpeza delimitada.  
**Arquivo de origem:** [`bridge/emotes/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/emotes/client.lua)  
**Tags:** `emotes` · `client` · `emotes: módulo opt-in` · `begin` · `session`

**Exemplo de construção e uso:**

```lua
local emotes = pr_lib.loadModule('@pr_bridge/bridge/emotes/client')
local result = emotes.beginSession('prop_ld_flow_bottle')
print('Retorno da operação:', result)
```

---

### `emotes.finishSession(session)`

**Contexto:** `client`  
**Descrição:** Finaliza uma vez. Se session.emoteStarted, cancela o emote; remove somente objetos novos dos modelos da sessão que ainda estão anexados ao ped. Não apaga objetos arbitrários do mundo.  
**Arquivo de origem:** [`bridge/emotes/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/emotes/client.lua)  
**Tags:** `emotes` · `client` · `emotes: módulo opt-in` · `finish` · `session`

**Exemplo de construção e uso:**

```lua
local emotes = pr_lib.loadModule('@pr_bridge/bridge/emotes/client')
local result = emotes.finishSession({})
print('Resultado:', result)
```

---

### `emotes.play(command)`

**Contexto:** `client`  
**Descrição:** Executa comando de emote no scully_emotemenu quando iniciado; retorna boolean.  
**Arquivo de origem:** [`bridge/emotes/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/emotes/client.lua)  
**Tags:** `emotes` · `client` · `emotes: módulo opt-in` · `play`

**Exemplo de construção e uso:**

```lua
local emotes = pr_lib.loadModule('@pr_bridge/bridge/emotes/client')
local result = emotes.play('example:action')
print('Retorno da operação:', result)
```

---

## entities

### `pr_lib.getClosestPlayer(coords, radius?, includePlayer?)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get closest player” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/compat/entities_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/entities_client.lua)  
**Tags:** `entities` · `get` · `closest` · `player` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getClosestPlayer('example')
print('Resultado:', result)
```

---

### `pr_lib.getClosestVehicle(coords, radius?, includePlayerVehicle?)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get closest vehicle” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/compat/entities_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/entities_client.lua)  
**Tags:** `entities` · `get` · `closest` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getClosestVehicle(vector3(0.0, 0.0, 0.0), 1, PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.getNearbyPlayers(coords, radius?, includePlayer?)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get nearby players” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/compat/entities_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/entities_client.lua)  
**Tags:** `entities` · `get` · `nearby` · `players` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getNearbyPlayers('example')
print('Resultado:', result)
```

---

### `pr_lib.getNearbyVehicles(coords, radius?, includePlayerVehicle?)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get nearby vehicles” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/compat/entities_client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/compat/entities_client.lua)  
**Tags:** `entities` · `get` · `nearby` · `vehicles` · `client` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.getNearbyVehicles(vector3(0.0, 0.0, 0.0), 1, PlayerPedId())
print('Resultado:', result)
```

---

## environment

### `pr_lib.environment.canUseDeveloperTools(playerSource)`

**Contexto:** `client/server`  
**Descrição:** Só permite no servidor, fora de production e com hasDeveloperAccess aprovado.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `can` · `use` · `developer` · `tools`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.canUseDeveloperTools(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.environment.getAdminAce()`

**Contexto:** `client/server`  
**Descrição:** Retorna o nome da ACE forge-core.admin.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `get` · `admin` · `ace`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.getAdminAce()
print('Resultado:', result)
```

---

### `pr_lib.environment.getCallbackLimits()`

**Contexto:** `client/server`  
**Descrição:** Retorna timeout, maxPending, maxPendingPerPlayer e maxInboundPerPlayer, com limites mínimos e valores definidos nas convars pr_bridge:callback:*.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `get` · `callback` · `limits`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.getCallbackLimits()
print('Resultado:', result)
```

---

### `pr_lib.environment.getCallbackMode()`

**Contexto:** `client/server`  
**Descrição:** Retorna secure ou legacy conforme pr_bridge:callback:secure; padrão legacy.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `get` · `callback` · `mode`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.getCallbackMode()
print('Resultado:', result)
```

---

### `pr_lib.environment.getDeveloperAce()`

**Contexto:** `client/server`  
**Descrição:** Retorna o nome da ACE pr_bridge.developer.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `get` · `developer` · `ace`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.getDeveloperAce()
print('Resultado:', result)
```

---

### `pr_lib.environment.getMode()`

**Contexto:** `client/server`  
**Descrição:** Retorna production, development ou test; lê pr_bridge:environment na inicialização e usa production por padrão.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `get` · `mode`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.getMode()
print('Resultado:', result)
```

---

### `pr_lib.environment.hasDeveloperAccess(playerSource)`

**Contexto:** `client/server`  
**Descrição:** No servidor, permite console (source 0) ou jogador com ACE de desenvolvedor/admin; no cliente sempre retorna false.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `has` · `developer` · `access`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.hasDeveloperAccess(GetPlayerServerId(PlayerId()))
print('Resultado:', result)
```

---

### `pr_lib.environment.isDevelopment()`

**Contexto:** `client/server`  
**Descrição:** Retorna se o ambiente inicializado é development.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `is` · `development`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.isDevelopment()
print('Resultado:', result)
```

---

### `pr_lib.environment.isProduction()`

**Contexto:** `client/server`  
**Descrição:** Retorna se o ambiente inicializado é production.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `is` · `production`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.isProduction()
print('Resultado:', result)
```

---

### `pr_lib.environment.isSecureCallbackEnabled()`

**Contexto:** `client/server`  
**Descrição:** Retorna se o transporte reforçado foi habilitado pela convar na inicialização.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `is` · `secure` · `callback` · `enabled`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.isSecureCallbackEnabled()
print('Resultado:', result)
```

---

### `pr_lib.environment.isTest()`

**Contexto:** `client/server`  
**Descrição:** Retorna se o ambiente inicializado é test.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `is` · `test`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.isTest()
print('Resultado:', result)
```

---

### `pr_lib.environment.normalizeBoolean(value, defaultValue?)`

**Contexto:** `client/server`  
**Descrição:** Normaliza boolean ou texto true/1/yes/on e false/0/no/off; valores desconhecidos usam o default booleano.  
**Arquivo de origem:** [`bridge/environment.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/environment.lua)  
**Tags:** `environment` · `client/server` · `ambiente` · `permissões e callbacks` · `normalize` · `boolean`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.environment.normalizeBoolean({})
print('Resultado:', result)
```

---

## events

### `pr_lib.triggerClientEvent(eventName, target, ...)`

**Contexto:** `server`  
**Descrição:** Dispara um evento de cliente para um ou mais jogadores de forma otimizada. Esta função realiza a serialização (msgpack) dos argumentos apenas uma vez, em vez de fazer por alvo, proporcionando ganhos significativos de desempenho ao disparar para múltiplos jogadores. O parâmetro target aceita um ID numérico, ou uma tabela contendo uma lista de IDs.  
**Arquivo de origem:** [`bridge/triggerClientEvent/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/triggerClientEvent/server.lua)  
**Tags:** `events` · `trigger` · `client` · `event` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.triggerClientEvent('example:action', source)
print('Retorno da operação:', result)
```

---

## fivem.aliases

### `pr_lib.fivem.vehicle.findClosest(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find closest” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `find` · `closest` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.findClosest(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `find` · `in` · `radius` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.findInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getEntity(netId, timeout)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `entity` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getEntity(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getNetId(entity)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `net` · `id` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getNetId(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getOwner(entity)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `owner` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getOwner(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getProperties(vehicle)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get properties” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `properties` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getProperties(PlayerPedId())
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`

**Contexto:** `client`  
**Descrição:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getVehicle(PlayerPedId(), 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “resolve” por meio da API pública do módulo `fivem.vehicle`.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `resolve` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.resolve(PlayerPedId(), 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.setProperties(vehicle, props)`

**Contexto:** `client`  
**Descrição:** Define ou atualiza os dados ou a operação “set properties” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicle` · `set` · `properties` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.setProperties(PlayerPedId(), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find by model in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `by` · `model` · `in` · `radius` · `client` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findClosest(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find closest” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `closest` · `client` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findClosest(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find closest by model” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `closest` · `by` · `model` · `client` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findClosestByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`

**Contexto:** `client`  
**Descrição:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/client.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `in` · `radius` · `client` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.findClosest(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find closest” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `find` · `closest` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.findClosest(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `find` · `in` · `radius` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.findInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getEntity(netId, timeout)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get entity” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `entity` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getEntity(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getNetId(entity)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get net id” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `net` · `id` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getNetId(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getOwner(entity)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get owner” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `owner` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getOwner(0)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`

**Contexto:** `server`  
**Descrição:** Obtém os dados ou a operação “get vehicle” usando a ponte normalizada do módulo.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `get` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.getVehicle(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`

**Contexto:** `server`  
**Descrição:** Executa os dados ou a operação “resolve” por meio da API pública do módulo `fivem.vehicle`.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `resolve` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.resolve(0, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicle.setProperties(vehicle, props, options)`

**Contexto:** `server`  
**Descrição:** Define ou atualiza os dados ou a operação “set properties” usando a autoridade do módulo.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicle` · `set` · `properties` · `server` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicle.setProperties(0, {}, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find by model in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `by` · `model` · `in` · `radius` · `server` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findByModelInRadius('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findClosest(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find closest” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `closest` · `server` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findClosest(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find closest by model” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `closest` · `by` · `model` · `server` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findClosestByModel('prop_ld_flow_bottle', vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`

**Contexto:** `server`  
**Descrição:** Localiza os dados ou a operação “find in radius” conforme os filtros informados.  
**Arquivo de origem:** [`bridge/fivem/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/server.lua)  
**Tags:** `aliases` · `vehicles` · `find` · `in` · `radius` · `server` · `veículo` · `vehicle` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.vehicles.findInRadius(vector3(0.0, 0.0, 0.0), 1, {})
print('Resultado:', result)
```

---

## fivem.blips

### `pr_lib.fivem.blips.describe(value, colorId)`

**Contexto:** `shared`  
**Descrição:** Retorna um dicionário contendo ID, nome do sprite, link da imagem correspondente e dados da cor formatados.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `describe` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.describe({}, 1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getAssetImageUrl(kind, value)`

**Contexto:** `shared`  
**Descrição:** Gerador de URL generico para imagens de assets, incluindo prop e object.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `asset` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getAssetImageUrl('default', {})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getBlipImageUrl(value)`

**Contexto:** `shared`  
**Descrição:** Gera uma URL externa direta contendo a imagem .png do blip correspondente.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `blip` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getBlipImageUrl({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getCheckpointImageUrl(checkpointId)`

**Contexto:** `shared`  
**Descrição:** Retornam URLs contendo imagens demonstrativas de checkponts e marcadores 3D.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `checkpoint` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getCheckpointImageUrl('example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getColorInfo(colorId)`

**Contexto:** `shared`  
**Descrição:** Retorna as propriedades de cor do blip do radar (nome e hexadecimal de cor) a partir de seu ID numérico original.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `color` · `info` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getColorInfo(1)
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getImageUrl(value)`

**Contexto:** `shared`  
**Descrição:** Gera uma URL externa direta contendo a imagem .png do blip correspondente.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getImageUrl({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getMarkerImageUrl(markerId)`

**Contexto:** `shared`  
**Descrição:** Retornam URLs contendo imagens demonstrativas de checkponts e marcadores 3D.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `marker` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getMarkerImageUrl('example')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getObjectImageUrl(model)`

**Contexto:** `shared`  
**Descrição:** Monta a URL de preview de props no padrao [prop_name]-[hash].jpg, por exemplo prop_streetlight_08-1847069612.jpg.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `object` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getObjectImageUrl('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getPedImageUrl(model)`

**Contexto:** `shared`  
**Descrição:** Retorna a URL contendo a imagem de demonstração do modelo do ped.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `ped` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getPedImageUrl('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getPropHashId(model)`

**Contexto:** `shared`  
**Descrição:** Calcula o hash/ID unsigned do modelo com GetHashKey/joaat, usado no nome dos arquivos de props da Rage MP.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `prop` · `hash` · `id` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getPropHashId('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getPropImageUrl(model)`

**Contexto:** `shared`  
**Descrição:** Monta a URL de preview de props no padrao [prop_name]-[hash].jpg, por exemplo prop_streetlight_08-1847069612.jpg.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `prop` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getPropImageUrl('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getSprite(value)`

**Contexto:** `shared`  
**Descrição:** Retorna as informações do Blip (ícone do mapa) pelo seu ID numérico ou nome amigável registrado.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `sprite` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getSprite({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getSpriteId(value)`

**Contexto:** `shared`  
**Descrição:** Converte e recupera nomes ou IDs numéricos equivalentes de sprites de blips do radar.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `sprite` · `id` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getSpriteId({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getSpriteName(value)`

**Contexto:** `shared`  
**Descrição:** Converte e recupera nomes ou IDs numéricos equivalentes de sprites de blips do radar.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `sprite` · `name` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getSpriteName({})
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getVehicleImageUrl(model)`

**Contexto:** `shared`  
**Descrição:** Retorna a URL contendo a imagem do veículo.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `vehicle` · `image` · `url` · `shared` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getVehicleImageUrl('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.getWeaponImageUrl(model)`

**Contexto:** `shared`  
**Descrição:** Retorna a URL contendo a imagem da arma de fogo.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `get` · `weapon` · `image` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.getWeaponImageUrl('prop_ld_flow_bottle')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.listColors()`

**Contexto:** `shared`  
**Descrição:** Retorna a lista completa indexada de sprites e cores originais suportados nativamente pelo FiveM.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `list` · `colors` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.listColors()
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.listSprites()`

**Contexto:** `shared`  
**Descrição:** Retorna a lista completa indexada de sprites e cores originais suportados nativamente pelo FiveM.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `list` · `sprites` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.listSprites()
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.setDocsBaseUrl(url)`

**Contexto:** `shared`  
**Descrição:** Permite atualizar o caminho do servidor de documentação base do FiveM de onde as imagens de assets são baixadas.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `set` · `docs` · `base` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.setDocsBaseUrl('https://example.com')
print('Resultado:', result)
```

---

### `pr_lib.fivem.blips.setRagePropsBaseUrl(url)`

**Contexto:** `shared`  
**Descrição:** Ajusta a URL base usada para imagens de props da Rage MP. Padrao: https://cdn.rage.mp/public/odb/imgs.  
**Arquivo de origem:** [`bridge/fivem/blips/shared.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/blips/shared.lua)  
**Tags:** `blips` · `set` · `rage` · `props` · `base` · `url` · `shared`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.fivem.blips.setRagePropsBaseUrl('https://example.com')
print('Resultado:', result)
```

---

## fivem.devtools

### `pr_lib.devtools.createPlacement(placementType, modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `create` · `placement` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.createPlacement('default', 'prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Resultado:', result)
```

---

### `pr_lib.devtools.createPolyzone(options, cb)`

**Contexto:** `client`  
**Descrição:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `create` · `polyzone` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.createPolyzone({}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.devtools.createSphereZone(options, cb)`

**Contexto:** `client`  
**Descrição:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `create` · `sphere` · `zone` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.createSphereZone({}, function(value) print('Callback:', value) end)
print('Resultado:', result)
```

---

### `pr_lib.devtools.drawModelBoxAtCoords(options)`

**Contexto:** `client`  
**Descrição:** Desenha o wireframe/drawbox de um modelo em coordenadas informadas. Deve ser chamado por frame enquanto o debug ou preview estiver ativo.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `model` · `box` · `at` · `coords` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.drawModelBoxAtCoords({})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.DrawModelBoxAtCoords(options)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “draw model box at coords” por meio da API pública do módulo `fivem.devtools`.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `model` · `box` · `at` · `coords` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.DrawModelBoxAtCoords({})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.drawPedBox(coords, heading, model, options)`

**Contexto:** `client`  
**Descrição:** Desenha o wireframe/drawbox de um modelo em coordenadas informadas. Deve ser chamado por frame enquanto o debug ou preview estiver ativo.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `ped` · `box` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.drawPedBox('example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.devtools.DrawPedBox(coords, heading, model, options)`

**Contexto:** `client`  
**Descrição:** Executa os dados ou a operação “draw ped box” por meio da API pública do módulo `fivem.devtools`.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `ped` · `box` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.DrawPedBox('example', 'example', 'example', {})
print('Resultado:', result)
```

---

### `pr_lib.devtools.drawPolyzone3D(options, cb)`

**Contexto:** `client`  
**Descrição:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `polyzone3` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.drawPolyzone3D({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.DrawPolyzone3D(options, cb)`

**Contexto:** `client`  
**Descrição:** Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `polyzone3` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.DrawPolyzone3D({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.drawSphereZone(options, cb)`

**Contexto:** `client`  
**Descrição:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `sphere` · `zone` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.drawSphereZone({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.drawSphereZone3D(options, cb)`

**Contexto:** `client`  
**Descrição:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `sphere` · `zone3` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.drawSphereZone3D({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.DrawSphereZone3D(options, cb)`

**Contexto:** `client`  
**Descrição:** Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `draw` · `sphere` · `zone3` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.DrawSphereZone3D({}, function(value) print('Callback:', value) end)
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.placeAnimatedPed(modelName, maxSlots, animations, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicia placement de ped com lista de animações/poses para preview e seleção.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** 

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.placeAnimatedPed('example', 1, 'example', function(value) print('Callback:', value) end, {})
print('Resultado:', result)
```

---

### `pr_lib.devtools.placeObject(modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicia modos de colocação específicos para objetos, peds e veículos.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `place` · `object` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.placeObject('prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.placePed(modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicia posicionamento de NPC e devolve ponto/lista com x/y/z/heading. As coordenadas usam referência de superfície; não subtraia altura arbitrária do ped ao interpretar o retorno. options.animations, animationIndex e showPlacementGuides permitem preview animado e controle das guias; placeAnimatedPed oferece atalho dedicado.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `place` · `ped` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.placePed('prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.placeVehicle(modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicia modos de colocação específicos para objetos, peds e veículos.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `place` · `vehicle` · `client` · `veículo` · `carro`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.placeVehicle('prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.startEntityPlacement(placementType, modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `start` · `entity` · `placement` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.startEntityPlacement('default', 'prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.StartEntityPlacement(placementType, modelName, maxSlots, cb, options)`

**Contexto:** `client`  
**Descrição:** Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback cb ao confirmar.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `start` · `entity` · `placement` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.StartEntityPlacement('default', 'prop_ld_flow_bottle', 1, function(value) print('Callback:', value) end, {})
print('Retorno da operação:', result)
```

---

### `pr_lib.devtools.stop()`

**Contexto:** `client`  
**Descrição:** Encerra imediatamente qualquer modo de criação ou posicionamento de entidades ou zonas em andamento.  
**Arquivo de origem:** [`bridge/fivem/devtools/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/devtools/client.lua)  
**Tags:** `devtools` · `stop` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.devtools.stop()
print('Retorno da operação:', result)
```

---

## fivem.drawtext

### `pr_lib.drawtext.change(text, position, options)`

**Contexto:** `client`  
**Descrição:** Altera o texto ou propriedades do painel DrawText ativo na tela.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `change` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.change('Exemplo do PR Bridge', vector3(0.0, 0.0, 0.0), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.ChangeText(text, position, options)`

**Contexto:** `client`  
**Descrição:** Altera o texto ou propriedades do painel DrawText ativo na tela.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `change` · `text` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.ChangeText('Exemplo do PR Bridge', vector3(0.0, 0.0, 0.0), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.draw2d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho 2D.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw2d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.draw2d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.draw3d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho de textos tridimensionais.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw3d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.draw3d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.DrawText(text, position, options)`

**Contexto:** `client`  
**Descrição:** Exibe textos flutuantes formatados.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.DrawText('Exemplo do PR Bridge', vector3(0.0, 0.0, 0.0), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.drawText2d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho 2D.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text2d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.drawText2d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.DrawText2d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho 2D.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text2d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.DrawText2d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.DrawText2D(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho 2D.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text2` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.DrawText2D({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.drawText3d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho de textos tridimensionais.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text3d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.drawText3d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.DrawText3d(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho de textos tridimensionais.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text3d` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.DrawText3d({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.DrawText3D(params)`

**Contexto:** `client`  
**Descrição:** Métodos de desenho de textos tridimensionais.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `draw` · `text3` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.DrawText3D({})
print('Resultado:', result)
```

---

### `pr_lib.drawtext.hide()`

**Contexto:** `client`  
**Descrição:** Apaga o painel de texto.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `hide` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.hide()
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.HideText()`

**Contexto:** `client`  
**Descrição:** Apaga o painel de texto.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `hide` · `text` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.HideText()
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.isOpen()`

**Contexto:** `client`  
**Descrição:** Retorna se há algum painel de DrawText ativo na tela.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `is` · `open` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.isOpen()
print('Resultado:', result)
```

---

### `pr_lib.drawtext.keyPressed(delay)`

**Contexto:** `client`  
**Descrição:** Registra o acionamento de teclas de atalho de interações DrawText com debounce (delay).  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `key` · `pressed` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.keyPressed(1)
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.KeyPressed(delay)`

**Contexto:** `client`  
**Descrição:** Registra o acionamento de teclas de atalho de interações DrawText com debounce (delay).  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `key` · `pressed` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.KeyPressed(1)
print('Retorno da operação:', result)
```

---

### `pr_lib.drawtext.show(text, position, options)`

**Contexto:** `client`  
**Descrição:** Exibe textos flutuantes formatados.  
**Arquivo de origem:** [`bridge/fivem/drawtext/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/drawtext/client.lua)  
**Tags:** `drawtext` · `show` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.drawtext.show('Exemplo do PR Bridge', vector3(0.0, 0.0, 0.0), {})
print('Retorno da operação:', result)
```

---

## fivem.dui

### `pr_lib.dui.create(options, width, height)`

**Contexto:** `client`  
**Descrição:** Comanda sincronizadamente que clientes em target carreguem uma nova instância do navegador DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.create({}, 200, 100)
print('Resultado:', result)
```

---

### `pr_lib.dui.createPoly(target, options)`

**Contexto:** `client`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `poly` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createPoly(GetPlayerServerId(PlayerId()), {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createRenderTarget(target, options)`

**Contexto:** `client`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `render` · `target` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createRenderTarget(GetPlayerServerId(PlayerId()), {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createReplacement(target, options)`

**Contexto:** `client`  
**Descrição:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `replacement` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createReplacement(GetPlayerServerId(PlayerId()), {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createReplaceTexture(target, options)`

**Contexto:** `client`  
**Descrição:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `replace` · `texture` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createReplaceTexture(GetPlayerServerId(PlayerId()), {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createSprite(options)`

**Contexto:** `client`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `create` · `sprite` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createSprite({})
print('Resultado:', result)
```

---

### `pr_lib.dui.destroy(target)`

**Contexto:** `client`  
**Descrição:** Fecha e apaga a instância DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `destroy` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.destroy(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.disableMouse(target)`

**Contexto:** `client`  
**Descrição:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `disable` · `mouse` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.disableMouse(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.drawSprite(target, options)`

**Contexto:** `client`  
**Descrição:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `draw` · `sprite` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.drawSprite(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.enableMouse(target, options)`

**Contexto:** `client`  
**Descrição:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `enable` · `mouse` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.enableMouse(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.focus(target, options)`

**Contexto:** `client`  
**Descrição:** Foca o controle de teclado e mouse do jogador para interagir diretamente com o navegador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `focus` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.focus(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.get(id)`

**Contexto:** `client`  
**Descrição:** Consultas de status e instâncias de DUIs server-side.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `get` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.get('example_id')
print('Resultado:', result)
```

---

### `pr_lib.dui.list()`

**Contexto:** `client`  
**Descrição:** Consultas de status e instâncias de DUIs server-side.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `list` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.list()
print('Resultado:', result)
```

---

### `pr_lib.dui.nuiUrl(path, ownerResource)`

**Contexto:** `client`  
**Descrição:** Gera endereços locais válidos apontando para páginas HTML e assets de recursos NUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `nui` · `url` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.nuiUrl('example', 'my_resource')
print('Resultado:', result)
```

---

### `pr_lib.dui.poly(target, options)`

**Contexto:** `client`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `poly` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.poly(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.removeReplaceTexture(target, options)`

**Contexto:** `client`  
**Descrição:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `remove` · `replace` · `texture` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.removeReplaceTexture(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.renderTarget(target, options)`

**Contexto:** `client`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `render` · `target` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.renderTarget(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.replaceTexture(target, options)`

**Contexto:** `client`  
**Descrição:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `replace` · `texture` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.replaceTexture(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.send(target, message)`

**Contexto:** `client`  
**Descrição:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.send(GetPlayerServerId(PlayerId()), 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.sendMessage(target, message)`

**Contexto:** `client`  
**Descrição:** Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `message` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMessage(GetPlayerServerId(PlayerId()), 'Exemplo do PR Bridge')
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.sendMouseDown(target, button)`

**Contexto:** `client`  
**Descrição:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `mouse` · `down` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMouseDown(GetPlayerServerId(PlayerId()), 'E')
print('Resultado:', result)
```

---

### `pr_lib.dui.sendMouseMove(target, x, y)`

**Contexto:** `client`  
**Descrição:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `mouse` · `move` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMouseMove(GetPlayerServerId(PlayerId()), 0.0, 0.0)
print('Resultado:', result)
```

---

### `pr_lib.dui.sendMouseUp(target, button)`

**Contexto:** `client`  
**Descrição:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `mouse` · `up` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMouseUp(GetPlayerServerId(PlayerId()), 'E')
print('Resultado:', result)
```

---

### `pr_lib.dui.sendMouseWheel(target, deltaX, deltaY)`

**Contexto:** `client`  
**Descrição:** Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `send` · `mouse` · `wheel` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.sendMouseWheel(GetPlayerServerId(PlayerId()), 0.1, 0.1)
print('Resultado:', result)
```

---

### `pr_lib.dui.setBrightness(target, brightness)`

**Contexto:** `client`  
**Descrição:** Controla opacidade e brilho de renderização da textura.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `set` · `brightness` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setBrightness(GetPlayerServerId(PlayerId()), 1.0)
print('Resultado:', result)
```

---

### `pr_lib.dui.setOpacity(target, opacity)`

**Contexto:** `client`  
**Descrição:** Controla opacidade e brilho de renderização da textura.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `set` · `opacity` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setOpacity(GetPlayerServerId(PlayerId()), 1.0)
print('Resultado:', result)
```

---

### `pr_lib.dui.setUrl(target, url)`

**Contexto:** `client`  
**Descrição:** Redireciona o navegador DUI para outro endereço web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `set` · `url` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.setUrl(GetPlayerServerId(PlayerId()), 'https://example.com')
print('Resultado:', result)
```

---

### `pr_lib.dui.startPoly(target, options)`

**Contexto:** `client`  
**Descrição:** APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `start` · `poly` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.startPoly(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.startSprite(target, options)`

**Contexto:** `client`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `start` · `sprite` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.startSprite(GetPlayerServerId(PlayerId()), {})
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.stopPoly(target)`

**Contexto:** `client`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `stop` · `poly` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopPoly(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.stopRenderTarget(target)`

**Contexto:** `client`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `stop` · `render` · `target` · `client` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopRenderTarget(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.stopSprite(target)`

**Contexto:** `client`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `stop` · `sprite` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.stopSprite(GetPlayerServerId(PlayerId()))
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.toggleMouse(target, state)`

**Contexto:** `client`  
**Descrição:** Exibe e controla ponteiros de mouses interativos em cima do navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `toggle` · `mouse` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.toggleMouse(GetPlayerServerId(PlayerId()), false)
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.unfocus()`

**Contexto:** `client`  
**Descrição:** Foca o controle de teclado e mouse do jogador para interagir diretamente com o navegador.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `unfocus` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.unfocus()
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.url(path, ownerResource)`

**Contexto:** `client`  
**Descrição:** Gera endereços locais válidos apontando para páginas HTML e assets de recursos NUI.  
**Arquivo de origem:** [`bridge/fivem/dui/client.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/client.lua)  
**Tags:** `dui` · `url` · `client`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.url('example', 'my_resource')
print('Resultado:', result)
```

---

### `pr_lib.dui.clear(target)`

**Contexto:** `server`  
**Descrição:** Força limpeza de texturas.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `clear` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.clear(source)
print('Retorno da operação:', result)
```

---

### `pr_lib.dui.create(target, options)`

**Contexto:** `server`  
**Descrição:** Comanda sincronizadamente que clientes em target carreguem uma nova instância do navegador DUI.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.create(source, {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createPoly(target, options)`

**Contexto:** `server`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `poly` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createPoly(source, {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createPoly4(target, options)`

**Contexto:** `server`  
**Descrição:** Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `poly4` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createPoly4(source, {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createRenderTarget(target, options)`

**Contexto:** `server`  
**Descrição:** Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `render` · `target` · `server` · `alvo` · `interação` · `zona`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createRenderTarget(source, {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createReplaceTexture(target, options)`

**Contexto:** `server`  
**Descrição:** Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `replace` · `texture` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createReplaceTexture(source, {})
print('Resultado:', result)
```

---

### `pr_lib.dui.createSprite(target, options)`

**Contexto:** `server`  
**Descrição:** Desenha texturas DUI em elementos gráficos 2D.  
**Arquivo de origem:** [`bridge/fivem/dui/server.lua`](https://github.com/Pierremoraes-ofc/pr_bridge/blob/main/bridge/fivem/dui/server.lua)  
**Tags:** `dui` · `create` · `sprite` · `server`

**Exemplo de construção e uso:**

```lua
local result = pr_lib.dui.createSprite(source, {})
print('Resultado:', result)
```

---

