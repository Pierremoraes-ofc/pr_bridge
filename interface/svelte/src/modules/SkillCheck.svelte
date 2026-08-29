<script lang="ts">
  import { onDestroy, onMount } from 'svelte'
  import { fetchNui, onNuiMessage } from '../nui/bridge'

  export let data: any

  let roundIndex = 0
  let angle = 0
  let targetStart = 90
  let expectedKey = 'e'
  let frame = 0
  let lastFrame = 0
  let completed = false
  let roundStartedAt = 0
  let stopForwardedKey: (() => void) | null = null

  $: rounds = Array.isArray(data?.rounds) && data.rounds.length ? data.rounds : [{ areaSize: 50, speedMultiplier: 1 }]
  $: keys = Array.isArray(data?.keys) && data.keys.length ? data.keys : ['w', 'a', 's', 'd']
  $: round = rounds[Math.min(roundIndex, rounds.length - 1)] || rounds[0]
  $: areaSize = Math.max(10, Math.min(90, Number(round?.areaSize) || 50))
  $: targetEnd = targetStart + areaSize
  $: markerTransform = `translateX(-50%) rotate(${angle}deg)`
  $: skillPosition = normalizePosition(data?.position)


  function normalizePosition(value: unknown) {
    const position = String(value || '').toLowerCase()
    if (position === 'top' || position === 'top-center') return 'top'
    if (position === 'bottom' || position === 'bottom-center') return 'bottom'
    return ''
  }
  function normalizedKeys() {
    return keys.map((key: any) => String(key).toLowerCase())
  }

  function randomBetween(min: number, max: number) {
    return min + Math.random() * Math.max(0, max - min)
  }

  function beginRound() {
    const current = rounds[Math.min(roundIndex, rounds.length - 1)] || rounds[0]
    const currentArea = Math.max(10, Math.min(90, Number(current?.areaSize) || 50))
    targetStart = randomBetween(55, 305 - currentArea)
    expectedKey = String(keys[Math.floor(Math.random() * keys.length)] || 'e').toLowerCase()
    angle = 0
    lastFrame = performance.now()
    roundStartedAt = lastFrame
  }

  function sendResult(result: boolean, reason: string) {
    if (completed) return
    completed = true
    cancelAnimationFrame(frame)
    void fetchNui('skillcheck:result', {
      __resource: data?.__resource,
      token: data?.token,
      result,
      reason,
    })
  }

  function animate(now: number) {
    if (completed) return
    const delta = Math.min(50, now - lastFrame)
    lastFrame = now
    const speed = 155 * Math.max(0.15, Number(round?.speedMultiplier) || 1)
    angle += speed * (delta / 1000)

    if (angle >= 360 || now - roundStartedAt > 8000) {
      sendResult(false, 'missed')
      return
    }
    frame = requestAnimationFrame(animate)
  }

  function processKey(rawKey: unknown, repeat = false) {
    if (completed || repeat) return
    const pressed = String(rawKey || '').toLowerCase()
    const allowed = normalizedKeys()

    if (pressed === 'escape') {
      sendResult(false, 'cancelled')
      return
    }
    if (!allowed.includes(pressed)) return

    if (pressed !== expectedKey || angle < targetStart || angle > targetEnd) {
      sendResult(false, pressed !== expectedKey ? 'wrong_key' : 'outside_zone')
      return
    }

    if (roundIndex + 1 >= rounds.length) {
      sendResult(true, 'success')
      return
    }

    roundIndex += 1
    beginRound()
  }

  function handleKey(event: KeyboardEvent) {
    const pressed = event.key.toLowerCase()
    if (pressed === 'escape' || normalizedKeys().includes(pressed)) {
      event.preventDefault()
      event.stopImmediatePropagation()
    }
    processKey(event.key, event.repeat)
  }

  onMount(() => {
    beginRound()
    window.addEventListener('keydown', handleKey, true)
    stopForwardedKey = onNuiMessage('ui:key', (payload) => processKey(payload?.key, payload?.repeat === true))
    frame = requestAnimationFrame(animate)
  })

  onDestroy(() => {
    cancelAnimationFrame(frame)
    window.removeEventListener('keydown', handleKey, true)
    stopForwardedKey?.()
  })
