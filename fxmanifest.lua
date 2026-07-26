name          "pr_bridge"
description   "Adicione compatibilidade com frameworks, targets, inventarios, notificacoes, telefones e mais."
version       "1.0.9"
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
    "bridge/init.lua",
    "bridge/notifications/cl_events.lua",
}

server_scripts {
    "bridge/version.lua",
    "interface/server/config.lua",
}

client_scripts {
    "interface/client/host.lua",
}

ui_page "interface/loader/index.html"

files {
    "init.lua",
    "bridge/**/*.lua",
    "bridge/**/**/*.lua",
    "bridge/**/*.json",
    "interface/client/**/*.lua",
    "interface/data/*.json",
    "interface/loader/index.html",
    "interface/dist/vue/index.html",
    "interface/dist/vue/assets/*.js",
    "interface/dist/vue/assets/*.css",
    "interface/dist/vue/assets/*.svg",
    "interface/dist/vue/assets/*.webp",
    "interface/dist/svelte/index.html",
    "interface/dist/svelte/assets/*.js",
    "interface/dist/svelte/assets/*.css",
    "interface/dist/svelte/assets/*.svg",
    "interface/dist/svelte/assets/*.webp",
}
