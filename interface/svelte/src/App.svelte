<script lang="ts">
  import { onMount } from 'svelte'
  import { onNuiMessage, fetchNui, isEnvBrowser } from './nui/bridge'
  import { applyVisualConfig } from './lib/theme'
  import ContextMenu from './modules/ContextMenu.svelte'
  import AlertDialog from './modules/AlertDialog.svelte'
  import InputDialog from './modules/InputDialog.svelte'
  import NotifyStack from './modules/NotifyStack.svelte'
  import TextUI from './modules/TextUI.svelte'
  import ProgressBar from './modules/ProgressBar.svelte'
  import RadialMenu from './modules/RadialMenu.svelte'
  import TargetEye from './modules/TargetEye.svelte'
  import WorldInteract from './modules/WorldInteract.svelte'
  import SkillCheck from './modules/SkillCheck.svelte'
  import BubbleNotify from './modules/BubbleNotify.svelte'
  import GizmoHud from './modules/GizmoHud.svelte'

  let context: any = null
  let alert: any = null
  let input: any = null
  let textui: any = null
  let notifies: any[] = []
  let progress: any = null
  let radial: any = null
  let target: any = { visible: false, groups: [], zones: [], markers: [] }
  let interact: any = { entries: [] }
  let skillcheck: any = null
  let bubbles: any[] = []
  let gizmo: any = null
  let visualConfig: any = {}
  let notifySequence = 0

  function pushNotify(data: any) {
    notifySequence += 1
    notifies = [...notifies, { ...(data || {}), __renderId: `notify:${notifySequence}` }]
  }

  function removeNotify(renderId: string) {
    notifies = notifies.filter((n) => n.__renderId !== renderId)
  }

  function reportTextUIDebug(stage: string, data?: any) {
    if (!data?.debug) return
    void fetchNui('debug:textui', {
      stage,
      text: data.text,
      position: data.position,
      keys: data && typeof data === 'object' ? Object.keys(data) : [],
    })
  }

  function showTextUI(data: any) {
    reportTextUIDebug('message', data)
    textui = data
  }

  function hideTextUI() {
    reportTextUIDebug('hide', textui)
    textui = null
  }

  function applyTheme(data?: any) {
    visualConfig = data || {}
    applyVisualConfig(data)
  }

  onMount(() => {
    applyTheme()

    const unsubscribers = [
      onNuiMessage('theme:apply', applyTheme),
      onNuiMessage('context:open', (data) => (context = data)),
      onNuiMessage('context:close', () => (context = null)),
      onNuiMessage('alert:open', (data) => (alert = data)),
      onNuiMessage('alert:close', () => (alert = null)),
      onNuiMessage('input:open', (data) => (input = data)),
      onNuiMessage('input:close', () => (input = null)),
      onNuiMessage('notify:push', pushNotify),
      onNuiMessage('textui:show', showTextUI),
      onNuiMessage('textui:hide', hideTextUI),
      onNuiMessage('progress:show', (data) => (progress = data)),
      onNuiMessage('progress:hide', () => (progress = null)),
      onNuiMessage('radial:open', (data) => (radial = data)),
      onNuiMessage('radial:close', () => (radial = null)),
      onNuiMessage('target:visible', (data) => {
        target = { ...target, visible: data?.state === true }
        if (!data?.state) target = { visible: false, groups: [], zones: [], markers: [] }
      }),
      onNuiMessage('target:set', (data) => {
        target = { ...target, visible: true, groups: data?.groups || [], zones: data?.zones || [] }
      }),
      onNuiMessage('target:markers', (data) => {
        target = { ...target, markers: Array.isArray(data?.markers) ? data.markers : [] }
      }),
      onNuiMessage('target:left', () => {
        target = { ...target, groups: [], zones: [] }
      }),
      onNuiMessage('interact:set', (data) => (interact = { entries: Array.isArray(data?.entries) ? data.entries : [], key: String(data?.key || 'E') })),
      onNuiMessage('interact:clear', () => (interact = { entries: [] })),
      onNuiMessage('skillcheck:open', (data) => (skillcheck = data)),
      onNuiMessage('skillcheck:close', () => (skillcheck = null)),
      onNuiMessage('bubble:sync', (data) => (bubbles = Array.isArray(data?.items) ? data.items : [])),
      onNuiMessage('gizmo:update', (data) => (gizmo = data)),
      onNuiMessage('gizmo:close', () => (gizmo = null)),
    ]

    window.parent.postMessage({ action: 'ui:frame-ready' }, '*')
    void fetchNui('ui:ready')

    const onKey = (e: KeyboardEvent) => {
      if (e.key !== 'Escape') return

      if (input) {
        if (input.options?.allowCancel === false) return
        fetchNui('input:close', { __resource: input.__resource })
        return
      }
      if (alert) {
        fetchNui('alert:close', { __resource: alert.__resource })
        return
      }
      if (context) {
        if (context.hasParent) {
          fetchNui('context:back', { __resource: context.__resource })
        } else if (context.canClose !== false) {
          fetchNui('context:close', { __resource: context.__resource })
        }
      }
    }

    window.addEventListener('keydown', onKey)
    unsubscribers.push(() => window.removeEventListener('keydown', onKey))

    if (isEnvBrowser()) {
      ;(window as any).__prUiDebug = {
        openNotify: () => {
          pushNotify({ id: Date.now(), title: 'Forgebox UI', description: 'Notificacao Svelte ativa.', type: 'success', duration: 5000 })
        },
        openTextUI: () => (textui = { text: '[E] Interagir com o veiculo', position: 'right-center' }),
        closeTextUI: () => (textui = null),
      }
    }

    return () => unsubscribers.forEach((off) => off())
  })
</script>

<div class="pr-root">
  {#if context}<ContextMenu data={context} />{/if}
  {#if alert}<AlertDialog data={alert} />{/if}
  {#if input}<InputDialog data={input} />{/if}
  <NotifyStack items={notifies} on:remove={(event) => removeNotify(event.detail)} />
  {#if textui}<TextUI data={textui} />{/if}
  {#if progress}<ProgressBar data={progress} />{/if}
  {#if radial}<RadialMenu data={radial} />{/if}
  <TargetEye data={target} eyeIcon={visualConfig?.target?.eyeIcon || 'fa-solid fa-eye'} visual={visualConfig?.target || {}} />
  <WorldInteract data={interact} visual={visualConfig?.interact || {}} />
  {#if skillcheck}<SkillCheck data={skillcheck} />{/if}
  <BubbleNotify items={bubbles} />
  {#if gizmo}<GizmoHud data={gizmo} />{/if}
</div>

<style>
  .pr-root {
    position: relative;
    width: 100%;
    height: 100%;
    pointer-events: none;
    background: transparent !important;
  }

  .pr-root :global(.pr-interactive) {
    pointer-events: auto;
  }
</style>
