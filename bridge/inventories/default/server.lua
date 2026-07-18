local inventory = {}
local function framework() return Bridge and Bridge.framework or {} end
local native = framework()
local nativeAdd, nativeRemove, nativeGet, nativeCount, nativeCarry, nativeInventory, nativeClear, nativeMetadata, nativeItems = native.AddItem, native.RemoveItem, native.GetItemByName, native.GetItemCount, native.CanCarryItem, native.GetPlayerInventory, native.ClearPlayerInventory, native.SetMetadata, native.Items
function inventory.GetResourceName() return "framework" end
function inventory.AddItem(source,item,count,metadata,slot) local api=framework(); if nativeAdd then return nativeAdd(source,item,count,metadata,slot) end; local player=api.GetPlayer and api.GetPlayer(source); return player and player.Functions and player.Functions.AddItem and player.Functions.AddItem(item,count or 1,slot,metadata) or false end
function inventory.RemoveItem(source,item,count,metadata,slot) local api=framework(); if nativeRemove then return nativeRemove(source,item,count,metadata,slot) end; local player=api.GetPlayer and api.GetPlayer(source); return player and player.Functions and player.Functions.RemoveItem and player.Functions.RemoveItem(item,count or 1,slot) or false end
function inventory.GetItem(source,item,metadata) local api=framework(); if nativeGet then return nativeGet(source,item,metadata) end; local player=api.GetPlayer and api.GetPlayer(source); return player and player.Functions and player.Functions.GetItemByName and player.Functions.GetItemByName(item) end
inventory.GetItemByName=inventory.GetItem
function inventory.GetItemCount(source,item,metadata) local api=framework(); if nativeCount then return nativeCount(source,item,metadata) or 0 end; local data=inventory.GetItem(source,item,metadata); return data and (data.count or data.amount) or 0 end
function inventory.HasItem(source,item,count,metadata) return inventory.GetItemCount(source,item,metadata)>=(count or 1) end
function inventory.CanCarryItem(source,item,count,metadata) local api=framework(); return nativeCarry and nativeCarry(source,item,count,metadata) or true end
function inventory.GetInventory(source) local api=framework(); if nativeInventory then return nativeInventory(source) or {} end; local player=api.GetPlayer and api.GetPlayer(source); return player and player.PlayerData and player.PlayerData.items or {} end
inventory.GetInventoryItems=inventory.GetInventory
function inventory.ClearInventory(source) local api=framework(); return nativeClear and nativeClear(source)~=false or false end
function inventory.SetMetadata(source,slot,metadata) local api=framework(); return nativeMetadata and nativeMetadata(source,slot,metadata)~=false or false end
function inventory.Items(item) local api=framework(); return nativeItems and nativeItems(item) or nil end
function inventory.GetItemLabel(item) local data=inventory.Items(item); return type(data)=="table" and (data.label or item) or item end
return inventory