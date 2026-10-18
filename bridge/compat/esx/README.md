# ESX → framework de destino

Primeira implementação da fachada ESX, baseada na referência local
`[Docs]/[frameworks]/esx_core-main/[core]/es_extended`.
Não inicia outro core, não cria tabelas SQL ESX e não duplica jogadores.

**Estado: implementação parcial para homologação. Não é compatibilidade integral.**
O [relatório de cobertura](COVERAGE.md) distingue contratos adaptados de operações
que ainda lançam erro explícito. Ter o nome da função exposto não significa que
ela já esteja implementada. Os testes incluem presença do catálogo e cenários
representativos; não validam cada função em jogo.

## Configuração

Em `bridge/config.lua`:

```lua
compatFramework = 'qbx',
compatESXAccounts = { money = 'cash', bank = 'bank' },
compatESXComponentItems = {},
```

- `qbx` / `qbx_core`: chamadas ESX usam o backend QBX ativo do PR Bridge.
- `qb` / `qb-core`: usa o backend QB ativo (ainda precisa de homologação própria).
- `nd`, `ox`, `tmc`, `custom`, `default`: usam os adaptadores de destino
  correspondentes; capacidades sem equivalente exigem um serviço configurado.
- `forge` / `auto`: usa a framework efetiva detectada pelo PR Bridge; nesta base,
  normalmente QBX. A Forge não substitui a autoridade do core de jogadores.
- `esx`: o ESX original fornece sua própria API; a fachada não tenta redirecionar
  ESX de volta para si mesma nem intercepta um ESX original em execução.
- `false` / `'off'`: não carrega o host de compatibilidade de frameworks.

O destino explícito precisa corresponder ao backend ativo. Divergências geram erro
antes de qualquer operação de jogador: não alternam o core automaticamente.
`compatOx_lib` é independente; desativá-lo não desativa a fachada ESX.
A fachada de origem QBCore agora fica em [../qb/README.md](../qb/README.md).
QBX/QBCore nativos sao preservados; os demais destinos usam o contrato QB do PR Bridge.

Consumidores que suportam mais de uma framework devem selecionar o adaptador
nativo antes de usar um alias legado. Consulte [seleção e bloqueio de rotas](../FRAMEWORK_ROUTING.md).

`money` corresponde a `cash`, e `bank` a `bank`. Não há conversão implícita de
`black_money` para dinheiro limpo, itens ou uma carteira inexistente. Contas extras
exigem mapeamento explícito para uma carteira que realmente exista no destino.
Na configuração desta base, `compatFramework='forge'` foi preservado; nenhum core
foi alternado para fazer os testes.

## Scripts sem bridge próprio

Pontos de entrada implementados:

```lua
local ESX = exports['es_extended']:getSharedObject()
-- Ou, em scripts antigos:
TriggerEvent('esx:getSharedObject', function(object) ESX = object end)
```

E o import usual no manifest do consumidor:

```lua
shared_script '@es_extended/imports.lua'
```

O entrypoint público `imports.lua` fica na raiz apenas para preservar esse caminho;
sua implementação está em `bridge/compat/esx/consumer.lua`. Não é necessário
incluir `@pr_bridge/init.lua` no script ESX para usar esses pontos de entrada.
Não é necessário trocar chamadas ESX suportadas por chamadas PR manualmente.
Scripts que leem arquivos internos do core, acessam diretamente SQL ESX,
dependem de recursos separados como society/datastore/skin, ou usam contratos
marcados como não suportados não são automaticamente convertidos.

O manifest anuncia `provide('es_extended')`. Essa declaração é estática, como os
aliases ox_lib existentes. Para usar o ESX original como core, comente esse
`provide` e inicie o original. Para desligar completamente a identidade legada,
use `compatFramework=false` e comente o alias também. Alterações exigem reiniciar
o PR Bridge e seus consumidores; prefira reiniciar a cidade. Se apenas atualizar
o manifest com o servidor ligado, use `refresh` antes de reiniciar os recursos.

## Roteamento e limites

As 24 operações antes pendentes possuem encaminhamento por destino. Operações
de inventário seguem obrigatoriamente `Bridge.framework → Bridge.inventory`,
sem presumir Ox para QBX. O [contrato e a matriz de serviços](../../frameworks/COMPAT.md)
documentam o suporte real, as configurações e os casos ainda condicionais.

`GetCompatibilityCapabilities()` mostra disponibilidade e motivo/provider;
`GetCompatibilityReport()` retorna `delegated` somente quando há uma capacidade
resolvida. Existência da função na fachada não é confirmação de suporte real.

- Lookup por source/identificador, `Player`/`ExtendedPlayers`, filtros de empregos.
- `xPlayer`: dinheiro e contas mapeadas, emprego/duty, inventário e peso,
  metadados, coordenadas, notificações. Leitura usa snapshots; setters chamam
  o core/inventário real. Um wrapper de sessão antiga não pode escrever após logout.
- `xPlayer.set/get` guardam variáveis auxiliares da sessão, compartilhadas pelos
  consumidores ESX, sem permitir sobrescrever `money`, `job` ou `citizenid` do QBX.
