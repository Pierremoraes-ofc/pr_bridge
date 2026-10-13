// Read-only catalog of the installed Lua ox_lib API. Does not edit/start resources.
// Extraction is complemented by reviewed mappings for returned objects and aliases.
import fs from 'node:fs'
import path from 'node:path'
import crypto from 'node:crypto'
import { fileURLToPath } from 'node:url'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const args = process.argv.slice(2)
const baseline = path.resolve(args.find(arg => !arg.startsWith('--')) || path.join(root, '../../../[ox]/ox_lib'))
const read = file => fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n')
const hash = text => crypto.createHash('sha256').update(text).digest('hex')
const relative = (base, file) => path.relative(base, file).split(path.sep).join('/')
const files = directory => fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
  const file = path.join(directory, entry.name)
  return entry.isDirectory() ? files(file) : file.endsWith('.lua') ? [file] : []
}).sort()
const inventory = JSON.parse(read(path.join(root, 'docs/ox_compatibility_inventory.json')))
const importInfo = new Map(inventory.entries.map(entry => [entry.file, entry]))
// Preserve positions, but do not treat examples in comments as declarations.
const stripComments = text => text.replace(/--\[(=*)\[[\s\S]*?\]\1\]|--[^\n]*/g, match => match.replace(/[^\n]/g, ' '))
const lineOf = (text, index) => text.slice(0, index).split('\n').length
const entries = new Map(), excluded = [], classes = new Map(), sourceFiles = []
const keyOf = call => call.replaceAll(':', '.')
const done = (target, note = '') => ({ group: 'feito', detail: 'encaminhamento nativo', target, note })
const pending = (detail, target = '', note = '') => ({ group: 'analisar', detail, target, note })

const visual = new Set(('alertDialog closeAlertDialog inputDialog closeInputDialog notify defaultNotify registerContext showContext hideContext getOpenContextMenu registerMenu showMenu hideMenu setMenuOptions getOpenMenu showTextUI hideTextUI isTextUIOpen registerRadial getCurrentRadialId hideRadial addRadialItem removeRadialItem clearRadialItems disableRadial').split(' '))
const progress = new Set('progressBar progressCircle progressActive cancelProgress'.split(' '))
const skill = new Set('skillCheck cancelSkillCheck skillCheckActive'.split(' '))
const mathNames = { toscalars: 'toScalars', tovector: 'toVector', torgba: 'toRGBA', normaltorotation: 'normalToRotation', hextorgb: 'hexToRGB', tohex: 'toHex', groupdigits: 'groupdigits', clamp: 'clamp', interp: 'lerp', round: 'round', lerp: 'Lerp' }
const tableNames = { contains: 'contains', matches: 'matches', deepclone: 'clone', merge: 'merge', shuffle: 'shuffle', map: 'map', freeze: 'freeze', isfrozen: 'isfrozen' }
const candidates = {}

