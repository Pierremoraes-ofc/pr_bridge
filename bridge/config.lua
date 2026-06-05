ConfigBridge = {
    ---Resources are checked sequentially. So if you want to prioritize a specific bridge then put it higher in the list.

    frameworks = {
        { resource = "ND_Core", folder = "nd" },
        { resource = "ox_core", folder = "ox" },
        { resource = "es_extended", folder = "esx" },
        { resource = "qbx_core", folder = "qbx" },
        { resource = "qbx-core", folder = "qbx" },
        { resource = "qb-core", folder = "qb" }
    },

    inventories = {
        { resource = "ox_inventory", folder = "ox" },
        { resource = "qs-inventory", folder = "quasar" },
        { resource = "codem-inventory", folder = "codem" },
        { resource = "origen_inventory", folder = "origen" },
        { resource = "qb-inventory", folder = "qb" }
    },

    notifications = {
        { resource = "ox_lib", folder = "ox_lib" },
        { resource = "es_extended", folder = "esx" },
        { resource = "qb-core", folder = "qb" }
    },

    menus = {
        { resource = "ox_lib", folder = "ox_lib" }
    },

    targets = {
        { resource = "ox_target", folder = "ox" },
        { resource = "qb-target", folder = "qb" }
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
    Database = "auto",
    VersionCheck = false,
    Fivem = {
        VehiclePropertiesStateBag = false,
        VehiclePropertiesBroadcastFallback = false,
    },
    OxCirclePosition = "bottom"
}
