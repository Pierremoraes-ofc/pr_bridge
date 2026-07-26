<script setup lang="ts">
import { reactive, ref, watch } from 'vue'
import { fetchNui } from '../nui/bridge'
import BootstrapIcon from '../components/BootstrapIcon.vue'

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
      checked?: boolean
      min?: number | string
      max?: number | string
      step?: number | string
      precision?: number
      options?: Array<{ label?: string; value: unknown }>
      password?: boolean
      autosize?: boolean
      format?: string
      returnString?: boolean
      clearable?: boolean
      searchable?: boolean
      maxSelectedValues?: number
      minLength?: number
      maxLength?: number
    }>
    options?: {
      allowCancel?: boolean
      size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
    }
  }
}>()

const values = reactive<Record<number, unknown>>({})
const openSelect = ref<number | null>(null)
const selectSearch = reactive<Record<number, string>>({})

function pad(value: number) {
  return String(value).padStart(2, '0')
}

function dateInputValue(value: unknown): string {
  if (value === true) {
    const now = new Date()
    return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`
  }

  if (typeof value === 'number' || (typeof value === 'string' && /^\d{11,}$/.test(value))) {
    const date = new Date(Number(value))
    if (!Number.isNaN(date.getTime())) {
      return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`
    }
  }

  if (typeof value === 'string' && value) {
    const parsed = new Date(value)
    if (!Number.isNaN(parsed.getTime())) {
      return `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())}`
    }
  }

  return ''
}

function timeInputValue(value: unknown): string {
  if (typeof value === 'number' || (typeof value === 'string' && /^\d{11,}$/.test(value))) {
    const date = new Date(Number(value))
    if (!Number.isNaN(date.getTime())) return `${pad(date.getHours())}:${pad(date.getMinutes())}`
  }

  return typeof value === 'string' ? value : ''
}

function initialValue(row: (typeof props.data.rows)[number]): unknown {
  if (row.type === 'checkbox') return row.checked ?? row.default ?? false
  if (row.type === 'multi-select') return Array.isArray(row.default) ? [...row.default] : []
  if (row.type === 'slider') return Number(row.default ?? row.min ?? 0)
  if (row.type === 'color') return row.default ?? '#ff7a1a'
  if (row.type === 'date') return dateInputValue(row.default)
  if (row.type === 'date-range') {
    const range = Array.isArray(row.default) ? row.default : []
    return [dateInputValue(range[0]), dateInputValue(range[1])]
  }
  if (row.type === 'time') return timeInputValue(row.default)
  return row.default ?? ''
}

watch(
  () => props.data.rows,
  (rows) => {
    for (const key of Object.keys(values)) delete values[Number(key)]
    for (const row of rows || []) {
      values[row.index] = initialValue(row)
    }
  },
  { immediate: true },
)

function isEmpty(value: unknown): boolean {
  if (value === '' || value == null) return true
  if (Array.isArray(value)) return value.length === 0 || value.some((item) => item === '' || item == null)
  return false
}

function formatDate(value: string, format?: string): string {
  if (!value) return ''
  const [year, month, day] = value.split('-')
  return (format || 'DD/MM/YYYY')
    .replace(/YYYY/g, year)
    .replace(/MM/g, month)
    .replace(/DD/g, day)
}

function dateTimestamp(value: string): number | null {
  const timestamp = new Date(`${value}T00:00:00`).getTime()
  return Number.isNaN(timestamp) ? null : timestamp
}

function timeTimestamp(value: string): number | null {
  if (!value) return null
  const [hours, minutes] = value.split(':').map(Number)
  const date = new Date()
  date.setHours(hours, minutes, 0, 0)
  return date.getTime()
}

function outputValue(row: (typeof props.data.rows)[number]): unknown {
  const value = values[row.index]
  if (row.type === 'number' || row.type === 'slider') return value === '' ? null : Number(value)
  if (row.type === 'date') {
    const date = String(value || '')
    return row.returnString ? formatDate(date, row.format) : dateTimestamp(date)
  }
  if (row.type === 'date-range') {
    const range = Array.isArray(value) ? value.map(String) : ['', '']
    return row.returnString
      ? range.map((date) => formatDate(date, row.format))
      : range.map(dateTimestamp)
  }
  if (row.type === 'time') return timeTimestamp(String(value || ''))
  return value
}

function submit() {
  const ordered: unknown[] = []
  for (const row of props.data.rows || []) {
    if (row.required && isEmpty(values[row.index])) {
      return
    }
    ordered.push(outputValue(row))
  }
  fetchNui('input:submit', { values: ordered, __resource: props.data.__resource })
}

