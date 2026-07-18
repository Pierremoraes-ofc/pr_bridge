# PR Bridge Functions - Detalhes e Especificações

## 878 Funçoes catalogada.
Este documento descreve detalhadamente cada uma das funções e APIs expostas através da biblioteca `pr_lib`, explicando seu funcionamento, parâmetros e propósitos práticos de uso.

---

## Módulos do Sistema (`core`, `locale`, `cache`, `debug`, `events`)

### core (Shared)
- **`pr_lib.load(path, env, optional)`**: 
  Carrega e executa dinamicamente um chunk de código Lua a partir de um arquivo virtual ou real (`path`). Opcionalmente, permite passar um ambiente global customizado (`env`) para isolamento do escopo. Se `optional` for verdadeiro, o interpretador silencia erros de ausência do arquivo.
- **`pr_lib.loadFile(resource, fileName, env, optional)`**: 
  Carrega um arquivo específico (`fileName`) de um determinado recurso ativo do servidor (`resource`) no ambiente customizado (`env`). Silencia falhas de carregamento se `optional` for `true`.
- **`pr_lib.loadModule(path, env, optional)`**: 
  Importa dinamicamente submódulos e bibliotecas da estrutura interna da `pr_bridge`.
- **`pr_lib.loadJson(path, optional)` / `pr_lib.readJson(path, optional)`**: 
  Lê, decodifica e retorna uma tabela Lua a partir de um arquivo com formato JSON localizado em `path`.
- **`pr_lib.jsonExists(path)`**: 
  Verifica de forma rápida a existência física de um arquivo no caminho JSON informado.
- **`pr_lib.saveJson(path, value, options)` / `pr_lib.writeJson(path, value, options)`**: 
  Serializa uma tabela Lua (`value`) em formato JSON identado e legível, gravando-a no caminho (`path`).
- **`pr_lib.updateJson(path, changes, options)` / `pr_lib.mergeJson(path, changes, options)`**: 
  Mescla recursivamente dados novos de uma tabela (`changes`) em um arquivo JSON existente no disco, preservando as chaves anteriores.
- **`pr_lib.deleteJson(path)`**: 
  Remove fisicamente o arquivo JSON correspondente ao caminho especificado.
- **`pr_lib.locale(invokingResource)`**: 
  Inicia a ponte de internacionalização do recurso que invocou a biblioteca.
- **`pr_lib.versionCheck(repository)`**: 
  Executa uma checagem em background consultando a API do GitHub para verificar se a versão declarada no manifesto do recurso atual é inferior à última release pública (tag) do repositório informado.
- **`pr_lib.checkDependency(resource, minimumVersion, printMessage)`**: 
  Verifica se outro recurso dependência está rodando no servidor e se a versão instalada atende à restrição de versão mínima informada.

### locale (Shared)
- **`local lang = pr_lib.locale(invokingResource)`**: 
  Instancia o utilitário de localização que permite carregar traduções baseadas na localidade configurada do servidor ou do cliente.
- **`lang:t(key, substitutions)`**: 
  Recupera a tradução associada à `key`. Permite a interpolação dinâmica substituindo variáveis no texto (ex: `%{nome}`).
- **`lang:has(key)`**: 
  Retorna um booleano que indica se a chave de tradução está mapeada na localidade ativa.
- **`lang:extend(phrases, prefix)`**: 
  Adiciona um conjunto de frases a um catálogo de tradução ativo sob um prefixo identificador de namespace.
- **`lang:replace(phrases)`**: 
  Substitui todas as frases de localização atuais por um novo dicionário.
- **`lang:clear()`**: 
  Remove todas as entradas de tradução carregadas.
- **`lang:locale(newLocale)`**: 
  Altera dinamicamente o código de localidade atual do objeto de tradução (ex: para `"pt"`, `"en"`, `"es"`).
- **`lang:delete(phraseTarget, prefix)`**: 
  Apaga uma entrada específica de tradução.

### cache (Shared)
- **`pr_lib.cache.set(key, value)`**: 
  Armazena um dado em memória RAM atrelado a uma chave de identificação de cache.
- **`pr_lib.cache.get(key, fallback)`**: 
  Busca um valor anteriormente guardado no cache. Se a chave não existir ou for nula, retorna o valor de `fallback`.
- **`pr_lib.cache.clear(key)`**: 
  Limpa uma entrada de cache e notifica ouvintes ativos de alteração de estado.
- **`pr_lib.cache.clearPrefix(prefix)`**: 
  Invalida em lote todas as chaves do cache que começarem com um determinado termo.
- **`pr_lib.cache.remember(key, callback, timeout)` / `pr_lib.cache.call(key, callback, timeout)` / `pr_lib.cache(key, callback, timeout)`**: 
  Obtém o valor associado a uma chave. Caso não exista, executa a função de `callback`, persiste o seu retorno sob o tempo limite definido em `timeout` (milissegundos) e então entrega o dado retornado.
- **`pr_lib.cache.onChange(key, callback)`**: 
  Assina a alteração de uma chave de cache específica. O `callback` recebe `(newValue, oldValue)` quando o dado correspondente mudar.
- **`pr_lib.cache.GetPlayer(source, timeout)`**: 
  Retorna o objeto do jogador do framework de forma ultra rápida usando cache em memória para diminuir chamadas repetidas de export.
- **`pr_lib.cache.GetMetadata(source, metadata, timeout)`**: 
  Recupera metadados específicos de um jogador a partir do cache temporário de curta duração.
- **`pr_lib.cache.InvalidatePlayer(source)`**: 
  Limpa todas as instâncias de cache associadas à ID do jogador informada.

### debug (Shared)
- **`pr_lib.debug(...)`**: 
  Imprime dados formatados para console caso o nível de debug do recurso esteja ativado.
- **`pr_lib.debug.isEnabled()`**: 
  Retorna `true` se o console do recurso chamador estiver operando em modo verbose (depuração ativa).
- **`pr_lib.debug.setEnabled(state)`**: 
  Habilita ou desabilita logs de debug em tempo de execução.
- **`pr_lib.debug.log(...)` / `pr_lib.debug.info(...)` / `pr_lib.debug.success(...)`**: 
  Exibe mensagens formatadas no console usando as cores apropriadas do padrão ANSI (cinza, azul, verde).
- **`pr_lib.debug.warn(...)` / `pr_lib.debug.warning(...)`**: 
  Exibe logs de alerta em amarelo no console do servidor/cliente.
- **`pr_lib.debug.error(...)`**: 
  Imprime logs de erro formatados em vermelho no console.

### events (Server)
- **`pr_lib.triggerClientEvent(eventName, target, ...)`**: 
  Dispara um evento de cliente para um ou mais jogadores de forma otimizada. Esta função realiza a serialização (msgpack) dos argumentos apenas uma vez, em vez de fazer por alvo, proporcionando ganhos significativos de desempenho ao disparar para múltiplos jogadores. O parâmetro `target` aceita um ID numérico, ou uma tabela contendo uma lista de IDs.

---

## Ponte de Framework (`pr_lib.framework`)

Este módulo normaliza as diferenças entre as estruturas de dados e exports de frameworks populares como **Qbox, QBCore, ESX e ND-Framework**, de forma que o desenvolvedor utilize a mesma sintaxe independentemente da base do servidor.

### Server-Side
- **`pr_lib.framework.GetResourceName()`**: 
  Retorna o nome do recurso de framework ativo no servidor (ex: `"qbx_core"`, `"qb-core"`, `"es_extended"`).
- **`pr_lib.framework.GetPlayer(source)` / `pr_lib.framework.getPlayerFromId(source)` / `pr_lib.framework.GetPlayerFromId(source)`**: 
  Retorna a tabela abstrata que representa o jogador ativo do framework para a ID (`source`) indicada.
- **`pr_lib.framework.GetPlayerData(source)`**: 
  Obtém os dados puros de persistência do personagem do jogador (como nome, metadados, dinheiro, etc.).
- **`pr_lib.framework.GetPlayerFromIdentifier(identifier)`**: 
  Recupera um jogador logado a partir de sua licença primária ou ID única de cidadão (CitizenID/Identifier).
- **`pr_lib.framework.GetIdentifier(source)` / `pr_lib.framework.GetPlayerIdentifier(source)`**: 
  Retorna o identificador persistente do jogador ativo do framework (CitizenID no QB/QBox, License/CharID no ESX).
- **`pr_lib.framework.GetPlayerName(source)` / `pr_lib.framework.getPlayerName(source)`**: 
  Obtém o nome em jogo (RP) do personagem do jogador.
- **`pr_lib.framework.GetPlayerNameByIdentifier(identifier)`**: 
  Recupera o nome do personagem do jogador offline ou online pelo seu identificador.
- **`pr_lib.framework.GetPlayerDob(source)` / `pr_lib.framework.getPlayerDOB(source)`**: 
  Retorna a data de nascimento registrada do personagem.
- **`pr_lib.framework.GetPlayerGender(source)` / `pr_lib.framework.getPlayerSex(source)`**: 
  Retorna o gênero do personagem (retorna `"m"`, `"f"` ou representação equivalente).
- **`pr_lib.framework.GetPlayerGroup(source)` / `pr_lib.framework.getPlayerGroup(source)`**: 
  Retorna o grupo de permissão de administração do jogador (ex: `"user"`, `"admin"`, `"god"`).
- **`pr_lib.framework.getPlayerHeight(source)`**: 
  Retorna a altura registrada do personagem no framework (normalmente usado em ESX).
- **`pr_lib.framework.GetPlayerJob(source)` / `pr_lib.framework.getPlayerJob(source, dataType)`**: 
  Retorna a tabela ou string contendo o emprego (job), cargo (grade) e permissões do jogador.
- **`pr_lib.framework.SetPlayerJob(source, jobName, grade)`**: 
  Altera o emprego e cargo do jogador remotamente.
- **`pr_lib.framework.SetPlayerDuty(source, onDuty)`**: 
  Altera o estado de servico do emprego ativo do jogador (`true` para entrar em servico, `false` para sair).
- **`pr_lib.framework.AddPlayerToJob(citizenid, jobName, grade)` / `pr_lib.framework.RemovePlayerFromJob(citizenid, jobName)` / `pr_lib.framework.SetPlayerPrimaryJob(citizenid, jobName)`**: 
  Gerencia empregos do personagem por citizenid, incluindo adicionar, remover e definir emprego principal.
- **`pr_lib.framework.AddPlayerToGang(citizenid, gangName, grade)` / `pr_lib.framework.RemovePlayerFromGang(citizenid, gangName)` / `pr_lib.framework.SetPlayerPrimaryGang(citizenid, gangName)`**: 
  Gerencia gangs do personagem por citizenid, incluindo adicionar, remover e definir gang principal.
- **`pr_lib.framework.PlayerHasJob(source, jobName, grade)`**: 
  Verifica se o jogador pertence a um determinado grupo de emprego, com verificação opcional do nível do cargo (`grade`).
- **`pr_lib.framework.GetPlayerMetadata(source, key)` / `pr_lib.framework.getPlayerMetadata(source, key)`**: 
  Obtém um valor guardado dentro dos metadados persistentes do personagem.
- **`pr_lib.framework.SetPlayerMetadata(source, key, value)` / `pr_lib.framework.setPlayerMetadata(source, key, value)`**: 
  Grava um valor nos metadados do jogador e sincroniza a alteração com o banco de dados e cliente.
- **`pr_lib.framework.GetPlayerAccountBalance(source, account)` / `pr_lib.framework.getPlayerMoney(source, account)` / `pr_lib.framework.GetAccountBalance(source, account)`**: 
  Obtém o saldo de dinheiro em uma conta específica (ex: `"cash"`, `"bank"`, `"crypto"`).
- **`pr_lib.framework.AddPlayerAccountBalance(source, account, amount, reason)` / `pr_lib.framework.addPlayerMoney(source, account, amount, reason)` / `pr_lib.framework.AddAccountBalance(source, account, amount, reason)` / `pr_lib.framework.addMoney(src, amount, account, reason)`**: 
  Deposita um valor de dinheiro na conta informada do jogador, exigindo opcionalmente um motivo de log.
- **`pr_lib.framework.RemovePlayerAccountBalance(source, account, amount, reason)` / `pr_lib.framework.removePlayerMoney(source, account, amount, reason)` / `pr_lib.framework.RemoveAccountBalance(source, account, amount, reason)` / `pr_lib.framework.takeMoney(src, amount, reason)`**: 
  Retira dinheiro da conta do jogador (ex: para compras). Retorna se a operação foi bem-sucedida.
