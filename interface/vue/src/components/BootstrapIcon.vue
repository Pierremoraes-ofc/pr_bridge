<script setup lang="ts">
import bootstrapIconsSprite from 'bootstrap-icons/bootstrap-icons.svg?url'

defineProps<{
  name: string
}>()
</script>

<template>
  <svg viewBox="0 0 16 16" fill="currentColor" focusable="false" aria-hidden="true">
    <use :href="`${bootstrapIconsSprite}#${name}`" />
  </svg>
</template>
