<script setup lang="ts">
import { computed } from 'vue'
import { iconName } from '../lib/forgebox'
import BootstrapIcon from '../components/BootstrapIcon.vue'

const props = defineProps<{
  data: {
    text: string
    position?: string
    icon?: string
  }
}>()

const parsed = computed(() => parseKey(props.data.text))

function positionClass(position?: string) {
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
}

function parseKey(text: string): { key?: string; message: string } {
  const match = text.match(/^\[([^\]]+)\]\s*(.*)$/)
  if (!match) return { message: text }
  return { key: match[1], message: match[2] || text }
}
</script>

<template>
  <div class="textui" :class="positionClass(data.position)">
    <BootstrapIcon v-if="data.icon" class="textui__icon" :name="iconName(data.icon)" />
    <span v-if="parsed.key" class="textui__key">{{ parsed.key }}</span>
    <span class="textui__text">{{ parsed.message || data.text }}</span>
  </div>
</template>

<style scoped>
.textui {
  position: absolute;
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 12px 18px;
  border-radius: var(--fb-radius-md);
  background: var(--fb-nui-surface);
  border: 1px solid var(--fb-border);
  border-left: 4px solid var(--fb-orange);
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.5),
    0 0 12px var(--fb-orange-glow-light);
  font-size: 13px;
  font-weight: 500;
  max-width: 320px;
  animation: fb-pop-in 0.2s ease;
}

.textui.is-right {
  top: 50%;
  right: 3%;
  transform: translateY(-50%);
}

.textui.is-left {
  top: 50%;
  left: 3%;
  transform: translateY(-50%);
}

.textui.is-top {
  top: 8%;
  left: 50%;
  transform: translateX(-50%);
}

.textui.is-bottom {
  bottom: 8%;
  left: 50%;
  transform: translateX(-50%);
}

.textui__icon {
  width: 18px;
  height: 18px;
  flex: 0 0 18px;
  color: var(--fb-orange);
}

.textui__key {
  background-color: var(--fb-orange);
  color: var(--fb-text);
  font-weight: 700;
  padding: 4px 8px;
  border-radius: var(--fb-radius-sm);
  font-size: 12px;
  box-shadow: 0 0 8px var(--fb-orange-glow);
  font-family: var(--fb-font-heading);
}

.textui__text {
  white-space: pre-wrap;
  color: var(--fb-text);
  line-height: 1.35;
}
</style>
