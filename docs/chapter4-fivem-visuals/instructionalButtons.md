# Instructional Buttons

Um módulo fantástico e extremamente polido do `pr_bridge` disponível em `pr_lib.fivem.instructionalButtons`.
Com ele, você usa o Scaleform Nativo (`INSTRUCTIONAL_BUTTONS`) do GTA V para exibir comandos na parte inferior direita da tela (exatamente como o próprio GTA faz). E melhor: **Suporta Mouse Click Nativo**.

### `showSimple(label, control, options)`
Exibe apenas um botão na tela de forma visual. Não trava a câmera ou o mouse. E te retorna `true` no momento exato em que o jogador pressionar o botão mapeado.

```lua
Citizen.CreateThread(function()
    -- Fica na tela por 10 segundos, esperando apertar E (ControlId 38)
    local pressionado = pr_lib.fivem.instructionalButtons.showSimple("Entrar na Casa", "~INPUT_PICKUP~", {
        controlId = 38,
        duration = 10000 
    })
    
    if pressionado then
        print("Ele Apertou E!")
    end
end)
```

### `showClickable(label, control, controlId, options)`
Este é o ápice do scaleform. Ele liberta o ponteiro do mouse na tela. O jogador pode clicar com o cursor em cima do Instructional Button.

```lua
local pressed = pr_lib.fivem.instructionalButtons.showClickable("Confirmar", "~INPUT_FRONTEND_ACCEPT~", 201, {
    duration = 5000,
    disableMouseControls = true -- Tranca a movimentacao da camera
})
```

### Exibição Multi-Botões
Você pode desenhar um Scaleform complexo com vários botões e ele detectará qual botão foi pressionado no loop.

```lua
local clicou, botaoSelecionado, controlId = pr_lib.fivem.instructionalButtons.show({
    { label = "Confirmar", control = "~INPUT_FRONTEND_ACCEPT~", controlId = 201 },
    { label = "Cancelar", control = "~INPUT_FRONTEND_CANCEL~", controlId = 202 }
}, {
    clickable = true,
    duration = 15000
})

if clicou and controlId == 201 then
    print("Confirmou!")
end
```
