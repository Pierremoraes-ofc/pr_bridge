# PR Bridge Functions

## Contém 988 chamadas categorizadas por módulo e contexto: server, client e shared, sem explicações adicionais.


## core

### shared
- `pr_lib.load(path, env, optional)`
- `pr_lib.loadFile(resource, fileName, env, optional)`
- `pr_lib.loadJson(path, optional)`
- `pr_lib.readJson(path, optional)`
- `pr_lib.jsonExists(path)`
- `pr_lib.saveJson(path, value, options)`
- `pr_lib.writeJson(path, value, options)`
- `pr_lib.updateJson(path, changes, options)`
- `pr_lib.mergeJson(path, changes, options)`
- `pr_lib.deleteJson(path)`
- `pr_lib.loadModule(path, env, optional)`
- `pr_lib.locale(invokingResource)`
- `pr_lib.versionCheck(...)`
- `pr_lib.checkDependency(...)`

## locale

### shared
- `local lang = pr_lib.locale(invokingResource)`
- `lang:extend(phrases, prefix)`
- `lang:clear()`
- `lang:replace(phrases)`
- `lang:locale(newLocale)`
- `lang:t(key, substitutions)`
- `lang:has(key)`
- `lang:delete(phraseTarget, prefix)`
## cache

### shared
- `pr_lib.cache.set(key, value)`
- `pr_lib.cache.get(key, fallback)`
- `pr_lib.cache.clear(key)`
- `pr_lib.cache.clearPrefix(prefix)`
- `pr_lib.cache.remember(key, callback, timeout)`
- `pr_lib.cache.call(key, callback, timeout)`
- `pr_lib.cache.onChange(key, callback)`
- `pr_lib.cache.GetPlayer(source, timeout)`
- `pr_lib.cache.GetMetadata(source, metadata, timeout)`
- `pr_lib.cache.InvalidatePlayer(source)`

## debug

### shared
- `pr_lib.debug(...)`
- `pr_lib.debug.isEnabled()`
- `pr_lib.debug.setEnabled(state)`
- `pr_lib.debug.info(...)`
- `pr_lib.debug.success(...)`
- `pr_lib.debug.warn(...)`
- `pr_lib.debug.warning(...)`
- `pr_lib.debug.error(...)`
- `pr_lib.debug.log(level, ...)`

## events

### server
- `pr_lib.triggerClientEvent(eventName, target, ...)`
## framework

### server
- `pr_lib.framework.AddAccountBalance(source,account,amount,reason)`
- `pr_lib.framework.AddItem(source, itemName, count, metadata, slot)`
- `pr_lib.framework.AddJobAccountBalance(account, amount, reason)`
- `pr_lib.framework.addMoney(src, amount, account, reason)`
- `pr_lib.framework.AddPlayerAccountBalance(source,account,amount,reason)`
- `pr_lib.framework.addPlayerMoney(source, account, amount, reason)`
- `pr_lib.framework.addPlayerMoney(source, moneyWallet, amount)`
- `pr_lib.framework.addPlayerMoney(source, moneyWallet, amount, reason)`
- `pr_lib.framework.addPlayerMoney(source,account,amount,reason)`
- `pr_lib.framework.addSocietyBalance(account, amount, reason)`
- `pr_lib.framework.addSocietyBalance(job, amount)`
- `pr_lib.framework.AddWeapon(source, data)`
- `pr_lib.framework.CanCarryItem(source, itemName, count, metadata)`
- `pr_lib.framework.ClearPlayerInventory(source)`
- `pr_lib.framework.CreateWeaponData(source, data, weaponData)`
- `pr_lib.framework.DeleteOwnedVehicle(plate)`
- `pr_lib.framework.GetAccountBalance(source,account)`
- `pr_lib.framework.GetAllPlayers()`
- `pr_lib.framework.GetCoords(source, withHeading)`
- `pr_lib.framework.GetCoords(source,withHeading)`
- `pr_lib.framework.GetFrameworkJobs()`
- `pr_lib.framework.GetIdentifier(source)`
- `pr_lib.framework.getItemByName(name)`
- `pr_lib.framework.GetItemByName(source, itemName, metadata, slot)`
- `pr_lib.framework.getItemByName(source, name)`
- `pr_lib.framework.GetItemBySlot(source, slot)`
- `pr_lib.framework.GetItemCount(source, itemName, metadata, strict)`
- `pr_lib.framework.GetItemData(source, itemName, metadata, slot)`
- `pr_lib.framework.GetItemlabel(itemName)`
- `pr_lib.framework.GetItemLabel(itemName)`
- `pr_lib.framework.GetJobAccountBalance(account)`
- `pr_lib.framework.GetJobCount(jobName)`
- `pr_lib.framework.GetOwnedVehicleData(plate)`
- `pr_lib.framework.GetOwnedVehicleOwner(plate)`
- `pr_lib.framework.GetPlayer(source)`
- `pr_lib.framework.GetPlayerAccountBalance(source,account)`
- `pr_lib.framework.GetPlayerData(source)`
- `pr_lib.framework.getPlayerDOB(source)`
- `pr_lib.framework.GetPlayerDob(source)`
- `pr_lib.framework.getPlayerFromId(source)`
- `pr_lib.framework.GetPlayerFromId(source)`
- `pr_lib.framework.GetPlayerFromIdentifier(identifier)`
- `pr_lib.framework.GetPlayerGender(source)`
- `pr_lib.framework.getPlayerGroup()`
- `pr_lib.framework.GetPlayerGroup()`
- `pr_lib.framework.getPlayerGroup(source)`
- `pr_lib.framework.getPlayerHeight(source)`
- `pr_lib.framework.GetPlayerIdentifier(source)`
- `pr_lib.framework.GetPlayerInventory(source)`
- `pr_lib.framework.GetPlayerJob(source)`
- `pr_lib.framework.getPlayerJob(source, dataType)`
- `pr_lib.framework.getPlayerJob(source,dataType)`
- `pr_lib.framework.getPlayerMetadata(source, key)`
- `pr_lib.framework.getPlayerMetadata(source, meta)`
- `pr_lib.framework.GetPlayerMetadata(source,key)`
- `pr_lib.framework.getPlayerMetadata(source,key)`
- `pr_lib.framework.getPlayerMoney(source, account)`
- `pr_lib.framework.getPlayerMoney(source, moneyWallet)`
- `pr_lib.framework.getPlayerMoney(source,account)`
- `pr_lib.framework.getPlayerName(source)`
- `pr_lib.framework.GetPlayerName(source)`
- `pr_lib.framework.GetPlayerNameByIdentifier(identifier)`
- `pr_lib.framework.getPlayerSex(source)`
- `pr_lib.framework.getPlayerSourceFromPlayer(player)`
- `pr_lib.framework.getPlayerSourceFromPlayer(Player)`
- `pr_lib.framework.GetResourceName()`
- `pr_lib.framework.GetWeapon(source, name)`
- `pr_lib.framework.HasItem(source, itemName, count, metadata, strict)`
- `pr_lib.framework.InsertOwnedVehicle(plate, owner, vehicle)`
- `pr_lib.framework.InventoryManagement(source, data)`
- `pr_lib.framework.Items(itemName)`
- `pr_lib.framework.PlayerHasJob(source, jobName, grade)`
- `pr_lib.framework.PlayerHasJob(source, jobName, jobGrade)`
- `pr_lib.framework.RegisterCallback(name, callback)`
- `pr_lib.framework.RegisterCallback(name, cb)`
- `pr_lib.framework.RegisterUsableItem()`
- `pr_lib.framework.RegisterUsableItem(item, cb)`
- `pr_lib.framework.RegisterUsableItem(itemName, callback)`
- `pr_lib.framework.RemoveAccountBalance(source,account,amount,reason)`
- `pr_lib.framework.RemoveItem(source, itemName, count, metadata, slot)`
- `pr_lib.framework.RemoveJobAccountBalance(account, amount, reason)`
- `pr_lib.framework.RemovePlayerAccountBalance(source,account,amount,reason)`
- `pr_lib.framework.removePlayerMoney(source, account, amount, reason)`
- `pr_lib.framework.removePlayerMoney(source, moneyWallet, amount)`
- `pr_lib.framework.removePlayerMoney(source, moneyWallet, amount, reason)`
- `pr_lib.framework.removePlayerMoney(source,account,amount,reason)`
- `pr_lib.framework.removeSocietyBalance(account, amount, reason)`
- `pr_lib.framework.removeSocietyBalance(job, amount)`
- `pr_lib.framework.RemoveWeapon(source, data)`
- `pr_lib.framework.SetMetadata(source, slot, metadata)`
- `pr_lib.framework.SetPlayerJob(source, jobName, grade)`
- `pr_lib.framework.SetPlayerJob(source, jobName, jobGrade)`
- `pr_lib.framework.setPlayerMetadata(source, key, value)`
- `pr_lib.framework.setPlayerMetadata(source, meta, value)`
- `pr_lib.framework.setPlayerMetadata(source,key,value)`
- `pr_lib.framework.SetPlayerMetadata(source,key,value)`
- `pr_lib.framework.takeMoney(src, amount, reason)`

