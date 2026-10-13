<script lang="ts">
  import InteractSprite from '../components/InteractSprite.svelte'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'
  import { iconName } from '../lib/forgebox'
  export let data: any = { entries: [] }
  export let visual: any = {}

  $: entries = Array.isArray(data?.entries) ? data.entries : []
  $: actionKey = String(data?.key || 'E')
  $: clean = visual?.style === 'clean'
  $: outlineWidth = Math.max(0, Math.min(3, Number(visual?.iconOutlineWidth ?? 1)))
  $: perspective = visual?.perspectiveEnabled === true
  $: maxAngle = Math.max(0, Math.min(35, Number(visual?.perspectiveMaxAngle ?? 25)))
  $: tiltY = perspective && Number.isFinite(Number(data?.tiltY)) ? Math.max(-maxAngle, Math.min(maxAngle, Number(data.tiltY))) : 0

  function isSelected(entry: any, index: number) {
    const selected = Number(entry.selected)
    // Match Lua dispatch's first-option fallback when canInteract removes a row.
    const current = Number.isInteger(selected) && selected >= 1 && selected <= (entry.options || []).length ? selected : 1
    return current === index + 1
  }
</script>

{#if entries.length > 0}
  <div class:perspective class="interact-layer" style={`--pr-interact-tilt-y:${tiltY}deg`} aria-hidden="true">
    <svg class="outline-defs" width="0" height="0" focusable="false">
      <defs>
        <filter id="pr-interact-icon-outline" x="-100%" y="-100%" width="300%" height="300%" color-interpolation-filters="sRGB">
          <feMorphology in="SourceAlpha" operator="dilate" radius={outlineWidth} result="outline" />
          <feFlood flood-color={visual?.iconOutlineColor || '#000000'} result="color" />
          <feComposite in="color" in2="outline" operator="in" result="coloredOutline" />
          <feMerge><feMergeNode in="coloredOutline" /><feMergeNode in="SourceGraphic" /></feMerge>
        </filter>
      </defs>
    </svg>
    {#each entries as entry (entry.id)}
      <div class:active={entry.active} class:clean class="interaction" style={`--ix:${Number(entry.x) * 100}vw;--iy:${Number(entry.y) * 100}vh`}>
        {#if entry.active}
          <div class="options">
            {#each entry.options || [] as option, index (`${entry.id}:${index}`)}
              <div class:selected={isSelected(entry, index)} class="option">
                {#if isSelected(entry, index)}
                  <span class="action-key-wrap">
                    {#if clean}
                      <span class="clean-key-bg"></span>
                    {:else}
                      <span class="sprite action-key"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={'interact'}/></span>
                    {/if}
                    <span class="key-label">{actionKey}</span>
                  </span>
                {:else if clean}
                  <span class="clean-icon"><BootstrapIcon name={iconName(option.icon)} /></span>
                {:else if (entry.options || []).length > 1}
                  <span class="sprite bullet"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={'unselect_opt'}/></span>
                {/if}
                {#if !clean}
                  <span class="sprite label-bg"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={isSelected(entry, index) ? 'selected' : 'unselected'}/></span>
                {/if}
                <span class="label">{option.label}</span>
              </div>
            {/each}
          </div>
        {:else}
          {#if clean}
            <span class="clean-pin-glow"><span class="clean-pin"></span></span>
          {:else}
            <span class="sprite pin"><InteractSprite model={visual.style || 'obtaizen_ui'} kind={'pin'}/></span>
          {/if}
        {/if}
      </div>
    {/each}
  </div>
{/if}

<style>
  .interact-layer { position: fixed; inset: 0; z-index: var(--pr-interact-z, 38); pointer-events: none; user-select: none; font-family: var(--pr-interact-font-family, Inter, Nunito, sans-serif); }
  .outline-defs { position: absolute; pointer-events: none; }
  .interaction { position: absolute; left: 0; top: 0; transform: translate3d(var(--ix), var(--iy), 0) translate(-50%, -50%) scale(var(--pr-interact-scale, 1)); transform-origin: center; will-change: transform; }
  .perspective .options, .perspective .pin, .perspective .clean-pin-glow { transform: perspective(var(--pr-interact-perspective-distance, 600px)) rotateY(var(--pr-interact-tilt-y, 0deg)); transform-origin: center; }
  .sprite { display: block; position: relative; }
  .pin { width: var(--pr-interact-pin-size, 32px); height: var(--pr-interact-pin-size, 32px); color: var(--pr-interact-pin-color, #7656ff); filter: var(--pr-interact-icon-filter, none); }
  .action-key-wrap { position: absolute; width: var(--pr-interact-key-size, 38px); height: var(--pr-interact-key-size, 38px); left: calc(var(--pr-interact-key-size, 38px) * -1 - 6px); top: calc((var(--pr-interact-option-height, 30px) - var(--pr-interact-key-size, 38px)) * .5); }
  .action-key { position: absolute; inset: 0; width: 100%; height: 100%; color: var(--pr-interact-key-color, #7656ff); filter: var(--pr-interact-icon-filter, none); }
  .key-label { position: absolute; inset: 0; z-index: 1; display: flex; align-items: center; justify-content: center; color: var(--pr-interact-text-color, #ffffff); font-size: calc(var(--pr-interact-key-size, 38px) * .34); font-weight: var(--pr-interact-key-weight, 800); line-height: 1; text-shadow: 0 1px 3px rgba(0,0,0,.9); }
  .options { position: absolute; left: calc(var(--pr-interact-key-size, 38px) * .5 + var(--pr-interact-bullet-size, 17px) * 1.2 + 10px); top: calc(var(--pr-interact-option-height, 30px) * -.5); display: flex; flex-direction: column; gap: var(--pr-interact-option-gap, 3px); }
  .option { position: relative; display: flex; align-items: center; width: var(--pr-interact-option-width, 180px); height: var(--pr-interact-option-height, 30px); color: var(--pr-interact-unselected-color, #777777); }
  .option.selected { color: var(--pr-interact-selected-color, #7656ff); }
  .label-bg { position: absolute; inset: 0; color: inherit; opacity: var(--pr-interact-background-opacity, .92); }
  .bullet { position: absolute; left: calc(var(--pr-interact-key-size, 38px) * -.5 - var(--pr-interact-bullet-size, 17px) * .5 - 6px); width: var(--pr-interact-bullet-size, 17px); height: var(--pr-interact-bullet-size, 17px); color: inherit; filter: var(--pr-interact-icon-filter, none); }
  .label { position: relative; z-index: 1; width: 100%; padding: 0 12px; color: var(--pr-interact-text-color, #ffffff); font-size: var(--pr-interact-font-size, 14px); font-weight: var(--pr-interact-font-weight, 400); line-height: var(--pr-interact-option-height, 30px); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align: center; text-shadow: 0 1px 2px rgba(0,0,0,.85); }
  .label, .key-label { -webkit-text-stroke: var(--pr-interact-text-outline-width, 0px) var(--pr-interact-text-outline-color, #000); paint-order: stroke fill; }

  .clean .options { left: calc(var(--pr-interact-clean-key-size, 18px) * -.5); }
  .clean .option { width: max-content; max-width: calc(var(--pr-interact-option-width, 180px) + var(--pr-interact-clean-key-size, 18px) + 12px); height: auto; min-height: max(var(--pr-interact-option-height, 30px), var(--pr-interact-clean-key-size, 18px)); gap: 7px; padding: 0 4px 0 0; border-radius: 3px; background: var(--pr-interact-clean-background, transparent); }
  .clean .action-key-wrap { position: relative; left: auto; top: auto; width: var(--pr-interact-clean-key-size, 18px); height: var(--pr-interact-clean-key-size, 18px); flex: 0 0 var(--pr-interact-clean-key-size, 18px); }
  .clean-key-bg { position: absolute; inset: 0; border-radius: 3px; background: var(--pr-interact-clean-key, #f4f6f8); filter: var(--pr-interact-icon-filter, none); }
  .clean .key-label { color: var(--pr-interact-clean-key-text, #161616); font-size: calc(var(--pr-interact-clean-key-size, 18px) * .65); text-shadow: none; }
  .clean-icon { width: var(--pr-interact-clean-key-size, 18px); height: var(--pr-interact-clean-key-size, 18px); flex: 0 0 var(--pr-interact-clean-key-size, 18px); display: flex; align-items: center; justify-content: center; color: var(--pr-interact-clean-icon, #ffb347); filter: var(--pr-interact-icon-filter, none); }
  .clean-icon :global(svg) { width: var(--pr-interact-bullet-size, 17px); height: var(--pr-interact-bullet-size, 17px); stroke: currentColor; stroke-width: var(--pr-interact-icon-stroke, 0px); }
  .clean .label { width: auto; max-width: var(--pr-interact-option-width, 180px); padding: 0; line-height: 1.3; text-align: left; color: var(--pr-interact-clean-text, #fff); }
  .clean .selected .label { color: var(--pr-interact-clean-highlight, #ffb347); }
  .clean-pin-glow { display: block; width: var(--pr-interact-pin-size, 32px); height: var(--pr-interact-pin-size, 32px); color: var(--pr-interact-pin-color, #7656ff); filter: drop-shadow(0 0 4px currentColor); }
  .clean-pin { display: block; width: 100%; height: 100%; box-sizing: border-box; border: 2px solid currentColor; border-radius: 50%; filter: var(--pr-interact-icon-filter, none); }
</style>
