const palette: Record<string, string> = {
  orange: '#ff7a1a',
  blue: '#3b82f6',
  green: '#10b981',
  yellow: '#f59e0b',
  red: '#ef4444',
  purple: '#8b5cf6',
  cyan: '#06b6d4',
}

export function resolveColor(color?: string): string {
  if (!color) return palette.orange
  return palette[color] || color
}

export function alphaColor(color: string, alpha: number): string {
  const resolved = resolveColor(color)
  if (resolved.startsWith('#')) {
    const raw = resolved.slice(1)
    const hex = raw.length === 3 ? raw.split('').map((c) => c + c).join('') : raw
    const value = parseInt(hex, 16)
    if (!Number.isNaN(value)) {
      return `rgba(${(value >> 16) & 255}, ${(value >> 8) & 255}, ${value & 255}, ${alpha})`
    }
  }
  if (resolved.startsWith('var(')) return resolved
  return resolved
}

const bootstrapIconAliases: Record<string, string> = {
  'arrow-down-to-line': 'download',
  'arrow-left': 'arrow-left',
  'arrows-to-dot': 'bounding-box-circles',
  'arrow-up-from-line': 'upload',
  bars: 'list',
  bell: 'bell-fill',
  'book-open': 'book-fill',
  bolt: 'lightning-fill',
  box: 'box-seam-fill',
  'box-open': 'box-seam-fill',
  'box-select': 'bounding-box',
  'boxes-stacked': 'boxes',
  brain: 'activity',
  briefcase: 'briefcase-fill',
  'briefcase-business': 'briefcase-fill',
  'building-2': 'buildings-fill',
  car: 'car-front-fill',
  'cart-shopping': 'cart-fill',
  'chart-no-axes-combined': 'graph-up-arrow',
  check: 'check-lg',
  circle: 'circle-fill',
  'circle-dollar-sign': 'currency-dollar',
  'circle-dot': 'record-circle',
  'circle-info': 'info-circle-fill',
  'circle-question': 'question-circle-fill',
  'clipboard-question': 'clipboard2-check-fill',
  close: 'x-lg',
  crosshairs: 'crosshair',
  crown: 'award-fill',
  cube: 'box-fill',
  dolly: 'cart4',
  'file-signature': 'file-earmark-text-fill',
  'flag-checkered': 'flag-fill',
  gauge: 'speedometer2',
  'heart-pulse': 'heart-pulse-fill',
  hand: 'hand-index-thumb-fill',
  'hourglass-half': 'hourglass-split',
  'key-round': 'key-fill',
  landmark: 'bank2',
  'list-checks': 'list-check',
  'list-ordered': 'list-ol',
  'location-arrow': 'cursor-fill',
  'location-crosshairs': 'crosshair',
  'location-dot': 'geo-alt-fill',
  'lock-open': 'unlock-fill',
  'magnifying-glass': 'search',
  map: 'map-fill',
  'map-location-dot': 'geo-alt-fill',
  'map-pin': 'geo-alt-fill',
  'map-pinned': 'pin-map-fill',
  'message-square': 'chat-square-fill',
  'message-square-text': 'chat-square-text-fill',
  'money-bill-wave': 'cash-stack',
  'move-3d': 'arrows-move',
  'network-wired': 'diagram-3-fill',
  package: 'box-seam-fill',
  'pen-to-square': 'pencil-square',
  'person-running': 'person-walking',
  'plane-arrival': 'airplane-engines-fill',
  plug: 'plug-fill',
  'refresh-cw': 'arrow-clockwise',
  'right-left': 'arrow-left-right',
  'rotate-ccw': 'arrow-counterclockwise',
  route: 'signpost-split-fill',
  scan: 'upc-scan',
  seedling: 'flower1',
  'server-cog': 'server',
  settings: 'gear-fill',
  shield: 'shield-fill',
  'shield-alt': 'shield-lock-fill',
  skull: 'emoji-dizzy-fill',
  'sliders-horizontal': 'sliders',
  snowflake: 'snow',
  spinner: 'arrow-repeat',
  spotlight: 'lamp-fill',
  store: 'shop',
  toolbox: 'tools',
  target: 'bullseye',
  tractor: 'truck-front-fill',
  'traffic-cone': 'cone-striped',
  'trash-2': 'trash',
  user: 'person-fill',
  'user-gear': 'person-gear',
  'user-check': 'person-check-fill',
  'user-lock': 'person-lock',
  'user-minus': 'person-dash-fill',
  'user-plus': 'person-plus-fill',
  'user-x': 'person-x-fill',
  'user-round': 'person-circle',
  users: 'people-fill',
  'users-gear': 'people-fill',
  'users-round': 'people-fill',
  vault: 'safe2-fill',
  video: 'camera-video-fill',
  wallet: 'wallet2',
  'wand-sparkles': 'magic',
  warehouse: 'building-fill',
  wrench: 'wrench-adjustable',
}

export function iconName(icon: unknown): string {
  let name = ''

  if (typeof icon === 'string') {
    name = icon
  } else if (icon && typeof icon === 'object' && 'name' in (icon as Record<string, unknown>)) {
    name = String((icon as Record<string, unknown>).name)
  }

  const normalized = name
    .trim()
    .toLowerCase()
    .replace(/^fa-(solid|regular|brands)\s+/, '')
    .replace(/^fa[srlbd]?\s+/, '')
    .replace(/^fa-/, '')
    .replace(/^bi\s+/, '')
    .replace(/^bi-/, '')

  if (!normalized) return 'circle-fill'
  return bootstrapIconAliases[normalized] || normalized
}

export type MetaItem = {
  label: string
  value: string
  image?: string
  progress?: number
  colorScheme?: string
}

export function metaItems(metadata: unknown): MetaItem[] {
  if (!metadata) return []
  if (typeof metadata === 'string') return [{ label: '', value: metadata }]
  if (Array.isArray(metadata)) {
    return metadata.map((item) => {
      if (typeof item === 'string') return { label: '', value: item }
      if (item && typeof item === 'object') {
        const obj = item as Record<string, unknown>
        const label = String(obj.label ?? obj.title ?? '')
        const value = String(obj.value ?? obj.description ?? '')
        return {
          label,
          value,
          image: typeof obj.image === 'string' ? obj.image : undefined,
          progress: typeof obj.progress === 'number' ? obj.progress : undefined,
          colorScheme: typeof obj.colorScheme === 'string' ? obj.colorScheme : undefined,
        }
      }
      return { label: '', value: String(item) }
    })
  }
  if (typeof metadata === 'object') {
    return Object.entries(metadata as Record<string, unknown>).map(([label, value]) => ({
      label,
      value: String(value),
    }))
  }
  return []
}

export function notifyTone(type?: string) {
  switch (type) {
    case 'success':
      return { border: 'var(--fb-success)', glow: 'var(--fb-success)', icon: 'check-circle-fill' }
    case 'error':
      return { border: 'var(--fb-error)', glow: 'var(--fb-error)', icon: 'x-circle-fill' }
    case 'warning':
      return { border: 'var(--fb-warning)', glow: 'var(--fb-warning)', icon: 'exclamation-triangle-fill' }
    default:
      return { border: 'var(--fb-info)', glow: 'var(--fb-info)', icon: 'info-circle-fill' }
  }
}
