<script lang="ts">
  import { onMount, onDestroy } from 'svelte'
  export let data: any

  const totalSegments = 21
  const radius = 54
  const circumference = 2 * Math.PI * radius
  let percent = 0
  let frame = 0
  let startedAt = 0

  function update() {
    const duration = Math.max(1, Number(data?.duration) || 1)
    const elapsed = performance.now() - startedAt
    percent = Math.min(100, Math.max(0, (elapsed / duration) * 100))
    if (percent < 100) frame = requestAnimationFrame(update)
  }

  onMount(() => {
    startedAt = performance.now()
    frame = requestAnimationFrame(update)
  })
  onDestroy(() => cancelAnimationFrame(frame))

  $: completedSegments = Math.ceil((percent / 100) * totalSegments)
  $: circleOffset = circumference * (1 - percent / 100)
  $: isCircle = data?.style === 'circle'
  $: accent = /^#[0-9a-f]{6}$/i.test(String(data?.color || '')) ? data.color : 'var(--fb-orange)'
  $: progressPosition = normalizePosition(data?.position)

  function normalizePosition(value: unknown) {
    const position = String(value || '').toLowerCase()
    if (position === 'top' || position === 'top-center') return 'top'
    if (position === 'middle' || position === 'center' || position === 'center-center') return 'middle'
    if (position === 'bottom' || position === 'bottom-center') return 'bottom'
    return ''
  }
</script>

{#if isCircle}
  <section class:progresscircle--top={progressPosition === 'top'} class:progresscircle--middle={progressPosition === 'middle'} class:progresscircle--bottom={progressPosition === 'bottom'} class="progresscircle" style={`--progress-accent:${accent}`} aria-label={data?.label || 'Progress'}>
    <div class="progresscircle__dial">
      <svg viewBox="0 0 124 124" aria-hidden="true">
        <circle class="progresscircle__track" cx="62" cy="62" r={radius}></circle>
        <circle class="progresscircle__value" cx="62" cy="62" r={radius} style={`stroke-dasharray:${circumference};stroke-dashoffset:${circleOffset}`}></circle>
      </svg>
      <output>{Math.floor(percent)}<small>%</small></output>
    </div>
    <strong>{data?.label || 'PROCESSANDO...'}</strong>
    {#if data?.canCancel}<span>BACKSPACE PARA CANCELAR</span>{/if}
  </section>
{:else}
  <section class:progressbar--top={progressPosition === 'top'} class:progressbar--middle={progressPosition === 'middle'} class:progressbar--bottom={progressPosition === 'bottom'} class="progressbar" style={`--progress-accent:${accent}`} aria-label={data?.label || 'Progress'}>
    <header><span class="line"></span><span class="dot"></span><strong>{data?.label || 'PROCESSANDO...'}</strong><span class="dot"></span><span class="line"></span><output>{Math.floor(percent)}%</output></header>
    <div class="segments" aria-hidden="true">
      {#each Array(totalSegments) as _, index}<i class:complete={index < completedSegments}></i>{/each}
    </div>
  </section>
{/if}

<style>
  .progressbar { position: fixed; left: 50%; bottom: 7.5%; width: min(720px, 72vw); transform: translateX(-50%); color: var(--fb-text); background: transparent; font-family: var(--fb-font-body); text-shadow: 0 1px 5px rgba(0, 0, 0, .9); }
  header { display: grid; grid-template-columns: 1fr auto auto auto 1fr auto; align-items: center; gap: 12px; margin: 0 7px 13px; }
  .line { height: 1px; background: color-mix(in srgb, var(--fb-text) 34%, transparent); }
  .dot { width: 5px; height: 5px; border-radius: 50%; background: var(--progress-accent); box-shadow: 0 0 8px color-mix(in srgb, var(--progress-accent) 50%, transparent); }
  strong { font-size: 16px; letter-spacing: .1em; text-transform: uppercase; white-space: nowrap; }
  .progressbar output { min-width: 74px; padding: 4px 13px; color: var(--progress-accent); border: 1px solid rgba(255,255,255,.82); clip-path: polygon(12% 0, 100% 0, 88% 100%, 0 100%); font-size: 20px; font-weight: 800; line-height: 1; text-align: center; }
  .segments { display: grid; grid-template-columns: repeat(21, minmax(0, 1fr)); gap: 6px; }
  .segments i { height: 14px; transform: skewX(-24deg); border-radius: 2px; background: color-mix(in srgb, var(--fb-text) 20%, transparent); border: 1px solid rgba(255,255,255,.72); box-sizing: border-box; box-shadow: inset 0 0 0 1px rgba(0, 0, 0, .18); }
  .segments i.complete { background: var(--progress-accent); border-color: #fff; box-shadow: 0 0 8px color-mix(in srgb, var(--progress-accent) 50%, transparent), inset 0 1px rgba(255, 255, 255, .44); }

  .progresscircle { position: fixed; left: 50%; bottom: 8%; display: flex; flex-direction: column; align-items: center; gap: 8px; transform: translateX(-50%); color: var(--fb-text); font-family: var(--fb-font-body); text-align: center; text-shadow: 0 1px 5px rgba(0,0,0,.9); }
  .progresscircle--middle { top: 50%; bottom: auto; transform: translate(-50%, -50%); }
  .progresscircle__dial { position: relative; width: 132px; height: 132px; padding: 4px; border-radius: 50%; background: rgba(12,12,15,.78); box-shadow: 0 8px 24px rgba(0,0,0,.6), inset 0 0 20px rgba(0,0,0,.62); }
  .progresscircle svg { width: 100%; height: 100%; transform: rotate(-90deg); overflow: visible; }
  .progresscircle circle { fill: none; stroke-width: 9; }
  .progresscircle__track { stroke: rgba(255,255,255,.11); }
  .progresscircle__value { stroke: var(--progress-accent); stroke-linecap: round; filter: drop-shadow(0 0 6px color-mix(in srgb, var(--progress-accent) 58%, transparent)); transition: stroke-dashoffset .04s linear; }
  .progresscircle output { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; color: var(--fb-text); font-size: 27px; font-weight: 900; line-height: 1; }
  .progresscircle output small { margin-left: 2px; transform: translateY(4px); color: var(--progress-accent); font-size: 12px; line-height: 1; }
  .progresscircle strong { max-width: 300px; font-size: 13px; }
  .progresscircle > span { color: var(--fb-text-grey); font-size: 9px; letter-spacing: .12em; }

  :global(html[data-progress-position='top-center']) .progressbar { top: 7.5%; bottom: auto; }
  :global(html[data-progress-position='top-center']) .progresscircle:not(.progresscircle--middle) { top: 8%; bottom: auto; }
  .progressbar.progressbar--top { top: 7.5%; bottom: auto; }
  .progressbar.progressbar--middle { top: 50%; bottom: auto; transform: translate(-50%, -50%); }
  .progressbar.progressbar--bottom { top: auto; bottom: 7.5%; }
  .progresscircle.progresscircle--top { top: 8%; bottom: auto; transform: translateX(-50%); }
  .progresscircle.progresscircle--bottom { top: auto; bottom: 8%; transform: translateX(-50%); }
  @media (max-width: 800px) { .progressbar { width: 86vw; bottom: 5%; } .progressbar strong { font-size: 13px; } .progressbar output { min-width: 60px; font-size: 16px; } .segments { gap: 4px; } }
</style>