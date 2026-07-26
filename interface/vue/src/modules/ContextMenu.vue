<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue'
import { fetchNui } from '../nui/bridge'
import { alphaColor, iconName, metaItems } from '../lib/forgebox'
import BootstrapIcon from '../components/BootstrapIcon.vue'
import forgeSymbol from '../assets/forge-symbol.webp'

const props = defineProps<{
  data: {
    id: string
    __resource?: string
    title: string
    position?: string
    canClose?: boolean
    hasParent?: boolean
    searchPlaceholder?: string
    searchEmpty?: string
    options: Array<{
      index: number
      title: string
      description?: string
      icon?: string | Record<string, unknown>
      iconColor?: string
      iconAnimation?: string
      disabled?: boolean
      readOnly?: boolean
      metadata?: string | Array<string | Record<string, unknown>> | Record<string, unknown>
      progress?: number
      image?: string
      arrow?: boolean
      badge?: string
      keybind?: string
      checked?: boolean
      colorScheme?: string
    }>
  }
}>()

const hoveredOption = ref<any | null>(null)
const tooltipRect = ref({ top: 0, left: 0 })
const searchOpen = ref(false)
const searchQuery = ref('')
const searchInput = ref<HTMLInputElement | null>(null)

const hoveredMetadata = computed(() => metaItems(hoveredOption.value?.metadata))
const metadataOnLeft = computed(() => document.documentElement.dataset.metadataSide === 'left')
const hoveredImage = computed(() => {
  const image = hoveredOption.value?.image
  return typeof image === 'string' ? image : ''
})
const tooltipStyle = computed(() => ({
  top: `${tooltipRect.value.top}px`,
  left: `${tooltipRect.value.left}px`,
}))
const filteredOptions = computed(() => {
  const query = normalizeSearch(searchQuery.value)
  if (!query) return props.data.options || []

  return (props.data.options || []).filter((option) => {
    const metadata = metaItems(option.metadata)
      .map((item) => `${item.label || ''} ${item.value || ''}`)
      .join(' ')
    const searchable = [
      option.title,
      option.description,
      option.badge,
      option.keybind,
      metadata,
    ].join(' ')

    return normalizeSearch(searchable).includes(query)
  })
})

watch(
  () => props.data.id,
  () => {
    searchOpen.value = false
    searchQuery.value = ''
    hoveredOption.value = null
  },
)

watch(searchQuery, () => {
  hoveredOption.value = null
})

function normalizeSearch(value: unknown): string {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim()
}

async function toggleSearch() {
  searchOpen.value = !searchOpen.value
  if (!searchOpen.value) {
    searchQuery.value = ''
    return
  }

  await nextTick()
  searchInput.value?.focus()
}

function closeSearch() {
  searchOpen.value = false
  searchQuery.value = ''
}

function onSelect(option: any, id: string) {
  if (option.disabled || option.readOnly) return
  fetchNui('context:select', { id, index: option.index, __resource: props.data.__resource })
}

function onClose() {
  fetchNui('context:close', { __resource: props.data.__resource })
}

function onBack() {
  fetchNui('context:back', { __resource: props.data.__resource })
}

function optionColor(option: any): string {
  const map: Record<string, string> = {
    orange: 'var(--fb-orange)',
    blue: 'var(--fb-info)',
    green: 'var(--fb-success)',
    yellow: 'var(--fb-warning)',
    red: 'var(--fb-error)',
    purple: '#8b5cf6',
    cyan: '#06b6d4',
  }
  if (map[option.colorScheme]) return map[option.colorScheme]
  return getComputedStyle(document.documentElement).getPropertyValue('--fb-orange').trim() || '#ff7a1a'
}

