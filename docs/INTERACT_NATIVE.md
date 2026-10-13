# Interact nativo

O `pr_lib.interact` cria interacoes persistentes no mundo sem depender de `ox_lib`.
O runtime central pertence ao `pr_bridge`; os registros sao removidos automaticamente quando o recurso que os criou e encerrado.

## Controles

- `Interact` (padrao `E`): executa a opcao selecionada. A tecla pode ser alterada nas configuracoes do FiveM e a legenda exibida acompanha o mapeamento atual.
- Roda do mouse ou setas para cima/baixo: muda a opcao.

### Resposta do scroll

Enquanto ha uma interacao ativa com mais de uma opcao, a leitura de scroll/setas ocorre a cada quadro (`Wait(0)`), independentemente do intervalo de atualizacao visual. Um movimento isolado da roda seleciona a linha seguinte/anterior e envia a selecao para a NUI no mesmo tick. Nao e preciso aumentar a forca do scroll nem alterar a sensibilidade do mouse.

A leitura aceita os controles diretos de scroll (241/242), inclusive quando desativados pelo jogo/outro consumidor, e preserva os controles anteriores da roda de armas (15/14). Os sinais equivalentes sao combinados: um mesmo movimento nao avanca duas linhas. As setas, a tecla de acao, a ordem das opcoes e o retorno da ultima para a primeira continuam iguais. Foco de outra NUI e os bloqueios existentes continuam sendo respeitados; este ajuste nao bloqueia controles nem captura o cursor.

Os raycasts e as atualizacoes visuais continuas permanecem limitados por `pr_bridge:interact:renderInterval` (padrao 16 ms); apenas a mudanca de selecao antecipa o envio visual. A busca de pontos segue `pr_bridge:interact:scanInterval` (padrao 250 ms). Nao foi acrescentado um segundo loop. A [documentacao oficial de Citizen.Wait](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/Citizen.Wait/) explica por que pausas positivas podem perder quadros em FPS alto.

### Ancoragem e custo no cliente

Registros de entidade acompanham o ped/prop pela transformacao atual e seu offset no intervalo de renderizacao, sem esperar a busca de pontos de 250 ms. Registros por modelo preservam o offset especifico de cada modelo. A distancia e a existencia da entidade sao atualizadas tambem antes de executar a acao.

Menus exclusivos e pontos com apenas um candidato elegivel nao fazem raycast de camera para selecionar um alvo que ja esta definido. As etiquetas/icones sao preparados na busca; a NUI recebe novos dados somente quando posicao, selecao, opcoes, tecla ou perspectiva mudam. O scroll continua sendo lido por quadro e a selecao continua sendo apresentada imediatamente. O host solicita uma nova apresentacao quando a NUI monta novamente.

`tests/interact_anchor_cost_test.lua` verifica movimento entre buscas, prop removido/fora de alcance, ausencia de raycasts no menu do ped e supressao de pacotes identicos. Contagem de chamadas em testes isolados nao equivale a um tempo de CPU medido no FiveM. Compare o resmon no mesmo local, FPS, quantidade de pontos e configuracao visual; 0,10 ms significa um decimo de milissegundo, nao 10 ms.

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

### Menus temporarios de consumidores

Um registro de coordenada/entidade pode informar `exclusive = true` (padrao: `false`). Enquanto esse registro estiver elegivel, dentro de `interactDst` e com opcoes disponiveis, somente ele participa da selecao/apresentacao. Isso evita que uma acao temporaria de item execute a interacao de um lavatorio/NPC proximo. Nao altera os controles, nao adquire foco NUI e nao ignora os bloqueios globais. Ao remover o registro, os pontos normais voltam a participar.

`UpdateInteraction(id, options)` substitui as opcoes de um estagio e reinicia a selecao quando a lista muda. Registro, atualizacao e remocao invalidam o cache do runtime: o proximo processamento usa a lista atual, inclusive quando a tecla e pressionada antes da proxima busca periodica. Nao ha novas APIs publicas nem um segundo leitor de controles.

