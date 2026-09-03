# Interact nativo

O `pr_lib.interact` cria interacoes persistentes no mundo sem depender de `ox_lib`.
O runtime central pertence ao `pr_bridge`; os registros sao removidos automaticamente quando o recurso que os criou e encerrado.

## Controles

- `Interact` (padrao `E`): executa a opcao selecionada. A tecla pode ser alterada nas configuracoes do FiveM e a legenda exibida acompanha o mapeamento atual.
- Roda do mouse ou setas para cima/baixo: muda a opcao.

## APIs

- `AddInteraction(data)` / `addInteraction(data)`
- `AddLocalEntityInteraction(data)` / `addLocalEntityInteraction(data)`
- `AddEntityInteraction(data)` / `addEntityInteraction(data)`
- `AddEntityBoneInteraction(data)` / `addEntityBoneInteraction(data)`
- `AddModelInteraction(data)` / `addModelInteraction(data)`
- `AddGlobalVehicleInteraction(data)` / `addGlobalVehicleInteraction(data)`
- `AddGlobalPlayerInteraction(data)` / `addGlobalPlayerInteraction(data)`
- `RemoveInteraction(id)`
- `RemoveInteractionByEntity(entity)`
- `RemoveInteractionOption(id, name)`
- `UpdateInteraction(id, options)`
- `RemoveLocalEntityInteraction(entity, id)`
- `RemoveEntityInteraction(netId, id)`
- `RemoveModelInteraction(models, id)`
- `RemoveGlobalVehicleInteraction(id)`
- `RemoveGlobalPlayerInteraction(id)`
- `Disable(state)` / `disable(state)`

## Exemplo

```lua
pr_lib.interact.AddInteraction({
    id = "example:counter",
    coords = vector3(25.0, -1346.0, 29.5),
    distance = 8.0,
    interactDst = 1.5,
    showUI = false,
    options = {
        {
            name = "example:hello",
            label = "Interagir",
            canInteract = function(entity, coords, args) return true end,
            action = function(entity, coords, args) print("Interacao executada", coords) end,
        },
    },
})
```

Os modelos `blue_circle`, `gold_circle`, `green_square`, `glitch` e `obtaizen_ui` podem ser escolhidos em **Interface global > Interact**. O painel tambem controla cores, tamanhos, bloqueios e deteccao de paredes.


A opcao **Exibir indicadores do interact na tela** pode ocultar toda a NUI sem desativar a deteccao nem a execucao do keybind.
Cada registro tambem pode usar hide = true para ocultar apenas o seu indicador. A deteccao, o canInteract, a selecao e a execucao pela tecla configurada continuam ativos. Os aliases hidden = true e showUI = false sao aceitos para compatibilidade.
