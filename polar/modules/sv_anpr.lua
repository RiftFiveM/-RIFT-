local flaggedVehicles = {}
-- test
AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if Polar.hasPermission(user_id, 'police.onduty.permission') then
            TriggerClientEvent('Polar:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("Polar:flagVehicleAnpr")
AddEventHandler("Polar:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('Polar:setFlagVehicles', -1, flaggedVehicles)
    end
end)