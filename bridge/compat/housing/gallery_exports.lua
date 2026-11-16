-- The gallery image exports live in the JS runtime and are resource-agnostic.
for _, name in ipairs({ 'ReadGalleryImage', 'SaveGalleryImage' }) do
    exports(name, function(...)
        local provider = exports['forge-realtor']
        return provider[name](provider, ...)
    end)
end
