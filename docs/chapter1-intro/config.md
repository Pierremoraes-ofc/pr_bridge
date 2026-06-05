# O Arquivo config.lua

Localizado em `bridge/config.lua`, este arquivo é o cérebro de detecção do `pr_bridge`.

Ele define as matrizes de ordem de carregamento. O `pr_bridge` checará se os resources definidos nas tabelas estão iniciados (`started`), operando sempre de **cima para baixo**.

### Estrutura Base
```lua
ConfigBridge = {
    frameworks = {
        { resource = "ND_Core", folder = "nd" },
        { resource = "ox_core", folder = "ox" },
        { resource = "es_extended", folder = "esx" },
        -- ...
    },
    -- ...
}
```

Se o seu servidor roda `qb-core` junto com o `qbx_core`, e você deseja forçar que a engine priorize o QB-Core, basta inverter a ordem dessa lista.

### Configurações Globais (`Config`)
No final do arquivo, você encontrará as diretrizes absolutas de configuração:

```lua
Config = {
    Debug = false,
    Database = "auto",
    VersionCheck = false,
    Fivem = {
        VehiclePropertiesStateBag = false,
        VehiclePropertiesBroadcastFallback = false,
    },
    OxCirclePosition = "bottom"
}
```

* **Debug**: Ativa outputs detalhados no F8/Console do que está sendo detectado ou resolvido.
* **Database**: Pode ser deixado em `"auto"` (para descobrir sozinho), ou forçado em strings como `"oxmysql"`, `"ghmattimysql"`, etc.
* **Fivem.VehiclePropertiesStateBag**: Envio de modificações de veículos através de StateBags. Por padrão é `false` porque o bridge envia as modificações de forma eficiente diretamente via evento ao Network Owner, mas você pode ativar se houver necessidade (fallbacks).
* **Fivem.VehiclePropertiesBroadcastFallback**: Permite fallback broadcast quando as props do veículo falham.
* **OxCirclePosition**: Posição padrão para o timer em anel (se usar `ox_lib` para progresso).