- **`pr_lib.framework.addSocietyBalance(account, amount, reason)` / `pr_lib.framework.AddJobAccountBalance(account, amount, reason)`**: 
  Adiciona fundos à conta bancária de uma facção/empresa/sociedade.
- **`pr_lib.framework.removeSocietyBalance(account, amount, reason)` / `pr_lib.framework.RemoveJobAccountBalance(account, amount, reason)`**: 
  Remove fundos da conta corporativa/sociedade de um emprego específico.
- **`pr_lib.framework.GetJobAccountBalance(account)`**: 
  Retorna o saldo bancário atual da conta corporativa da sociedade/facção.
- **`pr_lib.framework.GetPlayerInventory(source)`**: 
  Retorna o inventário bruto de itens carregados do jogador da forma normalizada pelo framework ativo.
- **`pr_lib.framework.GetAllPlayers()`**: 
  Retorna uma lista contendo todos os IDs de jogadores conectados no servidor.
- **`pr_lib.framework.GetFrameworkJobs()`**: 
  Obtém a lista geral de empregos cadastrados no framework ativo.
- **`pr_lib.framework.GetFrameworkGangs()`**:
  Obtém a lista geral de gangs/facções cadastradas no framework ativo quando o framework oferecer esse conceito.
- **`pr_lib.framework.GetJobCount(jobName)`**: 
  Obtém a quantidade de funcionários que estão online e em serviço para o emprego especificado.
- **`pr_lib.framework.GetCoords(source, withHeading)`**: 
  Retorna um `vector3` ou `vector4` contendo as coordenadas globais tridimensionais e o ângulo (heading) da entidade do jogador.
- **`pr_lib.framework.getPlayerSourceFromPlayer(player)`**: 
  Extrai a ID (`source`) do servidor a partir do objeto abstrato do jogador entregue pelo framework.
- **`pr_lib.framework.AddItem(source, itemName, count, metadata, slot)`**: 
  Adiciona um item ao inventário do jogador, especificando metadados ou o slot preferencial.
- **`pr_lib.framework.RemoveItem(source, itemName, count, metadata, slot)`**: 
  Remove um item do inventário do jogador.
- **`pr_lib.framework.CanCarryItem(source, itemName, count, metadata)`**: 
  Verifica se o inventário do jogador comporta o peso/slots adicionais daquele item específico.
- **`pr_lib.framework.HasItem(source, itemName, count, metadata, strict)`**: 
  Verifica se o jogador possui o item com a quantidade especificada.
- **`pr_lib.framework.GetItemCount(source, itemName, metadata, strict)`**: 
  Retorna a contagem exata daquele item no inventário.
- **`pr_lib.framework.GetItemData(source, itemName, metadata, slot)` / `pr_lib.framework.GetItemByName(source, itemName, metadata, slot)` / `pr_lib.framework.getItemByName(name)`**: 
  Obtém a tabela de dados detalhada de um item pelo seu nome.
- **`pr_lib.framework.GetItemBySlot(source, slot)`**: 
  Retorna os dados do item que ocupa o slot numérico informado.
- **`pr_lib.framework.GetItemLabel(itemName)` / `pr_lib.framework.GetItemlabel(itemName)` / `pr_lib.framework.Items(itemName)`**: 
  Retorna o nome amigável/rótulo (label) de exibição do item cadastrado no sistema.
- **`pr_lib.framework.ClearPlayerInventory(source)`**: 
  Apaga todos os itens do inventário de um jogador.
- **`pr_lib.framework.SetMetadata(source, slot, metadata)`**: 
  Define dados e atributos internos customizados para um item em um slot específico.
- **`pr_lib.framework.RegisterUsableItem(itemName, callback)`**: 
  Associa uma função executada quando o jogador consome ou usa o item a partir do inventário.
- **`pr_lib.framework.RegisterCallback(name, callback)`**: 
  Registra um server-callback que pode ser requisitado e retornado síncrona ou assincronamente pelo cliente.
- **`pr_lib.framework.InventoryManagement(source, data)`**: 
  API utilitária para gerenciamento em lote de estados do inventário.
- **`pr_lib.framework.AddWeapon(source, data)` / `pr_lib.framework.RemoveWeapon(source, data)` / `pr_lib.framework.GetWeapon(source, name)` / `pr_lib.framework.CreateWeaponData(source, data, weaponData)`**: 
  Funções utilitárias para lidar com armamentos no padrão de frameworks antigos baseados em loadouts de armas físicas.
- **`pr_lib.framework.GetOwnedVehicleData(plate)`**: 
  Busca no banco de dados a estrutura de persistência associada a um veículo de proprietário baseado na placa.
- **`pr_lib.framework.GetOwnedVehicleOwner(plate)`**: 
  Retorna o identificador único (CitizenID/License) do dono do veículo.
- **`pr_lib.framework.InsertOwnedVehicle(plate, owner, vehicle)`**: 
  Grava um veículo na tabela de propriedade de veículos persistentes.
- **`pr_lib.framework.DeleteOwnedVehicle(plate)`**: 
  Remove a persistência de propriedade de um veículo.
- **`pr_lib.framework.CheckItemValid(source, name, count)`**: 
  Validação interna de segurança de consistência de item de inventário.

### Client-Side
- **`pr_lib.framework.GetPlayer()` / `pr_lib.framework.GetPlayerData()`**: 
  Retorna a tabela contendo informações do jogador local logado.
- **`pr_lib.framework.GetPlayerIdentifier()`**: 
  Obtém a ID de persistência única do personagem do jogador local.
- **`pr_lib.framework.GetPlayerName()` / `pr_lib.framework.getCharacterName()`**: 
  Retorna o nome RP do personagem local.
- **`pr_lib.framework.GetPlayerDob()` / `pr_lib.framework.GetPlayerGender()` / `pr_lib.framework.GetPlayerGroup()` / `pr_lib.framework.GetPlayerJob()` / `pr_lib.framework.GetJobInfo()`**: 
  Utilitários locais para resgatar dados do personagem sincronizados com o framework.
- **`pr_lib.framework.PlayerHasJob(jobName, grade)`**: 
  Retorna `true` se o jogador local estiver ativo no emprego informado.
- **`pr_lib.framework.GetPlayerMetadata(key)` / `pr_lib.framework.getPlayerMetadata(key)`**: 
  Retorna metadados do jogador local.
- **`pr_lib.framework.GetPlayerInventory()`**: 
  Retorna a lista de itens locais do inventário.
- **`pr_lib.framework.GetItemCount(itemName, metadata, strict)` / `pr_lib.framework.HasItem(itemName, count, metadata, strict)`**: 
  Valida posse de itens localmente para decisões rápidas de UI ou menus.
- **`pr_lib.framework.GetAccountBalance(account)` / `pr_lib.framework.GetMoney(account)`**: 
  Retorna o saldo financeiro do personagem local.
- **`pr_lib.framework.IsPlayerLoaded()`**: 
  Retorna se o personagem local terminou de carregar completamente e já está ativo e spawnado no mapa.
- **`pr_lib.framework.IsPlayerDead()`**: 
  Retorna se o jogador local está em estado de morte/nocaute.
- **`pr_lib.framework.GetClosestPlayer()`**: 
  Retorna o ID da entidade ped e o ID de rede do jogador mais próximo do personagem local.
- **`pr_lib.framework.GetClosestVehicle()`**: 
  Retorna o ID da entidade do veículo mais próximo.
- **`pr_lib.framework.Notify(message, kind, duration)`**: 
  Dispara uma notificação nativa simplificada baseada no framework carregado.
- **`pr_lib.framework.ShowTextUI(text)` / `pr_lib.framework.HideTextUI()`**: 
  Exibe e oculta painéis TextUI flutuantes.
- **`pr_lib.framework.toggleOutfit(wear, outfits)`**: 
  Aplica ou remove partes de roupas integradas a sistemas de vestiários de frameworks.

---

## Módulo de Inventário (`pr_lib.inventory`)

Ponte de comunicação abstrata para inventários como **ox_inventory, qb-inventory, qs-inventory e codem-inventory**.

### Server-Side
- **`pr_lib.inventory.GetResourceName()`**: 
  Retorna o nome do script de inventário ativo no servidor.
- **`pr_lib.inventory.AddItem(inv, item, count, metadata, slot, cb)`**: 
  Adiciona um item a um inventário qualquer (`inv` pode ser o ID do jogador ou o ID de um baú/stash).
- **`pr_lib.inventory.RemoveItem(inv, item, count, metadata, slot)`**: 
  Remove um item do inventário do jogador ou de um baú.
- **`pr_lib.inventory.CanCarryItem(inv, item, count, metadata)` / `pr_lib.inventory.CanCarryAmount(inv, item)` / `pr_lib.inventory.CanCarryWeight(inv, weight)`**: 
  Validam limites físicos (peso total, volume ou slots livres) de um inventário para determinar se novos itens podem ser adicionados.
- **`pr_lib.inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)`**: 
  Retorna se o inventário suporta a troca física de um item por outro em termos de peso e capacidade restante.
- **`pr_lib.inventory.HasItem(inv, item, count, metadata, strict)` / `pr_lib.inventory.GetItemCount(inv, itemName, metadata, strict)`**: 
  Verificações de estoque de itens.
- **`pr_lib.inventory.GetItem(inv, item, metadata, returnsCount)` / `pr_lib.inventory.GetItemByName(...)`**: 
  Busca os dados detalhados e integridade de um item pelo seu nome ou chave.
- **`pr_lib.inventory.GetItemBySlot(inv, slot)` / `pr_lib.inventory.GetSlot(inv, slot)`**: 
  Recupera dados do slot do inventário.
- **`pr_lib.inventory.GetItemSlots(inv, item, metadata)`**: 
  Retorna uma lista de números de slots que contêm o item pesquisado.
- **`pr_lib.inventory.GetSlotWithItem(inv, itemName, metadata, strict)` / `pr_lib.inventory.GetSlotsWithItem(...)` / `pr_lib.inventory.GetSlotIdWithItem(...)` / `pr_lib.inventory.GetSlotIdsWithItem(...)` / `pr_lib.inventory.GetSlotForItem(...)` / `pr_lib.inventory.GetEmptySlot(...)`**: 
  Utilitários avançados de pesquisa de slots por critério de itens correspondentes ou vazios.
- **`pr_lib.inventory.GetInventory(inv, owner)` / `pr_lib.inventory.GetInventoryItems(...)` / `pr_lib.inventory.GetPlayerInventory(source)`**: 
  Obtém a tabela geral contendo todos os dados e itens de um inventário específico.
- **`pr_lib.inventory.GetItemInfo(item)` / `pr_lib.inventory.getItemInfo(item)` / `pr_lib.inventory.GetItemLabel(item)` / `pr_lib.inventory.Items(itemName)`**: 
  Retornam metadados estáticos do item a partir da tabela de configuração de itens registrada no inventário.
- **`pr_lib.inventory.GetImagePath(item)` / `pr_lib.inventory.getInventoryImg(image)` / `pr_lib.inventory.GetInventoryImg(image)`**: 
  Obtém o caminho da imagem de exibição do item para uso em interfaces NUI.
- **`pr_lib.inventory.GetCurrentWeapon(inv)`**: 
  Retorna os dados da arma equipada ativa de um inventário de jogador.
- **`pr_lib.inventory.GetContainerFromSlot(inv, slotId)`**: 
  Retorna dados de sub-recipientes/mochilas carregados no slot de inventário.
- **`pr_lib.inventory.GetWeaponAttachmentItems()`**: 
  Retorna a lista de itens válidos que servem como acessórios de armas.
- **`pr_lib.inventory.GetTotalUsedSlots(source)`**: 
  Retorna o número de slots ocupados no inventário.
- **`pr_lib.inventory.GetTotalWeight(items)`**: 
  Calcula o peso total acumulado a partir de uma lista de itens.
- **`pr_lib.inventory.Search(inv, search, item, metadata)`**: 
  Executa buscas avançadas utilizando seletores complexos (comportamento nativo do ox_inventory).
- **`pr_lib.inventory.SetItemMetadata(inv, slot, metadata)` / `pr_lib.inventory.setItemMetadata(...)` / `pr_lib.inventory.SetMetadata(...)`**: 
  Atualiza metadados específicos de um item que ocupa determinado slot (ex: definir durabilidade, número de série).
