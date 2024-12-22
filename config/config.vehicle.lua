Config = Config or {}

Config.Units = 'kph'          -- or "mph"

Config.ShowGear = false       -- Whether to show the gear in the speedometer.
Config.UsingChaser = false    -- Whether to use the chaser gear system https://legacydmc.net/chaser/.

Config.FuelSystem = 'ox_fuel' -- or "LegacyFuel", "ps-fuel", "ox_fuel", "cdn-fuel", "hyon_gas_station", "okokGasStation", "myFuel", "ti_fuel", "none"

Config.Nitro = 'jg-mechanic'    -- or "qbx_nitro", "jg-mechanic", "none"

Config.VehiclesWithoutFuel = {
    [`bmx`] = true,
    [`cruiser`] = true,
    [`fixter`] = true,
    [`scorcher`] = true,
    [`tribike`] = true,
    [`tribike2`] = true,
    [`tribike3`] = true,
}

Config.GetVehicleEngineHealth = function(vehicleEntity)
    return GetVehicleEngineHealth(vehicleEntity)
end

Config.ShowVehicleLocked = false -- Whether to show if the vehicle is locked or not.
Config.VehicleLocked = function(vehicleEntity)
    return GetVehicleDoorLockStatus(vehicleEntity) == 2
end

-- Refresh rate table for the speedometer.
-- Higher refresh rate will consume less resources but will update the speedometer less frequently.
Config.RefreshRateTable = {
    ['performance'] = 200,
    ['normal'] = 75,
}
