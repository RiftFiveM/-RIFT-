local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0
local cfg = module('cfg/cfg_organheist')


RegisterNetEvent("RIFT:joinOrganHeist")
AddEventHandler("RIFT:joinOrganHeist",function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not playersInOrganHeist[user_id] then
        if inWaitingStage then
            if RIFT.hasPermission(user_id, 'police.onduty.permission') then
                playersInOrganHeist[source] = {type = 'police'}
                policeInGame = policeInGame+1
                TriggerClientEvent('RIFT:addOrganHeistPlayer', -1, source, 'police')
                TriggerClientEvent('RIFT:teleportToOrganHeist', source, cfg.locations[1].safePositions[math.random(2)], timeTillOrgan, 'police', 1)
            elseif RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
                RIFTclient.notify(source, {'~r~You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[source] = {type = 'civ'}
                civsInGame = civsInGame+1
                TriggerClientEvent('RIFT:addOrganHeistPlayer', -1, source, 'civ')
                TriggerClientEvent('RIFT:teleportToOrganHeist', source, cfg.locations[2].safePositions[math.random(2)], timeTillOrgan, 'civ', 2)
                RIFTclient.giveWeapons(source, {{['WEAPON_ROOK'] = {ammo = 250}}, false})
            end
            tRIFT.setBucket(source, 15)
            RIFTclient.setArmour(source, {100, true})
        else
            RIFTclient.notify(source, {'~r~The organ heist has already started.'})
        end
    end
end)

local timeTillOrgan2 = 600 

RegisterCommand('restartorgan', function(source, args)
    local source = source
    local user_id = RIFT.getUserId(source)
    
    if user_id == 1 then
        inWaitingStage = true

        local countdownSeconds = 600

        Citizen.CreateThread(function()
            for timeTillOrgan2 = countdownSeconds, 60, -60 do
                local minutes = math.floor(timeTillOrgan2 / 60)
                local minutesRemaining = math.floor((timeTillOrgan2 - 600) / 60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist has been triggered and beings soon! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
                Citizen.Wait(60 * 1000)
            end
            if inGamePhase then
                RIFTclient.notify(source, {'Since this event has been triggered, the timer will be different.'})
            end
            if civsInGame > 0 and policeInGame > 0 then
                TriggerClientEvent('RIFT:startOrganHeist', -1)
                inGamePhase = true
                inWaitingStage = false
            end
        end)
    end
end)


RegisterNetEvent("RIFT:diedInOrganHeist")
AddEventHandler("RIFT:diedInOrganHeist",function(killer)
    local source = source
    if playersInOrganHeist[source] then
        if RIFT.getUserId(killer) ~= nil then
            local killerID = RIFT.getUserId(killer)
            RIFT.giveBankMoney(killerID, 25000)
            TriggerClientEvent('RIFT:organHeistKillConfirmed', killer, GetPlayerName(source))
        end
        TriggerClientEvent('RIFT:endOrganHeist', source)
        TriggerClientEvent('RIFT:removeFromOrganHeist', -1, source)
        tRIFT.setBucket(source, 0)
        playersInOrganHeist[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    if playersInOrganHeist[source] then
        playersInOrganHeist[source] = nil
        TriggerClientEvent('RIFT:removeFromOrganHeist', -1, source)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if inGamePhase then
            local policeAlive = 0
            local civAlive = 0
            for k,v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive +1
                end
            end
            if policeAlive == 0 or civAlive == 0 then
                for k,v in pairs(playersInOrganHeist) do
                    if policeAlive == 0 then
                        TriggerClientEvent('RIFT:endOrganHeistWinner', k, 'Civillians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('RIFT:endOrganHeistWinner', k, 'Police')
                    end
                    TriggerClientEvent('RIFT:endOrganHeist', k)
                    tRIFT.setBucket(k, 0)
                    RIFT.giveBankMoney(RIFT.getUserId(k), 250000)
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 18 and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((60-tonumber(time["min"]))*60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist starts in ^1"..math.floor((timeTillOrgan/60)).." minutes! Make your way over to the Morgue with a weapon", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 19 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('RIFT:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k,v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('RIFT:endOrganHeist', k)
                        RIFTclient.notify(k, {'~r~Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                        tRIFT.setBucket(k, 0)
                    end
                end
            end
        end
    end
end)