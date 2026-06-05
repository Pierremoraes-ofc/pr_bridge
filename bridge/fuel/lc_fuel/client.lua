local fuel = {}
if ActiveBridges["fuel"] ~= "lc_fuel" then return end

---@description Returns the name of the active fuel resource.
---@return string
function fuel.GetResourceName()
    return "lc_fuel"
end

---@description Returns the current fuel level of a vehicle.
---@param vehicle number The vehicle entity handle.
---@return number The vehicle fuel level.
function fuel.GetFuel(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports["lc_fuel"]:GetFuel(vehicle)
end

---@description Sets the fuel level of a vehicle.
---@param vehicle number The vehicle entity handle.
---@param amount number The fuel level to assign.
---@param type? string The fuel type, used only in ti_fuel. (default: RON91)
function fuel.SetFuel(vehicle, amount, type)
    if not DoesEntityExist(vehicle) then return end
    exports["lc_fuel"]:SetFuel(vehicle, amount)
end

return fuel
