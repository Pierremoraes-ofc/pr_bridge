-- Read the actual framework-owned integration profile only on request.
-- Consumer policy and the boot epoch are owned by Forge, never by this library.
return function(e)
 local path='kernel/pr_integration/operational_profile.lua'
 local source=assert(e.LoadResourceFile('forge-core',path),'Forge integration profile unavailable')
 local create=assert(e.load(source,'@@forge-core/'..path,'t',e))()
 return create(e)
end
