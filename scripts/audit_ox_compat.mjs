// Read-only inventory/audit; never edits resources or starts a FiveM server.
import fs from 'node:fs'
import path from 'node:path'
import crypto from 'node:crypto'
import { fileURLToPath } from 'node:url'
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const args = process.argv.slice(2)
const baseline = args.find(arg => !arg.startsWith('--'))
const read = file => fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n')
const hash = file => crypto.createHash('sha256').update(read(file)).digest('hex')
function files(directory, suffix) {
  if (!fs.existsSync(directory)) return []
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
    const file = path.join(directory, entry.name)
    return entry.isDirectory() ? files(file, suffix) : file.endsWith(suffix) ? [file] : []
  }).sort()
}
const relative = (base, file) => path.relative(base, file).split(path.sep).join('/')
const catalog = read(path.join(root, 'bridge/compat/ox_catalog.lua'))
const moduleSection = catalog.split(' modules = {')[1].split('\n },')[0]
const symbolSection = catalog.split(' symbols = {')[1].split('\n },')[0]
const modules = [...moduleSection.matchAll(/\["([^"\n]+)"\]/g)].map(match => match[1]).filter(name => !['shared', 'client', 'server'].includes(name))
const symbols = [...symbolSection.matchAll(/\["([^"\n]+)"\]/g)].map(match => match[1])
if (!baseline) {
  const inventory = JSON.parse(read(path.join(root, 'docs/ox_compatibility_inventory.json')))
  const mismatch = []
  for (const entry of [...inventory.entries, ...inventory.nativeFiles, ...inventory.locales]) {
    const file = path.join(root, entry.file)
    if (!fs.existsSync(file) || hash(file) !== entry.providerSha256) mismatch.push(entry.file)
  }
  if (files(path.join(root, 'bridge/compat/ox_services'), '.lua').length) mismatch.push('duplicate ox_services')
  const actual = files(path.join(root, 'imports'), '.lua').length
  if (actual !== inventory.importFiles || modules.length !== inventory.modules || symbols.length !== inventory.symbols) mismatch.push('catalog counts')
  if (mismatch.length) throw new Error('Inventory mismatch: ' + mismatch.join(', '))
  console.log(`PASS inventory integrity: ${actual} imports, ${modules.length} modules, ${symbols.length} top-level symbols, ${inventory.resourceExportCount} resource exports, ${inventory.locales.length} locales`)
} else {
  const source = path.resolve(baseline)
  const entries = files(path.join(source, 'imports'), '.lua').map(file => {
    const name = relative(source, file), provider = path.join(root, name)
    const sha256 = hash(file), providerSha256 = hash(provider)
    const nativeModules = [...read(provider).matchAll(/lib\.__native\('([^']+)'\)|PRCore\.load\('@pr_bridge\/([^']+)'/g)].map(match => match[1] || match[2])
    if (name.startsWith('imports/callback/')) nativeModules.push('bridge/callback/transport')
    return { file: name, sha256, providerSha256, modified: sha256 !== providerSha256, adapted: read(file).trimEnd() !== read(provider).trimEnd(),
      nativeModules,
      status: nativeModules.length ? 'native PR routing adapter; offline contracts checked; FiveM pending'
        : name.startsWith('imports/callback/') ? 'legacy protocol adapter; offline callback contracts passed; FiveM pending'
        : 'legacy-specific contract; no claim of native-equivalent redirection; FiveM pending' }
  })
  const resourceExports = {}
  for (const file of files(path.join(source, 'resource'), '.lua')) {
    const name = relative(source, file)
    const context = name.includes('/server') ? 'server' : name.includes('/client') ? 'client' : 'shared'
    for (const match of read(file).matchAll(/function\s+lib\.([\w]+)\s*\(([^)]*)\)/g)) {
      ;(resourceExports[match[1]] ||= {})[context] = { parameters: match[2], source: name }
    }
  }
  const routes = [
    { legacy: 'getVehicleProperties/setVehicleProperties', adapter: 'bridge/compat/ox_native.lua', native: 'fivem.vehicleProperties.get/set/queue/applyQueue' },
    { legacy: 'checkDependency/versionCheck', adapter: 'bridge/compat/ox_native.lua', native: 'github.checkDependency/versionCheck' },
    { legacy: 'addAce/removeAce/addPrincipal/removePrincipal', adapter: 'bridge/compat/ox_native.lua', native: 'fivem.ace' },
    { legacy: 'progressBar/progressCircle/progressActive/cancelProgress', adapter: 'bridge/compat/ox_host.lua', native: 'nativeProgress + progressProps' },
    { legacy: 'ox_lib:requestSetStateBag', adapter: 'bridge/compat/ox_protocol.lua', native: 'fivem.state.requestSet (legacy authorization policy)' },
    { legacy: 'ox_entity_setonground', adapter: 'bridge/compat/ox_protocol.lua', native: 'fivem.streaming.placeEntityProperly' },
  ]
  const implementationFiles = [
    'bridge/compat/ox_native.lua', 'bridge/compat/ox_protocol.lua', 'bridge/compat/ox_command.lua',
    'bridge/compat/ox_host.lua', 'bridge/compat/ox_runtime.lua', 'bridge/compat/entities_client.lua',
    'bridge/github/client.lua', 'bridge/github/server.lua', 'bridge/ace/server.lua',
    'bridge/fivem/client.lua', 'bridge/fivem/server.lua', 'bridge/fivem/state/server.lua',
    'bridge/fivem/vehicleProperties/client.lua', 'bridge/fivem/vehicleProperties/server.lua',
    'bridge/fivem/streaming/client.lua', 'bridge/fivem/objects/client.lua', 'bridge/fivem/objects/server.lua',
    'bridge/fivem/proximity/shared.lua', 'bridge/fivem/spatial/client.lua',
    'bridge/fivem/controls/client.lua',
    'bridge/utils/waitFor.lua', 'bridge/utils/numbers.lua', 'bridge/utils/tables.lua', 'bridge/utils/strings.lua', 'bridge/utils/timer.lua',
    'bridge/addKeybind/client.lua', 'bridge/addCommand/server.lua', 'bridge/triggerClientEvent/server.lua',
    'bridge/progressbar/native/client.lua', 'bridge/progressbar/native/props_client.lua', 'bridge/progressbar/native/props_server.lua',
    'bridge/init.lua', 'init.lua',
    'bridge/core.lua', 'bridge/callback/client.lua', 'bridge/callback/server.lua',
    'bridge/fivem/nui/client.lua', 'bridge/compat/ox_callback.lua',
  ]
  for (const directory of ['bridge/library','bridge/collections','bridge/entities','bridge/hooks','bridge/files','bridge/i18n','bridge/tasks','bridge/logging','bridge/callback','bridge/fivem/zones','bridge/fivem/grid','bridge/fivem/relativeCoords','bridge/fivem/marker','bridge/fivem/scaleform','bridge/fivem/state']) {
    implementationFiles.push(...files(path.join(root,directory),'.lua').map(file=>relative(root,file)))
  }
  implementationFiles.push('bridge/utils/class.lua','bridge/utils/uuid.lua')
  const nativeFiles = [...new Set(implementationFiles)].sort().map(file => ({file, providerSha256: hash(path.join(root,file))}))
  const locales = files(path.join(source, 'locales'), '.json').map(origin => {
    const file = 'bridge/compat/ox_locales/' + path.basename(origin)
    return { file, origin: relative(source, origin), sha256: hash(origin), providerSha256: hash(path.join(root, file)) }
  })
  const inventory = { baseline: 'ox_lib 3.38.0 (local distribution)', bridgeVersion: '1.4.2', contractVersion: '3.38.0',
    reviewedOn: '2026-10-10', importFiles: entries.length, modules: modules.length, symbols: symbols.length,
    resourceExportCount: Object.keys(resourceExports).length,
    note: 'Counts describe files/modules/top-level symbols, not every class method or a percentage of runtime compatibility.',
    validation: { offline: 'see OX_COMPATIBILITY.md and tests/ox_compat_test.lua', FiveM: 'pending', nativeCompiler: 'CFX syntax normalized in memory for Lua 5.5; actual CFX Lua 5.4 compilation pending' },
    oxTarget: { baseline: 'Overextended public client API (no original local resource found)', implementation: 'internal legacy export discovery + native PR Target', FiveM: 'pending' },
    architecture: 'native-first; adapters convert signatures, wire names and policies only',
    nativeRoutedImports: entries.filter(entry => entry.nativeModules.length).length,
    entries, resourceExports, routes, nativeFiles, locales }
  if (args.includes('--json')) console.log(JSON.stringify(inventory, null, 2))
  else console.log(JSON.stringify({ imports: entries.length, modules: modules.length, symbols: symbols.length, resourceExports: Object.keys(resourceExports).length, nativeRoutedImports: inventory.nativeRoutedImports, legacySpecificImports: entries.filter(entry => !entry.nativeModules.length).map(entry => entry.file), locales: locales.length }, null, 2))
}
