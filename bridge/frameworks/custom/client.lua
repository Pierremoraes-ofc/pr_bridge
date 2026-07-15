local framework = {}
if ActiveBridges["frameworks"] ~= "custom" then return end

-- Custom framework client contract.
-- Replace the safe defaults below with calls to your framework.

function framework.GetResourceName() return "custom" end
function framework.GetPlayerData() return {} end
function framework.GetPlayer() return framework.GetPlayerData() end
function framework.IsPlayerLoaded() return false end
function framework.GetPlayerIdentifier() return nil end
function framework.GetPlayerName() return { fullName = "", firstName = "", lastName = "" } end
function framework.GetPlayerGender() return nil end
function framework.GetPlayerDob() return "" end
function framework.IsPlayerDead() return IsEntityDead(PlayerPedId()) end

function framework.GetPlayerJob()
    return { name = "", label = "", grade = 0, gradeLabel = "", onduty = false }
end
function framework.GetJobInfo()
    local job = framework.GetPlayerJob()
    return { grade = job.grade, gradeName = job.gradeLabel, jobName = job.name, jobLabel = job.label }
end
function framework.PlayerHasJob(jobName, grade) return false end
function framework.GetPlayerGroup() return "user" end

function framework.GetClosestPlayer()
    local closest, distance = -1, -1
    local coords = GetEntityCoords(PlayerPedId())
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local current = #(GetEntityCoords(GetPlayerPed(player)) - coords)
            if distance < 0 or current < distance then closest, distance = player, current end
        end
    end
    return closest, distance
end
function framework.GetClosestVehicle()
    local coords = GetEntityCoords(PlayerPedId())
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 100.0, 0, 71)
    return vehicle, vehicle ~= 0 and #(GetEntityCoords(vehicle) - coords) or -1
end

function framework.GetMoney(account) return 0 end
framework.GetAccountBalance = framework.GetMoney
function framework.getPlayerMetadata(key) return nil end
framework.GetPlayerMetadata = framework.getPlayerMetadata

function framework.Notify(message, kind, duration)
    if Bridge.notify and Bridge.notify.Notify then
        return Bridge.notify.Notify({ description = message, type = kind, duration = duration })
    end
    return false
end
function framework.ShowTextUI(text)
    return Bridge.textuiAdapter and Bridge.textuiAdapter.Show and Bridge.textuiAdapter.Show(text) or false
end
function framework.HideTextUI()
    return Bridge.textuiAdapter and Bridge.textuiAdapter.Hide and Bridge.textuiAdapter.Hide() or false
end

-- Inventory fallbacks. Prefer implementing inventory adapters under bridge/inventories.
function framework.GetItemCount(itemName, metadata, strict) return 0 end
function framework.HasItem(itemName, count, metadata, strict) return false end
function framework.GetPlayerInventory() return {} end

function framework.toggleOutfit(wear, outfits) return false end

return framework