local spikes = 0
local speedzones = 0

RegisterNetEvent("RIFT:placeSpike")
AddEventHandler("RIFT:placeSpike", function(heading, coords)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('RIFT:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("RIFT:removeSpike")
AddEventHandler("RIFT:removeSpike", function(entity)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('RIFT:deleteSpike', -1, entity)
        TriggerClientEvent("RIFT:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("RIFT:requestSceneObjectDelete")
AddEventHandler("RIFT:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("RIFT:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("RIFT:createSpeedZone")
AddEventHandler("RIFT:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
        speedzones = speedzones + 1
        TriggerClientEvent('RIFT:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("RIFT:deleteSpeedZone")
AddEventHandler("RIFT:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('RIFT:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

