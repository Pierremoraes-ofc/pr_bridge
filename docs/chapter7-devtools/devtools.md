# Ferramentas de Plotagem (`pr_lib.fivem.devtools`)

Esse módulo habilita uma **Freecam** (Câmera Livre) com Raycasts (lasers) atrelados à mira central, permitindo que você desenhe elementos 3D no cenário para capturar coordenadas.

Tudo é devolvido via Callback com as informações brutas pra você salvar no banco ou printar no F8!

### `drawPolyzone3D`
Quer criar uma Polyzone em um script seu de forma dinâmica? O Bridge congela o seu personagem, abre uma câmera livre que voa pelo cenário e você "Clica" adicionando vértices no chão construindo um polígono visual!
Quando você aperta "ENTER", a Bridge te devolve a tabela das coordenadas perfeitamente montada.

```lua
pr_lib.fivem.devtools.drawPolyzone3D({
    wallHeight = 3.0,
    minPoints = 3
}, function(points)
    if not points then return print("Cancelou") end
    
    -- Devolve a tabela ja formatada!
    pr_lib.utils.dumpTable(points)
end)
```

### `placeObject` (Ghost Placement)
Quer que o ADM crie caixas pelo mapa? Com essa função, o objeto vira um "Fantasma" atrelado à câmera livre. Ele desliza sobre as paredes e chão, usando *Raycast* e calculando o offset exato do modelo (Bounding Box) para que não atravesse a parede.
O usuário controla a rotação no scroll do mouse.

```lua
pr_lib.fivem.devtools.placeObject({
    model = "prop_mp_crate_01",
    placeProperly = true
}, function(result)
    -- result.coords
    -- result.heading
    -- result.groundZ
    print("Colocado!")
end)
```

> **Aviso:** Você também pode usar `.placePed` e `.placeVehicle` com a exata mesma sintaxe, o sistema adaptará a câmera e o motor de física.
