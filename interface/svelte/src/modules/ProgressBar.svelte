<script lang="ts">
  import { onMount, onDestroy } from 'svelte'
  export let data: any
  const totalSegments = 21
  let percent = 0
  let frame = 0
  let startedAt = 0
  function update() {
    const duration = Math.max(1, Number(data?.duration) || 1)
    const elapsed = performance.now() - startedAt
    percent = Math.min(100, Math.max(0, (elapsed / duration) * 100))
    if (percent < 100) frame = requestAnimationFrame(update)
  }
  onMount(() => { startedAt = performance.now(); frame = requestAnimationFrame(update) })
  onDestroy(() => cancelAnimationFrame(frame))
  $: completedSegments = Math.ceil((percent / 100) * totalSegments)
</script>

<section class="progressbar" aria-label={data?.label || 'Progress'}>
  <header><span class="line"></span><span class="dot"></span><strong>{data?.label || 'PROCESSANDO...'}</strong><span class="dot"></span><span class="line"></span><output>{Math.floor(percent)}%</output></header>
  <div class="segments" aria-hidden="true">
    {#each Array(totalSegments) as _, index}<i class:complete={index < completedSegments}></i>{/each}
  </div>
</section>

<style>
  .progressbar { position: fixed; left: 50%; bottom: 7.5%; width: min(720px, 72vw); transform: translateX(-50%); color: var(--fb-text); background: transparent; font-family: var(--fb-font-body); text-shadow: 0 1px 5px rgba(0, 0, 0, .9); }
  header { display: grid; grid-template-columns: 1fr auto auto auto 1fr auto; align-items: center; gap: 12px; margin: 0 7px 13px; }
  .line { height: 1px; background: color-mix(in srgb, var(--fb-text) 34%, transparent); }
  .dot { width: 5px; height: 5px; border-radius: 50%; background: var(--fb-orange); box-shadow: 0 0 8px var(--fb-orange-glow); }
  strong { font-size: 16px; letter-spacing: .1em; text-transform: uppercase; white-space: nowrap; }
  output { min-width: 74px; padding: 4px 13px; color: var(--fb-orange); border: 1px solid color-mix(in srgb, var(--fb-text) 42%, transparent); clip-path: polygon(12% 0, 100% 0, 88% 100%, 0 100%); font-size: 20px; font-weight: 800; line-height: 1; text-align: center; }
  .segments { display: grid; grid-template-columns: repeat(21, minmax(0, 1fr)); gap: 6px; }
  .segments i { height: 14px; transform: skewX(-24deg); border-radius: 2px; background: color-mix(in srgb, var(--fb-text) 20%, transparent); box-shadow: inset 0 0 0 1px rgba(0, 0, 0, .18); }
  .segments i.complete { background: var(--fb-orange); box-shadow: 0 0 8px var(--fb-orange-glow), inset 0 1px rgba(255, 255, 255, .44); }
  :global(html[data-progress-position='top-center']) .progressbar { top: 7.5%; bottom: auto; }
  @media (max-width: 800px) { .progressbar { width: 86vw; bottom: 5%; } strong { font-size: 13px; } output { min-width: 60px; font-size: 16px; } .segments { gap: 4px; } }
</style>