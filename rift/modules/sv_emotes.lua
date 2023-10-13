RegisterNetEvent('RIFT:sendSharedEmoteRequest')
AddEventHandler('RIFT:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('RIFT:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('RIFT:receiveSharedEmoteRequest')
AddEventHandler('RIFT:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('RIFT:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('RIFT:receiveSharedEmoteRequest', source, a)
end)

local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = RIFT.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('RIFT:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function RIFT.ShaveHead(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        RIFTclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                RIFTclient.globalSurrenderring(nplayer,{},function(surrendering)
                    if surrendering then
                        RIFT.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('RIFT:startShavingPlayer', source, nplayer)
                        TriggerClientEvent('RIFT:startBeingShaved', nplayer, source)
                        TriggerClientEvent('RIFT:playDelayedShave', -1, source)
                        shavedPlayers[RIFT.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        RIFTclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                RIFTclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
