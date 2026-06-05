local Translations = {
    Debug = {
        FrameworkDetected = "Framework detectado: %{framework}",
        FuelDetected = "Sistema de combustível detectado: %{fuel}",
        InventoryDetected = "Sistema de inventário detectado: %{inventory}",
        NotificationDetected = "Sistema de notificação detectado: %{notification}",
        MenuDetected = "Sistema de menu detectado: %{menu}",
        TargetDetected = "Sistema de alvo detectado: %{target}",
        PhoneDetected = "Sistema de telefone detectado: %{phone}",
        ProgressbarDetected = "Sistema de barra de progresso detectado: %{progressbar}",
        VehicleKeyDetected = "Sistema de chave de veículo detectado: %{vehiclekey}",
        WeatherDetected = "Sistema de clima detectado: %{weather}",
    },
    message = {
        UpdateCheckFailed = "Não foi possível verificar atualizações.",
        UpdateAvailable = "Nova versão disponível: %{newversion} (você está na %{oldversion})",
        UpdateAvailableLink = "Acesse: https://github.com/%{author}/%{repo}/releases/latest",
        UpdateChecked = "Versão %{oldversion} — você está atualizado!"
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
