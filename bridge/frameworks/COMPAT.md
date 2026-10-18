# Contrato de compatibilidade entre frameworks e serviços

O ESX é a **origem** da chamada. `Config.compatFramework` seleciona o destino,
que precisa corresponder à framework nativa ativa; não inicia nem troca cores.
Destinos: `qbx`, `qb`, `esx`, `nd`, `ox`, `tmc`, `custom`, `default`.
`forge`/`auto` usam o destino detectado, sem substituir o core por Forge Core.

## Caminho obrigatório

```text
ESX.AddItems(definições)
  → Bridge.framework.AddItems(definições)
    → Bridge.inventory.AddItems(definições)
      → adaptador do inventário selecionado
        → API nativa ou serviço auxiliar com contrato conhecido
```

O adaptador QBX não escolhe ox_inventory. A seleção de inventário continua em
`ConfigBridge.inventories` / `ActiveBridges.inventories`. Um inventário diferente
nunca chama Ox apenas porque Ox também está instalado.

Cada destino possui `frameworks/<destino>/compat.lua`; cada inventário possui
`inventories/<inventário>/compat.lua` (servidor) e `compat_client.lua` (cliente).
Os instaladores comuns expõem os mesmos nomes e padronizam disponibilidade e
erros; não inventam APIs ausentes. `compat_contract.lua` enumera as 24 operações.

## Suporte real nesta etapa

| Operações | Implementação automática | Quando falta equivalente |
| --- | --- | --- |
| CreateJob, RefreshJob, RefreshJobs | QB/QBX nativos; no QBX com Forge instalado, registry Forge | provider configurado para ND/Ox/TMC/custom/standalone |
| AddItems | inventário Ox com SetItemDefinition customizado; QB/PS com Shared.Items do QB; Forge persiste definições quando QBX+Ox+Forge | provider no adaptador do inventário ativo |
| RefreshItems | registry Forge no adaptador Ox; ESX original pelo inventário default | provider de recarga real; não retorna só a lista atual fingindo recarga |
| CreatePickup | CustomDrop no adaptador Ox; ESX original pelo inventário default | provider do inventário ativo |
| beginAccountOperation, beginAccountShutdown, endAccountOperation, getPendingAccountOperations | guardas de sessão comuns, ESX nativo quando disponível | não são locks bancários nem substituem transações do core |
| RegisterPlayerFunctionOverrides, SetPlayerFunctionOverride | factories da fachada, isoladas por recurso e invalidadas ao parar; ESX original nativo | não alteram os objetos nativos do core |
| setName | QB/QBX/TMC: nome de exibição em metadata + name; preserva firstname/lastname; ESX nativo | provider de identidade apropriado |
| getSSN | QB/QBX/TMC: metadata `compatMetadata.ssn`, exige valor real; ESX nativo | provider; nunca citizenid/license fictício |
| isPaycheckEnabled, togglePaycheck | serviço salarial real Forge no QBX; ESX nativo | provider que controle o serviço salarial real, não uma flag ignorada |
| getPlayTime | ESX nativo | provider de tempo total persistido; tempo da sessão não equivale ao total |
| setGroup | ESX nativo | provider de permissões com mapeamento explícito; não presume equivalência entre grupos/ACEs |
| CreateExtendedVehicle, GetExtendedVehicleFromPlate | ESX nativo | provider que devolva o contrato CExtendedVehicle; catálogo de modelos não é veículo persistente |
| DiscordLog, DiscordLogFields | webhook Discord configurado por convar privada ou ESX nativo | provider explícito; Fivemerr não é tratado como Discord |
| PreviewContext | esx_context:Preview real ou ESX nativo | provider de preview; não transforma preview em menu interativo com foco |
| SpawnPlayer | illenium-appearance para schema com `model`; colisão limitada a 5s, restaura freeze; ESX nativo | schema skinchanger antigo exige conversor completo/provider |

Todas as funções têm um ponto de encaminhamento em cada framework. Isso **não**
significa suporte integral em todo inventário ou equivalência de todos os schemas.
ND/Ox/TMC/custom/standalone não ganham funções nativas que não possuem: recebem
o contrato comum, serviços verificáveis e pontos de extensão explícitos.
Outras APIs ESX existentes também precisam de homologação por destino.

`RefreshJobs` sem registry auxiliar consulta o catálogo autoritativo QB/QBX atual;
não recarrega arbitrariamente arquivos `shared` nem cria tabelas ESX. `CreateJob`
preserva os grades/campos existentes. Em QBX sem Forge, `compatCommitJobs=true`
permite a persistência nativa em shared/jobs.lua; padrão false. QB usa a atualização
runtime/broadcast nativa, sem prometer persistência em arquivo.

`AddItems` cadastra **definições**, não entrega itens. `AddItem` continua separado.
Em Ox sem Forge a API customizada é runtime; use provider de persistência quando
necessário. Na Forge, o batch é validado antes de salvar e usa o lock JSON existente.
Falha posterior de sincronização é explícita, e repetir a chamada pode reparar a
definição salva que ainda não chegou ao runtime. Não há rollback fictício.

## DisplayMetadata

Cliente: `Bridge.inventory.displayMetadata(metadata, value)` e alias
`Bridge.inventory.DisplayMetadata`.

