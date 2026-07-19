<script setup lang="ts">
import { reactive, watch } from 'vue'
import { fetchNui } from '../nui/bridge'

const props = defineProps<{
  data: {
    __resource?: string
    heading: string
    rows: Array<{
      index: number
      type?: string
      label?: string
      description?: string
      placeholder?: string
      default?: unknown
      required?: boolean
      disabled?: boolean
      min?: number
      max?: number
      step?: number
      options?: Array<{ label: string; value: unknown }>
      password?: boolean
    }>
  }
}>()

const values = reactive<Record<number, unknown>>({})

watch(
  () => props.data.rows,
  (rows) => {
    for (const key of Object.keys(values)) delete values[Number(key)]
    for (const row of rows || []) {
      values[row.index] = row.default ?? (row.type === 'checkbox' ? false : '')
    }
  },
  { immediate: true },
)

function submit() {
  const ordered: unknown[] = []
  for (const row of props.data.rows || []) {
    if (row.required && (values[row.index] === '' || values[row.index] == null)) {
      return
    }
    ordered.push(values[row.index])
  }
  fetchNui('input:submit', { values: ordered, __resource: props.data.__resource })
}

function close() {
  fetchNui('input:close', { __resource: props.data.__resource })
}
</script>

<template>
  <div class="input-backdrop pr-interactive" @click.self="close">
    <form class="input fb-panel" @submit.prevent="submit">
      <header class="input__header">
        <h2 class="input__heading">{{ data.heading }}</h2>
        <button type="button" class="input__close" aria-label="Fechar" @click="close">×</button>
      </header>

      <div class="input__fields">
        <div v-for="row in data.rows" :key="row.index" class="input__field">
          <label v-if="row.label && row.type !== 'checkbox'" class="input__label">
            {{ row.label }}
            <span v-if="row.required" class="input__req">*</span>
          </label>
          <p v-if="row.description" class="input__desc">{{ row.description }}</p>

          <select
            v-if="row.type === 'select'"
            v-model="values[row.index]"
            class="fb-input"
            :disabled="row.disabled"
          >
            <option
              v-for="(opt, i) in row.options || []"
              :key="i"
              :value="opt.value"
            >
              {{ opt.label }}
            </option>
          </select>

          <label v-else-if="row.type === 'checkbox'" class="input__check">
            <input v-model="values[row.index]" type="checkbox" :disabled="row.disabled" />
            <span class="input__check-box" :class="{ 'is-on': values[row.index] }">✓</span>
            <span>{{ row.placeholder || row.label }}</span>
          </label>

          <textarea
            v-else-if="row.type === 'textarea'"
            v-model="values[row.index] as string"
            class="fb-input fb-input--area"
            :placeholder="row.placeholder"
            :disabled="row.disabled"
            rows="3"
          />

          <input
            v-else
            v-model="values[row.index]"
            class="fb-input"
            :type="row.password ? 'password' : row.type === 'number' ? 'number' : 'text'"
            :placeholder="row.placeholder"
            :disabled="row.disabled"
            :min="row.min"
            :max="row.max"
            :step="row.step"
          />
        </div>
      </div>

      <div class="input__actions">
        <button type="button" class="fb-btn fb-btn-secondary" @click="close">
          Cancelar
        </button>
        <button type="submit" class="fb-btn fb-btn-primary">Confirmar</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.input-backdrop {
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

.input {
  width: min(460px, 92vw);
  max-height: min(80vh, 720px);
  display: flex;
  flex-direction: column;
  animation: fb-pop-in 0.24s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.input__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 16px 18px 12px;
  border-bottom: 1px solid var(--fb-border);
}

.input__heading {
  font-family: var(--fb-font-heading);
  font-size: 16px;
  font-weight: 600;
}

.input__close {
  width: 30px;
  height: 30px;
  border: 1px solid var(--fb-border);
  border-radius: var(--fb-radius-md);
  background: transparent;
  color: var(--fb-text-muted);
  cursor: pointer;
  transition: var(--fb-transition);
}

.input__close:hover {
  color: var(--fb-orange);
  border-color: rgba(255, 122, 26, 0.35);
}

.input__fields {
  overflow-y: auto;
  padding: 16px 18px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.input__label {
  display: block;
  font-size: 13px;
  font-weight: 500;
  color: var(--fb-text-grey);
  margin-bottom: 6px;
}

.input__req {
  color: var(--fb-error);
}

.input__desc {
  font-size: 12px;
  color: var(--fb-text-muted);
  margin-bottom: 6px;
}

.input__check {
  display: flex;
  align-items: center;
  gap: 10px;
  min-height: 38px;
  padding: 8px 10px;
  border-radius: 7px;
  border: 1px solid var(--fb-border);
  background: rgba(5, 5, 7, 0.58);
  font-size: 13px;
  cursor: pointer;
}

.input__check input {
  display: none;
}

.input__check-box {
  width: 20px;
  height: 20px;
  display: grid;
  place-items: center;
  border: 2px solid var(--fb-border);
  border-radius: var(--fb-radius-sm);
  font-size: 11px;
  color: transparent;
  transition: var(--fb-transition);
}

.input__check-box.is-on {
  background: var(--fb-orange);
  border-color: var(--fb-orange);
  color: var(--fb-text);
  box-shadow: 0 0 8px var(--fb-orange-glow);
}

.input__actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 14px 18px 18px;
  border-top: 1px solid var(--fb-border);
}
</style>
