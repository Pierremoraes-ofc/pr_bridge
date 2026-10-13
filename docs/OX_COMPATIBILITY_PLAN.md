# ox_lib / ox_target compatibility

Status: public compatibility implementation and offline validation completed; FiveM end-to-end validation pending. PR Bridge 1.4.2 / ox_lib contract 3.38.0. See [the activation and validation guide](OX_COMPATIBILITY.md).

## Contract and scope

- Baseline: the local ox_lib 3.38.0, including its additional utility modules.
- ox_target baseline: the public Overextended client API; no original ox_target resource was found in this checkout.
- Keep PR Bridge's native APIs, Interact controls, consumer resources and server startup configuration unchanged.
- Preserve original libraries while they are running. Do not silently replace their exports.
- Never claim compatibility from matching names alone: parameters, return values, ownership, cleanup and callback protocols must also match.

## Architecture decision

Use FiveM's resource `provide` metadata for the legacy resource names, and register legacy export discovery handlers inside PR Bridge. The manifest alias alone does not register exports under a second name. No additional compatibility resource is required.

Native-first rule: use existing PR methods and adapt parameters/results only. Add missing capabilities to native modules, never to a parallel ox service engine. The 2026-10-10 revision removes all nine duplicate ox_services sources and redirects 32 import files to native PR modules. Preserve consumer-local loading and legacy wire protocols; callbacks cannot be blindly aliased because native PR and ox signatures/wire names differ. Retain upstream attribution for genuinely distinct legacy contracts. Visual APIs must use PR's renderer.

An inventory entry is not proof of native forwarding: remaining legacy-specific class/collection/zone contracts are explicitly distinguished from native routes. See [the architecture review](OX_NATIVE_ROUTING_REVIEW.md).

References:

- https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#provide
- https://github.com/citizenfx/fivem/blob/master/code/components/citizen-resources-core/src/ResourceManager.cpp
- https://github.com/citizenfx/fivem/blob/master/data/shared/citizen/scripting/lua/scheduler.lua
- https://github.com/overextended/ox_target/blob/main/client/api.lua

## Execution and acceptance gates

1. Inventory all utility modules and resource exports from the installed baseline; record source hashes.
2. Add independently loadable utility modules, preserving ox callback wire protocol and consumer-local globals without changing `pr_lib.callback`.
3. Complete native visual contracts, including menu selection/side scrolling/check states, dialog cancellation and active-state getters.
4. Add internal legacy exports, provider bootstrap, cache/locale/callback services and native target ownership handling.
5. Run offline contract tests (client/server, cancellation, nil returns, original-resource coexistence, owner cleanup and export discovery), syntax checks and existing regressions.
6. In FiveM, test original resources running and stopped separately: untouched manifests importing `@ox_lib/init.lua`, direct ox_lib/ox_target exports, UI, callbacks, vehicle state and resource restarts. Only after this gate should the old resources be removed from startup.

## Explicit limits to verify

- Custom scripts reading resource version metadata directly see the provider's manifest version; `lib.checkDependency` must handle the ox_lib contract version explicitly.
- Loading undocumented private files, the old frontend or arbitrary internal NUI events is not a public API compatibility guarantee.
- Runtime hot-switching between original and provider resources requires consumer restarts because FiveM caches export references.
- JS/C# export consumers and network/state-bag behavior need an actual FiveM smoke test; offline mocks are not a substitute.

## Execution evidence

Gates 1–5 were executed: 71 import files, 59 modules, 63 top-level symbols, 49 resource-export names and 33 locale files are inventoried. The read-only auditor verifies provider hashes. 95 shared/context import compositions and integration files pass normalized Lua syntax checks. Mocked contracts cover boot, untouched legacy imports, callback wire protocol/nil slots, ownership, global UI state, menu lifecycle, radial callbacks, target shapes and progress cancellation/cleanup.

Svelte and Vue builds pass. Browser tests cover keyboard forwarding and long-list scrolling, modal priority, notifications, progress, radial, target and skillcheck. Existing Context/Interact/Target/scroll/perspective/config regressions pass. The Lua runner is 5.5 with CFX-only syntax normalized in memory; this is not actual CFX Lua 5.4 compilation. Gate 6 remains open and must not be reported as passed.

No consumer resource, framework core, startup configuration or original ox resource was edited or stopped. The remaining runtime checklist and metadata/private-path constraints are explicit in the guide.
