<script lang="ts">
  import { onMount } from 'svelte'
  import { fetchNui } from '../nui/bridge'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'
  import { iconName } from '../lib/forgebox'

  export let data: any

  let selected = 0

  $: items = data?.items || []

  function select(index: number) {
    selected = index
    void fetchNui('radial:select', { index: index + 1 })
  }

  function back() {
    void fetchNui('radial:back')
  }

  function close() {
    void fetchNui('radial:close')
  }

  function itemPosition(index: number, total: number) {
    const step = total <= 5 ? 16 : 80 / Math.max(1, total - 1)
    const y = 10 + index * step
    const normalized = (y / 100) * 2 - 1

    return {
      x: 22 + Math.round(84 * (1 - normalized * normalized)),
      y,
    }
  }

  onMount(() => {
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape' || event.key === 'F1') close()
    }

    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  })
</script>

<section class="radial" aria-label="Menu rápido">
  <div class="radial__shade" aria-hidden="true"></div>

  <svg class="radial__arc" viewBox="0 0 520 920" preserveAspectRatio="none" aria-hidden="true">
    <path d="M16 875 C130 690 130 230 16 35" />
    <circle cx="27" cy="853" r="10" />
    <circle cx="27" cy="57" r="10" />
  </svg>

  <div class="radial__actions">
    {#if data?.menuId}
      <button class="radial__action" type="button" aria-label="Voltar" title="Voltar" on:click={back}>
        <BootstrapIcon name="arrow-left" />
      </button>
    {/if}

    <button class="radial__action radial__action--close" type="button" aria-label="Fechar" title="Fechar" on:click={close}>
      <BootstrapIcon name="x-lg" />
    </button>
  </div>

  <div class="radial__rail">
    {#each items as item, index}
      {@const position = itemPosition(index, items.length)}
      <button
        class:selected={index === selected}
        class="radial__item"
        style={`--curve-x:${position.x}px; --curve-y:${position.y}%`}
        type="button"
        on:mouseenter={() => selected = index}
        on:click={() => select(index)}
      >
        <span class="radial__node"></span>
        <span class="radial__icon"><BootstrapIcon name={iconName(item.icon || 'circle')} /></span>
        <span class="radial__label">{item.label}</span>
      </button>
    {/each}
  </div>
</section>

<style>
  .radial { position: fixed; inset: 0; pointer-events: none; color: var(--fb-text); font-family: var(--fb-font-body); }
  .radial__arc, .radial__rail, .radial__shade { position: absolute; left: 47%; top: 31%; width: 14%; height: 43%; }
  .radial__arc { overflow: visible; }
  .radial__arc path { fill: none; stroke: rgba(255,255,255,.62); stroke-width: 2; }
  .radial__arc circle { fill: var(--fb-orange); filter: drop-shadow(8px 0 7px var(--fb-orange-glow)); }
  .radial__shade { left: 50%; width: 28.5%; background: radial-gradient(ellipse at left center, rgba(0,0,0,.39) 0%, rgba(0,0,0,.208) 38%, transparent 74%); filter: blur(15px); }
  .radial__rail { overflow: visible; }
  .radial__item { pointer-events: auto; position: absolute; left: var(--curve-x); top: var(--curve-y); display: flex; align-items: center; gap: 7px; width: 230px; transform: translateY(-50%); border: 0; background: transparent; color: var(--fb-text); text-align: left; cursor: pointer; transition: transform .16s ease; }
  .radial__node { width: 7px; height: 7px; flex: 0 0 7px; border-radius: 50%; background: var(--fb-orange); box-shadow: 8px 0 13px var(--fb-orange-glow); }
  .radial__icon { display: grid; place-items: center; width: 32px; height: 32px; flex: 0 0 32px; border: 1px solid var(--fb-border); border-radius: 9px; background: var(--fb-nui-surface); color: var(--fb-text); font-size: 16px; box-shadow: 0 4px 10px rgba(0,0,0,.38); transition: .16s ease; }
  .radial__label { font-size: 11px; font-weight: 500; line-height: 1.2; text-shadow: 0 2px 5px rgba(0,0,0,.9); transition: .16s ease; }
  .radial__item.selected { transform: translate(10px, -50%); }
  .radial__item.selected .radial__icon { border: 2px solid var(--fb-orange); color: var(--fb-orange); background: var(--fb-nui-field); box-shadow: 0 0 15px var(--fb-orange-glow), 0 4px 10px rgba(0,0,0,.38); }
  .radial__item.selected .radial__label { color: var(--fb-orange); font-size: 12px; font-weight: 700; }
  .radial__actions { pointer-events: none; position: absolute; left: 46.1%; top: 51%; display: flex; flex-direction: column; align-items: center; gap: 7px; transform: translate(-100%, -50%); }
  .radial__action { pointer-events: auto; display: grid; place-items: center; width: 30px; height: 30px; border: 1px solid var(--fb-border); border-radius: 9px; background: var(--fb-nui-surface); color: var(--fb-text); font-size: 14px; cursor: pointer; box-shadow: 0 4px 12px rgba(0,0,0,.32); transition: .16s ease; }
  .radial__action:hover { border-color: var(--fb-orange); color: var(--fb-orange); box-shadow: 0 0 12px var(--fb-orange-glow); }
  .radial__action--close:hover { color: var(--fb-error); border-color: var(--fb-error); }
  @media (max-width: 1000px) { .radial__arc, .radial__rail { left: 45%; width: 17%; } .radial__shade { left: 49%; width: 22%; } .radial__actions { left: 44%; } }
</style>