As declarações públicas são mantidas, inclusive sem implementação nativa. No Ox
encaminha à API `displayMetadata` real. QB, Origen e Quasar mantêm a função no
próprio `client.lua`, com um placeholder que trata ausência explicitamente.
O desenvolvedor pode substituir a atribuição do placeholder por
`function inventory.displayMetadata(metadata, value) ... end` nesse arquivo;
o normalizador preserva essa implementação, sem exigir outra configuração.
PS e demais inventários também recebem o contrato público pelo normalizador.
Quando o recurso selecionado não tem equivalente, o tratamento informa a
função ausente; não significa que ela deve ser removida do bridge.
Também podem usar um provider compatível
configurado **no adaptador desse inventário**, nunca fallback para outro inventário.

## Configurar serviços adicionais

```lua
compatServices = {
    frameworks = {
        nd = {
            GetPlayTime = { resource = 'meu_adapter_de_tempo', export = 'GetTotalSeconds' },
            SetPlayerGroup = { resource = 'meu_adapter_acl', export = 'SetGroup' },
        },
    },
    inventories = {
        origen = {
            AddItems = { resource = 'meu_adapter_de_itens', export = 'AddDefinitions' },
            displayMetadata = { resource = 'meu_adapter_origen', export = 'DisplayMetadata' },
            RefreshItems = false, -- erro explícito; não tenta outro serviço
        },
    },
},
```

Os nomes acima são **exemplos**, não recursos existentes na distribuição.
Um export configurado precisa implementar o contrato abaixo. Não aponte apenas
para uma função com nome parecido: semântica, parâmetros, retornos e schema têm
que corresponder. `['*']` fornece configuração padrão; a entrada do destino tem
precedência. Para inventário, configure sempre `inventories`, não `frameworks`.

| Contrato normalizado | Parâmetros/retorno |
| --- | --- |
| CreateJob | `{name,label,type,grades={{grade,name,label,salary,...}}}` → resultado real |
| RefreshJob / RefreshJobs | nome / sem argumentos → registro/catálogo autoritativo ou falha |
| AddItems | array `{name,label,weight,stack,...}` → resultado real, quantidade opcional |
| RefreshItems | sem argumentos → quantidade carregada ou falha |
| CreatePickup | `{kind,name,count,label,source,coords,bucket,metadata}` → id/resultado real; caller ESX já removeu item, não remover novamente |
| operações de conta | source → contador/boolean conforme operação |
| GetPlayTime / GetSSN | source → total de segundos persistido / identificador SSN real |
| IsPaycheckEnabled / TogglePaycheck | source / source,boolean → estado/resultado real |
| SetPlayerGroup / SetPlayerName | source,string → resultado; respeitar permissões e identidade do backend |
| CreateExtendedVehicle / GetExtendedVehicleFromPlate | owner,plate,coords / plate → CExtendedVehicle compatível |
| DiscordLog / DiscordLogFields | canal,título,cor,descrição ou fields → envio configurado |
| PreviewContext | assinatura ESX do preview, somente leitura |
| SpawnPlayer | skin,coords,callback,owner → resultado; callback de conclusão, inclusive falha |
| displayMetadata | string,label ou tabela de labels, conforme contrato Ox |

Um provider deve retornar false/razão em falha conhecida, ou lançar erro. Retornos
nil/múltiplos são preservados, não convertidos artificialmente em true. Erros não
provocam tentativas em outro serviço. O dispatcher verifica o registro do export,
inclusive contra proxies lazy, e resolve novamente ao chamar após restart.

`ESX.GetCompatibilityCapabilities()` informa `{framework=...,inventory=...}`;
cada entrada contém `available` e `provider`/motivo. Disponível significa API
registrada, não garante dados válidos para todos os jogadores/argumentos.
`GetCompatibilityReport()` distingue `adapted`, `delegated` e `unsupported`.
Os logs incluem operação, recurso chamador, framework, inventário e motivo, com
limite de uma mensagem por operação a cada 30s. Não registram argumentos, e URLs
presentes em mensagens de erro são ocultadas.

## Serviços Forge e Discord

Os sete exports `Compat*` da Forge são apenas servidor. Aceitam `pr_bridge` ou
recurso explicitamente autorizado com `forge-core.compat`; não existem eventos
de rede de administração. Payroll usa metadata persistida e o serviço real de
salário verifica a flag antes de pagar. O benefício VIP permanece independente.

Discord: `compatDiscordWebhookConvars = { auditoria = 'forge_discord_auditoria' }`.
Defina a URL com `set forge_discord_auditoria ...` privado no CFG, **nunca setr**.
A URL não entra na configuração shared nem no diagnóstico. Falhas HTTP são
registradas por canal/status, sem prometer confirmação síncrona de entrega.

## Validação

- `tests/framework_compat_routing_test.lua`: 348 verificações, 8 destinos,
  12 adaptadores de inventário, recusa/ausência/stop/restart e retorno múltiplo.
- `forge-core/tests/compat_services_test.lua`: serviços reais com armazenamento,
  jogadores e exports simulados; batch/erro/retry, autorização e folha salarial.
- Regressões de ESX, callbacks/NUI, catálogo de armas, OX e persistência.

Não houve inicialização da cidade, operação em banco/jogador real nem homologação
em jogo. Testar outras frameworks/inventários requer os recursos reais e suas
versões, principalmente os comerciais ou não presentes nesta instalação.
