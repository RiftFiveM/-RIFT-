local spikes = 0
local speedzones = 0

RegisterNetEvent("Polar:placeSpike")
AddEventHandler("Polar:placeSpike", function(heading, coords)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('Polar:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("Polar:removeSpike")
AddEventHandler("Polar:removeSpike", function(entity)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('Polar:deleteSpike', -1, entity)
        TriggerClientEvent("Polar:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("Polar:requestSceneObjectDelete")
AddEventHandler("Polar:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("Polar:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("Polar:createSpeedZone")
AddEventHandler("Polar:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
        speedzones = speedzones + 1
        TriggerClientEvent('Polar:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("Polar:deleteSpeedZone")
AddEventHandler("Polar:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('Polar:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

