<script lang="ts">
  import { fetchNui } from '../nui/bridge'
  import BootstrapIcon from '../components/BootstrapIcon.svelte'

  export let data: any

  let values: Record<number, any> = {}
  let openSelect: number | null = null
  let selectSearch: Record<number, string> = {}

  $: if (data?.rows) {
    const next: Record<number, any> = {}
    for (const row of data.rows) next[row.index] = values[row.index] ?? initialValue(row)
    values = next
  }

  const pad = (value: number) => String(value).padStart(2, '0')

  function dateInputValue(value: unknown): string {
    if (value === true) {
      const now = new Date()
      return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`
    }
    if (typeof value === 'number' || (typeof value === 'string' && /^\d{11,}$/.test(value))) {
      const date = new Date(Number(value))
      if (!Number.isNaN(date.getTime())) return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`
    }
    if (typeof value === 'string' && value) {
      const parsed = new Date(value)
      if (!Number.isNaN(parsed.getTime())) return `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())}`
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

  function initialValue(row: any): unknown {
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

  const updateValue = (index: number, value: any) => (values = { ...values, [index]: value })
  const isEmpty = (value: unknown) => value === '' || value == null || (Array.isArray(value) && (value.length === 0 || value.some((item) => item === '' || item == null)))

  function formatDate(value: string, format?: string): string {
    if (!value) return ''
    const [year, month, day] = value.split('-')
    return (format || 'DD/MM/YYYY').replace(/YYYY/g, year).replace(/MM/g, month).replace(/DD/g, day)
  }

  const dateTimestamp = (value: string) => {
    const timestamp = new Date(`${value}T00:00:00`).getTime()
    return Number.isNaN(timestamp) ? null : timestamp
  }

  const timeTimestamp = (value: string) => {
    if (!value) return null
    const [hours, minutes] = value.split(':').map(Number)
    const date = new Date()
    date.setHours(hours, minutes, 0, 0)
    return date.getTime()
  }

  function outputValue(row: any): unknown {
    const value = values[row.index]
    if (row.type === 'number' || row.type === 'slider') return value === '' ? null : Number(value)
    if (row.type === 'date') return row.returnString ? formatDate(String(value || ''), row.format) : dateTimestamp(String(value || ''))
    if (row.type === 'date-range') {
      const range = Array.isArray(value) ? value.map(String) : ['', '']
      return row.returnString ? range.map((date) => formatDate(date, row.format)) : range.map(dateTimestamp)
    }
    if (row.type === 'time') return timeTimestamp(String(value || ''))
    return value
  }

  function submit() {
    const ordered: unknown[] = []
    for (const row of data.rows || []) {
      if (row.required && isEmpty(values[row.index])) return
      ordered.push(outputValue(row))
    }
    fetchNui('input:submit', { values: ordered, __resource: data.__resource })
  }

  function close() {
    if (data.options?.allowCancel === false) return
    fetchNui('input:close', { __resource: data.__resource })
  }

  function toggleMultiSelect(index: number, value: unknown, maxSelectedValues?: number) {
    const selected = Array.isArray(values[index]) ? [...values[index]] : []
    const currentIndex = selected.findIndex((item) => String(item) === String(value))
    if (currentIndex >= 0) selected.splice(currentIndex, 1)
    else if (!maxSelectedValues || selected.length < maxSelectedValues) selected.push(value)
    updateValue(index, selected)
  }

  const isMultiSelected = (index: number, value: unknown) => (Array.isArray(values[index]) ? values[index] : []).some((item: unknown) => String(item) === String(value))
  const safeColor = (value: unknown) => /^#[0-9a-f]{6}$/i.test(String(value || '')) ? String(value) : '#ff7a1a'
  const numberStep = (row: any) => row.step ?? (typeof row.precision === 'number' && row.precision >= 0 ? 10 ** -Math.floor(row.precision) : 'any')
  const optionLabel = (row: any, value: unknown) => String((row.options || []).find((entry: any) => String(entry.value) === String(value))?.label ?? (row.options || []).find((entry: any) => String(entry.value) === String(value))?.value ?? '')
  const filteredSelectOptions = (row: any) => {
    const query = String(selectSearch[row.index] || '').trim().toLowerCase()
    return query ? (row.options || []).filter((option: any) => String(option.label ?? option.value).toLowerCase().includes(query)) : row.options || []
  }
</script>

<div class="input-backdrop pr-interactive">
  <form class={`input fb-panel ${data.options?.size ? `input--${data.options.size}` : ''}`} on:submit|preventDefault={submit}>
    <header class="input__header">
      <h2 class="input__heading">{data.heading || data.title}</h2>
      {#if data.options?.allowCancel !== false}
        <button type="button" class="input__close" aria-label="Fechar" on:click={close}><BootstrapIcon name="x-lg" /></button>
      {/if}
    </header>

    <div class="input__fields">
      {#each data.rows || [] as row (row.index)}
        <div class="input__field">
          {#if row.label && row.type !== 'checkbox'}<label class="input__label">{row.label}{#if row.required}<span class="input__req">*</span>{/if}</label>{/if}
          {#if row.description}<p class="input__desc">{row.description}</p>{/if}

          {#if row.type === 'select'}
            <div class:is-open={openSelect === row.index} class="input__select">
              <button type="button" class="fb-input input__select-trigger" disabled={row.disabled} on:click={() => { openSelect = openSelect === row.index ? null : row.index; selectSearch[row.index] = '' }}>
                <span class:is-placeholder={!optionLabel(row, values[row.index])}>{optionLabel(row, values[row.index]) || row.placeholder || 'Selecione...'}</span>
                <span class="input__select-actions"><BootstrapIcon name="chevron-down" /></span>
              </button>
              {#if openSelect === row.index}
                <div class="input__select-panel">
                  {#if row.searchable}
                    <div class="input__select-search"><BootstrapIcon name="search" /><input value={selectSearch[row.index] || ''} on:input={(e) => (selectSearch = { ...selectSearch, [row.index]: (e.target as HTMLInputElement).value })} type="text" placeholder="Buscar..." autocomplete="off" /></div>
                  {/if}
                  {#each filteredSelectOptions(row) as opt}
                    <button type="button" class:is-selected={String(values[row.index]) === String(opt.value)} class="input__select-option" on:click={() => { updateValue(row.index, opt.value); openSelect = null }}>
                      <span>{opt.label || opt.value}</span>{#if String(values[row.index]) === String(opt.value)}<BootstrapIcon name="check-lg" />{/if}
                    </button>
                  {/each}
                </div>
              {/if}
            </div>
          {:else if row.type === 'multi-select'}
            <div class:is-disabled={row.disabled} class="input__multi">
              {#each row.options || [] as opt}
                <button type="button" class:is-selected={isMultiSelected(row.index, opt.value)} class="input__multi-option" disabled={row.disabled} on:click={() => toggleMultiSelect(row.index, opt.value, row.maxSelectedValues)}>
                  <span class="input__multi-check">{#if isMultiSelected(row.index, opt.value)}<BootstrapIcon name="check-lg" />{/if}</span><span>{opt.label || opt.value}</span>
                </button>
              {/each}
            </div>
          {:else if row.type === 'checkbox'}
            <label class="input__check"><input checked={values[row.index]} type="checkbox" disabled={row.disabled} on:change={(e) => updateValue(row.index, (e.target as HTMLInputElement).checked)} /><span class:is-on={values[row.index]} class="input__check-box"><BootstrapIcon name="check-lg" /></span><span>{row.placeholder || row.label}</span></label>
          {:else if row.type === 'textarea'}
            <textarea value={values[row.index]} on:input={(e) => updateValue(row.index, (e.target as HTMLTextAreaElement).value)} class="fb-input fb-input--area" placeholder={row.placeholder} disabled={row.disabled} minlength={row.minLength ?? (typeof row.min === 'number' ? row.min : undefined)} maxlength={row.maxLength ?? (typeof row.max === 'number' ? row.max : undefined)} rows="3" />
          {:else if row.type === 'slider'}
            <div class="input__slider"><input value={values[row.index]} on:input={(e) => updateValue(row.index, Number((e.target as HTMLInputElement).value))} type="range" disabled={row.disabled} min={row.min ?? 0} max={row.max ?? 100} step={numberStep(row)} /><output>{values[row.index]}</output></div>
          {:else if row.type === 'color'}
            <div class="input__color"><input type="color" value={safeColor(values[row.index])} disabled={row.disabled} on:input={(e) => updateValue(row.index, (e.target as HTMLInputElement).value)} /><input value={values[row.index]} on:input={(e) => updateValue(row.index, (e.target as HTMLInputElement).value)} class="fb-input" type="text" disabled={row.disabled} /></div>
          {:else if row.type === 'date-range'}
            <div class="input__date-range"><input class="fb-input" type="date" value={values[row.index]?.[0]} disabled={row.disabled} min={row.min} max={row.max} on:input={(e) => updateValue(row.index, [(e.target as HTMLInputElement).value, values[row.index]?.[1] || ''])} /><input class="fb-input" type="date" value={values[row.index]?.[1]} disabled={row.disabled} min={row.min} max={row.max} on:input={(e) => updateValue(row.index, [values[row.index]?.[0] || '', (e.target as HTMLInputElement).value])} /></div>
          {:else}
            <input value={values[row.index]} on:input={(e) => updateValue(row.index, (e.target as HTMLInputElement).value)} class="fb-input" type={row.password ? 'password' : row.type === 'number' ? 'number' : row.type === 'date' ? 'date' : row.type === 'time' ? 'time' : 'text'} placeholder={row.placeholder} disabled={row.disabled} min={row.min} max={row.max} step={row.type === 'number' ? numberStep(row) : undefined} minlength={row.minLength} maxlength={row.maxLength} />
          {/if}
        </div>
      {/each}
    </div>

    <div class="input__actions">
      {#if data.options?.allowCancel !== false}<button type="button" class="fb-btn fb-btn-secondary" on:click={close}>Cancelar</button>{/if}
      <button type="submit" class="fb-btn fb-btn-primary">Confirmar</button>
    </div>
  </form>
</div>

<style>
  .input-backdrop { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; padding: 18px; background: transparent; animation: fb-fade-in .2s ease; }
  .input { width: min(460px,92vw); max-height: min(80vh,720px); display: flex; flex-direction: column; background: var(--fb-nui-surface); animation: fb-pop-in .24s cubic-bezier(.1,.8,.25,1); }
  .input--xs { width: min(340px,92vw); } .input--sm { width: min(400px,92vw); } .input--md { width: min(520px,92vw); } .input--lg { width: min(640px,92vw); } .input--xl { width: min(760px,92vw); }
  .input__header { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 16px 18px 12px; border-bottom: 1px solid var(--fb-border); }
  .input__heading { font-family: var(--fb-font-heading); font-size: 16px; font-weight: 600; }
  .input__close { width: 30px; height: 30px; border: 1px solid var(--fb-border); border-radius: var(--fb-radius-md); background: transparent; color: var(--fb-text-muted); cursor: pointer; }
  .input__fields { overflow-y: auto; padding: 16px 18px; display: flex; flex-direction: column; gap: 14px; }
  .input__fields input, .input__fields textarea { user-select: text; -webkit-user-select: text; }
  .input__label { display: block; font-size: 13px; font-weight: 500; color: var(--fb-text-grey); margin-bottom: 6px; }
  .input__req { color: var(--fb-error); }
  .input__desc { font-size: 12px; color: var(--fb-text-muted); margin-bottom: 6px; }
  .input__actions { display: flex; justify-content: flex-end; gap: 10px; padding: 14px 18px 18px; border-top: 1px solid var(--fb-border); }
  .input__check { display: flex; align-items: center; gap: 10px; min-height: 38px; padding: 8px 10px; border-radius: 7px; border: 1px solid var(--fb-border); background: var(--fb-nui-field); font-size: 13px; cursor: pointer; }
  .input__check input { display: none; }
  .input__check-box, .input__multi-check { width: 20px; height: 20px; display: grid; place-items: center; border: 1px solid var(--fb-border); border-radius: var(--fb-radius-sm); color: transparent; }
  .input__check-box.is-on, .input__multi-option.is-selected .input__multi-check { background: var(--fb-orange); border-color: var(--fb-orange); color: var(--fb-text); }
  .input__multi { display: grid; gap: 6px; padding: 6px; border: 1px solid var(--fb-border); border-radius: 7px; background: var(--fb-nui-field); }
  .input__multi-option, .input__select-option { min-height: 34px; display: flex; align-items: center; gap: 9px; padding: 7px 9px; border: 1px solid transparent; border-radius: 5px; background: transparent; color: var(--fb-text-grey); text-align: left; cursor: pointer; }
  .input__multi-option:hover, .input__multi-option.is-selected, .input__select-option:hover, .input__select-option.is-selected { border-color: var(--fb-orange-glow-light); background: var(--fb-orange-subtle); color: var(--fb-text); }
  .input__slider, .input__color, .input__date-range { display: grid; align-items: center; gap: 10px; }
  .input__slider { grid-template-columns: minmax(0,1fr) 54px; } .input__color { grid-template-columns: 44px minmax(0,1fr); } .input__date-range { grid-template-columns: repeat(2,minmax(0,1fr)); }
  .input__slider input { accent-color: var(--fb-orange); }
  .input__slider output { text-align: center; color: var(--fb-orange); font-family: var(--fb-font-mono); font-size: 12px; }
  .input__color input[type='color'] { width: 44px; height: 38px; padding: 3px; border-radius: 7px; border: 1px solid var(--fb-border); background: var(--fb-nui-field); }
  .input__select { position: relative; }
  .input__select-trigger { display: flex; align-items: center; justify-content: space-between; gap: 10px; text-align: left; cursor: pointer; }
  .input__select.is-open .input__select-trigger { border-color: var(--fb-orange); box-shadow: 0 0 10px var(--fb-orange-glow-light); }
  .input__select-trigger .is-placeholder { color: var(--fb-text-muted); }
  .input__select-panel { margin-top: 5px; max-height: 220px; overflow-y: auto; padding: 5px; border: 1px solid var(--fb-border-hover); border-radius: 7px; background: var(--fb-nui-surface); box-shadow: 0 12px 30px rgba(0,0,0,.48); }
  .input__select-search { display: grid; grid-template-columns: 16px minmax(0,1fr); align-items: center; gap: 7px; margin-bottom: 5px; padding: 7px 9px; border: 1px solid var(--fb-border); border-radius: 6px; color: var(--fb-text-grey); }
  .input__select-search input { min-width: 0; border: 0; outline: 0; background: transparent; color: var(--fb-text); }
</style>
