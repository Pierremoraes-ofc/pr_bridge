<script lang="ts">
  export let data: any

  const modeLabel = (mode: string) => mode === 'rotate' ? 'Rotacionar' : 'Mover'
  const spaceLabel = (space: string) => space === 'global' ? 'Global' : 'Local'
  const axisLabel = (axis?: string) => {
    if (!axis) return 'Livre'
    if (axis === 'xyz') return 'Movimento livre'
    return axis.toUpperCase()
  }
  const number = (value: unknown, digits = 2) => Number(value || 0).toFixed(digits)
</script>

{#if data?.visible !== false}
  <section class="gizmo-hud" aria-label="Editor 3D">
    <header>
      <span class="unity-mark"><i></i><i></i><i></i></span>
      <div class="heading">
        <strong>{data?.title || 'Editor 3D'}</strong>
        <small>PR BRIDGE • GIZMO</small>
      </div>
      <span class:active={data?.dragging} class="session-dot"></span>
    </header>

    <div class="state-row">
      <span class="mode">{modeLabel(data?.mode)}</span>
      <span>{spaceLabel(data?.space)}</span>
      <span class:enabled={data?.precision}>Precisão {data?.precision ? '×' + number(data?.precisionSpeed, 1) : 'OFF'}</span>
      <span class:enabled={data?.freeCamera}>Freecam {data?.freeCamera ? 'ON' : 'OFF'}</span>
    </div>

    {#if data?.mode === 'rotate' && data?.dragging}
      <div class="angle-readout"><small>ÂNGULO</small><strong>{Number(data?.rotationDegrees || 0) >= 0 ? '+' : ''}{number(data?.rotationDegrees, 1)}°</strong></div>
    {/if}

    <div class="transform-grid">
      <div class="label">POS</div>
      <div><b class="x">X</b>{number(data?.coords?.x, 3)}</div>
      <div><b class="y">Y</b>{number(data?.coords?.y, 3)}</div>
      <div><b class="z">Z</b>{number(data?.coords?.z, 3)}</div>
      <div class="label">ROT</div>
      <div><b class="x">X</b>{number(data?.rotation?.x)}</div>
      <div><b class="y">Y</b>{number(data?.rotation?.y)}</div>
      <div><b class="z">Z</b>{number(data?.rotation?.z)}</div>
    </div>

    <footer>
      <span class="axis">{axisLabel(data?.activeAxis || data?.hoveredAxis)}</span>
      <span><kbd>ENTER</kbd> confirmar</span>
      <span><kbd>BACKSPACE</kbd> cancelar</span>
    </footer>
  </section>
{/if}

<style>
  .gizmo-hud {
    position: absolute;
    top: 8.5vh;
    left: 50%;
    width: min(540px, 48vw);
    transform: translateX(-50%);
    color: var(--fb-text, #fff);
    background: linear-gradient(135deg, rgba(10, 11, 15, .94), rgba(16, 18, 24, .84));
    border: 1px solid var(--fb-orange-border, rgba(255, 122, 26, .32));
    border-radius: 8px;
    box-shadow: 0 12px 36px rgba(0, 0, 0, .38), inset 0 1px rgba(255, 255, 255, .035);
    overflow: hidden;
    font-family: Inter, system-ui, sans-serif;
    pointer-events: none;
    backdrop-filter: blur(9px);
  }

  header { display: flex; align-items: center; gap: 11px; padding: 10px 13px; border-bottom: 1px solid rgba(255,255,255,.07); }
  .heading { display: grid; line-height: 1.05; flex: 1; }
  .heading strong { font-size: 13px; letter-spacing: .025em; }
  .heading small { color: var(--fb-text-grey, #8e8e9f); font-size: 8px; letter-spacing: .17em; margin-top: 4px; }
  .session-dot { width: 7px; height: 7px; border-radius: 50%; background: #aeb3bd; box-shadow: 0 0 0 4px rgba(174,179,189,.08); }
  .session-dot.active { background: var(--fb-orange, #ff7a1a); box-shadow: 0 0 12px var(--fb-orange, #ff7a1a); }

  .unity-mark { position: relative; width: 24px; height: 24px; display: block; transform: rotate(30deg); }
  .unity-mark i { position: absolute; left: 10px; top: 10px; width: 11px; height: 2px; transform-origin: 1px 1px; background: var(--fb-orange, #ff7a1a); border-radius: 2px; }
  .unity-mark i:nth-child(1) { transform: rotate(0deg); }
  .unity-mark i:nth-child(2) { transform: rotate(120deg); background: #41d66d; }
  .unity-mark i:nth-child(3) { transform: rotate(240deg); background: #438bff; }

  .state-row { display: flex; gap: 6px; padding: 8px 12px 4px; }
  .state-row span { padding: 4px 7px; border: 1px solid rgba(255,255,255,.08); border-radius: 4px; color: #aeb3bd; font-size: 9px; text-transform: uppercase; letter-spacing: .06em; }
  .state-row .mode, .state-row .enabled { color: #fff; border-color: var(--fb-orange-border, rgba(255,122,26,.32)); background: var(--fb-orange-subtle, rgba(255,122,26,.08)); }

  .angle-readout { display: flex; align-items: center; justify-content: center; gap: 8px; margin: 7px 12px 0; padding: 6px 9px; color: #ffe35f; background: rgba(255, 218, 51, .08); border: 1px solid rgba(255, 218, 51, .28); border-radius: 5px; }
  .angle-readout small { color: #c8b958; font-size: 8px; letter-spacing: .14em; }
  .angle-readout strong { font: 700 14px ui-monospace, SFMono-Regular, Consolas, monospace; }

  .transform-grid { display: grid; grid-template-columns: 30px repeat(3, 1fr); gap: 5px 8px; align-items: center; padding: 8px 12px 10px; font-family: ui-monospace, SFMono-Regular, Consolas, monospace; font-size: 10px; }
  .transform-grid > div { min-width: 0; white-space: nowrap; }
  .transform-grid .label { color: #737986; font-size: 8px; letter-spacing: .12em; }
  .transform-grid b { display: inline-grid; place-items: center; width: 15px; height: 15px; margin-right: 5px; border-radius: 3px; color: #fff; font-size: 8px; }
  .x { background: #df3328; } .y { background: #24b84f; } .z { background: #286ee6; }

  footer { display: flex; justify-content: flex-end; align-items: center; gap: 12px; padding: 7px 12px; background: rgba(0,0,0,.22); border-top: 1px solid rgba(255,255,255,.055); color: #aeb3bd; font-size: 9px; }
  footer .axis { margin-right: auto; color: var(--fb-orange, #ff7a1a); font-weight: 700; text-transform: uppercase; letter-spacing: .08em; }
  kbd { padding: 2px 5px; color: #fff; background: rgba(255,255,255,.09); border: 1px solid rgba(255,255,255,.13); border-radius: 3px; font: inherit; font-weight: 700; }
</style>