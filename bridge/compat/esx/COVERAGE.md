# ESX: cobertura de contratos

Referência local: `[Docs]/[frameworks]/esx_core-main/[core]/es_extended`.

Este relatório distingue adaptadores existentes de encaminhamentos condicionais.
`adaptado` significa que existe roteamento/implementação; não significa homologação
no FiveM, equivalência completa de comportamento ou teste individual de cada função.
`encaminhado` significa que o destino resolve a capacidade real por operação;
quando não existe equivalente configurado, a chamada falha explicitamente.
`não suportado` no relatório de runtime significa erro, sem simular sucesso.
A solicitação de compatibilidade integral ainda não está concluída.

| Contexto | Adaptadores anteriores | Novos encaminhamentos condicionais |
| --- | ---: | ---: |
| server | 134 | 22 |
| client | 122 | 2 |

As 24 funções agora passam pelo contrato da framework/inventário. Não são 24
implementações universais: disponibilidade depende do backend, schema e serviço.
Veja a matriz e as assinaturas em [COMPAT.md](../../frameworks/COMPAT.md).

## Limites que também se aplicam a funções adaptadas

- Escrita de armas/metadados foi verificada no esquema ox_inventory; outros inventários requerem adaptação própria.
- Attachments exigem correspondência verificável arma/hash/item; acessórios customizados sem alias ESX geram erro.
- Dois slots/seriais da mesma arma tornam setters por nome ambíguos; a alteração é recusada.
- Arremessáveis precisam de uma política de conversão entre munição ESX e quantidade de itens nativos.
- Contas extras exigem carteira explícita. Nenhuma carteira de dinheiro sujo ou identidade SSN foi inventada.
- Configuração, menus, contextos e snapshots oferecem os campos/opções documentados, não toda extensão histórica do ESX.
- Propriedades de spawn sem owner têm prazo de 5s; a configuração de state bag/broadcast não é ignorada.
- Arquivos internos, protocolos alternativos e acesso direto a SQL ESX não são redirecionados por uma fachada Lua.

## Verificação

351 checks de compatibilidade (incluindo presença do catálogo); 30 checks de contratos
nativos; 112 modelos e 548 componentes conferidos contra a referência.
Regressões de ox_lib, inicialização QBX, cache, menu NUI e limpeza por consumidor passaram.
São testes isolados/simulados. O teste em FiveM e a homologação por inventário/framework continuam pendentes.

## Contratos

