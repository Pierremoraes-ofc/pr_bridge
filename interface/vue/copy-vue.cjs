const fs = require('fs')
const path = require('path')

const root = path.join(__dirname, '..')
const distAssets = path.join(root, 'dist', 'assets')
const vueSrc = path.join(
  process.env.USERPROFILE || '',
  '.cursor/projects/c-Users-brunopierre-Desktop-Trabalhos/agent-tools/4b6e1352-d4f5-48d7-aab5-660f482a3571.txt',
)

fs.mkdirSync(distAssets, { recursive: true })

if (!fs.existsSync(vueSrc)) {
  console.error('vue source missing:', vueSrc)
  process.exit(1)
}

const dest = path.join(distAssets, 'vue.global.prod.js')
fs.copyFileSync(vueSrc, dest)
console.log('ok', dest, fs.statSync(dest).size)
