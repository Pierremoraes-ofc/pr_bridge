<!-- generated-by: gsd-doc-writer -->
# Catálogo público Lua do ox_lib e situação no PR Bridge

PR Bridge **1.4.2** · referência **ox_lib 3.38.0 (local distribution)** · conferência **10/10/2026**

**311 entradas de API catalogadas: 311 no grupo feito; 0 no grupo analisar.** Há ainda 91 caminhos de acesso herdados, listados separadamente e não somados como novas implementações.

Composição: 87 chamadas diretas do tipo lib.função, 196 funções/métodos em namespaces e 28 métodos de objetos retornados. Os totais não contam arquivos nem tratam um módulo inteiro como uma única função.

## Critério da separação

- **Feito:** a chamada usa implementação canônica do PR Bridge, diretamente ou com adapter de assinatura/retorno/protocolo de UI.
- **Analisar:** o contrato ainda mantém implementação legada/infraestrutura compat própria, tem consolidação parcial ou uma lacuna de exposição. Não significa que todas essas funções estejam ausentes ou quebradas.
- Consolidação de implementação e testes offline, não homologação no FiveM. As 202 entradas anteriormente pendentes foram integradas à biblioteca canônica.

## Como ler e reproduzir

Uma entrada é um nome público. Client/server e overloads ficam na mesma linha. Aliases contam como nomes distintos, não como novos motores. `lib.array:map(fn)` representa o método da classe: no uso normal, crie `local arr = lib.array:new(...)` e chame `arr:map(fn)`; também é possível `lib.array.map(arr, fn)`. Não é `lib.array.map(fn)` sem self.

`timer:...`, `keybind:...`, `point:...`, `zone:...`, `marker:...`, `cronTask:...` e `eventHook:...` são métodos do objeto retornado, não funções globais inventadas em lib. `class:...` corresponde à classe devolvida por `lib.class(...)`.

C = cliente; S = servidor; C/S = arquivo compartilhado. Isso identifica onde a API é declarada, não garante que cada efeito exista dos dois lados: por exemplo, setRoutingBucket no cliente não aplica bucket, e setDebug de zonas só existe no cliente.

Gerador read-only: `node scripts/catalog_ox_public_api.mjs "caminho/para/ox_lib" --json` (dados) ou `--markdown` (este texto). Sem flags imprime o resumo. Não escreve arquivos nem inicia recursos.

A referência é a distribuição local 3.38.0, que inclui coleções/classes além de releases clássicos. Não é um catálogo de qualquer versão existente na internet. A saída --json do gerador registra fontes, linhas, hashes e critérios por entrada.

## 1. Feito — implementação nativa reutilizada

### __addCommand (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.__addCommand(group, name, callback, parameters, help)` | S | bridge/addCommand/server, bridge/compat/ox_command |

### addCommand (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.addCommand(commandName, properties, cb, ...)` | S | bridge/addCommand/server, bridge/compat/ox_command |

### addKeybind (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `keybind:disable(toggle)` | C | bridge/addKeybind/client |
| `keybind:getCurrentKey()` | C | bridge/addKeybind/client |
| `keybind:isControlPressed()` | C | bridge/addKeybind/client |
| `lib.addKeybind(data)` | C | bridge/addKeybind/client |

### array (23)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.array:at(index)` | C/S | pr_lib.library.collections.array |
| `lib.array:every(testFn)` | C/S | pr_lib.library.collections.array |
| `lib.array:fill(value, start, endIndex)` | C/S | pr_lib.library.collections.array |
| `lib.array:filter(testFn)` | C/S | pr_lib.library.collections.array |
| `lib.array:find(testFn, last)` | C/S | pr_lib.library.collections.array |
| `lib.array:findIndex(testFn, last)` | C/S | pr_lib.library.collections.array |
| `lib.array:forEach(cb)` | C/S | pr_lib.library.collections.array |
| `lib.array:from(iter)` | C/S | pr_lib.library.collections.array |
| `lib.array:includes(element, fromIndex)` | C/S | pr_lib.library.collections.array |
| `lib.array:indexOf(value, last)` | C/S | pr_lib.library.collections.array |
| `lib.array:join(seperator)` | C/S | pr_lib.library.collections.array |
| `lib.array:map(cb)` | C/S | pr_lib.library.collections.array |
| `lib.array:merge(...)` | C/S | pr_lib.library.collections.array |
| `lib.array:new(...)` | C/S | pr_lib.library.collections.array |
| `lib.array:pop()` | C/S | pr_lib.library.collections.array |
| `lib.array:push(...)` | C/S | pr_lib.library.collections.array |
| `lib.array:reduce(reducer, initialValue, reverse)` | C/S | pr_lib.library.collections.array |
| `lib.array:reverse()` | C/S | pr_lib.library.collections.array |
| `lib.array:shift()` | C/S | pr_lib.library.collections.array |
| `lib.array:slice(start, finish)` | C/S | pr_lib.library.collections.array |
| `lib.array:toReversed()` | C/S | pr_lib.library.collections.array |
| `lib.array:unshift(...)` | C/S | pr_lib.library.collections.array |
| `lib.array.isArray(tbl)` | C/S | pr_lib.library.collections.array |