| Contexto | Função | Estado |
| --- | --- | --- |
| server | `AddItems` | encaminhado (condicional) |
| server | `AssertType` | adaptado |
| server | `Await` | adaptado |
| server | `AwaitClientCallback` | adaptado |
| server | `ClearTimeout` | adaptado |
| server | `CreateExtendedVehicle` | encaminhado (condicional) |
| server | `CreateJob` | encaminhado (condicional) |
| server | `CreatePickup` | encaminhado (condicional) |
| server | `DiscordLog` | encaminhado (condicional) |
| server | `DiscordLogFields` | encaminhado (condicional) |
| server | `DoesJobExist` | adaptado |
| server | `DoesServerCallbackExist` | adaptado |
| server | `DumpTable` | adaptado |
| server | `ExtendedPlayers` | adaptado |
| server | `GetConfig` | adaptado |
| server | `GetExtendedPlayers` | adaptado |
| server | `GetExtendedVehicleFromPlate` | encaminhado (condicional) |
| server | `GetIdentifier` | adaptado |
| server | `GetItemLabel` | adaptado |
| server | `GetItems` | adaptado |
| server | `GetJobs` | adaptado |
| server | `GetNumPlayers` | adaptado |
| server | `GetPlayerFromId` | adaptado |
| server | `GetPlayerFromIdentifier` | adaptado |
| server | `GetPlayerIdFromIdentifier` | adaptado |
| server | `GetPlayers` | adaptado |
| server | `GetRandomString` | adaptado |
| server | `GetUsableItems` | adaptado |
| server | `GetVehicleType` | adaptado |
| server | `GetWeapon` | adaptado |
| server | `GetWeaponComponent` | adaptado |
| server | `GetWeaponFromHash` | adaptado |
| server | `GetWeaponLabel` | adaptado |
| server | `GetWeaponList` | adaptado |
| server | `IsFunctionReference` | adaptado |
| server | `IsPlayerLoaded` | adaptado |
| server | `IsValidLocaleString` | adaptado |
| server | `Math.GetHeadingFromCoords` | adaptado |
| server | `Math.GroupDigits` | adaptado |
| server | `Math.Random` | adaptado |
| server | `Math.Round` | adaptado |
| server | `Math.Trim` | adaptado |
| server | `OneSync.GetClosestObject` | adaptado |
| server | `OneSync.GetClosestPed` | adaptado |
| server | `OneSync.GetClosestPlayer` | adaptado |
| server | `OneSync.GetClosestVehicle` | adaptado |
| server | `OneSync.GetObjectsInArea` | adaptado |
| server | `OneSync.GetPedsInArea` | adaptado |
| server | `OneSync.GetPlayersInArea` | adaptado |
| server | `OneSync.GetVehiclesInArea` | adaptado |
| server | `OneSync.SpawnObject` | adaptado |
| server | `OneSync.SpawnPed` | adaptado |
| server | `OneSync.SpawnPedInVehicle` | adaptado |
| server | `OneSync.SpawnVehicle` | adaptado |
| server | `Player` | adaptado |
| server | `RefreshItems` | encaminhado (condicional) |
| server | `RefreshJob` | encaminhado (condicional) |
| server | `RefreshJobs` | encaminhado (condicional) |
| server | `RegisterCommand` | adaptado |
| server | `RegisterPlayerFunctionOverrides` | encaminhado (condicional) |
| server | `RegisterServerCallback` | adaptado |
| server | `RegisterUsableItem` | adaptado |
| server | `Round` | adaptado |
| server | `SavePlayer` | adaptado |
| server | `SetPlayerFunctionOverride` | encaminhado (condicional) |
| server | `SetTimeout` | adaptado |
| server | `Table.Clone` | adaptado |
| server | `Table.Concat` | adaptado |
| server | `Table.Filter` | adaptado |
| server | `Table.Find` | adaptado |
| server | `Table.FindIndex` | adaptado |
| server | `Table.IndexOf` | adaptado |
| server | `Table.Join` | adaptado |
| server | `Table.LastIndexOf` | adaptado |
| server | `Table.Map` | adaptado |
| server | `Table.Reverse` | adaptado |
| server | `Table.Set` | adaptado |
| server | `Table.SizeOf` | adaptado |
| server | `Table.Sort` | adaptado |
| server | `Table.TableContains` | adaptado |
| server | `Table.ToArray` | adaptado |
| server | `Table.Wipe` | adaptado |
| server | `Trace` | adaptado |
| server | `TriggerClientCallback` | adaptado |
| server | `TriggerClientEvent` | adaptado |
| server | `UseItem` | adaptado |
| server | `ValidateType` | adaptado |
| server | `load` | adaptado |
| server | `loadJson` | adaptado |
| server | `require` | adaptado |
| server | `xPlayer.addAccountMoney` | adaptado |
| server | `xPlayer.addInventoryItem` | adaptado |
| server | `xPlayer.addMoney` | adaptado |
| server | `xPlayer.addWeapon` | adaptado |
| server | `xPlayer.addWeaponAmmo` | adaptado |
| server | `xPlayer.addWeaponComponent` | adaptado |
| server | `xPlayer.beginAccountOperation` | encaminhado (condicional) |
| server | `xPlayer.beginAccountShutdown` | encaminhado (condicional) |
| server | `xPlayer.canCarryItem` | adaptado |
| server | `xPlayer.canSwapItem` | adaptado |
| server | `xPlayer.clearMeta` | adaptado |
| server | `xPlayer.endAccountOperation` | encaminhado (condicional) |
| server | `xPlayer.executeCommand` | adaptado |
| server | `xPlayer.get` | adaptado |
| server | `xPlayer.getAccount` | adaptado |
| server | `xPlayer.getAccounts` | adaptado |
| server | `xPlayer.getCoords` | adaptado |
| server | `xPlayer.getGroup` | adaptado |
| server | `xPlayer.getIdentifier` | adaptado |
| server | `xPlayer.getInventory` | adaptado |
| server | `xPlayer.getInventoryItem` | adaptado |
| server | `xPlayer.getJob` | adaptado |
| server | `xPlayer.getLoadout` | adaptado |
| server | `xPlayer.getMaxWeight` | adaptado |
| server | `xPlayer.getMeta` | adaptado |
| server | `xPlayer.getMoney` | adaptado |
| server | `xPlayer.getName` | adaptado |
| server | `xPlayer.getPendingAccountOperations` | encaminhado (condicional) |
| server | `xPlayer.getPlayTime` | encaminhado (condicional) |
| server | `xPlayer.getPlayerId` | adaptado |
| server | `xPlayer.getSSN` | encaminhado (condicional) |
| server | `xPlayer.getSource` | adaptado |
| server | `xPlayer.getWeapon` | adaptado |
| server | `xPlayer.getWeaponTint` | adaptado |
| server | `xPlayer.getWeight` | adaptado |
| server | `xPlayer.hasItem` | adaptado |
| server | `xPlayer.hasWeapon` | adaptado |
| server | `xPlayer.hasWeaponComponent` | adaptado |
| server | `xPlayer.isAdmin` | adaptado |
| server | `xPlayer.isCurrent` | adaptado |
| server | `xPlayer.isPaycheckEnabled` | encaminhado (condicional) |
| server | `xPlayer.kick` | adaptado |
| server | `xPlayer.refreshJob` | adaptado |
| server | `xPlayer.removeAccountMoney` | adaptado |
| server | `xPlayer.removeInventoryItem` | adaptado |
| server | `xPlayer.removeMoney` | adaptado |
| server | `xPlayer.removeWeapon` | adaptado |
| server | `xPlayer.removeWeaponAmmo` | adaptado |
| server | `xPlayer.removeWeaponComponent` | adaptado |
| server | `xPlayer.set` | adaptado |
| server | `xPlayer.setAccountMoney` | adaptado |
| server | `xPlayer.setCoords` | adaptado |
| server | `xPlayer.setGroup` | encaminhado (condicional) |
| server | `xPlayer.setInventoryItem` | adaptado |
| server | `xPlayer.setJob` | adaptado |
| server | `xPlayer.setMaxWeight` | adaptado |
| server | `xPlayer.setMeta` | adaptado |
| server | `xPlayer.setMoney` | adaptado |
| server | `xPlayer.setName` | encaminhado (condicional) |
| server | `xPlayer.setWeaponTint` | adaptado |
| server | `xPlayer.showAdvancedNotification` | adaptado |
| server | `xPlayer.showHelpNotification` | adaptado |
| server | `xPlayer.showNotification` | adaptado |
| server | `xPlayer.togglePaycheck` | encaminhado (condicional) |
| server | `xPlayer.triggerEvent` | adaptado |
| server | `xPlayer.updateWeaponAmmo` | adaptado |
| client | `AssertType` | adaptado |
| client | `Await` | adaptado |
| client | `AwaitServerCallback` | adaptado |
| client | `CancelProgressbar` | adaptado |
| client | `ClearTimeout` | adaptado |
| client | `CloseContext` | adaptado |
| client | `CreatePointInternal` | adaptado |
| client | `DisableSpawnManager` | adaptado |
| client | `DoesClientCallbackExist` | adaptado |
| client | `DrawMissionText` | adaptado |
| client | `DumpTable` | adaptado |
| client | `Game.DeleteObject` | adaptado |
| client | `Game.DeleteVehicle` | adaptado |
| client | `Game.GetClosestEntity` | adaptado |
| client | `Game.GetClosestObject` | adaptado |
| client | `Game.GetClosestPed` | adaptado |
| client | `Game.GetClosestPlayer` | adaptado |
| client | `Game.GetClosestVehicle` | adaptado |
| client | `Game.GetObjects` | adaptado |
| client | `Game.GetPedMugshot` | adaptado |
| client | `Game.GetPeds` | adaptado |
| client | `Game.GetPlayers` | adaptado |
| client | `Game.GetPlayersInArea` | adaptado |
| client | `Game.GetRaycastResult` | adaptado |
| client | `Game.GetVehicleInDirection` | adaptado |
| client | `Game.GetVehicleProperties` | adaptado |
| client | `Game.GetVehicles` | adaptado |
| client | `Game.GetVehiclesInArea` | adaptado |
| client | `Game.IsRaycastActive` | adaptado |
| client | `Game.IsSpawnPointClear` | adaptado |
| client | `Game.IsVehicleEmpty` | adaptado |
| client | `Game.SetVehicleProperties` | adaptado |
| client | `Game.SpawnLocalObject` | adaptado |
| client | `Game.SpawnLocalVehicle` | adaptado |
| client | `Game.SpawnObject` | adaptado |
| client | `Game.SpawnVehicle` | adaptado |
| client | `Game.StopRaycasting` | adaptado |
| client | `Game.Teleport` | adaptado |
| client | `Game.Utils.DrawText3D` | adaptado |
| client | `GetAccount` | adaptado |
| client | `GetConfig` | adaptado |
| client | `GetInteractKey` | adaptado |
| client | `GetPlayerData` | adaptado |
| client | `GetRandomString` | adaptado |
| client | `GetVehicleType` | adaptado |
| client | `GetVehicleTypeClient` | adaptado |
| client | `GetWeapon` | adaptado |
| client | `GetWeaponComponent` | adaptado |
| client | `GetWeaponFromHash` | adaptado |
| client | `GetWeaponLabel` | adaptado |
| client | `GetWeaponList` | adaptado |
| client | `HashString` | adaptado |
| client | `HidePointInternal` | adaptado |
| client | `HideUI` | adaptado |
| client | `IsFunctionReference` | adaptado |
| client | `IsPlayerLoaded` | adaptado |
| client | `IsValidLocaleString` | adaptado |
| client | `Math.GetHeadingFromCoords` | adaptado |
| client | `Math.GroupDigits` | adaptado |
| client | `Math.Random` | adaptado |
| client | `Math.Round` | adaptado |
| client | `Math.Trim` | adaptado |
| client | `OpenContext` | adaptado |
| client | `Point` | adaptado |
| client | `PreviewContext` | encaminhado (condicional) |
| client | `Progressbar` | adaptado |
| client | `RefreshContext` | adaptado |
| client | `RegisterClientCallback` | adaptado |
| client | `RegisterInput` | adaptado |
| client | `RegisterInteraction` | adaptado |
| client | `RemoveInteraction` | adaptado |
| client | `RemovePointInternal` | adaptado |
| client | `Round` | adaptado |
| client | `Scaleform.ShowBreakingNews` | adaptado |
| client | `Scaleform.ShowFreemodeMessage` | adaptado |
| client | `Scaleform.ShowPopupWarning` | adaptado |
| client | `Scaleform.ShowTrafficMovie` | adaptado |
| client | `Scaleform.Utils.RequestScaleformMovie` | adaptado |
| client | `Scaleform.Utils.RunMethod` | adaptado |
| client | `SearchInventory` | adaptado |
| client | `SecureNetEvent` | adaptado |
| client | `SetPlayerData` | adaptado |
| client | `SetTimeout` | adaptado |
| client | `ShowAdvancedNotification` | adaptado |
| client | `ShowFloatingHelpNotification` | adaptado |
| client | `ShowHelpNotification` | adaptado |
| client | `ShowInventory` | adaptado |
| client | `ShowNotification` | adaptado |
| client | `SpawnPlayer` | encaminhado (condicional) |
| client | `Streaming.RequestAnimDict` | adaptado |
| client | `Streaming.RequestAnimSet` | adaptado |
| client | `Streaming.RequestModel` | adaptado |
| client | `Streaming.RequestNamedPtfxAsset` | adaptado |
| client | `Streaming.RequestStreamedTextureDict` | adaptado |
| client | `Streaming.RequestWeaponAsset` | adaptado |
| client | `Table.Clone` | adaptado |
| client | `Table.Concat` | adaptado |
| client | `Table.Filter` | adaptado |
| client | `Table.Find` | adaptado |
| client | `Table.FindIndex` | adaptado |
| client | `Table.IndexOf` | adaptado |
| client | `Table.Join` | adaptado |
| client | `Table.LastIndexOf` | adaptado |
| client | `Table.Map` | adaptado |
| client | `Table.Reverse` | adaptado |
| client | `Table.Set` | adaptado |
| client | `Table.SizeOf` | adaptado |
| client | `Table.Sort` | adaptado |
| client | `Table.TableContains` | adaptado |
| client | `Table.ToArray` | adaptado |
| client | `Table.Wipe` | adaptado |
| client | `TextUI` | adaptado |
| client | `TriggerServerCallback` | adaptado |
| client | `UI.Menu.Close` | adaptado |
| client | `UI.Menu.CloseAll` | adaptado |
| client | `UI.Menu.GetOpened` | adaptado |
| client | `UI.Menu.GetOpenedMenus` | adaptado |
| client | `UI.Menu.Open` | adaptado |
| client | `UI.Menu.RegisterType` | adaptado |
| client | `UI.ShowInventoryItemNotification` | adaptado |
| client | `ValidateType` | adaptado |
| client | `load` | adaptado |
| client | `loadJson` | adaptado |
| client | `require` | adaptado |
