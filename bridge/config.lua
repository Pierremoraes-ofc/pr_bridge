ConfigBridge = {
    ---Resources are checked sequentially. So if you want to prioritize a specific bridge then put it higher in the list.

    frameworks = {
        { resource = "core", folder = "tmc" },
        { resource = "ND_Core", folder = "nd" },
        { resource = "ox_core", folder = "ox" },
        { resource = "es_extended", folder = "esx" },
        { resource = "qbx_core", folder = "qbx" },
        { resource = "qbx-core", folder = "qbx" },
        { resource = "qb-core", folder = "qb" }
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
        { resource = "qb-inventory", folder = "qb" }
    },

    notifications = {
        { resource = "ox_lib", folder = "ox_lib" },
        { resource = "okokNotify", folder = "okok" },
        { resource = "mythic_notify", folder = "mythic" },
        { resource = "pNotify", folder = "pnotify" },
        { resource = "17mov_Hud", folder = "hud17" },
        { resource = "codem-notification", folder = "codem_notification" },
        { resource = "es_extended", folder = "esx" },
        { resource = "qb-core", folder = "qb" }
    },

    menus = {
        { resource = "ox_lib", folder = "ox_lib" }
    },

    targets = {
        { resource = "ox_target", folder = "ox" },
        { resource = "core_focus", folder = "core_focus" },
        { resource = "qb-target", folder = "qb" }
    },


    textui = {
        { resource = "ox_lib", folder = "ox_lib" },
        { resource = "jg-textui", folder = "jg" },
        { resource = "okokTextUI", folder = "okok" },
        { resource = "cd_drawtextui", folder = "cd" },
        { resource = "codem-textui", folder = "codem" },
        { resource = "brutal_textui", folder = "brutal" }
    },

    banking = {
        { resource = "Renewed-Banking", folder = "renewed" },
        { resource = "qb-banking", folder = "qb_banking" },
        { resource = "okokBanking", folder = "okok" },
        { resource = "tgiann-bank", folder = "tgiann" },
        { resource = "kartik-banking", folder = "kartik" },
        { resource = "fd_banking", folder = "fd" }
    },
    phones = {
        { resource = "qs-smartphone-pro", folder = "qs_smartphone" },
        { resource = "lb-phone", folder = "lb_phone" },
        { resource = "okokPhone", folder = "okok_phone" },
        { resource = "yseries", folder = "y_phone" }
    },

    progressbar = {
        { resource = "ox_lib", folder = "qbx" }, -- Using qbx folder as it implements ox_lib progress
        { resource = "qb-core", folder = "qb" },
        { resource = "es_extended", folder = "esx" }
    },

    weather = {
        { resource = "Renewed-Weathersync", folder = "renewed" },
        { resource = "cd_easytime", folder = "cd_easytime" },
        { resource = "qb-weathersync", folder = "qb" },
        { resource = "default", folder = "default" }
    },

    database = {
        { resource = "oxmysql", folder = "oxmysql" },
        { resource = "ghmattimysql", folder = "ghmattimysql" },
        { resource = "mysql-async", folder = "mysql_async" }
    },

    fuel = {
        { resource = "cdn-fuel", folder = "cdn" },
        { resource = "lc_fuel", folder = "lc_fuel" },
        { resource = "LegacyFuel", folder = "legacyfuel" }
    },

    vehicle_key = {
        { resource = "mm_carkeys", folder = "mm_carkeys" },
        { resource = "mri_Qcarkeys", folder = "mri_Qcarkeys" },
        { resource = "qb-vehiclekeys", folder = "qb-vehiclekeys" },
        { resource = "qbx_vehiclekeys", folder = "qbx_vehiclekeys" },
        { resource = "wasabi_carlock", folder = "wasabi_carlock" }
    }
}

Config = {
    Debug = false,
    Framework = "auto", -- auto | custom | resource/folder name
    Database = "auto",
    VersionCheck = true,
    Fivem = {
        VehiclePropertiesStateBag = false,
        VehiclePropertiesBroadcastFallback = false,
    },
    OxCirclePosition = "bottom"
}