### callback (3)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.callback(event, delay, cb, ...)`<br>`lib.callback(event, playerId, cb, ...)` | C/S | PRCore.callback / bridge/callback/transport.lua |
| `lib.callback.await(event, delay, ...)`<br>`lib.callback.await(event, playerId, ...)` | C/S | PRCore.callback / bridge/callback/transport.lua |
| `lib.callback.register(name, cb)` | C/S | PRCore.callback / bridge/callback/transport.lua |

### class (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `class:instanceOf(class)` | C/S | pr_lib.library.class |
| `class:isClass(class)` | C/S | pr_lib.library.class |
| `class.new(class, ...)` | C/S | pr_lib.library.class |
| `lib.class(name, super)` | C/S | pr_lib.library.class |

### cron (7)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `cronTask:getAbsoluteNextTime()` | S | pr_lib.library.cron |
| `cronTask:getNextTime()` | S | pr_lib.library.cron |
| `cronTask:getTimeAsString(timestamp)` | S | pr_lib.library.cron |
| `cronTask:run()` | S | pr_lib.library.cron |
| `cronTask:scheduleTask()` | S | pr_lib.library.cron |
| `cronTask:stop(msg)` | S | pr_lib.library.cron |
| `lib.cron.new(expression, job, options)` | S | pr_lib.library.cron |

### disableControls (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.disableControls()` | C | bridge/fivem/controls/client |
| `lib.disableControls:Add(...)` | C | bridge/fivem/controls/client |
| `lib.disableControls:Clear(...)` | C | bridge/fivem/controls/client |
| `lib.disableControls:Remove(...)` | C | bridge/fivem/controls/client |

### dui (8)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.dui:new(data)` | C | pr_lib.library.entities.dui |
| `lib.dui:remove()` | C | pr_lib.library.entities.dui |
| `lib.dui:sendMessage(message)` | C | pr_lib.library.entities.dui |
| `lib.dui:sendMouseDown(button)` | C | pr_lib.library.entities.dui |
| `lib.dui:sendMouseMove(x, y)` | C | pr_lib.library.entities.dui |
| `lib.dui:sendMouseUp(button)` | C | pr_lib.library.entities.dui |
| `lib.dui:sendMouseWheel(deltaX, deltaY)` | C | pr_lib.library.entities.dui |
| `lib.dui:setUrl(url)` | C | pr_lib.library.entities.dui |

### gameEntity (15)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.gameEntity:get(key)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:getCoords()` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:getHeading()` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:getModel()` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:getRoutingBucket()` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:has(key)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:keys()` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:new(handle)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:set(key, value, mode)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:setCoords(x, y, z, deadFlag, ragdollFlag, clearArea)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:setHandle(handle)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:setHeading(heading)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:setr(key, value)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:setRoutingBucket(bucket)` | C/S | pr_lib.library.entities.gameEntity |
| `lib.gameEntity:sets(key, value)` | C/S | pr_lib.library.entities.gameEntity |

### getClosestObject (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getClosestObject(coords, maxDistance)` | C/S | bridge/fivem/proximity/shared |

### getClosestPed (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getClosestPed(coords, maxDistance)` | C/S | bridge/fivem/proximity/shared |

### getClosestPlayer (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getClosestPlayer(coords, maxDistance, includePlayer)`<br>`lib.getClosestPlayer(coords, maxDistance, ignorePlayerId)` | C/S | bridge/fivem/proximity/shared |

### getClosestVehicle (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getClosestVehicle(coords, maxDistance, includePlayerVehicle)` | C/S | bridge/fivem/proximity/shared |

### getFilesInDirectory (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getFilesInDirectory(path, pattern)` | S | pr_lib.library.getFilesInDirectory |

### getNearbyObjects (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getNearbyObjects(coords, maxDistance)` | C/S | bridge/fivem/proximity/shared |

### getNearbyPeds (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getNearbyPeds(coords, maxDistance)` | C/S | bridge/fivem/proximity/shared |

### getNearbyPlayers (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getNearbyPlayers(coords, maxDistance, includePlayer)`<br>`lib.getNearbyPlayers(coords, maxDistance)` | C/S | bridge/fivem/proximity/shared |

### getNearbyVehicles (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getNearbyVehicles(coords, maxDistance, includePlayerVehicle)` | C/S | bridge/fivem/proximity/shared |

### getRelativeCoords (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getRelativeCoords(coords, rotation, offset)` | C/S | pr_lib.library.getRelativeCoords |

### grid (5)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.grid.addEntry(entry)` | C/S | pr_lib.library.grid |
| `lib.grid.getCell(point)` | C/S | pr_lib.library.grid |
| `lib.grid.getCellPosition(point)` | C/S | pr_lib.library.grid |
| `lib.grid.getNearbyEntries(point, filter)` | C/S | pr_lib.library.grid |
| `lib.grid.removeEntry(entry)` | C/S | pr_lib.library.grid |

### heap (8)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.heap:clear()` | C/S | pr_lib.library.collections.heap |
| `lib.heap:drain()` | C/S | pr_lib.library.collections.heap |
| `lib.heap:isEmpty()` | C/S | pr_lib.library.collections.heap |
| `lib.heap:new(comparator)` | C/S | pr_lib.library.collections.heap |
| `lib.heap:peek()` | C/S | pr_lib.library.collections.heap |
| `lib.heap:pop()` | C/S | pr_lib.library.collections.heap |
| `lib.heap:push(...)` | C/S | pr_lib.library.collections.heap |
| `lib.heap:size()` | C/S | pr_lib.library.collections.heap |

