# Consolidação das 202 entradas de API

PR Bridge **1.4.2** · referência local **ox_lib 3.38.0** · **311 entradas catalogadas** · **202 anteriormente pendentes** · revisão **10/10/2026**.

As 202 entradas foram expostas e consolidadas. O catálogo agora contém 311 entradas encaminhadas e nenhuma pendente de consolidação. Isso **não significa 311 funções homologadas no FiveM**: incluem métodos, aliases, fábricas e objetos retornados. A homologação de rede, GLM/CFX e renderização continua pendente.

## Implementar uma vez

| Grupo | Destino / reutilização |
| --- | --- |
| Classes e coleções | `library.class`, `collections.array/map/set/heap/lru/ringbuffer/selector`; implementação única, agora pública também para scripts PR |
| Callbacks | `bridge/callback/transport.lua`; chamadas PR e ox usam o mesmo motor de pedidos, deadlines, respostas, ownership do destino e registros. Apenas os envelopes/throttle diferem |
| DUI | Fachada `entities.dui` chama o motor existente `fivem.dui.create/destroy/setUrl/send*`; não cria outro renderer |
| Entidades | Classes `entities.gameEntity/ped/prop/vehicle/player`; criação cliente delega ao streaming existente; estado usa helpers/política nativos |
| Zonas | Registro canônico `fivem/zones/shared`; substitui a implementação parcial anterior, preservando geometria GLM, consultas e debug. `pr_lib.zones` e `lib.zones` acessam esse registro; a fachada PR preserva `nearby`, defaults anteriores e limites `minZ/maxZ` |
| Arquivos | `library.require/load/loadJson`; resolução/cache por consumidor; compilação/JSON reutilizam `PRCore.loadFile/loadJson` |
| Localização | Dicionário/tradutor do consumidor + `localeSettings`; nenhum polling/export extra para traduzir textos |
| Demais grupos | APIs nativas únicas de hooks, grid, cron, logger/providers, print, markers, scaleform, UUID e coordenadas relativas |
| Serviços/lacunas | `lib.cache/hasLoaded`, identificação e `timer:run`; foco NUI e callbackRegistry nativos |

Nos grupos sem equivalente completo anterior, os algoritmos passam a pertencer à biblioteca PR e são utilizados tanto pelo desenvolvimento novo quanto pelo legado. Não há uma cópia ativa em `imports`: ali restam aliases e adaptações. Direitos/créditos/licenças das implementações derivadas foram preservados. O motor anterior de zonas e o motor paralelo de callbacks foram retirados, não mantidos ao lado da nova API.

Os **71 arquivos** de imports, incluindo adaptações de protocolo e providers, apontam para implementação canônica. Os globals `SetInterval/ClearInterval` também delegam ao scheduler nativo. Cada ambiente de recurso mantém a instância/ownership necessários; não se compartilham globals do consumidor com outros recursos.

## Uso nativo sem quebrar contratos antigos

```lua
-- No manifesto do consumidor: shared_script '@pr_bridge/init.lua'
local api = pr_lib.library
local entries = pr_lib.collections.map:new()
entries:set('documento', { numero = 'FORGE-001' })

local selected = api.array:new('a', 'b', 'c'):slice(2)
local vehicle = pr_lib.entities.vehicle:new(entityHandle)
print(vehicle:getPlate())
```

Scripts antigos continuam usando `lib.map:new`, `lib.vehicle:new`, `lib.callback.await`, etc. Não se substituiu o significado de `pr_lib.player` (adapter do framework), `pr_lib.locale` ou `pr_lib.load`. As classes de entidades e o loader com contrato completo ficam nos namespaces explícitos acima. `lib.locale()` carrega traduções; `locale(key)` / `api.translate(key)` traduzem o dicionário.

Callbacks PR mantêm timeout como argumento; callbacks ox mantêm throttle no cliente e destino no servidor. Essa diferença é adaptada na borda, não ignorada.

## Correções durante a consolidação

- Lacunas de exposição de cache/hasLoaded e métodos do timer.
- Loader limpa o sentinel após erro; permite tentar novamente sem falso erro circular.
- Hooks sem filtro executam; IDs não são reutilizados após remoção.
- `array:map` reutiliza o utilitário nativo em modo ordenado; `reduce` preserva valor inicial `false`.
- Selector preserva resultados `false`; grid invalida também o cache da célula.
- UUID valida corretamente os bits de variante; zonas usam IDs monotônicos e desligam debug corretamente.
- Cron calcula o último dia com `day=0`, executa deadlines atuais/atrasados permitidos e invalida gerações canceladas.
- Foco NUI respeita ownership e restaura keepInput; callbacks nativos expiram também pedidos não-await e validam o jogador de resposta.

## Verificação e roteiro de teste

- `tests/native_library_test.lua`: exposição das 202 entradas nos respectivos contextos, aliases nativo/legado, comportamentos representativos e delegação DUI/streaming com spies.
- `tests/ox_compat_test.lua`: bootstrap/host, callbacks (retornos nil, throttle, timeout, resposta correta), ownership/exports, coexistência, UI, estado, streaming e filas nativas.
- `tests/ox_public_api_catalog_test.mjs`: cobertura do catálogo da referência, herança/contexto/aliases e documento gerado.
- `scripts/audit_ox_compat.mjs`: hashes dos módulos canônicos e imports; rejeita reintrodução de `ox_services`.

Para homologar, use uma cidade de testes, PR como fornecedor e ox original parado. Valide dois jogadores, timeout/desconexão, state bags com/sem autorização, criação de entidades, DUI/scaleform, zonas côncavas/altura/rotações/debug e remoção/reinício de consumidores. Teste cron, arquivos/locales reais e providers HTTP com credenciais de teste.

Os testes offline usam Lua 5.5 com normalização em memória das extensões CFX. As doubles de geometria verificam ligações/formas básicas, não substituem GLM real. Não houve medição resmon, início/reinício de produção, alteração dos cores, alteração da referência ox_lib ou mudança da ordem de boot.
