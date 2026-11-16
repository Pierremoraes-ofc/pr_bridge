# Cache passivo e fachada Player/state

O mecanismo de cache do PR Bridge somente recebe publicacoes explicitas, guarda valores em memoria e responde a leituras solicitadas. Se ninguem publicar um dado, ele fica ausente. Nao coleta dados do jogo/framework, nao sonda inventario, nao varre jogadores/entidades, nao busca snapshots ao iniciar e nao envia deltas/notificacoes.

Isso se aplica tambem ao bootstrap de compatibilidade OX e aos registros de configuracoes. As ferramentas independentes da biblioteca (UI, target, animacoes, comandos, adaptadores chamados explicitamente) nao foram removidas nem transformadas em cache.

## Publicacao e leitura

Recursos consumidores importam `@pr_bridge/init.lua` como antes. As duas sintaxes acessam o mesmo campo:

```lua
-- O script responsavel entrega a informacao:
pr_lib.cache.set('player:10:job', 'police')
print(pr_lib.Player(10).state.job) -- police

pr_lib.Player(10).state.job = 'ambulance'
print(pr_lib.cache.get('player:10:job')) -- ambulance

-- A biblioteca nao chama SetJob nem altera a framework por essa atribuicao.
```

Dinheiro, inventario, permissao, saude e demais regras continuam pertencendo aos seus produtores. Gravar um valor informativo no cliente nao autoriza uma transacao no servidor. Nao houve mudanca nas validacoes de transacoes da framework/banco/inventario.

Cliente e servidor sao armazenamentos independentes, sem transporte automatico entre eles nem entre jogadores. Exports locais consultam a memoria do host do mesmo lado, somente quando chamados. Nao transporte os proxies por eventos/exports; transporte IDs e construa `pr_lib.Player(id)` no recurso de destino.

## Namespaces

| Fachada | Chave equivalente |
|---|---|
| `pr_lib.Player(10).state.job` | `player:10:job` |
| `pr_lib.LocalPlayer.state.health` | `player:<serverId publicado>:health` |
| `pr_lib.Entity(handle).state.locked` | `entity:<handle>:locked` |
| `pr_lib.GlobalState.weather` | `global:weather` |
| `pr_lib.Mission('delivery').state.stage` | `mission:delivery:stage` |
| `pr_lib.Property('house_3').state.owner` | `property:house_3:owner` |
| `cache.SetResourceState('weapons', 'selected', data)` | `resource:weapons:selected` |

`Player` recebe o server ID. `Entity` recebe o handle no contexto atual, nao network ID. `GlobalState` nao e o objeto nativo FiveM e nao replica nada.

Para usar `LocalPlayer`, um produtor precisa publicar `serverId` antes:

```lua
-- Quem conhece o ID publica; o cache NAO usa natives para descobri-lo:
pr_lib.cache.set('serverId', 10)
pr_lib.LocalPlayer.state.health = 175
print(pr_lib.cache.get('player:local:health')) -- 175
```

Sem ID publicado, `LocalPlayer.state` falha explicitamente. `Player(10)` nao exige essa publicacao. Nao ha reidratacao automatica no login/restart.

Campos comuns como `ped`, `coords`, `vehicle`, `seat`, `weapon`, `playerId`, `serverId`, `playerLoaded`, `playerData`, `job`, `gang`, `groups`, `cash`, `bank`, `dirtyMoney`, `isDead`, `health`, `armor`, `hunger`, `thirst`, `stress`, `oxygen`, `stamina` e `playerStatus` sao compartilhados localmente quando publicados por `cache.set`. Chaves fora dos namespaces e campos comuns continuam privadas do recurso. Use `cache.set`, nao atribuicao de campos no proprio objeto `cache`.

## Contratos dos produtores

| Responsavel externo | Publica quando mudar | Consumidor le quando precisar |
|---|---|---|
| Framework/sessao | `serverId`, `playerData`, `job`, `gang`, `groups`, estado de sessao | `cache.get(...)` |
| HUD/controlador do jogador | saude/status, coordenadas, veiculo, assento | `cache.get(...)` ou namespace pessoal explicitamente escolhido |
| Banco/inventario | saldos e registros/flags do dominio | `cache.get(...)` / `GetResourceState(...)` |
| Armas | arma selecionada e informacoes que gerencia | `cache.get('weapon')` ou namespace do produtor |

Essa tabela define responsabilidade, nao coleta automatica pela biblioteca. A integracao com produtores QBX/inventario/HUD esta descrita em `QBX_CACHE_PRODUCER.md`. Publicar `health` nao preenche automaticamente `Player(id).state.health`, nem vice-versa: o produtor e os leitores devem combinar qual chave usam.

```lua
-- Publicacao de um dominio, por quem o gerencia:
pr_lib.cache.SetResourceState('ox_inventory', 'player', {
    invBusy = false, invOpen = true, invHotkeys = true, canUseWeapons = true
})
-- Leitura local sob demanda, sem chamar exports do inventario:
local data = pr_lib.cache.GetResourceState('ox_inventory', 'player')
```

`GetResourceState` agora consulta somente dados entregues a este cache; nao chama mais `GetCachedState` de outro recurso. `SetResourceState` e `GetResourceState` copiam tabelas para nao expor uma referencia mutavel ao produtor/leitor. Quem distribui entre cliente/servidor precisa implementar seu proprio contrato autorizado, fora do cache.

## Mudancas de contrato intencionais

