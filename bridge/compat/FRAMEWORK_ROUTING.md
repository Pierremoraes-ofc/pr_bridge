# Seleção nativa antes do compat

`provide 'es_extended'` ou `provide 'qb-core'` oferece uma identidade legada.
`GetResourceState` sozinho não distingue esse alias de um core real. Não use
testes independentes desses dois nomes para inicializar dois adaptadores.

Nos consumidores que importam `@pr_bridge/init.lua`, escolha apenas um:

```lua
local selected = pr_lib.frameworkRouting.select({ 'qb', 'esx' })
-- QBX/QB ativo: 'qb'. ESX ativo: 'esx'.
-- Outro core: primeiro compat habilitado da lista, ou nil se desabilitado.
```

O backend exato tem prioridade. QBX também pode usar o adaptador nativo QB
fornecido pelo próprio `qbx_core`. A seleção não muda o core, os dados dos
jogadores ou os inventários. `getActive()` informa o backend efetivo, não o
apelido `forge` configurado como destino automático.

Para bloquear a aquisição de uma fachada errada, declare os adaptadores que o
recurso realmente implementa no seu manifest:

```lua
pr_bridge_framework 'qb'
pr_bridge_framework 'esx'
```

Com QBX ativo, esse consumidor não pode adquirir a fachada ESX. Com ESX ativo,
não pode adquirir a fachada QB. O erro identifica o recurso, a rota bloqueada
e o adaptador nativo a usar. A declaração não implementa um adaptador inexistente;
o consumidor ainda precisa usar a seleção acima nos seus testes de framework.
O Illenium desta base já usa esse contrato no detector compartilhado, portanto
seus módulos ESX e QB não sobrescrevem mais um ao outro.

Scripts exclusivamente ESX podem continuar usando a fachada no QBX, sem precisar
declarar nada. Não é possível deduzir com segurança quais frameworks um script
suporta apenas vendo seus nomes de dependência ou chamadas de export. Por isso,
o bloqueio nativo de consumidores multiframework é declarativo, não um bloqueio
global do compat ESX. Não altera `GetResourceState` nem oculta aliases da CFX.

## Custo de execução e ativação sob demanda

O host ESX mantém somente os pontos de entrada legados enquanto não houver um
consumidor externo que adquira seu objeto. Não cria um consumidor interno no
login, não monta xPlayer e não assina eventos nativos de jogador/inventário para
sincronizar ESX sem necessidade. Ao parar o último consumidor, remove essas
assinaturas e invalida a atualização pendente. As APIs nativas PR/QBX continuam
independentes da fachada ESX; o host QB também continua devolvendo o core nativo
em QBX/QBCore sem instalar seus próprios handlers legados.

Com consumidores ESX reais, alterações de inventário/dados recebidas no mesmo
lote são agregadas. Uma leitura nativa abastece snapshots isolados dos diferentes
consumidores. Não há janela fixa de throttling: a conversão é adiada para o próximo
tick, levando o estado mais recente. Login/logout/stop invalidam trabalho obsoleto.

O loadout consulta somente definições dos itens presentes no inventário; não
reconstrói o catálogo inteiro para obter o nome de cada arma. Caches de definições
existem somente dentro do lote, para não congelar itens, skins ou componentes.
A leitura server que retorna nil durante o carregamento gera uma visão vazia e
temporária; nunca cai numa API exclusiva do client. Funções realmente ausentes
continuam diagnosticadas, com limite de repetição do log.

### Regressão offline de contagem de trabalho

Fixture com 3.001 definições, dois consumidores ESX e 1.000 notificações:

| Operação | Antes | Depois |
| --- | ---: | ---: |
| Leitura de jogador | 2.000 | 1 |
| Leitura de inventário | 4.000 | 1 |
| Consulta do catálogo completo | 4.000 | 0 |

Sem consumidores ESX, a fixture server/client executa zero leituras, conversões,
eventos ESX e inicializações de UI em eventos nativos. Também há cobertura para o
pipeline real de lifecycle PR, restart do consumidor e logs de operações ausentes.
Essas contagens não são um benchmark de FPS nem uma garantia de custo no FiveM.
Teste: `tests/compat_idle_cost_test.lua`. Confirmar com o Resource Monitor/profiler
na cidade depois de reiniciar PR Bridge e todos os seus consumidores.

## Inicialização tardia do backend

PR Bridge pode iniciar antes do QBX por fornecer sua dependência ox_lib.
O servidor agora atualiza os adaptadores em `onServerResourceStart`, evento
enfileirado depois da inicialização, em vez de `onResourceStart`, executado durante
o start. Isso permite selecionar apenas recursos realmente `started` e preencher
as mesmas tabelas já referenciadas pelos consumidores legados. No cliente,
permanece `onClientResourceStart`. Não há loop novo de detecção.

Referência: [eventos de servidor da CFX](https://docs.fivem.net/docs/scripting-reference/events/server-events/).

## Verificação isolada

- `tests/framework_routing_test.lua`: prioridade nativa, aliases, bloqueio,
  switches, cache das declarações e detector/adaptadores reais do Illenium.
- `tests/esx_compat_test.lua`: bloqueio no host e aquisição de jogador pelo
  adaptador QBX real após start tardio, mantendo a referência da fachada ESX.

Os testes não iniciam a cidade nem acessam dados reais. Validação em FiveM pendente.
