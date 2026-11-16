-- Public interfaces of the housing providers, by runtime.
return {
    ['forge-housing'] = {
        client = {
            'ApplyHousingPhotoDecor', 'CancelIPLPreview', 'CanOpenOwnerTablet', 'CanUsePropertyUtility',
            'CaptureHygienePoint', 'CloseSecurityCamera', 'CreateTempShell', 'DespawnTempShell',
            'DoorRegistrationVersion', 'GetApartment', 'GetApartments', 'GetCurrentPropertyUtilities',
            'GetHygieneAnimation', 'GetHygieneStatus', 'GetProperties', 'GetProperty', 'GetShellData',
            'GetShells', 'HideSecurityPanel', 'LoadHousingIPL', 'MoveHygieneWater', 'OpenPropertyFurniture',
            'PreviewIPLDecor', 'ReceiveIPLDecor', 'ResolveHygienePose', 'ScaleHygieneWater',
            'SetPropertyZoneDebug', 'StartHygieneWater', 'StopHygieneWater', 'ViewSecurityCamera',
        },
        server = {
            'DeleteFurniture', 'DeleteFurnitureCategory', 'DeleteRealtorProperty', 'DispatchPoliceForProperty',
            'GetApartments', 'GetFurnitureCatalog', 'GetHotelNames', 'GetProperties', 'GetPropertyWaypoint',
            'GetRealtorPropertySummaries', 'GetRealtorResidents', 'GetShells', 'HousingServicePrices',
            'HousingTaxSettings', 'InteriorSelection', 'IsOwner', 'IsPropertyUtilityAvailable',
            'ListEnterprises', 'ManageDoorPairs', 'ManageHygienePoints', 'ManageIPLPrices',
            'ManagePropertyDoors', 'ManageRealtorResident', 'PlayerHasPropertyUtility', 'RemovePropertyOwner',
            'ReportSecurityDoorBreach', 'SaveEnterprise', 'SaveRealtorProperty', 'UpsertFurniture',
            'UpsertFurnitureCategory', 'getMainDoor', 'registerProperty',
        },
    },
    ['forge-realtor'] = {
        client = { 'OpenHotelCatalog', 'OpenOwnerTablet', 'OpenPropertyDetails' },
        server = { 'GetPaymentsType', 'IsPaymentTypeAllowed', 'ReadGalleryImage', 'SaveGalleryImage' },
    },
}