- **`pr_lib.inventory.SetMaxWeight(inv, maxWeight)` / `pr_lib.inventory.SetSlotCount(inv, slots)`**: 
  Redefine propriedades de limite de peso e contagem de slots de um baú/stash ou jogador.
- **`pr_lib.inventory.SetDurability(inv, slot, durability)`**: 
  Define a durabilidade (vida útil de 0 a 100) do item de um determinado slot.
- **`pr_lib.inventory.SetItemBySlot(source, slot, itemdata)` / `pr_lib.inventory.SetInventoryItems(source, item, amount)` / `pr_lib.inventory.setPlayerInventory(player, data)`**: 
  APIs utilitárias para forçar estados de itens diretamente em slots.
- **`pr_lib.inventory.ClearInventory(inv, keep)` / `pr_lib.inventory.ClearPlayerInventory(inv, keep)`**: 
  Limpa todos os itens de um inventário, permitindo opcionalmente ignorar (preservar) itens informados na tabela `keep`.
- **`pr_lib.inventory.ClearOtherInventory(type, id)`**: 
  Limpa inventários secundários de baús.
- **`pr_lib.inventory.ConfiscateInventory(source)` / `pr_lib.inventory.ReturnInventory(source)`**: 
  Usado para apreender o inventário do jogador temporariamente e depois restaurá-lo (útil para sistemas de prisão).
- **`pr_lib.inventory.SaveInventory(source, offline)` / `pr_lib.inventory.LoadInventory(source, identifier)`**: 
  Força salvamento ou carregamento direto de estados de inventários no banco de dados.
- **`pr_lib.inventory.InspectInventory(target, source)`**: 
  Permite que o jogador `source` visualize e inspecione em tempo real o inventário do jogador `target`.
- **`pr_lib.inventory.OpenPlayerInventory(src, target)` / `pr_lib.inventory.OpenStash(source, id)` / `pr_lib.inventory.OpenShop(src, shopTitle)` / `pr_lib.inventory.forceOpenInventory(...)`**: 
  Exibe na tela da ID especificada a UI do inventário aberta em um baú, jogador ou loja.
- **`pr_lib.inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)`**: 
  Registra dinamicamente um novo baú (stash) no inventário com regras de permissão.
- **`pr_lib.inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)`**: 
  Cria uma loja dinâmica acessível por alvo ou coordenadas.
- **`pr_lib.inventory.RegisterUsableItem(item, cb, options)` / `pr_lib.inventory.CreateUsableItem(item, cb)`**: 
  Registra lógica de ativação de itens consumíveis.
- **`pr_lib.inventory.CreateTemporaryStash(properties)`**: 
  Cria um baú em memória que é descartado após o encerramento do recurso ou limpeza.
- **`pr_lib.inventory.CreateDropFromPlayer(playerId)`**: 
  Dropa todos os itens do inventário de um jogador no chão em um contêiner físico.
- **`pr_lib.inventory.CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)`**: 
  Cria um container de drop customizado no chão no mundo 3D.
- **`pr_lib.inventory.AddStashItems(id, items)` / `pr_lib.inventory.GetStashItems(id)` / `pr_lib.inventory.ClearStash(id)` / `pr_lib.inventory.UpdateStash(...)` / `pr_lib.inventory.AddItemIntoStash(...)` / `pr_lib.inventory.RemoveItemIntoStash(...)`**: 
  Lógicas de gerenciamento remoto de itens persistidos dentro de baús registrados.
- **`pr_lib.inventory.AddTrunkItems(identifier, items)`**: 
  Adiciona itens ao porta-malas de um veículo persistente.
- **`pr_lib.inventory.UpdateVehicle(oldPlate, newPlate)`**: 
  Transfere itens e baús de porta-malas/porta-luvas quando a placa de um veículo for alterada.
- **`pr_lib.inventory.CheckItemValid(source, name, count)`**: 
  Validação interna de segurança de transação de inventário.

### Client-Side
- **`pr_lib.inventory.GetResourceName()`**: 
  Nome do script de inventário do cliente.
- **`pr_lib.inventory.HasItem(item, count, metadata, strict)` / `pr_lib.inventory.GetItemCount(...)`**: 
  Verificadores locais rápidos de estoque de itens.
- **`pr_lib.inventory.GetItemInfo(item)` / `pr_lib.inventory.getItemInfo(item)` / `pr_lib.inventory.GetItemLabel(item)` / `pr_lib.inventory.GetItemList()` / `pr_lib.inventory.Items(itemName)`**: 
  Busca propriedades registradas locais dos itens.
- **`pr_lib.inventory.GetImagePath(item)` / `pr_lib.inventory.getInventoryImg(image)` / `pr_lib.inventory.GetInventoryImg(image)`**: 
  Resgata caminhos de imagens.
- **`pr_lib.inventory.GetSlotWithItem(...)` / `pr_lib.inventory.GetSlotsWithItem(...)` / `pr_lib.inventory.GetSlotIdWithItem(...)` / `pr_lib.inventory.GetSlotIdsWithItem(...)`**: 
  Procura slots correspondentes localmente.
- **`pr_lib.inventory.GetPlayerInventory()` / `pr_lib.inventory.GetClientPlayerInventory()` / `pr_lib.inventory.GetPlayerItems()`**: 
  Retorna a lista bruta de itens que estão atualmente na posse do jogador local.
- **`pr_lib.inventory.GetPlayerMaxWeight()` / `pr_lib.inventory.GetPlayerWeight()`**: 
  Resgata propriedades de peso do jogador local.
- **`pr_lib.inventory.GetWeaponList()`**: 
  Retorna lista de armas estáticas cadastradas.
- **`pr_lib.inventory.getCurrentWeapon()` / `pr_lib.inventory.getUserInventory()`**: 
  Resgata arma equipada e inventário bruto local do cliente.
- **`pr_lib.inventory.Search(search, item, metadata)`**: 
  Executa buscas baseadas em seletores (ex: buscar durabilidade menor que 10).
- **`pr_lib.inventory.displayMetadata(metadata, value)`**: 
  Registra formatação de exibição de metadados customizados na interface do inventário.
- **`pr_lib.inventory.openInventory(invType, data)` / `pr_lib.inventory.closeInventory()` / `pr_lib.inventory.isInventoryOpen()`**: 
  Lógicas de abertura, fechamento e status de exibição da UI do inventário.
- **`pr_lib.inventory.openNearbyInventory()`**: 
  Abre o contêiner de drop/chão mais próximo.
- **`pr_lib.inventory.setInventoryDisabled(state)` / `pr_lib.inventory.CheckIfInventoryBlocked()`**: 
  Desativa e bloqueia a abertura do inventário pelo jogador (útil em animações de algemas, etc.).
- **`pr_lib.inventory.RegisterStash(id, slots, weight)` / `pr_lib.inventory.setStashTarget(id, owner)`**: 
  Registra ou define o proprietário temporário de baús.
- **`pr_lib.inventory.useItem(data, cb)` / `pr_lib.inventory.useSlot(slot)`**: 
  Usa localmente um item ou aciona a tecla de atalho de um slot de arma/item.
- **`pr_lib.inventory.giveItemToTarget(serverId, slotId, count)`**: 
  Transfere um item do inventário local diretamente para o jogador próximo (`serverId`).
- **`pr_lib.inventory.setInClothing(state)`**: 
  Desativa o acesso a itens quando o jogador está em animação de troca de roupa.
- **`pr_lib.inventory.weaponWheel(state)`**: 
  Ativa ou desativa o menu circular nativo de armas do GTA V.

---

## Notificações e Menus (`pr_lib.notify`, `pr_lib.menus`, `pr_lib.textuiAdapter`)

### Módulo de Notificações (Server e Client)
- **`pr_lib.notify.GetResourceName()`**: 
  Retorna o script de notificação ativo (ex: `"ox_lib"`, `"okokNotify"`, `"bulletin"`, etc.).
- **`pr_lib.notify.Notify(src, data, kind, duration)`** *(Server)* / **`pr_lib.notify.Notify(data, kind, duration)`** *(Client)*: 
  Envia uma notificação flutuante na tela. O parâmetro `data` pode ser uma string contendo a mensagem ou uma tabela com propriedades como `title`, `description`, `type`, `icon`, etc. `kind` e `duration` servem de fallback de tipo de notificação e tempo de duração (em ms).

### Módulo de Menus (Client)
- **`pr_lib.menus.RegisterMenu(data, cb)`**: 
  Registra um menu contextual ou lista (baseado em ox_lib ou qb-menu). `data` descreve as opções e `cb` é acionado quando o menu é fechado ou atualizado.
- **`pr_lib.menus.ShowMenu(id, startIndex)` / `pr_lib.menus.HideMenu(onExit)`**: 
  Exibe ou esconde o menu registrado sob a ID correspondente.
- **`pr_lib.menus.RegisterContext(context)` / `pr_lib.menus.ShowContext(id)` / `pr_lib.menus.HideContext(onExit)` / `pr_lib.menus.GetOpenContextMenu()`**: 
  Criação, manipulação e status de exibição de menus contextuais modernos e listagens interativas.
- **`pr_lib.menus.InputDialog(heading, rows, options)`**: 
  Exibe uma caixa de diálogo na tela contendo formulários de entrada de dados (inputs, selects, etc.), retornando as respostas do usuário após o envio.
- **`pr_lib.menus.AlertDialog(data, timeout)`**: 
  Exibe um modal pop-up de confirmação de tela cheia (ex: Sim/Não), aguardando e retornando a decisão do jogador.

### Módulo TextUI (Client)
- **`pr_lib.textuiBridge.GetResourceName()`**: 
  Retorna o recurso ativo de TextUI.
- **`pr_lib.textuiBridge.Show(text)` / `pr_lib.textuiBridge.show(text)`**: 
  Mostra um painel flutuante de texto na tela (geralmente no canto superior esquerdo ou centralizado).
- **`pr_lib.textuiBridge.Hide()` / `pr_lib.textuiBridge.hide()`**: 
  Esconde o painel TextUI ativo.

---

## Interações Físicas e Alvos (`pr_lib.target`)

Este módulo gerencia a integração de alvos tridimensionais usando **ox_target, qb-target ou qtarget**.

### Client-Side
- **`pr_lib.target.GetResourceName()`**: 
  Nome do recurso de target ativo.
- **`pr_lib.target.addBoxZone(parameters)` / `pr_lib.target.AddBoxZone(name, coords, size, rotation, options, debug)`**: 
  Cria uma zona de interação retangular tridimensional invisível (ou com renderização em debug) no mapa.
- **`pr_lib.target.addSphereZone(parameters)` / `pr_lib.target.AddSphereZone(name, coords, radius, options, debug)`**: 
  Cria uma zona de interação esférica em coordenadas 3D.
- **`pr_lib.target.addPolyZone(parameters)` / `pr_lib.target.AddPolyZone(name, points, thickness, options, debug)`**: 
  Cria uma zona de interação poligonal complexa contornando uma área.
- **`pr_lib.target.removeZone(id)` / `pr_lib.target.RemoveZone(id)`**: 
  Remove do sistema de alvos a zona de interação correspondente à ID informada.
- **`pr_lib.target.addEntity(netIds, options)` / `pr_lib.target.AddEntity(netIds, options)`**: 
  Registra opções de interação via menu de alvo (olho/olhar) para uma entidade de rede (veículo, ped, objeto) baseada em sua ID de rede.
- **`pr_lib.target.removeEntity(netIds, optionNames)` / `pr_lib.target.RemoveEntity(...)`**: 
  Remove opções específicas registradas na entidade de rede.
- **`pr_lib.target.addLocalEntity(entities, options)` / `pr_lib.target.AddLocalEntity(...)`**: 
  Cria interações de alvo para entidades locais criadas unicamente no cliente.
- **`pr_lib.target.removeLocalEntity(entities, optionNames)` / `pr_lib.target.RemoveLocalEntity(...)`**: 
  Remove interações da entidade local.
- **`pr_lib.target.addModel(models, options)` / `pr_lib.target.AddModel(models, options)`**: 
  Registra interações que estarão ativas globalmente para todos os objetos, peds ou veículos criados que utilizem o modelo 3D (hash/name) especificado (ex: lixeiras, hidrantes).
