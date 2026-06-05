# DevLaser e Gizmo (`pr_lib.fivem.devlaser`)

A cereja do bolo para a manutenção do servidor em tempo real. O DevLaser é um módulo focado em apontamento visual direto.

### `.start()`
Ao chamar essa função, um raio a partir da sua câmera apontará para o exato local de colisão.
Se atingir uma entidade suportada (Veículo, Ped ou Objeto de mapa prop), ele renderiza um gigantesco Painel 2D colado na tela mostrando TUDO sobre a entidade (NetID, Health, Hash do Modelo, Nome em Tela, Velocidade em tempo real).

Além disso desenha um `Bounding Box` 3D sobre os vértices do modelo alvo em verde fosforescente.

### Manipulação (Delete & Freeze)
Com o DevLaser ativo e olhando pra entidade, um painel de "Instructional Buttons" nativo e bonito aparece na parte inferior.
Pressionando a tecla equivalente você pode:
- Deletar a entidade da rede instantaneamente.
- "Freezar" ou Descongelar a entidade.
- "Print Debug", que cospe todo o json da entidade no seu terminal (F8) caso precise copiar os *hashes* ou coordenadas para o script!

### O Poder do Gizmo (`Move`)
Olhando para a entidade e pressionando "Move", o DevLaser instila a API `pr_lib.fivem.gizmo` nela.
Aparecerá as setas tridimensionais do GTA V oficiais por cima da entidade (Setas Azul, Vermelho e Verde).
O seu mouse fica livre na tela e você clica e arrasta para mover o objeto, veículo ou ped em tempo real em todas as direções perfeitamente sincronizado com a física!

Perfeito para posicionar NPCs e cadeiras no servidor e usar o Print Debug pra copiar o valor salvo pra colocar no seu código!

```lua
-- Inicia a thread de laser
pr_lib.fivem.devlaser.start({
    distance = 50.0 -- Ate 50 metros pega o laser
})

-- Ou para desligar a forca:
pr_lib.fivem.devlaser.stop()
```
