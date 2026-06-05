# DrawText (2D e 3D)

Localizado em `pr_lib.fivem.drawtext`, este módulo facilita a plotagem de texto nativo em tela com alinhamentos automáticos, controle por Thread interna da Bridge (evitando códigos espaguetes) e manipulação simples de cor.

### Exibição Segura de Texto 2D Automática
Você pode simplesmente pedir para a Bridge gerenciar a exibição de um texto (ela gerencia as Threads de desenho automaticamente e limpa sozinha).

```lua
-- Mostra o texto no centro-esquerdo da tela
pr_lib.fivem.drawtext.show("Pressione E para acessar a Lojinha", "left", {
    color = "#5db6e5", -- Cor em HEX automatico (Blue)
    scale = 0.45,
    enableOutline = true
})

-- Esconder apos interacao
pr_lib.fivem.drawtext.hide()

-- Ou esconder automaticamente após N milissegundos
pr_lib.fivem.drawtext.keyPressed(1000)
```

### Rendering Direto no Frame (Para `Wait(0)`)
Se você já tem uma Thread em `Wait(0)` (exemplo: dentro de uma checagem de distância), pode usar os renderers brutos, que desenham apenas por 1 *frame*.

#### Texto 2D no seu Loop
```lua
pr_lib.fivem.drawtext.drawText2d({
    text = "Assalto em Progresso",
    coords = vec2(0.50, 0.10),
    scale = 0.50,
    font = 4,
    color = vec4(255, 0, 0, 255),
    align = "center",
    enableDropShadow = true,
})
```

#### Texto 3D Projetado no Mundo
```lua
local pedCoords = GetEntityCoords(PlayerPedId())
pr_lib.fivem.drawtext.drawText3d({
    text = "~g~Segurança",
    coords = pedCoords + vec3(0, 0, 1.0),
    scale = 0.35, -- Pode passar vec2(0.35, 0.35) também
    font = 4,
    color = vec4(255, 255, 255, 255),
    drawRect = true, -- Desenha fundo preto opaco atras do texto
    rectAlpha = 100
})
```
