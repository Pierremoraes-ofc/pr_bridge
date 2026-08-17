<script lang="ts">
  import { fetchNui } from '../nui/bridge'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  export let data: any
  export let eyeIcon = 'fa-solid fa-eye'
  export let visual: any = {}

  $: visible = data?.visible === true
  $: groups = Array.isArray(data?.groups) ? data.groups : []
  $: zones = Array.isArray(data?.zones) ? data.zones : []
  $: markers = Array.isArray(data?.markers) ? data.markers : []
  $: options = [
    ...groups.flatMap((group: any) => Array.isArray(group?.options) ? group.options : []),
    ...zones.flatMap((zone: any) => Array.isArray(zone?.options) ? zone.options : []),
  ]
  $: hasTarget = options.length > 0

  function markerIconName(marker: any) {
    const configured = marker?.targeted && visual.markerChangeOnTarget !== false
      ? (visual.markerTargetIcon || 'bi bi-record-circle')
      : (visual.markerIcon || 'bi bi-circle')
    return String(configured).split(' ').find((part) => part.startsWith('bi-'))?.slice(3) || 'circle'
  }

  function select(option: any) {
    void fetchNui('target:select', {
      groupIndex: option.groupIndex,
      optionIndex: option.optionIndex,
      zoneIndex: option.zoneIndex,
    })
  }
</script>

{#if visible}
  <div class="target-layer">
    {#each markers as marker (marker.id)}
      <span
        class={`world-target-marker ${marker.targeted ? 'selected' : ''}`}
        style={`--marker-x:${Number(marker.x) * 100}vw;--marker-y:${Number(marker.y) * 100}vh`}
        aria-hidden="true"
      >
        <span class="world-target-marker__global">
          <span class="world-target-marker__specific">
            <span class={`world-target-marker__effect effect-${marker.targeted ? (visual.markerEffect || 'none') : 'none'}`}>
              <BootstrapIcon name={markerIconName(marker)} />
            </span>
          </span>
        </span>
      </span>
    {/each}
    <div class:targeted={hasTarget} class="target-eye" aria-hidden="true">
      <i class={`target-eye-icon ${eyeIcon}`}></i>
    </div>

    {#if hasTarget}
      <div class="target-options pr-interactive">
        {#each options as option}
          <button type="button" class="target-option" on:click={() => select(option)}>
            <i class={`fa-fw ${option.icon || 'fa-solid fa-circle'} target-icon`} style:color={option.iconColor || undefined}></i>
            <span>{option.label}</span>
          </button>
        {/each}
      </div>
    {/if}
  </div>
{/if}

<style>
  .target-layer {
    position: fixed;
    inset: 0;
    pointer-events: none;
    user-select: none;
    white-space: nowrap;
    font-family: Nunito, Inter, sans-serif;
    z-index: var(--pr-target-z, 40);
  }

  .target-eye {
    position: absolute;
    top: var(--pr-target-y, 50%);
    left: var(--pr-target-x, 50%);
    width: var(--pr-target-eye-size, 36px);
    height: var(--pr-target-eye-size, 36px);
    transform: translate(-50%, -50%) scale(var(--pr-target-scale, 1));
    transform-origin: center;
  }

  .target-eye-icon {
    display: flex;
    width: 100%;
    height: 100%;
    align-items: center;
    justify-content: center;
    color: var(--pr-target-eye, #000);
    font-size: var(--pr-target-eye-size, 36px);
    transform: scale(var(--pr-target-eye-scale, 1));
    transform-origin: center;
    transition: color 160ms ease, transform 160ms ease;
  }
  .target-eye.targeted .target-eye-icon { color: var(--pr-target-color, #cfd2da); }

  .world-target-marker {
    position: absolute;
    left: 0;
    top: 0;
    transform: translate3d(var(--marker-x, 50vw), var(--marker-y, 50vh), 0) translate(-50%, -50%);
    transform-origin: center;
    will-change: transform;
    backface-visibility: hidden;
    color: var(--pr-target-marker-color, #9b9b9b);
    opacity: var(--pr-target-marker-opacity, .69);
    font-size: var(--pr-target-marker-size, 30px);
    line-height: 1;
    text-shadow: 0 0 5px color-mix(in srgb, currentColor 45%, transparent);
  }
  .world-target-marker__global {
    display: block;
    transform: scale(var(--pr-target-scale, 1));
    transform-origin: center;
  }
  .world-target-marker__specific {
    display: block;
    transform: scale(var(--pr-target-marker-scale, 1));
    transform-origin: center;
  }
  .world-target-marker.selected .world-target-marker__specific {
    transform: scale(var(--pr-target-marker-target-scale, 1));
  }
  .world-target-marker__effect {
    display: block;
  
  }
  .world-target-marker.selected { color: var(--pr-target-marker-hover, #6287ec); opacity: 1; }
  .effect-pulse { animation: marker-pulse var(--pr-target-marker-effect-speed, 1.2s) ease-in-out infinite; }
  .effect-pulse-glow { animation: marker-glow var(--pr-target-marker-effect-speed, 1.2s) ease-in-out infinite; }
  .effect-spin { animation: marker-spin var(--pr-target-marker-effect-speed, 1.2s) linear infinite; }
  .effect-breathe { animation: marker-breathe var(--pr-target-marker-effect-speed, 1.2s) ease-in-out infinite; }
  @keyframes marker-pulse { 50% { opacity: .45; } }
  @keyframes marker-glow { 50% { filter: drop-shadow(0 0 10px currentColor); } }
  @keyframes marker-spin { to { transform: rotate(360deg); } }
  @keyframes marker-breathe { 50% { transform: scale(var(--pr-target-marker-effect-strength, 1.25)); } }

  .target-options {
    position: absolute;
    top: var(--pr-target-options-y, 48.4%);
    left: calc(var(--pr-target-x, 50%) + var(--pr-target-offset-x, 24px));
    transform: scale(var(--pr-target-scale, 1));
    transform-origin: left top;
    pointer-events: auto;
  }

  .target-option {
    appearance: none;
    border: 0;
    padding: 0;
    color: var(--pr-target-color, #cfd2da);
    display: flex;
    flex-direction: row;
    justify-content: flex-start;
    align-items: center;
    background: linear-gradient(90deg,
      var(--pr-target-background-color, rgba(20, 20, 20, .70)) 0%,
      var(--pr-target-background-fade-color, rgba(20, 20, 20, .60)) 66%,
      transparent 100%);
    font: 500 var(--pr-target-font-size, 14.67px)/var(--pr-target-height, 29.33px) Nunito, Inter, sans-serif;
    margin: 2.67px;
    transition: color 160ms ease, margin-left 160ms ease, background 160ms ease;
    height: var(--pr-target-height, 29.33px);
    width: var(--pr-target-width, 200px);
    text-align: left;
    cursor: pointer;
  }

  .target-option:hover,
  .target-option:focus-visible {
    color: var(--pr-target-hover, #fff);
    margin-left: 5.33px;
    outline: none;
    background: linear-gradient(90deg,
      var(--pr-target-hover-background-color, rgba(30, 30, 30, .70)) 0%,
      var(--pr-target-hover-background-fade-color, rgba(30, 30, 30, .60)) 66%,
      transparent 100%);
  }

  .target-icon {
    flex: 0 0 18.67px;
    width: 18.67px;
    margin: 6.67px;
    color: var(--pr-target-color, #cfd2da);
    font-size: 16px;
    line-height: var(--pr-target-height, 29.33px);
    text-align: center;
  }
</style>
