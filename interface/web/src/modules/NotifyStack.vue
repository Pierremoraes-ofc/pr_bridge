<script setup lang="ts">
import { onBeforeUnmount, ref, watch } from 'vue'
import { notifyTone } from '../lib/forgebox'

const props = defineProps<{
  items: Array<{
    id: string | number
    title?: string
    description?: string
    type?: string
    duration?: number
  }>
}>()

const emit = defineEmits<{
  remove: [id: string | number]
}>()

const timers = new Map<string | number, number>()
const progress = ref<Record<string | number, number>>({})

watch(
  () => props.items,
  (items) => {
    for (const item of items) {
      if (timers.has(item.id)) continue
      const duration = item.duration ?? 5000
      progress.value[item.id] = 100
      const started = Date.now()

      const handle = window.setInterval(() => {
        const elapsed = Date.now() - started
        const pct = Math.max(0, 100 - (elapsed / duration) * 100)
        progress.value[item.id] = pct
        if (pct <= 0) {
          window.clearInterval(handle)
          timers.delete(item.id)
          emit('remove', item.id)
        }
      }, 50)

      timers.set(item.id, handle)
    }
  },
  { deep: true },
)

onBeforeUnmount(() => {
  for (const handle of timers.values()) window.clearInterval(handle)
  timers.clear()
})

function tone(type?: string) {
  return notifyTone(type)
}
</script>

<template>
  <div class="notify-stack">
    <TransitionGroup name="notify">
      <div
        v-for="item in items"
        :key="item.id"
        class="notify"
        :style="{
          borderLeftColor: tone(item.type).border,
          boxShadow: `0 8px 30px rgba(0,0,0,0.5), 0 0 20px ${tone(item.type).glow}`,
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
            width: `${progress[item.id] ?? 100}%`,
            backgroundColor: tone(item.type).border,
          }"
        />
      </div>
    </TransitionGroup>
  </div>
</template>

<style scoped>
.notify-stack {
  position: absolute;
  top: 16px;
  right: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: min(320px, 90vw);
  pointer-events: none;
  z-index: 9999;
}

.notify {
  position: relative;
  overflow: hidden;
  padding: 16px;
  padding-left: 14px;
  border-radius: var(--fb-radius-md);
  border: 1px solid var(--fb-border);
  border-left-width: 4px;
  background: var(--fb-bg-darker);
  display: flex;
  gap: 12px;
  animation: fb-slide-in-right 0.3s cubic-bezier(0.1, 0.8, 0.25, 1);
}

.notify__icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
  display: grid;
  place-items: center;
  font-size: 14px;
  font-weight: 700;
}

.notify__content {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.notify__title {
  display: block;
  font-family: var(--fb-font-heading);
  font-size: 14px;
  font-weight: 600;
}

.notify__desc {
  font-size: 12px;
  color: var(--fb-text-grey);
  line-height: 1.4;
}

.notify__progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  transition: width 0.05s linear;
}

.notify-enter-active,
.notify-leave-active {
  transition: all 0.28s ease;
}

.notify-enter-from,
.notify-leave-to {
  opacity: 0;
  transform: translateX(12px);
}
</style>