function close() {
  if (props.data.options?.allowCancel === false) return
  fetchNui('input:close', { __resource: props.data.__resource })
}

function updateDateRange(index: number, part: number, value: string) {
  const range = Array.isArray(values[index]) ? [...(values[index] as unknown[])] : ['', '']
  range[part] = value
  values[index] = range
}

function isMultiSelected(index: number, value: unknown): boolean {
  const selected = Array.isArray(values[index]) ? values[index] as unknown[] : []
  return selected.some((item) => String(item) === String(value))
}

function toggleMultiSelect(index: number, value: unknown, maxSelectedValues?: number) {
  const selected = Array.isArray(values[index]) ? [...values[index] as unknown[]] : []
  const currentIndex = selected.findIndex((item) => String(item) === String(value))
  if (currentIndex >= 0) {
    selected.splice(currentIndex, 1)
  } else if (!maxSelectedValues || selected.length < maxSelectedValues) {
    selected.push(value)
  }
  values[index] = selected
}

function safeColor(value: unknown): string {
  const color = String(value || '')
  return /^#[0-9a-f]{6}$/i.test(color) ? color : '#ff7a1a'
}

function numberStep(row: { step?: number | string; precision?: number }): number | string {
  if (row.step !== undefined && row.step !== null) return row.step

  if (typeof row.precision === 'number' && row.precision >= 0) {
    return 10 ** -Math.floor(row.precision)
  }

  return 'any'
}

function optionLabel(row: (typeof props.data.rows)[number], value: unknown): string {
  const option = (row.options || []).find((entry) => String(entry.value) === String(value))
  return option ? String(option.label ?? option.value) : ''
}

function filteredSelectOptions(row: (typeof props.data.rows)[number]) {
  const query = String(selectSearch[row.index] || '').trim().toLowerCase()
  if (!query) return row.options || []
  return (row.options || []).filter((option) => String(option.label ?? option.value).toLowerCase().includes(query))
}

function toggleSelect(row: (typeof props.data.rows)[number]) {
  if (row.disabled) return
  openSelect.value = openSelect.value === row.index ? null : row.index
  selectSearch[row.index] = ''
}

function chooseSelect(row: (typeof props.data.rows)[number], value: unknown) {
  values[row.index] = value
  openSelect.value = null
  selectSearch[row.index] = ''
}

function clearSelect(row: (typeof props.data.rows)[number], event: MouseEvent) {
  event.stopPropagation()
  values[row.index] = ''
}
</script>