- **`pr_lib.target.removeModel(models, optionNames)` / `pr_lib.target.RemoveModel(...)`**: 
  Remove opções do modelo.
- **`pr_lib.target.addGlobalObject(options)` / `pr_lib.target.AddGlobalObject(options)` / `pr_lib.target.removeGlobalObject(...)` / `pr_lib.target.RemoveGlobalObject(...)`**: 
  Adiciona ou remove opções de interações aplicadas globalmente em **todos** os objetos físicos do GTA.
- **`pr_lib.target.addGlobalPed(options)` / `pr_lib.target.AddGlobalPed(options)` / `pr_lib.target.removeGlobalPed(...)` / `pr_lib.target.RemoveGlobalPed(...)`**: 
  Registra opções aplicadas a todos os peds (NPCs) do jogo.
- **`pr_lib.target.addGlobalPlayer(options)` / `pr_lib.target.AddGlobalPlayer(...)` / `pr_lib.target.removeGlobalPlayer(...)` / `pr_lib.target.RemoveGlobalPlayer(...)`**: 
  Adiciona opções que aparecerão ao focar a mira do alvo em outros jogadores online (ex: revistar, algemar).
- **`pr_lib.target.addGlobalVehicle(options)` / `pr_lib.target.AddGlobalVehicle(...)` / `pr_lib.target.removeGlobalVehicle(...)` / `pr_lib.target.RemoveGlobalVehicle(...)`**: 
  Registra opções em todos os veículos do mundo 3D (ex: trancar/destrancar).
- **`pr_lib.target.addGlobalOption(options)` / `pr_lib.target.removeGlobalOption(...)`**: 
  Opções universais que se aplicam a qualquer elemento do mundo 3D focado pelo target.
- **`pr_lib.target.disableTargeting(state)` / `pr_lib.target.DisableTargeting(state)`**: 
  Ativa ou desativa temporariamente a possibilidade do jogador usar a tecla do target.
- **`pr_lib.target.FixOptions(options)`**: 
  Normalização interna de parâmetros de callback de alvos.

---

## Aplicativos de Celular (`pr_lib.phone`)

Gerenciamento de integrações para smartphones como **gksphone, qs-smartphone, lb-phone, yseries** e similares.

### Server-Side
- **`pr_lib.phone.GetMetaFromSource(source)`**: 
  Obtém metadados de mídia, contatos ou fotos salvos no celular do jogador.
- **`pr_lib.phone.GetPhoneNames()`**: 
  Lista de telefones cadastrados.
- **`pr_lib.phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)`**: 
  Retorna o número de telefone do jogador com base no seu identificador.
- **`pr_lib.phone.HasEmailAccount(source)`**: 
  Verifica se o jogador local criou ou possui uma conta ativa de e-mail no aplicativo.
- **`pr_lib.phone.IsInJobDuty(source)` / `pr_lib.phone.SetInJobDuty(source)` / `pr_lib.phone.RemoveFromJobDuty(source)`**: 
  Modifica e consulta o status de trabalho em serviço de serviços de emergência nos aplicativos de dispatch/chamados do celular.
- **`pr_lib.phone.SendNewMessageFromApp(target, phoneNumber, message, appName)`**: 
  Envia uma notificação/mensagem de texto simulada de um aplicativo (ex: WhatsApp, Bank) para o celular de destino.
- **`pr_lib.phone.SendSOSMessage(source, job, coords, messageType)`**: 
  Envia uma notificação de chamado de emergência GPS para os celulares das facções militares/médicas em serviço.

### Client-Side
- **`pr_lib.phone.InPhone()`**: 
  Retorna `true` se o jogador local estiver ativamente com a interface gráfica do celular aberta.
- **`pr_lib.phone.ClosePhone()`**: 
  Força o fechamento imediato do celular.
- **`pr_lib.phone.SetCanOpenPhone(bool)`**: 
  Bloqueia ou libera a capacidade do jogador de abrir a interface do telefone.
- **`pr_lib.phone.SetSOS(bool)`**: 
  Ativa ou desativa alertas persistentes de GPS SOS locais.
- **`pr_lib.phone.CreateCall(name, number, image, anonymous)`**: 
  Inicia a interface de discagem/ligação local no telefone.
- **`pr_lib.phone.EndCall()`**: 
  Encerra a chamada ativa localmente.
- **`pr_lib.phone.GetCall()` / `pr_lib.phone.IsInCall()`**: 
  Consultas de status de ligações ativas.
- **`pr_lib.phone.IsInCamera()`**: 
  Retorna se o jogador está utilizando o aplicativo de foto/câmera do celular.

---

## Banco de Dados (`pr_lib.database`)

Normalizador de banco de dados SQL compatível com **oxmysql, mysql-async e ghmattimysql**. Suporta consultas síncronas usando Promises e backups automatizados.

### Server-Side
- **`pr_lib.database.GetResourceName()`**: 
  Retorna o recurso SQL de banco de dados ativo (ex: `"oxmysql"`).
- **`pr_lib.database.isReady()`**: 
  Retorna se a conexão inicial e o pool de conexões com o MySQL estão prontos para receber queries.
- **`pr_lib.database.query(query, parameters, cb)` / `pr_lib.database.Select(...)`**: 
  Executa uma query no banco de dados e retorna uma lista completa de tabelas de registros (linhas) correspondentes.
- **`pr_lib.database.execute(query, parameters, cb)` / `pr_lib.database.Execute(...)` / `pr_lib.database.run(...)` / `pr_lib.database.auto(...)`**: 
  Executa instruções DDL ou DML (como INSERT, UPDATE, DELETE) que alteram dados, retornando a quantidade de linhas afetadas ou informações da transação.
- **`pr_lib.database.scalar(query, parameters, cb)` / `pr_lib.database.Scalar(...)`**: 
  Executa a query e extrai a primeira coluna do primeiro registro retornado (útil para buscar contagens `COUNT(*)` ou valores de colunas únicas).
- **`pr_lib.database.single(query, parameters, cb)`**: 
  Executa a query e retorna uma tabela simples contendo as chaves da primeira linha encontrada (útil para buscar um único usuário).
- **`pr_lib.database.insert(query, parameters, cb)` / `pr_lib.database.Insert(...)`**: 
  Insere registros no banco de dados e retorna a ID numérica autoincremento (insertId) do registro inserido.
- **`pr_lib.database.update(query, parameters, cb)` / `pr_lib.database.Update(...)`**: 
  Executa comandos SQL de alteração de dados, retornando a contagem de linhas afetadas.
- **`pr_lib.database.transaction(queries, parameters, cb)` / `pr_lib.database.Transaction(...)`**: 
  Executa um lote de queries SQL como uma transação atômica. Se qualquer uma falhar, executa um Rollback geral no banco de dados.
- **`pr_lib.database.fetch(...)` / `pr_lib.database.fetchAll(...)` / `pr_lib.database.read(...)` / `pr_lib.database.write(...)`**: 
  Aliases compatíveis de leitura e gravação legadas para scripts antigos que dependiam de mysql-async ou ghmattimysql.
- **`pr_lib.database.backup.create(options)` / `pr_lib.database.backup.run(...)` / `pr_lib.database.backup.export(...)` / `pr_lib.database.createBackup(options)` / `pr_lib.sqlBackup.create(options)`**: 
  Exporta tabelas e dados em formato de arquivo `.sql` gravado no disco do servidor de forma otimizada e nativa através de consultas. O parâmetro `options` permite configurar as tabelas a serem salvas, o local e se deve exportar estrutura (`schema`), dados (`inserts`) ou ambos.

### Client-Side (Stubs para compatibilidade de chamadas locais)
- **`pr_lib.database.GetResourceName()`** / **`pr_lib.database.isReady()`** / **`pr_lib.database.query(...)`** etc.: 
  O cliente possui stubs locais para compatibilidade de API de bibliotecas, porém as consultas SQL reais devem ser acionadas e executadas apenas através do lado do servidor (Server-Side).

---

## Combustível e Chaves de Veículos (`pr_lib.fuel`, `pr_lib.vehicle_key`)

### Combustível (`pr_lib.fuel` - Client)
- **`pr_lib.fuel.GetResourceName()`**: 
  Retorna o script de combustível ativo (ex: `"ox_fuel"`, `"legacyfuel"`).
- **`pr_lib.fuel.GetFuel(vehicle)`**: 
  Obtém a porcentagem ou volume de combustível atual de um veículo (de `0.0` a `100.0`).
- **`pr_lib.fuel.SetFuel(vehicle, amount, type)`**: 
  Define a quantidade e tipo de combustível no veículo informado.

### Chaves de Veículos (`pr_lib.vehicle_key` - Server/Client)

Ponte normalizadora para sistemas de trancar/destrancar e permissões de chave como **qb-vehiclekeys, cd_garage, wasabi_carlock, jg-advancedgarage** e similares.

#### Server-Side
- **`pr_lib.vehicle_key.HasKey(source, plate)` / `pr_lib.vehicle_key.HavePermanentKey(...)`**: 
  Consulta se o jogador de ID `source` possui as chaves físicas de um veículo com a placa especificada.
- **`pr_lib.vehicle_key.GiveKey(source, plate)` / `pr_lib.vehicle_key.GiveTempKeys(...)`**: 
  Concede chaves permanentes ou temporárias de um veículo para o jogador.
- **`pr_lib.vehicle_key.RemoveKey(source, plate)` / `pr_lib.vehicle_key.RemoveTempKeys(...)`**: 
  Revoga e retira a posse de chaves.
- **`pr_lib.vehicle_key.GiveKeyItem(source, plate, netId)` / `pr_lib.vehicle_key.RemoveKeyItem(source, plate)`**: 
  Associa a posse da chave de um veículo específico a um item físico físico do inventário do jogador.
- **`pr_lib.vehicle_key.HaveTemporaryKey(source, plate)`**: 
  Retorna se o jogador tem uma chave temporária/alugada.
- **`pr_lib.vehicle_key.GetAllKeys(source)`**: 
  Retorna a lista completa de placas de veículos das quais o jogador tem chaves guardadas.

#### Client-Side
- **`pr_lib.vehicle_key.GetResourceName()`**: 
  Script de chaves ativo localmente.
- **`pr_lib.vehicle_key.HasKey(plate)` / `pr_lib.vehicle_key.HavePermanentKey(plate)` / `pr_lib.vehicle_key.HaveTemporaryKey(plate)`**: 
  Retorna o status de posse de chave local do jogador para a placa informada.
- **`pr_lib.vehicle_key.GiveKey(plate)` / `pr_lib.vehicle_key.GiveTempKeys(plate)` / `pr_lib.vehicle_key.GiveKeys(vehicle, plate)`**: 
  Registra a chave localmente no chaveiro do veículo.
- **`pr_lib.vehicle_key.RemoveKey(plate)` / `pr_lib.vehicle_key.RemoveTempKeys(plate)` / `pr_lib.vehicle_key.RemoveKeys(vehicle, plate)`**: 
  Remove as chaves locais do veículo.
- **`pr_lib.vehicle_key.GiveKeyItem(plate, vehicle)` / `pr_lib.vehicle_key.RemoveKeyItem(plate)`**: 
  Associações de itens de chaves.
- **`pr_lib.vehicle_key.GetAllKeys(target)`**: 
  Retorna chaves registradas.
- **`pr_lib.vehicle_key.GiveKeyMenu(plate)`**: 
  Abre o menu para emprestar ou entregar a chave do veículo correspondente à placa para o jogador mais próximo.
- **`pr_lib.vehicle_key.ManageKeysMenu()`**: 
  Exibe o menu de chaveiro contendo todas as chaves do jogador para controle e exclusões.
- **`pr_lib.vehicle_key.ToggleLock()`**: 
  Executa a ação local de chaveamento física do veículo (trancar/destrancar porta, tocar alarme e piscar setas).

---

## Outros Adaptadores (`pr_lib.banking`, `pr_lib.callback`, `pr_lib.ace`, `pr_lib.progress`, `pr_lib.weather`)

### Finanças (`pr_lib.banking` - Shared)
- **`pr_lib.banking.GetResourceName()`**: 
  Retorna o recurso bancário ativo (ex: `"okokBanking"`, `"renewed_banking"`, etc.).
- **`pr_lib.banking.GetAccountBalance(player, accountType)` / `pr_lib.banking.GetPlayerAccountBalance(...)`**: 
  Retorna o saldo de uma conta bancária de um jogador (ex: `"personal"`, `"savings"`).
