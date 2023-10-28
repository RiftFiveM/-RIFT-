RegisterServerEvent("Polar:stretcherAttachPlayer")
AddEventHandler('Polar:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("Polar:toggleAmbulanceDoors")
AddEventHandler('Polar:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("Polar:updateHasStretcherInsideDecor")
AddEventHandler('Polar:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("Polar:updateStretcherLocation")
AddEventHandler('Polar:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:Polar:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("Polar:removeStretcher")
AddEventHandler('Polar:removeStretcher', function(stretcher)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("Polar:forcePlayerOnToStretcher")
AddEventHandler('Polar:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:forcePlayerOnToStretcher', id, stretcher)
    end
end)