O `ox_inventory` usa esse mecanismo para Usar/Arremessar/Colocar/Soltar/Cancelar. A rotacao da previa aparece como opcoes do Interact, sem disputar o scroll da selecao. A coleta usa registros locais ancorados nos props, com indicador distante e texto proximo. Recolher apenas guarda o item, sem abrir o menu; o jogador aciona a hotkey quando quiser usar suas acoes. Fonte, modelo, cores, contornos, perspectiva e deteccao de paredes seguem a configuracao global; as antigas abas de aparencia dessas acoes no OX foram retiradas. A barra numerica e o catalogo de props continuam no inventario.

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

Os modelos `clean`, `blue_circle`, `green_square`, `glitch`, `obtaizen_ui`, `circle`, `record-circle`, `crosshair`, `bullseye`, `geo-alt-fill`, `cursor-fill` e `diamond` podem ser escolhidos em **Interface global > Interact**. Configuracoes antigas `gold_circle` migram para `blue_circle`. O painel tambem controla cores, tamanhos, bloqueios e deteccao de paredes.

## Layout Clean e tipografia

Abra `/pr_ui_admin` com permissao administrativa (ou acesse **Interface global > Interact** pelo painel da base), escolha **Clean (texto e icones)** no modelo visual e salve o formulario. Nao e necessario recriar as interacoes que ja existem no mundo.

- Clean exibe uma lista compacta, alinhada a esquerda, sem fundo por padrao. Fora da distancia de interacao, exibe um circulo com brilho no mesmo ponto do mundo usado pelo Interact.
- Em todos os modelos, a tecla configurada acompanha a linha selecionada e substitui seu icone/seletor. Nao existe uma segunda tecla fixa.
- O tamanho do texto, a altura das linhas e o espaco entre opcoes continuam configuraveis. Para um visual compacto, experimente fonte de 14 px, altura de 24 px e intervalo de 2 px.
- **Texto e tipografia** permite escolher Inter, Nunito, Space Grotesk, JetBrains Mono, Arial ou a fonte do sistema; ativar negrito do texto e da tecla; e engrossar os icones Clean. As fontes web usam os carregadores ja existentes da interface, com fontes de fallback quando indisponiveis; Arial/Sistema nao dependem desses carregadores.
- **Layout Clean (cores independentes)** configura o tamanho da tecla (padrao 18 px), cor do texto, destaque da selecao, icones, preenchimento e letra da tecla, alem da cor e opacidade do fundo. Opacidade zero deixa o fundo transparente. Essas cores nao sobrescrevem a paleta dos modelos antigos.
- Cores/opacidades do ponto, escala e tamanhos gerais continuam nos grupos existentes. A opacidade do texto tambem afeta os textos Clean, a da tecla afeta seu preenchimento, e as opacidades das opcoes afetam o destaque/icones.
- **Contornos e legibilidade** permite ativar separadamente o contorno dos textos/letra da tecla e o dos icones, tecla e indicador no mundo. Cada grupo tem sua cor e espessura de 0 a 3 px (antes da escala geral), validada tambem pelo servidor. Sugestao para fundo claro: preto com 1 px nos textos e 1 px nos icones. Os contornos comecam desativados para preservar os perfis existentes.

O Clean utiliza o `icon` das opcoes existentes (nomes Bootstrap ou aliases Font Awesome suportados pela interface, como `bi bi-droplet` e `fa-solid fa-hand`). Quando nao ha icone, usa um circulo simples. Apenas `label` e `icon` sao enviados para apresentacao; callbacks e permissoes continuam no runtime Lua.

```lua
pr_lib.interact.AddInteraction({
    id = "example:sink",
    coords = vector3(25.0, -1346.0, 29.5),
    distance = 8.0,
    interactDst = 1.5,
    options = {
        { label = "Lavar as maos", icon = "fa-solid fa-hand", action = function() print("Maos") end },
        { label = "Lavar o rosto", icon = "bi bi-droplet", action = function() print("Rosto") end },
    },
})
```