function status(entry, source) {
  const call = keyOf(entry.call), name = call.slice(4)
  const module = entry.module
    const promoted = {
      class:'class', array:'collections.array', map:'collections.map', set:'collections.set',
      heap:'collections.heap', lru:'collections.lru', ringbuffer:'collections.ringbuffer', selector:'collections.selector',
      grid:'grid', cron:'cron', hook:'hook', registerHook:'registerHook', require:'require/load/loadJson',
      locale:'locale/getLocales/getLocale', logger:'logger', print:'print', uuid:'uuid',
      marker:'marker', scaleform:'scaleform', getFilesInDirectory:'getFilesInDirectory', getRelativeCoords:'getRelativeCoords',
      gameEntity:'entities.gameEntity', ped:'entities.ped', prop:'entities.prop', vehicle:'entities.vehicle', player:'entities.player',
      dui:'entities.dui', zones:'zones',
    }
    if (promoted[module]) return done('pr_lib.library.' + promoted[module], 'Uma implementação canônica exposta para desenvolvimento PR e aliases legados; ver tests/native_library_test.lua. DUI/criação/estado reutilizam motores existentes; zonas usam um único registro.')
    if (module === 'callback') return done('PRCore.callback / bridge/callback/transport.lua', 'Motor RPC único; adapter preserva envelopes ox, throttle, destino e timeout. Não é alias de assinatura incompatível.')
    if (call === 'lib.cache') return done('pr_lib.cache', 'Leitura do cache nativo; não cria outro observador/polling.')
    if (call === 'lib.hasLoaded') return done('pr_lib.library.hasLoaded')
    if (['lib.setNuiFocus','lib.resetNuiFocus'].includes(call)) return done('pr_lib.fivem.nui.focus', 'Ownership e restauração de keepInput no serviço canônico.')
    if (['lib.setLocale','lib.getLocaleKey'].includes(call)) return done('pr_lib.library.localeSettings', 'Configuração nativa; evento antigo apenas adaptado.')
    if (['lib.setValidCallback','lib.isCallbackValid'].includes(call)) return done('pr_lib.callbackRegistry', 'Registro canônico de ownership.')
    if (entry.call === 'timer:run') return done('pr_lib.timer.run', 'Método público do motor nativo; não é alias para assinatura privada.')
  if (call === 'lib.onCache') return done('pr_lib.onCache / ox_bootstrap', 'Pelo init PR usa o observador nativo; o bootstrap mínimo observa os eventos do host. Não há novo loop de polling no compat.')
  if (progress.has(name)) return done('pr_lib.nativeProgress.' + name, 'Motor único; adapter preserva política/retorno antigo e propriedade da atividade.')
  if (skill.has(name)) return done('bridge/minigames/default/client', 'Facade nativa SkillCheck / CancelSkillCheck / SkillCheckActive.')
  if (visual.has(name)) return done('interface/client/ui.' + name, name === 'notify' ? 'No servidor usa transporte até a notificação nativa no cliente.' : 'Adapters preservam callback, ownership e estado dos menus.')
  if (call === 'lib.setClipboard') return done('pr_lib.setClipboard')
  if (call === 'lib.getVehicleProperties') return done('pr_lib.fivem.vehicleProperties.get')
  if (call === 'lib.setVehicleProperties') return done('pr_lib.fivem.vehicleProperties.set / queue', 'Client: setter; server: fila nativa. Política ox de lockState preservada.')
  if (['addAce', 'removeAce', 'addPrincipal', 'removePrincipal'].includes(name)) return done('pr_lib.fivem.ace.' + name)
  if (name === 'versionCheck' || name === 'checkDependency') return done('pr_lib.github.' + name)
  if (module === 'timer') {
    return done('pr_lib.timer' + (entry.call.startsWith('timer:') ? ' -> Timer:' + entry.call.split(':')[1] : ''))
  }
  const info = importInfo.get(source)
  if (info?.nativeModules.length) {
    let target = info.nativeModules.join(', ')
    if (module === 'math') target = 'pr_lib.math.' + mathNames[entry.call.split('.').at(-1)]
    if (module === 'table') target = 'pr_lib.table.' + tableNames[entry.call.split('.').at(-1)]
    if (module === 'string') target = 'pr_lib.string.random'
    if (module === 'points') target = 'pr_lib.points' + (entry.call === 'point:remove' ? ' -> point:remove' : '.' + (entry.call.endsWith('.closest') ? 'getClosestPoint' : entry.call.split('.').at(-1)))
    if (module.startsWith('request')) {
      const names = { requestNamedPtfxAsset: 'requestPtfxAsset', requestStreamedTextureDict: 'requestTextureDict' }
      target = 'pr_lib.fivem.streaming.' + (names[module] || module)
    }
    if (module === 'streamingRequest') target = 'pr_lib.fivem.streaming.requestAsset'
    return done(target, 'Assinatura/defaults/retorno adaptados no import; implementação no módulo nativo.')
  }
  const [target, note] = candidates[module] || ['', 'Contrato específico ainda não consolidado.']
  return pending(module === 'callback' ? 'adapter de protocolo legado' : 'implementação legada mantida', target, note)
}

