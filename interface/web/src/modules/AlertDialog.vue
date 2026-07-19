<script setup lang="ts">
import { fetchNui } from '../nui/bridge'

defineProps<{
  data: {
    header: string
    content: string
    centered?: boolean
    cancel?: boolean
    labels?: { cancel?: string; confirm?: string }
  }
}>()

function confirm() {
  fetchNui('alert:result', { result: 'confirm' })
}

function cancel() {
  fetchNui('alert:result', { result: 'cancel' })
}
</script>

<template>
  <div
    class="alert-backdrop pr-interactive"
    :class="{ 'is-centered': data.centered !== false }"
    @click.self="cancel"
  >
    <div class="alert fb-panel">
      <div class="alert__icon">⚠</div>
      <h2 class="alert__header">{{ data.header }}</h2>
      <p class="alert__content">{{ data.content }}</p>
      <div class="alert__actions">
        <button
          v-if="data.cancel !== false"
          type="button"
          class="fb-btn fb-btn-ghost"
          @click="cancel"
        >
          {{ data.labels?.cancel || 'Cancelar' }}
        </button>
        <button type="button" class="fb-btn fb-btn-primary" @click="confirm">
          {{ data.labels?.confirm || 'Confirmar' }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.alert-backdrop {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 18px;
  background: rgba(0, 0, 0, 0.68);
  backdrop-filter: blur(8px);
  animation: fb-fade-in 0.2s ease;
}

.alert {
  width: min(420px, 92vw);
  padding: 28px 24px 22px;
  text-align: center;
  animation: fb-pop-in 0.24s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.alert__icon {
  width: 52px;
  height: 52px;
  margin: 0 auto 14px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  font-size: 22px;
  color: var(--fb-orange);
  background: rgba(255, 122, 26, 0.12);
  border: 1px solid rgba(255, 122, 26, 0.3);
}

.alert__header {
  font-family: var(--fb-font-heading);
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 10px;
}

.alert__content {
  font-size: 14px;
  line-height: 1.5;
  color: var(--fb-text-grey);
  white-space: pre-wrap;
}

.alert__actions {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 22px;
}
</style>
