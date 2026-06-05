# Streaming e Spawns (`pr_lib.fivem.streaming`)

O motor de streaming resolve os famosos bugs de "objeto invisível" porque o desenvolvedor esqueceu de fazer um laço de espera com `HasModelLoaded`.

### Requisitar Asset com Segurança
```lua
-- Pede um modelo e trava o script (max 3 seg) ate carregar.
local loaded = pr_lib.fivem.streaming.requestModel("adder", 3000)

local loadedAnim = pr_lib.fivem.streaming.requestAnimDict("missheistdockssetup1clipboard@base")
```

### Criação de Entidades `CreateEntity`
Ao invés de fazer as 5 linhas tradicionais para criar um ped, você pode mandar o bridge cuidar disso. Ele pede o modelo, carrega, spawna na coordenada, alinha no chão, configura colisão e limpa a memória. Tudo em uma função!

```lua
local myProp = pr_lib.fivem.streaming.createProp("prop_box_wood02a_pu", vec3(100.0, -100.0, 30.0), {
    placeProperly = true, -- Auto-alinha no chao
    freeze = true,        -- Ja nasce congelado
    collision = true,
    alpha = 255
})

local myPed = pr_lib.fivem.streaming.createPed("a_m_y_business_01", vec3(100.0, -100.0, 30.0), 90.0, {
    placeProperly = true,
    freeze = true,
    blockingEvents = false -- Ignora o player atirando nele
})
```

### `findGroundZ`
Muitas vezes você tem um Vec3 com altura flutuante e quer colar algo perfeitamente no chão. O Bridge possui um algorítmo que atira um *Raycast* para baixo e te devolve o Z perfeito.

```lua
local groundZ, vectorZ = pr_lib.fivem.streaming.findGroundZ(vec3(0, 0, 100.0))
```