### hook (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.hook:dispatch(payload)` | C/S | pr_lib.library.hook |
| `lib.hook:new(event, filter)` | C/S | pr_lib.library.hook |
| `lib.hook:registerHook(cb, options)` | C/S | pr_lib.library.hook |
| `lib.hook:remove(resource, hookId)` | C/S | pr_lib.library.hook |

### locale (3)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.getLocale(resource, key)` | C/S | pr_lib.library.locale/getLocales/getLocale |
| `lib.getLocales()` | C/S | pr_lib.library.locale/getLocales/getLocale |
| `lib.locale(key)` | C/S | pr_lib.library.locale/getLocales/getLocale |

### logger (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.logger(source, event, message, ...)` | S | pr_lib.library.logger |

### lru (10)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.lru:capacity()` | C/S | pr_lib.library.collections.lru |
| `lib.lru:clear()` | C/S | pr_lib.library.collections.lru |
| `lib.lru:delete(key)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:each()` | C/S | pr_lib.library.collections.lru |
| `lib.lru:get(key)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:has(key)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:new(capacity)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:peek(key)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:set(key, value)` | C/S | pr_lib.library.collections.lru |
| `lib.lru:size()` | C/S | pr_lib.library.collections.lru |

### map (14)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.map:clear()` | C/S | pr_lib.library.collections.map |
| `lib.map:delete(key)` | C/S | pr_lib.library.collections.map |
| `lib.map:each()` | C/S | pr_lib.library.collections.map; alias de `lib.map.entries` |
| `lib.map:entries()` | C/S | pr_lib.library.collections.map |
| `lib.map:get(key)` | C/S | pr_lib.library.collections.map |
| `lib.map:has(key)` | C/S | pr_lib.library.collections.map |
| `lib.map:isEmpty()` | C/S | pr_lib.library.collections.map |
| `lib.map:keys()` | C/S | pr_lib.library.collections.map |
| `lib.map:new(initial)` | C/S | pr_lib.library.collections.map |
| `lib.map:set(key, value)` | C/S | pr_lib.library.collections.map |
| `lib.map:size()` | C/S | pr_lib.library.collections.map |
| `lib.map:toArray()` | C/S | pr_lib.library.collections.map |
| `lib.map:toTable()` | C/S | pr_lib.library.collections.map |
| `lib.map:values()` | C/S | pr_lib.library.collections.map |

### marker (2)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.marker.new(options)` | C | pr_lib.library.marker |
| `marker:draw()` | C | pr_lib.library.marker |

### math (11)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.math.clamp(val, lower, upper)` | C/S | pr_lib.math.clamp |
| `lib.math.groupdigits(number, seperator)` | C/S | pr_lib.math.groupdigits |
| `lib.math.hextorgb(input)` | C/S | pr_lib.math.hexToRGB |
| `lib.math.interp(start, finish, factor)` | C/S | pr_lib.math.lerp |
| `lib.math.lerp(start, finish, duration)` | C/S | pr_lib.math.Lerp |
| `lib.math.normaltorotation(input)` | C/S | pr_lib.math.normalToRotation |
| `lib.math.round(value, places)` | C/S | pr_lib.math.round |
| `lib.math.tohex(n, upper)` | C/S | pr_lib.math.toHex |
| `lib.math.torgba(input)` | C/S | pr_lib.math.toRGBA |
| `lib.math.toscalars(input, min, max, round)` | C/S | pr_lib.math.toScalars |
| `lib.math.tovector(input, min, max, round)` | C/S | pr_lib.math.toVector |

### ped (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.ped:getArmour()` | C/S | pr_lib.library.entities.ped |
| `lib.ped:new(handle)` | C/S | pr_lib.library.entities.ped |
| `lib.ped:setArmour(amount)` | C/S | pr_lib.library.entities.ped |
| `lib.ped.create(model, x, y, z, heading, isNetworked, bScriptHostPed)`<br>`lib.ped.create(model, x, y, z, heading)` | C/S | pr_lib.library.entities.ped |

### playAnim (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.playAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, animFlags, startPhase, phaseControlled, controlFlags, overrideCloneUpdate)` | C | bridge/fivem/streaming/client |

### player (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.player:getRoutingBucket()` | C/S | pr_lib.library.entities.player |
| `lib.player:new(netId)` | C/S | pr_lib.library.entities.player |
| `lib.player:setModel(model)` | C/S | pr_lib.library.entities.player |
| `lib.player:setRoutingBucket(bucket)` | C/S | pr_lib.library.entities.player |

### points (6)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.points.closest()` | C | pr_lib.points.getClosestPoint; alias de `lib.points.getClosestPoint` |
| `lib.points.getAllPoints()` | C | pr_lib.points.getAllPoints |
| `lib.points.getClosestPoint()` | C | pr_lib.points.getClosestPoint |
| `lib.points.getNearbyPoints()` | C | pr_lib.points.getNearbyPoints |
| `lib.points.new(...)` | C | pr_lib.points.new |
| `point:remove()` | C | pr_lib.points -> point:remove |

### print (5)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.print.debug(...)` | C/S | pr_lib.library.print |
| `lib.print.error(...)` | C/S | pr_lib.library.print |
| `lib.print.info(...)` | C/S | pr_lib.library.print |
| `lib.print.verbose(...)` | C/S | pr_lib.library.print |
| `lib.print.warn(...)` | C/S | pr_lib.library.print |

