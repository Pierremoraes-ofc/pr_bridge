name("pr_bridge")
description("Adicione compatibilidade com frameworks, targets, inventarios, notificacoes, telefones e mais.")
version("1.4.2")
repository("https://github.com/Pierremoraes-ofc/pr_bridge")
author("Pierremoraes-ofc")

fx_version("cerulean")
game("gta5")
lua54("yes")

-- Static replacement identities: keep enabled for this base (compatOx_lib=true).
-- When using original ox_lib/ox_target with compatOx_lib=false, comment the
-- matching provide entries too: the manifest cannot read runtime Config.
provide("ox_lib")
provide("ox_target")
-- ESX facade: comment this alias when starting the original es_extended core.
provide("es_extended")
-- QBX already provides qb-core in this base. Do NOT enable a second alias here.
-- For an ESX/ND/Ox destination without QB/QBX, uncomment for legacy dependencies:
-- provide("qb-core")

use_experimental_fxv2_oal("yes")

shared_scripts({
	"bridge/core.lua",
	"bridge/locale.lua",
	"bridge/config.lua",
	"bridge/debug.lua",
	"bridge/init.lua",
	"bridge/player_lifecycle.lua",
	"bridge/notifications/cl_events.lua",
})

server_scripts({
	"bridge/version.lua",
	"bridge/notifications/bubble_server.lua",
	"bridge/targets/native/runtime_server.lua",
	"interface/server/config.lua",
	"bridge/compat/loader.lua",
})

client_scripts({
	"bridge/targets/native/runtime_client.lua",
	"bridge/targets/native/defaults.lua",
	"bridge/targets/native/compat_qtarget.lua",
	"bridge/interact/runtime_client.lua",
	"bridge/notifications/bubble_client.lua",
	"interface/client/host.lua",
	"bridge/compat/loader.lua",
})

ui_page("interface/loader/index.html")

files({
	"bridge/minigames/glitch/client.lua",
	"bridge/emotes/client.lua",
	"bridge/doorlock/client.lua",
	"bridge/doorlock/server.lua",
	"shared/progression.lua",
	"shared/locale.lua", -- optional @qb-core/shared/locale.lua when PR owns qb-core
	"init.lua",
	"imports.lua", -- @es_extended/imports.lua public entrypoint
	"imports/**/*.lua",
	"imports/**/**/*.lua",
	"bridge/compat/ox_lib/locales/*.json",
	"bridge/**/*.lua",
	"bridge/**/**/*.lua",
	--"bridge/**/*.json",
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
	"interface/dist/svelte/interact-assets/**/*.png",
})
