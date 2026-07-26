<script lang="ts">
  import { tick } from 'svelte'
  import { fetchNui } from '../nui/bridge'
  import { alphaColor, iconName, metaItems } from '../lib/forgebox'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'
  import forgeSymbol from '../assets/forge-symbol.webp'

  export let data: any

  let hoveredOption: any = null
  let tooltipRect = { top: 0, left: 0 }
  let searchOpen = false
  let searchQuery = ''
  let searchInput: HTMLInputElement

  $: hoveredMetadata = metaItems(hoveredOption?.metadata)
  $: metadataOnLeft = document.documentElement.dataset.metadataSide === 'left'
  $: hoveredImage = typeof hoveredOption?.image === 'string' ? hoveredOption.image : ''
  $: filteredOptions = filterOptions(data?.options || [], searchQuery)

  function normalizeSearch(value: unknown): string {
    return String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim()
  }

  function filterOptions(options: any[], queryValue: string) {
    const query = normalizeSearch(queryValue)
    if (!query) return options
    return options.filter((option) => {
      const metadata = metaItems(option.metadata).map((item) => `${item.label || ''} ${item.value || ''}`).join(' ')
      return normalizeSearch([option.title, option.description, option.badge, option.keybind, metadata].join(' ')).includes(query)
    })
  }

  async function toggleSearch() {
    searchOpen = !searchOpen
    if (!searchOpen) {
      searchQuery = ''
      return
    }
    await tick()
    searchInput?.focus()
  }

  const closeSearch = () => {
    searchOpen = false
    searchQuery = ''
  }

  const onSelect = (option: any) => {
    if (option.disabled || option.readOnly) return
    fetchNui('context:select', { id: data.id, index: option.index, __resource: data.__resource })
  }

  const onClose = () => fetchNui('context:close', { __resource: data.__resource })
  const onBack = () => fetchNui('context:back', { __resource: data.__resource })

  function optionColor(option: any): string {
    const map: Record<string, string> = { orange: 'var(--fb-orange)', blue: 'var(--fb-info)', green: 'var(--fb-success)', yellow: 'var(--fb-warning)', red: 'var(--fb-error)', purple: '#8b5cf6', cyan: '#06b6d4' }
    return map[option?.colorScheme] || getComputedStyle(document.documentElement).getPropertyValue('--fb-orange').trim() || '#ff7a1a'
  }

  function hasOptionIcon(icon: unknown): boolean {
    if (typeof icon === 'string') return icon.trim().length > 0
    if (Array.isArray(icon)) return icon.some((entry) => typeof entry === 'string' && entry.trim().length > 0)
    if (!icon || typeof icon !== 'object') return false
    const name = (icon as Record<string, unknown>).name
    return typeof name === 'string' && name.trim().length > 0
  }

  function positionClass(position?: string): string {
    const normalized = String(position || 'top-right').toLowerCase()
    if (normalized === 'top-left') return 'ctx--top-left'
    if (normalized === 'bottom-left') return 'ctx--bottom-left'
    if (normalized === 'bottom-right') return 'ctx--bottom-right'
    if (normalized === 'center-left') return 'ctx--center-left'
    if (normalized === 'center-right') return 'ctx--center-right'
    return 'ctx--top-right'
  }

  function onOptionEnter(option: any, event: MouseEvent) {
    if (!metaItems(option.metadata).length && !option.image) {
      hoveredOption = null
      return
    }
    const rect = (event.currentTarget as HTMLElement).getBoundingClientRect()
    hoveredOption = option
    tooltipRect = { top: rect.top + rect.height / 2, left: metadataOnLeft ? rect.left - 12 : rect.right + 12 }
  }
</script>

