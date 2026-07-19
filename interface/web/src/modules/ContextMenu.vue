<script setup lang="ts">
import { fetchNui } from '../nui/bridge'
import { alphaColor, iconLabel, metaItems } from '../lib/forgebox'

defineProps<{
  data: {
    id: string
    title: string
    canClose?: boolean
    hasParent?: boolean
    options: Array<{
      index: number
      title: string
      description?: string
      icon?: string | Record<string, unknown>
      iconColor?: string
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

const accent = '#ff7a1a'

function onSelect(option: any, id: string) {
  if (option.disabled || option.readOnly) return
  fetchNui('context:select', { id, index: option.index })
}

function onClose() {
  fetchNui('context:close')
}

function onBack() {
  fetchNui('context:back')
}

function optionColor(option: any): string {
  const map: Record<string, string> = {
    orange: '#ff7a1a',
    blue: '#3b82f6',
    green: '#10b981',
    yellow: '#f59e0b',
    red: '#ef4444',
    purple: '#8b5cf6',
  }
  return map[option.colorScheme] || accent
}
</script>

<template>
  <div class="ctx pr-interactive">
    <header class="ctx__header">
      <button
        v-if="data.hasParent"
        class="ctx__nav"
        type="button"
        aria-label="Voltar"
        @click="onBack"
      >
        ‹
      </button>
      <span v-else class="ctx__nav-spacer" />

      <div class="ctx__heading">
        <h2 class="ctx__title">{{ data.title }}</h2>
      </div>

      <button
        v-if="data.canClose !== false"
        class="ctx__nav ctx__nav--close"
        type="button"
        aria-label="Fechar"
        @click="onClose"
      >
        ×
      </button>
      <span v-else class="ctx__nav-spacer" />
    </header>

    <ul class="ctx__list">
      <li
        v-for="option in data.options"
        :key="option.index"
        class="ctx__item"
        :class="{
          'is-disabled': option.disabled,
          'is-readonly': option.readOnly,
        }"
        @click="onSelect(option, data.id)"
      >
        <div
          v-if="option.icon"
          class="ctx__icon"
          :style="{ color: option.iconColor || optionColor(option) }"
        >
          {{ iconLabel(option.icon) }}
        </div>

        <div class="ctx__body">
          <div class="ctx__row">
            <span class="ctx__item-title">{{ option.title }}</span>
            <span v-if="option.badge" class="ctx__badge">{{ option.badge }}</span>
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
                width: `${Math.max(0, Math.min(100, option.progress))}%`,
                backgroundColor: optionColor(option),
                boxShadow: `0 0 8px ${alphaColor(optionColor(option), 0.45)}`,
              }"
            />
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
</template>

<style scoped>
.ctx {
  position: absolute;
  top: 50%;
  right: 4%;
  transform: translateY(-50%);
  width: min(380px, 92vw);
  max-height: min(72vh, 680px);
  display: flex;
  flex-direction: column;
  border-radius: 10px;
  border: 1px solid rgba(255, 122, 26, 0.16);
  background: linear-gradient(180deg, rgba(13, 13, 17, 0.92), rgba(8, 8, 10, 0.95));
  backdrop-filter: blur(18px);
  box-shadow:
    0 28px 80px rgba(0, 0, 0, 0.72),
    0 0 0 1px rgba(255, 122, 26, 0.08),
    inset 0 1px 0 rgba(255, 255, 255, 0.06);
  overflow: hidden;
  animation: fb-slide-in-left 0.28s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.ctx__header {
  display: grid;
  grid-template-columns: 36px 1fr 36px;
  align-items: center;
  gap: 8px;
  padding: 14px 12px 12px;
  border-bottom: 1px solid var(--fb-border);
}

.ctx__heading {
  min-width: 0;
  text-align: center;
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
  background: rgba(255, 255, 255, 0.02);
  color: var(--fb-text-grey);
  font-size: 1.25rem;
  line-height: 1;
  cursor: pointer;
  transition: var(--fb-transition);
}

.ctx__nav:hover {
  color: var(--fb-orange);
  border-color: rgba(255, 122, 26, 0.35);
  background: var(--fb-orange-subtle);
}

.ctx__nav-spacer {
  width: 32px;
  height: 32px;
}

.ctx__list {
  list-style: none;
  overflow-y: auto;
  padding: 8px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.ctx__item {
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 12px;
  align-items: center;
  min-height: 58px;
  padding: 12px 13px;
  border-radius: var(--fb-radius-md);
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(255, 255, 255, 0.025);
  cursor: pointer;
  transition: transform 0.16s ease, border-color 0.16s ease, background 0.16s ease;
}

.ctx__item:hover:not(.is-disabled):not(.is-readonly) {
  border-color: rgba(255, 122, 26, 0.42);
  background: rgba(255, 122, 26, 0.09);
  transform: translateY(-1px);
}

.ctx__item.is-disabled {
  opacity: 0.42;
  cursor: not-allowed;
}

.ctx__item.is-readonly {
  cursor: default;
}

.ctx__icon {
  width: 30px;
  height: 30px;
  display: grid;
  place-items: center;
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  border-radius: var(--fb-radius-md);
  background: rgba(255, 122, 26, 0.08);
  border: 1px solid rgba(255, 122, 26, 0.15);
}

.ctx__body {
  min-width: 0;
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
  background: rgba(255, 122, 26, 0.1);
  color: var(--fb-orange);
  border: 1px solid rgba(255, 122, 26, 0.2);
}

.ctx__desc {
  margin-top: 4px;
  font-size: 12px;
  color: var(--fb-text-grey);
  line-height: 1.4;
}

.ctx__meta {
  margin-top: 8px;
  list-style: none;
  display: grid;
  gap: 4px;
}

.ctx__meta li {
  display: flex;
  gap: 6px;
  font-size: 11px;
}

.ctx__meta-label {
  color: var(--fb-text-muted);
}

.ctx__meta-value {
  color: var(--fb-text-grey);
  font-family: var(--fb-font-mono);
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
  gap: 4px;
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
  color: var(--fb-text-muted);
  font-size: 1.1rem;
}

.ctx__image {
  grid-column: 1 / -1;
  width: 100%;
  max-height: 120px;
  object-fit: cover;
  border-radius: var(--fb-radius-md);
  margin-top: 4px;
}
</style>