- **`pr_lib.banking.AddAccountBalance(...)` / `pr_lib.banking.AddPlayerAccountBalance(...)`**: 
  Adiciona fundos à conta bancária de um jogador.
- **`pr_lib.banking.RemoveAccountBalance(...)` / `pr_lib.banking.RemovePlayerAccountBalance(...)`**: 
  Deduz dinheiro da conta bancária de um jogador.
- **`pr_lib.banking.GetJobAccountBalance(account)` / `pr_lib.banking.AddJobAccountBalance(...)` / `pr_lib.banking.RemoveJobAccountBalance(...)`**: 
  Visualiza e altera o saldo de contas bancárias corporativas/sociedades de empregos.

### Callbacks e Requisições (`pr_lib.callback` - Server e Client)
- **`pr_lib.callback.trigger(target, name, cb, ...)`** *(Server)* / **`pr_lib.callback.trigger(name, cb, ...)`** *(Client)*: 
  Dispara uma chamada assíncrona que executa um bloco de código no ambiente oposto (Server para Client, ou vice-versa) e executa a função `cb` entregando o resultado assim que a resposta for enviada.
- **`pr_lib.callback.triggerClient(target, name, cb, ...)`** *(Server)*: 
  Dispara um callback direcionado ao cliente do jogador `target`.
- **`pr_lib.callback.await(target, name, timeout, ...)`** *(Server)* / **`pr_lib.callback.await(name, timeout, ...)`** *(Client)* / **`pr_lib.callback.awaitClient(...)`** *(Server)*: 
  Chama o callback remoto bloqueando a execução da thread atual (síncrona) até que a resposta chegue, ou ocorra um estouro de tempo limite (`timeout` em ms). Retorna os dados diretamente.
- **`pr_lib.callback.cancel(requestId)`**: 
  Cancela uma requisição pendente ativa.
- **`pr_lib.callback.getPending()`**: 
  Retorna a lista de requisições de callback aguardando resposta.

### Ace Permissions (`pr_lib.ace` - Server)
- **`pr_lib.ace.getIdentifiers(source)`**: 
  Retorna todos os identificadores conhecidos de rede do jogador (license, discord, ip, steam, etc.).
- **`pr_lib.ace.hasIdentifier(source, identifier)`**: 
  Verifica se um jogador possui um identificador específico.
- **`pr_lib.ace.isPlayerAceAllowed(source, aceName)` / `pr_lib.ace.hasAce(source, aceName)`**: 
  Consulta nativa se o jogador possui permissões no arquivo de configurações `server.cfg` baseada em ACE principal (ex: `IsPlayerAceAllowed`).
- **`pr_lib.ace.isIdentifierAceAllowed(source, aceName)` / `pr_lib.ace.hasIdentifierAce(...)`**: 
  Verifica se o identificador específico do jogador está explicitamente autorizado no ACE.
- **`pr_lib.ace.isCommandAllowed(source, commandName)` / `pr_lib.ace.hasCommandAce(...)`**: 
  Retorna se o jogador tem permissão de execução de um comando do console nativo do FiveM.
- **`pr_lib.ace.isWhitelisted(source, whitelistName)` / `pr_lib.ace.inWhitelist(...)`**: 
  Verifica se o jogador está em uma whitelist do ACE correspondente ao nome da licença.
- **`pr_lib.ace.hasFrameworkAccess(source, options)` / `pr_lib.ace.canAccess(source, options)`**: 
  Verificação híbrida de permissão que analisa grupos de frameworks, empregos e permissões ACE configuradas no objeto `options`.
- **`pr_lib.ace.ensureAce(principal, aceName)` / `pr_lib.ace.addAce(principal, aceName, allow)`**: 
  Adiciona ou garante a existência de regras ACE dinamicamente (ex: conceder comandos administrativos).
- **`pr_lib.ace.ensureCommandAce(principal, commandName)`**: 
  Garante permissão ACE de execução de comando.
- **`pr_lib.ace.removeAce(principal, aceName, allow)`**: 
  Apaga ou altera regras ACE de permissão.
- **`pr_lib.ace.addPrincipal(child, parent)` / `pr_lib.ace.removePrincipal(...)`**: 
  Vincula ou remove herança e hierarquia de principais do ACE (ex: herdar permissões de admin de um cargo superior).
- **`pr_lib.ace.parseConvarList(raw)`**: 
  Parser interno de strings de convars.

### Comandos e Teclas (`pr_lib.addCommand`, `pr_lib.addKeybind` - Client/Server)
- **`pr_lib.addCommand(commandName, properties, callback)` / `pr_lib.addCommand.add(...)` / `pr_lib.addCommand.register(...)`**: 
  API robusta para registro de comandos de console/chat. Suporta filtragem nativa de permissões (empregos, cargos, ACE e whitelists), sugestões de chat automáticas com parâmetros tipados e conversão automática de argumentos de entrada (ex: converter string para número, boleano ou ID do jogador "me").
- **`pr_lib.addKeybind(data)`**: 
  Registra mapeamentos de teclas (key mappings) nativas do GTA V que podem ser alterados pelas configurações do jogador no FiveM. O objeto `data` define o nome, descrição, tecla padrão de mapeamento (`keys`), atalhos de combinações de teclas e callbacks acionados quando pressionado (`onPressed`) e solto (`onReleased`).
- **`pr_lib.addKeybind.get(name)`**: 
  Obtém o objeto mapeador de tecla registrado.
- **`pr_lib.addKeybind.remove(name)`**: 
  Remove e desativa permanentemente o mapeamento de teclas associado.

### Progressbar (`pr_lib.progress` - Client)
- **`pr_lib.progress.doProgressbar(duration, label, anim)`**: 
  Mostra uma barra de carregamento de progresso linear na tela com tempo especificado em `duration` (ms) executando opcionalmente uma animação no personagem (`anim`).
- **`pr_lib.progress.doProgressCircle(duration, label, anim)`**: 
  Exibe uma animação circular de contagem de progresso na tela do jogador.


### Minigames (`pr_lib.minigame` - Client)
- **`pr_lib.minigame.Start(config, mode)` / `pr_lib.minigames.Start(config, mode)`**:
  Executa o minigame ativo detectado pelo `pr_bridge` e retorna `true` em sucesso ou `false` em falha/cancelamento. O parametro `config` deve conter a configuracao do minigame, incluindo `game` e, quando aplicavel, `dificultMinigame.vehiParked` e `dificultMinigame.vehiCarjack`. O parametro `mode` seleciona qual dificuldade usar, por exemplo `"parked"` para veiculo estacionado ou `"carjack"` para roubo/abordagem. Adaptadores atuais: `glitch-minigames`, `glitch-minigame`, `mhacking`, `ox_lib` e fallback `default`.
### Clima e Tempo (`pr_lib.weather` - Client)
- **`pr_lib.weather.GetResourceName()`**: 
  Retorna o recurso gerenciador de clima ativo (ex: `"vSync"`, `"cd_easytime"`).
- **`pr_lib.weather.ToggleSync(toggle)`**: 
  Ativa ou congela a sincronização global de clima e hora locais para o jogador.

---

## Tradutor de Textos (`pr_lib.translator`)

Este módulo provê tradução automatizada de textos inteiros, menus do ox_lib e notificações em tempo real consumindo a API gratuita do Google Translate, possuindo persistência de cache local em JSON.

### Server-Side
- **`pr_lib.translator.translateText(text, targetLang, cb)` / `pr_lib.translator.translate(...)`**: 
  Traduz um texto individual (`text`) para o idioma informado (`targetLang`) de forma assíncrona, retornando o resultado no callback `cb` e em uma Promise.
- **`pr_lib.translator.translateBatch(strings, targetLang, cb)`**: 
  Executa a tradução em lote de uma lista de strings de forma otimizada paralelamente para minimizar latência.

### Client-Side
- **`pr_lib.translator.translateText(text, targetLang)` / `pr_lib.translator.translate(...)`**: 
  Traduz um texto de forma síncrona aguardando o retorno do servidor.
- **`pr_lib.translator.translateBatch(strings, targetLang)`**: 
  Envia requisições de tradução em lote de forma síncrona.
- **`pr_lib.translator.translateMenu(menuData, targetLang)`**: 
  Varre e traduz automaticamente todas as propriedades de título, descrição e opções de um objeto de menu (compatível com a estrutura de ox_lib menus) de forma dinâmica para a localidade do jogador antes de sua renderização.
- **`pr_lib.translator.showTranslatedNotify(title, description, notifyType, targetLang)`**: 
  Traduz e exibe imediatamente um alerta de notificação com título e descrição localizados.

---

## Utilitários, Matemática e Arrays (`pr_lib.utils`, `pr_lib.math`, `pr_lib.table`, `pr_lib.ids`)

### Utilitários Gerais (`pr_lib.utils` - Shared)
- **`pr_lib.utils.trim(value)`**: 
  Remove espaços em branco do início e do fim de uma string.
- **`pr_lib.utils.firstToUpper(value)`**: 
  Converte a primeira letra da string em maiúscula.
- **`pr_lib.utils.round(value, decimals)`**: 
  Arredonda um número de ponto flutuante para a quantidade de casas decimais informada.
- **`pr_lib.utils.deepCopy(value, seen)`**: 
  Clona profundamente uma tabela Lua recursivamente, incluindo metatabelas e evitando referências circulares.
- **`pr_lib.utils.dumpTable(value, depth, seen)`**: 
  Serializa uma tabela complexa em formato legível de texto para console (dump de depuração).
- **`pr_lib.utils.ensureTable(value)`**: 
  Garante que o retorno seja sempre uma tabela Lua (caso seja nulo ou string, encapsula/converte).
- **`pr_lib.utils.hash(value)`**: 
  Converte uma string em um hash numérico nativo do GTA V (equivalente ao hash do Jenkins One-at-a-time).

### Funções Matemáticas Avançadas (`pr_lib.math` - Shared)
- **`pr_lib.math.round(...)` / `pr_lib.math.Round(...)`**: 
  Arredonda números de ponto flutuante.
- **`pr_lib.math.clamp(value, minimum, maximum)` / `pr_lib.math.Clamp(...)`**: 
  Limita um número dentro do intervalo especificado entre `minimum` e `maximum`.
- **`pr_lib.math.toHex(value, upper)` / `pr_lib.math.ToHex(...)`**: 
  Converte um número inteiro para uma string hexadecimal.
- **`pr_lib.math.hexToRGB(value)` / `pr_lib.math.HexToRGB(...)` / `pr_lib.math.hexToRGBA(...)`**: 
  Converte cores de string hexadecimal (ex: `"#FF5500"`) em vetores de cores RGB ou RGBA com canais individuais.
- **`pr_lib.math.parse(value, minimum, maximum, shouldRound)` / `pr_lib.math.ParseNumber(...)`**: 
  Processa e valida a consistência de um número dentro de restrições.
- **`pr_lib.math.toScalars(value, minimum, maximum, shouldRound)` / `pr_lib.math.toVector(...)`**: 
  Processa tabelas ou tipos vetoriais normais do FiveM aplicando constraints matemáticas de limites.
- **`pr_lib.math.normalToRotation(input)` / `pr_lib.math.NormalToRotation(...)`**: 
  Converte um vetor normal de superfície em um vetor tridimensional de rotação (Pitch, Roll, Yaw).
- **`pr_lib.math.lerp(startValue, finishValue, factor)` / `pr_lib.math.Lerp(...)`**: 
  Executa uma interpolação linear simples entre dois valores baseada no fator decimal.
- **`pr_lib.math.inverseLerp(startValue, finishValue, value)` / `pr_lib.math.InverseLerp(...)`**: 
  Retorna o fator decimal linear correspondente ao valor dentro do intervalo.
- **`pr_lib.math.map(value, inMin, inMax, outMin, outMax)` / `pr_lib.math.Map(...)`**: 
  Mapeia de forma linear um valor de um intervalo de entrada para outro de saída.
- **`pr_lib.math.degToRad(value)` / `pr_lib.math.Deg2Rad(...)` / `pr_lib.math.radToDeg(...)` / `pr_lib.math.Rad2Deg(...)`**: 
  Conversores de ângulos trigonométricos entre graus e radianos.
- **`pr_lib.math.sign(value)` / `pr_lib.math.Sign(...)`**: 
  Retorna `-1` se o número for negativo, `1` se for positivo e `0` se for nulo.
