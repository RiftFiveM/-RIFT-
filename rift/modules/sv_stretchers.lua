RegisterServerEvent("RIFT:stretcherAttachPlayer")
AddEventHandler('RIFT:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("RIFT:toggleAmbulanceDoors")
AddEventHandler('RIFT:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("RIFT:updateHasStretcherInsideDecor")
AddEventHandler('RIFT:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("RIFT:updateStretcherLocation")
AddEventHandler('RIFT:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:RIFT:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("RIFT:removeStretcher")
AddEventHandler('RIFT:removeStretcher', function(stretcher)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("RIFT:forcePlayerOnToStretcher")
AddEventHandler('RIFT:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:forcePlayerOnToStretcher', id, stretcher)
    end
end)