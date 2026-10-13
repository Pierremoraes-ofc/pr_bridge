# Compatibilidade ox_lib / ox_target no PR Bridge

PR Bridge: **1.4.2**. Contrato de referência: **ox_lib 3.38.0 da distribuição local**.

Implementação integrada ao próprio `pr_bridge`, sem recurso separado de compatibilidade e sem a NUI original do ox_lib. A revisão de 10/10/2026 removeu os nove arquivos duplicados de `ox_services`: a compatibilidade dos serviços usa as APIs nativas PR. **A homologação dentro do FiveM ainda está pendente**; testes offline não são uma declaração de compatibilidade de 100%.

## O que foi incorporado

| Camada | Implementação |
| --- | --- |
| Importação Lua | `@ox_lib/init.lua` atendido pelo PR Bridge; utilitários carregados sob demanda no ambiente do consumidor. |
| Utilitários | 71 arquivos, 59 módulos e 63 símbolos de primeiro nível, incluindo classes, coleções, callbacks, require, locale, zonas e helpers de entidades. |
| Serviços | 49 nomes de funções encontrados nos arquivos de recurso da referência, inventariados por contexto e assinatura; getters, foco, permissões, versão, cache e propriedades de veículos. |
| Interface | Context, menu de lista, input, alert, notify, TextUI, progresso, radial e skillcheck usando renderização PR. Componentes de compatibilidade compilados em Svelte e Vue. |
| Target | Nomes legados de exports encaminhados à API nativa PR, mantendo autoria, remoção e estrutura pública das opções. |
| Idiomas | 33 arquivos de tradução da biblioteca de referência, preservando também os locales próprios de cada consumidor. |

Esses totais não incluem cada método interno de uma classe e não devem ser somados como um total de funções testadas em jogo. O inventário completo, com hashes da referência e do código incorporado, está em [ox_compatibility_inventory.json](ox_compatibility_inventory.json).

## Arquitetura: implementar uma vez, adaptar na borda

| Chamada antiga | Implementação canônica |
| --- | --- |
| `lib.getVehicleProperties / setVehicleProperties` | `fivem.vehicleProperties.get / set / queue / applyQueue` |
| `lib.checkDependency / versionCheck` | `github.checkDependency / versionCheck` |
| `lib.addAce / removeAce / addPrincipal / removePrincipal` | `fivem.ace` |
| `lib.progressBar / progressCircle` | `bridge/progressbar/native/client.lua` e publicador/renderizador nativo de props |
| Escrita de state bag solicitada pelo cliente | `fivem.state.requestSet`, com política de hooks nativa compartilhada e nomes legados na borda |
| Helpers de streaming, raycast, proximidade e pontos | Módulos nativos `fivem.streaming / raycast / proximity` e `fivem/spatial` |
| Tabelas, números, strings, timers, espera, comandos, teclas e controles | Utilitários/módulos nativos PR; assinaturas adaptadas nos imports |

**Os 71 arquivos de imports agora encaminham para implementações canônicas**, diretamente ou por adapter de assinatura/protocolo. As 202 entradas anteriormente pendentes foram consolidadas: o catálogo contém **311 entradas**, incluindo métodos e aliases, sem pendência de consolidação. Coleções, classes, arquivos/localização, hooks, cron, logging, markers e scaleforms são também APIs públicas em `pr_lib.library`; DUI/criação/estado reaproveitam motores existentes. O motor parcial antigo de zonas foi substituído pelo serviço completo único. O bootstrap permanece independente de framework.
Detalhes importantes de contrato:

- O loader nativo de modelo retorna `sucesso, hash`; o import ox retorna somente o hash ou lança erro. Weapon assets preservam o argumento original, e não o hash retornado pelo PR.
- `raycast.fromCamera` tem ordem de parâmetros diferente; a borda apenas reorganiza argumentos.
- `table.contains` do ox busca valores, não chaves; `table.merge` soma números por padrão. Essas opções pertencem ao utilitário nativo, e o adaptador escolhe os defaults antigos.
- Comandos usam o parser, permissões e sugestões nativos. O adaptador converte definições antigas e a forma dos argumentos; comandos legados solicitam ACE estrita, sem ampliar permissões por whitelist administrativa.
- A fila nativa de propriedades aceita a chave de state bag antiga; não contém outro setter de veículos. A política `ox:setLockState` permanece na borda.
- Animações, interrupções, `invBusy`, props e limpeza de progresso foram consolidados no motor nativo, não copiados para outro serviço ox.

Detalhes e exemplos: [OX_NATIVE_LIBRARY_COMPLETION.md](OX_NATIVE_LIBRARY_COMPLETION.md). `tests/native_library_test.lua` verifica a exposição das 202 entradas e compartilhamento de implementação, além de comportamentos representativos. Isso não substitui teste com CFX/GLM/rede reais.
## Como funciona sem editar cada script

