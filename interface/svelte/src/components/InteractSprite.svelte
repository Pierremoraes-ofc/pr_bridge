<script lang="ts">
import BootstrapIcon from './BootstrapIcon.svelte'
export let model='obtaizen_ui'
export let kind='pin'
const shapes=new Set(['circle','record-circle','crosshair','bullseye','geo-alt-fill','cursor-fill','diamond'])
$: shape=shapes.has(model)
$: secondary = kind==='pin' ? 'var(--pr-interact-secondary-color)' : kind==='interact' ? 'var(--pr-interact-key-secondary-color)' : (kind==='selected'||kind==='select_opt') ? 'var(--pr-interact-selected-secondary-color)' : 'var(--pr-interact-unselected-secondary-color)'
function asset(){
 const names:Record<string,string>={pin:'point',interact:'key',selected:'label',unselected:'label_no',select_opt:'circle_selected',unselect_opt:'circle'}
 return `https://cfx-nui-pr_bridge/interface/dist/svelte/interact-assets/${model==='gold_circle'?'blue_circle':model}/${model==='obtaizen_ui'?names[kind]:kind}.png`
}
</script>
<span class="sprite-content" style={`--sprite-secondary:${secondary}`}>
{#if model==='glitch'}
<svg viewBox="0 0 32 32" preserveAspectRatio="none" aria-hidden="true">
 {#if kind==='pin'}
 <path d="M6 10 L16 20 L26 10" fill="none" stroke="var(--sprite-secondary)" stroke-width="5" transform="translate(-2,2)"/>
 <path d="M6 10 L16 20 L26 10" fill="none" stroke="currentColor" stroke-width="5" transform="translate(2,-2)"/>
 <path d="M6 10 L16 20 L26 10" fill="none" stroke="white" stroke-opacity="var(--pr-interact-pin-opacity,1)" stroke-width="2"/>
 {:else}
 <path d="M2 12 V2 H12 M20 30 H30 V20" fill="none" stroke="var(--sprite-secondary)" stroke-width="3" transform="translate(-1,1)"/>
 <path d="M2 12 V2 H12 M20 30 H30 V20" fill="none" stroke="currentColor" stroke-width="3" transform="translate(1,-1)"/>
 {/if}
</svg>
{:else if model==='obtaizen_ui' && (kind==='pin'||kind==='interact')}
<svg viewBox="0 0 32 32" aria-hidden="true"><path d="M16 8 L28 20 L16 31 L4 20 Z" fill="var(--sprite-secondary)"/><path d="M16 1 L29 14 L16 27 L3 14 Z" fill="currentColor"/>{#if kind==='pin'}<path d="M16 6 L24 14 L16 22 L8 14 Z" fill="none" stroke="white" stroke-opacity="var(--pr-interact-pin-opacity,1)" stroke-width="1.4"/>{/if}</svg>
{:else if shape && (kind==='pin'||kind==='interact')}
<span class="icon back"><BootstrapIcon name={model}/></span><span class="icon front"><BootstrapIcon name={model}/></span>
{:else}
<span class="layer back" style={`--mask:url("${shape?'https://cfx-nui-pr_bridge/interface/dist/svelte/interact-assets/blue_circle/'+kind+'.png':asset()}")`}></span>
<span class="layer front" style={`--mask:url("${shape?'https://cfx-nui-pr_bridge/interface/dist/svelte/interact-assets/blue_circle/'+kind+'.png':asset()}")`}></span>
{/if}
</span>
<style>.sprite-content{display:block;width:100%;height:100%}svg{width:100%;height:100%;overflow:visible}.layer,.icon{position:absolute;inset:0}.layer{background:currentColor;mask:var(--mask) center/100% 100% no-repeat;-webkit-mask:var(--mask) center/100% 100% no-repeat}.back{color:var(--sprite-secondary);transform:translate(-2px,3px)}.front{color:inherit}.icon{display:flex;align-items:center;justify-content:center}.icon :global(svg){width:100%;height:100%}</style>