function hasOptionIcon(icon: unknown): boolean {
  if (typeof icon === 'string') return icon.trim().length > 0
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
    hoveredOption.value = null
    return
  }

  const rect = (event.currentTarget as HTMLElement).getBoundingClientRect()
  hoveredOption.value = option
  tooltipRect.value = {
    top: rect.top + rect.height / 2,
    left: metadataOnLeft.value ? rect.left - 12 : rect.right + 12,
  }
}
</script>

<template>
  <div class="ctx-shell">
    <div class="ctx pr-interactive" :class="positionClass(data.position)">
    <div class="ctx__brand" aria-hidden="true">
      <img class="ctx__brand-image" :src="forgeSymbol" alt="" />
    </div>

    <header class="ctx__header">
      <button
        v-if="data.hasParent"
        class="ctx__nav"
        type="button"
        aria-label="Voltar"
        @click="onBack"
      >
        <BootstrapIcon class="ctx__nav-icon" name="chevron-left" />
      </button>
      <span v-else class="ctx__nav-spacer" />

      <div class="ctx__heading">
        <h2 class="ctx__title">{{ data.title }}</h2>
      </div>

      <div class="ctx__actions">
        <button
          class="ctx__nav"
          :class="{ 'is-active': searchOpen }"
          type="button"
          aria-label="Buscar"
          @click="toggleSearch"
        >
          <BootstrapIcon class="ctx__nav-icon" name="search" />
        </button>

        <button
          v-if="data.canClose !== false"
          class="ctx__nav ctx__nav--close"
          type="button"
          aria-label="Fechar"
          @click="onClose"
        >
          <BootstrapIcon class="ctx__nav-icon" name="x-lg" />
        </button>
      </div>
    </header>

    <div v-if="searchOpen" class="ctx__search">
      <BootstrapIcon class="ctx__search-icon" name="search" />
      <input
        ref="searchInput"
        v-model="searchQuery"
        class="ctx__search-input"
        type="text"
        :placeholder="data.searchPlaceholder || 'Buscar opcao...'"
        autocomplete="off"
        @keydown.esc.stop.prevent="closeSearch"
      />
      <button
        v-if="searchQuery"
        class="ctx__search-clear"
        type="button"
        aria-label="Limpar busca"
        @click="searchQuery = ''"
      >
        <BootstrapIcon name="x-circle" />
      </button>
    </div>

    <ul class="ctx__list">
      <li
        v-for="option in filteredOptions"
        :key="option.index"
        class="ctx__item"
        :class="{
          'is-disabled': option.disabled,
          'is-readonly': option.readOnly,
          'has-icon': hasOptionIcon(option.icon),
        }"
        @click="onSelect(option, data.id)"
        @mouseenter="onOptionEnter(option, $event)"
      >
        <BootstrapIcon
          v-if="hasOptionIcon(option.icon)"
          class="ctx__icon"
          :class="{
            'is-spin': option.iconAnimation === 'spin',
            'is-pulse': option.iconAnimation === 'pulse' || option.iconAnimation === 'beat',
          }"
          :name="iconName(option.icon)"
          :style="{ color: option.iconColor || optionColor(option) }"
        />

        <div class="ctx__body">
          <div class="ctx__row">
            <span class="ctx__item-title">{{ option.title }}</span>
            <span v-if="option.badge" class="ctx__badge">{{ option.badge }}</span>
          </div>

          <p v-if="option.description" class="ctx__desc">{{ option.description }}</p>

          <div v-if="option.progress != null" class="ctx__progress">
            <div
              class="ctx__progress-bar"
              :style="{
                width: `${Math.max(0, Math.min(100, option.progress))}%`,
                backgroundColor: optionColor(option),
                boxShadow: `0 0 8px ${alphaColor(optionColor(option), 0.45)}`,
              }"
            />
          </div>
        </div>

        <div class="ctx__aside">
          <span v-if="option.checked !== undefined" class="ctx__check" :class="{ 'is-on': option.checked }">
            <BootstrapIcon name="check-lg" />
          </span>
          <span v-if="option.keybind" class="ctx__keybind">{{ option.keybind }}</span>
          <BootstrapIcon v-if="option.arrow" class="ctx__arrow" name="chevron-right" />
        </div>
      </li>
      <li v-if="filteredOptions.length === 0" class="ctx__empty">
        <BootstrapIcon name="search" />
        <span>{{ data.searchEmpty || 'Nenhuma opcao encontrada.' }}</span>
      </li>
    </ul>
    </div>

    <div
      v-if="hoveredMetadata.length || hoveredImage"
      class="ctx__tooltip pr-interactive"
      :class="{ 'is-left': metadataOnLeft }"
      :style="tooltipStyle"
    >
      <div class="ctx__tooltip-arrow" />
      <img v-if="hoveredImage" class="ctx__meta-preview" :src="hoveredImage" alt="" />
      <ul class="ctx__meta">
        <li v-for="(m, i) in hoveredMetadata" :key="i" class="ctx__meta-item">
          <img v-if="m.image" class="ctx__meta-image" :src="m.image" alt="" />
          <div class="ctx__meta-content">
            <span v-if="m.label" class="ctx__meta-label">{{ m.label }}</span>
            <span class="ctx__meta-value">{{ m.value }}</span>
            <span v-if="m.progress != null" class="ctx__meta-progress">
              <span
                :style="{
                  width: `${Math.max(0, Math.min(100, m.progress))}%`,
                  backgroundColor: optionColor(m),
                }"
              />
            </span>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.ctx-shell {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: transparent !important;
}

