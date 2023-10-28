MySQL.createCommand("Polar/get_prison_time","SELECT prison_time FROM Polar_prison WHERE user_id = @user_id")
MySQL.createCommand("Polar/set_prison_time","UPDATE Polar_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("Polar/add_prisoner", "INSERT IGNORE INTO Polar_prison SET user_id = @user_id")
MySQL.createCommand("Polar/get_current_prisoners", "SELECT * FROM Polar_prison WHERE prison_time > 0")

local cfg = module("cfg/cfg_prison")
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = Polar.getUserId(source)
    MySQL.execute("Polar/add_prisoner", {user_id = user_id})
end)

AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("Polar/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('Polar:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('Polar:forcePlayerInPrison', source, true)
                    TriggerClientEvent('Polar:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('Polar:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('Polar:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
    end
end)

RegisterNetEvent("Polar:getNumOfNHSOnline")
AddEventHandler("Polar:getNumOfNHSOnline", function()
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('Polar:prisonSpawnInMedicalBay', source)
                Polarclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('Polar:getNumberOfDocsOnline', source, #Polar.getUsersByPermission('nhs.onduty.permission'))
            end
        end
    end)
end)

RegisterServerEvent("Polar:prisonArrivedForJail")
AddEventHandler("Polar:prisonArrivedForJail", function()
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                tPolar.setBucket(source, 0)
                TriggerClientEvent('Polar:forcePlayerInPrison', source, true)
                TriggerClientEvent('Polar:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('Polar:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("Polar:prisonStartJob")
AddEventHandler("Polar:prisonStartJob", function(job)
    local source = source
    local user_id = Polar.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("Polar:prisonEndJob")
AddEventHandler("Polar:prisonEndJob", function(job)
    local source = source
    local user_id = Polar.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("Polar/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("Polar/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('Polar:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    Polarclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("Polar:jailPlayer")
AddEventHandler("Polar:jailPlayer", function(player)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        Polarclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                Polarclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("Polar/get_prison_time", {user_id = Polar.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    Polar.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            -- check if gc then compare jailtime to 
                                            -- maxTimeGc = 7200,
                                            MySQL.execute("Polar/set_prison_time", {user_id = Polar.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('Polar:prisonTransportWithBus', player, lastCellUsed+1)
                                            tPolar.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            TriggerClientEvent('Polar:prisonCreateItemAreas', player, prisonItemsTable)
                                            Polarclient.notify(source, {"~g~Jailed Player."})
                                            tPolar.sendWebhook('jail-player', 'Polar Jail Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..GetPlayerName(player).."**\n> Criminal PermID: **"..Polar.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            Polarclient.notify(source, {"~r~Invalid time."})
                                        end
                                    end)
                                else
                                    Polarclient.notify(source, {"~r~Player is already in prison."})
                                end
                            end
                        end)
                    else
                        Polarclient.notify(source, {"~r~You must have the player handcuffed."})
                    end
                end)
            else
                Polarclient.notify(source, {"~r~Player not found."})
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        MySQL.query("Polar/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("Polar/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and Polar.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('Polar:prisonStopClientTimer', Polar.getUserSource(v.user_id))
                        TriggerClientEvent('Polar:prisonReleased', Polar.getUserSource(v.user_id))
                        TriggerClientEvent('Polar:forcePlayerInPrison', Polar.getUserSource(v.user_id), false)
                        Polarclient.setHandcuffed(Polar.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.noclip') then
        Polar.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("Polar/set_prison_time", {user_id = Polar.getUserId(player), prison_time = 0})
                TriggerClientEvent('Polar:prisonStopClientTimer', player)
                TriggerClientEvent('Polar:prisonReleased', player)
                TriggerClientEvent('Polar:forcePlayerInPrison', player, false)
                Polarclient.setHandcuffed(player, {false})
                Polarclient.notify(source, {"~g~Target will be released soon."})
            else
                Polarclient.notify(source, {"~r~Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('Polar:prisonUpdateGuardNumber', -1, #Polar.getUsersByPermission('prisonguard.onduty.permission'))
    end
end)

local currentLockdown = false
RegisterServerEvent("Polar:prisonToggleLockdown")
AddEventHandler("Polar:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('Polar:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('Polar:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("Polar:prisonSetDoorState")
AddEventHandler("Polar:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = Polar.getUserId(source)
    TriggerClientEvent('Polar:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("Polar:enterPrisonAreaSyncDoors")
AddEventHandler("Polar:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = Polar.getUserId(source)
    TriggerClientEvent('Polar:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- Polar:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- Polar:requestPrisonerData