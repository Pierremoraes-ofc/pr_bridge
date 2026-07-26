# pr_bridge interface

Este diretorio possui duas versoes da NUI e um loader que escolhe qual abrir pelo `Config.ui_interface`:

- `web`: versao Vue original, mantida por compatibilidade.
- `vue`: copia separada da versao Vue para quem quiser usar Vue.
- `svelte`: versao Svelte com a mesma estrutura de pastas e eventos NUI.
- `loader`: pagina fixa usada no `fxmanifest.lua`; ela abre `dist/vue` ou `dist/svelte`.

Para escolher a interface em runtime, altere em `bridge/config.lua`:

```lua
ui_interface = 'svelte', -- svelte | vue
```

Cada interface compila para uma pasta propria. Rode uma vez em cada pasta quando quiser distribuir as duas:

```bash
cd interface/vue
npm install
npm run build

cd ../svelte
npm install
npm run build
```

O Vue gera em `interface/dist/vue` e o Svelte gera em `interface/dist/svelte`. Depois disso, basta trocar `ui_interface` sem sobrescrever builds.

Se a interface escolhida ainda nao tiver `index.html` compilado, o loader usa `vue` como fallback para evitar tela vazia.