### client
- `pr_lib.framework.GetAccountBalance(account)`
- `pr_lib.framework.getCharacterName()`
- `pr_lib.framework.GetClosestPlayer()`
- `pr_lib.framework.GetClosestVehicle()`
- `pr_lib.framework.GetItemCount(itemName, metadata, strict)`
- `pr_lib.framework.GetJobInfo()`
- `pr_lib.framework.GetMoney(account)`
- `pr_lib.framework.GetMoney(type)`
- `pr_lib.framework.GetPlayer()`
- `pr_lib.framework.GetPlayerData()`
- `pr_lib.framework.GetPlayerDob()`
- `pr_lib.framework.GetPlayerGender()`
- `pr_lib.framework.GetPlayerGroup()`
- `pr_lib.framework.GetPlayerIdentifier()`
- `pr_lib.framework.GetPlayerInventory()`
- `pr_lib.framework.GetPlayerJob()`
- `pr_lib.framework.getPlayerMetadata(key)`
- `pr_lib.framework.GetPlayerMetadata(key)`
- `pr_lib.framework.getPlayerMetadata(meta)`
- `pr_lib.framework.GetPlayerName()`
- `pr_lib.framework.GetResourceName()`
- `pr_lib.framework.HasItem(itemName, count, metadata, strict)`
- `pr_lib.framework.HideTextUI()`
- `pr_lib.framework.IsPlayerDead()`
- `pr_lib.framework.IsPlayerLoaded()`
- `pr_lib.framework.Notify(message, kind, duration)`
- `pr_lib.framework.PlayerHasJob(jobName, grade)`
- `pr_lib.framework.ShowTextUI(text)`
- `pr_lib.framework.toggleOutfit(wear, outfits)`

### shared
- `pr_lib.framework.AddItem(...)`
- `pr_lib.framework.AddJobAccountBalance(...)`
- `pr_lib.framework.CanCarryItem(...)`
- `pr_lib.framework.ClearPlayerInventory(...)`
- `pr_lib.framework.GetAccountBalance(account)`
- `pr_lib.framework.GetAllPlayers()`
- `pr_lib.framework.GetClosestPlayer()`
- `pr_lib.framework.GetClosestVehicle()`
- `pr_lib.framework.GetFrameworkJobs()`
- `pr_lib.framework.GetItemByName(...)`
- `pr_lib.framework.GetItemBySlot(...)`
- `pr_lib.framework.GetItemCount(...)`
- `pr_lib.framework.GetItemData(...)`
- `pr_lib.framework.GetItemLabel(...)`
- `pr_lib.framework.GetItemlabel(...)`
- `pr_lib.framework.GetJobAccountBalance(...)`
- `pr_lib.framework.GetJobCount(jobName)`
- `pr_lib.framework.GetPlayerData(...)`
- `pr_lib.framework.GetPlayerDob()`
- `pr_lib.framework.GetPlayerFromIdentifier(identifier)`
- `pr_lib.framework.GetPlayerGender()`
- `pr_lib.framework.GetPlayerGroup()`
- `pr_lib.framework.GetPlayerIdentifier()`
- `pr_lib.framework.GetPlayerInventory(...)`
- `pr_lib.framework.GetPlayerJob()`
- `pr_lib.framework.getPlayerJob()`
- `pr_lib.framework.GetPlayerJob(source)`
- `pr_lib.framework.GetPlayerName()`
- `pr_lib.framework.GetResourceName()`
- `pr_lib.framework.HasItem(...)`
- `pr_lib.framework.HideTextUI()`
- `pr_lib.framework.IsPlayerDead()`
- `pr_lib.framework.IsPlayerLoaded()`
- `pr_lib.framework.Items(...)`
- `pr_lib.framework.Notify(message,kind,duration)`
- `pr_lib.framework.PlayerHasJob(jobName,grade)`
- `pr_lib.framework.PlayerHasJob(source, jobName, grade)`
- `pr_lib.framework.RegisterUsableItem(...)`
- `pr_lib.framework.RemoveItem(...)`
- `pr_lib.framework.RemoveJobAccountBalance(...)`
- `pr_lib.framework.SetMetadata(...)`
- `pr_lib.framework.SetPlayerJob(source, jobName, grade)`
- `pr_lib.framework.ShowTextUI(text)`

## inventory

