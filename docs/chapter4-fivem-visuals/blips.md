# API de Blips e URLs de Assets

O submódulo `pr_lib.fivem.blips` não é apenas um criador de blips. Ele é um mapeador unificado da **FiveM Docs** que converte IDs numéricas de imagens e itens do GTA para as URLs oficias de imagem no site de documentação.

Ideal para preencher NUI e Menus com imagens oficiais do jogo dinamicamente!

### Buscador de URLs Nativas
Ao passar os modelos, o `pr_bridge` formata as strings, mapeia e lhe entrega a URL pronta de `.png` ou `.webp`.

```lua
local blips = pr_lib.fivem.blips

local imgPed = blips.getPedImageUrl("a_m_m_business_01")
-- "https://docs.fivem.net/peds/a_m_m_business_01.webp"

local imgVeiculo = blips.getVehicleImageUrl("adder")
-- "https://docs.fivem.net/vehicles/adder.webp"

local imgArma = blips.getWeaponImageUrl("weapon_pistol")
-- "https://docs.fivem.net/weapons/WEAPON_PISTOL.png"

local imgMarker = blips.getMarkerImageUrl(1)
-- "https://docs.fivem.net/markers/1.png"

local imgBlipMap = blips.getBlipImageUrl(60)
-- Retorna a foto do Escudo da Delegacia (radar_police_station)
```

### Metadados de Cores e Sprites de Blips (Mapa)
O bridge possui uma tabela catalogada completa internamente de todos os blips do jogo.

```lua
-- Pega a cor oficial mapeada em Hex
local corPolicial = pr_lib.fivem.blips.getColorInfo(3) 
print(corPolicial.name) -- "Blue"
print(corPolicial.color) -- "#5db6e5"

-- Retorna toda a informacao de um Blip ID
local blipInfo = pr_lib.fivem.blips.describe(60, 2)
print(blipInfo.name) -- "radar_police_station"
print(blipInfo.image) -- "https://docs.fivem.net/blips/radar_police_station.png"
print(blipInfo.color.name) -- "Green"
```