.ctx {
  position: absolute;
  width: min(390px, 92vw);
  max-height: min(72vh, 680px);
  display: flex;
  flex-direction: column;
  border: 0;
  background: transparent;
  box-shadow: none;
  overflow: visible;
  animation: fb-slide-in-left 0.28s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.ctx__brand {
  position: absolute;
  top: -70px;
  left: 0;
  width: 66px;
  height: 66px;
  overflow: hidden;
  pointer-events: none;
}

.ctx__brand-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  filter: drop-shadow(0 5px 12px rgba(0, 0, 0, 0.45));
}

.ctx--top-right {
  top: 7%;
  right: 17%;
}

.ctx--top-left {
  top: 7%;
  left: 7%;
}

.ctx--bottom-right {
  right: 17%;
  bottom: 7%;
}

.ctx--bottom-left {
  left: 7%;
  bottom: 7%;
}

.ctx--center-right {
  top: 50%;
  right: 4%;
  transform: translateY(-50%);
}

.ctx--center-left {
  top: 50%;
  left: 4%;
  transform: translateY(-50%);
}

.ctx__header {
  display: grid;
  grid-template-columns: 36px minmax(0, 1fr) auto;
  align-items: center;
  gap: 8px;
  padding: 0;
  margin-bottom: 7px;
  border: 0;
  background: transparent;
}

.ctx__actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 6px;
}