function add(call, parameters, file, line, kind = 'função', extra = {}) {
  const module = extra.module || (file.startsWith('imports/') ? file.split('/')[1] : 'serviços')
  const context = file === 'init.lua' && call === 'lib.notify' ? 'server' : file.endsWith('/client.lua') || file.startsWith('resource/interface/client/') ? 'client' : file.endsWith('/server.lua') ? 'server' : 'shared'
  const key = keyOf(call), item = entries.get(key) || { call, module, kind, signatures: [], ...extra }
  const signature = { context, parameters, source: file, line }
  if (!item.signatures.some(existing => JSON.stringify(existing) === JSON.stringify(signature))) item.signatures.push(signature)
  Object.assign(item, status(item, file))
  entries.set(key, item)
}

const objects = {
  addKeybind: { keybind_mt: 'keybind' }, disableControls: { disableControls: 'lib.disableControls' },
  marker: { marker_mt: 'marker' }, cron: { OxTask: 'cronTask' }, timer: { timer: 'timer' },
  selector: { OxSelector: 'lib.selector' }, registerHook: { EventHook: 'eventHook' }, class: { mixins: 'class' },
}
const publicName = (name, module) => {
  if (name.startsWith('lib.')) return name
  if (['math', 'table', 'string'].includes(module) && name.startsWith(module + '.')) return 'lib.' + name
  const [base, method] = name.split(/[:.]/)
  return method && objects[module]?.[base] ? objects[module][base] + (name.includes(':') ? ':' : '.') + method : null
}

for (const file of [...files(path.join(baseline, 'imports')), ...files(path.join(baseline, 'resource')), path.join(baseline, 'init.lua')]) {
  const source = relative(baseline, file), text = read(file), code = stripComments(text)
  const module = source.startsWith('imports/') ? source.split('/')[1] : 'serviços'
  sourceFiles.push({ file: source, sha256: hash(text) })
  if (importInfo.has(source) && importInfo.get(source).sha256 !== hash(text)) throw new Error('Baseline drift: ' + source)
  const definitions = new Map()
  for (const match of code.matchAll(/^[ \t]*(?:local\s+)?function\s+([\w.:]+)\s*\(([^)]*)\)/gm)) {
    definitions.set(keyOf(match[1]), { parameters: match[2], line: lineOf(code, match.index) })
    const call = publicName(match[1], module)
    if (!call) continue
    if (call.split(/[:.]/).at(-1).startsWith('__') && call !== 'lib.__addCommand' || call.endsWith(':constructor')) {
      excluded.push({ name: call, source, line: lineOf(code, match.index), reason: 'metamétodo ou constructor de ciclo de vida' })
      continue
    }
    add(call, match[2], source, lineOf(code, match.index), call.includes(':') ? 'método' : 'função')
  }
  for (const match of code.matchAll(/^(lib\.\w+)\s*=\s*lib\.class\(['"]\w+['"](?:,\s*(lib\.\w+))?\)/gm)) {
    classes.set(match[1], { module, parent: match[2], source, line: lineOf(code, match.index) })
  }
  if (module === 'selector') classes.set('lib.selector', { module, source, line: lineOf(code, code.indexOf('local OxSelector')) })
  // Explicit function aliases; assignments of tables/constants are not functions.
  for (const match of code.matchAll(/^[ \t]*([\w.]+)\s*=\s*([\w.]+)\s*$/gm)) {
    let call = publicName(match[1], module)
    const definition = definitions.get(keyOf(match[2]))
    if (!call || !definition || call.split('.').at(-1).startsWith('__')) continue
    if (classes.has(call.slice(0, call.lastIndexOf('.'))) && entries.get(keyOf(match[2]))?.call.includes(':')) call = call.replace(/\.([^.]+)$/, ':$1')
    add(call, definition.parameters, source, lineOf(code, match.index), 'alias', { aliasOf: publicName(match[2], module) || match[2] })
  }
  if (module === 'print') for (const match of code.matchAll(/^\s*(\w+)\s*=\s*function\(([^)]*)\)/gm)) add('lib.print.' + match[1], match[2], source, lineOf(code, match.index))
  if (module === 'callback') {
    const match = code.match(/__call\s*=\s*function\(_,\s*([^)]*)\)/)
    add('lib.callback', match[1], source, lineOf(code, match.index), 'tabela chamável')
  }
  if (module === 'disableControls') {
    const match = code.match(/__call\s*=\s*function\(([^)]*)\)/)
    add('lib.disableControls', match[1].replace(/^self,?\s*/, ''), source, lineOf(code, match.index), 'tabela chamável')
  }
  if (module === 'points') add('point:remove', '', source, lineOf(code, code.indexOf('local function removePoint')), 'método retornado', { module })
  if (module === 'zones') for (const [method, fn, parameters] of [['remove', 'removeZone', ''], ['contains', 'contains', 'coords, updateDistance'], ['setDebug', 'setDebug', 'bool, colour']]) {
    add('zone:' + method, parameters, source, lineOf(code, code.indexOf('local function ' + fn)), 'método retornado', { module })
    if (method === 'setDebug') entries.get('zone.setDebug').signatures[0].context = 'client'
  }
}

