ConfigBridge = {
	---Resources are checked sequentially. So if you want to prioritize a specific bridge then put it higher in the list.

	frameworks = {
		{ resource = "core", folder = "tmc" },
		{ resource = "ND_Core", folder = "nd" },
		{ resource = "ox_core", folder = "ox" },
		{ resource = "es_extended", folder = "esx" },
		{ resource = "qbx_core", folder = "qbx" },
		{ resource = "qbx-core", folder = "qbx" },
		{ resource = "qb-core", folder = "qb" },
	},

	inventories = {
		{ resource = "ox_inventory", folder = "ox" },
		{ resource = "tgiann-inventory", folder = "tgiann" },
		{ resource = "core_inventory", folder = "core" },
		{ resource = "ps-inventory", folder = "ps" },
		{ resource = "ak47_inventory", folder = "ak47" },
		{ resource = "jaksam_inventory", folder = "jaksam" },
		{ resource = "qs-inventory", folder = "quasar" },
		{ resource = "codem-inventory", folder = "codem" },
		{ resource = "minventory", folder = "codem" },
		{ resource = "origen_inventory", folder = "origen" },
		{ resource = "qb-inventory", folder = "qb" },
	},

	notifications = {

		{ resource = "ox_lib", folder = "ox_lib" },
		{ resource = "okokNotify", folder = "okok" },
		{ resource = "mythic_notify", folder = "mythic" },
		{ resource = "pNotify", folder = "pnotify" },
		{ resource = "17mov_Hud", folder = "hud17" },
		{ resource = "codem-notification", folder = "codem_notification" },
		{ resource = "es_extended", folder = "esx" },
		{ resource = "qb-core", folder = "qb" },
	},

	menus = {
		{ resource = "ox_lib", folder = "ox_lib" },
	},

	targets = {
		{ resource = "ox_target", folder = "ox" },
		{ resource = "core_focus", folder = "core_focus" },
		{ resource = "qb-target", folder = "qb" },
		{ resource = "pr_bridge", folder = "native" },
	},

	textui = {
		{ resource = "ox_lib", folder = "ox_lib" },
		{ resource = "jg-textui", folder = "jg" },
		{ resource = "okokTextUI", folder = "okok" },
		{ resource = "cd_drawtextui", folder = "cd" },
		{ resource = "codem-textui", folder = "codem" },
		{ resource = "brutal_textui", folder = "brutal" },
	},

	banking = {
		{ resource = "Renewed-Banking", folder = "renewed" },
		{ resource = "qb-banking", folder = "qb_banking" },
		{ resource = "okokBanking", folder = "okok" },
		{ resource = "tgiann-bank", folder = "tgiann" },
		{ resource = "kartik-banking", folder = "kartik" },
		{ resource = "fd_banking", folder = "fd" },
	},
	phones = {
		{ resource = "qs-smartphone-pro", folder = "qs_smartphone" },
		{ resource = "lb-phone", folder = "lb_phone" },
		{ resource = "okokPhone", folder = "okok_phone" },
		{ resource = "yseries", folder = "y_phone" },
	},

	progressbar = {
		{ resource = "pr_bridge", folder = "native" }, -- Native Svelte progress; ox_lib-compatible API
		{ resource = "ox_lib", folder = "qbx" }, -- Using qbx folder as it implements ox_lib progress
		{ resource = "qb-core", folder = "qb" },
		{ resource = "es_extended", folder = "esx" },
	},

	minigames = {
		{ resource = "glitch-minigames", folder = "glitch" },
		{ resource = "glitch-minigame", folder = "glitch" },
		{ resource = "mhacking", folder = "mhacking" },
		{ resource = "ox_lib", folder = "ox_lib" },
	},

	weather = {
		{ resource = "Renewed-Weathersync", folder = "renewed" },
		{ resource = "cd_easytime", folder = "cd_easytime" },
		{ resource = "qb-weathersync", folder = "qb" },
		{ resource = "default", folder = "default" },
	},

	database = {
		{ resource = "oxmysql", folder = "oxmysql" },
		{ resource = "ghmattimysql", folder = "ghmattimysql" },
		{ resource = "mysql-async", folder = "mysql_async" },
	},

	fuel = {
		{ resource = "cdn-fuel", folder = "cdn" },
		{ resource = "lc_fuel", folder = "lc_fuel" },
		{ resource = "LegacyFuel", folder = "legacyfuel" },
	},

	vehicle_key = {
		{ resource = "mm_carkeys", folder = "mm_carkeys" },
		{ resource = "pr_carkeys", folder = "pr_carkeys" },
		{ resource = "mri_Qcarkeys", folder = "mri_Qcarkeys" },
		{ resource = "qb-vehiclekeys", folder = "qb-vehiclekeys" },
		{ resource = "qbx_vehiclekeys", folder = "qbx_vehiclekeys" },
		{ resource = "wasabi_carlock", folder = "wasabi_carlock" },
	},
}

Config = {
	ui_interface = "svelte", -- svelte | vue | alterne entre as interfaces desejada
	Debug = false,
	Framework = "auto", -- auto | custom | resource/folder name
	Database = "auto",
	Target = "native", -- auto | native | ox | core_focus | qb
	compatOx_lib = true, -- true = instala o adaptador ox_lib; false = nao carrega host, imports, eventos, exports ou aliases lib do compat.
	-- Alterar exige reiniciar pr_bridge e consumidores (preferencialmente a cidade).
	-- provide('ox_lib') / provide('ox_target') no manifest sao declaracoes estaticas:
	-- com false e bibliotecas originais, comente os provide correspondentes no manifest.
	compatFramework = 'forge', -- Destino: forge/auto (backend ativo), qbx, qb, esx, nd, ox, tmc, custom, default; false = desliga.
	compatQBCore = true, -- Origem QB: preserva QB/QBX nativo; fachada redireciona nos demais destinos.
	compatQBAccounts = { cash = 'cash', bank = 'bank' }, -- carteiras reais no adaptador selecionado.
	compatQBConfig = {}, -- campos legados opcionais; nao copia credenciais/configuracao privada do core.
	-- Contas ESX sem equivalente exigem mapeamento explicito (nao inventa black_money).
	compatESXAccounts = { money = 'cash', bank = 'bank' },
	-- Opcional, apenas quando dois itens nativos representam o mesmo componente:
	-- { WEAPON_PISTOL = { flashlight = 'at_flashlight' } }. O hash e validado.
	compatESXComponentItems = {},
	-- APIs auxiliares com contrato normalizado. Nunca aponta AddItems para AddItem:
	-- AddItems registra DEFINICOES; AddItem entrega uma unidade ao jogador.
	-- Cada entrada: false (desliga) ou { resource='meu_adapter', export='MinhaFuncao' }.
	-- Consulte bridge/frameworks/COMPAT.md para assinaturas e exemplos.
	compatServices = { frameworks = {}, inventories = {} },
	compatCommitJobs = false, -- somente QBX sem registry auxiliar: persiste em shared/jobs.lua quando true.
	compatMetadata = { ssn = 'ssn' }, -- SSN real; nunca substituido por citizenid/license.
	compatPickupAccounts = { money = 'money' }, -- banco/contas extras exigem item equivalente explicito.
	compatDiscordWebhookConvars = {}, -- { canal = 'meu_discord_webhook' }; URL em convar privada (set, nunca setr).
	VersionCheck = true,
	Fivem = {
		VehiclePropertiesStateBag = false,
		VehiclePropertiesBroadcastFallback = false,
	},
	OxCirclePosition = "bottom",
}
