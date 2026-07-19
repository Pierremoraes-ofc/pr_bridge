const { createApp, ref, reactive, watch, onMounted, onUnmounted, TransitionGroup, computed } = Vue

async function fetchNui(eventName, data) {
  const resourceName = typeof GetParentResourceName === 'function'
    ? GetParentResourceName()
    : 'pr_bridge'

  // Don't try to fetch in debug mode (browser)
  if (!window.invokeNative && !window.GetParentResourceName) {
    console.log('[DEBUG] fetchNui called (skipped in browser):', eventName, data)
    return undefined
  }

  const response = await fetch(`https://${resourceName}/${eventName}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  })

  try {
    return await response.json()
  } catch {
    return undefined
  }
}

function iconLabel(icon) {
  if (typeof icon === 'string') return icon
  if (icon && typeof icon === 'object' && icon.name) return String(icon.name)
  return ''
}

function metaItems(metadata) {
  if (!metadata) return []
  if (typeof metadata === 'string') return [{ value: metadata }]
  if (Array.isArray(metadata)) {
    return metadata.map((m) => {
      if (typeof m === 'string') return { value: m }
      if (m && typeof m === 'object') {
        const label = m.label ?? m.title
        const value = m.value ?? m.description
        return { label, value: value !== undefined ? value : label }
      }
      return { value: String(m) }
    })
  }
  const items = []
  for (const key in metadata) {
    items.push({ label: key, value: metadata[key] })
  }
  return items
}

function alphaColor(color, alpha) {
  // Assuming color is hex like #ff7a1a
  if (!color) return 'rgba(0,0,0,0)'
  let r = 0, g = 0, b = 0
  if (color.startsWith('#')) {
    const hex = color.slice(1)
    if (hex.length === 3) {
      r = parseInt(hex[0] + hex[0], 16)
      g = parseInt(hex[1] + hex[1], 16)
      b = parseInt(hex[2] + hex[2], 16)
    } else if (hex.length === 6) {
      r = parseInt(hex.slice(0, 2), 16)
      g = parseInt(hex.slice(2, 4), 16)
      b = parseInt(hex.slice(4, 6), 16)
    }
  }
  return `rgba(${r}, ${g}, ${b}, ${alpha})`
}

const accent = '#ff7a1a'
const colorMap = {
  orange: '#ff7a1a',
  blue: '#3b82f6',
  green: '#10b981',
  yellow: '#f59e0b',
  red: '#ef4444',
  purple: '#8b5cf6',
  pink: '#ec4899',
  gray: '#6b7280'
}

function optionColor(option) {
  return colorMap[option.colorScheme] || accent
}

function notifyTone(type) {
  const tones = {
    success: { border: '#10b981', glow: 'rgba(16, 185, 129, 0.4)', icon: '✓' },
    error: { border: '#ef4444', glow: 'rgba(239, 68, 68, 0.4)', icon: '✕' },
    warning: { border: '#f59e0b', glow: 'rgba(245, 158, 11, 0.4)', icon: '⚠' },
    info: { border: '#3b82f6', glow: 'rgba(59, 130, 246, 0.4)', icon: 'ℹ' }
  }
  return tones[type] || tones.info
}

function parseKey(text) {
  const match = text.match(/^\[([^\]]+)\]\s*(.*)$/)
  if (!match) return { key: undefined, message: text }
  return { key: match[1], message: match[2] || text }
}

createApp({
  components: { TransitionGroup },
  setup() {
    const context = ref(null)
    const alert = ref(null)
    const input = ref(null)
    const textui = ref(null)
    const notifies = ref([])
    const inputValues = reactive({})
    const timers = new Map()
    const progress = reactive({})
    const searchQuery = ref('')
    const searchExpanded = ref(false)
    // Store menu history for debug navigation
    let menuHistory = []

    const filteredOptions = computed(() => {
      if (!context.value?.options) return []
      if (!searchQuery.value) return context.value.options
      
      const query = searchQuery.value.toLowerCase()
      return context.value.options.filter(opt => 
        (opt.title?.toLowerCase() || '').includes(query) ||
        (opt.description?.toLowerCase() || '').includes(query)
      )
    })

    function toggleSearch() {
      searchExpanded.value = !searchExpanded.value
      if (!searchExpanded.value) {
        searchQuery.value = ''
      }
    }

    function onMessage(event) {
      const payload = event.data
      if (!payload || typeof payload.action !== 'string') return
      const { action, data } = payload

      switch (action) {
        case 'context:open':
          context.value = data
          searchQuery.value = ''
          searchExpanded.value = false
          break
        case 'context:close':
          context.value = null
          menuHistory = []
          searchQuery.value = ''
          searchExpanded.value = false
          break
        case 'alert:open':
          alert.value = data
          break
        case 'alert:close':
          alert.value = null
          break
        case 'input:open':
          input.value = data
          break
        case 'input:close':
          input.value = null
          break
        case 'notify:push':
          notifies.value = [...notifies.value, data]
          break
        case 'textui:show':
          textui.value = data
          break
        case 'textui:hide':
          textui.value = null
          break
      }
    }

    function onKey(event) {
      if (event.key === 'Escape') {
        if (searchExpanded.value) {
          toggleSearch()
          return
        }
        if (input.value) {
          fetchNui('input:close')
          return
        }
        if (alert.value) {
          fetchNui('alert:close')
          return
        }
        if (context.value) {
          if (context.value.hasParent) fetchNui('context:back')
          else if (context.value.canClose !== false) fetchNui('context:close')
        }
      }
    }

    watch(
      () => input.value && input.value.rows,
      (rows) => {
        Object.keys(inputValues).forEach((k) => delete inputValues[k])
        ;(rows || []).forEach((row) => {
          inputValues[row.index] = row.default ?? (row.type === 'checkbox' ? false : '')
        })
      },
    )

    watch(
      notifies,
      (items) => {
        items.forEach((item) => {
          if (timers.has(item.id)) return
          const duration = item.duration ?? 5000
          progress[item.id] = 100
          const started = Date.now()

          const handle = window.setInterval(() => {
            const elapsed = Date.now() - started
            const pct = Math.max(0, 100 - (elapsed / duration) * 100)
            progress[item.id] = pct
            if (pct <= 0) {
              window.clearInterval(handle)
              timers.delete(item.id)
              notifies.value = notifies.value.filter((n) => n.id !== item.id)
              delete progress[item.id]
            }
          }, 50)

          timers.set(item.id, handle)
        })
      },
      { deep: true },
    )
    
    const searchInput = ref(null)
    watch(searchExpanded, (newVal) => {
      if (newVal) {
        setTimeout(() => {
          if (searchInput.value) {
            searchInput.value.focus()
          }
        }, 100)
      }
    })

    onMounted(() => {
      window.addEventListener('message', onMessage)
      window.addEventListener('keydown', onKey)

      // Adiciona ferramentas de debug para navegador
      if (!window.invokeNative) {
        window.__prUiDebug = {
          // Menu principal completo com todos os recursos
          openContext: () => {
            menuHistory = []
            searchQuery.value = ''
            searchExpanded.value = false
            context.value = {
              id: 'main',
              title: 'Menu Principal — Demo',
              canClose: true,
              hasParent: false,
              headerImage: 'https://coresg-normal.trae.ai/api/v1/text-to-image?prompt=city%20logo%20simple%20modern%20orange%20and%20black&image_size=square',
              options: [
                {
                  index: 1,
                  title: 'Veículo — SPC-2048',
                  description: 'Placa, combustível e estado do motor.',
                  icon: 'bi-car-front',
                  badge: 'PRONTO',
                  progress: 82,
                  colorScheme: 'green',
                  metadata: { Placa: 'SPC-2048', Combustível: '82%', Motor: '94%', Tanque: '55L' },
                },
                {
                  index: 2,
                  title: 'Guardar na garagem',
                  description: 'Sincroniza estado, dano e combustível.',
                  keybind: 'G',
                  checked: true,
                  colorScheme: 'blue',
                },
                {
                  index: 3,
                  title: 'Rastrear veículo',
                  description: 'Cria uma rota temporária no mapa.',
                  icon: 'bi-map',
                  arrow: true,
                  colorScheme: 'orange',
                },
                {
                  index: 4,
                  title: 'Configurações',
                  description: 'Ajustes do sistema.',
                  icon: 'bi-gear',
                  arrow: true,
                  colorScheme: 'purple',
                },
                {
                  index: 5,
                  title: 'Sistema de Som',
                  description: 'Controle de volume.',
                  icon: 'bi-speaker',
                  progress: 65,
                  colorScheme: 'pink',
                },
                {
                  index: 6,
                  title: 'Modo Avião',
                  description: 'Desativa conexões.',
                  icon: 'bi-airplane',
                  checked: false,
                  colorScheme: 'gray',
                },
              ],
            }
          },
          // Menu de configurações (submenu)
          openSettingsMenu: () => {
            menuHistory.push(context.value)
            searchQuery.value = ''
            searchExpanded.value = false
            context.value = {
              id: 'settings',
              title: 'Configurações',
              canClose: true,
              hasParent: true,
              options: [
                {
                  index: 1,
                  title: 'Gráficos',
                  description: 'Qualidade e resolução.',
                  icon: 'bi-display',
                  arrow: true,
                  colorScheme: 'blue',
                },
                {
                  index: 2,
                  title: 'Áudio',
                  description: 'Volume master e efeitos.',
                  icon: 'bi-music-note-beamed',
                  progress: 70,
                  colorScheme: 'green',
                },
                {
                  index: 3,
                  title: 'Notificações',
                  description: 'Ativar/desativar alertas.',
                  icon: 'bi-bell',
                  checked: true,
                  colorScheme: 'yellow',
                },
                {
                  index: 4,
                  title: 'Idioma',
                  description: 'Português (BR)',
                  icon: 'bi-translate',
                  badge: 'PT-BR',
                  colorScheme: 'purple',
                },
              ],
            }
          },
          closeContext: () => {
            context.value = null
            menuHistory = []
            searchQuery.value = ''
            searchExpanded.value = false
          },
          // Voltar para o menu anterior
          backContext: () => {
            if (menuHistory.length > 0) {
              context.value = menuHistory.pop()
              searchQuery.value = ''
              searchExpanded.value = false
            }
          },
          openAlert: () => {
            alert.value = {
              id: 'demo',
              header: 'Confirmação',
              content: 'Você tem certeza que deseja realizar esta ação?',
              labels: { cancel: 'Cancelar', confirm: 'Confirmar' },
            }
          },
          closeAlert: () => {
            alert.value = null
          },
          openInput: () => {
            input.value = {
              id: 'demo',
              heading: 'Editar veículo',
              rows: [
                {
                  index: 1,
                  type: 'text',
                  label: 'Placa',
                  default: 'SPC-2048',
                  placeholder: 'Digite a placa',
                },
                {
                  index: 2,
                  type: 'number',
                  label: 'Combustível (%)',
                  default: 82,
                  min: 0,
                  max: 100,
                  placeholder: '0-100',
                },
                {
                  index: 3,
                  type: 'select',
                  label: 'Cor do veículo',
                  default: 'preto',
                  options: [
                    { label: 'Preto', value: 'preto' },
                    { label: 'Branco', value: 'branco' },
                    { label: 'Vermelho', value: 'vermelho' },
                    { label: 'Azul', value: 'azul' },
                  ],
                },
                {
                  index: 4,
                  type: 'checkbox',
                  label: 'Ativar alarme',
                  default: true,
                },
                {
                  index: 5,
                  type: 'textarea',
                  label: 'Observações',
                  default: 'Veículo em boas condições.',
                  placeholder: 'Digite observações...',
                },
              ],
            }
          },
          closeInput: () => {
            input.value = null
          },
          // Notificações de diferentes tipos
          openNotify: (type = 'success') => {
            const types = {
              success: { title: 'Sucesso!', description: 'Operação concluída com êxito.', type: 'success' },
              error: { title: 'Erro', description: 'Ocorreu um problema durante a operação.', type: 'error' },
              warning: { title: 'Aviso', description: 'Verifique as informações antes de continuar.', type: 'warning' },
              info: { title: 'Informação', description: 'Nova atualização disponível.', type: 'info' },
            }
            const notif = types[type] || types.success
            notifies.value = [
              ...notifies.value,
              {
                id: Date.now(),
                ...notif,
                duration: 5000,
              },
            ]
          },
          // TextUI em diferentes posições
          openTextUI: (position = 'right-center') => {
            textui.value = { 
              text: '[E] Interagir', 
              position: position,
              icon: 'bi-hand-index'
            }
          },
          closeTextUI: () => {
            textui.value = null
          },
          // Lista todos os comandos
          help: () => {
            console.log('%c🔧 Comandos disponíveis:', 'font-weight: bold; font-size: 14px;')
            console.log('  openContext()        - Abre o menu principal')
            console.log('  openSettingsMenu()   - Abre o submenu de configurações')
            console.log('  backContext()        - Volta ao menu anterior')
            console.log('  closeContext()       - Fecha o menu')
            console.log('  openAlert()          - Abre o alerta')
            console.log('  closeAlert()         - Fecha o alerta')
            console.log('  openInput()          - Abre o formulário de input')
            console.log('  closeInput()         - Fecha o input')
            console.log('  openNotify([tipo])   - Abre notificação (tipos: success, error, warning, info)')
            console.log('  openTextUI([pos])    - Abre TextUI (posições: right-center, left-center, top-center, bottom-center)')
            console.log('  closeTextUI()        - Fecha o TextUI')
            console.log('  help()               - Mostra esta lista de ajuda')
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
      window.removeEventListener('message', onMessage)
      window.removeEventListener('keydown', onKey)
      for (const handle of timers.values()) window.clearInterval(handle)
      timers.clear()
    })

    return {
      context,
      alert,
      input,
      textui,
      notifies,
      inputValues,
      progress,
      searchQuery,
      searchExpanded,
      searchInput,
      filteredOptions,
      toggleSearch,
      iconLabel,
      metaItems,
      optionColor,
      alphaColor,
      tone: notifyTone,
      parsed: parseKey,
      selectOption(option) {
        if (!context.value || option.disabled || option.readOnly) return
        
        // Navegação de debug para submenus
        if (window.__prUiDebug) {
          if (context.value.id === 'main' && option.index === 4) {
            window.__prUiDebug.openSettingsMenu()
            return
          }
          console.log('[DEBUG] Menu option selected:', option)
          return
        }
        
        fetchNui('context:select', { id: context.value.id, index: option.index })
      },
      closeContext() {
        if (window.__prUiDebug) {
          window.__prUiDebug.closeContext()
        } else {
          fetchNui('context:close')
        }
      },
      backContext() {
        if (window.__prUiDebug) {
          window.__prUiDebug.backContext()
        } else {
          fetchNui('context:back')
        }
      },
      alertConfirm() {
        if (window.__prUiDebug) {
          console.log('[DEBUG] Alert confirmed')
          alert.value = null
          return
        }
        fetchNui('alert:result', { result: 'confirm' })
      },
      alertCancel() {
        if (window.__prUiDebug) {
          console.log('[DEBUG] Alert cancelled')
          alert.value = null
          return
        }
        fetchNui('alert:result', { result: 'cancel' })
      },
      submitInput() {
        if (!input.value) return
        if (window.__prUiDebug) {
          console.log('[DEBUG] Input submitted with values:', inputValues)
          input.value = null
          return
        }
        const ordered = []
        for (const row of input.value.rows || []) {
          if (row.required && (inputValues[row.index] === '' || inputValues[row.index] == null)) {
            return
          }
          ordered.push(inputValues[row.index])
        }
        fetchNui('input:submit', { values: ordered })
      },
      closeInput() {
        if (window.__prUiDebug) {
          input.value = null
          return
        }
        fetchNui('input:close')
      },
      textuiClass(position) {
        switch (position) {
          case 'left-center':
            return 'is-left'
          case 'top-center':
            return 'is-top'
          case 'bottom-center':
            return 'is-bottom'
          default:
            return 'is-right'
        }
      },
    }
  },
  template: `
    <div class="pr-root">
      <div v-if="context" class="ctx pr-interactive">
        <header class="ctx__header">
          <img v-if="context.headerImage" class="ctx__header-image" :src="context.headerImage" alt="" />
          <div class="ctx__header-top">
            <button v-if="context.hasParent" class="ctx__nav" type="button" @click="backContext">
              <i class="bi-chevron-left"></i>
            </button>
            <span v-else class="ctx__nav-spacer"></span>
            <div class="ctx__heading">
              <h2 class="ctx__title">{{ context.title }}</h2>
            </div>
            <button v-if="context.canClose !== false" class="ctx__nav" type="button" @click="closeContext">
              <i class="bi-x-lg"></i>
            </button>
            <span v-else class="ctx__nav-spacer"></span>
          </div>
          <div class="ctx__search-container">
            <div v-if="!searchExpanded" class="ctx__search-icon" @click="toggleSearch">
              <i class="bi-search"></i>
            </div>
            <input
              v-if="searchExpanded"
              type="text"
              class="ctx__search"
              placeholder="Buscar opções..."
              v-model="searchQuery"
              ref="searchInput"
              @blur="searchQuery.length === 0 && (searchExpanded = false)"
              @keyup.esc="toggleSearch"
            />
          </div>
        </header>
        <ul class="ctx__list">
          <li
            v-for="option in filteredOptions"
            :key="option.index"
            class="ctx__item"
            :class="{ 'is-disabled': option.disabled, 'is-readonly': option.readOnly }"
            @click="selectOption(option)"
          >
            <div v-if="option.icon" class="ctx__icon" :style="{ color: option.iconColor || optionColor(option) }">
              <i :class="option.icon"></i>
            </div>
            <div class="ctx__body">
              <div class="ctx__row">
                <span class="ctx__item-title">{{ option.title }}</span>
                <span v-if="option.badge" class="ctx__badge">{{ option.badge }}</span>
                <span v-if="option.arrow" class="ctx__arrow">›</span>
              </div>
              <p v-if="option.description" class="ctx__desc">{{ option.description }}</p>
              <ul v-if="metaItems(option.metadata).length" class="ctx__meta">
                <li v-for="(m, i) in metaItems(option.metadata)" :key="i">
                  <span v-if="m.label" class="ctx__meta-label">{{ m.label }}</span>
                  <span class="ctx__meta-value">{{ m.value }}</span>
                </li>
              </ul>
              <div v-if="option.progress != null" class="ctx__progress">
                <div
                  class="ctx__progress-bar"
                  :style="{
                    width: Math.max(0, Math.min(100, option.progress)) + '%',
                    backgroundColor: optionColor(option),
                    boxShadow: '0 0 8px ' + alphaColor(optionColor(option), 0.45)
                  }"
                ></div>
              </div>
            </div>
            <div class="ctx__aside">
              <span v-if="option.checked !== undefined" class="ctx__check" :class="{ 'is-on': option.checked }">✓</span>
              <span v-if="option.keybind" class="ctx__keybind">{{ option.keybind }}</span>
              <span v-if="option.arrow" class="ctx__arrow">›</span>
            </div>
            <img v-if="option.image" class="ctx__image" :src="option.image" alt="" />
          </li>
        </ul>
      </div>

      <div v-if="alert" class="alert-backdrop pr-interactive" :class="{ 'is-centered': alert.centered !== false }" @click.self="alertCancel">
        <div class="alert fb-panel">
          <div class="alert__icon">
            <i class="bi-exclamation-triangle" style="font-size: 32px;"></i>
          </div>
          <h2 class="alert__header">{{ alert.header }}</h2>
          <p class="alert__content">{{ alert.content }}</p>
          <div class="alert__actions">
            <button v-if="alert.cancel !== false" type="button" class="fb-btn fb-btn-secondary" @click="alertCancel">
              {{ (alert.labels && alert.labels.cancel) || 'Cancelar' }}
            </button>
            <button type="button" class="fb-btn fb-btn-primary" @click="alertConfirm">
              {{ (alert.labels && alert.labels.confirm) || 'Confirmar' }}
            </button>
          </div>
        </div>
      </div>

      <div v-if="input" class="input-backdrop pr-interactive" @click.self="closeInput">
        <form class="input fb-panel" @submit.prevent="submitInput">
          <header class="input__header">
            <h2 class="input__heading">{{ input.heading }}</h2>
            <button type="button" class="input__close" aria-label="Fechar" @click="closeInput">×</button>
          </header>
          <div class="input__fields">
            <div v-for="row in input.rows" :key="row.index" class="input__field">
              <label v-if="row.label && row.type !== 'checkbox'" class="input__label">
                {{ row.label }}
                <span v-if="row.required" class="input__req">*</span>
              </label>
              <p v-if="row.description" class="input__desc">{{ row.description }}</p>

              <select v-if="row.type === 'select'" v-model="inputValues[row.index]" class="fb-input" :disabled="row.disabled">
                <option v-for="(opt, i) in (row.options || [])" :key="i" :value="opt.value">{{ opt.label }}</option>
              </select>

              <label v-else-if="row.type === 'checkbox'" class="input__check">
                <input v-model="inputValues[row.index]" type="checkbox" :disabled="row.disabled" />
                <span class="input__check-box" :class="{ 'is-on': inputValues[row.index] }">✓</span>
                <span>{{ row.placeholder || row.label }}</span>
              </label>

              <textarea
                v-else-if="row.type === 'textarea'"
                v-model="inputValues[row.index]"
                class="fb-input fb-input--area"
                :placeholder="row.placeholder"
                :disabled="row.disabled"
                rows="3"
              ></textarea>

              <input
                v-else
                v-model="inputValues[row.index]"
                class="fb-input"
                :type="row.password ? 'password' : (row.type === 'number' ? 'number' : 'text')"
                :placeholder="row.placeholder"
                :disabled="row.disabled"
                :min="row.min"
                :max="row.max"
                :step="row.step"
              />
            </div>
          </div>
          <div class="input__actions">
            <button type="button" class="fb-btn fb-btn-secondary" @click="closeInput">Cancelar</button>
            <button type="submit" class="fb-btn fb-btn-primary">Confirmar</button>
          </div>
        </form>
      </div>

      <div class="notify-stack">
        <TransitionGroup name="notify">
          <div
            v-for="item in notifies"
            :key="item.id"
            class="notify"
            :style="{
              borderLeftColor: tone(item.type).border,
              boxShadow: '0 8px 30px rgba(0,0,0,0.5), 0 0 20px ' + tone(item.type).glow
            }"
          >
            <span class="notify__icon" :style="{ color: tone(item.type).border }">
              {{ tone(item.type).icon }}
            </span>
            <div class="notify__content">
              <strong v-if="item.title" class="notify__title">{{ item.title }}</strong>
              <p class="notify__desc">{{ item.description }}</p>
            </div>
            <div
              class="notify__progress"
              :style="{
                width: (progress[item.id] ?? 100) + '%',
                backgroundColor: tone(item.type).border
              }"
            />
          </div>
        </TransitionGroup>
      </div>

      <div v-if="textui" class="textui" :class="textuiClass(textui.position)">
        <span v-if="textui.icon" class="textui__icon">
          <i :class="textui.icon"></i>
        </span>
        <span v-if="parsed(textui.text).key" class="textui__key">{{ parsed(textui.text).key }}</span>
        <span class="textui__text">{{ parsed(textui.text).message || textui.text }}</span>
      </div>
    </div>
  `,
}).mount('#app')