### server
- `pr_lib.inventory.AddItem(inv, item, count, metadata, slot, cb)`
- `pr_lib.inventory.AddItem(inv,item,count,metadata,slot)`
- `pr_lib.inventory.AddItem(source,item,count,metadata,slot)`
- `pr_lib.inventory.AddItemIntoStash(id, item, amount, slot, metadata, slots, maxWeight)`
- `pr_lib.inventory.AddStashItems(id, items)`
- `pr_lib.inventory.AddStashItems(id,items)`
- `pr_lib.inventory.AddTrunkItems(identifier, items)`
- `pr_lib.inventory.CanCarryAmount(inv, item)`
- `pr_lib.inventory.CanCarryItem(inv, item, count, metadata)`
- `pr_lib.inventory.CanCarryItem(inv,item,count,metadata)`
- `pr_lib.inventory.CanCarryItem(source,item,count,metadata)`
- `pr_lib.inventory.CanCarryWeight(inv, weight)`
- `pr_lib.inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)`
- `pr_lib.inventory.CheckItemValid(source, name, count)`
- `pr_lib.inventory.ClearInventory(inv, keep)`
- `pr_lib.inventory.ClearInventory(inv,keep)`
- `pr_lib.inventory.ClearInventory(source)`
- `pr_lib.inventory.ClearOtherInventory(type, id)`
- `pr_lib.inventory.ClearPlayerInventory(inv, keep)`
- `pr_lib.inventory.ClearStash(id)`
- `pr_lib.inventory.ConfiscateInventory(source)`
- `pr_lib.inventory.CreateDropFromPlayer(playerId)`
- `pr_lib.inventory.CreateTemporaryStash(properties)`
- `pr_lib.inventory.CreateUsableItem(item, cb)`
- `pr_lib.inventory.CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)`
- `pr_lib.inventory.forceOpenInventory(playerId, invType, data)`
- `pr_lib.inventory.GetContainerFromSlot(inv, slotId)`
- `pr_lib.inventory.GetCurrentWeapon(inv)`
- `pr_lib.inventory.GetEmptySlot(inv)`
- `pr_lib.inventory.GetImagePath(item)`
- `pr_lib.inventory.GetInventory(inv)`
- `pr_lib.inventory.GetInventory(inv, owner)`
- `pr_lib.inventory.GetInventory(inv, source)`
- `pr_lib.inventory.GetInventory(source)`
- `pr_lib.inventory.getInventoryImg(image)`
- `pr_lib.inventory.getInventoryImg(item)`
- `pr_lib.inventory.GetInventoryItems(inv)`
- `pr_lib.inventory.GetInventoryItems(inv, owner)`
- `pr_lib.inventory.GetItem(inv, item, metadata, returnsCount)`
- `pr_lib.inventory.GetItem(inv,item,metadata)`
- `pr_lib.inventory.GetItem(source,item,metadata)`
- `pr_lib.inventory.GetItemByName(inv, item, metadata, returnsCount)`
- `pr_lib.inventory.GetItemBySlot(inv,slot,metadata)`
- `pr_lib.inventory.GetItemBySlot(source, slot)`
- `pr_lib.inventory.GetItemBySlot(src, slot)`
- `pr_lib.inventory.GetItemCount(inv, itemName, metadata, strict)`
- `pr_lib.inventory.GetItemCount(inv,item,metadata,strict)`
- `pr_lib.inventory.GetItemCount(source,item,metadata)`
- `pr_lib.inventory.getItemInfo(item)`
- `pr_lib.inventory.GetItemInfo(item)`
- `pr_lib.inventory.GetItemLabel(item)`
- `pr_lib.inventory.GetItemLabel(itemname)`
- `pr_lib.inventory.GetItemSlots(inv, item, metadata)`
- `pr_lib.inventory.GetResourceName()`
- `pr_lib.inventory.GetSlot(inv, slot)`
- `pr_lib.inventory.GetSlotForItem(inv, itemName, metadata)`
- `pr_lib.inventory.GetSlotIdsWithItem(inv, itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotIdWithItem(inv, itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotsWithItem(inv, itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotWithItem(inv, itemName, metadata, strict)`
- `pr_lib.inventory.GetStashItems(id)`
- `pr_lib.inventory.GetStashItems(stashid)`
- `pr_lib.inventory.GetTotalUsedSlots(source)`
- `pr_lib.inventory.GetTotalWeight(items)`
- `pr_lib.inventory.GetWeaponAttachmentItems()`
- `pr_lib.inventory.HasItem(inv,item,count,metadata,strict)`
- `pr_lib.inventory.HasItem(source, items, amount)`
- `pr_lib.inventory.HasItem(source,item,count,metadata)`
- `pr_lib.inventory.HasItem(src, item, requiredCount)`
- `pr_lib.inventory.InspectInventory(target, source)`
- `pr_lib.inventory.Items(item)`
- `pr_lib.inventory.Items(itemName)`
- `pr_lib.inventory.LoadInventory(source, identifier)`
- `pr_lib.inventory.OpenPlayerInventory(src, target)`
- `pr_lib.inventory.OpenShop(src, shopTitle)`
- `pr_lib.inventory.OpenStash(source,id)`
- `pr_lib.inventory.RegisterShop(shopTitle, invData, shopCoords, shopGroups)`
- `pr_lib.inventory.RegisterStash(id, label, slots, maxWeight, owner, groups, coords)`
- `pr_lib.inventory.RegisterStash(id,label,slots,maxWeight,owner,groups,coords)`
- `pr_lib.inventory.RegisterStash(source, id, slots, weight)`
- `pr_lib.inventory.RegisterUsableItem(item, cb, options)`
- `pr_lib.inventory.RemoveItem(inv, item, count, metadata, slot)`
- `pr_lib.inventory.RemoveItem(inv,item,count,metadata,slot)`
- `pr_lib.inventory.RemoveItem(source,item,count,metadata,slot)`
- `pr_lib.inventory.RemoveItemIntoStash(id, item, amount, slot, slots, maxWeight)`
- `pr_lib.inventory.ReturnInventory(source)`
- `pr_lib.inventory.SaveInventory(source, offline)`
- `pr_lib.inventory.Search(inv, search, item, metadata)`
- `pr_lib.inventory.SetDurability(inv, slot, durability)`
- `pr_lib.inventory.SetInventoryItems(source, item, amount)`
- `pr_lib.inventory.SetItemBySlot(source, slot, itemdata)`
- `pr_lib.inventory.SetItemMetadata(inv, slot, metadata)`
- `pr_lib.inventory.SetItemMetadata(source, slot, metadata)`
- `pr_lib.inventory.setItemMetadata(src, slot, metadata)`
- `pr_lib.inventory.SetMaxWeight(inv, maxWeight)`
- `pr_lib.inventory.SetMetadata(inv, slot, metadata)`
- `pr_lib.inventory.SetMetadata(inv,slot,metadata)`
- `pr_lib.inventory.SetMetadata(source,slot,metadata)`
- `pr_lib.inventory.setPlayerInventory(player, data)`
- `pr_lib.inventory.SetSlotCount(inv, slots)`
- `pr_lib.inventory.UpdateStash(stashid, items)`
- `pr_lib.inventory.UpdateVehicle(oldPlate, newPlate)`

### client
- `pr_lib.inventory.CheckIfInventoryBlocked()`
- `pr_lib.inventory.closeInventory()`
- `pr_lib.inventory.displayMetadata(metadata, value)`
- `pr_lib.inventory.GetClientPlayerInventory()`
- `pr_lib.inventory.getCurrentWeapon()`
- `pr_lib.inventory.GetImagePath(item)`
- `pr_lib.inventory.getInventoryImg(image)`
- `pr_lib.inventory.getInventoryImg(item)`
- `pr_lib.inventory.GetItemCount(item,metadata)`
- `pr_lib.inventory.GetItemCount(item,metadata,strict)`
- `pr_lib.inventory.GetItemCount(itemName, metadata, strict)`
- `pr_lib.inventory.GetItemInfo(item)`
- `pr_lib.inventory.getItemInfo(item)`
- `pr_lib.inventory.GetItemLabel(item)`
- `pr_lib.inventory.GetItemList()`
- `pr_lib.inventory.GetPlayerInventory()`
- `pr_lib.inventory.GetPlayerItems()`
- `pr_lib.inventory.GetPlayerMaxWeight()`
- `pr_lib.inventory.GetPlayerWeight()`
- `pr_lib.inventory.GetResourceName()`
- `pr_lib.inventory.GetSlotIdsWithItem(itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotIdWithItem(itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotsWithItem(itemName, metadata, strict)`
- `pr_lib.inventory.GetSlotWithItem(itemName, metadata, strict)`
- `pr_lib.inventory.getUserInventory()`
- `pr_lib.inventory.GetWeaponList()`
- `pr_lib.inventory.giveItemToTarget(serverId, slotId, count)`
- `pr_lib.inventory.HasItem(item, requiredCount)`
- `pr_lib.inventory.HasItem(item,count,metadata)`
- `pr_lib.inventory.HasItem(item,count,metadata,strict)`
- `pr_lib.inventory.isInventoryOpen()`
- `pr_lib.inventory.Items(itemName)`
- `pr_lib.inventory.openInventory(invType, data)`
- `pr_lib.inventory.openNearbyInventory()`
- `pr_lib.inventory.RegisterStash(id, slots, weight)`
- `pr_lib.inventory.Search(search, item, metadata)`
- `pr_lib.inventory.setInClothing(state)`
- `pr_lib.inventory.setInventoryDisabled(state)`
- `pr_lib.inventory.setStashTarget(id, owner)`
- `pr_lib.inventory.useItem(data, cb)`
- `pr_lib.inventory.useSlot(slot)`
- `pr_lib.inventory.weaponWheel(state)`