Esta configuracao altera somente a apresentacao. Roda/setas, keybind, selecao, distancias, deteccao de paredes, grupos, `canInteract` e dispatch permanecem os mesmos. Nao foram adicionados clique esquerdo, cancelamento com botao direito, foco NUI nem atalhos do ox_inventory. A configuracao salva atual nao e trocada automaticamente para Clean; o administrador escolhe o modelo para testar.

## Perspectiva 3D pela camera (opcional)

Em `/pr_ui_admin > Interact > Perspectiva 3D (somente visual)`, ative **Ativar perspectiva pela camera** e salve. O efeito funciona no Clean e nos modelos existentes, tanto nas opcoes proximas quanto no indicador distante. Comeca **desativado** para preservar as configuracoes atuais.

- Virar a camera para a direita aproxima visualmente o lado esquerdo da interface e afasta o direito. Virar para a esquerda inverte o efeito.
- A intensidade acompanha o angulo da camera em relacao a direcao inicial da perspectiva, nao a velocidade da virada ou a posicao de um cursor. Ao parar a camera, a interface permanece inclinada; retornar a direcao inicial restaura o plano normal e virar para o outro lado inverte a inclinacao. Nao e preciso abrir a NUI nem capturar o mouse.
- O ponto de ancoragem no mundo continua sendo o mesmo. Apenas a apresentacao recebe uma rotacao CSS; nao se trata de um objeto 3D, nao muda a camera nem as areas de interacao.

| Configuracao | Padrao | Limites | Efeito |
| --- | --- | --- | --- |
| Inclinacao maxima | 25 graus | 0 a 35 | Limites simetricos: -maximo a +maximo; 25 significa -25 a +25 graus. Zero deixa tudo plano. |
| Sensibilidade | 1 | 0,1 a 3 | Valores maiores atingem o limite com viradas menores. Em 1, uma virada de 45 graus atinge o limite. |
| Profundidade | 600 px | 250 a 2000 | Valores menores deixam a diferenca entre os lados mais evidente. |
| Suavizacao | 120 ms | 0 a 400 | Amortece a mudanca entre angulos, sem retorno automatico a zero; zero aplica a resposta imediatamente. |

Para testar um efeito mais evidente, experimente inclinacao de 30 graus, sensibilidade 1,5, profundidade de 350 px e suavizacao de 120 ms. Depois ajuste ao gosto do servidor. A escala, fonte, negrito e contornos continuam independentes.

A leitura usa a orientacao da camera efetivamente renderizada, a mesma referencia dos raycasts existentes do PR Bridge. A passagem entre -180 e 180 graus e tratada pelo deslocamento angular em relacao a direcao inicial; viradas grandes sao limitadas ao maximo configurado, sem zerar o efeito. Pausas longas preservam o angulo e uma reinicializacao do relogio recebe uma nova referencia segura. A suavizacao leva em conta o tempo entre quadros, em vez de depender de uma quantidade fixa de quadros.

Nao ha um novo loop de controles ou renderizacao: o runtime existente envia somente um angulo adicional para a NUI. Desativar a perspectiva, ocultar os indicadores, perder todos os pontos visiveis ou bloquear o Interact por foco de outra NUI reinicia o efeito. Com a opcao desativada, nao ha leitura adicional da camera para esta funcionalidade.

`tests/interact_perspective_test.lua` verifica inclinacao mantida, retorno a direcao original, limites positivos/negativos, passagem angular, pausas, configuracao invalida e suavizacao em 30/60/120/240 FPS. O teste do runtime confirma que selecao, scroll e foco continuam independentes do efeito.

A opcao **Exibir indicadores do interact na tela** pode ocultar toda a NUI sem desativar a deteccao nem a execucao do keybind.
Cada registro tambem pode usar hide = true para ocultar apenas o seu indicador. A deteccao, o canInteract, a selecao e a execucao pela tecla configurada continuam ativos. Os aliases hidden = true e showUI = false sao aceitos para compatibilidade.
