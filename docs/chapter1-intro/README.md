# Instalação e Integração

A instalação do `pr_bridge` é extremamente simples.

### 1. Inserindo no Servidor
Coloque a pasta `pr_bridge` dentro da pasta de `resources`.
No seu `server.cfg`, garanta que ele seja iniciado **antes** de qualquer outro recurso que vá consumir sua API.

```cfg
ensure pr_bridge
ensure meu_script
```

### 2. Importando no seu Script
Para que a global `pr_lib` fique disponível no seu código, adicione o arquivo de inicialização da bridge no `fxmanifest.lua` do seu script:

```lua
shared_scripts {
    "@pr_bridge/init.lua",
}
```

Isso fará com que tanto os scripts de Client quanto os de Server do seu resource reconheçam os objetos `pr_lib`.
