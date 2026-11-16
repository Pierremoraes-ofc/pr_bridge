return function(id)
    if GetResourceState('ps-realtor') ~= 'started' then return end
    return exports['ps-realtor']:ReadLegacyGalleryMetadata(id)
end