// Constructors are supplied by the class factory, not literally declared as lib.X.new.
for (const [name, info] of classes) {
  const sourceText = stripComments(read(path.join(baseline, info.source)))
  const constructor = sourceText.match(/function\s+(?:lib\.\w+|OxSelector):constructor\(([^)]*)\)/)
  add(name + ':new', constructor?.[1] || '...', info.source, info.line, 'construtor herdado', { module: info.module, suppliedBy: 'imports/class/shared.lua:97' })
}
// Returned timers and EventHooks inherit the two public class tests too.
const inherited = []
function inherit(call, method, sourceItem, module) {
  inherited.push({ ...sourceItem, call, module, kind: 'método herdado', inheritedFrom: sourceItem.call, signatures: sourceItem.signatures.map(signature => ({ ...signature })) })
}
for (const [name, info] of [...classes, ['timer', { module: 'timer' }], ['eventHook', { module: 'registerHook' }]]) {
  for (const method of ['isClass', 'instanceOf']) {
    const item = entries.get('class.' + method)
    inherit(name + ':' + method, method, item, info.module)
    if (name === 'timer') Object.assign(inherited.at(-1), done('bridge/utils/timer.lua', 'Métodos públicos de identificação/herança expostos no timer nativo.'))
  }
  let parent = info.parent
  const seenMethods = new Set([...entries.values()].filter(item => item.call.startsWith(name + ':')).map(item => item.call.split(':')[1]))
  while (parent) {
    for (const item of entries.values()) if (item.call.startsWith(parent + ':') || item.call.startsWith(parent + '.')) {
      const method = item.call.split(/[:.]/).at(-1)
      if (method === 'new' || seenMethods.has(method)) continue
      seenMethods.add(method)
      inherit(name + (item.call.includes(':') ? ':' : '.') + method, method, item, info.module)
    }
    parent = classes.get(parent)?.parent
  }
}

