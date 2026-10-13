local api = lib.__native('bridge/library/init')
lib.locale = api.locale
lib.getLocales, lib.getLocale = api.getLocales, api.getLocale
locale = api.translate
AddEventHandler('ox_lib:setLocale', lib.locale)
return lib.locale
