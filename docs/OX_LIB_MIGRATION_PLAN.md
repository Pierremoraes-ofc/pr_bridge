# Plano final de migração OX e preparação do Forge Core

> Auditoria estática: **01/10/2026**. Base: `E:\[FIVEM]\Forge-Core`.
> Status de migração e aprovações atualizados em **04/10/2026**. PR Bridge: idioma/interface implementados, aguardando aprovação no jogo; aprovações anteriores preservadas. Os blocos da auditoria original mantêm sua data; esta atualização não é uma nova auditoria integral da base.
> Esta é a referência vigente do plano. O [histórico integral anterior](OX_LIB_MIGRATION_HISTORY_2026_10_01.md) foi preservado, mas seus percentuais e checklists não descrevem necessariamente o código atual.
> **Decisão: ainda não é seguro retirar `ox_lib` do boot nem substituir/renomear `qbx_core`.** Nenhum código, configuração de inicialização ou banco foi alterado nesta revisão.

<a id="indice"></a>
## Índice

1. [Resumo executivo e decisões](#resumo)
2. [Escopo, método e limites](#escopo)
3. [Arquitetura pretendida versus implementação](#arquitetura)
4. [Inventário atual e inicialização](#inventario)
5. [Bloco A — entregas existentes](#entregas)
6. [Bloco B — bloqueadores OX por recurso](#bloqueadores)
7. [Bloco C — auditoria cirúrgica do QBX](#qbx)
8. [Bloco D — paridade e bootstrap do PR Bridge](#bridge)
9. [Bloco E — SQL centralizado e transações](#sql)
10. [Bloco F — cache, sincronização e state bags](#estado)
11. [Bloco G — comunicação fora do bridge](#integracoes)
12. [Bloco H — desempenho e capacidade](#desempenho)
13. [Bloco I — segurança, falhas e consistência](#seguranca)
14. [Sequência recomendada de implementação](#sequencia)
15. [Critérios de retirada do ox_lib](#aceite-ox)
16. [Critérios de transferência QBX → Forge](#aceite-forge)
17. [Matriz de testes e evidências](#testes)
18. [Documentação revisada, divergências e histórico](#documentacao)

<a id="resumo"></a>
## 1. Resumo executivo e decisões

A migração avançou: grande parte dos manifests já importa o PR Bridge, o target nativo existe, há interface própria, cache de leituras automáticas no host, callbacks protegidos e adaptadores SQL. Isso **não** demonstra que toda comunicação, persistência e replicação já esteja centralizada.

| Meta | Situação em 01/10/2026 | Decisão |
|---|---|---|
| Retirar recurso `ox_target` | Nenhum manifesto desse recurso encontrado na árvore de recursos inventariada; nenhuma entrada ativa correspondente no `server.cfg`; target do bridge configurado como `native`. | Migração estrutural avançada. Certificar o funcionamento sem fornecedor externo; limpar adaptadores opcionais somente depois. |
| Retirar `ox_lib` | Quatro consumidores instalados ainda importam `@ox_lib/init.lua`: QBX, identidade, gestão do telefone e logs. QBX também exige versão e declara dependência. | **Bloqueado. Não remover o ensure agora.** |
| SQL somente pelo bridge | Quatro consumidores importam MySQL diretamente; dois apps mantêm fallback direto; Forge NPWD mantém pool `mysql2` próprio. | **Pendente**, inclusive fora do ecossistema OX. |
| State bags somente veiculares | Há usos pessoais e globais em QBX, bridge, Forge Core, voz, clima, inventário, prisão e emotes. | **Direção aprovada, implementação não concluída.** |
| Todos os scripts conversarem pelo bridge | Persistem exports QBX/QB diretos e leitura de dados de outros recursos. | Pendente, separado da retirada do ox_lib. |
| QBX virar Forge Core | QBX mantém sessão, personagem, player data, dinheiro e persistência. Forge Core já existe e ainda chama QBX em vários domínios. | Fazer transferência por domínio, não simples troca de nome. |
| Alto desempenho / meta de 2 mil jogadores | Há mecanismos favoráveis, mas não foi fornecida medição representativa de carga nesta revisão. | **Capacidade não certificada.** |

**Primeira etapa recomendada:** estabilizar a fundação independente de framework do PR Bridge e sua paridade com os contratos realmente usados pelo QBX; em paralelo de planejamento, preparar a limpeza dos consumidores menores. Não começar pela renomeação da framework.

### Decisão pendente — scripts com state bags não veiculares

**PENDENTE NOS RECURSOS AINDA NÃO MIGRADOS:** definir a sequência de migração para cache e transporte explícito pelo PR Bridge. A diretriz permanece: reservar state bags aos estados veiculares necessários. Esta lista identifica produtores **e leitores** de estados pessoais/globais; não significa que todos sejam escritores nem que todo módulo opcional esteja ativo no servidor. Achados iniciais conferidos em 01/10/2026; linhas de recursos migrados atualizadas em 03/10/2026, com caminhos relativos ao próprio recurso. Aprovação do responsável é homologação funcional, não certificação exaustiva de segurança ou desempenho.

| Recurso | Uso não veicular encontrado | Evidência representativa |
|---|---|---|
| `qbx_core` | **MIGRAÇÃO PARCIAL IMPLEMENTADA em 04/10/2026 — AGUARDA TESTE NO JOGO:** sessão e morte relacionadas ao inventário; carregamento OX e notificações de instância/metadata. | `client/session.lua` e `server/session.lua`: cache QBX consultável pelo PRBridge, sem `isLoggedIn` em state bag; loop de morte usa metadata/nativas. Inventário usa `QBCore:Server:PlayerLoaded`, antes da prontidão pós-spawn. Leitores legados em chaves/combustível migrados somente para sessão. `loadInventory` e publicações pessoais de `instance`/`canUseWeapons` retirados. Estados globais `/me`/PVP/contadores e contratos genéricos permanecem pendentes; estados veiculares preservados. Guia: `resources/[ox]/ox_inventory/docs/FORGE_CACHE_MIGRATION.md`. |
| `pr_bridge` | **IDIOMA E INTERFACE IMPLEMENTADOS em 04/10/2026 — AGUARDAM APROVAÇÃO NO JOGO:** `pr_bridge_locale` e `pr_bridge_ui_config` usam cache, snapshot inicial e deltas por evento. **Migração parcial do recurso:** radial e adaptadores ainda têm estados pessoais/globais fora deste escopo. | `bridge/settings.lua`, `bridge/locale.lua`, `interface/server/config.lua` e consumidores UI/Target/Interact/progresso/skillcheck. Logo por URL no menu Interface global; metadata expansível nos renderizadores Svelte/Vue. Guia: [Cache de idioma, interface e logo](BRIDGE_UI_CACHE_2026_10_04.md). |
| `forge-core` | **IMPLEMENTADO em 03/10/2026 — AGUARDA TESTE DE APROVAÇÃO NO JOGO:** Configurações/dados globais de lojas, objetos, NPCs, densidade, starterpack, farms, billboards, slots e spotlights. | `server/stores/service.lua:667` — `GlobalState.forgeStores`; detalhamento no [Bloco F](#estado). |
| `ox_inventory` | **ETAPA 1 IMPLEMENTADA em 04/10/2026 — AGUARDA TESTE DE APROVAÇÃO NO JOGO:** flags pessoais, morte/laststand/algemas, instância e permissão de revista/roubo migrados para cache no caminho ativo QBX. | `modules/state/client.lua`, `modules/state/server.lua`, adaptadores QBX e fachada `pr_bridge/bridge/cache/player_client.lua`. Snapshot por personagem, revisões, deltas ao dono, validação de bucket/proximidade e limpeza no logout. `vehicleid` preservado. Leitura de grupos via `GlobalState` no adaptador alternativo inativo `ox_core` continua fora do caminho QBX. Guia: `resources/[ox]/ox_inventory/docs/FORGE_CACHE_MIGRATION.md`. Redesign/admin/carrinho/hotkeys são próximas etapas separadas. |
| `pma-voice` | **IMPLEMENTADO em 03/10/2026 — AGUARDA TESTE DE APROVAÇÃO NO JOGO:** estado de voz, canais, volume e transmissão migrados para cache PR Bridge com snapshots/deltas explícitos. Morte/laststand consultados no cache de metadata da framework. | `cache.lua`, `server/main.lua`, `server/module/radio.lua`, `client/module/radio.lua`. Export `GetVoiceState` disponível aos consumidores; testes isolados em `tests/cache_test.lua`, `tests/death_cache_test.lua` e `tests/mic_click_test.lua`. O teste de áudio verifica mensagens de ativação/desativação, não audibilidade dentro do FiveM. |
| `mm_radio` | **IMPLEMENTADO em 03/10/2026 — AGUARDA TESTE DE APROVAÇÃO NO JOGO:** sessão, morte/laststand e memória temporária em cache; canais restritos validados no servidor. Administração in-game em JSON, catálogo de empregos/gangues via PR Bridge e exigência de serviço opcional por canal. | `client/interface.lua`, `client/event.lua`, `server/main.lua`, `server/policy.lua`, `shared/config.lua` e `client/admin.lua`. Snapshot de configurações, revisões e autorização administrativa; testes `tests/client_test.lua`, `tests/config_test.lua` e `tests/server_flow_test.lua`. Retorno ao menu pai do Forge Core e som ligado por padrão quando a preferência não existe; preferência explícita de silenciar preservada. |
| `Renewed-Weathersync` | **APROVADO PELO RESPONSÁVEL em 03/10/2026:** clima, tempo, blackout global/individual e pausa local migrados para cache PR Bridge com transporte explícito. | `shared/cache.lua`, produtores e compatibilidades ativos; snapshots, gerações/revisões, cópias defensivas e isolamento por personagem. Evidências locais da implementação: três suítes Lua aprovadas e 31 arquivos validados com luac. Integrações Bridge/Forge/relógio do parquímetro migradas junto. Os seis arquivos antigos de `legacy/` foram removidos com autorização e backup externo, conforme o guia. Guia, anormalidades e roteiro: `resources/[standalone]/Renewed-Weathersync/docs/FORGE_CACHE_MIGRATION.md`. |
| `forge-npwd-weather` | **APROVADO PELO RESPONSÁVEL em 03/10/2026:** consulta clima/tempo/região via PR Bridge e recebe atualizações do cache, sem state bags nos arquivos ativos. | `client/main.lua`, `server/main.lua` e adaptadores `pr_bridge/bridge/weather/renewed/`. Preservados previsão, mapas e widgets; integração cliente/servidor testada com acesso a state bags proibido. Fallback ilustrativo e limitações da projeção semanal relatados no guia do Renewed; aprovação da migração não elimina essas observações. |
| `xt-prison` | **APROVADO PELO RESPONSÁVEL em 03/10/2026:** cache e persistência por personagem; estados preso/foragido/livre, spawn obrigatório, uniforme na reconexão e gestão/F9. | Integração com Space Spawn e Forge Core confirmada pelo responsável após correções de ordem da aparência/ped e uniforme exclusivo de preso. Empregos bloqueados somente para preso. Guias: `resources/[standalone]/xt-prison/docs/FORGE_CACHE_MIGRATION.md` e `docs/PRISON_SPAWN_STATE.md`. Aprovação funcional relatada pelo responsável, não auditoria exaustiva ou benchmark. |
| `scully_emotemenu` | **APROVADO PELO RESPONSÁVEL em 03/10/2026 (implementado em 01/10/2026):** estado pessoal, props/partículas e postura convertidos para cache PR Bridge. | `client/modules/state.lua`, `server/state.lua`, `shared/modules/emote_state.lua` e handlers em `client/main.lua`/`stance.lua`. Callbacks de snapshot/escrita, deltas direcionados por distância/bucket, limpeza e reidratação por streaming; exports existentes preservados. Testes Lua de contrato/cache e catálogo (597 props / 46 partículas) aprovados. Guia e roteiro: `resources/[standalone]/scully_emotemenu/docs/FORGE_CACHE_MIGRATION.md`. |
| `Renewed-Banking` | **APROVADO PELO RESPONSÁVEL em 01/10/2026:** removidos `GlobalState.renewedBankInteraction` e seu handler. Configuração de interação e configurações de faturas usam `pr_lib.cache`; coleções temporárias de contas/jogadores também registradas no cache, somente no servidor. | `server/invoices.lua`, `server/main.lua`, `client/main.lua`. Snapshot inicial via callback do bridge e deltas por evento de rede do recurso, com revisão e validação de origem; cache sozinho não replica pela rede. Teste Lua em `tests/interaction_cache_test.lua` aprovado; 9 arquivos aprovados no `luac55 -p` (inclui teste). `config.lua` não alterado: hashes nativos FiveM não são aceitos pelo luac padrão. Responsável confirmou funcionamento após cache e idiomas; não equivale a auditoria integral de segurança ou benchmark. |
| `pr_elevator` | **APROVADO PELO RESPONSÁVEL em 01/10/2026:** leitura direta de idioma global removida. Diagnóstico usa o idioma resolvido por `pr_lib.locale()` e `pr_lib.cache.set/get('pr_elevator:locale')`. | `server/menu.lua` — cache do recurso, sem nova replicação. Os 12 arquivos Lua passaram no `luac55 -p`; teste Lua isolado aprovado. Responsável confirmou funcionamento após a alteração; não equivale a certificação exaustiva de segurança/desempenho. |
| `forge-police` | **CONSUMIDOR MIGRADO — AGUARDA TESTE JUNTO AO RÁDIO:** consulta de canal do jogador para o roster pelo export do cache de voz. Não representa homologação integral deste recurso. | `server/backend/roster.lua` — `exports['pma-voice']:GetVoiceState(playerSource)`, com retorno seguro quando o provedor está parado. Os estados de clamp veicular não entram neste achado. |

**Recursos de foco veicular que também possuem usos não veiculares:** não devem ser considerados integralmente cobertos pela exceção de veículos.

| Recurso | Uso pessoal/global que precisa de decisão | Evidência |
|---|---|---|
| `forge-garage` | Flag pessoal `garageBusy` e leitura do horário global. | `client/main.lua:51/105/242/502`; `server/parking.lua:82` — `GlobalState.currentTime`. Preservar separadamente a identidade/estado dos veículos. |
| `pr_carkeys` | Consulta de sessão do jogador. | `client/modules/vehicle_init.lua:538` — `LocalPlayer.state.isLoggedIn`. Não confundir com `garageVehicleIdentity`, que é veicular. |
| `cdn-fuel` | **CONSULTA DE SESSÃO MIGRADA em 04/10/2026 — AGUARDA TESTE:** leitor `isLoggedIn` usa `pr_lib.framework.IsSessionReady` no QBX. | `client/fuel_cl.lua`: somente a consulta pessoal foi alterada. Combustível do tanque continua no caminho preexistente Decor/nativas (não foi convertido para cache); galão continua em metadata do item. Regra: estados veiculares ficam fora da migração pessoal e seus state bags são preservados. |

**Decisão a registrar por recurso:** contrato substituto no bridge, ordem de migração e critérios de homologação. Migrar produtores e consumidores juntos, preservando entrada tardia, reinício, desconexão e sincronização entre jogadores. **Aprovados pelo responsável:** `pr_elevator`, `Renewed-Banking`, `scully_emotemenu`, `xt-prison`, `Renewed-Weathersync` e `forge-npwd-weather`. **Implementados, aguardando teste de aprovação:** `pma-voice`, `mm_radio`, `forge-core` e a etapa 1 do `ox_inventory`; idioma/interface do `pr_bridge` constituem migração parcial, também aguardando aprovação. Inclui a integração de rádio do roster e os ajustes produtores QBX necessários ao inventário, sem declarar migração integral do QBX. Os demais achados permanecem pendentes. Atualizar o status individual conforme o responsável aprovar cada script. A lista não certifica exaustivamente todas as chaves/entidades da base. `pr_carkeys`, `cdn-fuel` e os estados veiculares do `forge-garage` permanecem na exceção veicular; a consulta não veicular do relógio do parquímetro foi migrada separadamente.

**Complemento rádio e navegação (03/10/2026) — aguarda teste no jogo:** no painel do MM Rádio, escolher canal/tipo e depois selecionar os empregos ou gangues cadastrados em dropdown pesquisável com tags. O servidor fornece o catálogo por `pr_lib.framework.GetFrameworkJobs/GetFrameworkGangs`. Para empregos, `requireDuty` define a exigência de serviço; configurações antigas sem a flag continuam exigindo serviço. Gangues não exigem duty. Alterações de emprego/gangue/serviço reavaliam o canal no servidor e removem acesso indevido. O botão de voltar dos painéis do rádio e elevador informa `menuResource` junto ao ID do menu pai, preservando os pais locais dos submenus; abertura independente não herda o Forge Core. Configurações do elevador retornam ao gerenciamento ao cancelar/salvar. Esses ajustes posteriores não são automaticamente homologados pela aprovação anterior da migração do elevador.

**Verificação local desse complemento:** 56 arquivos Lua de `mm_radio`, `pma-voice` e `pr_elevator` passaram em `luac55.exe -p`; 15 suítes isoladas (rádio, voz, elevador e atalhos administrativos do Forge Core) aprovadas. Os seis JSON de idiomas do rádio foram validados, incluindo as nove chaves comuns de catálogo/duty. Busca estática não encontrou leitura/escrita direta nem handlers de state bags nos Lua ativos de `mm_radio`/`pma-voice`. Nenhum reinício do servidor, alteração do banco real ou teste em FiveM foi executado nesta verificação.

**Complemento Renewed-Banking — idiomas (01/10/2026):** interface e mensagens geradas revisadas; 22 catálogos com paridade de 216 chaves, sem rótulos visíveis fixos nos 15 componentes auditados. Codificação mista do painel de configurações corrigida para UTF-8. Datas/moeda da NUI seguem o idioma recebido do bridge; dados personalizados e histórico preservados. Testes de catálogos/componentes/cache, validação Lua, checagem Svelte e build aprovados. **Aprovado pelo responsável no jogo em 01/10/2026.** Evidências e roteiro: `resources/[standalone]/Renewed-Banking/docs/LOCALIZATION_2026_10_01.md`.

<a id="escopo"></a>
## 2. Escopo, método e limites

### O que foi auditado

- Censo dos manifests `fxmanifest.lua` e `__resource.lua` encontrados em `resources/`, com exclusão de `node_modules`.
- Entradas ativas `start`, `ensure` e `exec` do `server.cfg`; configurações relacionadas, especialmente `pr_bridge.cfg`.
- Varreduras transversais de imports, dependências, exports OX/QBX/QB, MySQL, state bags, GlobalState e carregamentos.
- Leitura aprofundada dos entrypoints, adaptadores, cache, callbacks, lifecycle e contratos SQL do bridge; núcleo de sessão, status, salvamento, storage e APIs do QBX.
- Conferência contextual dos achados em telefone, moradia, segurança e demais grupos; distinção entre fonte carregada, bundle distribuído, fallback, comentário, teste e fornecedor opcional.
- Plano anterior e documentos de visão, compatibilidade, target, interact, gizmo, garagem, correções e complemento de cache/callbacks.
- Catálogos extensos `API_FUNCTIONS.md` e `functions_datails.md` consultados por índice e seções relevantes; não constituem prova de paridade de todas as funções.

### O que esta revisão não certifica

- Não houve start/stop/restart do FXServer, alteração SQL, teste com jogadores ou benchmark.
- O boot descrito é o **configurado**, não uma captura dos recursos efetivamente iniciados no processo.
- Arquivos de desenvolvimento, backups, exemplos, módulos opcionais e pastas documentais não são automaticamente consumidores ativos.
- Varredura ampla e leitura aprofundada das áreas críticas não significam revisão linha a linha de todo código de terceiros, frontend, binário ou artefato gerado.
- Nenhuma conversa externa intitulada “Forge Framework 1/2/3” foi acessada nesta sessão; decisões foram confrontadas com o pedido atual e a documentação local.
- Testes e homologações antigos são evidência histórica atribuída a seus documentos, não testes reexecutados nesta auditoria.
- Git não reconheceu a raiz como repositório utilizável nesta sessão. Não foi possível certificar um diff global ou histórico de commits; mudanças anteriores foram preservadas.

### Classificação

| Marcador | Significado |
|---|---|
| **ESTÁTICO** | Presença ou ausência de um contrato confirmada no código/manifest consultado. Não equivale a funcionamento no jogo. |
| **HISTÓRICO** | Entrega/teste relatado por documentação anterior; precisa considerar mudanças posteriores. |
| **PENDENTE** | Implementação, decisão ou teste ainda necessário. |
| **RISCO** | Condição concreta que exige investigação/controle; não significa incidente reproduzido. |
| **P0** | Boot, perda de dados, consistência ou segurança crítica. |
| **P1** | Migração necessária ou melhoria operacional relevante. |
| **P2** | Consolidação, observabilidade ou otimização a medir. |

Não reutilizar `[X]` para dizer simultaneamente “código presente”, “migração estática concluída” e “homologação atual aprovada”.

<a id="arquitetura"></a>
## 3. Arquitetura pretendida versus implementação

### Destino aprovado

`Scripts → contratos pr_lib → serviços do Forge Core / fornecedores de domínio`

`Persistência dos serviços → pr_lib.database → adaptador SQL → oxmysql → banco`

`Estado pessoal/configurações → cache + transporte explícito do bridge`

`Estado veicular compartilhado → canal veicular do bridge → state bags necessários`

O `oxmysql` pode continuar iniciado como **driver físico**. Retirar sua importação dos consumidores não exige retirar o serviço nem trocar o servidor de banco.

### Responsabilidade de cada camada

| Camada | Responsabilidade | Não confundir com |
|---|---|---|
| PR Bridge | Transporte, contratos públicos, cache, invalidação, interface e seleção/adaptação dos fornecedores. | Autoridade econômica automática ou autorização de toda operação. |
| QBX durante transição | Domínios ainda não transferidos: personagens, sessão, player data, economia e storage. | Biblioteca que pode ser simplesmente desligada enquanto consumidores ainda usam seus objetos. |
| Forge Core definitivo | Autoridade de regras e escrita dos domínios homologados. | Segunda autoridade simultânea escrevendo os mesmos saldos e registros. |
| Fornecedores de domínio | Garagem, banco, moradia, voz, telefone e inventário, atrás de contratos estáveis. | Infraestrutura paralela que escolhe framework/driver por conta própria. |

O recurso `forge-core` existente já contém serviços e administração. Integrar o núcleo QBX nele exige plano de propriedade dos módulos, compatibilidade e persistência. Não criar dois recursos com o mesmo nome, nem pressupor que `provide 'qb-core'` resolva imports `@qbx_core/...` ou todos os nomes de eventos.

<a id="inventario"></a>
## 4. Inventário atual e inicialização

### Contagem reproduzível da árvore instalada

Foram encontrados **113 manifests**, dos quais **39 em `resources/[Docs]`** e **74 fora dessa árvore**.

| Grupo fora de [Docs] | Manifests | Recursos |
|---|---:|---|
| [cfx-default] | 6 | baseevents, mapmanager, sessionmanager, spawnmanager, webpack, yarn |
| [clothing] | 4 | backpacks, illenium-appearance, illenium-appearance-studio, Unisex Body Armor With Pouches |
| [forge] | 15 | forge-backpack, forge-chat, forge-core, forge-crafting, forge-garage, forge-gym, forge-hud, forge-loadscreen, forge-npwd-shop, forge-radialmenu, forge-rental, forge-smallresources, pr_bridge, pr_scriptTest, space_spawn |
| [housing] | 2 | ps-housing, ps-realtor |
| [mapping] | 7 | bob74_ipl, driver_license, jordqn_free_shells, paletopd, patoche_paleto_airport, patoche_paleto_airport_minimap, pillbox |
| [ox] | 4 | ox_doorlock, ox_inventory, ox_lib, oxmysql |
| [props-and-peds] | 2 | ped_model, props |
| [qbx] | 2 | qbx_core, qbx_idcard |
| [security] | 2 | antic-cheat, fm-logs |
| [standalone] | 12 | forge-police, glitch-minigames, MugShotBase64, pr_3dsound, pr_elevator, ps-dispatch, Renewed-Banking, Renewed-Weathersync, screencapture, scully_emotemenu, Syn_Sit, xt-prison |
| [vehicle_system] | 7 | cdn-fuel, lvc, mh6m, pr_carkeys, pr_mileage, RageUI, veh_service |
| [voice] | 11 | forge-npwd-bridge, forge-npwd, mm_radio, forge-npwd-banking, forge-npwd-garage, forge-npwd-housing, forge-npwd-management, forge-npwd-weather, forge-npwd-mail, npwd_original, pma-voice |
| **Total** | **74** | Contagem instalada, não homologação. |

Se um denominador de consumidores for necessário: retirar `pr_bridge` e `oxmysql` como infraestrutura, `ox_lib` como legado a remover e `npwd_original` como cópia não selecionada no boot explícito deixa **70 candidatos de produto**. Isso não transforma os demais em “70 recursos certificados”.

**Não foi calculado percentual de migração concluída.** Existem pelo menos oito consumidores com resíduos concretos na trilha biblioteca/SQL; os demais ainda exigem avaliação de caminho ativo, integração, replicação e QA. Percentuais 60/65 e 92,3% do histórico estão superados.

### Boot configurado

`server.cfg:95–106` contém:

`oxmysql → ox_lib → qbx_core → glitch-minigames → pr_bridge → forge-core → ox_inventory`

- Há **71 comandos explícitos start/ensure** no arquivo principal.
- `pr_bridge.cfg` é executado antes dos recursos e ativa **development/secure**, com limites temporários **64/16/16** e debug de target ligado.
- `forge-crafting` aparece em `server.cfg:129`: não é mais o consumidor “inativo aguardando migração” das tabelas antigas.
- `npwd_original`, `antic-cheat` e `fm-logs` não aparecem nas entradas explícitas do arquivo principal. Dependências e inicialização externa devem ser verificadas no FXServer.
- `server.cfg:262–264` ainda inicia `pr_animateConfig`, `codem-adminmenu` e `pinel-admin`, apesar da decisão documental de excluir `[Docs]` do produto.
- `ps-realtor` declara dependência de `ps-housing`, mas aparece antes dele no cfg; confirmar a ordem efetiva resolvida por dependências.
- `forge-npwd` declara dependência de captura e voz; certificar o fornecedor/alias de captura na instalação real.

### Pendente de limpeza do boot — P0/P1

1. Decidir/remover as entradas residuais de [Docs] em etapa autorizada; enquanto forem iniciadas, não tratá-las como meramente arquivadas.
2. Confirmar fornecedores carregados e dependências implícitas, incluindo segurança, screenshots, scripts de teste e builders.
3. Preparar perfil de produção, sem simplesmente aplicar os limites de homologação a uma população grande.
4. Fazer a mudança de ordem do núcleo somente após resolver o bootstrap descrito no bloco D.

<a id="entregas"></a>
## 5. Bloco A — entregas existentes

| Área | Implementação existente | Estado / limite |
|---|---|---|
| Target nativo | API de zonas/modelos/entidades, runtime, filtros, compatibilidade qtarget e interface no bridge. `Config.Target = "native"`. | ESTÁTICO; documentos registram testes locais e uso em jogo anterior. Reteste atual necessário. |
| Interface própria | Loader e bundles Svelte/Vue; APIs de context, input, notify, TextUI, radial e progresso. | ESTÁTICO; adaptadores OX opcionais continuam presentes. |
| Cache | TTL, observadores, métricas, leituras automáticas limitadas ao host e compartilhamento seletivo entre recursos no mesmo contexto. | ESTÁTICO; não é cache global universal de todos os domínios. |
| Callbacks | Módulos secure/legacy, limites, source esperado nas respostas, timeout, cancelamento e limpeza. | ESTÁTICO; histórico de homologação com um jogador. Cenários com dois jogadores permanecem a certificar. |
| Lifecycle | Eventos normalizados de carregamento/descarregamento de personagem e inventário. | ESTÁTICO; depende da seleção inicial de framework. |
| SQL | query, single, scalar, insert, execute/update, prepare, rawExecute, ready e transaction; adaptadores para três drivers. | ESTÁTICO; paridade real e transação interativa ainda não certificadas. |
| Estado veicular | `bridge/fivem/vehicleState/shared.lua`, canais e APIs de leitura/escrita/observação. | ESTÁTICO; preservar campos que precisam de replicação. |
| Forge Crafting | Manifesto agora importa e depende do PR Bridge. | Corrige classificação antiga; não atesta todo QA do crafting. |
| Forge Core | Nenhuma ocorrência executável `MySQL.*`/`exports.oxmysql` encontrada na varredura Lua contextual desta revisão. | Não confundir com autonomia: ainda usa QBX diretamente e GlobalState. |
| Inventário/portas/garagem | Manifests sem imports OX/SQL diretos antigos; várias integrações já pelo bridge. | Migração de infraestrutura avançada; framework/estado/lifecycle precisam de certificação separada. |
| Telefone | Dispositivos/perfis, bridge Lua, apps e recursos separados. | Funcionalidades não equivalem a centralização: pool SQL próprio e resíduos em apps persistem. |

O histórico registra migrações de aparência, pequenas funcionalidades, clima, banco, prisão, keys, mileage, combustível, garagem e adaptadores de telefone. Essas entregas não foram apagadas; foram separadas das pendências identificadas agora.

<a id="bloqueadores"></a>
## 6. Bloco B — bloqueadores OX por recurso

**Oito consumidores instalados têm resíduos concretos de biblioteca ou acesso SQL fora do contrato desejado.** O PR Bridge tem, adicionalmente, sua própria limpeza/paridade interna. Segurança instalada e não iniciada explicitamente continua relevante se voltar ao produto.

| Recurso | Boot explícito | Achado confirmado | Trabalho necessário | Prioridade |
|---|---|---|---|---|
| qbx_core | Sim | `fxmanifest.lua:9,12,31,71–72`: locale/import/dependências OX; checks e ampla API lib; SQL em storage/slots/events. | Resolver fundação do bridge; portar APIs e SQL; preservar contratos e sessão. | P0 |
| qbx_idcard | Sim | `fxmanifest.lua:14,19,26`: dependência/import ox_lib e import MySQL; bridge próprio Qbox. | Migrar callbacks/proximidade/notificação/framework; confirmar import SQL ocioso antes de remover. | P1 |
| forge-npwd-management | Sim | `fxmanifest.lua:10` importa ox_lib; `server/main.lua:174–179` tenta MySQL/oxmysql após bridge. | Remover import e fallbacks; falha do bridge deve retornar erro controlado, não selecionar outro banco. | P1 |
| forge-npwd-banking | Sim | Manifesto declara oxmysql; `server/main.lua:339–340` mantém fallback `exports.oxmysql`. | Banco exclusivamente pelo bridge, preservando segurança e identidade do aparelho. TypeScript legado não é o runtime Lua selecionado no manifesto. | P1 |
| ps-housing | Sim | `fxmanifest.lua:51` importa MySQL; properties/hotel/doors/management/migrate usam SQL direto. `server/enterprises.lua:77` usa transação interativa. | Migrar armazenamento completo; criar contrato transacional equivalente antes de trocar chamadas. | P0 |
| forge-npwd | Sim | Pool próprio em `packages/database/src/db/pool.ts:41`; consultas em `db_wrapper.ts`. Bundle ativo contém `createPool` e inicialização do pool. | Criar transporte JS↔bridge para SQL e unidade de trabalho/transações. Preservar formatos de retorno esperados. | P0 |
| fm-logs | Não | `fxmanifest.lua:26` importa ox_lib; callbacks, comandos e onCache dependem de lib. | Migrar ou retirar formalmente do produto; necessário se antic-cheat for iniciado. | P1 |
| antic-cheat | Não | Manifesto importa/depende de oxmysql; módulos SQL e calls QB/QBX diretos; depende de fm-logs. | Migrar persistência e integrações; preservar integridade do sistema de segurança. | P0 |

### ox_target residual

Na varredura de consumidores não documentais, as chamadas diretas encontradas em `pr_scriptTest/client_target_hydrants.lua:209–237` são comparação opcional condicionada a `GetResourceState`. Não representam fornecedor obrigatório no caminho sem ox_target. Adaptadores externos do bridge e convars de compatibilidade são outra categoria, não novas instalações do recurso.

Para a versão final sem legado, decidir se comparações/adaptadores OX ficam apenas em ferramentas de desenvolvimento ou são retirados do pacote. Não contar simples nomes `pr_lib.ox_target` como dependência do recurso original.

<a id="qbx"></a>
## 7. Bloco C — auditoria cirúrgica do QBX

### C1. Bootstrap e carregamento — P0

- `fxmanifest.lua` importa ox_lib como shared e MySQL no servidor; não importa PR Bridge.
- `server/main.lua:1–18` faz versionCheck, exige ox_lib >= 3.20.0, verifica inventário/framework/OneSync e pode executar `quit immediately`.
- `modules/hooks.lua:4` também exige ox_lib. Alterar apenas o manifesto deixaria um segundo bloqueio.
- `require`, `lib.load`, `locale`, `cache` e globais da compatibilidade fazem parte do ambiente dos módulos.
- `provide 'qb-core'` é contrato usado por vários consumidores e deve permanecer compatível durante a transição.
- `server/vehicle-persistence-compat.lua` é o script veicular carregado explicitamente. O arquivo completo `server/vehicle-persistence.lua`, que referencia qbx_vehicles, não deve ser considerado automaticamente ativo só por estar no disco.

### C2. Superfície lib a portar

| Família | Usos encontrados no QBX | Equivalente / cuidado |
|---|---|---|
| Transporte | callback.register / callback.await | `pr_lib.callback`; preservar ordem de argumentos, múltiplos retornos, nils, timeout e erros. |
| Interface | notify, inputDialog, alertDialog, register/showContext, progressBar, show/hideTextUI | APIs nativas; testar foco, cancelamento e retorno síncrono esperado. |
| Cache/proximidade | cache, onCache, points.new, closest object/ped/player/vehicle, nearby players/vehicles | Cache central e helpers; preservar entity, distância, filtros e falsy/nil. |
| Streaming | requestModel, requestAnimDict/Set, requestNamedPtfxAsset, playAnim | Streaming do bridge; timeout e liberação dos assets. |
| Veículos | get/setVehicleProperties, waitFor, state handlers | APIs veiculares; validar controle de rede, ownership e persistência. |
| Utilitários | string.random, math.groupdigits, table.freeze/matches/merge | APIs existentes; conferir semântica, mutabilidade e colisões. |
| Administração | addCommand, add/removeAce, add/removePrincipal | Commands/ACE; não transferir confiança ao cliente. |
| Loader/idioma | load, locale, require/configs | Carregador e tradutor do bridge; preservar resolução relativa e ambiente. |
| Observabilidade | print.debug/error/info/verbose/warn, logger, versionCheck, checkDependency | Paridade de níveis/assinaturas e diagnóstico sanitizado. |

**Existir uma API pr_lib não significa existir o mesmo alias em lib.** O `bridge/compat/ox_phase1.lua` publica apenas parte da superfície. Uma troca cega de `@ox_lib/init.lua` por `@pr_bridge/init.lua` não atende essa matriz.

### C3. Sessão e autoridade

Domínios que precisam de inventário de contratos antes da transferência:

1. Identificação/license/userId/citizenid, fila, whitelist e bans.
2. Slots, termos, criação, seleção e exclusão de personagens.
3. Registro em QBX.Players, eventos de load/unload/drop e buckets.
4. PlayerData, metadata, grupos, cargo, gangue e permissões.
5. Dinheiro, pagamentos, conta offline e operações de inventário.
6. Status locais, efeitos autorizados, morte/revive e persistência.
7. Catálogos e identidade/persistência mínima de veículos.
8. Compatibilidade QB, exports e módulos importados por consumidores.

### C4. Persistência e desempenho

- `server/status.lua` já distribui checkpoints por jogador: ciclo mínimo 60 s, intervalo entre jogadores mínimo 250 ms. Preservar essa melhoria.
- `server/player.lua:1112–1196` contém Save/SaveOffline/SaveAllPlayers; Save usa lock por personagem e marca revisão salva após sucesso.
- `server/events.lua` faz save no drop e flush em restart/shutdown.
- Checkpoint e SaveAllPlayers pedem snapshot ao cliente antes de salvar. Um callback lento pode atrasar os seguintes; flush global é sequencial.
- A revisão `savedRevision` existe, mas o ciclo periódico chama Save sem usar essa revisão como único filtro. Qualquer futura política dirty deve abranger dinheiro/grupos/posição/metadata, não apenas status.
- `client/status.lua:28` usa debounce padrão de 500 ms. Autonomia local já existe, porém comunicação de snapshots continua frequente quando há mudanças.

### C5. SQL e schema

Preservar tipos de retorno, parâmetros nomeados/posicionais, upserts, affected rows, transações e tabelas users/players/bans/player_groups/slots/termos. Não alterar schema e dono de escrita simultaneamente sem plano de migração e rollback.

<a id="bridge"></a>
## 8. Bloco D — paridade e bootstrap do PR Bridge

### D1. Dependência circular — bloqueador P0

Estado atual:

- QBX inicia antes do PR Bridge.
- `pr_bridge/init.lua:18–20` recusa consumidor quando o bridge não está `started`.
- Bridge detecta QBX e carrega adaptador de framework; adaptador cliente acessa `exports.qbx_core:GetPlayerData()` durante sua inicialização.
- `bridge/player_lifecycle.lua` escolhe handlers segundo o framework detectado no carregamento.

Adicionar simplesmente `dependency 'pr_bridge'` ao QBX e inverter os ensures pode selecionar framework default ou carregar um adaptador que espera QBX ainda indisponível.

**Proposta, ainda não implementada:**

1. Separar fundação framework-independent: loader, utilitários, locale, cache básico, callbacks, UI, SQL.
2. Inicializar essa fundação antes do QBX sem exigir PlayerData ou exports dele.
3. Registrar/anexar fornecedor de framework quando pronto; hidratar consumidores e lifecycle de modo explícito.
4. Tornar restart/reattach seguro e evitar seleção default congelada.
5. Migrar QBX para a fundação, mantendo adaptador de domínio transitório.
6. Certificar boot vazio, entrada posterior e restart coordenado.

### D2. Adaptadores OX internos — P1

`bridge/config.lua` ainda prioriza ox_lib em notifications/menus/textui e mantém opções de minigame/progress/target externos. Os entrypoints carregam esses adaptadores antes das sobreposições de interface nativa.

- `bridge/menus/ox_lib/client.lua`: calls reais a exports.ox_lib.
- `bridge/textui/ox_lib/client.lua`: show/hide por exports.
- `bridge/notifications/ox_lib/client.lua`: evento ox_lib:notify.
- `init.lua:591–592`: fallback de isTextUIOpen consulta ox_lib.

As APIs públicas de interface são sobrepostas pela NUI própria em vários caminhos; isso não certifica todas as chamadas ao adapter bruto. Homologar com ox_lib **ausente desde o boot**, não apenas parado depois de inicializar.

Escolher fornecedores nativos explicitamente, verificar os dois entrypoints e impedir fallback silencioso em contratos críticos. Adapters legados podem ficar opcionais durante transição, mas não no produto final anunciado como livre de ox_lib.

### D3. Cache e callbacks

O host centraliza sondagens automáticas; consumidores têm caches locais e callbacks por instância. Alterar o arquivo init.lua não troca os módulos já importados em recursos em execução. Planejar restart coordenado e invalidação.

O perfil secure está ativo no cfg, mas os limites são temporários. Os limites por jogador/pendências são **por instância de callback**, não um orçamento global de todo o servidor.

<a id="sql"></a>
## 9. Bloco E — SQL centralizado e transações

### E1. Contrato atual

Adaptador oxmysql oferece operações reais por exports e normalização de update. Alternativos já delegam transaction ao driver:

- `bridge/database/ghmattimysql/server.lua:206–217`.
- `bridge/database/mysql_async/server.lua:180–191`.

Por isso, o checklist antigo “implementar transações alternativas” está desatualizado. **A pendência é homologar a semântica real**, além de acrescentar contratos faltantes.

### E2. Lacunas prioritárias

| Lacuna | Evidência | Impacto / próximo trabalho |
|---|---|---|
| Transação interativa | Housing usa MySQL.startTransaction com query na mesma conexão; bridge expõe transaction de lote. | Definir unidade de trabalho com leitura, decisão, locks e escrita atômica. Não converter em queries independentes. |
| SQL JS do telefone | Pool/bundle usam mysql2 e formatos [rows/header, fields]. | Export/transporte bridge para JavaScript, retorno normalizado, tratamento de erro e transação. |
| Pool paralelo e logs sensíveis | pool.ts:49–54 inclui connection string no catch. | Sanitizar erro em implementação futura; eliminar conexão paralela do consumidor. Não copiar credenciais para documentos. |
| Readiness | oxmysql isReady verifica estado do recurso; ready espera sem prazo final; await depende de callback do driver. | Diferenciar recurso iniciado/conexão pronta; deadline, cancelamento e erro de indisponibilidade. |
| Seleção forçada | getBridge database pode continuar seleção automática após fornecedor forçado indisponível. | Definir política fail-closed; configuração inválida não deve operar em fornecedor inesperado. |
| Resultado ausente | wrappers retornam nil em falha; consumidores podem assumir iterable/resultado numérico. | Contrato de erro uniforme; nunca tratar indisponibilidade como lista vazia/saldo zero/sucesso. |
| Multi-driver | Implementações e testes históricos com mocks. | Certificar parâmetros, batches, NULL, insertId, affectedRows e rollback em banco de homologação. |

### E3. Atomicidade do telefone — P0

`withTransaction(queries: Promise<any>[])` em pool.ts recebe promises já criadas e executa Promise.all, sem encaminhar essas queries à conexão obtida. A estrutura não garante que todas as operações pertençam à transação dessa conexão; beginTransaction também não é aguardado no trecho.

Localizar seus consumidores e substituir por contrato de trabalho ligado à conexão antes de utilizar esse helper em recuperação/transferência econômica. A existência de funções transacionais separadas no módulo recovery não elimina a necessidade de revisar esse helper.

### E4. Ordem SQL

Primeiro consolidar contrato e testes; depois migrar consumidores; manter oxmysql antes do bridge; somente então remover imports e dependências físicas dos consumidores. Trocar o driver é trilha opcional posterior, não pré-requisito para retirar ox_lib.

<a id="estado"></a>
## 10. Bloco F — cache, sincronização e state bags

### F1. O que o cache central realmente faz

`bridge/cache/central.lua` distribui chaves selecionadas via eventos locais e exports: ped, vehicle, seat, weapon, coords, interior, dead, contagens e seatbelt.

- Esses eventos compartilham dados **entre recursos no mesmo contexto**, não entre cliente e servidor por si só.
- Valores arbitrários em cache:set não são automaticamente globais.
- Servidor, cliente e consumidores têm estruturas distintas.
- QBX ainda mantém QBX.Players e statusCache; bancos/garagem/casas mantêm caches próprios. A centralização da infraestrutura não extinguiu essas autoridades de domínio.
- TTL trabalha a cada **500 ms** no código, inclusive nas instâncias consumidoras; a tabela antiga dizia 1000 ms.
- World scan padrão está **habilitado**; no host percorre pools inteiros periodicamente. Não há pausa automática por ausência de assinantes nesse trecho.

### F2. Usos não veiculares confirmados

| Domínio | Evidência representativa | Plano necessário |
|---|---|---|
| Sessão QBX | **Migração parcial implementada em 04/10/2026; aguarda aprovação.** `client/session.lua`/`server/session.lua` substituem `isLoggedIn`; loop de fome/sede consulta morte em metadata/nativa. `loadInventory` foi substituído pelo evento de criação de personagem. | Contrato de cache consultável pelo PRBridge; manter personagem autenticado distinto de spawn concluído. Outros globais/generic handlers não foram migrados; estados veiculares preservados. |
| Interface bridge | **Implementado em 04/10/2026; aguarda aprovação no jogo.** `bridge/settings.lua` publica o domínio `interface`; configuração persistida em JSON antes de publicar. UI/Target/Interact/progresso/skillcheck sem leitura de `GlobalState.pr_bridge_ui_config`. | Snapshot inicial, deltas com geração/revisão, rehidratação entre recursos e rejeição de versões antigas. [Guia e testes](BRIDGE_UI_CACHE_2026_10_04.md). |
| Idioma bridge | **Implementado em 04/10/2026; aguarda aprovação no jogo.** Cache `pr_bridge_locale`, domínio `locale` consultável pelo PR Bridge, sem state bag. | Convars de idioma preservadas apenas como configuração/bootstrap compatível; cache autoritativo para consulta. Testados PT-BR/EN/ES/FR e aliases; [guia](BRIDGE_UI_CACHE_2026_10_04.md). |
| Dados Forge Core | server/stores/service.lua:667 publica forgeStores; objetos, NPCs, densidade, starterpack, farms, billboards, slots e spotlights também têm GlobalState. | Contratos por domínio, destinatários e revisão. |
| Voz | pma-voice/server/main.lua:26–27 usa Player.state; rádio/telefone/proximidade têm leitores/handlers. | Transporte dedicado de voz integrado pelo bridge; não substituir por cache local isolado. |
| Clima e tempo | **Migrado em 03/10/2026; aguarda teste no jogo.** Arquivos ativos do Renewed e Forge NPWD usam cache e transporte explícito, junto dos adaptadores e consumidores mapeados. | Snapshots regionais norte/sul, horário/blackout e mudanças com geração/revisão. Guia no recurso Renewed. Código `legacy/` arquivado não faz parte do manifest ativo. |
| Prisão | sv_settings.lua:263/281; sv_main.lua:58 publica jailSentence; roster usa Player.state. | Sessão/sentença e settings por contrato; preservar relógios e offline. |
| Inventário | client.lua/server.lua e modules/inventory/server.lua ainda usam estados de jogador. | Mapear invBusy/invOpen/loadInventory e demais consumidores antes de migrar. |
| Emotes/props pessoais | scully_emotemenu main/stance usam replicação pessoal. | Eventos para observadores relevantes, cleanup e ownership. |

Isso **não** significa que todas as ocorrências de Entity.state devam ser removidas. Identificar se a entidade é veículo, ped, porta ou objeto; a mesma sintaxe atende domínios diferentes.

### F3. Contrato mínimo para substituir replicação

Para cada chave: produtor, escritor autorizado, consumidores, escopo, snapshot inicial, revisão/delta, destinatários, invalidação, late join, restart, player drop, persistência e limites de payload/frequência.

- Status locais pessoais: cache local; servidor recebe agrupamento necessário.
- Dinheiro, propriedade, estoque e permissões: autoridade do servidor.
- Props estritamente ligados ao veículo: exceção veicular, conforme visão.
- Clima/voz/portas: comunicação explícita precisa preservar observadores; “não veicular” não significa “sem rede”.
- Não enviar tabelas globais completas a todos os jogadores por cada mudança pequena.

<a id="integracoes"></a>
## 11. Bloco G — comunicação fora do bridge

A retirada OX e a retirada QBX são gates diferentes. Um recurso pode estar sem OX e continuar acoplado à framework.

| Consumidor | Acoplamento representativo | Contrato a consolidar |
|---|---|---|
| forge-core | server/job/service.lua, job/payments.lua, vip/service.lua, automedic/service.lua, player/management.lua, staff/service.lua, character_slots/service.lua chamam exports.qbx_core; sync de jobs/weapons/catalogs. | Framework, economia, sessão, permissões, status, catálogos e offline pelo bridge. |
| forge-hud | server/admin-config.lua:62 consulta jobs/gangs direto. | Catálogo framework do bridge. |
| mm_radio | fxmanifest.lua:21 importa módulo QBX; server/main.lua:186 consulta jogador direto. | Player data/grupos e lifecycle normalizados. |
| ps-housing / ps-realtor | GetCoreObject direto em cliente/servidor, security/economy/management/gallery. | Framework, autorização e contas pelo bridge. |
| forge-police | backend roster, officers, court, management, tracking e outros resolvem QB/QBX direto. | Consultas/operações de domínio atrás do bridge, sem perder auditoria/permissões. |
| pr_elevator | client/main.lua e server/menu.lua mantêm resolução QB/QBX própria. | Player/grupos/catálogos pelo bridge. |
| ox_inventory | bridge/qbx/server.lua e server.lua:421 acessam QBX. | Adaptador framework e efeitos de status normalizados. Apenas auditado nesta etapa. |
| ox_doorlock | server/framework/qbx_core.lua resolve QBX. | Validar seleção ativa; unificar framework mantendo contratos de autorização. |
| qbx_idcard / segurança | Bridges Qbox e GetCoreObject próprios. | Mesma infraestrutura framework/lifecycle do bridge. |
| forge-npwd | Fontes de adapters QB/QBX mantêm integração própria; runtime compilado precisa ser conferido conforme seleção configurada. | Identidade/dispositivo/framework explícitos, sem retirar fornecedor incompatível por busca textual. |

Exemplo adicional: gestão do telefone lê `forge-core/data/jobs.json` diretamente como fallback. Mesmo sem export QBX, isso é contrato entre arquivos de recursos. Preferir API de catálogo e invalidação; não fazer leituras de disco repetidas para cada tela.

Módulos alternativos da aparência e exemplos do telefone, por estarem no pacote, não foram automaticamente classificados como caminho ativo. Confirmar manifesto/seleção antes de modificar.

<a id="desempenho"></a>
## 12. Bloco H — desempenho e capacidade

> **DESTAQUE: centralizar chamadas não prova redução de CPU, tráfego ou SQL.** Um bridge pode apenas mover o mesmo custo de lugar. A meta de 2 mil jogadores precisa de medição e orçamento de carga da base completa.

| ID | Prioridade | Condição observada | Melhoria proposta / como medir |
|---|---|---|---|
| PERF-01 | P0 | SaveAllPlayers e checkpoint aguardam cliente antes do save; flush sequencial. | Deadline curto, fallback ao último estado do servidor e concorrência limitada. Medir duração total/cauda de flush e saves falhos. |
| PERF-02 | P1 | Client status debounce 500 ms e snapshotDirty frequente. | Deltas/agrupamento por relevância; preservar morte/logout/consumo. Medir eventos e bytes por jogador/s. |
| PERF-03 | P1 | World cache usa GetGamePool nos três pools; padrão ligado. | Sob demanda, orçamento por ciclo e índices incrementais onde possível. Medir entidades/ciclo, ms, memória e churn. |
| PERF-04 | P1 | Target faz sondagem síncrona cara; markerInterval padrão 16 ms e busca por pools. | Aproveitar índices/cache e variar atualização por movimento/atividade. Medir com 0/32/100+ alvos; manter clique revalidado e paredes bloqueando. |
| PERF-05 | P1 | Pool mysql2 do telefone paralelo ao driver SQL. | Unificar caminho SQL, limitar concorrência e observar filas. Medir conexões, latência p95/p99 e operações/s. |
| PERF-06 | P1 | GlobalState transporta configurações/tabelas de vários domínios. | Deltas versionados e destinatários relevantes; snapshot apenas entrada/resync. Medir payload completo versus delta. |
| PERF-07 | P2 | TTL é percorrido a cada 500 ms por instância de cache; observers criam threads. | Não manter timers vazios; escalonar expiração/deduplicar dispatch conforme medição. |
| PERF-08 | P1 | cfg ainda development, limites de teste 64/16/16 e debug target. | Perfil de produção dedicado, testes desligados e limites dimensionados. Não elevar limites cegamente. |
| PERF-09 | P2 | Leitura direta de JSON de outros recursos e estruturas/cache duplicados. | Catálogos em memória, invalidação por revisão e contratos explícitos. Medir leituras de disco/serialização. |
| PERF-10 | P1 | Migrações SQL/ALTER e consultas amplas no boot, por exemplo Housing. | Migrações versionadas/idempotentes; revisar índices e planos reais. Não recomendar índices específicos sem EXPLAIN/dados. |
| PERF-11 | P2 | lifecycle de inventário recebe evento genérico de PlayerData. | Coalescer/notificar somente mudanças pertinentes, preservando itemCount/updateInventory. Medir rebuilds e notificações duplicadas. |
| PERF-12 | P2 | Métricas callbacks/cache não formam painel global certificado. | Agregação periódica sanitizada, histogramas e limite de cardinalidade. |

### Preservar

- Checkpoints já distribuídos por jogador.
- Save lock por citizenid, retries e revisão salva após sucesso.
- Cache automático no host, não um scanner completo por consumidor.
- Índice espacial de zonas e limites de candidatos do target.
- Limpeza em drop/stop, cancelamento e timeouts de callbacks.
- Cliente para cálculo contínuo pessoal e servidor para economia/permissões.

### Evidência exigida de capacidade

Profiler cliente/servidor, event rate/bytes, consultas/s, p50/p95/p99, filas, memória/GC, total de entidades e duração de save. Medir repouso, concentração de jogadores, alvo aberto, inventário/lojas, chamadas/rádio, banco, casas, veículos e restart.

Não converter relatos anteriores de ms em promessa de capacidade. Definir primeiro SLOs e limites; depois executar cenários de população crescente em ambiente representativo.

<a id="seguranca"></a>
## 13. Bloco I — segurança, falhas e consistência

1. **P0 — snapshots pessoais não são prova econômica.** QBX aceita valores de status com clamp; evento aceita reason death/logout e pode disparar Save. Aplicar orçamento de frequência e validação de transição; manter autonomia local sem autorizar recompensa por payload do cliente.
2. **P0 — transações e idempotência.** Compra, débito/crédito, recuperação de telefone, transferência de propriedade e estoque exigem resultado durável, compensação ou registro recuperável.
3. **P1 — callbacks seguros não autorizam negócio.** secure_server valida correlação/source esperado e limita handlers concorrentes. Isso não é rate limit de operações por segundo nem garantia de autorização de cada rota.
4. **P1 — timeout do remetente não cancela handler SQL automaticamente.** Considerar deadlines, resultado tardio, geração de sessão e cleanup de trabalhos ainda em execução após drop.
5. **P0 — identidade do aparelho diferente do portador.** Migração do telefone deve preservar registered owner/profile/device, usuário atual e gate de senha do banco. Não usar apenas source para resolver propriedade.
6. **P1 — configuração explícita/falha fechada.** Backend ausente não pode virar banco default silencioso ou lista vazia apresentada como resultado válido.
7. **P1 — sanitização.** Não logar connection string, PIN, tokens, dados pessoais completos ou payload inteiro de callbacks. O pool do telefone tem achado concreto de logging sensível.
8. **P1 — invalidação.** Logout, troca de personagem e reutilização de source exigem revisão/generation de sessão; cache antigo não pode entregar dados do personagem anterior.
9. **P1 — reinício.** Atualizar bridge central requer recarregar consumidores do init; compatibilidade não é atualização automática de módulos já residentes.
10. **P0 — economia offline.** Transferência de autoridade deve incluir SaveOffline e consumidores de contas offline, não somente jogador conectado.

<a id="sequencia"></a>
## 14. Sequência recomendada de implementação

Esta seção é **planejamento**, não autorização adicional para alterações nesta revisão.

| Etapa | Entrega | Gate de saída |
|---|---|---|
| 0 — congelar fotografia | Inventário real do FXServer, backup de configurações/schema e identificação dos consumidores ativos. | Boot e seleção de fornecedores documentados; [Docs]/segurança decididos. |
| 1 — fundação bridge | Resolver bootstrap independente; paridade QBX; readiness/erros SQL; contrato JS e transação interativa. | Testes de contrato, boot sem circularidade e reattach. |
| 2 — consumidores pequenos | qbx_idcard, gestão/banking apps e fm-logs se mantido; retirar fallbacks/dependências diretas. | Zero chamadas ao fornecedor OX real nesses caminhos e QA. |
| 3 — SQL crítico | Housing, Forge NPWD e antic-cheat se mantido, pela fundação estabilizada. | Atomicidade, rollback, segurança, restart e falha do driver testados. |
| 4 — centralização framework | Forge Core, rádio, HUD, Housing/Realtor, Police, elevator e adaptadores restantes. | Consumidores não escolhem QB/QBX; contratos públicos preservados. |
| 5 — QBX sem OX | Migrar loaders/UI/cache/callback/SQL/checks mantendo QBX como fornecedor transitório. | Login/multichar/economia/save/drop completos sem ox_lib. |
| 6 — retirar ox_lib | Ajustar cfg em janela autorizada; remover opções/adapters reais do produto final. | Boot completo sem instalar/iniciar ox_lib; teste de ausência e auditoria residual. |
| 7 — estado não veicular | Migrar por domínio snapshots/deltas do bridge; pode ser executado em lotes após fundação. | Late join, restart, observers e persistência sem state bags pessoais/globais. |
| 8 — Forge definitivo | Transferir núcleo por domínio; consolidar compatibilidade e nomes. | QBX deixa de ser fornecedor/escritor; critérios do bloco 16 aprovados. |
| 9 — desempenho final | Perfil produção, carga, soak e recuperação. | SLOs atingidos com evidências; sem promessa baseada apenas em revisão estática. |

Etapas 4 e 7 têm lotes independentes, mas não justificam alterações simultâneas sem ownership claro. Evitar misturar rename, schema, protocolo e mudança de autoridade em uma única entrega.

<a id="aceite-ox"></a>
## 15. Critérios de retirada do ox_lib

- [ ] Nenhum recurso de produto ativo importa/declara ox_lib.
- [ ] Nenhum caminho ativo dispara exports/eventos do ox_lib real.
- [ ] Checks QBX/hooks migrados, sem desligamento da base por ausência do legado.
- [ ] APIs necessárias e assinaturas homologadas sem fallback ao legado.
- [ ] Ambos os entrypoints do bridge operam com fornecedor nativo.
- [ ] OX ausente desde boot, não apenas stop após seleção de adapters.
- [ ] Comunicação SQL fora do bridge removida conforme meta, inclusive mysql2.
- [ ] Login, criação/troca de personagem, NUI, inventário, portas, casas, veículos, banco e voz aprovados.
- [ ] Restart/reconnect/drop e falhas de fornecedor não deixam filas/foco preso.
- [ ] Configuração e instruções de instalação não reintroduzem imports antigos.
- [ ] Rollback praticável e resultados anexados.
- [ ] Somente então retirar ensure e, em etapa autorizada, o pacote físico.

A política “state bags somente veiculares” é um gate arquitetural adicional. Remover ox_lib não conclui automaticamente essa política.

<a id="aceite-forge"></a>
## 16. Critérios de transferência QBX → Forge

- [ ] Mapa por domínio: produtor, escritor, consumidores, cache, transporte, persistência e recovery.
- [ ] Fundação do PR Bridge independente do fornecedor em substituição.
- [ ] Sessão/identidade/slots/termos/bans/whitelist/buckets equivalentes.
- [ ] PlayerData, grupos, money, metadata e offline com autoridade única.
- [ ] Dinheiro/inventário/estoque/propriedade sem gravações duplicadas.
- [ ] Save, SaveOffline, checkpoints, drop/shutdown e crash recovery homologados.
- [ ] Consumidores sem exports/imports QBX diretos ou bridge particular selecionando framework.
- [ ] Compatibilidade QB pública deliberada: exports, eventos, módulos e formatos.
- [ ] State bags não veiculares substituídos por contratos reais, conforme direção.
- [ ] Forge Core existente e núcleo portado consolidados sem colisão de recurso/serviço.
- [ ] Licenças e atribuições do código de origem preservadas conforme arquivos do projeto.
- [ ] Boot com QBX ausente, não apenas com alias de nome, e testes de regressão aprovados.

<a id="testes"></a>
## 17. Matriz de testes e evidências

| Bloco | Testes necessários | Evidência para fechar |
|---|---|---|
| Bootstrap | Bridge antes da framework sem seleção default definitiva; framework pronta depois; reinício e attach. | Logs sanitizados de fornecedores e exports disponíveis. |
| Paridade lib | Cada família da matriz C2, nils/múltiplos retornos, cancelamento/foco e falhas. | Testes reais de contratos + sintaxe Cfx compatível. |
| SQL | NULL, named/positional, insertId, affectedRows, batch, rollback, locks/transação dinâmica, falha e timeout. | Banco de homologação; nenhuma consulta na cidade por esta revisão. |
| Sessão | Login, termos/slots, create/delete, spawn, logout, reconexão, source reutilizado, drop abrupto. | Player/profile corretos e última cópia persistida disponível. |
| Economia | Online/offline, compras simultâneas, débito falho, repetição de request, restart durante transação. | Saldo/estoque consistente, idempotência ou recovery documentado. |
| Estado | Late join, revisão/delta, reload, troca de domínio, cleanup e destinatários. | Sem state bags não veiculares nos caminhos migrados; snapshots corretos. |
| Telefone | Dois aparelhos, troca de portador, senha do aparelho/banco, apps/widgets, recuperação e mesmo número/profile. | Propriedade e dados corretos após centralização SQL/framework. |
| Interações | Target, paredes, NPC/pickup, radial, menu/input/progress e foco NUI. | Sem OX real, sem bypass de autorização ou foco preso. |
| Callbacks | Limites, atraso, desconhecido, erro, stop, drop e source incorreto com dois jogadores em servidor fechado. | pending=0; testes invasivos bloqueados em production. |
| Carga | Crescimento populacional, entidades, flush global, rádio/call, ações concorrentes e soak. | Capturas, histogramas, filas/memória estáveis e SLOs definidos. |

### O que foi validado nesta atualização

Censo/contagens, imports e chamadas representativas, seleção dos arquivos carregados em manifests, fonte e bundle SQL do telefone, contratos/rotinas críticas e consistência documental. **Nenhuma suíte funcional FiveM ou carga foi executada.**

Há testes locais em `pr_bridge/tests`, scripts de diagnóstico no `pr_scriptTest` e roteiros de QA nos recursos. Sua presença não demonstra aprovação da versão atual; reexecutar de forma controlada quando houver implementação.

<a id="documentacao"></a>
## 18. Documentação revisada, divergências e histórico

| Documento | Uso nesta revisão | Divergência/observação |
|---|---|---|
| [FORGE_CORE_VISION.md](FORGE_CORE_VISION.md) | Direção principal: Forge definitivo, bridge central, estado local e checkpoints. | Meta de capacidade é objetivo, não homologação; retirada de state bags já era descrita como pendente. |
| [OX_COMPATIBILITY.md](OX_COMPATIBILITY.md) | Compatibilidade de interface e preservação de lib existente. | Próximas etapas antigas não representam todo avanço atual; alias lib parcial continua importante. |
| [functions_cache_callback_addendum.md](functions_cache_callback_addendum.md) | Contratos de cache/callbacks e convars. | Defaults documentados não são os limites temporários ativos no cfg. |
| [API_FUNCTIONS.md](API_FUNCTIONS.md) | Índice de APIs por módulo/contexto. | Listar nome não certifica fornecedor/semântica; database no cliente é stub, não acesso SQL autorizado. |
| [functions_datails.md](functions_datails.md) | Consulta técnica direcionada por índice, cache/framework/SQL. | Catálogo extenso; não certificado integralmente nesta revisão. |
| [TARGET_NATIVE.md](TARGET_NATIVE.md) | Contratos, filtros, zonas e setup. | Alguns statuses são históricos; doc ainda usa GlobalState para UI. |
| [TARGET_RUNTIME_AUDIT_2026_09_21.md](TARGET_RUNTIME_AUDIT_2026_09_21.md) | Evidência de revisão do target. | Descrição inicial assíncrona foi superada pelo trecho posterior síncrono; código atual confirma native síncrona. |
| [FIXES_2026_09_20.md](FIXES_2026_09_20.md) | Correções/validações locais e roteiro em jogo. | Sequência de revisões não deve ser lida como uma implementação única; separar logs históricos do código atual. |
| [INTERACT_NATIVE.md](INTERACT_NATIVE.md) | API/runtime central de interação. | Verificar cleanup/foco na homologação conjunta. |
| [GIZMO.md](GIZMO.md) | API modal e editor central. | Mantido como especificação funcional; não reauditoria visual do editor. |
| [GARAGE_BRIDGE.md](GARAGE_BRIDGE.md) | Contratos residenciais e seleção de garagem. | Seleção de fornecedor não migra ownership/banco automaticamente. |
| [Histórico integral](OX_LIB_MIGRATION_HISTORY_2026_10_01.md) | Preserva plano, IDs, exemplos e relatos anteriores. | Não usar como fotografia vigente. |

### Correções de interpretação incorporadas

- “Só QBX falta” → há resíduos em apps, moradia, segurança e pool SQL do telefone.
- “State bags só veículos” → meta, ainda não estado real da base.
- “Todos passam pelo bridge” → imports comuns coexistem com exports/framework/arquivos diretos.
- “Crafting inativo não migrado” → manifest com bridge e entrada ativa no cfg.
- “Forge Core ainda tem MySQL de jobs” → não confirmado no código Lua atual varrido; problema atual relevante é framework direto/estado.
- “Transações alternativas ausentes” → implementações existem; falta certificar, e transaction interativa é lacuna distinta.
- “Telefone sem SQL direto” → falso para Forge NPWD: pool mysql2 confirmado também no bundle carregado.
- “92,3% / 65 recursos” → denominador desatualizado e critérios misturados; substituído por inventário atual sem percentual de homologação.
- “Cache mundial opt-in/pausado sem assinantes” → código padrão ligado e varredura periódica; TTL de 500 ms por instância.
- “Uma mudança no bridge propaga em execução” → fonte central propaga na recarga, não substitui módulos já importados.

### Manutenção futura

Atualizar o bloco específico após cada lote: arquivos/contratos alterados, status estático, QA com versão/cenário, métricas e rollback. Recalcular censo quando resources/boot mudar; não incrementar percentuais manualmente. Backlog funcional antigo permanece no histórico para triagem, sem ser declarado corrigido por esta revisão documental.

**Próximo passo seguro:** autorizar um lote de implementação da fundação/paridade/bootstrap do PR Bridge, com escopo e critérios definidos. A auditoria não executou essa implementação.
