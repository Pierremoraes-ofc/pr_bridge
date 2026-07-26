<script lang="ts">
  import bootstrapIconsSprite from 'bootstrap-icons/bootstrap-icons.svg?url'

  export let name: string
</script>

<svg viewBox="0 0 16 16" fill="currentColor" focusable="false" aria-hidden="true">
  <use href={`${bootstrapIconsSprite}#${name}`} />
</svg>

<style>
  svg {
    display: block;
    width: 1em;
    height: 1em;
    flex: 0 0 1em;
  }
</style>
