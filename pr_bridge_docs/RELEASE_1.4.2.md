# PR Bridge 1.4.2 — mudanças desde 1.3.0

Resumo para o GitHub Releases, comparando a [tag oficial 1.3.0](https://github.com/Pierremoraes-ofc/pr_bridge/releases/tag/1.3.0) com o código local 1.4.2.

## Novidades

- Novas APIs de persistência JSON: backup, recuperação, locks locais, gravação em lote com tentativa de restauração e registro de incidentes.
- Cache entre recursos com `GetResourceState` e `OnResourceState`; configuração de idioma/interface em memória, com revisões e sincronização por eventos.
- Ampliação do Target nativo para pickups: registro global, por tipo e por pickup específico, também disponível na compatibilidade ox.
- NPCs animados com `placeAnimatedPed`, seleção de cenário/animação e controle das guias de posicionamento.
- Integrações para garagens de propriedades, portas, emotes e prisão; facade policial opcional e utilitário compartilhado de progressão.
- APIs de catálogo de veículos, jogador offline e prontidão de sessão QBX; perfil normalizado de telefone e consulta do aparelho ativo no Forge NPWD.
- Ampliação do Renewed Weather: snapshots, clima regional, previsão semanal e listeners; fallback nativo de combustível em standalone.
- Seleção de ambiente production/development/test e de callbacks legacy/secure, com acesso controlado às ferramentas de desenvolvimento.
- Logo da cidade configurável na interface nativa e complementação das traduções PT-BR/EN/ES/FR.

## Correções e melhorias

- Target: visibilidade/obstrução de opções e marcadores, exceções de parede e proteção contra sessões antigas após abrir/fechar rapidamente.
- Target/NUI: fechamento tardio não libera o foco da interface aberta pela ação. Interact respeita o bloqueio por parede de cada interação.
- Notificações: listener de rede centralizado no host, evitando repetições por recursos consumidores.
- Interface Svelte/Vue: metadata com altura dinâmica, rolagem e reposicionamento dentro da tela; atualização da logo e fallback de imagem.
- JSON: tratamento correto dos retornos nativos `true`/`1` e `false`/`0`, sem anunciar sucesso quando a gravação falha.
- SQL: `update` normalizado para linhas afetadas e callback aceito como segundo argumento de `transaction` nos adapters implementados.
- Comandos/ACE: normalização das permissões e aplicação da whitelist administrativa; QBX propaga o resultado de adicionar dinheiro.
- Posicionador: SHIFT + scroll ajusta a câmera sem alterar a geometria; preview de NPC animado preserva pose e referência vertical.
- Glitch: detecção do provider iniciado, diagnóstico de indisponibilidade e preparação dos recursos para Plasma Drilling.
- Catálogo atualizado com contextos, dependências, módulos opcionais, versão e total de caminhos de API documentados.

## Observações

- Target, Interact e compatibilidade ox_lib já existiam em 1.3.0; a lista descreve ampliações e correções posteriores.
- Algumas APIs dependem do adapter ou de carregamento opcional. Consulte [functions_datails.md](functions_datails.md).
- Comparação de código, não certificação de todas as integrações no FiveM; valide na sua base antes de publicar em produção.
- Base: commit `50060f3b5ddcb272d1eac0a0454937bcad87bd6e`. A tag pública é **1.3.0**, embora seu manifest ainda informe **1.2.9**; o manifest local informa **1.4.2**.