O manifesto do PR Bridge declara `provide` para `ox_lib` e `ox_target`, usando o [mecanismo oficial do FiveM](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#provide). A resolução dos exports legados é registrada separadamente dentro do PR Bridge: declarar `provide` sozinho não registra outro nome de export.

Um consumidor Lua padrão pode manter seu manifesto:

```lua
shared_script '@ox_lib/init.lua'
dependency 'ox_lib'
-- Se já usa target:
dependency 'ox_target'
```

E manter suas chamadas:

```lua
lib.registerContext({
    id = 'exemplo',
    title = 'Atendimento',
    options = { { title = 'Consultar documentos' } }
})
lib.showContext('exemplo')

exports.ox_target:addLocalEntity(ped, {
    { name = 'consultar_documentos', label = 'Consultar documentos',
      onSelect = function(data) print(data.entity) end }
})
```

Não é necessário duplicar o script, substituir todas as chamadas ou adicionar um recurso de compatibilidade. Scripts novos continuam podendo usar `@pr_bridge/init.lua` e `pr_lib`; suas APIs nativas não passam a ter a assinatura diferente dos callbacks ox.

## Inicialização e troca segura

1. Faça a primeira validação em uma cópia de testes da cidade.
2. Mantenha as pastas originais disponíveis para retorno. Não as apague para testar.
3. Para testar o PR como substituto, deixe os recursos originais sem iniciar e inicie `pr_bridge` **antes** dos consumidores de ox_lib/ox_target. Se o original instalado estiver parado e o PR ainda não tiver iniciado, não conte com a seleção automática do substituto.
4. O core pode carregar depois do PR, inclusive se depender de ox_lib. O PR atualiza suas conexões com os backends prontos e preserva as referências de suas tabelas; isso não altera o código do core.
5. Ao trocar entre original e substituto, reinicie o PR e os consumidores. A alternativa mais previsível em homologação é uma inicialização completa da cópia de testes.

Exemplo conceitual da ordem, **não aplicado automaticamente ao seu servidor**:

```cfg
# Bibliotecas e serviços independentes necessários à sua base vêm antes.
ensure pr_bridge
# Depois, o core e os demais consumidores, na ordem exigida pela base.
```

Se o ox_lib/ox_target original estiver em execução, ele continua responsável pelas chamadas legadas. O PR não deve tomar seus exports. Isso também significa que testar com o original ativo não comprova o funcionamento do substituto. Não há troca transparente a quente: o FiveM mantém referências de exports em cache.

## Contratos preservados e diferenças intencionais

- `lib.callback.await` mantém o protocolo ox e seus parâmetros: no cliente, o segundo argumento é o intervalo de limitação de chamadas; no servidor, é o ID do jogador. Não é o timeout da API nativa PR. Retornos contendo `nil` são preservados.
- Menus de lista têm seleção por teclado, valores laterais, checkbox, índice inicial, `canClose`, `close=false`, `onSelected`, `onSideScroll`, `onCheck` e `onClose`. O suporte ao teclado inclui o encaminhamento da janela principal do FiveM.
- Menus, diálogos e TextUI coordenam seu estado entre consumidores, mantendo as funções de cada script isoladas. Reiniciar um consumidor limpa seus registros e atividades.
- Progresso usa um único motor nativo para interrupções por estado do personagem, `invBusy`, animações, cancelamento e props replicados. Os nomes antigos de eventos/state bags são traduzidos pelo adaptador. A conclusão é controlada pelo Lua; solicitações de props e state bags recebem validações no servidor.
- Radiais aceitam itens de submenu sem ID e callbacks por nome de export. O atalho legado é registrado como `+ox_lib-radial` em Z; o atalho nativo do PR continua disponível.
- Notify aceita posição, ícone, cor, animação do ícone, alinhamento, estilo e exibição da duração. Áudio explícito pode ser habilitado com `setr pr_bridge:ox_compat:notificationAudio true`; permanece desabilitado por padrão.
- Visual, fontes, ícones e animações são os do PR Bridge. Não há promessa de reprodução pixel a pixel do frontend antigo nem de todas as suas extensões privadas de Markdown/HTML/CSS.
- O Interact mantém a mecânica, os controles, o layout Clean, contornos e perspectiva já existentes. Esta integração não migra novamente o inventário nem altera recursos consumidores.

## Limites que precisam ser considerados

- **Versão lida diretamente do manifesto:** `lib.checkDependency('ox_lib', ...)` trata a versão de contrato 3.38.0. Já um script que lê `GetResourceMetadata('ox_lib', 'version', 0)` diretamente pode receber a versão 1.4.2 do PR, pois o recurso substituto tem um único manifesto. Essa leitura não tem equivalência garantida sem ajuste específico do consumidor.
- **Arquivos e eventos internos:** leitura de `resource/settings.lua`, caminhos do frontend antigo, callbacks NUI privados e ferramentas de desenvolvimento do recurso original não fazem parte desta camada pública de compatibilidade. Imports públicos catalogados são incluídos.
- **Dependências fora da biblioteca:** fornecer ox_lib não fornece inventário, banco de dados, framework ou outras dependências que um script exija.
- **Plataforma:** o alvo é FiveM/GTA V. Não foi homologado RedM.
- **Outros runtimes:** exports chamados por JavaScript/C# e comportamentos de rede precisam de validação real no FiveM; testes Lua e navegador não substituem essa etapa.
- **Desempenho:** os testes de custo contam chamadas simuladas; não são uma medição de resmon nem uma garantia de tempo em milissegundos.

## Verificações realizadas

- 95 combinações de imports compartilhados/cliente/servidor verificadas quanto à sintaxe, além dos arquivos de integração e renderização modificados.
- Encaminhamento aos métodos nativos verificado por identidade de função/spies: versão, ACE, propriedades, loaders, comandos e proximidade; opções legadas de utilitários, pontos/controles e validação de state bags exercitadas.
- Fila nativa de veículos testada com troca simulada de autoria, aplicação pelo setter único e limpeza; cancelamento de progresso por outro consumidor não interrompe o proprietário ativo.
- Boot simulado cliente/servidor, descoberta dos exports de referência, coexistência com original, callbacks, autoria e limpeza.
- Importação sem editar `@ox_lib/init.lua`, carregamento independente do core, require e globals do consumidor.
- Menus, coordenação entre scripts, radial, target, progresso, cancelamento, timers antigos e restauração do inventário.
- Builds Svelte/Vue e testes de navegador para menus, teclas encaminhadas, rolagem de listas longas, prioridade de modal, notify, progresso, radial, target e skillcheck.
- Regressões de Context, Interact, scroll em várias taxas de quadros, perspectiva, âncoras e orçamento de chamadas do Target/Interact; permissões e persistência do painel de configuração.

Os testes Lua usam um interpretador local 5.5 com normalização **somente em memória** das extensões de sintaxe do CFX e da diferença nos iteradores. Os arquivos de produção não são reescritos por essa normalização. A compilação e execução no CFX Lua 5.4 continuam sendo uma etapa distinta.

Para conferir a integridade sem iniciar a cidade:

```powershell
node scripts/audit_ox_compat.mjs
node tests/ox_menu_test.mjs
```

Para comparar novamente com uma instalação ox_lib:

```powershell
node scripts/audit_ox_compat.mjs 'caminho/para/ox_lib'
```

O auditor é somente leitura. Os testes completos estão em `tests/ox_compat_test.lua` e `tests/ox_menu_browser_test.cjs`; regressões de custo reutilizam o harness local de testes da base, sem editar esse harness.

## Checklist obrigatório no FiveM

- [ ] Inicialização limpa com os originais ativos; nenhuma interceptação indevida.
- [ ] Inicialização limpa com os originais parados e PR já iniciado; core e consumidores sem alterações.
- [ ] Import Lua legado, callbacks cliente/servidor e exports diretos de ox_lib/ox_target.
- [ ] Context, lista, input de cada tipo, alert, notify, TextUI, progresso, radial e skillcheck.
- [ ] Props visíveis para dois jogadores; término, cancelamento, morte e desconexão sem resíduos ou `invBusy` preso.
- [ ] Propriedades de veículos, state bags, transferência de autoria e streaming de entidades.
- [ ] Target em entidades locais/de rede, modelos, zonas, grupos, itens, distância, paredes e remoção ao reiniciar scripts.
- [ ] Reinício de consumidores com UI aberta; foco e registros liberados.
- [ ] Export consumers JavaScript/C# usados pela base, quando existirem.
- [ ] Medição de resmon na máquina real, com Interact/Target ativos e inativos.

Só depois desta homologação é seguro tratar a substituição como aprovada para a cidade. Nenhum recurso original foi parado, nenhum core foi editado e nenhuma configuração de inicialização foi alterada nesta implementação.

## Créditos

Utilitários, protocolos e serviços de referência: [Overextended/ox_lib](https://github.com/overextended/ox_lib). API de referência de Target: [Overextended/ox_target](https://github.com/overextended/ox_target). Integração e renderização: PR Bridge. Os avisos e as licenças incorporadas estão em [OX_NOTICE.md](../licenses/OX_NOTICE.md).
