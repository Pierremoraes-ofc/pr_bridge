<script lang="ts">
  import { fetchNui } from '../nui/bridge'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  export let data: {
    __resource?: string
    header?: string
    title?: string
    content: string
    centered?: boolean
    cancel?: boolean
    labels?: { cancel?: string; confirm?: string }
  }

  const confirm = () => fetchNui('alert:result', { result: 'confirm', __resource: data.__resource })
  const cancel = () => fetchNui('alert:result', { result: 'cancel', __resource: data.__resource })
</script>

<div class:is-centered={data.centered !== false} class="alert-backdrop pr-interactive" on:click|self={cancel}>
  <div class="alert fb-panel">
    <div class="alert__icon"><BootstrapIcon name="exclamation-triangle-fill" /></div>
    <h2 class="alert__header">{data.header || data.title}</h2>
    <p class="alert__content">{data.content}</p>
    <div class="alert__actions">
      {#if data.cancel !== false}
        <button type="button" class="fb-btn fb-btn-ghost" on:click={cancel}>{data.labels?.cancel || 'Cancelar'}</button>
      {/if}
      <button type="button" class="fb-btn fb-btn-primary" on:click={confirm}>{data.labels?.confirm || 'Confirmar'}</button>
    </div>
  </div>
</div>

<style>
  .alert-backdrop { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; padding: 18px; background: transparent; animation: fb-fade-in 0.2s ease; }
  .alert { width: min(420px, 92vw); padding: 28px 24px 22px; text-align: center; background: var(--fb-nui-surface); animation: fb-pop-in 0.24s cubic-bezier(0.1, 0.8, 0.25, 1); }
  .alert__icon { width: 52px; height: 52px; margin: 0 auto 14px; display: grid; place-items: center; border-radius: 50%; font-size: 22px; color: var(--fb-orange); background: var(--fb-orange-subtle); border: 1px solid var(--fb-orange-glow-light); }
  .alert__header { font-family: var(--fb-font-heading); font-size: 18px; font-weight: 600; margin-bottom: 10px; }
  .alert__content { font-size: 14px; line-height: 1.5; color: var(--fb-text-grey); white-space: pre-wrap; }
  .alert__actions { display: flex; justify-content: center; gap: 10px; margin-top: 22px; }
</style>
