const positions = new Set(['top', 'top-right', 'top-left', 'bottom', 'bottom-right', 'bottom-left', 'center-right', 'center-left'])
export function notificationGroups(items, position) {
  const aliases = { 'top-center': 'top', 'bottom-center': 'bottom', 'left-center': 'center-left', 'right-center': 'center-right' }
  position = aliases[position] || position
  const fallback = positions.has(position) ? position : 'top-right'
  const grouped = new Map()
  for (const item of items) {
    const key = positions.has(item.position) ? item.position : fallback
    if (!grouped.has(key)) grouped.set(key, [])
    grouped.get(key).push(item)
  }
  return [...grouped].map(([position, items]) => ({ position, items }))
}
export function cssStyle(value) {
  return Object.entries(value || {}).filter(([, value]) => ['number', 'string'].includes(typeof value))
    .map(([key, value]) => `${key.startsWith('--') ? key : key.replace(/[A-Z]/g, letter => '-' + letter.toLowerCase())}:${value}`).join(';')
}
