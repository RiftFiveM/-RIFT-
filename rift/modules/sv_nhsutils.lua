local bodyBags = {}

RegisterServerEvent("RIFT:requestBodyBag")
AddEventHandler('RIFT:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("RIFT:removeBodybag")
AddEventHandler('RIFT:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("RIFT:playNhsSound")
AddEventHandler('RIFT:playNhsSound', function(sound)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('RIFT:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("RIFT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("RIFT:attachLifepakServer")
AddEventHandler('RIFT:attachLifepakServer', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        RIFTclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = RIFT.getUserId(nplayer)
            if nuser_id ~= nil then
                RIFTclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('RIFT:attachLifepak', source, in_coma, nuser_id, nplayer, GetPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                RIFTclient.notify(source, {"~r~There is no player nearby"})
            end
        end)
    else
        TriggerEvent("RIFT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("RIFT:finishRevive")
AddEventHandler('RIFT:finishRevive', function(permid)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('RIFT:returnRevive', source)
                RIFT.giveBankMoney(user_id, 5000)
                RIFTclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                RIFTclient.RevivePlayer(RIFT.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("RIFT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("RIFT:nhsRevive")
AddEventHandler('RIFT:nhsRevive', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        RIFTclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('RIFT:beginRevive', source, in_coma, RIFT.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = RIFT.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("RIFT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}
RegisterServerEvent("RIFT:attemptCPR")
AddEventHandler('RIFT:attemptCPR', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFTclient.getNearestPlayers(source,{15},function(nplayers)
        if nplayers[playersrc] then
            if GetEntityHealth(GetPlayerPed(playersrc)) > 102 then
                RIFTclient.notify(source, {"~r~This person already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('RIFT:attemptCPR', source)
                Wait(15000)
                if playersInCPR[user_id] then
                    local cprChance = math.random(1,5)
                    if cprChance == 1 then
                        RIFTclient.RevivePlayer(playersrc, {})
                        RIFTclient.notify(playersrc, {"~b~Your life has been saved."})
                        RIFTclient.notify(source, {"~b~You have saved this Person's Life."})
                    else
                        RIFTclient.notify(source, {'~r~Failed to CPR.'})
                    end
                    playersInCPR[user_id] = nil
                    TriggerClientEvent('RIFT:cancelCPRAttempt', source)
                end
            end
        else
            RIFTclient.notify(source, {"~r~Player not found."})
        end
    end)
end)

RegisterServerEvent("RIFT:cancelCPRAttempt")
AddEventHandler('RIFT:cancelCPRAttempt', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        TriggerClientEvent('RIFT:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("RIFT:syncWheelchairPosition")
AddEventHandler('RIFT:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = RIFT.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("RIFT:wheelchairAttachPlayer")
AddEventHandler('RIFT:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:wheelchairAttachPlayer', -1, entity, source)
end)