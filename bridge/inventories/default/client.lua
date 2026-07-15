local inventory={}
local function framework() return Bridge and Bridge.framework or {} end
local native=framework()
local nativeCount,nativeHas,nativeInventory=native.GetItemCount,native.HasItem,native.GetPlayerInventory
function inventory.GetResourceName() return "framework" end
function inventory.GetItemCount(item,metadata) local api=framework(); if nativeCount then return nativeCount(item,metadata) or 0 end; return 0 end
function inventory.HasItem(item,count,metadata) local api=framework(); if nativeHas then return nativeHas(item,count,metadata)==true end; return inventory.GetItemCount(item,metadata)>=(count or 1) end
function inventory.GetPlayerItems() local api=framework(); return nativeInventory and nativeInventory() or {} end
inventory.GetPlayerInventory=inventory.GetPlayerItems
return inventory