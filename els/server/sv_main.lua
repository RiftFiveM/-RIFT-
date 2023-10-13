RegisterNetEvent("RIFTELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('RIFTELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("RIFTELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('RIFTELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("RIFTELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('RIFTELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("RIFTELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('RIFTELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("RIFTELS:vehicleRemoved", function(stage)
	TriggerClientEvent('RIFTELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("RIFTELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('RIFTELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)