### prop (3)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.prop:new(handle)` | C/S | pr_lib.library.entities.prop |
| `lib.prop:setOnGround()` | C/S | pr_lib.library.entities.prop |
| `lib.prop.create(model, x, y, z, heading, isNetworked, netMissionEntity, dynamic)`<br>`lib.prop.create(model, x, y, z, heading, dynamic)` | C/S | pr_lib.library.entities.prop |

### raycast (3)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.raycast.cam(flags, ignore, distance)` | C | bridge/fivem/raycast/client; alias de `lib.raycast.fromCamera` |
| `lib.raycast.fromCamera(flags, ignore, distance)` | C | bridge/fivem/raycast/client |
| `lib.raycast.fromCoords(coords, destination, flags, ignore)` | C | bridge/fivem/raycast/client |

### registerHook (4)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `eventHook:off()` | C/S | pr_lib.library.registerHook |
| `eventHook:on(handler)` | C/S | pr_lib.library.registerHook |
| `eventHook:remove()` | C/S | pr_lib.library.registerHook |
| `lib.registerHook(eventName, handler, options)` | C/S | pr_lib.library.registerHook |

### requestAnimDict (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestAnimDict(animDict, timeout)` | C | pr_lib.fivem.streaming.requestAnimDict |

### requestAnimSet (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestAnimSet(animSet, timeout)` | C | pr_lib.fivem.streaming.requestAnimSet |

### requestAudioBank (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestAudioBank(audioBank, timeout)` | C | pr_lib.fivem.streaming.requestAudioBank |

### requestModel (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestModel(model, timeout)` | C | pr_lib.fivem.streaming.requestModel |

### requestNamedPtfxAsset (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestNamedPtfxAsset(ptFxName, timeout)` | C | pr_lib.fivem.streaming.requestPtfxAsset |

### requestScaleformMovie (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestScaleformMovie(scaleformName, timeout)` | C | pr_lib.fivem.streaming.requestScaleformMovie |

### requestStreamedTextureDict (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestStreamedTextureDict(textureDict, timeout)` | C | pr_lib.fivem.streaming.requestTextureDict |

### requestWeaponAsset (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.requestWeaponAsset(weaponType, timeout, weaponResourceFlags, extraWeaponComponentFlags)` | C | pr_lib.fivem.streaming.requestWeaponAsset |

### require (3)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.load(filePath, env)` | C/S | pr_lib.library.require/load/loadJson |
| `lib.loadJson(filePath)` | C/S | pr_lib.library.require/load/loadJson |
| `lib.require(modName)` | C/S | pr_lib.library.require/load/loadJson |

### ringbuffer (10)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.ringbuffer:capacity()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:clear()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:each()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:get(i)` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:isEmpty()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:isFull()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:new(capacity)` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:push(value)` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:size()` | C/S | pr_lib.library.collections.ringbuffer |
| `lib.ringbuffer:toArray()` | C/S | pr_lib.library.collections.ringbuffer |

### scaleform (10)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.scaleform:callMethod(name, args, returnValue)` | C | pr_lib.library.scaleform |
| `lib.scaleform:dispose()` | C | pr_lib.library.scaleform |
| `lib.scaleform:draw()` | C | pr_lib.library.scaleform |
| `lib.scaleform:isDrawing()` | C | pr_lib.library.scaleform |
| `lib.scaleform:new(details)` | C | pr_lib.library.scaleform |
| `lib.scaleform:setFullScreen(isFullscreen)` | C | pr_lib.library.scaleform |
| `lib.scaleform:setProperties(x, y, width, height)` | C | pr_lib.library.scaleform |
| `lib.scaleform:setRenderTarget(name, model)` | C | pr_lib.library.scaleform |
| `lib.scaleform:startDrawing()` | C | pr_lib.library.scaleform |
| `lib.scaleform:stopDrawing()` | C | pr_lib.library.scaleform |

### selector (10)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.selector:addSet(setName, items)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getAllSets()` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getRandom(setName)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getRandomAmount(setName, count)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getRandomWeighted(setName)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getRandomWeightedAmount(setName, count)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:getSet(setName)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:new(sets)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:removeSet(setName)` | C/S | pr_lib.library.collections.selector |
| `lib.selector:updateSet(setName, newItems)` | C/S | pr_lib.library.collections.selector |

