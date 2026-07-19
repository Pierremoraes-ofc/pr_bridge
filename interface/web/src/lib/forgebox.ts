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

export function iconLabel(icon: unknown): string {
  if (typeof icon === 'string') return icon
  if (icon && typeof icon === 'object' && 'name' in (icon as Record<string, unknown>)) {
    return String((icon as Record<string, unknown>).name)
  }
  return ''
}

export type MetaItem = { label: string; value: string }

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
        return { label, value }
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
      return { border: '#37e35c', glow: 'rgba(55, 227, 92, 0.15)', icon: '✓' }
    case 'error':
      return { border: '#ff3b4f', glow: 'rgba(255, 59, 79, 0.15)', icon: '!' }
    case 'warning':
      return { border: '#ff9500', glow: 'rgba(255, 149, 0, 0.15)', icon: '⚠' }
    default:
      return { border: '#45e8ff', glow: 'rgba(69, 232, 255, 0.15)', icon: 'ℹ' }
  }
}