.ctx__heading {
  min-width: 0;
  min-height: 36px;
  display: grid;
  place-items: center;
  padding: 7px 12px;
  text-align: center;
  border: 1px solid var(--fb-orange-glow-light);
  border-radius: var(--fb-radius-md);
  background: var(--fb-nui-surface);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

.ctx__title {
  font-family: var(--fb-font-heading);
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0.02em;
  color: var(--fb-text);
}

.ctx__nav {
  width: 32px;
  height: 32px;
  border: 1px solid var(--fb-border);
  border-radius: var(--fb-radius-md);
  background: var(--fb-nui-surface);
  color: var(--fb-text-grey);
  font-size: 1.25rem;
  line-height: 1;
  cursor: pointer;
  transition: var(--fb-transition);
}

.ctx__nav:hover {
  color: var(--fb-orange);
  border-color: var(--fb-orange-border);
  background: var(--fb-nui-surface);
}

.ctx__nav.is-active {
  color: var(--fb-orange);
  border-color: var(--fb-orange-glow);
}

.ctx__nav-icon {
  width: 14px;
  height: 14px;
}

.ctx__nav-spacer {
  width: 32px;
  height: 32px;
}

.ctx__list {
  list-style: none;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 0 4px 0 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.ctx__search {
  min-height: 38px;
  display: grid;
  grid-template-columns: auto minmax(0, 1fr) auto;
  align-items: center;
  gap: 9px;
  margin-bottom: 7px;
  padding: 0 11px;
  border: 1px solid var(--fb-orange-border);
  border-radius: var(--fb-radius-md);
  background: var(--fb-nui-surface);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

.ctx__search-icon {
  width: 14px;
  height: 14px;
  color: var(--fb-orange);
}

.ctx__search-input {
  width: 100%;
  min-width: 0;
  height: 36px;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--fb-text);
  font-size: 12px;
}

.ctx__search-input::placeholder {
  color: var(--fb-text-muted);
}

.ctx__search-clear {
  width: 24px;
  height: 24px;
  display: grid;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--fb-text-muted);
  cursor: pointer;
}

.ctx__search-clear:hover {
  color: var(--fb-orange);
}

.ctx__search-clear svg {
  width: 13px;
  height: 13px;
}

.ctx__item {
  position: relative;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  align-items: flex-start;
  width: 100%;
  min-height: 58px;
  height: auto;
  padding: 12px 13px;
  border-radius: var(--fb-radius-md);
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: var(--fb-nui-surface);
  cursor: pointer;
  transition: transform 0.16s ease, border-color 0.16s ease, background 0.16s ease;
}

.ctx__item:hover:not(.is-disabled):not(.is-readonly) {
  border-color: var(--fb-orange-glow);
  background: var(--fb-nui-surface);
  box-shadow: inset 3px 0 0 var(--fb-orange-strong);
  transform: translateY(-1px);
}

.ctx__item.has-icon {
  grid-template-columns: auto minmax(0, 1fr) auto;
}

.ctx__item.is-disabled {
  opacity: 0.42;
  cursor: not-allowed;
}

.ctx__item.is-readonly {
  cursor: default;
}

.ctx__icon {
  margin-top: 2px;
  width: 30px;
  height: 30px;
  display: grid;
  place-items: center;
  font-size: 1rem;
  line-height: 1;
  padding: 7px;
  border-radius: var(--fb-radius-md);
  background: var(--fb-orange-subtle);
  border: 1px solid var(--fb-orange-glow-light);
}

.ctx__empty {
  min-height: 54px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 9px;
  padding: 12px;
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: var(--fb-radius-md);
  background: var(--fb-nui-surface);
  color: var(--fb-text-muted);
  font-size: 12px;
}

.ctx__empty svg {
  width: 14px;
  height: 14px;
}

.ctx__icon.is-spin {
  animation: fb-spin 1s linear infinite;
}

.ctx__icon.is-pulse {
  animation: ctx-icon-pulse 0.9s ease-in-out infinite alternate;
}

@keyframes ctx-icon-pulse {
  to { transform: scale(1.14); }
}

.ctx__body {
  min-width: 0;
  width: 100%;
  max-width: 100%;
  align-self: stretch;
  overflow: hidden;
}

.ctx__row {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.ctx__item-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--fb-text);
}

.ctx__badge {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 2px 8px;
  border-radius: var(--fb-radius-sm);
  background: var(--fb-orange-subtle);
  color: var(--fb-orange);
  border: 1px solid var(--fb-orange-glow-light);
}

.ctx__desc {
  display: block;
  width: 100%;
  max-width: 100%;
  margin-top: 4px;
  font-size: 12px;
  color: var(--fb-text-grey);
  line-height: 1.4;
  white-space: normal;
  overflow-wrap: anywhere;
  word-break: break-word;
}