### serviços (50)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.addAce(principal, ace, allow)` | S | pr_lib.fivem.ace.addAce |
| `lib.addPrincipal(child, parent)` | S | pr_lib.fivem.ace.addPrincipal |
| `lib.addRadialItem(items, parentMenuId)` | C | interface/client/ui.addRadialItem |
| `lib.alertDialog(data, timeout)` | C | interface/client/ui.alertDialog |
| `lib.cache(key)` | C | pr_lib.cache |
| `lib.cancelProgress()` | C | pr_lib.nativeProgress.cancelProgress |
| `lib.cancelSkillCheck()` | C | bridge/minigames/default/client |
| `lib.checkDependency(resource, minimumVersion, printMessage)` | C/S | pr_lib.github.checkDependency |
| `lib.clearRadialItems()` | C | interface/client/ui.clearRadialItems |
| `lib.closeAlertDialog(reason)` | C | interface/client/ui.closeAlertDialog |
| `lib.closeInputDialog()` | C | interface/client/ui.closeInputDialog |
| `lib.defaultNotify(data)` | C | interface/client/ui.defaultNotify |
| `lib.disableRadial(state)` | C | interface/client/ui.disableRadial |
| `lib.getCurrentRadialId()` | C | interface/client/ui.getCurrentRadialId |
| `lib.getLocaleKey()` | C/S | pr_lib.library.localeSettings |
| `lib.getOpenContextMenu()` | C | interface/client/ui.getOpenContextMenu |
| `lib.getOpenMenu()` | C | interface/client/ui.getOpenMenu |
| `lib.getVehicleProperties(vehicle)` | C | pr_lib.fivem.vehicleProperties.get |
| `lib.hasLoaded()` | C/S | pr_lib.library.hasLoaded |
| `lib.hideContext(onExit)` | C | interface/client/ui.hideContext |
| `lib.hideMenu(onExit)` | C | interface/client/ui.hideMenu |
| `lib.hideRadial()` | C | interface/client/ui.hideRadial |
| `lib.hideTextUI()` | C | interface/client/ui.hideTextUI |
| `lib.inputDialog(heading, rows, options)` | C | interface/client/ui.inputDialog |
| `lib.isCallbackValid(callbackName)` | C/S | pr_lib.callbackRegistry |
| `lib.isTextUIOpen()` | C | interface/client/ui.isTextUIOpen |
| `lib.notify(data)`<br>`lib.notify(playerId, data)` | C/S | interface/client/ui.notify |
| `lib.onCache(key, cb)` | C/S | pr_lib.onCache / ox_bootstrap |
| `lib.progressActive()` | C | pr_lib.nativeProgress.progressActive |
| `lib.progressBar(data)` | C | pr_lib.nativeProgress.progressBar |
| `lib.progressCircle(data)` | C | pr_lib.nativeProgress.progressCircle |
| `lib.registerContext(context)` | C | interface/client/ui.registerContext |
| `lib.registerMenu(data, cb)` | C | interface/client/ui.registerMenu |
| `lib.registerRadial(radial)` | C | interface/client/ui.registerRadial |
| `lib.removeAce(principal, ace, allow)` | S | pr_lib.fivem.ace.removeAce |
| `lib.removePrincipal(child, parent)` | S | pr_lib.fivem.ace.removePrincipal |
| `lib.removeRadialItem(id, parentMenuId)` | C | interface/client/ui.removeRadialItem |
| `lib.resetNuiFocus()` | C | pr_lib.fivem.nui.focus |
| `lib.setClipboard(value)` | C | pr_lib.setClipboard |
| `lib.setLocale(key)` | C | pr_lib.library.localeSettings |
| `lib.setMenuOptions(id, options, index)` | C | interface/client/ui.setMenuOptions |
| `lib.setNuiFocus(allowInput, disableCursor)` | C | pr_lib.fivem.nui.focus |
| `lib.setValidCallback(callbackName, isValid)` | C/S | pr_lib.callbackRegistry |
| `lib.setVehicleProperties(vehicle, props, fixVehicle)`<br>`lib.setVehicleProperties(vehicle, props)` | C/S | pr_lib.fivem.vehicleProperties.set / queue |
| `lib.showContext(id)` | C | interface/client/ui.showContext |
| `lib.showMenu(id, startIndex)` | C | interface/client/ui.showMenu |
| `lib.showTextUI(text, options)` | C | interface/client/ui.showTextUI |
| `lib.skillCheck(difficulty, inputs)` | C | bridge/minigames/default/client |
| `lib.skillCheckActive()` | C | bridge/minigames/default/client |
| `lib.versionCheck(repository)` | S | pr_lib.github.versionCheck |

### set (14)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.set:add(value)` | C/S | pr_lib.library.collections.set |
| `lib.set:clear()` | C/S | pr_lib.library.collections.set |
| `lib.set:difference(other)` | C/S | pr_lib.library.collections.set |
| `lib.set:each()` | C/S | pr_lib.library.collections.set |
| `lib.set:equals(other)` | C/S | pr_lib.library.collections.set |
| `lib.set:has(value)` | C/S | pr_lib.library.collections.set |
| `lib.set:intersection(other)` | C/S | pr_lib.library.collections.set |
| `lib.set:isEmpty()` | C/S | pr_lib.library.collections.set |
| `lib.set:isSubsetOf(other)` | C/S | pr_lib.library.collections.set |
| `lib.set:new(...)` | C/S | pr_lib.library.collections.set |
| `lib.set:remove(value)` | C/S | pr_lib.library.collections.set |
| `lib.set:size()` | C/S | pr_lib.library.collections.set |
| `lib.set:toArray()` | C/S | pr_lib.library.collections.set |
| `lib.set:union(other)` | C/S | pr_lib.library.collections.set |

### streamingRequest (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.streamingRequest(request, hasLoaded, assetType, asset, timeout, ...)` | C | pr_lib.fivem.streaming.requestAsset |

### string (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.string.random(pattern, length)` | C/S | pr_lib.string.random |