</script>

<section class:skillcheck--top={skillPosition === 'top'} class:skillcheck--bottom={skillPosition === 'bottom'} class="skillcheck" aria-label={data?.label || 'Teste de habilidade'}>
  <div class="skillcheck__heading">{data?.label || 'TESTE DE HABILIDADE'}</div>
  <div class="skillcheck__ring" style={`--target-start:${targetStart}deg; --target-size:${areaSize}deg`}>
    <div class="skillcheck__inner"></div>
    <div class="skillcheck__needle" style:transform={markerTransform}><i></i></div>
    <div class="skillcheck__hub">{expectedKey.toUpperCase()}</div>
  </div>
  <div class="skillcheck__status">ETAPA {roundIndex + 1} / {rounds.length}</div>
  <div class="skillcheck__hint">Pressione a tecla quando o ponto branco alcançar a área laranja</div>
</section>

<style>
  .skillcheck { position: fixed; left: 50%; bottom: 13%; width: 280px; transform: translateX(-50%); color: var(--fb-text); text-align: center; font-family: var(--fb-font-body); text-shadow: 0 1px 5px rgba(0,0,0,.9); pointer-events: none; animation: fb-pop-in .2s ease; }
  .skillcheck__heading { margin-bottom: 13px; color: var(--fb-orange); font-family: var(--fb-font-heading); font-size: 13px; font-weight: 800; letter-spacing: .14em; }
  .skillcheck__ring { position: relative; width: 164px; height: 164px; margin: auto; border-radius: 50%; background: conic-gradient(from 0deg, #24252b 0deg var(--target-start), var(--fb-orange) var(--target-start) calc(var(--target-start) + var(--target-size)), #24252b calc(var(--target-start) + var(--target-size)) 360deg); filter: drop-shadow(0 7px 18px rgba(0,0,0,.72)); }
  .skillcheck__inner { position: absolute; inset: 11px; border-radius: 50%; background: radial-gradient(circle at 50% 45%, #191a1f 0%, #101115 72%); box-shadow: inset 0 0 24px rgba(0,0,0,.78), 0 0 0 1px rgba(255,255,255,.035); }
  .skillcheck__needle { position: absolute; left: 50%; bottom: 50%; width: 1px; height: 72px; transform-origin: 50% 100%; background: rgba(255,255,255,.32); will-change: transform; }
  .skillcheck__needle i { position: absolute; left: 50%; top: -6px; width: 12px; height: 12px; transform: translateX(-50%); border-radius: 50%; background: #fff; box-shadow: 0 0 7px rgba(255,255,255,.95), 0 0 14px rgba(255,255,255,.35); }
  .skillcheck__hub { position: absolute; left: 50%; top: 50%; width: 31px; height: 31px; display: grid; place-items: center; transform: translate(-50%, -50%); border-radius: 50%; color: var(--fb-text); background: #101115; border: 2px solid #24252b; box-shadow: 0 2px 8px rgba(0,0,0,.75); font-size: 12px; font-weight: 900; }
  .skillcheck__status { margin-top: 13px; color: var(--fb-orange); font-size: 12px; font-weight: 800; letter-spacing: .12em; }
  .skillcheck__hint { margin-top: 5px; color: var(--fb-text-grey); font-size: 11px; line-height: 1.35; }
  :global(html[data-skillcheck-position='top-center']) .skillcheck { top: 13%; bottom: auto; }
  .skillcheck.skillcheck--top { top: 13%; bottom: auto; }
  .skillcheck.skillcheck--bottom { top: auto; bottom: 13%; }
</style>