- **`pr_lib.math.almostEqual(a, b, epsilon)` / `pr_lib.math.AlmostEqual(...)`**: 
  Compara números de ponto flutuante considerando tolerâncias de arredondamento.
- **`pr_lib.math.length2(x, y)` / `pr_lib.math.Length2(...)` / `pr_lib.math.length3(...)` / `pr_lib.math.Length3(...)`**: 
  Calcula a magnitude geométrica/comprimento de vetores de duas ou três dimensões.
- **`pr_lib.math.distance2D(x1, y1, x2, y2)` / `pr_lib.math.Distance2D(...)` / `pr_lib.math.distance3D(...)` / `pr_lib.math.Distance3D(...)`**: 
  Retorna a distância euclidiana geométrica absoluta entre dois pontos no espaço.

### Manipulação de Tabelas e Vetores (`pr_lib.table` - Shared)
- **`pr_lib.table.contains(source, value)` / `pr_lib.table.Contains(...)`**: 
  Verifica se a tabela possui determinado valor entre seus elementos indexados.
- **`pr_lib.table.matches(left, right)` / `pr_lib.table.Matches(...)`**: 
  Compara recursivamente se duas tabelas possuem conteúdo exatamente idêntico.
- **`pr_lib.table.merge(target, source, override)` / `pr_lib.table.Merge(...)`**: 
  Combina elementos de uma tabela de origem em uma tabela de destino.
- **`pr_lib.table.clone(value, seen)` / `pr_lib.table.DeepClone(...)`**: 
  Gera uma cópia profunda (deep copy) de tabelas e metatabelas.
- **`pr_lib.table.shuffle(source, copy, random)` / `pr_lib.table.Shuffle(...)`**: 
  Embaralha aleatoriamente a ordem dos elementos numéricos indexados da tabela.
- **`pr_lib.table.map(source, callback)` / `pr_lib.table.Map(...)`**: 
  Executa a projeção e mapeamento de chaves e valores a partir da execução do `callback`.
- **`pr_lib.table.count(source)` / `pr_lib.table.Count(...)`**: 
  Conta o número absoluto de elementos em uma tabela (incluindo chaves associativas não numéricas).

### IDs Únicas (`pr_lib.ids` - Shared)
- **`pr_lib.ids.createUniqueId(registry, length, pattern)` / `pr_lib.ids.CreateUniqueId(...)`**: 
  Gera uma string aleatória baseada no padrão (`pattern` ex: `"ALPHANUMERIC"`) com o comprimento fornecido, garantindo sua exclusividade comparando com uma tabela de registros existentes (`registry`).

---

## APIs de Desenvolvimento e FiveM Nativo (`fivem`, `devtools`, `raycast`, `ui`, `dui`, `streaming`, `objects`, `vehicleCache`)

### Raycasting (`pr_lib.raycast` - Client)
- **`pr_lib.raycast.fromCamera(distance, flags, ignoreFlags, ignoreEntity)` / `pr_lib.raycast.FromCamera(...)`**: 
  Projeta um feixe de raycast tridimensional invisível a partir da câmera do jogador na direção de foco da mira até a distância máxima informada. Retorna se atingiu algo, as coordenadas de impacto, o vetor normal e a ID da entidade atingida (veículo, ped ou objeto).
- **`pr_lib.raycast.fromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)` / `pr_lib.raycast.FromCoords(...)`**: 
  Dispara um feixe de raycast a partir de coordenadas absolutas de origem (`origin`) para um destino (`destination`).

### UI Nativa do GTA (`pr_lib.ui` - Client)
- **`pr_lib.ui.draw2DText(text, x, y, scale, textColor, font)` / `pr_lib.ui.Draw2DText(...)`**: 
  Desenha na tela do jogador textos em coordenadas bidimensionais de proporção decimal (de `0.0` a `1.0`).
- **`pr_lib.ui.draw3DText(text, coords, scale, textColor, font)` / `pr_lib.ui.Draw3DText(...)`**: 
  Desenha textos flutuantes projetados no mundo físico tridimensional em coordenadas GPS.
- **`pr_lib.ui.drawRect(x, y, width, height, rectColor)` / `pr_lib.ui.DrawRect(...)`**: 
  Desenha retângulos bidimensionais coloridos na HUD da tela do jogador local.

### DUI (Browser em Texturas do GTA) (`pr_lib.dui` - Client/Server)

Permite carregar páginas web interativas projetadas em superfícies do mundo 3D (ex: outdoors, telas de TV de propriedades).

#### Server-Side
- **`pr_lib.dui.create(target, options)`**: 
  Comanda sincronizadamente que clientes em `target` carreguem uma nova instância do navegador DUI.
- **`pr_lib.dui.destroy(target, id)` / `pr_lib.dui.remove(target, id)`**: 
  Fecha e apaga a instância DUI.
- **`pr_lib.dui.get(id)` / `pr_lib.dui.list()`**: 
  Consultas de status e instâncias de DUIs server-side.
- **`pr_lib.dui.sync(target)`**: 
  Sincroniza DUIs ativas com novos jogadores conectados que entraram no escopo.
- **`pr_lib.dui.clear(target)`**: 
  Força limpeza de texturas.
- **`pr_lib.dui.send(target, id, message)` / `pr_lib.dui.sendMessage(...)`**: 
  Envia mensagens estruturadas (postMessage) para o javascript rodando no navegador da DUI especificada.
- **`pr_lib.dui.setUrl(target, id, url)`**: 
  Redireciona o navegador DUI para outro endereço web.
- **`pr_lib.dui.setOpacity(target, id, opacity)` / `pr_lib.dui.setBrightness(...)`**: 
  Controla opacidade e brilho de renderização da textura.
- **`pr_lib.dui.createSprite(...)` / `pr_lib.dui.startSprite(...)` / `pr_lib.dui.stopSprite(...)`**: 
  Desenha texturas DUI em elementos gráficos 2D.
- **`pr_lib.dui.createPoly(...)` / `pr_lib.dui.poly(...)` / `pr_lib.dui.createPoly4(...)` / `pr_lib.dui.poly4(...)` / `pr_lib.dui.stopPoly(...)`**: 
  Renderiza o navegador web em polígonos tridimensionais posicionados no espaço.
- **`pr_lib.dui.createRenderTarget(...)` / `pr_lib.dui.renderTarget(...)` / `pr_lib.dui.stopRenderTarget(...)`**: 
  Associa a DUI a um render target de textura nativo do GTA (ex: telas internas originais de cinemas ou monitores).
- **`pr_lib.dui.createReplaceTexture(...)` / `pr_lib.dui.replaceTexture(...)`**: 
  Substitui texturas físicas de modelos 3D originais do GTA pelo navegador web.

#### Client-Side
- **`pr_lib.dui.create(options, width, height)`**: 
  Instancia o objeto DUI nativo com as dimensões de tela fornecidas.
- **`pr_lib.dui.destroy(target)`** / **`pr_lib.dui.get(id)`** / **`pr_lib.dui.list()`** / **`pr_lib.dui.send(...)`** / **`pr_lib.dui.sendMessage(...)`** / **`pr_lib.dui.setUrl(...)`** / **`pr_lib.dui.setOpacity(...)`** / **`pr_lib.dui.setBrightness(...)`**: 
  Gerenciadores diretos locais de navegador.
- **`pr_lib.dui.nuiUrl(path, ownerResource)` / `pr_lib.dui.url(...)`**: 
  Gera endereços locais válidos apontando para páginas HTML e assets de recursos NUI.
- **`pr_lib.dui.focus(target, options)` / `pr_lib.dui.unfocus()`**: 
  Foca o controle de teclado e mouse do jogador para interagir diretamente com o navegador.
- **`pr_lib.dui.enableMouse(target, options)` / `pr_lib.dui.disableMouse(...)` / `pr_lib.dui.toggleMouse(...)`**: 
  Exibe e controla ponteiros de mouses interativos em cima do navegador web.
- **`pr_lib.dui.sendMouseDown(target, button)` / `pr_lib.dui.sendMouseUp(...)` / `pr_lib.dui.sendMouseMove(...)` / `pr_lib.dui.sendMouseWheel(...)`**: 
  Simula eventos de clique, movimento e rolagem no navegador DUI baseado em entradas físicas do jogador.
- **`pr_lib.dui.createSprite(options)` / `pr_lib.dui.drawSprite(...)` / `pr_lib.dui.startSprite(...)` / `pr_lib.dui.stopSprite(...)` / `pr_lib.dui.createPoly(...)` / `pr_lib.dui.poly(...)` / `pr_lib.dui.startPoly(...)` / `pr_lib.dui.stopPoly(...)` / `pr_lib.dui.createRenderTarget(...)` / `pr_lib.dui.renderTarget(...)` / `pr_lib.dui.stopRenderTarget(...)` / `pr_lib.dui.createReplaceTexture(...)` / `pr_lib.dui.replaceTexture(...)` / `pr_lib.dui.removeReplaceTexture(...)` / `pr_lib.dui.createReplacement(...)`**: 
  APIs locais de projeção e substituição de texturas físicas tridimensionais no mundo 3D por renderizadores DUI.

### Tuning de Veículos (`pr_lib.fivem.tuning` - Client/Server)

#### Server-Side
- **`pr_lib.fivem.tuning.apply(vehicle, props, options)`**: 
  Aplica modificações físicas, cores e upgrades no veículo.
- **`pr_lib.fivem.tuning.applyNetId(netId, props, target, options)`**: 
  Envia comando para que clientes apliquem propriedades em um veículo baseado na sua ID de rede.
- **`pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`**: 
  Restaura o estado do veículo a partir de um snapshot salvo.
- **`pr_lib.fivem.tuning.snapshot()`**: 
  Retorna tabela vazia para stubs do servidor.

#### Client-Side
- **`pr_lib.fivem.tuning.apply(vehicle, props, options)`** / **`pr_lib.fivem.tuning.applyNetId(...)`** / **`pr_lib.fivem.tuning.restore(...)`**: 
  Aplicações e restaurações de propriedades físicas e cosméticas em veículos.
- **`pr_lib.fivem.tuning.get(vehicle)`**: 
  Retorna uma tabela contendo todas as propriedades de customizações, modificações mecânicas, cores e níveis de integridade do veículo correspondente.
- **`pr_lib.fivem.tuning.repair(vehicle)`**: 
  Conserta visualmente e mecanicamente o motor, carroceria e pneus do veículo.
- **`pr_lib.fivem.tuning.snapshot(vehicle)`**: 
  Salva e retorna uma cópia de segurança rápida do estado atual do veículo para futuras restaurações.
- **`pr_lib.fivem.tuning.setExtra(vehicle, extraId, state)`**: 
  Ativa ou remove extras e acessórios nativos de carroceria instalados no veículo.
- **`pr_lib.fivem.tuning.setFuel(vehicle, fuelLevel)`**: 
  Altera diretamente o nível físico de combustível do motor do veículo.
- **`pr_lib.fivem.tuning.setMod(vehicle, modType, modIndex, customTires)`**: 
  Altera peças de modificação mecânica (como Motor, Transmissão, Suspensão) ou visual (aerofólios, capôs).
- **`pr_lib.fivem.tuning.setNeon(vehicle, enabled, color)`**: 
  Configura luzes de neons instaladas embaixo do chassi do veículo.
- **`pr_lib.fivem.tuning.setPlate(vehicle, plate)`**: 
  Modifica a string exibida na placa física do veículo.
- **`pr_lib.fivem.tuning.setXenon(vehicle, enabled, color)`**: 
  Configura faróis de Xenon e tonalidades de cores nos faróis do veículo.
- **`pr_lib.fivem.tuning.toggleMod(vehicle, modType, state)`**: 
  Liga ou desliga modificações de performance específicas (como Turbo).

### Textos 3D e 2D flutuantes (`pr_lib.drawtext` - Client)
- **`pr_lib.drawtext.show(text, position, options)` / `pr_lib.drawtext.DrawText(...)`**: 
  Exibe textos flutuantes formatados.
- **`pr_lib.drawtext.change(text, position, options)` / `pr_lib.drawtext.ChangeText(...)`**: 
  Altera o texto ou propriedades do painel DrawText ativo na tela.
- **`pr_lib.drawtext.hide()` / `pr_lib.drawtext.HideText()`**: 
  Apaga o painel de texto.
- **`pr_lib.drawtext.isOpen()`**: 
  Retorna se há algum painel de DrawText ativo na tela.
