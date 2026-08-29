<script lang="ts">
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  type BubbleItem = {
    id: string
    title?: string
    text?: string
    icon?: string
    color?: string
    textColor?: string
    background?: string
    opacity?: number
    borderColor?: string
    borderOpacity?: number
    x?: number
    y?: number
    scale?: number
    stack?: number
  }

  export let items: BubbleItem[] = []

  function hexToRgba(hex: string, opacity: number, fallback: string) {
    const value = /^#[0-9a-f]{6}$/i.test(hex || '') ? hex : fallback
    const alpha = Math.max(0, Math.min(1, Number(opacity)))
    const red = parseInt(value.slice(1, 3), 16)
    const green = parseInt(value.slice(3, 5), 16)
    const blue = parseInt(value.slice(5, 7), 16)
    return `rgba(${red}, ${green}, ${blue}, ${alpha})`
  }

  function position(item: BubbleItem) {
    const stackOffset = Math.max(0, Number(item.stack) || 0) * 78
    const background = item.background
      ? hexToRgba(item.background, item.opacity ?? 0.96, '#ffffff')
      : 'var(--pr-bubble-background-color)'
    const border = item.borderColor
      ? hexToRgba(item.borderColor, item.borderOpacity ?? 1, '#222222')
      : 'var(--pr-bubble-border-color)'

    return `left:${Number(item.x) || 50}%; top:calc(${Number(item.y) || 50}% - ${stackOffset}px); transform:translate(-18%, -100%) scale(${Number(item.scale) || 1}); --bubble-bg:${background}; --bubble-border:${border}; --bubble-accent:${item.color || 'var(--fb-orange)'}; --bubble-text:${item.textColor || 'var(--pr-bubble-text)'};`
  }
</script>

<div class="bubble-layer" aria-live="polite">
  {#each items as item (item.id)}
    <div class="bubble" style={position(item)}>
      <div class="bubble__body">
        {#if item.icon}
          <span class="bubble__icon"><BootstrapIcon name={item.icon} /></span>
        {/if}
        <div class="bubble__content">
          {#if item.title}<strong>{item.title}</strong>{/if}
          {#if item.text}<span>{item.text}</span>{/if}
        </div>
        <i class="bubble__tail"></i>
      </div>
    </div>
  {/each}
</div>

<style>
  .bubble-layer { position: fixed; inset: 0; overflow: hidden; pointer-events: none; z-index: 7800; }
  .bubble { position: absolute; transform-origin: 18% calc(100% + var(--pr-bubble-tail-size)); will-change: left, top, transform; transition: left .035s linear, top .035s linear; filter: drop-shadow(0 5px 12px rgba(0,0,0,.42)); }
  .bubble__body { position: relative; width: max-content; min-width: var(--pr-bubble-min-width); max-width: var(--pr-bubble-max-width); min-height: 40px; padding: 8px 13px; display: flex; align-items: center; justify-content: center; gap: 7px; box-sizing: border-box; color: var(--bubble-text); background: var(--bubble-bg); border: var(--pr-bubble-border-width) solid var(--bubble-border); border-radius: var(--pr-bubble-radius); box-shadow: inset 0 0 0 1px rgba(255,255,255,.18), 0 0 12px color-mix(in srgb, var(--bubble-accent) 20%, transparent); animation: bubble-in .2s cubic-bezier(.15,.8,.25,1); }
  .bubble__tail { position: absolute; z-index: -1; left: 18%; bottom: calc(var(--pr-bubble-tail-size) * -.88); width: calc(var(--pr-bubble-tail-size) * 1.35); height: var(--pr-bubble-tail-size); transform: translateX(-50%); background: var(--bubble-border); clip-path: polygon(0 0, 100% 0, 67% 30%, 48% 62%, 61% 100%, 27% 78%, 10% 44%); }
  .bubble__tail::after { content: ''; position: absolute; inset: var(--pr-bubble-border-width); background: var(--bubble-bg); clip-path: inherit; }
  .bubble__icon { position: relative; z-index: 1; flex: 0 0 auto; display: grid; place-items: center; color: var(--bubble-accent); font-size: 17px; }
  .bubble__content { position: relative; z-index: 1; display: flex; min-width: 0; flex-direction: column; gap: 2px; text-align: center; line-height: 1.2; overflow-wrap: anywhere; word-break: break-word; }
  .bubble__content strong { color: color-mix(in srgb, var(--bubble-accent) 72%, var(--bubble-text)); font-family: var(--fb-font-heading); font-size: var(--pr-bubble-title-size); }
  .bubble__content span { white-space: pre-wrap; font-family: var(--fb-font-body); font-size: var(--pr-bubble-font-size); font-weight: 650; }
  @keyframes bubble-in { from { opacity: 0; transform: translateY(7px) scale(.82); } to { opacity: 1; transform: translateY(0) scale(1); } }
</style>