<template>
  <div class="input-backdrop pr-interactive">
    <form
      class="input fb-panel"
      :class="data.options?.size ? `input--${data.options.size}` : undefined"
      @submit.prevent="submit"
    >
      <header class="input__header">
        <h2 class="input__heading">{{ data.heading }}</h2>
        <button
          v-if="data.options?.allowCancel !== false"
          type="button"
          class="input__close"
          aria-label="Fechar"
          @click="close"
        >
          <BootstrapIcon name="x-lg" />
        </button>
      </header>

      <div class="input__fields">
        <div v-for="row in data.rows" :key="row.index" class="input__field">
          <label v-if="row.label && row.type !== 'checkbox'" class="input__label">
            {{ row.label }}
            <span v-if="row.required" class="input__req">*</span>
          </label>
          <p v-if="row.description" class="input__desc">{{ row.description }}</p>

          <div v-if="row.type === 'select'" class="input__select" :class="{ 'is-open': openSelect === row.index }">
            <button
              type="button"
              class="fb-input input__select-trigger"
              :disabled="row.disabled"
              @click="toggleSelect(row)"
            >
              <span :class="{ 'is-placeholder': !optionLabel(row, values[row.index]) }">
                {{ optionLabel(row, values[row.index]) || row.placeholder || 'Selecione...' }}
              </span>
              <span class="input__select-actions">
                <BootstrapIcon
                  v-if="row.clearable && values[row.index] !== ''"
                  class="input__select-clear"
                  name="x-circle-fill"
                  @click="clearSelect(row, $event)"
                />
                <BootstrapIcon class="input__select-chevron" name="chevron-down" />
              </span>
            </button>
            <div v-if="openSelect === row.index" class="input__select-panel">
              <div v-if="row.searchable" class="input__select-search">
                <BootstrapIcon name="search" />
                <input v-model="selectSearch[row.index]" type="text" placeholder="Buscar..." autocomplete="off" />
              </div>
              <button
                v-for="(opt, i) in filteredSelectOptions(row)"
                :key="i"
                type="button"
                class="input__select-option"
                :class="{ 'is-selected': String(values[row.index]) === String(opt.value) }"
                @click="chooseSelect(row, opt.value)"
              >
                <span>{{ opt.label || opt.value }}</span>
                <BootstrapIcon v-if="String(values[row.index]) === String(opt.value)" name="check-lg" />
              </button>
              <div v-if="filteredSelectOptions(row).length === 0" class="input__select-empty">Nenhuma opcao.</div>
            </div>
          </div>

          <div
            v-else-if="row.type === 'multi-select'"
            class="input__multi"
            :class="{ 'is-disabled': row.disabled }"
          >
            <button
              v-for="(opt, i) in row.options || []"
              :key="i"
              type="button"
              class="input__multi-option"
              :class="{ 'is-selected': isMultiSelected(row.index, opt.value) }"
              :disabled="row.disabled"
              @click="toggleMultiSelect(row.index, opt.value, row.maxSelectedValues)"
            >
              <span class="input__multi-check"><BootstrapIcon v-if="isMultiSelected(row.index, opt.value)" name="check-lg" /></span>
              <span>{{ opt.label || opt.value }}</span>
            </button>
          </div>

          <label v-else-if="row.type === 'checkbox'" class="input__check">
            <input v-model="values[row.index]" type="checkbox" :disabled="row.disabled" />
            <span class="input__check-box" :class="{ 'is-on': values[row.index] }"><BootstrapIcon name="check-lg" /></span>
            <span>{{ row.placeholder || row.label }}</span>
          </label>

          <textarea
            v-else-if="row.type === 'textarea'"
            v-model="values[row.index] as string"
            class="fb-input fb-input--area"
            :placeholder="row.placeholder"
            :disabled="row.disabled"
            :minlength="row.minLength ?? (typeof row.min === 'number' ? row.min : undefined)"
            :maxlength="row.maxLength ?? (typeof row.max === 'number' ? row.max : undefined)"
            rows="3"
          />

          <div v-else-if="row.type === 'slider'" class="input__slider">
            <input
              v-model.number="values[row.index]"
              type="range"
              :disabled="row.disabled"
              :min="row.min ?? 0"
              :max="row.max ?? 100"
              :step="numberStep(row)"
            />
            <output>{{ values[row.index] }}</output>
          </div>

          <div v-else-if="row.type === 'color'" class="input__color">
            <input
              type="color"
              :value="safeColor(values[row.index])"
              :disabled="row.disabled"
              @input="values[row.index] = ($event.target as HTMLInputElement).value"
            />
            <input v-model="values[row.index] as string" class="fb-input" type="text" :disabled="row.disabled" />
          </div>

          <input
            v-else-if="row.type === 'date'"
            v-model="values[row.index] as string"
            class="fb-input"
            type="date"
            :disabled="row.disabled"
            :min="row.min"
            :max="row.max"
          />

          <div v-else-if="row.type === 'date-range'" class="input__date-range">
            <input
              class="fb-input"
              type="date"
              :value="(values[row.index] as string[])?.[0]"
              :disabled="row.disabled"
              :min="row.min"
              :max="row.max"
              @input="updateDateRange(row.index, 0, ($event.target as HTMLInputElement).value)"
            />
            <input
              class="fb-input"
              type="date"
              :value="(values[row.index] as string[])?.[1]"
              :disabled="row.disabled"
              :min="row.min"
              :max="row.max"
              @input="updateDateRange(row.index, 1, ($event.target as HTMLInputElement).value)"
            />
          </div>

          <input
            v-else-if="row.type === 'time'"
            v-model="values[row.index] as string"
            class="fb-input"
            type="time"
            :disabled="row.disabled"
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
            :step="row.type === 'number' ? numberStep(row) : undefined"
            :minlength="row.minLength"
            :maxlength="row.maxLength"
          />
        </div>
      </div>

      <div class="input__actions">
        <button
          v-if="data.options?.allowCancel !== false"
          type="button"
          class="fb-btn fb-btn-secondary"
          @click="close"
        >
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
  background: transparent;
  backdrop-filter: none;
  -webkit-backdrop-filter: none;
  animation: fb-fade-in 0.2s ease;
}