### shared
- `pr_lib.inventory.AddStashItems(stashId, items)`
- `pr_lib.inventory.ClearPlayerInventory(...)`
- `pr_lib.inventory.ClearStash(...)`
- `pr_lib.inventory.GetImagePath(image)`
- `pr_lib.inventory.getInventoryImg(image)`
- `pr_lib.inventory.GetInventoryImg(image)`
- `pr_lib.inventory.GetInventoryItems()`
- `pr_lib.inventory.GetInventoryItems(inv, owner)`
- `pr_lib.inventory.GetItemByName(...)`
- `pr_lib.inventory.GetItemBySlot(inv, slot)`
- `pr_lib.inventory.GetItemInfo(item)`
- `pr_lib.inventory.getItemInfo(item)`
- `pr_lib.inventory.GetItemLabel(item)`
- `pr_lib.inventory.GetItemSlots(inv, item, metadata, strict)`
- `pr_lib.inventory.GetPlayerInventory()`
- `pr_lib.inventory.GetResourceName()`
- `pr_lib.inventory.GetSlot(...)`
- `pr_lib.inventory.GetSlot(inv, slot)`
- `pr_lib.inventory.GetSlotForItem(item, metadata, strict)`
- `pr_lib.inventory.GetSlotIdsWithItem(inv, item, metadata, strict)`
- `pr_lib.inventory.GetSlotIdsWithItem(item, metadata, strict)`
- `pr_lib.inventory.GetSlotIdWithItem(inv, item, metadata, strict)`
- `pr_lib.inventory.GetSlotIdWithItem(item, metadata, strict)`
- `pr_lib.inventory.GetSlotsWithItem(inv, item, metadata, strict)`
- `pr_lib.inventory.GetSlotsWithItem(item, metadata, strict)`
- `pr_lib.inventory.GetSlotWithItem(inv, item, metadata, strict)`
- `pr_lib.inventory.GetSlotWithItem(item, metadata, strict)`
- `pr_lib.inventory.GetStashItems()`
- `pr_lib.inventory.HasItem(inv, item, amount, metadata, strict)`
- `pr_lib.inventory.HasItem(item, amount, metadata, strict)`
- `pr_lib.inventory.OpenStash(source, stashId)`
- `pr_lib.inventory.Search(inv, search, item, metadata)`
- `pr_lib.inventory.Search(search, item, metadata)`
- `pr_lib.inventory.SetItemMetadata(...)`
- `pr_lib.inventory.setItemMetadata(...)`
- `pr_lib.inventory.SetMetadata(...)`

## notification

### server
- `pr_lib.notify.GetResourceName()`
- `pr_lib.notify.Notify(src, data)`
- `pr_lib.notify.Notify(src,data)`

### client
- `pr_lib.notify.GetResourceName()`
- `pr_lib.notify.Notify(data)`

## menu

### client
- `pr_lib.menus.AlertDialog()`
- `pr_lib.menus.AlertDialog(data, timeout)`
- `pr_lib.menus.GetOpenContextMenu()`
- `pr_lib.menus.HideContext()`
- `pr_lib.menus.HideContext(onExit)`
- `pr_lib.menus.HideMenu()`
- `pr_lib.menus.HideMenu(onExit)`
- `pr_lib.menus.InputDialog()`
- `pr_lib.menus.InputDialog(heading, rows, options)`
- `pr_lib.menus.RegisterContext(context)`
- `pr_lib.menus.RegisterMenu()`
- `pr_lib.menus.RegisterMenu(data, cb)`
- `pr_lib.menus.ShowContext(id)`
- `pr_lib.menus.ShowMenu()`
- `pr_lib.menus.ShowMenu(id, startIndex)`

## target

### client
- `pr_lib.target.addBoxZone(parameters)`
- `pr_lib.target.addEntity(netIds, options)`
- `pr_lib.target.addEntity(netIds,list)`
- `pr_lib.target.addGlobalObject(list)`
- `pr_lib.target.addGlobalObject(options)`
- `pr_lib.target.addGlobalOption(options)`
- `pr_lib.target.addGlobalPed(list)`
- `pr_lib.target.addGlobalPed(options)`
- `pr_lib.target.addGlobalPlayer(list)`
- `pr_lib.target.addGlobalPlayer(options)`
- `pr_lib.target.addGlobalVehicle(list)`
- `pr_lib.target.addGlobalVehicle(options)`
- `pr_lib.target.addLocalEntity(entities, options)`
- `pr_lib.target.addLocalEntity(entities,list)`
- `pr_lib.target.addModel(models, options)`
- `pr_lib.target.addModel(models,list)`
- `pr_lib.target.addPolyZone(parameters)`
- `pr_lib.target.addSphereZone(parameters)`
- `pr_lib.target.disableTargeting()`
- `pr_lib.target.disableTargeting(state)`
- `pr_lib.target.GetResourceName()`
- `pr_lib.target.removeEntity(netIds, optionNames)`
- `pr_lib.target.removeEntity(netIds,names)`
- `pr_lib.target.removeGlobalObject(names)`
- `pr_lib.target.removeGlobalObject(optionNames)`
- `pr_lib.target.removeGlobalOption(optionNames)`
- `pr_lib.target.removeGlobalPed(names)`
- `pr_lib.target.removeGlobalPed(optionNames)`
- `pr_lib.target.removeGlobalPlayer(names)`
- `pr_lib.target.removeGlobalPlayer(optionNames)`
- `pr_lib.target.removeGlobalVehicle(names)`
- `pr_lib.target.removeGlobalVehicle(optionNames)`
- `pr_lib.target.removeLocalEntity(entities, optionNames)`
- `pr_lib.target.removeLocalEntity(entities,names)`
- `pr_lib.target.removeModel(models, optionNames)`
- `pr_lib.target.removeModel(models,names)`
- `pr_lib.target.removeZone(id)`

### shared
- `pr_lib.target.AddBoxZone(name,coords,size,rotation,options,debug)`
- `pr_lib.target.AddPolyZone(name,points,thickness,options,debug)`
- `pr_lib.target.AddSphereZone(name,coords,radius,options,debug)`
- `pr_lib.target.FixOptions(...)`
- `pr_lib.target.GetResourceName(...)`

## phone

### server
- `pr_lib.phone.GetMetaFromSource(phoneNumber)`
- `pr_lib.phone.GetMetaFromSource(source)`
- `pr_lib.phone.GetPhoneNames()`
- `pr_lib.phone.GetPhoneNumberFromIdentifier(identifier, mustBePhoneOwner)`
- `pr_lib.phone.GetPhoneNumberFromIdentifier(source, mustBePhoneOwner)`
- `pr_lib.phone.HasEmailAccount(phoneNumber)`
- `pr_lib.phone.HasEmailAccount(source)`
- `pr_lib.phone.IsInJobDuty(source)`
- `pr_lib.phone.RemoveFromJobDuty(source)`
- `pr_lib.phone.SendNewMessageFromApp(source, phoneNumber, message, appName)`
- `pr_lib.phone.SendNewMessageFromApp(target, phoneNumber, message, appName)`
- `pr_lib.phone.SendSOSMessage(phoneNumber, job, coords, messageType)`
- `pr_lib.phone.SendSOSMessage(source, job, coords, messageType)`
- `pr_lib.phone.SetInJobDuty(source)`

### client
- `pr_lib.phone.ClosePhone()`
- `pr_lib.phone.CreateCall(name, number, image, anonymous)`
- `pr_lib.phone.EndCall()`
- `pr_lib.phone.GetCall()`
- `pr_lib.phone.InPhone()`
- `pr_lib.phone.IsInCall()`
- `pr_lib.phone.IsInCamera()`
- `pr_lib.phone.SetCanOpenPhone(bool)`
- `pr_lib.phone.SetSOS(bool)`

## progressbar

### client
- `pr_lib.progress.doProgressbar()`
- `pr_lib.progress.doProgressbar(duration, label, anim)`
- `pr_lib.progress.doProgressCircle()`
- `pr_lib.progress.doProgressCircle(duration, label, anim)`

## weather

### client
- `pr_lib.weather.GetResourceName()`
- `pr_lib.weather.ToggleSync(toggle)`

## database