const list = [...entries.values()].sort((a, b) => a.module.localeCompare(b.module) || a.call.localeCompare(b.call))
const count = group => list.filter(item => item.group === group).length
const resourceExports = Object.keys(inventory.resourceExports)
for (const name of resourceExports) if (!entries.has('lib.' + name)) throw new Error('Uncatalogued resource API: ' + name)
const catalogText = read(path.join(root, 'bridge/compat/ox_catalog.lua')).split(' symbols = {')[1].split('\n },')[0]
for (const [, name] of catalogText.matchAll(/\["([^"\n]+)"\]/g)) if (!list.some(item => item.call === 'lib.' + name || item.call.startsWith('lib.' + name + '.') || item.call.startsWith('lib.' + name + ':'))) throw new Error('Uncatalogued top-level symbol: ' + name)
const result = { reviewedOn: '2026-10-10', baseline: inventory.baseline, bridgeVersion: inventory.bridgeVersion,
  scope: 'Lua lib.* + métodos públicos retornados; sem JS/TS, funções privadas, metamétodos ou duplicação por lado',
  summary: { entries: list.length, feito: count('feito'), analisar: count('analisar'),
    topLevelCallables: list.filter(item => /^lib\.\w+$/.test(item.call)).length,
    namespacedCallables: list.filter(item => item.call.startsWith('lib.') && !/^lib\.\w+$/.test(item.call)).length,
    returnedObjectMethods: list.filter(item => !item.call.startsWith('lib.')).length,
    inheritedAccessPaths: inherited.length,
    pendingMissingExposure: [...list, ...inherited].filter(item => item.detail.includes('não exposto') || item.detail.includes('lacuna de exposição')).map(item => item.call) },
  entries: list, inherited, excluded, sourceFiles }

function markdown() {
  const md = ['<!-- generated-by: gsd-doc-writer -->', '# Catálogo público Lua do ox_lib e situação no PR Bridge', '',
    `PR Bridge **${result.bridgeVersion}** · referência **${result.baseline}** · conferência **10/10/2026**`, '',
    `**${list.length} entradas de API catalogadas: ${count('feito')} no grupo feito; ${count('analisar')} no grupo analisar.** Há ainda ${inherited.length} caminhos de acesso herdados, listados separadamente e não somados como novas implementações.`, '',
    `Composição: ${result.summary.topLevelCallables} chamadas diretas do tipo lib.função, ${result.summary.namespacedCallables} funções/métodos em namespaces e ${result.summary.returnedObjectMethods} métodos de objetos retornados. Os totais não contam arquivos nem tratam um módulo inteiro como uma única função.`, '',
    '## Critério da separação', '',
    '- **Feito:** a chamada usa implementação canônica do PR Bridge, diretamente ou com adapter de assinatura/retorno/protocolo de UI.',
    '- **Analisar:** o contrato ainda mantém implementação legada/infraestrutura compat própria, tem consolidação parcial ou uma lacuna de exposição. Não significa que todas essas funções estejam ausentes ou quebradas.',
    '- Consolidação de implementação e testes offline, não homologação no FiveM. As 202 entradas anteriormente pendentes foram integradas à biblioteca canônica.', '',
    '## Como ler e reproduzir', '',
    'Uma entrada é um nome público. Client/server e overloads ficam na mesma linha. Aliases contam como nomes distintos, não como novos motores. `lib.array:map(fn)` representa o método da classe: no uso normal, crie `local arr = lib.array:new(...)` e chame `arr:map(fn)`; também é possível `lib.array.map(arr, fn)`. Não é `lib.array.map(fn)` sem self.', '',
    '`timer:...`, `keybind:...`, `point:...`, `zone:...`, `marker:...`, `cronTask:...` e `eventHook:...` são métodos do objeto retornado, não funções globais inventadas em lib. `class:...` corresponde à classe devolvida por `lib.class(...)`.', '',
    'C = cliente; S = servidor; C/S = arquivo compartilhado. Isso identifica onde a API é declarada, não garante que cada efeito exista dos dois lados: por exemplo, setRoutingBucket no cliente não aplica bucket, e setDebug de zonas só existe no cliente.', '',
    'Gerador read-only: `node scripts/catalog_ox_public_api.mjs "caminho/para/ox_lib" --json` (dados) ou `--markdown` (este texto). Sem flags imprime o resumo. Não escreve arquivos nem inicia recursos.', '',
    'A referência é a distribuição local 3.38.0, que inclui coleções/classes além de releases clássicos. Não é um catálogo de qualquer versão existente na internet. A saída --json do gerador registra fontes, linhas, hashes e critérios por entrada.', '']
  const context = item => {
    const sides = new Set(item.signatures.flatMap(signature => signature.context === 'shared' ? ['C', 'S'] : [signature.context === 'client' ? 'C' : 'S']))
    return ['C', 'S'].filter(side => sides.has(side)).join('/')
  }
  const code = value => '`' + value + '`'
  const cell = value => String(value).replaceAll('|', '\\|').replaceAll('\n', ' ')
  for (const group of ['feito', 'analisar']) {
    md.push('## ' + (group === 'feito' ? '1. Feito — implementação nativa reutilizada' : '2. Ainda não concluído — leitura e análise'), '')
    const modules = [...new Set(list.filter(item => item.group === group).map(item => item.module))]
    for (const module of modules) {
      const items = list.filter(item => item.group === group && item.module === module)
      md.push(`### ${module} (${items.length})`, '')
      if (group === 'analisar' && candidates[module]) md.push(candidates[module][1], '')
      md.push('| Chamada / assinatura | Lado | ' + (group === 'feito' ? 'Destino nativo' : 'Situação / próxima conferência') + ' |', '| --- | --- | --- |')
      for (const item of items) {
        const signatures = [...new Set(item.signatures.map(signature => `${item.call}(${signature.parameters})`))].map(code).join('<br>')
        const target = group === 'feito' ? item.target : item.detail + (item.target ? '; referência: ' + item.target : '')
        md.push(`| ${cell(signatures)} | ${context(item)} | ${cell(target)}${item.aliasOf ? '; alias de ' + code(item.aliasOf) : ''} |`)
      }
      md.push('')
    }
  }
  md.push('## 3. Lacunas de consolidação', '',
    'Nenhuma das 202 entradas originalmente pendentes permanece sem consolidação/exposição. `lib.cache`, `lib.hasLoaded`, `timer:run`, `timer:isClass` e `timer:instanceOf` foram incluídos. Locale, foco NUI e ownership de callbacks usam serviços canônicos.', '',
    'O teste native_library_test.lua verifica a presença das 202 entradas e aliases compartilhados nos dois contextos, além de comportamentos representativos. Isso não testa cada combinação/parâmetro em rede real. Renderização, CFX/GLM, providers HTTP e consumidores reais continuam exigindo teste no FiveM.', '',
    '## 4. Herança pública — sem esconder métodos das classes derivadas', '',
    'Estes são outros caminhos para implementações já listadas. Não são novas funções a reescrever. A origem indica a implementação que deve ser compartilhada.', '',
    '| Caminho de acesso | Origem | Grupo |', '| --- | --- | --- |')
  for (const item of inherited) md.push(`| ${code(item.call + '(' + item.signatures[0].parameters + ')')} | ${code(item.inheritedFrom)} | ${item.group}${item.detail.includes('não exposto') ? ' — não exposto no objeto nativo' : ''} |`)
  md.push('', 'As fábricas de classe também fornecem `:new(...)` por mixin; esses construtores já estão no catálogo principal. Em `player`, get/setRoutingBucket são sobrescritos pela própria classe; não se repetem como herança.', '',
    '## 5. Funções das bibliotecas Lua/CFX acessíveis por lib', '',
    '`lib.math = math`, `lib.string = string` e `lib.table = table`. Portanto expõem também as funções do runtime, além das extensões ox listadas acima. Não são implementação ox a copiar nem entram nos totais anteriores.', '',
    '| Namespace | Funções padrão Lua 5.4 acessíveis |', '| --- | --- |',
    '| `lib.math` | `abs`, `acos`, `asin`, `atan`, `ceil`, `cos`, `deg`, `exp`, `floor`, `fmod`, `log`, `max`, `min`, `modf`, `rad`, `random`, `randomseed`, `sin`, `sqrt`, `tan`, `tointeger`, `type`, `ult` |',
    '| `lib.string` | `byte`, `char`, `dump`, `find`, `format`, `gmatch`, `gsub`, `len`, `lower`, `match`, `pack`, `packsize`, `rep`, `reverse`, `sub`, `unpack`, `upper` |',
    '| `lib.table` | `concat`, `insert`, `move`, `pack`, `remove`, `sort`, `unpack` |', '',
    'Extensões CFX referenciadas no próprio código local: `lib.table.create`, `lib.table.clone`, `lib.table.wipe`, `lib.table.type` e `lib.string.strsplit`. Dependem do runtime CFX, não de reimplementação em imports. Outros extras do runtime dependem do artifact; o catálogo não simula presença em FiveM real.', '',
    '## 6. Globais e comportamentos relacionados, fora de lib.*', '',
    '| Nome | Situação |', '| --- | --- |',
    '| `locale(key, ...)` | Alias para o tradutor nativo do consumidor. Não é `lib.locale(key)`. |',
    '| `cache(key, fn, timeout)` e `cache.campo` | Adapter de cache no bootstrap / cache nativo no init PR. Não confundir com `lib.cache(key)`. |',
    '| `SetInterval(callbackOuId, interval, ...)` / `ClearInterval(id)` | Aliases do scheduler nativo bridge/tasks/interval. Fora da contagem lib.*. |',
    '| `require(name)` / `package.*` | Loader nativo por consumidor, reutilizando PRCore.loadFile/loadJson. |',
    '| `GetActivePlayers()` no servidor | Adapter em ox_runtime; converte IDs do runtime. |',
    '| `noop()` | Helper instalado pelo bootstrap/runtime; não é API lib.*. |',
    '| `lib("módulo")` | Metatable de carregamento/consulta; não é mais uma função de domínio. |', '',
    'Não entram como novas APIs: hooks de ciclo de vida `constructor`/`super`, metamétodos `__index`, `__pairs`, `__len`, `__pack`, etc.; callbacks fornecidos pelo consumidor (`onEnter`, `onExit`, `nearby`, `job`, ...); providers internos de logger; eventos/state bags; APIs de exports.ox_target; API JavaScript/TypeScript; propriedades não chamáveis como lib.name/context e cache.ped. As exclusões de declarações são rastreáveis no JSON.', '',
    '## 7. Próxima etapa: homologação em jogo', '',
    '1. Inicializar uma cópia de testes com o PR como fornecedor e o ox original parado.',
    '2. Testar callbacks entre dois jogadores, timeout, desconexão e alterações de estado autorizadas.',
    '3. Testar zonas GLM (polígono côncavo, altura, rotação, debug), DUI, scaleform, entidades e limpeza ao reiniciar consumidor.',
    '4. Testar arquivos/traduções reais, cron e providers de logger com credenciais de teste.', '',
    '## Fontes e limites da verificação', '',
    'Extração das declarações em init.lua, imports/**/*.lua e resource/**/*.lua da referência local, incluindo aliases, tabelas chamáveis, construtores por mixin e métodos retornados/inherdados. Cruzamento com ox_catalog, inventário de hashes, ox_phase1, ox_runtime, ox_bootstrap, ox_host, ox_native e módulos nativos.', '',
    'Verificações: tests/ox_public_api_catalog_test.mjs cobre declarações, aliases, tabelas chamáveis, construtores, métodos retornados, herança, contexto e paridade deste documento. tests/native_library_test.lua cobre as 202 entradas antes pendentes, identidade de aliases e comportamentos representativos. tests/ox_compat_test.lua cobre integração/protocolos com ambiente simulado. scripts/audit_ox_compat.mjs confere integridade dos módulos nativos e adapters. Não é teste no jogo.', '',
    'A presença de encaminhamento foi revisada no código. O catálogo não representa cobertura integral de testes por método nem porcentagem de compatibilidade real. UI/renderização, CFX Lua 5.4, rede e recursos consumidores precisam de homologação no FiveM.', '')
  return md.join('\n')
}

if (args.includes('--markdown')) console.log(markdown())
else if (args.includes('--json')) console.log(JSON.stringify(result, null, 2))
else console.log(JSON.stringify(result.summary, null, 2))
