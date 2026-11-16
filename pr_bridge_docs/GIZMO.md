# Gizmo 3D modal

O gizmo do `pr_bridge` e um editor 3D autocontido. Ele abre a camera, cria a NUI Svelte, bloqueia os controles do jogo, desenha os manipuladores e encerra a sessao sem exigir loops de teclado no recurso consumidor.

## Contratos publicos

### Compatibilidade (`start`)

```lua
local session = pr_lib.gizmo.start(entity, function(coords, oldCoords, rotation, oldRotation)
    -- callback opcional executado enquanto o transform muda
    return true
end, vector3(0.0, 0.0, 0.0), {
    title = 'Editar objeto',
    restoreOnCancel = true,
    onFinish = function(result)
        if result.confirmed then
            print(result.coords, result.rotation)
        end
    end,
})
```

A assinatura anterior de `start(entity, callback, offset, options)` permanece valida. O retorno agora e um objeto de sessao com `active` e `result`.

### Fluxo modal (`await`)

```lua
CreateThread(function()
    local result, cancelledResult = pr_lib.gizmo.await(entity, {
        title = 'Editar objeto',
        offset = vector3(0.0, 0.0, 0.0),
        restoreOnCancel = true,
    })

    if result then
        print(('confirmado: %.3f %.3f %.3f'):format(result.coords.x, result.coords.y, result.coords.z))
    else
        print(('cancelado: %s'):format(cancelledResult.reason))
    end
end)
```

`await` deve ser chamado dentro de uma thread. No sucesso, o primeiro retorno contem o resultado. No cancelamento, o primeiro retorno e `nil` e o segundo explica o encerramento.

## Resultado

- `confirmed` / `cancelled`;
- `reason`: `enter`, `backspace`, `escape`, `stopped` ou motivo informado pelo consumidor;
- `entity`;
- `coords` e alias `position`;
- `rotation` e `heading`;
- `offset`, `mode`, `space`;
- `precision` e `precisionSpeed`.

## Opcoes principais

- `title`: titulo da NUI;
- `offset`: deslocamento local do manipulador;
- `precisionMode`, `precisionSpeed`;
- `allowFreeCameraToggle`;
- `restoreOnCancel`: restaura o transform inicial; padrao `true`;
- `managedControls`: bloqueio central de controles; padrao `true`;
- `managedPrecision`: movimentacao de precisao interna; padrao `true`;
- `autoStop`: fecha automaticamente apos a decisao; padrao `true`;
- `ui`/`showUi`: mostra a NUI Svelte; padrao `true`;
- `onUpdate`, `onConfirm`, `onCancel`, `onFinish`.

## Controles

Todos os comandos de teclado abaixo sao registrados por `pr_lib.addKeybind`, aparecem nas configuracoes do FiveM e alimentam o mesmo despachante usado pela barra instrucional:

- `ENTER`: confirmar e retornar o transform;
- `BACKSPACE`: cancelar e restaurar o transform inicial quando `restoreOnCancel` estiver ativo;
- `R`: alternar entre posicionamento e rotacao;
- `L`: alternar espaco local/global;
- `TAB`: ativar/desativar o modo preciso;
- `F`: alternar freecam/foco;
- `G`: alinhar ao solo;
- `W`, `A`, `S`, `D`: mover no modo preciso;
- `Q`/`E`: yaw no modo preciso;
- setas esquerda/direita: roll no modo preciso;
- setas cima/baixo: pitch no modo preciso;
- `PAGEUP`/`PAGEDOWN`: aumentar/reduzir a velocidade precisa;
- roda do mouse: subir/descer ou ajustar distancia conforme o modo;
- mouse esquerdo: selecionar e arrastar eixo, plano, centro ou anel;
- mouse direito: orbitar a camera de foco.

O editor bloqueia os demais controles, inclusive o pause menu. A barra instrucional muda entre posicionamento, seletor de rotacao, rotacao ativa, precisao e freecam. No arraste de rotacao, o setor angular e o HUD Svelte exibem os graus acumulados.

O HUD Svelte e passivo e nao assume foco NUI. O cursor pertence ao manipulador nativo e e liberado explicitamente ao confirmar, cancelar, parar ou ocorrer encerramento externo. `TAB` sempre alterna de volta do modo preciso para o manipulador, inclusive quando o estado inicial veio de um `precisionModeProvider`.

No modo de translacao, setas, planos e o controle central preservam coordenadas 3D para selecao, mas sao projetados em uma camada 2D sem teste de profundidade. Por isso permanecem visiveis por cima do prop. Os eixos usam hastes finas com cabecas triangulares destacadas, os planos possuem preenchimento leve e o movimento livre usa um pequeno disco central.

Na orientacao local, o gizmo normaliza a ordem nativa da matriz para X = direita (vermelho), Y = frente (verde) e Z = cima (azul). O anel selecionado e o eixo quaternion aplicado seguem essa mesma convencao.

A barra instrucional inferior nao e clicavel. Ela volta a exibir todas as acoes e controles do modo atual, incluindo confirmar, cancelar, modo, espaco local/global, solo, precisao, freecam, movimento, camera e zoom. As teclas continuam funcionais e remapeaveis pelo FiveM; a barra serve apenas como guia visual e nao disputa o mouse com o manipulador.

## Movimento livre central

Ao clicar no pequeno circulo central, o editor entra temporariamente em freecam. A camera, e nao o ped, passa a ser movimentada; enquanto o clique estiver pressionado, o objeto acompanha o ponto a frente da camera. Ao soltar, o editor retorna para a camera orbital.

## Compatibilidade e teste

`pr_scriptTest/client_manifest.lua` contem duas entradas consecutivas:

1. `Gizmo editor manifest`: contrato compativel via `gizmo.start`;
2. `Gizmo modal manifest (nova API)`: contrato autocontido via `gizmo.await`.

A implementacao esta pronta para homologacao in-game. Reinicie `pr_bridge` e `pr_scriptTest` antes de comparar os dois fluxos.