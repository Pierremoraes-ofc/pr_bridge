// Shared by the Svelte and Vue renderers; no change to Interact controls.
export function createListMenu(data, emit) {
  const options = data.options || []
  let selected = Math.max(1, Math.min(options.length, Number(data.startIndex) || 1))
  const indices = options.map(o => Math.max(1, Math.min(o.values?.length || 1, Number(o.defaultIndex) || 1)))
  const checked = options.map(o => o.checked === true)
  const payload = () => ({ id: data.id, __resource: data.__resource, selected,
    scrollIndex: options[selected - 1]?.values ? indices[selected - 1] : undefined,
    checked: options[selected - 1]?.checked !== undefined ? checked[selected - 1] : undefined })
  const notify = action => emit(action, payload())
  return {
    snapshot: () => ({ selected, indices: [...indices], checked: [...checked] }),
    select(index) { if (index !== selected) { selected = index; notify('selected') } },
    announce() { notify('selected') },
    key(key) {
      if (!options.length) return false
      const option = options[selected - 1]
      if (key === 'ArrowUp' || key === 'ArrowDown') {
        selected = ((selected - 1 + (key === 'ArrowDown' ? 1 : -1) + options.length) % options.length) + 1
        notify('selected')
      } else if (key === 'ArrowLeft' || key === 'ArrowRight') {
        if (!option.values?.length || option.disabled || option.readOnly) return true
        indices[selected - 1] = ((indices[selected - 1] - 1 + (key === 'ArrowRight' ? 1 : -1) + option.values.length) % option.values.length) + 1
        notify('side')
      } else if (key === 'Enter') {
        if (option.disabled || option.readOnly) return true
        if (option.checked !== undefined && !option.values) {
          checked[selected - 1] = !checked[selected - 1]
          notify('check')
        } else notify('confirm')
      } else if (key === 'Escape' || key === 'Backspace') {
        if (data.canClose !== false) emit('close', { ...payload(), key })
      } else return false
      return true
    },
  }
}
