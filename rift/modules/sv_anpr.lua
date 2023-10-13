local flaggedVehicles = {}
-- test
AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if RIFT.hasPermission(user_id, 'police.onduty.permission') then
            TriggerClientEvent('RIFT:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("RIFT:flagVehicleAnpr")
AddEventHandler("RIFT:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('RIFT:setFlagVehicles', -1, flaggedVehicles)
    end
end)