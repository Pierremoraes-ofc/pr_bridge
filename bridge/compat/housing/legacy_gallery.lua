-- Runs on the server under the original KVP namespace.
exports('ReadLegacyGalleryMetadata', function(id)
    if GetInvokingResource() ~= 'forge-realtor' then return end
    if id == nil then return GetResourceKvpInt('gallery_sequence') end
    if type(id) ~= 'string' or not id:match('^photo_%d+_%d+$') then return end
    return GetResourceKvpString('gallery_owner:' .. id), GetResourceKvpString('gallery_property:' .. id)
end)