### table (8)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.table.contains(tbl, value)` | C/S | pr_lib.table.contains; alias de `contains` |
| `lib.table.deepclone(tbl)` | C/S | pr_lib.table.clone; alias de `table_deepclone` |
| `lib.table.freeze(tbl)` | C/S | pr_lib.table.freeze |
| `lib.table.isfrozen(tbl)` | C/S | pr_lib.table.isfrozen |
| `lib.table.map(tbl, fn)` | C/S | pr_lib.table.map; alias de `map` |
| `lib.table.matches(t1, t2)` | C/S | pr_lib.table.matches; alias de `table_matches` |
| `lib.table.merge(t1, t2, addDuplicateNumbers)` | C/S | pr_lib.table.merge; alias de `table_merge` |
| `lib.table.shuffle(tbl)` | C/S | pr_lib.table.shuffle; alias de `shuffle` |

### timer (9)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.timer(time, onEnd, async)` | C/S | pr_lib.timer |
| `timer:forceEnd(triggerOnEnd)` | C/S | pr_lib.timer -> Timer:forceEnd |
| `timer:getTimeLeft(format)` | C/S | pr_lib.timer -> Timer:getTimeLeft |
| `timer:isPaused()` | C/S | pr_lib.timer -> Timer:isPaused |
| `timer:pause()` | C/S | pr_lib.timer -> Timer:pause |
| `timer:play()` | C/S | pr_lib.timer -> Timer:play |
| `timer:restart(async)` | C/S | pr_lib.timer -> Timer:restart |
| `timer:run()` | C/S | pr_lib.timer.run |
| `timer:start(async)` | C/S | pr_lib.timer -> Timer:start |

### triggerClientEvent (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.triggerClientEvent(eventName, targetIds, ...)` | S | bridge/triggerClientEvent/server |

### uuid (2)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.uuid.generate()` | C/S | pr_lib.library.uuid |
| `lib.uuid.validate(str)` | C/S | pr_lib.library.uuid |

### vehicle (6)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.vehicle:getPlate()` | C/S | pr_lib.library.entities.vehicle |
| `lib.vehicle:getType()` | C/S | pr_lib.library.entities.vehicle |
| `lib.vehicle:new(handle)` | C/S | pr_lib.library.entities.vehicle |
| `lib.vehicle:setOnGround()` | C/S | pr_lib.library.entities.vehicle |
| `lib.vehicle:setPlate(plate)` | C/S | pr_lib.library.entities.vehicle |
| `lib.vehicle.create(model, x, y, z, heading, isNetworked, netMissionEntity)`<br>`lib.vehicle.create(model, type, x, y, z, heading)` | C/S | pr_lib.library.entities.vehicle |

### waitFor (1)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.waitFor(cb, errMessage, timeout)` | C/S | bridge/utils/waitFor |

### zones (9)

| Chamada / assinatura | Lado | Destino nativo |
| --- | --- | --- |
| `lib.zones.box(data)` | C/S | pr_lib.library.zones |
| `lib.zones.getAllZones()` | C/S | pr_lib.library.zones |
| `lib.zones.getCurrentZones()` | C/S | pr_lib.library.zones |
| `lib.zones.getNearbyZones()` | C/S | pr_lib.library.zones |
| `lib.zones.poly(data)` | C/S | pr_lib.library.zones |
| `lib.zones.sphere(data)` | C/S | pr_lib.library.zones |
| `zone:contains(coords, updateDistance)` | C/S | pr_lib.library.zones |
| `zone:remove()` | C/S | pr_lib.library.zones |
| `zone:setDebug(bool, colour)` | C | pr_lib.library.zones |

## 2. Ainda não concluído — leitura e análise

## 3. Lacunas de consolidação

Nenhuma das 202 entradas originalmente pendentes permanece sem consolidação/exposição. `lib.cache`, `lib.hasLoaded`, `timer:run`, `timer:isClass` e `timer:instanceOf` foram incluídos. Locale, foco NUI e ownership de callbacks usam serviços canônicos.

O teste native_library_test.lua verifica a presença das 202 entradas e aliases compartilhados nos dois contextos, além de comportamentos representativos. Isso não testa cada combinação/parâmetro em rede real. Renderização, CFX/GLM, providers HTTP e consumidores reais continuam exigindo teste no FiveM.

## 4. Herança pública — sem esconder métodos das classes derivadas

Estes são outros caminhos para implementações já listadas. Não são novas funções a reescrever. A origem indica a implementação que deve ser compartilhada.