### server
- `pr_lib.database.backup.create(options)`
- `pr_lib.database.backup.run(options)`
- `pr_lib.database.backup.export(options)`
- `pr_lib.database.createBackup(options)`
- `pr_lib.sqlBackup.create(options)`
- `pr_lib.database.auto(query, parameters, cb)`
- `pr_lib.database.execute(_, _, cb)`
- `pr_lib.database.execute(query, parameters, cb)`
- `pr_lib.database.fetch(query, parameters, cb)`
- `pr_lib.database.fetchAll(query, parameters, cb)`
- `pr_lib.database.GetResourceName()`
- `pr_lib.database.insert(_, _, cb)`
- `pr_lib.database.insert(query, parameters, cb)`
- `pr_lib.database.isReady()`
- `pr_lib.database.query(_, _, cb)`
- `pr_lib.database.query(query, parameters, cb)`
- `pr_lib.database.read(query, parameters, cb)`
- `pr_lib.database.run(query, parameters, cb)`
- `pr_lib.database.scalar(_, _, cb)`
- `pr_lib.database.scalar(query, parameters, cb)`
- `pr_lib.database.single(_, _, cb)`
- `pr_lib.database.single(query, parameters, cb)`
- `pr_lib.database.transaction(_, _, cb)`
- `pr_lib.database.transaction(queries, parameters, cb)`
- `pr_lib.database.update(query, parameters, cb)`
- `pr_lib.database.write(query, parameters, cb)`

### client
- `pr_lib.database.execute(_, _, cb)`
- `pr_lib.database.fetch(_, _, cb)`
- `pr_lib.database.fetchAll(_, _, cb)`
- `pr_lib.database.GetResourceName()`
- `pr_lib.database.insert(_, _, cb)`
- `pr_lib.database.isReady()`
- `pr_lib.database.query(_, _, cb)`
- `pr_lib.database.read(_, _, cb)`
- `pr_lib.database.run(_, _, cb)`
- `pr_lib.database.scalar(_, _, cb)`
- `pr_lib.database.single(_, _, cb)`
- `pr_lib.database.transaction(_, _, cb)`
- `pr_lib.database.update(_, _, cb)`
- `pr_lib.database.write(_, _, cb)`

## fuel

### client
- `pr_lib.fuel.GetFuel(vehicle)`
- `pr_lib.fuel.GetResourceName()`
- `pr_lib.fuel.SetFuel(vehicle, amount, type)`

## vehicle_key

### server
- `pr_lib.vehicle_key.GetAllKeys()`
- `pr_lib.vehicle_key.GetAllKeys(source)`
- `pr_lib.vehicle_key.GiveKey()`
- `pr_lib.vehicle_key.GiveKey(source, plate)`
- `pr_lib.vehicle_key.GiveKeyItem()`
- `pr_lib.vehicle_key.GiveKeyItem(source, plate, netId)`
- `pr_lib.vehicle_key.GiveTempKeys()`
- `pr_lib.vehicle_key.GiveTempKeys(source, plate)`
- `pr_lib.vehicle_key.HasKey()`
- `pr_lib.vehicle_key.HasKey(source, plate)`
- `pr_lib.vehicle_key.HavePermanentKey()`
- `pr_lib.vehicle_key.HavePermanentKey(source, plate)`
- `pr_lib.vehicle_key.HaveTemporaryKey()`
- `pr_lib.vehicle_key.HaveTemporaryKey(source, plate)`
- `pr_lib.vehicle_key.RemoveKey()`
- `pr_lib.vehicle_key.RemoveKey(source, plate)`
- `pr_lib.vehicle_key.RemoveKeyItem()`
- `pr_lib.vehicle_key.RemoveKeyItem(source, plate)`
- `pr_lib.vehicle_key.RemoveTempKeys()`
- `pr_lib.vehicle_key.RemoveTempKeys(source, plate)`

### client
- `pr_lib.vehicle_key.GetAllKeys(target)`
- `pr_lib.vehicle_key.GetResourceName()`
- `pr_lib.vehicle_key.GiveKey()`
- `pr_lib.vehicle_key.GiveKey(plate)`
- `pr_lib.vehicle_key.GiveKeyItem(plate, vehicle)`
- `pr_lib.vehicle_key.GiveKeyMenu(plate)`
- `pr_lib.vehicle_key.GiveKeys()`
- `pr_lib.vehicle_key.GiveKeys(vehicle, plate)`
- `pr_lib.vehicle_key.GiveTempKeys(plate)`
- `pr_lib.vehicle_key.HasKey()`
- `pr_lib.vehicle_key.HasKey(plate)`
- `pr_lib.vehicle_key.HavePermanentKey(plate)`
- `pr_lib.vehicle_key.HaveTemporaryKey(plate)`
- `pr_lib.vehicle_key.ManageKeysMenu()`
- `pr_lib.vehicle_key.RemoveKey()`
- `pr_lib.vehicle_key.RemoveKey(plate)`
- `pr_lib.vehicle_key.RemoveKeyItem(plate)`
- `pr_lib.vehicle_key.RemoveKeys()`
- `pr_lib.vehicle_key.RemoveKeys(vehicle, plate)`
- `pr_lib.vehicle_key.RemoveTempKeys(plate)`
- `pr_lib.vehicle_key.ToggleLock()`

## banking

### shared
- `pr_lib.banking.AddAccountBalance(player, accountType, amount, reason)`
- `pr_lib.banking.AddJobAccountBalance(account, amount, reason)`
- `pr_lib.banking.AddPlayerAccountBalance(player, accountType, amount, reason)`
- `pr_lib.banking.GetAccountBalance(player, accountType)`
- `pr_lib.banking.GetJobAccountBalance(account)`
- `pr_lib.banking.GetPlayerAccountBalance(player, accountType)`
- `pr_lib.banking.GetResourceName()`
- `pr_lib.banking.RemoveAccountBalance(player, accountType, amount, reason)`
- `pr_lib.banking.RemoveJobAccountBalance(account, amount, reason)`
- `pr_lib.banking.RemovePlayerAccountBalance(player, accountType, amount, reason)`

## textui_adapter

### client
- `pr_lib.textuiBridge.GetResourceName()`
- `pr_lib.textuiBridge.hide()`
- `pr_lib.textuiBridge.Hide()`
- `pr_lib.textuiBridge.Show(text)`
- `pr_lib.textuiBridge.show(text)`

## callback

### server
- `pr_lib.callback.await(target, name, timeout, ...)`
- `pr_lib.callback.awaitClient(target, name, timeout, ...)`
- `pr_lib.callback.cancel(requestId)`
- `pr_lib.callback.getPending()`
- `pr_lib.callback.trigger(target, name, cb, ...)`
- `pr_lib.callback.triggerClient(target, name, cb, ...)`

### client
- `pr_lib.callback.await(name, timeout, ...)`
- `pr_lib.callback.cancel(requestId)`
- `pr_lib.callback.getPending()`
- `pr_lib.callback.trigger(name, cb, ...)`

## ace

### server
- `pr_lib.ace.addAce(principal, aceName, allow)`
- `pr_lib.ace.addPrincipal(child, parent)`
- `pr_lib.ace.canAccess(source, options)`
- `pr_lib.ace.ensureAce(principal, aceName)`
- `pr_lib.ace.ensureCommandAce(principal, commandName)`
- `pr_lib.ace.getIdentifiers(source)`
- `pr_lib.ace.hasAce(source, aceName)`
- `pr_lib.ace.hasCommandAce(source, commandName)`
- `pr_lib.ace.hasFrameworkAccess(source, options)`
- `pr_lib.ace.hasIdentifier(source, identifier)`
- `pr_lib.ace.inWhitelist(source, whitelistName)`
- `pr_lib.ace.isCommandAllowed(source, commandName)`
- `pr_lib.ace.isPlayerAceAllowed(source, aceName)`
- `pr_lib.ace.isWhitelisted(source, whitelistName)`
- `pr_lib.ace.parseConvarList(raw)`
- `pr_lib.ace.removeAce(principal, aceName, allow)`
- `pr_lib.ace.removePrincipal(child, parent)`

## addcommand

