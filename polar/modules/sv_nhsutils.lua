local bodyBags = {}

RegisterServerEvent("Polar:requestBodyBag")
AddEventHandler('Polar:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("Polar:removeBodybag")
AddEventHandler('Polar:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = Polar.getUserId(source)
    TriggerClientEvent('Polar:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("Polar:playNhsSound")
AddEventHandler('Polar:playNhsSound', function(sound)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('Polar:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("Polar:attachLifepakServer")
AddEventHandler('Polar:attachLifepakServer', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        Polarclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = Polar.getUserId(nplayer)
            if nuser_id ~= nil then
                Polarclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('Polar:attachLifepak', source, in_coma, nuser_id, nplayer, GetPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                Polarclient.notify(source, {"~r~There is no player nearby"})
            end
        end)
    else
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("Polar:finishRevive")
AddEventHandler('Polar:finishRevive', function(permid)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('Polar:returnRevive', source)
                Polar.giveBankMoney(user_id, 5000)
                Polarclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                Polarclient.RevivePlayer(Polar.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("Polar:nhsRevive")
AddEventHandler('Polar:nhsRevive', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        Polarclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('Polar:beginRevive', source, in_coma, Polar.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = Polar.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}
RegisterServerEvent("Polar:attemptCPR")
AddEventHandler('Polar:attemptCPR', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    Polarclient.getNearestPlayers(source,{15},function(nplayers)
        if nplayers[playersrc] then
            if GetEntityHealth(GetPlayerPed(playersrc)) > 102 then
                Polarclient.notify(source, {"~r~This person already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('Polar:attemptCPR', source)
                Wait(15000)
                if playersInCPR[user_id] then
                    local cprChance = math.random(1,5)
                    if cprChance == 1 then
                        Polarclient.RevivePlayer(playersrc, {})
                        Polarclient.notify(playersrc, {"~b~Your life has been saved."})
                        Polarclient.notify(source, {"~b~You have saved this Person's Life."})
                    else
                        Polarclient.notify(source, {'~r~Failed to CPR.'})
                    end
                    playersInCPR[user_id] = nil
                    TriggerClientEvent('Polar:cancelCPRAttempt', source)
                end
            end
        else
            Polarclient.notify(source, {"~r~Player not found."})
        end
    end)
end)

RegisterServerEvent("Polar:cancelCPRAttempt")
AddEventHandler('Polar:cancelCPRAttempt', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        TriggerClientEvent('Polar:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("Polar:syncWheelchairPosition")
AddEventHandler('Polar:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = Polar.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("Polar:wheelchairAttachPlayer")
AddEventHandler('Polar:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = Polar.getUserId(source)
    TriggerClientEvent('Polar:wheelchairAttachPlayer', -1, entity, source)
end)