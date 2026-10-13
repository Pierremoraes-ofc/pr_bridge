# Visão de arquitetura da Forge-Core

Direção definida pelo proprietário do projeto em 2026-09-07. Este documento registra a arquitetura desejada e orienta o plano de migração. Não representa uma declaração de migração concluída nem de capacidade homologada.

## Objetivo

O `forge-core` se tornará o framework da base, substituindo gradualmente o `qbx_core` até sua retirada. A prioridade é reduzir trabalho repetitivo, comunicação desnecessária e picos de persistência, mantendo consistência nos dados que afetam economia e sessão. A meta de projeto é suportar 2 mil jogadores; a capacidade efetiva depende de medição da base completa sob carga.

## Os dois componentes permanentes

### Pierre Bridge — `pr_bridge` / `pr_lib`

É a biblioteca central de conhecimento, acesso a dados e comunicação da base. Recebe informações de jogadores, recursos e servidor, mantém caches e oferece contratos estáveis para consulta, observação e atualização. Um consumidor não precisa conhecer o recurso produtor nem os demais consumidores.

Centraliza mecanismos de cache, invalidação, transporte, acesso à persistência e adaptadores. Os serviços de domínio definem quem pode escrever, o significado de cada dado e quando ele precisa ser salvo. Guardar uma cópia no bridge não transfere para ele as regras de negócio do framework.

O cache tem contextos distintos: cada cliente mantém seu estado local e o servidor mantém seu próprio estado. Compartilhamento entre recursos no mesmo contexto não exige tráfego de rede. Uma consulta local não consulta automaticamente o servidor nem o banco. Dados remotos chegam por contratos explícitos de sincronização.

### Forge Core — `forge-core`

É o futuro framework e o responsável pelas regras de sessão, personagens, economia, propriedade, permissões e recompensas, conforme cada domínio for migrado. Usa os mecanismos do `pr_bridge` para evitar integrações particulares e duplicação de infraestrutura.

O `qbx_core` é transitório. Continua responsável pelos domínios ainda não migrados, com seus contratos preservados até a substituição. Cada domínio deve ter um único responsável por escrita; uma cópia em cache não é uma segunda autoridade.

## Distribuição de responsabilidades

| Informação ou operação | Responsabilidade |
|---|---|
| Animação, HUD, efeitos visuais e cálculo contínuo de necessidades | Cliente |
| Existência e remoção do consumível | Servidor, aproveitando a operação do inventário |
| Evolução de fome, sede e estresse | Cliente, com sincronização agrupada conforme a política do projeto |
| Efeitos autorizados de consumíveis | Configuração resolvida no servidor no fluxo já existente; aplicação local e atualização da cópia do servidor sem confirmação individual por atributo |
| Dinheiro, estoque, propriedade e concessão de recompensas | Servidor, operando sobre estado em memória |
| Entrada, saída, morte, revive e troca de personagem | Fluxos de sessão coordenados pelo servidor |
| Persistência | Importância do dado, alterações acumuladas, checkpoints escalonados e eventos de sessão |
| Histórico de operações relevantes | Registros próprios da operação; um snapshot final não substitui o histórico |

O cálculo e a apresentação locais de vida e colete não tornam um snapshot do cliente prova independente para autorizar recompensas ou transições de sessão. As verificações necessárias devem acompanhar o fluxo relevante, sem criar consultas SQL contínuas.

## Consumo de itens

1. O inventário recebe e valida o uso sobre seu estado carregado no servidor.
2. A operação de consumo resolve o item, sua configuração e a remoção necessária.
3. Esse mesmo fluxo aproveita os efeitos autorizados para atualizar a cópia em cache do servidor e informar o cliente.
4. O cliente aplica efeitos e mantém a evolução local e o HUD.
5. Alterações relevantes são consolidadas nos checkpoints e nos eventos de sessão.

Não criar uma requisição de confirmação para cada mudança de fome, sede, estresse ou efeito visual. O contrato deve impedir que o mesmo consumo seja aplicado novamente ao reconciliar um snapshot. Cancelamentos e falhas de remoção não devem conceder efeitos de um consumo não concluído.

## Cache, sincronização e state bags

A direção é retirar state bags de estados pessoais, peds, objetos e demais usos não veiculares. Cinto de segurança e outros estados estritamente pessoais ficam no cache local; envio ao servidor só se houver um consumidor com necessidade definida.