| Caminho de acesso | Origem | Grupo |
| --- | --- | --- |
| `lib.array:isClass(class)` | `class:isClass` | feito |
| `lib.array:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.dui:isClass(class)` | `class:isClass` | feito |
| `lib.dui:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.gameEntity:isClass(class)` | `class:isClass` | feito |
| `lib.gameEntity:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.heap:isClass(class)` | `class:isClass` | feito |
| `lib.heap:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.hook:isClass(class)` | `class:isClass` | feito |
| `lib.hook:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.lru:isClass(class)` | `class:isClass` | feito |
| `lib.lru:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.map:isClass(class)` | `class:isClass` | feito |
| `lib.map:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.ped:isClass(class)` | `class:isClass` | feito |
| `lib.ped:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.ped:set(key, value, mode)` | `lib.gameEntity:set` | feito |
| `lib.ped:setr(key, value)` | `lib.gameEntity:setr` | feito |
| `lib.ped:sets(key, value)` | `lib.gameEntity:sets` | feito |
| `lib.ped:get(key)` | `lib.gameEntity:get` | feito |
| `lib.ped:has(key)` | `lib.gameEntity:has` | feito |
| `lib.ped:keys()` | `lib.gameEntity:keys` | feito |
| `lib.ped:setHandle(handle)` | `lib.gameEntity:setHandle` | feito |
| `lib.ped:getCoords()` | `lib.gameEntity:getCoords` | feito |
| `lib.ped:setCoords(x, y, z, deadFlag, ragdollFlag, clearArea)` | `lib.gameEntity:setCoords` | feito |
| `lib.ped:getModel()` | `lib.gameEntity:getModel` | feito |
| `lib.ped:getHeading()` | `lib.gameEntity:getHeading` | feito |
| `lib.ped:setHeading(heading)` | `lib.gameEntity:setHeading` | feito |
| `lib.ped:getRoutingBucket()` | `lib.gameEntity:getRoutingBucket` | feito |
| `lib.ped:setRoutingBucket(bucket)` | `lib.gameEntity:setRoutingBucket` | feito |
| `lib.player:isClass(class)` | `class:isClass` | feito |
| `lib.player:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.player.create(model, x, y, z, heading, isNetworked, bScriptHostPed)` | `lib.ped.create` | feito |
| `lib.player:getArmour()` | `lib.ped:getArmour` | feito |
| `lib.player:setArmour(amount)` | `lib.ped:setArmour` | feito |
| `lib.player:set(key, value, mode)` | `lib.gameEntity:set` | feito |
| `lib.player:setr(key, value)` | `lib.gameEntity:setr` | feito |
| `lib.player:sets(key, value)` | `lib.gameEntity:sets` | feito |
| `lib.player:get(key)` | `lib.gameEntity:get` | feito |
| `lib.player:has(key)` | `lib.gameEntity:has` | feito |
| `lib.player:keys()` | `lib.gameEntity:keys` | feito |
| `lib.player:setHandle(handle)` | `lib.gameEntity:setHandle` | feito |
| `lib.player:getCoords()` | `lib.gameEntity:getCoords` | feito |
| `lib.player:setCoords(x, y, z, deadFlag, ragdollFlag, clearArea)` | `lib.gameEntity:setCoords` | feito |
| `lib.player:getModel()` | `lib.gameEntity:getModel` | feito |
| `lib.player:getHeading()` | `lib.gameEntity:getHeading` | feito |
| `lib.player:setHeading(heading)` | `lib.gameEntity:setHeading` | feito |
| `lib.prop:isClass(class)` | `class:isClass` | feito |
| `lib.prop:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.prop:set(key, value, mode)` | `lib.gameEntity:set` | feito |
| `lib.prop:setr(key, value)` | `lib.gameEntity:setr` | feito |
| `lib.prop:sets(key, value)` | `lib.gameEntity:sets` | feito |
| `lib.prop:get(key)` | `lib.gameEntity:get` | feito |
| `lib.prop:has(key)` | `lib.gameEntity:has` | feito |
| `lib.prop:keys()` | `lib.gameEntity:keys` | feito |
| `lib.prop:setHandle(handle)` | `lib.gameEntity:setHandle` | feito |
| `lib.prop:getCoords()` | `lib.gameEntity:getCoords` | feito |
| `lib.prop:setCoords(x, y, z, deadFlag, ragdollFlag, clearArea)` | `lib.gameEntity:setCoords` | feito |
| `lib.prop:getModel()` | `lib.gameEntity:getModel` | feito |
| `lib.prop:getHeading()` | `lib.gameEntity:getHeading` | feito |
| `lib.prop:setHeading(heading)` | `lib.gameEntity:setHeading` | feito |
| `lib.prop:getRoutingBucket()` | `lib.gameEntity:getRoutingBucket` | feito |
| `lib.prop:setRoutingBucket(bucket)` | `lib.gameEntity:setRoutingBucket` | feito |
| `lib.ringbuffer:isClass(class)` | `class:isClass` | feito |
| `lib.ringbuffer:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.scaleform:isClass(class)` | `class:isClass` | feito |
| `lib.scaleform:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.selector:isClass(class)` | `class:isClass` | feito |
| `lib.selector:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.set:isClass(class)` | `class:isClass` | feito |
| `lib.set:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.vehicle:isClass(class)` | `class:isClass` | feito |
| `lib.vehicle:instanceOf(class)` | `class:instanceOf` | feito |
| `lib.vehicle:set(key, value, mode)` | `lib.gameEntity:set` | feito |
| `lib.vehicle:setr(key, value)` | `lib.gameEntity:setr` | feito |
| `lib.vehicle:sets(key, value)` | `lib.gameEntity:sets` | feito |
| `lib.vehicle:get(key)` | `lib.gameEntity:get` | feito |
| `lib.vehicle:has(key)` | `lib.gameEntity:has` | feito |
| `lib.vehicle:keys()` | `lib.gameEntity:keys` | feito |
| `lib.vehicle:setHandle(handle)` | `lib.gameEntity:setHandle` | feito |
| `lib.vehicle:getCoords()` | `lib.gameEntity:getCoords` | feito |
| `lib.vehicle:setCoords(x, y, z, deadFlag, ragdollFlag, clearArea)` | `lib.gameEntity:setCoords` | feito |
| `lib.vehicle:getModel()` | `lib.gameEntity:getModel` | feito |
| `lib.vehicle:getHeading()` | `lib.gameEntity:getHeading` | feito |
| `lib.vehicle:setHeading(heading)` | `lib.gameEntity:setHeading` | feito |
| `lib.vehicle:getRoutingBucket()` | `lib.gameEntity:getRoutingBucket` | feito |
| `lib.vehicle:setRoutingBucket(bucket)` | `lib.gameEntity:setRoutingBucket` | feito |
| `timer:isClass(class)` | `class:isClass` | feito |
| `timer:instanceOf(class)` | `class:instanceOf` | feito |
| `eventHook:isClass(class)` | `class:isClass` | feito |
| `eventHook:instanceOf(class)` | `class:instanceOf` | feito |

