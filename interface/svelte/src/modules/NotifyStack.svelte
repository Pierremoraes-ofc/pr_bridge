<script lang="ts">
  import { createEventDispatcher, onDestroy } from 'svelte'
  import { notifyTone } from '../lib/forgebox'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  export let items: Array<{ id: string | number; title?: string; description?: string; type?: string; duration?: number }> = []
  const dispatch = createEventDispatcher<{ remove: string | number }>()
  const timers = new Map<string | number, number>()
  let progress: Record<string | number, number> = {}

  $: for (const item of items) {
    if (!timers.has(item.id)) startTimer(item)
  }

  function startTimer(item: { id: string | number; duration?: number }) {
    const duration = item.duration ?? 5000
    const started = Date.now()
    progress = { ...progress, [item.id]: 100 }
    const handle = window.setInterval(() => {
      const pct = Math.max(0, 100 - ((Date.now() - started) / duration) * 100)
      progress = { ...progress, [item.id]: pct }
      if (pct <= 0) {
        window.clearInterval(handle)
        timers.delete(item.id)
        dispatch('remove', item.id)
      }
    }, 50)
    timers.set(item.id, handle)
  }

  const icon = (type?: string) => type === 'success' ? 'check-circle-fill' : type === 'error' ? 'x-circle-fill' : type === 'warning' ? 'exclamation-triangle-fill' : 'info-circle-fill'

  onDestroy(() => timers.forEach((handle) => window.clearInterval(handle)))
</script>

<div class="notify-stack">
  {#each items as item (item.id)}
    {@const tone = notifyTone(item.type)}
    <div class="notify" style={`border-left-color: ${tone.border}; box-shadow: 0 8px 30px rgba(0,0,0,0.5), 0 0 20px ${tone.glow};`}>
      <span class="notify__icon" style={`color: ${tone.border}`}><BootstrapIcon name={icon(item.type)} /></span>
      <div class="notify__content">
        {#if item.title}<strong class="notify__title">{item.title}</strong>{/if}
        <p class="notify__desc">{item.description}</p>
      </div>
      <div class="notify__progress" style={`width: ${progress[item.id] ?? 100}%; background-color: ${tone.border};`} />
    </div>
  {/each}
</div>

<style>
  .notify-stack { position: absolute; top: 16px; right: 16px; display: flex; flex-direction: column; gap: 12px; width: min(320px, 90vw); pointer-events: none; z-index: 9999; }
  .notify { position: relative; overflow: hidden; padding: 16px 16px 16px 14px; border-radius: var(--fb-radius-md); border: 1px solid var(--fb-border); border-left-width: 4px; background: var(--fb-nui-surface); display: flex; gap: 12px; animation: fb-slide-in-right .3s cubic-bezier(.1,.8,.25,1); }
  .notify__icon { width: 30px; height: 30px; flex: 0 0 30px; align-self: center; display: grid; place-items: center; }
  .notify__content { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
  .notify__title { display: block; font-family: var(--fb-font-heading); font-size: 14px; font-weight: 600; }
  .notify__desc { font-size: 12px; color: var(--fb-text-grey); line-height: 1.4; }
  .notify__progress { position: absolute; bottom: 0; left: 0; height: 3px; transition: width .05s linear; }
</style>
