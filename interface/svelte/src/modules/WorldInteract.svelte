<script lang="ts">
  import InteractSprite from '../components/InteractSprite.svelte'
  export let data: any = { entries: [] }
  export let visual: any = {}

  $: entries = Array.isArray(data?.entries) ? data.entries : []
  $: actionKey = String(data?.key || 'E')
</script>

{#if entries.length > 0}
  <div class="interact-layer" aria-hidden="true">
    {#each entries as entry (entry.id)}
      <div class:active={entry.active} class="interaction" style={`--ix:${Number(entry.x) * 100}vw;--iy:${Number(entry.y) * 100}vh`}>
        {#if entry.active}
          <span class="action-key-wrap">
            <span class="sprite action-key"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={'interact'}/></span>
            <span class="key-label">{actionKey}</span>
          </span>
          <div class="options">
            {#each entry.options || [] as option, index (`${entry.id}:${index}`)}
              <div class:selected={Number(entry.selected) === index + 1} class="option">
                {#if (entry.options || []).length > 1}
                  <span class="sprite bullet"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={Number(entry.selected) === index + 1 ? 'select_opt' : 'unselect_opt'}/></span>
                {/if}
                <span class="sprite label-bg"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={Number(entry.selected) === index + 1 ? 'selected' : 'unselected'}/></span>
                <span class="label">{option.label}</span>
              </div>
            {/each}
          </div>
        {:else}
          <span class="sprite pin"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={'pin'}/></span>
        {/if}
      </div>
    {/each}
  </div>
{/if}

<style>
  .interact-layer { position: fixed; inset: 0; z-index: var(--pr-interact-z, 38); pointer-events: none; user-select: none; font-family: Inter, Nunito, sans-serif; }
  .interaction { position: absolute; left: 0; top: 0; transform: translate3d(var(--ix), var(--iy), 0) translate(-50%, -50%) scale(var(--pr-interact-scale, 1)); transform-origin: center; will-change: transform; }
  .sprite { display: block; position: relative; }
  .pin { width: var(--pr-interact-pin-size, 32px); height: var(--pr-interact-pin-size, 32px); color: var(--pr-interact-pin-color, #7656ff);  }
  .action-key-wrap { position: absolute; width: var(--pr-interact-key-size, 38px); height: var(--pr-interact-key-size, 38px); left: calc(var(--pr-interact-key-size, 38px) * -.5); top: calc(var(--pr-interact-key-size, 38px) * -.5); }
  .action-key { position: absolute; inset: 0; width: 100%; height: 100%; color: var(--pr-interact-key-color, #7656ff);  }
  .key-label { position: absolute; inset: 0; z-index: 1; display: flex; align-items: center; justify-content: center; color: var(--pr-interact-text-color, #ffffff); font-size: calc(var(--pr-interact-key-size, 38px) * .34); font-weight: 800; line-height: 1; text-shadow: 0 1px 3px rgba(0,0,0,.9); }
  .options { position: absolute; left: calc(var(--pr-interact-key-size, 38px) * .5 + var(--pr-interact-bullet-size, 17px) * 1.2 + 10px); top: calc(var(--pr-interact-option-height, 30px) * -.5); display: flex; flex-direction: column; gap: var(--pr-interact-option-gap, 3px); }
  .option { position: relative; display: flex; align-items: center; width: var(--pr-interact-option-width, 180px); height: var(--pr-interact-option-height, 30px); color: var(--pr-interact-unselected-color, #777777); }
  .option.selected { color: var(--pr-interact-selected-color, #7656ff); }
  .label-bg { position: absolute; inset: 0; color: inherit; opacity: var(--pr-interact-background-opacity, .92); }
  .bullet { position: absolute; left: calc(var(--pr-interact-bullet-size, 17px) * -1.15); width: var(--pr-interact-bullet-size, 17px); height: var(--pr-interact-bullet-size, 17px); color: inherit; }
  .label { position: relative; z-index: 1; width: 100%; padding: 0 12px; color: var(--pr-interact-text-color, #ffffff); font-size: var(--pr-interact-font-size, 14px); line-height: var(--pr-interact-option-height, 30px); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align: center; text-shadow: 0 1px 2px rgba(0,0,0,.85); }
</style>