- `cache.onChange`, `cache.on`, `pr_lib.onCache`, `state:onChange`, `cache.OnResourceState` e o alias OX `lib.onCache` preservam a assinatura/cancelamento, mas ficam inertes: nenhum callback e executado automaticamente, nem em escritas, remocoes ou parada do host.
- Nao sao emitidos `pr_bridge:cache:update`, `ox_lib:cache:*`, `pr_bridge:resourceState:changed` nem sincronizacoes de configuracao por este mecanismo.
- O arquivo `player_lifecycle.lua` nao retransmite eventos de sessao/inventario da framework. Produtores devem publicar/informar consumidores por seus contratos proprios.
- `cache.GetPlayer` e `cache.GetMetadata` leem somente snapshots publicados. No servidor: `player:<id>` e `metadata:<id>:<campo>`. No cliente: `playerData` / `player:self` e `metadata:self:<campo>`. Nao buscam na framework quando nao encontram.
- `cache.getEntity/getEntities` leem registros explicitamente entregues aos indices, sem consultar natives. `scanWorld()` somente conta registros existentes; `setWorldEnabled(true)` retorna `false` e nao ativa varredura.
- `pr_lib.player.new()` minusculo permanece como fachada de cache. As flags de inventario so usam dados publicados; `set/setr` nao chamam mais `SetPlayerState` do inventario. Para alterar o inventario real, o produtor deve chamar sua API autorizada. Sem publicacao, a flag `invBusy` tem fallback seguro `true`, demais booleans `false` e `instance` zero; isso nao desbloqueia acoes por ausencia de dados.
- O adaptador QBX nao busca `GetPlayerData` na framework durante carregamento/inicio. Quando um consumidor solicita dados, ele pode ler o snapshot que o proprio QBX ja publicou no cache. Consumidores tardios nao precisam aguardar outro evento nem provocar uma coleta na framework.
- `settings.publish` apenas armazena configuracoes no host servidor e devolve o registro. `settings.get/snapshot` respondem a uma solicitacao; `settings.receive` permite entregar explicitamente um registro ao host local, com validacao de formato/revisao. O cache nao faz bootstrap, retry ou sincronizacao servidor/cliente. Para a interface visual, o produtor Forge Core solicita o registro inicial e entrega mudancas confirmadas pelo servico de configuracao a `exports.pr_bridge:ApplyVisualConfig(record)`. Essa chamada valida, armazena e reaplica a configuracao da NUI; nao e uma notificacao generica do cache. O painel visual pode recuperar o registro ausente por uma solicitacao explicita do usuario autorizado.
- Leituras/retornos das ferramentas funcionais da biblioteca continuam disponiveis quando explicitamente chamadas. Isso nao significa eliminar os runtimes de interface/target que seus usuarios escolhem usar.

Consumidores dependentes das coletas e notificacoes anteriores precisam ser adaptados. As assinaturas foram preservadas, mas o comportamento ativo foi removido por decisao arquitetural. Inicializacao sem erros nao equivale a homologar todos os recursos dependentes.

## Metodos e retencao

```lua
local state = pr_lib.Player(10).state
state:set('flag', false, 5000) -- prazo nao apaga dados
print(state:get('missing', 'fallback'))
state:clear('flag') -- remocao EXPLICITA
```

`get/set/onChange/off/clear` sao nomes reservados na sintaxe de propriedades. Use `state:get('set')` / `state:set('set', valor)` para campos com esses nomes. False/zero/nil e chamadas com ponto/dois-pontos sao preservados.

`cache.remember(key, callback, ttl)` so chama um callback que o proprio chamador forneceu nessa solicitacao explicita; nao agenda tarefas nem oferece um produtor padrao. Em chaves privadas, pode renovar o valor sob demanda apos o prazo. Em campos de estado compartilhados, o valor existente permanece. Uma leitura simples `get` nunca consulta produtores.

Nao ha rastreamento profundo de tabelas nem notificacoes. Para evitar alias mutavel no host, trabalhe em copia e reatribua o campo completo.

Logout, morte, troca de personagem, desconexao, vencimento de prazo e remocao de entidade nao apagam campos do cache automaticamente. Os indices nao sao mantidos por um scanner; tambem dependem de publicacao explicita.

`clear/clearPrefix/InvalidatePlayer/state:clear`, atribuicao de `nil` e `collectExpired()` continuam disponiveis apenas por chamada explicita. Nenhuma foi instalada como comando administrativo, timer ou callback de lifecycle. `InvalidatePlayer` remove somente snapshots `player:<id>`/`player:self` e `metadata:...`, nao `Player(id).state`.

Memoria pode crescer, IDs/handles podem ser reutilizados e mostrar dados anteriores, e remocao manual pode perder um snapshot ainda nao persistido. O produtor precisa distinguir identidade/sessao e manter suas autorizacoes. Reiniciar o recurso host ou servidor perde a memoria temporaria por natureza; nao ha persistencia nem fila de escritas para depois do restart.

## Validacao

- `cache_passive_test.lua`: 7 casos aprovados; nenhuma coleta, tarefa, push, busca externa, seed de dados, scan ou native de jogador/mundo; leituras e publicacoes explicitas entre recursos.
- `cache_state_test.lua`: 19 casos aprovados; APIs antigas/novas, false/zero, namespaces, isolamento cliente/servidor, remocoes explicitas, retencao e ausencia de notificacoes.
- Inicializadores reais com compat OX ativo/desativado, bootstrap legado OX e adaptador QBX: dados apenas por publicacao explicita.
- `settings_cache_test.lua`: configuracoes sem bootstrap/push/rede, com entrega/leitura explicitas e validacao de revisao.
- Testes isolados em Lua 5.5, normalizando sintaxe CFX nos testes de inicializacao. Homologacao no FiveM e medicao de FPS continuam pendentes. Nenhum recurso vivo foi reiniciado.

O manifesto ja inclui `bridge/**/*.lua`; a fabrica `cache/state.lua` e carregada pelos inicializadores, nao como `shared_script` independente.
