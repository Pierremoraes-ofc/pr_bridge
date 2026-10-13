# Revisao do target nativo - 21/09/2026

## Escopo e evidencias

Revisados adapter client, API de cadastro, zonas, compatibilidade qtarget, pickups, runtime client/server, defaults, mensagens da interface e registros de teste de hidrantes/pickups do PRScriptTest. O log local CitizenFX_log_2026-09-21T031844.log confirma a inicializacao do runtime; o usuario informa ausencia de erros no F8/server.

As falhas descritas nao foram reproduzidas em um cliente FiveM controlado pelo agente. Os resultados abaixo sao de Lua 5.4 com natives simuladas e execucao dos arquivos reais de API, zonas e runtime, usando agendador de corrotinas.

## Correcoes desta revisao

- Descoberta de marcadores inclui NPCs, veiculos, entidades locais/de rede, modelos, opcoes globais e pickups registrados. Antes, apenas modelos em CObject eram pesquisados. Candidatos continuam sujeitos a permissao, proximidade e obstrucao.
- No maximo quatro sondagens compartilhadas ficam pendentes; resultados anteriores sao consumidos antes de novas consultas e os candidatos aguardam em ordem. Uma sondagem independente continua exigida no clique.
- Fechar o target drena handles pendentes. O teste com fila limitada mostrou degradacao apos fechar/reabrir sem esta limpeza; com a limpeza, nao houve handles recusados nem resultados invalidos no cenario.
- Cada abertura possui uma geracao. Corrotinas antigas nao podem limpar a interface, continuar renderizando nem executar o clique de uma nova abertura.
- Desabilitar o target limpa foco, marcadores e opcoes, mesmo quando a API ja marcou o estado como inativo antes de emitir o evento.
- canInteract tem a mesma semantica Lua para marcadores e opcoes. A selecao tambem rejeita zonas removidas durante a espera.
- Resultado valido de visibilidade tem validade limitada a 1 segundo enquanto aguarda atualizacao; obstrucao confirmada bloqueia imediatamente ao ser recebida. Clique sem confirmacao nova nao executa a acao.

Nao foram alteradas coordenadas do MLO, permissoes, tolerancia de superficie (2,5 cm) ou distancias configuradas.

## Validacao executada

Comando local: python .tmp/target-audit/run.py

- Sintaxe dos nove arquivos do target nativo e dos dois produtores de zonas de empregos (11 arquivos).
- Cadastro real de box zone, objeto por modelo, NPC local e veiculo de rede: quatro marcadores apos aquecimento.
- Eventos de tecla, foco NUI, sondagem nova e dispatch: uma execucao de onSelect.
- Abertura/fechamento rapido, parede fechando com foco e reabrindo, marcadores com mira fora dos alvos.
- 32 candidatos simultaneos com fila de natives limitada: sem sondagens recusadas, ate 24 marcadores conforme configuracao.
- Desabilitar/habilitar novamente, limpeza de foco e comando de diagnostico.

Os arquivos de teste e backups ficam em .tmp/target-audit. Testes anteriores que extraem funcoes isoladas nao substituem este teste integrado.

## Aplicacao e teste no FiveM

Recarregar a base de forma controlada para restabelecer os cadastros dos recursos dependentes do PR Bridge. O agente nao reiniciou a base.

1. Na sala, segurar ALT com os pontos dentro do campo de visao, sem mirar diretamente neles; conferir os icones a ate 5 m conforme configuracao atual.
2. Aproximar-se ate 2 m dos pontos dos empregos, mirar, abrir opcoes e clicar.
3. Conferir hidrante, NPC/veiculo e pickups do PRScriptTest quando cadastrados.
4. Fechar/reabrir ALT repetidamente; conferir que marcadores e opcoes voltam sem degradacao.
5. Repetir pelo lado de fora da parede; uma obstrucao deve impedir o clique.

Se falhar, executar pr_targetdiag no F8, fechar F8 e manter ALT pressionado na frente dos alvos por 5 segundos. Copiar a unica linha [pr_bridge:target:diag]. Ela registra amostras ativas, zonas proximas, candidatos, maximo renderizado e resultados clear/blocked/invalid/pending; esses contadores sao amostras, nao alvos unicos. O comando nao altera permissoes ou configuracao nem libera interacao.


## Correcao orientada pelo log anexado (captura 573031)

A captura enviada registra: samples=49 active=24 zonesNearby=6 entityCandidates=2 zoneCandidates=4 maxRendered=0 clear=0 blocked=0 invalid=118 pending=22. Sao amostras acumuladas de estados, nao 118 alvos. Ela confirma cadastro de candidatos e ausencia de conclusoes validas de visibilidade. Nao permite distinguir sozinha status nativo 0 de timeout da implementacao anterior.

Substituida a fila de handles assincronos somente da verificacao de visibilidade do target por StartExpensiveSynchronousShapeTestLosProbe + leitura imediata. No maximo duas verificacoes de fundo por atualizacao; clique explicito faz uma verificacao independente. A native e mais custosa e seu custo real deve ser conferido em jogo. Mantidos flags de colisao, origem no personagem, contato de superficie e bloqueio em falha. A rotina de mira existente nao foi alterada.

A documentacao oficial confirma que essa native bloqueia ate concluir o teste e alerta sobre custo: https://github.com/citizenfx/natives/blob/master/SHAPETEST/StartExpensiveSynchronousShapeTestLosProbe.md

Novo teste de regressao faz as natives assincronas retornarem invalidas: a versao anterior falha com 63 atualizacoes vazias e zero marcadores; a versao corrigida passa com quatro tipos cadastrados. Tambem passam 32 candidatos, limite de consultas por tick, paredes, foco, clique e retorno invalido da propria consulta sincrona (nao executa acao). Nenhum teste local representa a execucao das natives reais do cliente.

A linha pr_targetdiag agora inclui mode=sync para identificar a implementacao carregada. Se persistir, comparar clear/blocked/invalid e maxRendered nessa captura. Esta revisao substitui a fila/limite de quatro handles e drenagem descritos anteriormente; nao existem mais handles assincronos de visibilidade mantidos entre frames pelo target.
