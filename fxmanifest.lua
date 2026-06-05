name          "pr_bridge"
description   "Adicione compatibilidade com frameworks, targets, inventarios, notificacoes, telefones e mais."
version       "1.0.2"
repository    "https://github.com/Pierremoraes-ofc/pr_bridge"
author        "Pierremoraes-ofc"

fx_version "cerulean"
game       "gta5"
lua54      "yes"

use_experimental_fxv2_oal "yes"

shared_scripts {
    "bridge/core.lua",
    "bridge/locale.lua",
    "bridge/config.lua",
    "bridge/debug.lua",
    "bridge/locale/*.lua",
    "bridge/init.lua",
    "bridge/notifications/cl_events.lua",
}

server_scripts {
    "bridge/version.lua",
}

files {
    "init.lua",
    "bridge/**/*.lua",
    "bridge/**/**/*.lua",
}
