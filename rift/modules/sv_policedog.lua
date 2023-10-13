RegisterCommand('k9', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RIFT:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RIFT:policeDogAttack', source)
    end
end)

RegisterNetEvent("RIFT:serverDogAttack")
AddEventHandler("RIFT:serverDogAttack", function(player)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('RIFT:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("RIFT:policeDogSniffPlayer")
AddEventHandler("RIFT:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = RIFT.getUserId(playerSrc)
        local cdata = RIFT.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('RIFT:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("RIFT:performDogLog")
AddEventHandler("RIFT:performDogLog", function(text)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'K9 Trained') then
        tRIFT.sendWebhook('police-k9', 'RIFT Police Dog Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)