- Catálogo de armas: somente itens definidos no inventário ativo; identificadores
  de 112 modelos e 548 componentes conferidos contra a referência ESX.
  Munição, pintura e attachments gravam no slot real do ox_inventory, preservando
  serial/durabilidade. A aparência da arma equipada é atualizada por evento validado.
  Outros inventários precisam de seu próprio contrato de metadados antes de escrever.
- Attachments usam o hash permitido para aquela arma e as configurações do inventário
  instalado (incluindo o overlay Forge quando ativo). Componentes desconhecidos ou
  sem mapeamento verificável geram erro; não recebem uma posição/hash inventado.
  Se dois itens representam o mesmo hash, configure, por exemplo,
  `compatESXComponentItems={WEAPON_PISTOL={flashlight='at_flashlight'}}`.
  Alterar uma arma apenas pelo nome é recusado quando há dois slots/seriais iguais.
  Arremessáveis não são convertidos automaticamente de munição ESX para quantidade
  de itens; essa política ainda precisa ser definida.
- Callbacks cliente/servidor, respostas com slots nil, prazos de 10s, ownership e
  limpeza por recurso. Requisições recebidas pelo servidor têm limite de 64/10s
  por jogador; o source vem do evento, nunca de um argumento de jogador.
- Protocolo manual `esx:triggerServerCallback` com envelope
  `(nome, requestId, recursoInvocador, ...)`; APIs obtidas pela fachada usam o
  transporte nativo do PR Bridge. Não há promessa de todos os protocolos históricos.
- Itens utilizáveis compartilham registro entre consumidores; comandos validam
  grupos no destino e não concedem ACEs por efeito colateral.
- Menus default/list/dialog, contextos simples, notificações e progresso reutilizam
  a interface nativa. Nem todos os detalhes visuais/opções ESX têm equivalência.
- Helpers de entidades/streaming e OneSync: execução sob demanda, sem ciclo de
  polling ocioso. Spawns de servidor usam espera limitada. Homologar com OneSync real.
- OneSync preserva os formatos ESX: players em área com registro/net ID do ped,
  players próximos como registro, outras entidades em área como lista de net IDs.
  Propriedades de veículos respeitam os flags nativos de state bag/broadcast;
  com ambos desligados, esperam um owner por até 5s e falham explicitamente se
  ninguém puder receber a aplicação. O spawn incompleto é removido nessa falha.
  Pontos usam o agendador espacial PR; interações usam o keybind nativo, sem criar
  outro ciclo de proximidade. Scaleforms só desenham durante a apresentação.
- Eventos de carregamento/logout, job e dados de jogador partem do ciclo de vida
  PR/QB/QBX. Nenhum state bag novo foi acrescentado para guardar jogadores.
- Dados são publicados uma vez por alteração, mesmo com vários consumidores.
  Parar um consumidor limpa menus, timers, pontos, ouvintes de UI e efeitos pendentes.

Pendências relevantes: SSN/playtime, paycheck individual, criação/refresh de itens
e jobs, permissões/grupos mutáveis, overrides/contabilidade de sessão de xPlayer,
pickups, logs Discord, veículos estendidos/persistência exclusiva do ESX,
skin/spawn de personagem e preview de contexto. Não são no-ops de
sucesso: o uso produz uma mensagem identificando o contrato não suportado.
Há 22 contratos server e 2 client nesse estado. Contas, identidades, salários e
persistência não devem receber uma segunda autoridade para esconder essa diferença.
Completar esses contratos exige definir sua correspondência com os serviços reais;
não foi alterado código de QBX, ox_inventory ou Forge Core nesta etapa.

## Testes

Na raiz do PR Bridge, com Lua instalado:

```text
lua tests/esx_compat_test.lua .
lua tests/esx_compat_test.lua . report
lua tests/esx_native_contract_test.lua .
lua tests/esx_weapon_catalog_test.lua .
lua tests/compat_toggle_test.lua .
lua tests/provider_client_boot_test.lua .
lua tests/provider_client_boot_test.lua . "" started disabled
lua tests/ox_compat_test.lua .
node tests/esx_catalog_test.mjs
```

O teste ESX executa módulos reais com core/inventário/natives simulados. Não abre
FXServer, banco ou áudio. O relatório é uma fotografia do alvo QBX simulado;
outra configuração/inventário pode não oferecer a mesma capacidade.

No FiveM, teste primeiro um recurso ESX pequeno: obter objeto/import, login/logout,
dinheiro/inventário, callback, menu e troca de emprego; depois reiniciar o recurso
consumidor e reconectar. Não inicie o ESX Core da pasta Docs junto com o QBX.

Verificação em 13/10/2026: 351 checks ESX (incluindo presença do catálogo),
30 checks de contratos nativos, 112 modelos/548 componentes conferidos e regressões
de ox_lib, menu NUI, inicialização QBX e cache aprovadas em ambiente simulado.
Isso não substitui o teste dentro do FiveM com o recurso ESX que será usado.