A exceção prevista são veículos e dados ligados ao veículo que precisam de replicação, incluindo referências e configurações de props anexados. Mesmo para veículos, apenas os campos que precisam ser compartilhados devem ser replicados.

Para dados não veiculares que realmente precisem cruzar cliente/servidor, usar contratos explícitos do bridge, com destinatários, snapshots ou alterações incrementais e limites definidos. Uma API semelhante a state bag não reproduz automaticamente sua replicação.

A retirada de state bags é uma direção arquitetural, não uma certificação do código atual. A leitura de 2026-09-07 ainda encontrou `GlobalState.forgeStores` no forge-core e estado de sessão de jogador no qbx_core. Esses usos precisam de migração com equivalência funcional; não podem ser removidos apenas por busca textual.

## Persistência e distribuição de carga

O caminho preferido é carregar dados, trabalhar em memória, marcar alterações e persistir conforme a política do domínio. Atualizar cache ou metadata em memória não significa gravar no banco.

Os checkpoints devem distribuir jogadores ou pequenos grupos ao longo do ciclo, evitando uma atualização global simultânea. O qbx_core atual já contém distribuição por jogador em `server/status.lua`, calculando o intervalo a partir do ciclo e da população; isso é uma base existente a preservar e aperfeiçoar, não uma entrega nova deste documento.

Definir limites de concorrência, agrupar pedidos repetidos e evitar que um cliente lento bloqueie o salvamento dos demais. Entrada carrega o estado; morte, revive, logout e desconexão tratam a transição e persistem conforme sua importância. Em desconexão abrupta, salvar a última cópia disponível no servidor: não há garantia de receber um snapshot final do cliente.

Checkpoints espaçados limitam a perda de estado pessoal recente. O intervalo exato e a tolerância de perda ainda precisam ser definidos e medidos. Dados econômicos exigem confirmação durável ou um mecanismo recuperável antes de considerar a operação concluída.

JSON é adequado para configurações, catálogos e snapshots conforme o domínio. Não é obrigatório como intermediário antes do banco. A escrita de um arquivo inteiro a cada ação também custa serialização e disco. Uma fila em memória precisa de política de falha e recuperação quando carrega operações que não podem ser perdidas.

## Migração gradual do QBX

1. Mapear produtores, consumidores e responsáveis por cada domínio.
2. Estabilizar o contrato público no `pr_bridge` e direcionar consumidores para ele.
3. Implementar o domínio correspondente no `forge-core` e validar comportamento e persistência.
4. Transferir a responsabilidade de escrita, evitando execução e salvamento duplicados.
5. Manter compatibilidade necessária para consumidores ainda não migrados.
6. Retirar o `qbx_core` quando não houver dependências ativas e os fluxos de sessão, economia e persistência estiverem homologados.

A autorização desta atualização é documental. Não executa a retirada do QBX nem muda contratos em funcionamento.

## Situação e próximos critérios de aceite

- Direção aprovada: autonomia local para necessidades, inventário e economia no servidor, bridge como biblioteca central e Forge como framework definitivo.
- Implementação existente: status locais e checkpoints distribuídos no QBX. O cliente ainda envia snapshots após alterações com debounce padrão de 500 ms; reduzir essa frequência exige ajuste posterior.
- Documentação histórica: referências a autoridade permanente do QBX e status integralmente autoritativos no servidor são superadas por esta visão.
- Pendente: mapa por dado com produtor, escritor, consumidores, contexto do cache, sincronização, destino persistente e tratamento de falhas.
- Pendente: medir eventos por segundo, bytes replicados, consultas e latência do banco, filas, memória e tempos de execução em repouso e sob carga.
- Pendente: homologar consumo/cancelamento, morte/revive, logout/desconexão, troca de personagem, restart e recuperação de operações econômicas.
- Pendente: demonstrar capacidade para a população pretendida com cenários representativos, incluindo jogadores concentrados e salvamentos simultâneos.

Os tempos relatados pelo proprietário (cliente entre 0,13 e 0,28 ms; servidor entre 0,02 e 0,03 ms) são referências observacionais sem captura de profiler anexada. Não constituem comprovação de capacidade para 2 mil jogadores.

## Documentos relacionados

- [Plano de migração e backlog operacional](OX_LIB_MIGRATION_PLAN.md)
- [Contratos de cache e callbacks](functions_cache_callback_addendum.md)
