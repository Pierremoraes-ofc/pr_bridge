# Interface web (Vue)

## Desenvolvimento

```bash
cd interface/web
npm install
npm run build
```

O build Vite gera em `interface/dist/`.

## Runtime FiveM

O resource serve `interface/dist/` via `ui_page`. Há um bundle pronto (`app.js` + Vue global) para funcionar sem npm no ambiente de build.

A fonte SFC em `src/` é o template oficial — ao trocar para Svelte no futuro, mantenha o contrato NUI (`action` / callbacks) e só substitua a pasta `web/`.
