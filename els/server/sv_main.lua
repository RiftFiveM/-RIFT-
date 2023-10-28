RegisterNetEvent("PolarELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('PolarELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("PolarELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('PolarELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("PolarELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('PolarELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("PolarELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('PolarELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("PolarELS:vehicleRemoved", function(stage)
	TriggerClientEvent('PolarELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("PolarELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('PolarELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)