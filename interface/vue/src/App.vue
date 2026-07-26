<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { onNuiMessage, fetchNui, isEnvBrowser } from './nui/bridge'
import ContextMenu from './modules/ContextMenu.vue'
import AlertDialog from './modules/AlertDialog.vue'
import InputDialog from './modules/InputDialog.vue'
import NotifyStack from './modules/NotifyStack.vue'
import TextUI from './modules/TextUI.vue'
import { applyVisualConfig } from './lib/theme'

const context = ref<any>(null)
const alert = ref<any>(null)
const input = ref<any>(null)
const textui = ref<any>(null)
const notifies = ref<any[]>([])

const unsubscribers: Array<() => void> = []

onMounted(() => {
  applyVisualConfig()
  unsubscribers.push(
    onNuiMessage('theme:apply', (data) => {
      applyVisualConfig(data)
    }),
    onNuiMessage('context:open', (data) => {
      context.value = data
    }),
    onNuiMessage('context:close', () => {
      context.value = null
    }),
    onNuiMessage('alert:open', (data) => {
      alert.value = data
    }),
    onNuiMessage('alert:close', () => {
      alert.value = null
    }),
    onNuiMessage('input:open', (data) => {
      input.value = data
    }),
    onNuiMessage('input:close', () => {
      input.value = null
    }),
    onNuiMessage('notify:push', (data) => {
      notifies.value = [...notifies.value, data]
    }),
    onNuiMessage('textui:show', (data) => {
      textui.value = data
    }),
    onNuiMessage('textui:hide', () => {
      textui.value = null
    }),
  )

  const onKey = (e: KeyboardEvent) => {
    if (e.key !== 'Escape') return

    if (input.value) {
      if (input.value.options?.allowCancel === false) return
      fetchNui('input:close', { __resource: input.value.__resource })
      return
    }
    if (alert.value) {
      fetchNui('alert:close', { __resource: alert.value.__resource })
      return
    }
    if (context.value) {
      if (context.value.hasParent) {
        fetchNui('context:back', { __resource: context.value.__resource })
      } else if (context.value.canClose !== false) {
        fetchNui('context:close', { __resource: context.value.__resource })
      }
    }
  }

  window.addEventListener('keydown', onKey)
  unsubscribers.push(() => window.removeEventListener('keydown', onKey))

  if (isEnvBrowser()) {
    ;(window as any).__prUiDebug = {
      openContext: () => {
        context.value = {
          id: 'demo',
          title: 'Veículo — SPC-2048',
          canClose: true,
          hasParent: false,
          options: [
            {
              index: 1,
              title: 'Informações do veículo',
              description: 'Placa, combustível e estado do motor.',
              icon: 'car',
              badge: 'PRONTO',
              progress: 82,
              colorScheme: 'green',
              metadata: { Placa: 'SPC-2048', Combustível: '82%', Motor: '94%' },
            },
            {
              index: 2,
              title: 'Guardar na garagem',
              description: 'Sincroniza estado, dano e combustível.',
              icon: 'gar',
              keybind: 'G',
              checked: true,
              colorScheme: 'blue',
            },
            {
              index: 3,
              title: 'Rastrear veículo',
              description: 'Cria uma rota temporária no mapa.',
              icon: 'map',
              arrow: true,
              colorScheme: 'orange',
            },
          ],
        }
      },
      closeContext: () => {
        context.value = null
      },
      openAlert: () => {
        alert.value = {
          id: 'demo',
          title: 'Confirmação',
          content: 'Você tem certeza que deseja realizar esta ação?',
          cancel: 'Cancelar',
          confirm: 'Confirmar',
        }
      },
      closeAlert: () => {
        alert.value = null
      },
      openInput: () => {
        input.value = {
          id: 'demo',
          title: 'Editar veículo',
          inputs: [
            {
              type: 'text',
              label: 'Placa',
              name: 'plate',
              value: 'SPC-2048',
            },
            {
              type: 'number',
              label: 'Combustível (%)',
              name: 'fuel',
              value: 82,
              min: 0,
              max: 100,
            },
          ],
          cancel: 'Cancelar',
          confirm: 'Salvar',
        }
      },
      closeInput: () => {
        input.value = null
      },
      openNotify: () => {
        notifies.value = [
          ...notifies.value,
          {
            id: Date.now(),
            title: 'Forgebox UI',
            description: 'Notificação com visual do UI Kit aplicado.',
            type: 'success',
            duration: 5000,
          },
        ]
      },
      openTextUI: () => {
        textui.value = { text: '[E] Interagir com o veículo', position: 'right-center' }
      },
      closeTextUI: () => {
        textui.value = null
      },
    }

    console.log('%c pr_bridge NUI Debug ', 'background: #3b82f6; color: white; font-size: 14px; padding: 4px 8px; border-radius: 4px;')
    console.log('Use os comandos no console:')
    console.log('  __prUiDebug.openContext() - Abrir menu de contexto')
    console.log('  __prUiDebug.closeContext() - Fechar menu de contexto')
    console.log('  __prUiDebug.openAlert() - Abrir alerta')
    console.log('  __prUiDebug.closeAlert() - Fechar alerta')
    console.log('  __prUiDebug.openInput() - Abrir input')
    console.log('  __prUiDebug.closeInput() - Fechar input')
    console.log('  __prUiDebug.openNotify() - Abrir notificação')
    console.log('  __prUiDebug.openTextUI() - Abrir TextUI')
    console.log('  __prUiDebug.closeTextUI() - Fechar TextUI')
  }
})

onUnmounted(() => {
  for (const off of unsubscribers) off()
})

function removeNotify(id: string | number) {
  notifies.value = notifies.value.filter((n) => n.id !== id)
}
</script>

<template>
  <div class="pr-root">
    <ContextMenu v-if="context" :data="context" />
    <AlertDialog v-if="alert" :data="alert" />
    <InputDialog v-if="input" :data="input" />
    <NotifyStack :items="notifies" @remove="removeNotify" />
    <TextUI v-if="textui" :data="textui" />
  </div>
</template>

<style scoped>
.pr-root {
  position: relative;
  width: 100%;
  height: 100%;
  pointer-events: none;
  background: transparent !important;
  background-color: transparent !important;
}

.pr-root :deep(.pr-interactive) {
  pointer-events: auto;
}
</style>