- **`pr_lib.drawtext.keyPressed(delay)` / `pr_lib.drawtext.KeyPressed(...)`**: 
  Registra o acionamento de teclas de atalho de interações DrawText com debounce (`delay`).
- **`pr_lib.drawtext.draw2d(params)` / `pr_lib.drawtext.drawText2d(...)` / `pr_lib.drawtext.DrawText2d(...)` / `pr_lib.drawtext.DrawText2D(...)`**: 
  Métodos de desenho 2D.
- **`pr_lib.drawtext.draw3d(params)` / `pr_lib.drawtext.drawText3d(...)` / `pr_lib.drawtext.DrawText3d(...)` / `pr_lib.drawtext.DrawText3D(...)`**: 
  Métodos de desenho de textos tridimensionais.

### Propriedades de Veículos (`pr_lib.vehicleProperties` - Client/Server)

#### Server-Side
- **`pr_lib.vehicleProperties.set(vehicle, props, options)` / `pr_lib.vehicleProperties.SetVehicleProperties(...)`**: 
  Modifica as propriedades físicas gerais de customização de um veículo.
- **`pr_lib.vehicleProperties.setNetId(netId, props, target, options)` / `pr_lib.vehicleProperties.SetNetIdProperties(...)`**: 
  Aplica propriedades sincronizadas via rede utilizando a ID de rede do veículo.

#### Client-Side
- **`pr_lib.vehicleProperties.get(vehicle)` / `pr_lib.vehicleProperties.GetVehicleProperties(...)`**: 
  Obtém a tabela completa contendo as propriedades estéticas e mecânicas instaladas no veículo (compatível com ESX/QBCore).
- **`pr_lib.vehicleProperties.set(vehicle, props, fixVehicle)` / `pr_lib.vehicleProperties.SetVehicleProperties(...)`**: 
  Aplica no veículo local o conjunto de propriedades fornecidas.

### Streaming e Carregamento de Assets (`pr_lib.fivem.streaming` - Client/Server)

#### Server-Side
- **`pr_lib.fivem.streaming.hash(model)`**: 
  Retorna o hash numérico de um modelo 3D.

#### Client-Side
- **`pr_lib.fivem.streaming.requestModel(model, timeout)` / `pr_lib.fivem.streaming.RequestModel(...)` / `pr_lib.fivem.streaming.releaseModel(...)`**: 
  Carrega e retém na memória de vídeo do jogo o modelo 3D informado (`model`), liberando-o da memória após o uso.
- **`pr_lib.fivem.streaming.requestAnimDict(animDict, timeout)` / `pr_lib.fivem.streaming.RequestAnimDict(...)` / `pr_lib.fivem.streaming.loadAnimDict(...)` / `pr_lib.fivem.streaming.releaseAnimDict(...)`**: 
  Carrega dicionários contendo arquivos de animações esqueléticas para peds.
- **`pr_lib.fivem.streaming.requestAnimSet(animSet, timeout)` / `pr_lib.fivem.streaming.RequestAnimSet(...)` / `pr_lib.fivem.streaming.releaseAnimSet(...)`**: 
  Carrega arquivos de sets de animações de postura/caminhar (walkstyles).
- **`pr_lib.fivem.streaming.requestAudioBank(audioBank, timeout)` / `pr_lib.fivem.streaming.RequestAudioBank(...)` / `pr_lib.fivem.streaming.releaseAudioBank(...)`**: 
  Carrega pacotes de efeitos sonoros e áudios nativos.
- **`pr_lib.fivem.streaming.requestPtfxAsset(asset, timeout)` / `pr_lib.fivem.streaming.RequestNamedPtfxAsset(...)` / `pr_lib.fivem.streaming.releasePtfxAsset(...)`**: 
  Carrega bibliotecas de efeitos de partículas (Ptfx, ex: fumaças, faíscas).
- **`pr_lib.fivem.streaming.requestScaleformMovie(name, timeout)` / `pr_lib.fivem.streaming.RequestScaleformMovie(...)` / `pr_lib.fivem.streaming.releaseScaleformMovie(...)`**: 
  Carrega arquivos Scaleforms Flash nativos do GTA V (ex: botões instrucionais, mini-games, telas de computadores).
- **`pr_lib.fivem.streaming.requestTextureDict(textureDict, timeout)` / `pr_lib.fivem.streaming.RequestStreamedTextureDict(...)` / `pr_lib.fivem.streaming.releaseTextureDict(...)`**: 
  Carrega dicionários contendo texturas e imagens nativas.
- **`pr_lib.fivem.streaming.requestWeaponAsset(model, timeout)` / `pr_lib.fivem.streaming.loadWeaponAsset(...)` / `pr_lib.fivem.streaming.releaseWeaponAsset(...)`**: 
  Carrega modelos de armas de fogo nativas e suas propriedades.
- **`pr_lib.fivem.streaming.getModelDimensions(model, timeout)`**: 
  Retorna as dimensões de bounding box (mínimo e máximo) do modelo especificado.
- **`pr_lib.fivem.streaming.getModelGroundOffset(model, timeout)`**: 
  Calcula a compensação de altura vertical necessária para posicionar o objeto rente ao chão.
- **`pr_lib.fivem.streaming.findGroundZ(coords, options)`**: 
  Varre verticalmente o mapa para obter as coordenadas Z precisas do solo abaixo da posição indicada.
- **`pr_lib.fivem.streaming.createEntity(placementType, model, coords, heading, options)` / `pr_lib.fivem.streaming.createObject(...)` / `pr_lib.fivem.streaming.createPed(...)` / `pr_lib.fivem.streaming.createProp(...)` / `pr_lib.fivem.streaming.createVehicle(...)`**: 
  APIs otimizadas que carregam o modelo correspondente e criam objetos, peds ou veículos locais no cliente.
- **`pr_lib.fivem.streaming.configureEntity(entity, options)`**: 
  Aplica opções de físicas, colisões, congelamento e persistência na entidade.
- **`pr_lib.fivem.streaming.placeEntityProperly(entity, placementType, options)`**: 
  Ajusta a altura e rotação de uma entidade para que ela fique alinhada corretamente com a superfície do solo.
- **`pr_lib.fivem.streaming.setEntityTransform(entity, coords, heading, options)`**: 
  Atualiza a posição e o ângulo horizontal de uma entidade de forma sincronizada.
- **`pr_lib.fivem.streaming.delete(entity)` / `pr_lib.fivem.streaming.deleteEntity(entity)`**: 
  Apaga uma entidade (ped, veículo ou objeto) local liberando memória.
- **`pr_lib.fivem.streaming.playAnim(...)` / `pr_lib.fivem.streaming.PlayAnim(...)` / `pr_lib.fivem.streaming.playAnimation(...)` / `pr_lib.fivem.streaming.PlayAnimation(...)`**: 
  Força uma entidade ped (geralmente o jogador local) a reproduzir uma animação esquelética de forma simplificada, carregando o dicionário de animação previamente.
- **`pr_lib.fivem.streaming.playAction(data)` / `pr_lib.fivem.streaming.PlayAction(...)` / `pr_lib.fivem.streaming.performAction(...)` / `pr_lib.fivem.streaming.PerformAction(...)` / `pr_lib.fivem.streaming.playInteraction(...)` / `pr_lib.fivem.streaming.PlayInteraction(...)`**: 
  APIs utilitárias para acionar ações cinemáticas combinadas.

### Manipulação de Objetos e Pools (`pr_lib.fivem.objects` - Client/Server)

#### Server-Side
- **`pr_lib.fivem.objects.getPool(poolName)` / `pr_lib.fivem.objects.getPoolName(...)`**: 
  Retorna entidades registradas no pool interno do FiveM.
- **`pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)` / `pr_lib.fivem.objects.getByPoolInRadius(...)` / `pr_lib.fivem.objects.getPoolByModelInRadius(...)` / `pr_lib.fivem.objects.getObjectsByPool(...)` / `pr_lib.fivem.objects.getClosestFromPool(...)`**: 
  Consultas remotas de localização de entidades cadastradas nos pools do motor do jogo (ex: `"CPed"`, `"CVehicle"`, `"CObject"`).
- **`pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)` / `pr_lib.fivem.objects.getByModelInRadius(...)`**: 
  Busca entidades filtradas por modelo específico e proximidade geográfica.
- **`pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)` / `pr_lib.fivem.objects.getObjectsInRadiusUsingPool(...)` / `pr_lib.fivem.objects.getNetworkedObjectsInRadius(...)` / `pr_lib.fivem.objects.getClosestObject(...)` / `pr_lib.fivem.objects.findObjectsInRadius(...)` / `pr_lib.fivem.objects.findObjectsInRadiusUsingPool(...)`**: 
  Resgata e lista todos os objetos físicos gerados dentro do raio informado.
- **`pr_lib.fivem.objects.getPedsInRadius(...)` / `pr_lib.fivem.objects.getPedsByModelInRadius(...)`**: 
  Resgata peds (NPCs) próximos.
- **`pr_lib.fivem.objects.getPickupsInRadius(...)`**: 
  Localiza pickups físicas de armas e colecionáveis do mundo GTA.
- **`pr_lib.fivem.objects.getVehiclesInRadius(...)` / `pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(...)` / `pr_lib.fivem.objects.getVehiclesByModelInRadius(...)` / `pr_lib.fivem.objects.getClosestVehicle(...)` / `pr_lib.fivem.objects.getClosestVehicleByModel(...)` / `pr_lib.fivem.objects.findVehiclesInRadius(...)` / `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(...)`**: 
  Utilitários avançados de pesquisa de veículos gerados no mapa do servidor.
- **`pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`**: 
  Congela ou descongela a física de todas as entidades de determinado modelo 3D que estão dentro daquele raio.

#### Client-Side
- **`pr_lib.fivem.objects.getPool(poolName)`** / **`pr_lib.fivem.objects.getPoolName(poolName)`** / **`pr_lib.fivem.objects.getPoolInRadius(...)`** / **`pr_lib.fivem.objects.getByPoolInRadius(...)`** / **`pr_lib.fivem.objects.getPoolByModelInRadius(...)`** / **`pr_lib.fivem.objects.getObjectsByPool(...)`** / **`pr_lib.fivem.objects.getClosestFromPool(...)`** / **`pr_lib.fivem.objects.getClosestByModel(...)`** / **`pr_lib.fivem.objects.getByModelInRadius(...)`** / **`pr_lib.fivem.objects.getObjectsInRadius(...)`** / **`pr_lib.fivem.objects.getObjectsInRadiusUsingPool(...)`** / **`pr_lib.fivem.objects.getNetworkedObjectsInRadius(...)`** / **`pr_lib.fivem.objects.getClosestObject(...)`** / **`pr_lib.fivem.objects.findObjectsInRadius(...)`** / **`pr_lib.fivem.objects.findObjectsInRadiusUsingPool(...)`** / **`pr_lib.fivem.objects.getPedsInRadius(...)`** / **`pr_lib.fivem.objects.getPedsByModelInRadius(...)`** / **`pr_lib.fivem.objects.getPickupsInRadius(...)`** / **`pr_lib.fivem.objects.getVehiclesInRadius(...)`** / **`pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(...)`** / **`pr_lib.fivem.objects.getVehiclesByModelInRadius(...)`** / **`pr_lib.fivem.objects.getClosestVehicle(...)`** / **`pr_lib.fivem.objects.getClosestVehicleByModel(...)`** / **`pr_lib.fivem.objects.findVehiclesInRadius(...)`** / **`pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(...)`** / **`pr_lib.fivem.objects.freezeByModelInRadius(...)`**: 
  Os mesmos utilitários do lado do servidor, porém otimizados para usar os loops de entidades nativas locais do cliente de forma extremamente rápida.

### Cache e Estado de Veículos (`pr_lib.fivem.vehicleCache` - Shared)
- **`pr_lib.fivem.vehicleCache.get(vehicleOrNetId)`**: 
  Retorna as informações em cache registradas para a ID da entidade do veículo ou ID de rede.
- **`pr_lib.fivem.vehicleCache.set(vehicleOrNetId, data)`**: 
  Salva dados customizados no cache persistente do veículo.
- **`pr_lib.fivem.vehicleCache.clear(vehicleOrNetId)`**: 
  Apaga o cache do veículo.
- **`pr_lib.fivem.vehicleCache.clearAll()`**: 
  Limpa todo o cache de veículos na memória RAM do recurso.