As fábricas de classe também fornecem `:new(...)` por mixin; esses construtores já estão no catálogo principal. Em `player`, get/setRoutingBucket são sobrescritos pela própria classe; não se repetem como herança.

## 5. Funções das bibliotecas Lua/CFX acessíveis por lib

`lib.math = math`, `lib.string = string` e `lib.table = table`. Portanto expõem também as funções do runtime, além das extensões ox listadas acima. Não são implementação ox a copiar nem entram nos totais anteriores.

| Namespace | Funções padrão Lua 5.4 acessíveis |
| --- | --- |
| `lib.math` | `abs`, `acos`, `asin`, `atan`, `ceil`, `cos`, `deg`, `exp`, `floor`, `fmod`, `log`, `max`, `min`, `modf`, `rad`, `random`, `randomseed`, `sin`, `sqrt`, `tan`, `tointeger`, `type`, `ult` |
| `lib.string` | `byte`, `char`, `dump`, `find`, `format`, `gmatch`, `gsub`, `len`, `lower`, `match`, `pack`, `packsize`, `rep`, `reverse`, `sub`, `unpack`, `upper` |
| `lib.table` | `concat`, `insert`, `move`, `pack`, `remove`, `sort`, `unpack` |

Extensões CFX referenciadas no próprio código local: `lib.table.create`, `lib.table.clone`, `lib.table.wipe`, `lib.table.type` e `lib.string.strsplit`. Dependem do runtime CFX, não de reimplementação em imports. Outros extras do runtime dependem do artifact; o catálogo não simula presença em FiveM real.

## 6. Globais e comportamentos relacionados, fora de lib.*

| Nome | Situação |
| --- | --- |
| `locale(key, ...)` | Alias para o tradutor nativo do consumidor. Não é `lib.locale(key)`. |
| `cache(key, fn, timeout)` e `cache.campo` | Adapter de cache no bootstrap / cache nativo no init PR. Não confundir com `lib.cache(key)`. |
| `SetInterval(callbackOuId, interval, ...)` / `ClearInterval(id)` | Aliases do scheduler nativo bridge/tasks/interval. Fora da contagem lib.*. |
| `require(name)` / `package.*` | Loader nativo por consumidor, reutilizando PRCore.loadFile/loadJson. |
| `GetActivePlayers()` no servidor | Adapter em ox_runtime; converte IDs do runtime. |
| `noop()` | Helper instalado pelo bootstrap/runtime; não é API lib.*. |
| `lib("módulo")` | Metatable de carregamento/consulta; não é mais uma função de domínio. |

Não entram como novas APIs: hooks de ciclo de vida `constructor`/`super`, metamétodos `__index`, `__pairs`, `__len`, `__pack`, etc.; callbacks fornecidos pelo consumidor (`onEnter`, `onExit`, `nearby`, `job`, ...); providers internos de logger; eventos/state bags; APIs de exports.ox_target; API JavaScript/TypeScript; propriedades não chamáveis como lib.name/context e cache.ped. As exclusões de declarações são rastreáveis no JSON.

## 7. Próxima etapa: homologação em jogo

1. Inicializar uma cópia de testes com o PR como fornecedor e o ox original parado.
2. Testar callbacks entre dois jogadores, timeout, desconexão e alterações de estado autorizadas.
3. Testar zonas GLM (polígono côncavo, altura, rotação, debug), DUI, scaleform, entidades e limpeza ao reiniciar consumidor.
4. Testar arquivos/traduções reais, cron e providers de logger com credenciais de teste.

## Fontes e limites da verificação

Extração das declarações em init.lua, imports/**/*.lua e resource/**/*.lua da referência local, incluindo aliases, tabelas chamáveis, construtores por mixin e métodos retornados/inherdados. Cruzamento com ox_catalog, inventário de hashes, ox_phase1, ox_runtime, ox_bootstrap, ox_host, ox_native e módulos nativos.

Verificações: tests/ox_public_api_catalog_test.mjs cobre declarações, aliases, tabelas chamáveis, construtores, métodos retornados, herança, contexto e paridade deste documento. tests/native_library_test.lua cobre as 202 entradas antes pendentes, identidade de aliases e comportamentos representativos. tests/ox_compat_test.lua cobre integração/protocolos com ambiente simulado. scripts/audit_ox_compat.mjs confere integridade dos módulos nativos e adapters. Não é teste no jogo.

A presença de encaminhamento foi revisada no código. O catálogo não representa cobertura integral de testes por método nem porcentagem de compatibilidade real. UI/renderização, CFX Lua 5.4, rede e recursos consumidores precisam de homologação no FiveM.

