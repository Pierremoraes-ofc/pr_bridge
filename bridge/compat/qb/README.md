# QBCore → framework selecionada no PR Bridge

Compat de **origem QBCore**, baseado no código local
`[Docs]/[frameworks]/qb-core-main`. Não é outro core de jogadores.

```text
script QB → GetCoreObject → fachada QB
  → Bridge.framework.QBCore → adaptador da framework selecionada
    → funções PR de jogador/emprego/dinheiro
    → Bridge.inventory → inventário selecionado
    → serviços PR de notificações/progresso/propriedades/callbacks
```

Não presume ox_inventory por usar QBX. Todas as declarações do catálogo são
preservadas, mesmo sem equivalente. A ausência gera diagnóstico com framework,
inventário, operação e recurso chamador; não simula sucesso nem troca de inventário.

## Configuração e coexistência

```lua
compatFramework = 'forge', -- auto/forge ou destino explícito que corresponda ao core ativo
compatQBCore = true,
compatQBAccounts = { cash = 'cash', bank = 'bank' },
compatQBConfig = {},
```

`compatQBCore=false` desliga o host de origem QB independentemente do compat ESX.
`compatFramework=false` desliga os hosts de frameworks. O contrato público dos
adaptadores continua disponível para código PR; nenhum core é iniciado/trocado.

Nesta base, **QBX já fornece qb-core**. O novo host reutiliza
`exports['qb-core']:GetCoreObject()` nativo e não registra eventos/callbacks/exports
legados adicionais. O convar `qbx:enablebridge` precisa continuar habilitado no
QBX; nenhum convar do servidor foi alterado por esta implementação.

Com QBCore original também usa o objeto original. Não substitui seu player store.
Para consumidores multiframework, consulte [seleção e bloqueio de rotas](../FRAMEWORK_ROUTING.md).
Se um core QB original estiver ativo junto a outro destino selecionado, recusa
esse conflito em vez de encaminhar escritas para o core errado.

Para **ESX/ND/Ox/TMC/custom/standalone sem QB/QBX**, a fachada registra os exports
legados `qb-core`, inclusive `GetCoreObject` e `GetShared`. Se o script declarar
`dependency 'qb-core'` ou importar `@qb-core/...`, habilite o `provide('qb-core')`
comentado no manifest de PR Bridge. **Não habilite esse segundo alias nesta base
QBX**, que já o fornece. Ao usar ESX original, comente também o alias es_extended
de PR Bridge, conforme as instruções do compat ESX.

Entradas suportadas:

```lua
local QBCore = exports['qb-core']:GetCoreObject()
local only = exports['qb-core']:GetCoreObject({'Functions', 'Shared'})
local explicit = exports.pr_bridge:getQBCoreObject()
```

Opcionalmente, `bridge/compat/qb/consumer.lua` cria a variável global QBCore no
consumidor. `shared/locale.lua` preserva o caminho público de Locale para a fachada.
Não redireciona arquivos internos arbitrários, consultas SQL qb-core nem recursos
separados (society, garagens, multicharacter, inventário etc.).

## Implementações e limites

- Lookup de jogador/source/identificador, listagem e consultas de emprego/duty.
- Snapshot QB de jogador, job.grade.level, dinheiro, metadata, charinfo e itens.
  `citizenid` representa o identificador real do personagem no destino; não cria
  uma nova identidade QB. `GetIdentifier` continua sendo identificador de rede.
- Carteiras mapeadas, SetJob/SetJobDuty/SetMetaData e operações de inventário.
  Slots, amount/count e info/metadata são traduzidos preservando conteúdo.
  HasItem aceita nome, lista ou mapa. GetItemByName escolhe o primeiro slot.
- Nome de jogador e GetPlayerData; métodos de extensão só alteram a fachada.
  Campos de autoridade não podem ser sobrescritos por SetPlayerData genérico.
- AddItem/AddItems **em Functions** registram definições; AddItem em
  **Player.Functions** entrega itens. RemoveItem de definições não é confundido
  com remover unidades do inventário de um jogador.
- CreateUseableItem usa o inventário selecionado e protege propriedade do registro.
  Recria o registro após restart do inventário e usa um dispatcher por item,
  evitando callbacks antigos bloqueando o item após restart do consumidor.
- Shared.Items/Jobs/Gangs/VehicleHashes/Vehicles vêm do destino. No cliente os
  catálogos do servidor são carregados via RPC com prazo de 10s e cache do host;
  não são cópias de tabelas estáticas de QB. Alterações externas posteriores do
  catálogo precisam de nova sessão/restart para invalidar esse cache nesta etapa.
- Notificações, progresso e várias funções de modelos/entidades/propriedades do
  cliente usam serviços PR/FiveM. Spawns e streaming são limitados, sem loops
  permanentes novos. Helpers não adaptados mantêm handlers de ausência.
- RPC PR com ids únicos, validação do remetente, limite 64 requisições/10s por
  jogador, timeout 10s, retornos múltiplos/nil e limpeza de callbacks por recurso.
  Compatibilidade com eventos manuais antigos é um subconjunto documentado no host.
- Commands.Add/Refresh verificam permissões reais do destino; não criam grupos
  administrativos nem concedem ACEs automaticamente.

**Não é compatibilidade integral homologada.** O catálogo mantém 64 declarações
server, 44 client e os métodos de jogador/lifecycle/shared. Funções de login,
criação/exclusão de personagens, offline players, substituição integral de
inventário, bans, permissões mutáveis, geradores de identidades e helpers sem
equivalente confirmado continuam declaradas, com tratamento explícito de ausência.
Não há criação de tabelas SQL QB, cadastro de identidades fictícias, estado paralelo
de jogadores nem novos state bags.

## Implementar uma operação ausente

Cada destino tem `bridge/frameworks/<destino>/qb_compat.lua`. O instalador comum
expõe as declarações em `Bridge.framework.QBCore.Functions`, `.Player` e `.Lifecycle`.
O adaptador pode fornecer uma factory de operação, mantendo assinaturas e retornos:

```lua
return function(F, context, I)
    local N = PRCore.load('@pr_bridge/bridge/frameworks/qb_native', _ENV)(F, context, I, 'nd')
    N['Player.SetGang'] = function()
        return function(source, name, grade)
            -- Chame aqui a API real de gangs do destino, validando seu resultado.
        end
    end
    return N
end
```

Esse bloco é um **exemplo de ponto de extensão**, não uma implementação funcional.
Também é possível configurar um adapter export com a assinatura normalizada:

```lua
compatServices.frameworks.nd = {
    ['QBCore.Player.SetGang'] = { resource='meu_adapter', export='SetPlayerGang' },
}
```

Operações de inventário devem continuar dentro do adaptador de inventário; não
chame Ox diretamente do adaptador QBX. Uma falha real não provoca tentativas em
outro serviço. `GetCompatibilityReport()` e `GetCompatibilityCapabilities()`
mostram o suporte da fachada/adaptador, não garantem paridade em jogo.

## Testes

`tests/qb_compat_test.lua`: 182 verificações de presença e comportamento,
QBCore→ESX, slots/metadados, sessões antigas, callbacks, propriedade, disable e
coexistência QBX. `tests/qb_catalog_test.mjs` compara declarações da referência.
Regressões ESX/OX/NUI/cache continuam passando. Testes isolados; não houve restart
da cidade nem operação em banco/jogador real. Outros destinos exigem homologação
com suas versões e scripts reais.