<div class="ctx-shell">
  <div class={`ctx pr-interactive ${positionClass(data.position)}`}>
    <div class="ctx__brand" aria-hidden="true"><img class="ctx__brand-image" src={forgeSymbol} alt="" /></div>
    <header class="ctx__header">
      {#if data.hasParent}
        <button class="ctx__nav" type="button" aria-label="Voltar" on:click={onBack}><BootstrapIcon name="chevron-left" /></button>
      {:else}
        <span class="ctx__nav-spacer" />
      {/if}
      <div class="ctx__heading"><h2 class="ctx__title">{data.title}</h2></div>
      <div class="ctx__actions">
        <button class:is-active={searchOpen} class="ctx__nav" type="button" aria-label="Buscar" on:click={toggleSearch}><BootstrapIcon name="search" /></button>
        {#if data.canClose !== false}
          <button class="ctx__nav ctx__nav--close" type="button" aria-label="Fechar" on:click={onClose}><BootstrapIcon name="x-lg" /></button>
        {/if}
      </div>
    </header>

    {#if searchOpen}
      <div class="ctx__search">
        <BootstrapIcon name="search" />
        <input bind:this={searchInput} bind:value={searchQuery} class="ctx__search-input" type="text" placeholder={data.searchPlaceholder || 'Buscar opcao...'} autocomplete="off" on:keydown={(e) => e.key === 'Escape' && closeSearch()} />
        {#if searchQuery}<button class="ctx__search-clear" type="button" aria-label="Limpar busca" on:click={() => (searchQuery = '')}><BootstrapIcon name="x-circle" /></button>{/if}
      </div>
    {/if}

    <ul class="ctx__list">
      {#each filteredOptions as option (option.index)}
        <li class:has-icon={hasOptionIcon(option.icon)} class:is-disabled={option.disabled} class:is-readonly={option.readOnly} class="ctx__item" on:click={() => onSelect(option)} on:mouseenter={(event) => onOptionEnter(option, event)}>
          {#if hasOptionIcon(option.icon)}
            <span class="ctx__option-icon" style:color={option.iconColor || undefined}>
              <BootstrapIcon name={iconName(option.icon)} />
            </span>
          {/if}
          <div class="ctx__body">
            <div class="ctx__row"><span class="ctx__item-title">{option.title}</span>{#if option.badge}<span class="ctx__badge">{option.badge}</span>{/if}</div>
            {#if option.description}<p class="ctx__desc">{option.description}</p>{/if}
            {#if option.progress != null}
              <div class="ctx__progress"><div class="ctx__progress-bar" style={`width: ${Math.max(0, Math.min(100, option.progress))}%; background-color: ${optionColor(option)}; box-shadow: 0 0 8px ${alphaColor(optionColor(option), 0.45)};`} /></div>
            {/if}
          </div>
          <div class="ctx__aside">
            {#if option.checked !== undefined}<span class:is-on={option.checked} class="ctx__check"><BootstrapIcon name="check-lg" /></span>{/if}
            {#if option.keybind}<span class="ctx__keybind">{option.keybind}</span>{/if}
            {#if option.arrow}<BootstrapIcon name="chevron-right" />{/if}
          </div>
        </li>
      {/each}
      {#if filteredOptions.length === 0}<li class="ctx__empty"><BootstrapIcon name="search" /><span>{data.searchEmpty || 'Nenhuma opcao encontrada.'}</span></li>{/if}
    </ul>
  </div>

  {#if hoveredMetadata.length || hoveredImage}
    <div class:is-left={metadataOnLeft} class="ctx__tooltip pr-interactive" style={`top: ${tooltipRect.top}px; left: ${tooltipRect.left}px;`}>
      <div class="ctx__tooltip-arrow" />
      {#if hoveredImage}<img class="ctx__meta-preview" src={hoveredImage} alt="" />{/if}
      <ul class="ctx__meta">
        {#each hoveredMetadata as m}
          <li class="ctx__meta-item">
            {#if m.image}<img class="ctx__meta-image" src={m.image} alt="" />{/if}
            <div class="ctx__meta-content"><span class="ctx__meta-label">{m.label}</span><span class="ctx__meta-value">{m.value}</span></div>
          </li>
        {/each}
      </ul>
    </div>
  {/if}
</div>

<style>
  .ctx-shell { position: absolute; inset: 0; pointer-events: none; background: transparent !important; }
  .ctx { position: absolute; width: min(390px, 92vw); max-height: min(72vh, 680px); display: flex; flex-direction: column; overflow: visible; animation: fb-slide-in-left .28s cubic-bezier(.1,.8,.25,1); }
  .ctx__brand { position: absolute; top: -70px; left: 0; width: 66px; height: 66px; overflow: hidden; pointer-events: none; }
  .ctx__brand-image { display: block; width: 100%; height: 100%; object-fit: contain; filter: drop-shadow(0 5px 12px rgba(0,0,0,.45)); }
  .ctx--top-right { top: 7%; right: 17%; } .ctx--top-left { top: 7%; left: 7%; } .ctx--bottom-right { right: 17%; bottom: 7%; } .ctx--bottom-left { left: 7%; bottom: 7%; } .ctx--center-right { top: 50%; right: 4%; transform: translateY(-50%); } .ctx--center-left { top: 50%; left: 4%; transform: translateY(-50%); }
  .ctx__header { display: grid; grid-template-columns: 70px minmax(0,1fr) 70px; align-items: center; gap: 8px; margin-bottom: 7px; }
  .ctx__actions { display: flex; justify-content: flex-end; gap: 6px; }
  .ctx__heading, .ctx__search, .ctx__item, .ctx__empty { border: 1px solid var(--fb-border); border-radius: var(--fb-radius-md); background: var(--fb-nui-surface); }
  .ctx__heading { min-height: 36px; display: grid; place-items: center; padding: 7px 12px; text-align: center; border-color: var(--fb-orange-glow-light); }
  .ctx__title { font-family: var(--fb-font-heading); font-size: 15px; font-weight: 600; color: var(--fb-text); }
  .ctx__nav { width: 32px; height: 32px; display: grid; place-items: center; padding: 0; line-height: 1; border: 1px solid var(--fb-border); border-radius: var(--fb-radius-md); background: var(--fb-nui-surface); color: var(--fb-text-grey); cursor: pointer; }
  .ctx__nav:hover, .ctx__nav.is-active { color: var(--fb-orange); border-color: var(--fb-orange-glow); }
  .ctx__nav-spacer { width: 32px; height: 32px; }
  .ctx__search { min-height: 38px; display: grid; grid-template-columns: auto minmax(0,1fr) auto; align-items: center; gap: 9px; margin-bottom: 7px; padding: 0 11px; border-color: var(--fb-orange-border); }
  .ctx__search-input { width: 100%; height: 36px; border: 0; outline: 0; background: transparent; color: var(--fb-text); font-size: 12px; }
  .ctx__search-clear { border: 0; background: transparent; color: var(--fb-text-muted); cursor: pointer; }
  .ctx__list { list-style: none; overflow-y: auto; overflow-x: hidden; padding: 0 4px 0 0; display: flex; flex-direction: column; gap: 6px; }
  .ctx__item { display: grid; grid-template-columns: minmax(0,1fr) auto; gap: 12px; align-items: flex-start; flex: 0 0 auto; min-height: 58px; height: auto; padding: 12px 13px; cursor: pointer; transition: transform .16s ease, border-color .16s ease; }
  .ctx__item.has-icon { grid-template-columns: auto minmax(0,1fr) auto; }
  .ctx__option-icon { display: grid; place-items: center; width: 18px; height: 18px; margin-top: 1px; color: var(--fb-orange); font-size: 16px; }
  .ctx__item:hover:not(.is-disabled):not(.is-readonly) { border-color: var(--fb-orange-glow); box-shadow: inset 3px 0 0 var(--fb-orange-strong); transform: translateY(-1px); }
  .ctx__item.is-disabled { opacity: .42; cursor: not-allowed; } .ctx__item.is-readonly { cursor: default; }
  .ctx__body { min-width: 0; overflow: visible; }
  .ctx__row { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
  .ctx__item-title { font-size: 13px; font-weight: 600; color: var(--fb-text); }
  .ctx__badge { font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: var(--fb-radius-sm); background: var(--fb-orange-subtle); color: var(--fb-orange); border: 1px solid var(--fb-orange-glow-light); }
  .ctx__desc { margin: 4px 0 0; font-size: 12px; color: var(--fb-text-grey); line-height: 1.4; white-space: normal; overflow-wrap: anywhere; }
  .ctx__progress { margin-top: 8px; height: 4px; border-radius: 999px; background: var(--fb-bg-dark); border: 1px solid var(--fb-border); overflow: hidden; }
  .ctx__progress-bar { height: 100%; }
  .ctx__aside { display: flex; flex-direction: column; align-items: flex-end; align-self: stretch; justify-content: center; gap: 4px; }
  .ctx__check { width: 18px; height: 18px; display: grid; place-items: center; border-radius: var(--fb-radius-sm); border: 1px solid var(--fb-border); color: transparent; } .ctx__check.is-on { color: var(--fb-text); background: var(--fb-orange); border-color: var(--fb-orange); }
  .ctx__keybind { font-size: 10px; color: var(--fb-text-muted); background: var(--fb-bg-darkest); padding: 2px 6px; border-radius: var(--fb-radius-sm); border: 1px solid var(--fb-border); font-family: var(--fb-font-mono); }
  .ctx__empty { min-height: 54px; display: flex; align-items: center; justify-content: center; gap: 9px; padding: 12px; color: var(--fb-text-muted); font-size: 12px; }
  .ctx__tooltip { position: absolute; z-index: 30; width: 270px; max-height: 300px; padding: 10px; border-radius: var(--fb-radius-md); border: 1px solid var(--fb-orange-border); background: var(--fb-nui-surface); box-shadow: 0 18px 48px rgba(0,0,0,.62); pointer-events: none; transform: translate(0,-50%); }
  .ctx__tooltip.is-left { transform: translate(-100%,-50%); }
  .ctx__meta { list-style: none; display: grid; gap: 8px; max-height: 280px; overflow-y: auto; }
  .ctx__meta-preview { display: block; width: 100%; max-height: 160px; margin-bottom: 9px; object-fit: contain; border-radius: var(--fb-radius-sm); border: 1px solid var(--fb-border); }
  .ctx__meta-item { display: flex; align-items: flex-start; gap: 8px; font-size: 11px; }
  .ctx__meta-image { width: 42px; height: 42px; object-fit: cover; border-radius: var(--fb-radius-sm); border: 1px solid var(--fb-border); }
  .ctx__meta-content { min-width: 0; display: grid; gap: 2px; }
  .ctx__meta-label { color: var(--fb-text-muted); font-size: 10px; text-transform: uppercase; }
  .ctx__meta-value { color: var(--fb-text-grey); font-family: var(--fb-font-mono); overflow-wrap: anywhere; }
</style>
