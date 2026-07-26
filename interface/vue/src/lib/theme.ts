import { alphaColor } from './forgebox'

export type VisualConfig = {
  palette?: Record<string, string | number>
  layout?: Record<string, string>
}

const defaults: VisualConfig = {
  palette: {
    primary: '#ff7a1a', primaryHover: '#ff8c2a', success: '#10b981', warning: '#f59e0b',
    error: '#ef4444', info: '#3b82f6', text: '#ffffff', textMuted: '#8e8e9f',
    surface: '#0c0c0f', surfaceOpacity: 0.82, border: '#2d2d35',
  },
  layout: {
    registerContext: 'right', metadata: 'right', alertDialog: 'center', inputDialog: 'center',
    registerMenu: 'right', notify: 'top-right', progressBar: 'bottom-center', showTextUI: 'right-center',
  },
}

export function applyVisualConfig(input?: VisualConfig) {
  const palette = { ...defaults.palette, ...(input?.palette || {}) } as Record<string, string | number>
  const layout = { ...defaults.layout, ...(input?.layout || {}) } as Record<string, string>
  const root = document.documentElement
  const primary = String(palette.primary)
  const opacity = Math.max(0.15, Math.min(1, Number(palette.surfaceOpacity) || 0.82))

  root.style.setProperty('--fb-orange', primary)
  root.style.setProperty('--fb-orange-hover', String(palette.primaryHover))
  root.style.setProperty('--fb-orange-glow', alphaColor(primary, 0.45))
  root.style.setProperty('--fb-orange-glow-light', alphaColor(primary, 0.15))
  root.style.setProperty('--fb-orange-subtle', alphaColor(primary, 0.08))
  root.style.setProperty('--fb-orange-border', alphaColor(primary, 0.32))
  root.style.setProperty('--fb-orange-strong', alphaColor(primary, 0.72))
  root.style.setProperty('--fb-success', String(palette.success))
  root.style.setProperty('--fb-warning', String(palette.warning))
  root.style.setProperty('--fb-error', String(palette.error))
  root.style.setProperty('--fb-info', String(palette.info))
  root.style.setProperty('--fb-text', String(palette.text))
  root.style.setProperty('--fb-text-grey', String(palette.textMuted))
  root.style.setProperty('--fb-text-muted', alphaColor(String(palette.textMuted), 0.7))
  root.style.setProperty('--fb-border', alphaColor(String(palette.border), 0.72))
  root.style.setProperty('--fb-border-hover', String(palette.border))
  root.style.setProperty('--fb-nui-surface', alphaColor(String(palette.surface), opacity))
  root.style.setProperty('--fb-nui-field', alphaColor(String(palette.surface), Math.min(1, opacity + 0.08)))

  root.dataset.contextSide = layout.registerContext
  root.dataset.metadataSide = layout.metadata
  root.dataset.alertSide = layout.alertDialog
  root.dataset.inputSide = layout.inputDialog
  root.dataset.menuSide = layout.registerMenu
  root.dataset.notifyPosition = layout.notify
  root.dataset.progressPosition = layout.progressBar
  root.dataset.textuiPosition = layout.showTextUI
}