### server
- `pr_lib.addCommand(commandName, properties, callback)`
- `pr_lib.addCommand.add(commandName, properties, cb)`
- `pr_lib.addCommand.addCommand(commandName, properties, cb)`
- `pr_lib.addCommand.register(commandName, properties, cb)`

### client
- `pr_lib.addCommand(commandName, properties, callback)`
- `pr_lib.addCommand.add(commandName, properties, cb)`
- `pr_lib.addCommand.addCommand(commandName, properties, cb)`
- `pr_lib.addCommand.register(commandName, properties, cb)`

## addkeybind

### client
- `pr_lib.addKeybind(data)`
- `pr_lib.addKeybind.get(name)`
- `pr_lib.addKeybind.remove(name)`

## translator

### server
- `pr_lib.translator.translate(text, targetLang, cb)`
- `pr_lib.translator.translateBatch(strings, targetLang, cb)`
- `pr_lib.translator.translateText(text, targetLang, cb)`

### client
- `pr_lib.translator.showTranslatedNotify(title, description, notifyType, targetLang)`
- `pr_lib.translator.translate(text, targetLang)`
- `pr_lib.translator.translateBatch(strings, targetLang)`
- `pr_lib.translator.translateMenu(menuData, targetLang)`
- `pr_lib.translator.translateText(text, targetLang)`

## github

### server
- `pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`
- `pr_lib.github.versionCheck(repository)`

### client
- `pr_lib.github.checkDependency(resource, minimumVersion, printMessage)`

## utils

### shared
- `pr_lib.utils.deepCopy(value, seen)`
- `pr_lib.utils.dumpTable(value, depth, seen)`
- `pr_lib.utils.ensureTable(value)`
- `pr_lib.utils.firstToUpper(value)`
- `pr_lib.utils.hash(value)`
- `pr_lib.utils.round(value, decimals)`
- `pr_lib.utils.trim(value)`

## math

### shared
- `pr_lib.math.AlmostEqual(a, b, epsilon)`
- `pr_lib.math.almostEqual(a, b, epsilon)`
- `pr_lib.math.Clamp(value, minimum, maximum)`
- `pr_lib.math.clamp(value, minimum, maximum)`
- `pr_lib.math.Deg2Rad(value)`
- `pr_lib.math.degToRad(value)`
- `pr_lib.math.Distance2D(x1,y1,x2,y2)`
- `pr_lib.math.distance2D(x1,y1,x2,y2)`
- `pr_lib.math.Distance3D(x1,y1,z1,x2,y2,z2)`
- `pr_lib.math.distance3D(x1,y1,z1,x2,y2,z2)`
- `pr_lib.math.hexToRGB(value)`
- `pr_lib.math.HexToRGB(value)`
- `pr_lib.math.hexToRGBA(value)`
- `pr_lib.math.HexToRGBA(value)`
- `pr_lib.math.InverseLerp(startValue, finishValue, value)`
- `pr_lib.math.inverseLerp(startValue, finishValue, value)`
- `pr_lib.math.length2(x, y)`
- `pr_lib.math.Length2(x, y)`
- `pr_lib.math.Length3(x, y, z)`
- `pr_lib.math.length3(x, y, z)`
- `pr_lib.math.Lerp(startValue, finishValue, duration)`
- `pr_lib.math.lerp(startValue, finishValue, factor)`
- `pr_lib.math.map(value, inMin, inMax, outMin, outMax)`
- `pr_lib.math.Map(value, inMin, inMax, outMin, outMax)`
- `pr_lib.math.NormalToRotation(input)`
- `pr_lib.math.normalToRotation(input)`
- `pr_lib.math.parse(value, minimum, maximum, shouldRound)`
- `pr_lib.math.ParseNumber(value, minimum, maximum, shouldRound)`
- `pr_lib.math.Rad2Deg(value)`
- `pr_lib.math.radToDeg(value)`
- `pr_lib.math.round(value, places)`
- `pr_lib.math.Round(value, places)`
- `pr_lib.math.Sign(value)`
- `pr_lib.math.sign(value)`
- `pr_lib.math.toHex(value, upper)`
- `pr_lib.math.ToHex(value, upper)`
- `pr_lib.math.ToScalars(value, minimum, maximum, shouldRound)`
- `pr_lib.math.toScalars(value, minimum, maximum, shouldRound)`
- `pr_lib.math.toVector(value, minimum, maximum, shouldRound)`
- `pr_lib.math.ToVector(value, minimum, maximum, shouldRound)`

## table

### shared
- `pr_lib.table.clone(value, seen)`
- `pr_lib.table.Contains(source, value)`
- `pr_lib.table.contains(source, value)`
- `pr_lib.table.count(source)`
- `pr_lib.table.Count(source)`
- `pr_lib.table.DeepClone(value, seen)`
- `pr_lib.table.Map(source, callback)`
- `pr_lib.table.map(source, callback)`
- `pr_lib.table.matches(left, right)`
- `pr_lib.table.Matches(left, right)`
- `pr_lib.table.Merge(target, source, override)`
- `pr_lib.table.merge(target, source, override)`
- `pr_lib.table.Shuffle(source, copy, random)`
- `pr_lib.table.shuffle(source, copy, random)`

## ids

### shared
- `pr_lib.ids.CreateUniqueId(registry, length, pattern)`
- `pr_lib.ids.createUniqueId(registry, length, pattern)`

## fivem.raycast

### client
- `pr_lib.raycast.FromCamera(distance, flags, ignoreFlags, ignoreEntity)`
- `pr_lib.raycast.fromCamera(distance, flags, ignoreFlags, ignoreEntity)`
- `pr_lib.raycast.fromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`
- `pr_lib.raycast.FromCoords(origin, destination, flags, ignoreFlags, ignoreEntity)`

## fivem.net

### server
- `pr_lib.fivem.net.getEntity(netId, timeout)`
- `pr_lib.fivem.net.getNetId(entity)`
- `pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`
- `pr_lib.fivem.net.getVehicle(netId, timeout)`
- `pr_lib.fivem.net.isValidNetId(netId)`
- `pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`

### client
- `pr_lib.fivem.net.getEntity(netId, timeout)`
- `pr_lib.fivem.net.getNetId(entity)`
- `pr_lib.fivem.net.getOwner(entityOrNetId, timeout)`
- `pr_lib.fivem.net.getVehicle(netId, timeout)`
- `pr_lib.fivem.net.isValidNetId(netId)`
- `pr_lib.fivem.net.resolveVehicle(vehicleOrNetId, timeout)`

## fivem.ui

### client
- `pr_lib.ui.Draw2DText(text, x, y, scale, textColor, font)`
- `pr_lib.ui.draw2DText(text, x, y, scale, textColor, font)`
- `pr_lib.ui.Draw3DText(text, coords, scale, textColor, font)`
- `pr_lib.ui.draw3DText(text, coords, scale, textColor, font)`
- `pr_lib.ui.DrawRect(x,y,width,height,rectColor)`
- `pr_lib.ui.drawRect(x,y,width,height,rectColor)`

## fivem.dui

### server
- `pr_lib.dui.clear(target)`
- `pr_lib.dui.create(target, options)`
- `pr_lib.dui.createPoly(target, options)`
- `pr_lib.dui.createPoly4(target, options)`
- `pr_lib.dui.createRenderTarget(target, options)`
- `pr_lib.dui.createReplaceTexture(target, options)`
- `pr_lib.dui.createSprite(target, options)`
- `pr_lib.dui.destroy(target, id)`
- `pr_lib.dui.get(id)`
- `pr_lib.dui.list()`
- `pr_lib.dui.poly(target, options)`
- `pr_lib.dui.poly4(target, options)`
- `pr_lib.dui.remove(target, id)`
- `pr_lib.dui.renderTarget(target, options)`
- `pr_lib.dui.replaceTexture(target, options)`
- `pr_lib.dui.send(target, id, message)`
- `pr_lib.dui.sendMessage(target, id, message)`
- `pr_lib.dui.setBrightness(target, id, brightness)`
- `pr_lib.dui.setOpacity(target, id, opacity)`
- `pr_lib.dui.setUrl(target, id, url)`
- `pr_lib.dui.startSprite(target, id, options)`
- `pr_lib.dui.stopPoly(target, id)`
- `pr_lib.dui.stopRenderTarget(target, id)`
- `pr_lib.dui.stopSprite(target, id)`
- `pr_lib.dui.sync(target)`

