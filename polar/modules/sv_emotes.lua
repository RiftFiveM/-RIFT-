RegisterNetEvent('Polar:sendSharedEmoteRequest')
AddEventHandler('Polar:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('Polar:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('Polar:receiveSharedEmoteRequest')
AddEventHandler('Polar:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('Polar:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('Polar:receiveSharedEmoteRequest', source, a)
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

AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = Polar.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('Polar:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function Polar.ShaveHead(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        Polarclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                Polarclient.globalSurrenderring(nplayer,{},function(surrendering)
                    if surrendering then
                        Polar.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('Polar:startShavingPlayer', source, nplayer)
                        TriggerClientEvent('Polar:startBeingShaved', nplayer, source)
                        TriggerClientEvent('Polar:playDelayedShave', -1, source)
                        shavedPlayers[Polar.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        Polarclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                Polarclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
