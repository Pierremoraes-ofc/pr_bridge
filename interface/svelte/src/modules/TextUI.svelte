<script lang="ts">
  import { onMount } from 'svelte'
  import { iconName } from '../lib/forgebox'
  import { fetchNui } from '../nui/bridge'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  export let data: { text: string; position?: string; icon?: string; iconColor?: string; debug?: boolean }

  let root: HTMLDivElement

  function positionClass(position?: string) {
    if (position === 'left-center') return 'is-left'
    if (position === 'top-center') return 'is-top'
    if (position === 'bottom-center') return 'is-bottom'
    return 'is-right'
  }

  $: parsed = parseKey(data.text)

  function parseKey(text: string): { key?: string; message: string } {
    const match = text.match(/^\[([^\]]+)\]\s*(.*)$/)
    if (!match) return { message: text }
    return { key: match[1], message: match[2] || text }
  }

  onMount(() => {
    if (!data.debug) return

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        if (!root) return

        const rect = root.getBoundingClientRect()
        const style = getComputedStyle(root)
        void fetchNui('debug:textui', {
          stage: 'mounted',
          text: data.text,
          position: data.position,
          configuredPosition: document.documentElement.dataset.textuiPosition,
          rect: { x: rect.x, y: rect.y, width: rect.width, height: rect.height },
          viewport: { width: window.innerWidth, height: window.innerHeight },
          css: {
            display: style.display,
            visibility: style.visibility,
            opacity: style.opacity,
            position: style.position,
            zIndex: style.zIndex,
            transform: style.transform,
            color: style.color,
            backgroundColor: style.backgroundColor,
          },
        })
      })
    })

    return () => {
      void fetchNui('debug:textui', { stage: 'destroyed', text: data.text })
    }
  })
</script>

<div bind:this={root} class={`textui ${positionClass(data.position)}`}>
  {#if data.icon}<span class="textui__icon" style:color={data.iconColor || undefined}><BootstrapIcon name={iconName(data.icon)} /></span>{/if}
  {#if parsed.key}<span class="textui__key">{parsed.key}</span>{/if}
  <span class="textui__text">{parsed.message || data.text}</span>
</div>

<style>
  .textui { position: absolute; z-index: 100; display: inline-flex; align-items: center; gap: 12px; padding: 12px 18px; border-radius: var(--fb-radius-md); background: var(--fb-nui-surface); border: 1px solid var(--fb-border); border-left: 4px solid var(--fb-orange); box-shadow: 0 8px 32px rgba(0,0,0,.5), 0 0 12px var(--fb-orange-glow-light); font-size: 13px; font-weight: 500; max-width: 320px; animation: fb-pop-in .2s ease; }
  .is-right { top: 50%; right: 3%; transform: translateY(-50%); }
  .is-left { top: 50%; left: 3%; transform: translateY(-50%); }
  .is-top { top: 8%; left: 50%; transform: translateX(-50%); }
  .is-bottom { bottom: 8%; left: 50%; transform: translateX(-50%); }
  .textui__icon { display: grid; place-items: center; width: 18px; height: 18px; flex: 0 0 18px; color: var(--fb-orange); font-size: 18px; }
  .textui__key { background-color: var(--fb-orange); color: var(--fb-text); font-weight: 700; padding: 4px 8px; border-radius: var(--fb-radius-sm); font-size: 12px; box-shadow: 0 0 8px var(--fb-orange-glow); font-family: var(--fb-font-heading); }
  .textui__text { white-space: pre-wrap; color: var(--fb-text); line-height: 1.35; }
</style>
