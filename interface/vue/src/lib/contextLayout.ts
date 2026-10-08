// Event-driven sizing: only the visible metadata panel is observed.
export function metadataLayout(node: HTMLElement, options: { top: number; left: number; side: 'left' | 'right'; element?: HTMLElement }) {
  let anchor = options
  const place = () => {
    const margin = 12
    const item = anchor.element?.getBoundingClientRect()
    let side = anchor.side
    if (item) {
      const leftRoom = item.left - 24
      const rightRoom = window.innerWidth - item.right - 24
      const preferredRoom = side === 'left' ? leftRoom : rightRoom
      const alternateRoom = side === 'left' ? rightRoom : leftRoom
      if (preferredRoom < 140 && alternateRoom > preferredRoom) side = side === 'left' ? 'right' : 'left'
      const room = side === 'left' ? leftRoom : rightRoom
      node.style.width = Math.min(270, Math.max(80, room), window.innerWidth - 24) + 'px'
    }
    const rect = node.getBoundingClientRect()
    const edge = item ? (side === 'left' ? item.left - 12 : item.right + 12) : anchor.left
    const center = item ? item.top + item.height / 2 : anchor.top
    const preferred = side === 'left' ? edge - rect.width : edge
    const alternate = item ? (side === 'left' ? item.right + 12 : item.left - 12 - rect.width)
      : side === 'left' ? anchor.left + 24 : anchor.left - rect.width - 24
    const fits = (x: number) => x >= margin && x + rect.width <= window.innerWidth - margin
    const left = fits(preferred) ? preferred : fits(alternate) ? alternate : preferred
    node.style.left = Math.max(margin, Math.min(left, window.innerWidth - rect.width - margin)) + 'px'
    node.style.top = Math.max(margin, Math.min(center - rect.height / 2, window.innerHeight - rect.height - margin)) + 'px'
  }
  const observer = new ResizeObserver(place)
  observer.observe(node)
  window.addEventListener('resize', place)
  place()
  return {
    update(next: typeof options) {
      if (next.element !== anchor.element) node.scrollTop = 0
      anchor = next; place()
    },
    destroy() { observer.disconnect(); window.removeEventListener('resize', place) },
  }
}

export function menuLogo(value: unknown, fallback: string): string {
  if (typeof value !== 'string' || value.length > 2048) return fallback
  try {
    const url = new URL(value)
    return ['http:', 'https:'].includes(url.protocol) && !url.username && !url.password ? url.href : fallback
  } catch { return fallback }
}