- **`pr_lib.fivem.vehicleCache.getByPlate(plate)`**: 
  Recupera dados do veículo pesquisando pela sua placa de identificação.
- **`pr_lib.fivem.vehicleCache.getState(vehicle, name)`**: 
  Consulta uma propriedade do State Bag (estado persistido de rede do FiveM) registrado no veículo.
- **`pr_lib.fivem.vehicleCache.setState(vehicle, name, value, replicated)`**: 
  Altera uma propriedade no State Bag do veículo, controlando se ela deve ser replicada para outros clientes.
- **`pr_lib.fivem.vehicleCache.getStateKey(name)`**: 
  Gera a string do caminho da chave de estado.
- **`pr_lib.fivem.vehicleCache.getPersistentMeta(vehicle)` / `pr_lib.fivem.vehicleCache.setPersistentMeta(...)`**: 
  Obtém ou grava metadados persistentes que sobrevivem ao respawn do veículo.

### Sprites, Cores e Blips (`pr_lib.fivem.blips` - Shared)
- **`pr_lib.fivem.blips.getSprite(value)`**: 
  Retorna as informações do Blip (ícone do mapa) pelo seu ID numérico ou nome amigável registrado.
- **`pr_lib.fivem.blips.getSpriteName(value)` / `pr_lib.fivem.blips.getSpriteId(value)`**: 
  Converte e recupera nomes ou IDs numéricos equivalentes de sprites de blips do radar.
- **`pr_lib.fivem.blips.getColorInfo(colorId)`**: 
  Retorna as propriedades de cor do blip do radar (nome e hexadecimal de cor) a partir de seu ID numérico original.
- **`pr_lib.fivem.blips.listSprites()` / `pr_lib.fivem.blips.listColors()`**: 
  Retorna a lista completa indexada de sprites e cores originais suportados nativamente pelo FiveM.
- **`pr_lib.fivem.blips.setDocsBaseUrl(url)`**: 
  Permite atualizar o caminho do servidor de documentação base do FiveM de onde as imagens de assets são baixadas.
- **`pr_lib.fivem.blips.getBlipImageUrl(value)` / `pr_lib.fivem.blips.getImageUrl(...)`**: 
  Gera uma URL externa direta contendo a imagem `.png` do blip correspondente.
- **`pr_lib.fivem.blips.getPedImageUrl(model)`**: 
  Retorna a URL contendo a imagem de demonstração do modelo do ped.
- **`pr_lib.fivem.blips.getVehicleImageUrl(model)`**: 
  Retorna a URL contendo a imagem do veículo.
- **`pr_lib.fivem.blips.getCheckpointImageUrl(checkpointId)` / `pr_lib.fivem.blips.getMarkerImageUrl(...)`**: 
  Retornam URLs contendo imagens demonstrativas de checkponts e marcadores 3D.
- **`pr_lib.fivem.blips.getWeaponImageUrl(model)`**: 
  Retorna a URL contendo a imagem da arma de fogo.
- **`pr_lib.fivem.blips.setRagePropsBaseUrl(url)`**: 
  Ajusta a URL base usada para imagens de props da Rage MP. Padrao: `https://cdn.rage.mp/public/odb/imgs`.
- **`pr_lib.fivem.blips.getPropHashId(model)`**: 
  Calcula o hash/ID unsigned do modelo com `GetHashKey`/`joaat`, usado no nome dos arquivos de props da Rage MP.
- **`pr_lib.fivem.blips.getPropImageUrl(model)` / `pr_lib.fivem.blips.getObjectImageUrl(model)`**: 
  Monta a URL de preview de props no padrao `[prop_name]-[hash].jpg`, por exemplo `prop_streetlight_08-1847069612.jpg`.
- **`pr_lib.fivem.blips.getAssetImageUrl(kind, value)`**: 
  Gerador de URL generico para imagens de assets, incluindo `prop` e `object`.
- **`pr_lib.fivem.blips.describe(value, colorId)`**: 
  Retorna um dicionário contendo ID, nome do sprite, link da imagem correspondente e dados da cor formatados.

### Identificadores de Jogadores (`pr_lib.fivem.identifiers` - Server)
- **`pr_lib.fivem.identifiers.getByType(source, identifierType)` / `pr_lib.fivem.identifiers.GetByType(...)`**: 
  Retorna o identificador específico de conexão de rede de um jogador chamando a API nativa (ex: `identifierType` pode ser `"license"`, `"discord"`, `"steam"`, `"ip"`).
- **`pr_lib.fivem.identifiers.getAll(source)` / `pr_lib.fivem.identifiers.GetAll(...)`**: 
  Varre e retorna uma tabela contendo todos os identificadores conhecidos do jogador logado (`discord`, `license`, `license2`, `steam`, `fivem`, `ip`, etc.) e determina qual licença deve ser tratada como principal (`primaryLicense`).
- **`pr_lib.fivem.identifiers.getPrimaryLicense(source)` / `pr_lib.fivem.identifiers.GetPrimaryLicense(...)`**: 
  Retorna a licença Rockstar de prioridade primária do jogador local (`license2` ou `license`).
- **`pr_lib.fivem.identifiers.getLicenseSet(source, extraLicenses)` / `pr_lib.fivem.identifiers.GetLicenseSet(...)`**: 
  Gera uma tabela contendo as licenças normais de identificação do jogador, permitindo mesclar chaves adicionais informadas.
- **`pr_lib.fivem.identifiers.has(source, identifier)` / `pr_lib.fivem.identifiers.Has(...)`**: 
  Verifica se o jogador especificado possui o identificador exato informado.

### Botões Instrucionais (`pr_lib.fivem.instructionalButtons` - Client)
- **`pr_lib.fivem.instructionalButtons.create(buttons, options)`**: 
  Inicializa e carrega a scaleform `INSTRUCTIONAL_BUTTONS` na memória, desenhando de forma customizada e retornando um manipulador de instância. A tabela `buttons` descreve o texto (`label`) e a tecla/controle correspondente (ex: `"~INPUT_FRONTEND_ACCEPT~"`).
- **`pr_lib.fivem.instructionalButtons.show(buttons, options)`**: 
  Cria e exibe dinamicamente o painel de botões na tela por um tempo limitado ou até que o jogador pressione uma tecla. Retorna se o usuário interagiu com algum botão.
- **`pr_lib.fivem.instructionalButtons.showSimple(label, control, options)`**: 
  Exibe de forma rápida e simplificada um único botão informativo no canto da tela (ex: *"Confirmar"* associado ao botão enter).
- **`pr_lib.fivem.instructionalButtons.showClickable(label, control, controlId, options)`**: 
  Cria botões que suportam interação física direta por cliques do mouse do jogador local.

### Ferramentas de Desenvolvimento (`pr_lib.devtools` - Client)
- **`pr_lib.devtools.createPlacement(placementType, modelName, maxSlots, cb, options)` / `pr_lib.devtools.startEntityPlacement(...)` / `pr_lib.devtools.StartEntityPlacement(...)`**: 
  Inicializa o modo de posicionamento visual tridimensional de objetos, peds ou veículos na tela do jogador. Permite rotacionar e movimentar o objeto usando o teclado ou gizmos de translação tridimensionais, acionando o callback `cb` ao confirmar.
- **`pr_lib.devtools.placeObject(modelName, maxSlots, cb, options)` / `pr_lib.devtools.placePed(...)` / `pr_lib.devtools.placeVehicle(...)`**: 
  Inicia modos de colocação específicos para objetos, peds e veículos.
- **`pr_lib.devtools.createPolyzone(options, cb)` / `pr_lib.devtools.drawPolyzone3D(...)` / `pr_lib.devtools.DrawPolyzone3D(...)`**: 
  Ferramentas gráficas locais que desenham polígonos no espaço para demarcação física de zonas de desenvolvimento.
- **`pr_lib.devtools.createSphereZone(options, cb)` / `pr_lib.devtools.drawSphereZone(...)` / `pr_lib.devtools.drawSphereZone3D(...)` / `pr_lib.devtools.DrawSphereZone3D(...)`**: 
  Cria e renderiza esferas tridimensionais físicas na HUD para demarcação gráfica.
- **`pr_lib.devtools.drawModelBoxAtCoords(options)` / `pr_lib.devtools.drawPedBox(coords, heading, model, options)`**: 
  Desenha o wireframe/drawbox de um modelo em coordenadas informadas. Deve ser chamado por frame enquanto o debug ou preview estiver ativo.
- **`pr_lib.devtools.stop()`**: 
  Encerra imediatamente qualquer modo de criação ou posicionamento de entidades ou zonas em andamento.

---

## Aliases de Conveniência e Mapeamento Global

Mapeamentos de links de escopos redundantes e atalhos rápidos adicionados no topo do escopo global da `pr_lib` para facilitar a digitação ou integração com recursos legados.

### Principais Aliases Globais (`shared`):
- **`pr_lib.db`** / **`pr_lib.sql`**: Referências diretas e equivalentes para o módulo de banco de dados (`pr_lib.database`).
- **`pr_lib.inventories`**: Aponta para a ponte de inventário (`pr_lib.inventory`).
- **`pr_lib.notifications`** / **`pr_lib.notification`**: Apontam para o módulo de notificações (`pr_lib.notify`).
- **`pr_lib.menu`**: Aponta para o módulo de menus contextuais (`pr_lib.menus`).
- **`pr_lib.targets`**: Aponta para o módulo de alvos físicos (`pr_lib.target`).
- **`pr_lib.phones`**: Aponta para o módulo de celular (`pr_lib.phone`).
- **`pr_lib.progressbar`**: Aponta para a barra de progresso linear (`pr_lib.progress`).
- **`pr_lib.textUIAdapter`** / **`pr_lib.textuiBridge`** / **`pr_lib.textUIBridge`**: Apontam para a TextUI adaptada (`pr_lib.textuiAdapter`).
- **`pr_lib.bank`**: Aponta para o módulo financeiro de banco (`pr_lib.banking`).
- **`pr_lib.vehicleKey`** / **`pr_lib.vehicleKeys`**: Apontam para o chaveiro do veículo (`pr_lib.vehicle_key`).
- **`pr_lib.drawtext`** / **`pr_lib.drawText`** / **`pr_lib.textui`** / **`pr_lib.textUI`**: Atalhos locais no cliente que apontam diretamente para o módulo de escrita de textos flutuantes (`pr_lib.fivem.drawtext`).
- **`pr_lib.dui`** / **`pr_lib.duis`**: Apontam para a DUI do FiveM (`pr_lib.fivem.dui`).
- **`pr_lib.raycast`**: Aponta para o raycasting do cliente (`pr_lib.fivem.raycast`).
- **`pr_lib.ui`**: Aponta para a UI nativa (`pr_lib.fivem.ui`).
- **`pr_lib.ace`** / **`pr_lib.permissions`**: Apontam para o gerenciador de regras ACE (`pr_lib.fivem.ace`).
- **`pr_lib.identifiers`** / **`pr_lib.identifier`**: Apontam para a catalogação de identificadores (`pr_lib.fivem.identifiers`).
- **`pr_lib.addKeybind`** / **`pr_lib.keybind`** / **`pr_lib.keybinds`**: Apontam para o mapeador de teclas do FiveM (`pr_lib.fivem.addKeybind`).
- **`pr_lib.addCommand`** / **`pr_lib.command`** / **`pr_lib.commands`**: Apontam para o gerenciador de comandos (`pr_lib.fivem.addCommand`).
- **`pr_lib.editorCamera`**: Aponta para a câmera orbital utilitária (`pr_lib.fivem.editorCamera`).
- **`pr_lib.gizmo`**: Aponta para o gizmo de rotação e translação (`pr_lib.fivem.gizmo`).
- **`pr_lib.devlaser`** / **`pr_lib.devLaser`**: Apontam para o devlaser local (`pr_lib.fivem.devlaser`).
- **`pr_lib.devtools`** / **`pr_lib.devTools`** / **`pr_lib.developerTools`**: Apontam para as ferramentas de desenvolvimento de zonas e posicionamentos (`pr_lib.fivem.devtools`).
- **`pr_lib.vehicleProperties`**: Aponta para o leitor/gravador de modificações mecânicas do veículo (`pr_lib.fivem.vehicleProperties`).
- **`pr_lib.sqlBackup`**: Aponta diretamente para o gerador de backups SQL (`pr_lib.database.backup`).
