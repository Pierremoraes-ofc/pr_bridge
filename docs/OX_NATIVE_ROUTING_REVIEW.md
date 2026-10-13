# Revisão: compatibilidade nativa, não outro ox_lib

PR Bridge **1.4.2** · referência local **ox_lib 3.38.0** · revisão **10/10/2026**

## Diagnóstico confirmado

O host carregava implementações de versão, ACE, propriedades de veículos, estado, progresso e posicionamento de entidades em `bridge/compat/ox_services`. Existiam APIs PR equivalentes, mas elas eram contornadas por uma segunda implementação. O inventário anterior conferia arquivos, hashes e nomes públicos; não distinguia redirecionamento de cópia. Por isso aqueles testes podiam passar sem garantir a arquitetura solicitada.

Não era necessário reimplementar o setter de veículos nem o verificador de versões. Também foram encontradas cópias em imports utilitários. A correção foi feita no PR Bridge, sem modificar ox_lib, qbx_core, forge-core, recursos consumidores ou a ordem de inicialização.

## Correção dos serviços

Foram excluídos os nove arquivos redundantes de `ox_services`, não apenas renomeados. A referência original continua intacta em `resources/[ox]/ox_lib`; os arquivos retirados eram a camada duplicada adicionada ao PR Bridge.

| Área | API canônica reutilizada/ampliada | O que fica no compat |
| --- | --- | --- |
| Versão/dependências | `github.versionCheck/checkDependency` | Versão virtual de contrato para o nome ox_lib |
| Propriedades de veículos | `fivem.vehicleProperties.get/set`, acrescida de `queue/applyQueue` | Chaves/eventos antigos, política de trava e assinatura |
| ACE | `fivem.ace` | Referências diretas aos métodos nativos |
| Progresso | Motor `progressbar/native/client`, props nativos cliente/servidor | Nomes antigos, retorno de atividade e cancelamento obrigatório |
| State bags | `fivem.state.requestSet` | Autorização pelos hooks legados e protocolo de callback |
| Posicionamento no chão | `fivem.streaming.placeEntityProperly` | Espera pela entidade e nome da state bag antiga |

As lacunas necessárias foram implementadas na biblioteca nativa: fila de veículos aguardando autoria/streaming; interrupções contínuas, animações, controles, props replicados e restauração de `invBusy` no progresso; escrita de estado validada e autorizada. A validação/persistência de props é compartilhada pelos transportes antigo e nativo.

O progresso deixou de instanciar um motor por consumidor no host. O encerramento de um consumidor diferente não cancela a atividade do proprietário atual.

## Imports consolidados

A primeira etapa consolidou 32 arquivos. A etapa atual fechou os outros 39: **todos os 71 imports** são aliases/adaptadores para a implementação canônica. Foram concluídas **202 entradas anteriormente pendentes** (funções, métodos e aliases). O catálogo total contém 311 entradas, não 311 motores independentes.

Na primeira etapa:

- Os oito loaders de assets e `streamingRequest`.
- `math`, `table`, `string`, `timer` e `waitFor`.
- `raycast`, `playAnim`, `triggerClientEvent`, `addKeybind`, comandos atual/antigo e `disableControls`.
- Os dez imports cliente/servidor de proximidade/entidade mais próxima.
- `points`.

Proximidade reutiliza os pools e cálculos da API `fivem.objects`. Os pontos nativos foram extraídos de `init.lua` para `bridge/fivem/spatial/client.lua`; o import antigo não mantém outro agendador. O módulo de controles também é único, com modo de contagem de referências para o contrato ox.

O carregador tem cache por consumidor e reutiliza tabelas nativas já inicializadas. Importar `@ox_lib/init.lua` não força o carregamento de adapters de framework dentro do próprio core.

## Por que ainda existem adaptadores e contratos legados

Redirecionar não significa ignorar diferenças. Exemplos:

- PR retorna `sucesso, hash` no loader; ox retorna o asset ou lança erro.
- O segundo argumento de callback no cliente ox é throttle, não timeout PR. Eventos de resposta também têm nomes diferentes.
- Merge de tabelas, busca por valores, campos do resultado de proximidade, ordem de raycast e formato de argumentos de comandos precisam de conversão.
- O contrato de classes/coleções, DUI/entidades e zonas legadas tem métodos/estado que não existem completos na fachada nativa anterior.

**Os outros 39 arquivos também foram consolidados.** As APIs que não existiam completas ganharam implementação canônica pública, consumida por scripts novos PR e pelo legado. DUI e criação de entidades delegam aos motores nativos existentes. Callback usa um motor RPC único para os dois transportes; o antigo motor parcial de zonas foi removido. O compat mantém apenas envelopes, aliases e conversão de contratos. Evidências, namespaces e limites: [OX_NATIVE_LIBRARY_COMPLETION.md](OX_NATIVE_LIBRARY_COMPLETION.md).
## Verificação

- `tests/native_library_test.lua`: 202 entradas expostas, identidade de aliases, delegação a motores existentes e comportamentos representativos de coleções, loader, entidades, DUI, scaleform e cron.
- `tests/ox_compat_test.lua`: sintaxe normalizada de 95 composições, boot cliente/servidor, exports e coexistência; identidade/encaminhamento dos métodos nativos; callbacks; utilitários; loaders; comandos; proximidade; pontos/controles; progresso/props; validação de estado e fila de veículos com autoria simulada.
- Regressões existentes de keybind, Interact, scroll, perspectiva, ancoragem e custo simulado de Target passaram, assim como o teste de contrato dos menus Svelte/Vue.
- `scripts/audit_ox_compat.mjs` agora distingue imports nativamente encaminhados de contratos específicos, verifica hashes dos módulos canônicos e rejeita a reintrodução de arquivos Lua em `ox_services`.

Não foi iniciado/reiniciado nenhum recurso de produção. Rede real, props entre dois jogadores, streaming, transferência de autoria e compilação CFX Lua 5.4 ainda exigem homologação no FiveM. O runner offline é Lua 5.5, com normalização apenas em memória; nenhuma medição aqui representa resmon real.
