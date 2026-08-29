import { alphaColor } from './forgebox'

export type VisualConfig = {
  palette?: Record<string, string | number>
  layout?: Record<string, string>
  target?: Record<string, string | number | boolean>
  interact?: Record<string, string | number | boolean>
  bubble?: Record<string, string | number>
}

const defaults: VisualConfig = {
  palette: {
    primary: '#ff7a1a', primaryHover: '#ff8c2a', success: '#10b981', warning: '#f59e0b',
    error: '#ef4444', info: '#3b82f6', text: '#ffffff', textMuted: '#8e8e9f',
    surface: '#0c0c0f', surfaceOpacity: 0.82, border: '#2d2d35',
  },
  layout: {
    registerContext: 'right', metadata: 'right', alertDialog: 'center', inputDialog: 'center',
    registerMenu: 'right', notify: 'top-right', progressBar: 'bottom-center', skillCheck: 'bottom-center', showTextUI: 'right-center',
  },
  target: {
    x: 50, y: 50, optionsY: 48.4, offsetX: 24, width: 200, height: 29.33,
    eyeSize: 36, eyeScale: 1, eyeIcon: 'fa-solid fa-eye', scale: 1, fontSize: 14.67, color: '#cfd2da', hoverColor: '#ffffff',
    eyeColor: '#000000', background: '#141414', hoverBackground: '#1e1e1e',
    backgroundOpacity: 0.70, backgroundFade: 0.60,
    markerColor: '#9b9b9b', markerHoverColor: '#6287ec', markerOpacity: 0.69,
    markerIcon: 'bi bi-circle', markerTargetIcon: 'bi bi-record-circle', markerChangeOnTarget: true,
    markerDistance: 5, markerSize: 30, markerScale: 1, markerTargetScale: 1, markerEffect: 'pulse-glow', markerEffectSpeed: 1.2, markerEffectStrength: 1.25, wallDetection: true, wallRayFlags: 277,
  },
  interact: {
    style: 'obtaizen_ui', scale: 1, pinSize: 32, keySize: 38, bulletSize: 17,
    optionWidth: 180, optionHeight: 30, optionGap: 3, fontSize: 14,
    pinColor: '#7656ff', keyColor: '#7656ff', selectedColor: '#7656ff',
    unselectedColor: '#777777', textColor: '#ffffff', backgroundOpacity: 0.92,
    wallDetection: true, wallRayFlags: 277,
    disableOnDeath: true, disableOnNuiFocus: true, disableInVehicle: true, disableWhenCuffed: true,
  },
  bubble: {
    background: '#ffffff', backgroundOpacity: 0.96, border: '#222222', borderOpacity: 0.92,
    text: '#161616', minWidth: 100, maxWidth: 300, borderWidth: 2, radius: 18,
    tailSize: 16, fontSize: 11, titleSize: 12,
  },
}

