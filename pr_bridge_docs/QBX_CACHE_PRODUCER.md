# QBX como produtor do cache passivo

Implementado na base em E: em 2026-10-17.

## Responsabilidades

- QBX carrega os dados pelos fluxos que ja possui e os entrega ao PR Bridge. Nao foi criada uma consulta SQL adicional, nem carga de todos os personagens offline.
- PR Bridge recebe, armazena e responde a leituras explicitas. Nao coleta jogador/mundo, nao consulta QBX para hidratar o cache, nao emite deltas automaticamente e nao limpa namespaces no logout.
- Inventario continua validando e executando itens/transacoes no servidor; ele publica seus estados reais apos suas operacoes. Uma escrita de cache nao chama uma transacao nem modifica o estado privado de autorizacao do inventario.
- Avisos de mudanca pertencem ao produtor. As validacoes existentes de origem, token, sequencia e transacao permanecem no recurso responsavel.

## Inicializacao e atualizacoes

1. `qbx_core/client/bridge-cache.lua` publica IDs, ped e contexto inicial antes dos consumidores de sessao/personagem do QBX.
2. O servidor publica cada jogador carregado em `UpdatePlayerData`, antes dos eventos ja existentes. Usa o `PlayerData` que o QBX possui, incluindo identidade, dinheiro, empregos, grupos e metadados; nenhuma busca adicional no banco.
3. No cliente, o handler real de `QBCore:Player:SetPlayerData` publica o snapshot recebido antes de atualizar a sessao.
4. Trocas de modelo feitas pelo multichar e a abertura da selecao atualizam o contexto explicitamente. Teleporte e inventario conferem o contexto na propria acao quando necessario.
5. O ciclo de contexto de 500 ms que a Forge HUD ja possuia entrega ped, assento exato, veiculo, arma e coordenadas ao QBX. Nao foi criado outro loop no Bridge ou por consumidor. Valores iguais nao produzem escritas/avisos. Uma HUD substituta deve entregar esse contexto por `exports.qbx_core:PublishClientContext(...)`, ou o script dono da acao pode chamar `RefreshClientContext(reason)`.
6. O produtor de status ja existente no QBX entrega as mudancas locais ao cache pelo evento `qbx_core:client:statusChanged`. Isso nao cria envio adicional de status ao servidor. Checkpoints e persistencia continuam com os fluxos anteriores.
7. Logout/desconexao registram a saida e preservam o ultimo snapshot. Consumidores verificam o estado de sessao, nao a simples existencia de um registro antigo.

## Chaves entregues

- Cliente: `playerData`, `player:self`, `player:<serverId>`, `player:<serverId>:<campo>`, `metadata:self:<campo>`, `job`, `gang`, `groups`, `cash`, `bank`, `playerLoaded`, `isDead`/`dead`, contexto e status.
- Servidor: `player:<source>`, `player:<source>:<campo>`, `metadata:<source>:<campo>`, `resource:qbx_core:session:<source>`. O registro `player:<source>` e uma tabela de dados, nao o objeto vivo com metodos `Functions`.
- O ultimo snapshot de cada personagem fica em `resource:qbx_core:character:<citizenid>` no servidor. IDs de conexao podem ser reutilizados; o registro atual daquele ID e substituido explicitamente, sem confundir os metadados de dois personagens.
- Inventario: `resource:ox_inventory:player` no cliente, `resource:ox_inventory:player:<source>` no servidor e o dominio `interface` em cada lado.
- Os caches cliente e servidor continuam separados. Registros pessoais nao sao transmitidos a todos os jogadores pelo mecanismo de cache.

## Eventos do produtor

```lua
AddEventHandler('qbx_core:client:cacheChanged', function(changes, reason)
    if changes.job then
        local job = pr_lib.cache.get('job')
        -- Atualizar apenas o consumidor interessado.
    end
end)
```

`changes` e um conjunto de chaves alteradas, nao uma copia de todos os dados. O equivalente do servidor e `qbx_core:server:cacheChanged`.

Para preservar consumidores existentes, o QBX tambem emite os nomes legados `pr_bridge:client/server:OnPlayerLoaded` e `OnPlayerUnloaded`. Apesar do prefixo historico, quem emite esses avisos agora e o QBX. `bridge/player_lifecycle.lua` continua passivo.

O inventario e a HUD foram migrados nos pontos afetados. As assinaturas genericas `pr_lib.onCache` / `lib.onCache` continuam inertes; esta implementacao nao reativa observadores automaticos na biblioteca. Outros consumidores dependentes dessas assinaturas devem acompanhar o produtor ou consultar os dados na acao.

## Recepcao parcial

`cache.patch(key, fields)` recebe explicitamente os campos de uma tabela e preserva os demais campos. E uma operacao de armazenamento, sem notificacao, rede ou coleta.

O publicador do QBX usa essa recepcao para mudar metadados sem reenviar a lista inteira de itens entre recursos locais. Uma substituicao completa ainda e usada quando campos deixam de existir na nova versao autoritativa do registro.

## Reinicio e limites

O publicador mantem suas entregas pendentes no proprio QBX quando o PR Bridge ainda nao esta iniciado. Um evento de inicio do Bridge permite entregar esses dados; nao ha tentativa periodica. Isso nao e persistencia: reiniciar todos os recursos/servidor perde memoria temporaria, e o login normal volta a publicar os registros.

Nao houve restart de recursos vivos, alteracao de dados SQL, configuracao de mapas ou build de interfaces nesta implementacao. Renderizacao do loading/mapa e desempenho real exigem homologacao dentro do FiveM.

## Verificacao

- Simulacao com modulos reais de cache, produtores QBX, sessoes Forge Core, estado do inventario e adaptador/listeners da HUD.
- Testes de cache passivo, fachada antiga/nova e inicializacao real do PR Bridge.
- Teste de compras do inventario: caixa/banco/cartao, replay, concorrencia, logout e reembolso.
- Sintaxe dos 23 arquivos de producao afetados, normalizando o dialeto CFX para Lua 5.5 no verificador.

Checklist no jogo: conectar do zero, selecionar personagem, abrir inventario, equipar/usar item, conferir dinheiro/emprego na HUD, teleportar, trocar modelo/roupa, dar logout e entrar em outro personagem. Confirmar tambem a tela de carregamento numa conexao nova.