### client
- `pr_lib.dui.create(options, width, height)`
- `pr_lib.dui.createPoly(target, options)`
- `pr_lib.dui.createRenderTarget(target, options)`
- `pr_lib.dui.createReplacement(target, options)`
- `pr_lib.dui.createReplaceTexture(target, options)`
- `pr_lib.dui.createSprite(options)`
- `pr_lib.dui.destroy(target)`
- `pr_lib.dui.disableMouse(target)`
- `pr_lib.dui.drawSprite(target, options)`
- `pr_lib.dui.enableMouse(target, options)`
- `pr_lib.dui.focus(target, options)`
- `pr_lib.dui.get(id)`
- `pr_lib.dui.list()`
- `pr_lib.dui.nuiUrl(path, ownerResource)`
- `pr_lib.dui.poly(target, options)`
- `pr_lib.dui.removeReplaceTexture(target, options)`
- `pr_lib.dui.renderTarget(target, options)`
- `pr_lib.dui.replaceTexture(target, options)`
- `pr_lib.dui.send(target, message)`
- `pr_lib.dui.sendMessage(target, message)`
- `pr_lib.dui.sendMouseDown(target, button)`
- `pr_lib.dui.sendMouseMove(target, x, y)`
- `pr_lib.dui.sendMouseUp(target, button)`
- `pr_lib.dui.sendMouseWheel(target, deltaX, deltaY)`
- `pr_lib.dui.setBrightness(target, brightness)`
- `pr_lib.dui.setOpacity(target, opacity)`
- `pr_lib.dui.setUrl(target, url)`
- `pr_lib.dui.startPoly(target, options)`
- `pr_lib.dui.startSprite(target, options)`
- `pr_lib.dui.stopPoly(target)`
- `pr_lib.dui.stopRenderTarget(target)`
- `pr_lib.dui.stopSprite(target)`
- `pr_lib.dui.toggleMouse(target, state)`
- `pr_lib.dui.unfocus()`
- `pr_lib.dui.url(path, ownerResource)`

## fivem.tuning

### server
- `pr_lib.fivem.tuning.apply(vehicle, props, options)`
- `pr_lib.fivem.tuning.applyNetId(netId, props, target, options)`
- `pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`
- `pr_lib.fivem.tuning.snapshot()`

### client
- `pr_lib.fivem.tuning.apply(vehicle, props, options)`
- `pr_lib.fivem.tuning.applyNetId(netId, props, options)`
- `pr_lib.fivem.tuning.get(vehicle)`
- `pr_lib.fivem.tuning.repair(vehicle)`
- `pr_lib.fivem.tuning.restore(vehicle, snapshot, options)`
- `pr_lib.fivem.tuning.setExtra(vehicle, extraId, state)`
- `pr_lib.fivem.tuning.setFuel(vehicle, fuelLevel)`
- `pr_lib.fivem.tuning.setMod(vehicle, modType, modIndex, customTires)`
- `pr_lib.fivem.tuning.setNeon(vehicle, enabled, color)`
- `pr_lib.fivem.tuning.setPlate(vehicle, plate)`
- `pr_lib.fivem.tuning.setXenon(vehicle, enabled, color)`
- `pr_lib.fivem.tuning.snapshot(vehicle)`
- `pr_lib.fivem.tuning.toggleMod(vehicle, modType, state)`

## fivem.drawtext

### client
- `pr_lib.drawtext.change(text, position, options)`
- `pr_lib.drawtext.ChangeText(text, position, options)`
- `pr_lib.drawtext.draw2d(params)`
- `pr_lib.drawtext.draw3d(params)`
- `pr_lib.drawtext.DrawText(text, position, options)`
- `pr_lib.drawtext.DrawText2D(params)`
- `pr_lib.drawtext.drawText2d(params)`
- `pr_lib.drawtext.DrawText2d(params)`
- `pr_lib.drawtext.DrawText3D(params)`
- `pr_lib.drawtext.drawText3d(params)`
- `pr_lib.drawtext.DrawText3d(params)`
- `pr_lib.drawtext.hide()`
- `pr_lib.drawtext.HideText()`
- `pr_lib.drawtext.isOpen()`
- `pr_lib.drawtext.keyPressed(delay)`
- `pr_lib.drawtext.KeyPressed(delay)`
- `pr_lib.drawtext.show(text, position, options)`

## fivem.vehicleProperties

### server
- `pr_lib.vehicleProperties.set(vehicle, props, options)`
- `pr_lib.vehicleProperties.setNetId(netId, props, target, options)`
- `pr_lib.vehicleProperties.SetNetIdProperties(netId, props, target, options)`
- `pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, options)`

### client
- `pr_lib.vehicleProperties.get(vehicle)`
- `pr_lib.vehicleProperties.GetVehicleProperties(vehicle)`
- `pr_lib.vehicleProperties.set(vehicle, props, fixVehicle)`
- `pr_lib.vehicleProperties.SetVehicleProperties(vehicle, props, fixVehicle)`

## fivem.streaming

### server
- `pr_lib.fivem.streaming.hash(model)`

### client
- `pr_lib.fivem.streaming.configureEntity(entity, options)`
- `pr_lib.fivem.streaming.createEntity(placementType, model, coords, heading, options)`
- `pr_lib.fivem.streaming.createObject(model, coords, options)`
- `pr_lib.fivem.streaming.createPed(model, coords, heading, options)`
- `pr_lib.fivem.streaming.createProp(model, coords, options)`
- `pr_lib.fivem.streaming.createVehicle(model, coords, heading, options)`
- `pr_lib.fivem.streaming.delete(entity)`
- `pr_lib.fivem.streaming.deleteEntity(entity)`
- `pr_lib.fivem.streaming.findGroundZ(coords, options)`
- `pr_lib.fivem.streaming.getModelDimensions(model, timeout)`
- `pr_lib.fivem.streaming.getModelGroundOffset(model, timeout)`
- `pr_lib.fivem.streaming.loadAnimDict(asset, timeout)`
- `pr_lib.fivem.streaming.loadModel(model, timeout)`
- `pr_lib.fivem.streaming.loadWeaponAsset(model, timeout)`
- `pr_lib.fivem.streaming.PerformAction(data)`
- `pr_lib.fivem.streaming.performAction(data)`
- `pr_lib.fivem.streaming.placeEntityProperly(entity, placementType, options)`
- `pr_lib.fivem.streaming.PlayAction(data)`
- `pr_lib.fivem.streaming.playAction(data)`
- `pr_lib.fivem.streaming.PlayAnim(data, clip, duration, options)`
- `pr_lib.fivem.streaming.playAnim(data, clip, duration, options)`
- `pr_lib.fivem.streaming.PlayAnimation(data, clip, duration, options)`
- `pr_lib.fivem.streaming.playAnimation(data, clip, duration, options)`
- `pr_lib.fivem.streaming.PlayInteraction(data)`
- `pr_lib.fivem.streaming.playInteraction(data)`
- `pr_lib.fivem.streaming.releaseAnimDict(animDict)`
- `pr_lib.fivem.streaming.releaseAnimSet(animSet)`
- `pr_lib.fivem.streaming.releaseAudioBank(audioBank)`
- `pr_lib.fivem.streaming.releaseModel(model)`
- `pr_lib.fivem.streaming.releasePtfxAsset(asset)`
- `pr_lib.fivem.streaming.releaseScaleformMovie(handle)`
- `pr_lib.fivem.streaming.releaseTextureDict(textureDict)`
- `pr_lib.fivem.streaming.releaseWeaponAsset(model)`
- `pr_lib.fivem.streaming.requestAnimDict(animDict, timeout)`
- `pr_lib.fivem.streaming.RequestAnimDict(asset, timeout)`
- `pr_lib.fivem.streaming.requestAnimSet(animSet, timeout)`
- `pr_lib.fivem.streaming.RequestAnimSet(asset, timeout)`
- `pr_lib.fivem.streaming.RequestAudioBank(asset, timeout)`
- `pr_lib.fivem.streaming.requestAudioBank(audioBank, timeout)`
- `pr_lib.fivem.streaming.requestModel(model, timeout)`
- `pr_lib.fivem.streaming.RequestModel(model, timeout)`
- `pr_lib.fivem.streaming.RequestNamedPtfxAsset(asset, timeout)`
- `pr_lib.fivem.streaming.requestPtfxAsset(asset, timeout)`
- `pr_lib.fivem.streaming.RequestScaleformMovie(asset, timeout)`
- `pr_lib.fivem.streaming.requestScaleformMovie(name, timeout)`
- `pr_lib.fivem.streaming.RequestStreamedTextureDict(asset, timeout)`
- `pr_lib.fivem.streaming.requestTextureDict(textureDict, timeout)`
- `pr_lib.fivem.streaming.requestWeaponAsset(model, timeout)`
- `pr_lib.fivem.streaming.setEntityTransform(entity, coords, heading, options)`

