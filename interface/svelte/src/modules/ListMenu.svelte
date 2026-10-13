<script lang="ts">
  import { afterUpdate, onMount } from 'svelte'
  import { fetchNui, onNuiMessage } from '../nui/bridge'
  import { iconName } from '../lib/forgebox'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'
  import { createListMenu } from '../../../shared/listMenu.mjs'
  import '../../../shared/listMenu.css'
  export let data: any
  export let blocked = false
  let root: HTMLDivElement
  const controller = createListMenu(data, (action: string, payload: any) => void fetchNui(`menu:${action}`, payload))
  let state = controller.snapshot()
  $: option = data.options[state.selected - 1]
  $: value = option?.values?.[state.indices[state.selected - 1] - 1]
  function key(event: KeyboardEvent) {
    if (blocked) return
    if (controller.key(event.key)) { event.preventDefault(); event.stopImmediatePropagation(); state = controller.snapshot() }
  }
  function choose(index: number) { controller.select(index); controller.key('Enter'); state = controller.snapshot() }
  afterUpdate(() => root?.querySelector('.list-option.active')?.scrollIntoView({ block: 'nearest' }))
  onMount(() => {
    controller.announce()
    return onNuiMessage('ui:key', payload => {
      if (!blocked && controller.key(payload?.key)) state = controller.snapshot()
    })
  })
</script>
<svelte:window on:keydown={key} />
<div bind:this={root} class={`pr-list-menu ${data.position || 'top-left'}`}>
  <header><span>{data.title}</span>{#if data.canClose !== false}<button aria-label="Close" on:click={() => controller.key('Escape')}>×</button>{/if}</header>
  <section>
    {#each data.options as item, i}
      <button class="list-option" class:active={state.selected === i + 1} disabled={item.disabled || item.readOnly} on:click={() => choose(i + 1)}>
        {#if item.icon}<BootstrapIcon name={iconName(item.icon)} />{/if}
        <span class="list-label">{item.label || item.title}</span>
        {#if item.values?.length}<span class="list-value">‹ {item.values[state.indices[i] - 1]?.label || item.values[state.indices[i] - 1]} ›</span>
        {:else if item.checked !== undefined}<span aria-label={state.checked[i] ? 'Checked' : 'Unchecked'}>{state.checked[i] ? '☑' : '☐'}</span>{/if}
      </button>
      {#if item.progress !== undefined}<progress max="100" value={item.progress}></progress>{/if}
    {/each}
  </section>
  {#if value?.description || option?.description}<div class="list-description">{value?.description || option.description}</div>{/if}
</div>