export function applyVisualConfig(input?: VisualConfig) {
  const palette = { ...defaults.palette, ...(input?.palette || {}) } as Record<string, string | number>
  const layout = { ...defaults.layout, ...(input?.layout || {}) } as Record<string, string>
  const target = { ...defaults.target, ...(input?.target || {}) } as Record<string, string | number>
  const interact = { ...defaults.interact, ...(input?.interact || {}) } as Record<string, string | number>
  const bubble = { ...defaults.bubble, ...(input?.bubble || {}) } as Record<string, string | number>
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

  root.style.setProperty('--pr-target-x', `${Number(target.x)}%`)
  root.style.setProperty('--pr-target-y', `${Number(target.y)}%`)
  root.style.setProperty('--pr-target-options-y', `${Number(target.optionsY)}%`)
  root.style.setProperty('--pr-target-offset-x', `${Number(target.offsetX)}px`)
  root.style.setProperty('--pr-target-width', `${Number(target.width)}px`)
  root.style.setProperty('--pr-target-height', `${Number(target.height)}px`)
  root.style.setProperty('--pr-target-eye-size', `${Number(target.eyeSize)}px`)
  root.style.setProperty('--pr-target-eye-scale', String(Number(target.eyeScale)))
  root.style.setProperty('--pr-target-scale', String(Number(target.scale)))
  root.style.setProperty('--pr-target-font-size', `${Number(target.fontSize)}px`)
  root.style.setProperty('--pr-target-color', String(target.color))
  root.style.setProperty('--pr-target-hover', String(target.hoverColor))
  root.style.setProperty('--pr-target-eye', String(target.eyeColor))
  root.style.setProperty('--pr-target-background', String(target.background))
  root.style.setProperty('--pr-target-hover-background', String(target.hoverBackground))
  root.style.setProperty('--pr-target-background-opacity', `${Number(target.backgroundOpacity) * 100}%`)
  root.style.setProperty('--pr-target-background-fade', `${Number(target.backgroundFade) * 100}%`)
  root.style.setProperty('--pr-target-background-color', alphaColor(String(target.background), Number(target.backgroundOpacity)))
  root.style.setProperty('--pr-target-background-fade-color', alphaColor(String(target.background), Number(target.backgroundFade)))
  root.style.setProperty('--pr-target-hover-background-color', alphaColor(String(target.hoverBackground), Number(target.backgroundOpacity)))
  root.style.setProperty('--pr-target-hover-background-fade-color', alphaColor(String(target.hoverBackground), Number(target.backgroundFade)))
  root.style.setProperty('--pr-target-marker-color', String(target.markerColor))
  root.style.setProperty('--pr-target-marker-hover', String(target.markerHoverColor))
  root.style.setProperty('--pr-target-marker-opacity', String(Number(target.markerOpacity)))
  root.style.setProperty('--pr-target-marker-size', `${Number(target.markerSize)}px`)
  root.style.setProperty('--pr-target-marker-scale', String(Number(target.markerScale)))
  root.style.setProperty('--pr-target-marker-target-scale', String(Number(target.markerTargetScale)))
  root.style.setProperty('--pr-target-marker-effect-speed', `${Number(target.markerEffectSpeed)}s`)
  root.style.setProperty('--pr-target-marker-effect-strength', String(Number(target.markerEffectStrength)))
  root.style.setProperty('--pr-interact-scale', String(Number(interact.scale)))
  root.style.setProperty('--pr-interact-pin-size', String(Number(interact.pinSize)) + 'px')
  root.style.setProperty('--pr-interact-key-size', String(Number(interact.keySize)) + 'px')
  root.style.setProperty('--pr-interact-bullet-size', String(Number(interact.bulletSize)) + 'px')
  root.style.setProperty('--pr-interact-option-width', String(Number(interact.optionWidth)) + 'px')
  root.style.setProperty('--pr-interact-option-height', String(Number(interact.optionHeight)) + 'px')
  root.style.setProperty('--pr-interact-option-gap', String(Number(interact.optionGap)) + 'px')
  root.style.setProperty('--pr-interact-font-size', String(Number(interact.fontSize)) + 'px')
  root.style.setProperty('--pr-interact-pin-color', String(interact.pinColor))
  root.style.setProperty('--pr-interact-key-color', String(interact.keyColor))
  root.style.setProperty('--pr-interact-selected-color', String(interact.selectedColor))
  root.style.setProperty('--pr-interact-unselected-color', String(interact.unselectedColor))
  root.style.setProperty('--pr-interact-text-color', String(interact.textColor))
  root.style.setProperty('--pr-interact-background-opacity', String(Number(interact.backgroundOpacity)))
  root.style.setProperty('--pr-bubble-background-color', alphaColor(String(bubble.background), Number(bubble.backgroundOpacity)))
  root.style.setProperty('--pr-bubble-border-color', alphaColor(String(bubble.border), Number(bubble.borderOpacity)))
  root.style.setProperty('--pr-bubble-text', String(bubble.text))
  root.style.setProperty('--pr-bubble-min-width', `${Number(bubble.minWidth)}px`)
  root.style.setProperty('--pr-bubble-max-width', `${Number(bubble.maxWidth)}px`)
  root.style.setProperty('--pr-bubble-border-width', `${Number(bubble.borderWidth)}px`)
  root.style.setProperty('--pr-bubble-radius', `${Number(bubble.radius)}px`)
  root.style.setProperty('--pr-bubble-tail-size', `${Number(bubble.tailSize)}px`)
  root.style.setProperty('--pr-bubble-font-size', `${Number(bubble.fontSize)}px`)
  root.style.setProperty('--pr-bubble-title-size', `${Number(bubble.titleSize)}px`)
  root.dataset.contextSide = layout.registerContext
  root.dataset.metadataSide = layout.metadata
  root.dataset.alertSide = layout.alertDialog
  root.dataset.inputSide = layout.inputDialog
  root.dataset.menuSide = layout.registerMenu
  root.dataset.notifyPosition = layout.notify
  root.dataset.progressPosition = layout.progressBar
  root.dataset.skillcheckPosition = layout.skillCheck
  root.dataset.textuiPosition = layout.showTextUI
}