## fivem.objects

### server
- `pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`
- `pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestObject(coords, radius, options)`
- `pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`
- `pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`
- `pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getPool(poolName)`
- `pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`
- `pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getPoolName(poolName)`
- `pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`

### client
- `pr_lib.fivem.objects.findObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.findObjectsInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.findVehiclesInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.findVehiclesInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.freezeByModelInRadius(model, coords, radius, state)`
- `pr_lib.fivem.objects.getByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getByPoolInRadius(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestByModel(model, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestFromPool(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getClosestObject(coords, radius, options)`
- `pr_lib.fivem.objects.getClosestVehicle(coords, radius, options)`
- `pr_lib.fivem.objects.getClosestVehicleByModel(model, coords, radius, options)`
- `pr_lib.fivem.objects.getNetworkedObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsByPool(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getObjectsInRadiusUsingPool(coords, radius, options)`
- `pr_lib.fivem.objects.getPedsByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getPedsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getPickupsInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getPool(poolName)`
- `pr_lib.fivem.objects.getPoolByModelInRadius(poolName, model, coords, radius, options)`
- `pr_lib.fivem.objects.getPoolInRadius(poolName, coords, radius, options)`
- `pr_lib.fivem.objects.getPoolName(poolName)`
- `pr_lib.fivem.objects.getVehiclesByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.objects.getVehiclesInRadius(coords, radius, options)`
- `pr_lib.fivem.objects.getVehiclesInRadiusUsingPool(coords, radius, options)`

## fivem.vehicleCache

### shared
- `pr_lib.fivem.vehicleCache.clear(vehicleOrNetId)`
- `pr_lib.fivem.vehicleCache.clearAll()`
- `pr_lib.fivem.vehicleCache.get(vehicleOrNetId)`
- `pr_lib.fivem.vehicleCache.getByPlate(plate)`
- `pr_lib.fivem.vehicleCache.getPersistentMeta(vehicle)`
- `pr_lib.fivem.vehicleCache.getState(vehicle, name)`
- `pr_lib.fivem.vehicleCache.getStateKey(name)`
- `pr_lib.fivem.vehicleCache.set(vehicleOrNetId, data)`
- `pr_lib.fivem.vehicleCache.setPersistentMeta(vehicle, meta)`
- `pr_lib.fivem.vehicleCache.setState(vehicle, name, value, replicated)`

## fivem.blips

### shared
- `pr_lib.fivem.blips.describe(value, colorId)`
- `pr_lib.fivem.blips.getAssetImageUrl(kind, value)`
- `pr_lib.fivem.blips.getBlipImageUrl(value)`
- `pr_lib.fivem.blips.getCheckpointImageUrl(checkpointId)`
- `pr_lib.fivem.blips.getColorInfo(colorId)`
- `pr_lib.fivem.blips.getImageUrl(value)`
- `pr_lib.fivem.blips.getMarkerImageUrl(markerId)`
- `pr_lib.fivem.blips.getPedImageUrl(model)`
- `pr_lib.fivem.blips.getSprite(value)`
- `pr_lib.fivem.blips.getSpriteId(value)`
- `pr_lib.fivem.blips.getSpriteName(value)`
- `pr_lib.fivem.blips.getVehicleImageUrl(model)`
- `pr_lib.fivem.blips.getWeaponImageUrl(model)`
- `pr_lib.fivem.blips.listColors()`
- `pr_lib.fivem.blips.listSprites()`
- `pr_lib.fivem.blips.setDocsBaseUrl(url)`

## fivem.devtools

### client
- `pr_lib.devtools.createPlacement(placementType, modelName, maxSlots, cb, options)`
- `pr_lib.devtools.createPolyzone(options, cb)`
- `pr_lib.devtools.createSphereZone(options, cb)`
- `pr_lib.devtools.DrawPolyzone3D(options, cb)`
- `pr_lib.devtools.drawPolyzone3D(options, cb)`
- `pr_lib.devtools.drawSphereZone(options, cb)`
- `pr_lib.devtools.drawSphereZone3D(options, cb)`
- `pr_lib.devtools.DrawSphereZone3D(options, cb)`
- `pr_lib.devtools.placeObject(modelName, maxSlots, cb, options)`
- `pr_lib.devtools.placePed(modelName, maxSlots, cb, options)`
- `pr_lib.devtools.placeVehicle(modelName, maxSlots, cb, options)`
- `pr_lib.devtools.startEntityPlacement(placementType, modelName, maxSlots, cb, options)`
- `pr_lib.devtools.StartEntityPlacement(placementType, modelName, maxSlots, cb, options)`
- `pr_lib.devtools.stop()`
## fivem_aliases

### server
- `pr_lib.fivem.setVehicleProperties(vehicleOrNetId, properties, options)`
- `pr_lib.fivem.vehicle.setProperties(vehicleOrNetId, properties, options)`
- `pr_lib.fivem.vehicle.getNetId(entity)`
- `pr_lib.fivem.vehicle.getEntity(netId, timeout)`
- `pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`
- `pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`
- `pr_lib.fivem.vehicle.getOwner(entity)`
- `pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`
- `pr_lib.fivem.vehicle.findClosest(coords, radius, options)`
- `pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`
- `pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.vehicles.findClosest(coords, radius, options)`
- `pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`

### client
- `pr_lib.fivem.getVehicleProperties(vehicle)`
- `pr_lib.fivem.setVehicleProperties(vehicle, properties)`
- `pr_lib.fivem.vehicle.getProperties(vehicle)`
- `pr_lib.fivem.vehicle.setProperties(vehicle, properties)`
- `pr_lib.fivem.vehicle.getNetId(entity)`
- `pr_lib.fivem.vehicle.getEntity(netId, timeout)`
- `pr_lib.fivem.vehicle.getVehicle(vehicleOrNetId, timeout)`
- `pr_lib.fivem.vehicle.resolve(vehicleOrNetId, timeout)`
- `pr_lib.fivem.vehicle.getOwner(entity)`
- `pr_lib.fivem.vehicle.findInRadius(coords, radius, options)`
- `pr_lib.fivem.vehicle.findClosest(coords, radius, options)`
- `pr_lib.fivem.vehicles.findInRadius(coords, radius, options)`
- `pr_lib.fivem.vehicles.findByModelInRadius(model, coords, radius, options)`
- `pr_lib.fivem.vehicles.findClosest(coords, radius, options)`
- `pr_lib.fivem.vehicles.findClosestByModel(model, coords, radius, options)`