.ctx__tooltip {
  position: absolute;
  z-index: 30;
  width: 270px;
  max-height: 300px;
  padding: 10px;
  border-radius: var(--fb-radius-md);
  border: 1px solid var(--fb-orange-border);
  background: var(--fb-nui-surface);
  box-shadow:
    0 18px 48px rgba(0, 0, 0, 0.62),
    0 0 0 1px var(--fb-orange-subtle);
  opacity: 0;
  pointer-events: none;
  transform: translate(8px, -50%);
  transition: opacity 0.14s ease, transform 0.14s ease;
  opacity: 1;
  transform: translate(0, -50%);
}

.ctx__tooltip.is-left {
  transform: translate(-100%, -50%);
}

.ctx__tooltip.is-left .ctx__tooltip-arrow {
  left: auto;
  right: -6px;
  transform: translateY(-50%) rotate(225deg);
}

.ctx__tooltip-arrow {
  position: absolute;
  left: -6px;
  top: 50%;
  width: 10px;
  height: 10px;
  border-left: 1px solid var(--fb-orange-border);
  border-bottom: 1px solid var(--fb-orange-border);
  background: var(--fb-nui-surface);
  transform: translateY(-50%) rotate(45deg);
}

.ctx__meta {
  list-style: none;
  display: grid;
  gap: 8px;
  max-height: 280px;
  overflow-y: auto;
  overflow-x: hidden;
}

.ctx__meta-preview {
  display: block;
  width: 100%;
  max-height: 160px;
  margin-bottom: 9px;
  object-fit: contain;
  border-radius: var(--fb-radius-sm);
  border: 1px solid var(--fb-border);
  background: rgba(0, 0, 0, 0.18);
}

.ctx__meta-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-size: 11px;
}

.ctx__meta-image {
  width: 42px;
  height: 42px;
  flex: 0 0 42px;
  object-fit: cover;
  border-radius: var(--fb-radius-sm);
  border: 1px solid var(--fb-border);
}

.ctx__meta-content {
  min-width: 0;
  display: grid;
  gap: 2px;
}

.ctx__meta-label {
  color: var(--fb-text-muted);
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

.ctx__meta-value {
  color: var(--fb-text-grey);
  font-family: var(--fb-font-mono);
  overflow-wrap: anywhere;
}

.ctx__meta-progress {
  width: 100%;
  height: 3px;
  border-radius: 999px;
  background: var(--fb-bg-dark);
  overflow: hidden;
}

.ctx__meta-progress span {
  display: block;
  height: 100%;
}

.ctx__progress {
  margin-top: 8px;
  height: 4px;
  border-radius: 999px;
  background: var(--fb-bg-dark);
  border: 1px solid var(--fb-border);
  overflow: hidden;
}

.ctx__progress-bar {
  height: 100%;
  transition: width 0.35s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.ctx__aside {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  align-self: stretch;
  justify-content: center;
  gap: 4px;
  margin-top: 0;
}

.ctx__check {
  width: 18px;
  height: 18px;
  display: grid;
  place-items: center;
  border-radius: var(--fb-radius-sm);
  border: 1px solid var(--fb-border);
  font-size: 10px;
  color: transparent;
}

.ctx__check.is-on {
  color: var(--fb-text);
  background: var(--fb-orange);
  border-color: var(--fb-orange);
  box-shadow: 0 0 8px var(--fb-orange-glow);
}

.ctx__check svg {
  width: 12px;
  height: 12px;
}

.ctx__keybind {
  font-size: 10px;
  color: var(--fb-text-muted);
  background: var(--fb-bg-darkest);
  padding: 2px 6px;
  border-radius: var(--fb-radius-sm);
  border: 1px solid var(--fb-border);
  font-family: var(--fb-font-mono);
}

.ctx__arrow {
  width: 17px;
  height: 17px;
  color: var(--fb-orange);
  stroke: currentColor;
  stroke-width: 0.6px;
  paint-order: stroke fill;
}
</style>
