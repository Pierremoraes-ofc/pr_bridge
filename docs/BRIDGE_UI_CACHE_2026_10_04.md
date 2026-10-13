# PR Bridge — idioma, interface, metadata e logo

Implementado em 04/10/2026. **Aguarda aprovação no FiveM.** Testes isolados e navegador local não equivalem a homologação no jogo ou certificação para 2 mil jogadores.

## Índice

- [Logo da cidade](#logo-da-cidade)
- [Metadata](#metadata)
- [Cache e consultas](#cache-e-consultas)
- [Persistência e desempenho](#persistência-e-desempenho)
- [Verificação e limites](#verificação-e-limites)
- [Roteiro no jogo](#roteiro-no-jogo)

## Logo da cidade

Forge Core → Configuração de servidor → Interface global → **Logo da cidade**. Também acessível pelo comando administrativo `pr_ui_admin`.

- Cole a URL direta da imagem PNG, de preferência HTTPS (não a página do serviço de hospedagem).
- Salva em `interface/data/config.json`, campo `branding.logoUrl`. Não foi necessário alterar o JSON existente durante esta implementação.
- URL vazia usa a imagem padrão do Forge. Falha no carregamento da imagem também usa a imagem padrão, sem repetição infinita.
- URL HTTP/HTTPS limitada a 2048 caracteres; protocolos executáveis, credenciais, espaços internos e caracteres de controle rejeitados no servidor. A interface valida o protocolo novamente.
- O cliente carrega a imagem diretamente; o servidor não baixa arquivos nem atua como proxy. Disponibilidade e tamanho do PNG dependem da hospedagem escolhida.
- Aplica-se a todos os menus `registerContext` do renderer nativo PR Bridge, inclusive os chamados por outros recursos. Não modifica logos de HUD ou de interfaces próprias de terceiros.
- Alterações recebidas atualizam também menus já abertos. Restaurar padrão limpa a URL juntamente com as demais configurações globais.
- Textos novos disponíveis em PT-BR, inglês, espanhol e francês. Os arquivos ES/FR estavam vazios e agora possuem os contratos básicos de tradução do bridge.

## Metadata

Causa corrigida nos dois renderizadores: fundo limitado a 300px, lista limitada separadamente a 280px e imagem fora desse cálculo. Isso deixava campos fora do fundo.

- Altura automática conforme imagem e campos; não há limite fixo de quantidade de informações.
- Uma única área de rolagem contém imagem principal e lista; limite vertical é a altura da tela menos 24px.
- Textos e rótulos longos quebram linha; imagens menores não são comprimidas pelos textos.
- Posição recalculada ao mudar opção, lado, imagem/tamanho ou resolução. Prefere o lado configurado; se não houver espaço, usa o outro lado ou reduz a largura para manter o painel acessível.
- Roda do mouse funciona dentro do metadata. Ao trocar de opção, retorna ao começo; ao mudar de menu, metadata anterior é descartado.
- Um `ResizeObserver` existe apenas enquanto o metadata está visível e é removido ao fechar. Nenhum loop permanente de renderização foi acrescentado.

## Cache e consultas

`bridge/settings.lua` é o provider autoritativo de **dois domínios**, disponível no servidor e no cliente:

| Domínio | Dados | Chave local de cache |
|---|---|---|
| `locale` | `{ name = 'pt-br' }` | `pr_bridge_locale` (string) |
| `interface` | paleta, posições, target, interact, bubble e branding | `pr_bridge_ui_config` (tabela) |

Consulta defensiva e assinatura entre recursos:

```lua
local locale = pr_lib.cache.GetResourceState('pr_bridge', 'locale')
local visual = pr_lib.cache.GetResourceState('pr_bridge', 'interface')
local removeListener = pr_lib.cache.OnResourceState('pr_bridge', 'interface', function(config)
    -- Recebe uma cópia; nil deve ser tratado como indisponível.
end)
-- removeListener() encerra a assinatura quando não for mais necessária.
```

`pr_lib.locale()` mantém a API e aliases anteriores. As convars `pr_bridge:locale`, `locale` e `qb_locale` continuam sendo configuração/bootstrap, não state bags. O idioma escolhido é mantido em memória e publicado pelo provider; não há novo editor de idioma neste escopo.

Para caminhos internos de alta frequência, `Bridge.settings.get('interface', {})` e o cache local fornecem a tabela em memória **somente para leitura**; não a altere diretamente. Use a consulta defensiva acima para código de terceiros.

Transporte: callback de snapshot apenas na inicialização do host cliente, com até três tentativas limitadas; mudanças por evento de rede enviado pelo servidor. Consumidores hidratam via export local e recebem eventos locais. Geração/revisão rejeitam versões antigas, inclusive snapshot anterior a um reinício. Eventos de rede locais falsificados são rejeitados. Cache por si só não replica pela rede.

Consumidores mapeados e migrados: locale, configuração/host/UI nativa, Target, Interact, progresso e skillcheck. Busca nos Lua da base não encontrou os dois contratos antigos `GlobalState.pr_bridge_locale` e `GlobalState.pr_bridge_ui_config`.

**Não declarar o PR Bridge inteiramente sem state bags:** `pr_bridge_radial_current` e estados pessoais/globais em outros adaptadores continuam fora desta entrega e da aprovação solicitada.

## Persistência e desempenho

- Configuração gravada com a API existente de recuperação/backup JSON. Memória e cache só são publicados após confirmação da gravação (`true`/`1` nativos).
- Falha de gravação não anuncia a nova configuração. JSON primário inválido pode ser recuperado do backup; ambos inválidos geram diagnóstico, sem sobrescrever silenciosamente.
- ACE administrativa verificada no servidor para salvar/restaurar.
- Nenhum novo scan de jogadores/entidades, loop por frame ou gravação JSON periódica. Clonagem ocorre em snapshot/alteração administrativa, não nos leitores de interação por frame.
- Broadcast apenas quando há publicação de configuração; snapshot é pequeno e acontece por entrada/reinício do cliente. Não há benchmark de carga de 2 mil jogadores.

## Verificação e limites

- `luac55 -p` nos Lua modificados.
- 9 suítes Lua do PR Bridge aprovadas (7 regressões existentes + `settings_cache_test.lua` + `ui_config_cache_test.lua`).
- 18 suítes Lua do Forge Core aprovadas como regressão, sem alterar seu código.
- Builds Svelte e Vue aprovados. Avisos de acessibilidade/HTML preexistentes do Svelte continuam pendentes; não são erros de compilação.
- Navegador Chromium local: 32 combinações por renderer, 64 no total, resoluções 1920×1080, 1280×720, 800×600 e 640×360; ambos os lados, posições diversas, 80 campos com rótulos/valores longos e imagens. Verificados crescimento além de 300px, limites da tela, rolagem por mouse, reset, atualização da logo e fallback. Chamadas NUI e URLs de imagens simuladas; nenhum host externo acessado.
- `tests/context_ui_test.cjs` aceita caminhos de Playwright e Chromium já instalados. Não exige download de imagem ou dependência adicional de runtime.
- Nenhum restart do servidor, gravação no banco real ou alteração do JSON administrativo real durante os testes.

## Roteiro no jogo

1. Após carregar a versão atualizada do PR Bridge e dos consumidores (preferencialmente no próximo reinício planejado), confirmar menu com metadata longo e veículo/imagem; rolar até o último campo.
2. Conferir ambos os lados nas posições globais e mudar resolução.
3. Colar URL PNG HTTPS em Logo da cidade; abrir menus de recursos diferentes e conferir a mesma logo.
4. Testar URL vazia e link de imagem indisponível: devem usar a imagem padrão.
5. Reconectar e confirmar persistência de logo, cores e posições. Conferir idioma e notificações dos consumidores.
6. Testar Target, Interact, barra de progresso e skillcheck, pois passaram a ler a configuração em cache.
7. Aprovar a entrega somente após esse teste; migração dos demais state bags do PR Bridge permanece uma etapa separada.
