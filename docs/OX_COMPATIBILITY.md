# Compatibilidade ox no pr_bridge

Atualizado em 2026-08-19.

## Objetivo

Permitir a migracao gradual de recursos que usam ox_lib e ox_target para a implementacao nativa do pr_bridge, preservando nomes, argumentos e retornos.

A camada e carregada automaticamente por @pr_bridge/init.lua.

## Acesso

- pr_lib.ox e pr_lib.ox_lib: API compativel do ox_lib.
- pr_lib.ox_target e pr_lib.ox.target: API compativel do ox_target.
- lib: instalado automaticamente quando nenhum outro lib existe no ambiente.
- setr pr_bridge:ox_compat:force true: substitui um lib preexistente somente durante homologacao controlada.

Enquanto o ox_lib real estiver carregado no consumidor, ele e preservado por padrao. Isso permite migrar um recurso por vez.

O `lib` preexistente agora e capturado diretamente do ambiente do recurso consumidor e repassado ao instalador de compatibilidade. Isso evita que o ambiente interno do loader substitua por engano o `ox_lib` real e preserve funcoes ainda nao migradas, como `lib.checkDependency`, `lib.callback`, `lib.addCommand` e `lib.onCache`.

Quando um recurso ainda usa ambos, carregue `@ox_lib/init.lua` antes de `@pr_bridge/init.lua` e inclua cada init apenas uma vez no manifesto.

## Etapa 1 implementada

### ox_target

- Opcoes globais para objeto, ped, player, veiculo e universais.
- Modelos, entidades de rede e entidades locais.
- Zonas sphere, box e poly, consulta e remocao.
- disableTargeting, isActive, getTargetOptions e inspectModels.

As chamadas aceitam ponto ou dois-pontos. Exemplo:

    local zoneId = pr_lib.ox_target:addSphereZone({
        coords = GetEntityCoords(PlayerPedId()),
        radius = 1.5,
        options = {{ name = 'example', label = 'Interagir', onSelect = function()
            pr_lib.ox.notify({ description = 'Executado pelo pr_bridge.' })
        end }},
    })

O runtime nao pode criar um recurso virtual chamado ox_target. Chamadas exports.ox_target devem ser trocadas por pr_lib.ox_target, lib.target ou pelos exports equivalentes de pr_bridge. A logica e os formatos permanecem compativeis.

### Interfaces ox_lib

- alertDialog e setClipboard.
- registerContext, showContext, hideContext e getOpenContextMenu.
- inputDialog.
- registerMenu, showMenu, hideMenu e getOpenMenu.
- notify.
- progressBar, progressCircle, progressActive e cancelProgress.
- addRadialItem, removeRadialItem, clearRadialItems, registerRadial, hideRadial, disableRadial e getCurrentRadialId.
- skillCheck e cancelSkillCheck.
- showTextUI, hideTextUI e isTextUIOpen.

Todos executam os modulos nativos/Svelte do pr_bridge. Nenhuma NUI ou logica de target e duplicada.

## Teste

- /pr_ox_compat_test: abre a matriz visual da etapa 1.
- /pr_ox_compat_cleanup: remove zona e item radial temporarios.

## Proximas etapas

1. callbacks, cache, intervalos, locale, require/load e classes.
2. entidades proximas, streaming, propriedades de veiculo e raycast.
3. comandos, keybinds, ACE, logger, versao e utilitarios.
4. auditoria final dos usos lib.* antes da remocao do ox_lib.
