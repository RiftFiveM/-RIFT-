RegisterCommand('k9', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('Polar:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('Polar:policeDogAttack', source)
    end
end)

RegisterNetEvent("Polar:serverDogAttack")
AddEventHandler("Polar:serverDogAttack", function(player)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('Polar:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("Polar:policeDogSniffPlayer")
AddEventHandler("Polar:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = Polar.getUserId(playerSrc)
        local cdata = Polar.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('Polar:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("Polar:performDogLog")
AddEventHandler("Polar:performDogLog", function(text)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'K9 Trained') then
        tPolar.sendWebhook('police-k9', 'Polar Police Dog Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)