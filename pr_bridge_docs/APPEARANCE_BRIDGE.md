# Forge Appearance no PR Bridge

Importe `@pr_bridge/init.lua` e acesse `pr_lib.appearance`. O bridge resolve o recurso sob demanda e acompanha sua disponibilidade pelos eventos de início e parada. Quando o provedor está indisponível, as operações retornam `nil, "appearance_provider_unavailable"`. `getProvider()` retorna `"forge-appearance"` ou `nil`. Os retornos e as validações das demais operações são os do provedor.

```lua
-- Cliente
local ped = PlayerPedId()
local appearance, reason = pr_lib.appearance.getPedAppearance(ped)
if appearance then
    pr_lib.appearance.setPedAppearance(ped, appearance)
end
```

Chame as funções do bridge com ponto. O export FiveM direto usa dois-pontos, como em `exports["forge-appearance"]:getPedAppearance(ped)`.

## Cliente

| Função | Finalidade |
| --- | --- |
| `getPedModel(ped)` | Nome do modelo. |
| `getPedComponents(ped)` | Variações das roupas. |
| `getPedProps(ped)` | Variações dos acessórios. |
| `getPedHeadBlend(ped)` | Dados de herança facial. |
| `getPedFaceFeatures(ped)` | Traços do rosto. |
| `getPedHeadOverlays(ped)` | Sobreposições faciais. |
| `getPedHair(ped)` | Cabelo e cores. |
| `getPedAppearance(ped)` | Objeto de aparência do ped. |
| `setPlayerModel(model)` | Troca o modelo do jogador local. |
| `setPedHeadBlend(ped, headBlend)` | Aplica herança facial. |
| `setPedFaceFeatures(ped, faceFeatures)` | Aplica traços do rosto. |
| `setPedHeadOverlays(ped, headOverlays)` | Aplica sobreposições faciais. |
| `setPedHair(ped, hair, tattoos)` | Aplica cabelo e os decalques fornecidos. |
| `setPedEyeColor(ped, eyeColor)` | Aplica a cor dos olhos. |
| `setPedComponent(ped, component)` | Aplica uma peça de roupa. |
| `setPedComponents(ped, components)` | Aplica uma lista de peças. |
| `setPedProp(ped, prop)` | Aplica um acessório. |
| `setPedProps(ped, props)` | Aplica uma lista de acessórios. |
| `setPlayerAppearance(appearance)` | Aplica modelo e aparência do jogador local. |
| `setPedAppearance(ped, appearance)` | Aplica aparência a um ped existente. |
| `setPedTattoos(ped, tattoos)` | Aplica tatuagens convencionais por região. |
| `startPlayerCustomization(callback, config)` | Abre a personalização. O callback recebe a aparência confirmada ou `nil` ao cancelar. |
| `OpenAdminMenu(parentMenu?, parentResource?)` | Abre a administração com a checagem de permissões do recurso. Passe o recurso do menu pai quando usar o bridge. |
| `Reapply()` | Solicita reaplicação local das tatuagens editáveis no próximo ciclo. |
| `GetBaseDecorations()` | Retorna pares de hashes de coleção e decoração do jogador sem as camadas dinâmicas. |

## Servidor

| Função | Finalidade |
| --- | --- |
| `IsAppearanceAdmin(source)` | Verifica a permissão de administração do jogador. |
| `ClothingCatalogImage(item)` | Lê uma imagem do catálogo local. |
| `ClothingCatalogReference(item)` | Lê a referência da imagem do catálogo local. |
| `ImageGenerationBegin(source, options)` | Abre uma sessão autorizada e devolve a chave da sessão. |
| `ImageGenerationCheck(source, token, item)` | Verifica ou prepara a captura de uma variação. |
| `ImageGenerationFail(source, token, key, error)` | Registra falha da captura em andamento. |
| `ImageGenerationFinish(source, token, reason?, error?)` | Encerra a sessão e retorna o resumo. |
| `AppearanceInkStorage(raw)` | Transporta uma requisição JSON de armazenamento e devolve um envelope JSON. Reservada à integração de servidor com identidade já validada. |

As operações de geração validam administrador, jogador e sessão conforme a ação. Os exports são interfaces entre recursos. Qualquer script que os ligue a ações de jogadores deve validar a identidade e os dados antes da chamada. A API de armazenamento recebe o identificador do personagem em `owner` e suporta `read`, `stage`, `stageCheckout`, `commit` e `drop` nas rotinas de aparência.

## Compatibilidade

O Forge Appearance fornece a dependência `illenium-appearance` com `provide` e publica aliases de seus exports no cliente e no servidor. Eventos de entrada e callbacks da interface Illenium são atendidos pelo mesmo código do Forge. O evento de conclusão da criação inicial é emitido nos dois nomes para os consumidores antigos. A documentação de configuração está em `docs/COMPATIBILITY.md` no Forge Appearance. [Referência do manifesto FiveM](https://docs.fivem.net/docs/scripting-reference/resource-manifest/#provide)