.input {
  width: min(460px, 92vw);
  max-height: min(80vh, 720px);
  display: flex;
  flex-direction: column;
  background: var(--fb-nui-surface);
  animation: fb-pop-in 0.24s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.input--xs { width: min(340px, 92vw); }
.input--sm { width: min(400px, 92vw); }
.input--md { width: min(520px, 92vw); }
.input--lg { width: min(640px, 92vw); }
.input--xl { width: min(760px, 92vw); }

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
  border-color: var(--fb-orange-glow);
}

.input__fields {
  overflow-y: auto;
  padding: 16px 18px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.input__fields input,
.input__fields textarea {
  user-select: text;
  -webkit-user-select: text;
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
  background: var(--fb-nui-field);
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

.input__multi {
  display: grid;
  gap: 6px;
  padding: 6px;
  border: 1px solid var(--fb-border);
  border-radius: 7px;
  background: var(--fb-nui-field);
}

.input__multi-option {
  min-height: 34px;
  display: flex;
  align-items: center;
  gap: 9px;
  padding: 6px 8px;
  border: 1px solid transparent;
  border-radius: 5px;
  background: transparent;
  color: var(--fb-text-grey);
  text-align: left;
  cursor: pointer;
}

.input__multi-option:hover,
.input__multi-option.is-selected {
  border-color: var(--fb-orange-glow);
  background: var(--fb-orange-subtle);
  color: var(--fb-text);
}

.input__multi-check {
  width: 18px;
  height: 18px;
  display: grid;
  place-items: center;
  border: 1px solid var(--fb-border-hover);
  border-radius: 4px;
  color: var(--fb-text);
  font-size: 11px;
}

.input__multi-option.is-selected .input__multi-check {
  border-color: var(--fb-orange);
  background: var(--fb-orange);
}

.input__multi.is-disabled {
  opacity: 0.55;
}

.input__slider,
.input__color,
.input__date-range {
  display: grid;
  align-items: center;
  gap: 10px;
}

.input__slider {
  grid-template-columns: minmax(0, 1fr) 54px;
}

.input__slider input {
  accent-color: var(--fb-orange);
}

.input__slider output {
  text-align: center;
  color: var(--fb-orange);
  font-family: var(--fb-font-mono);
  font-size: 12px;
}

.input__color {
  grid-template-columns: 44px minmax(0, 1fr);
}

.input__color input[type='color'] {
  width: 44px;
  height: 38px;
  padding: 3px;
  border-radius: 7px;
  border: 1px solid var(--fb-border);
  background: var(--fb-nui-field);
}

.input__date-range {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.input__close svg,
.input__multi-check svg,
.input__check-box svg {
  width: 13px;
  height: 13px;
}

.input__select {
  position: relative;
}

.input__select-trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  text-align: left;
  cursor: pointer;
}

.input__select.is-open .input__select-trigger {
  border-color: var(--fb-orange);
  box-shadow: 0 0 10px var(--fb-orange-glow-light);
}

.input__select-trigger .is-placeholder {
  color: var(--fb-text-muted);
}

.input__select-actions {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: var(--fb-text);
}

.input__select-clear,
.input__select-chevron {
  width: 14px;
  height: 14px;
  color: var(--fb-text);
  transition: transform 0.15s ease;
}

.input__select.is-open .input__select-chevron {
  transform: rotate(180deg);
}

.input__select-panel {
  margin-top: 5px;
  max-height: 220px;
  overflow-y: auto;
  padding: 5px;
  border: 1px solid var(--fb-border-hover);
  border-radius: 7px;
  background: var(--fb-nui-surface);
  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.48);
}

.input__select-search {
  display: grid;
  grid-template-columns: 16px minmax(0, 1fr);
  align-items: center;
  gap: 7px;
  margin-bottom: 5px;
  padding: 7px 9px;
  border: 1px solid var(--fb-border);
  border-radius: 6px;
  color: var(--fb-text-grey);
}

.input__select-search svg {
  width: 14px;
  height: 14px;
}

.input__select-search input {
  min-width: 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--fb-text);
}

.input__select-option {
  width: 100%;
  min-height: 34px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  padding: 7px 9px;
  border: 1px solid transparent;
  border-radius: 5px;
  background: transparent;
  color: var(--fb-text-grey);
  text-align: left;
  cursor: pointer;
}

.input__select-option:hover,
.input__select-option.is-selected {
  border-color: var(--fb-orange-glow-light);
  background: var(--fb-orange-subtle);
  color: var(--fb-text);
}

.input__select-option svg {
  width: 14px;
  height: 14px;
  color: var(--fb-orange);
}

.input__select-empty {
  padding: 12px 9px;
  color: var(--fb-text-muted);
  font-size: 12px;
  text-align: center;
}
</style>
