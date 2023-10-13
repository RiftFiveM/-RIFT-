MySQL.createCommand("RIFT/get_prison_time","SELECT prison_time FROM rift_prison WHERE user_id = @user_id")
MySQL.createCommand("RIFT/set_prison_time","UPDATE rift_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("RIFT/add_prisoner", "INSERT IGNORE INTO rift_prison SET user_id = @user_id")
MySQL.createCommand("RIFT/get_current_prisoners", "SELECT * FROM rift_prison WHERE prison_time > 0")

local cfg = module("cfg/cfg_prison")
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = RIFT.getUserId(source)
    MySQL.execute("RIFT/add_prisoner", {user_id = user_id})
end)

AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("RIFT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('RIFT:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('RIFT:forcePlayerInPrison', source, true)
                    TriggerClientEvent('RIFT:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('RIFT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('RIFT:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
    end
end)

RegisterNetEvent("RIFT:getNumOfNHSOnline")
AddEventHandler("RIFT:getNumOfNHSOnline", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    MySQL.query("RIFT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('RIFT:prisonSpawnInMedicalBay', source)
                RIFTclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('RIFT:getNumberOfDocsOnline', source, #RIFT.getUsersByPermission('nhs.onduty.permission'))
            end
        end
    end)
end)

RegisterServerEvent("RIFT:prisonArrivedForJail")
AddEventHandler("RIFT:prisonArrivedForJail", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    MySQL.query("RIFT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                tRIFT.setBucket(source, 0)
                TriggerClientEvent('RIFT:forcePlayerInPrison', source, true)
                TriggerClientEvent('RIFT:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('RIFT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("RIFT:prisonStartJob")
AddEventHandler("RIFT:prisonStartJob", function(job)
    local source = source
    local user_id = RIFT.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("RIFT:prisonEndJob")
AddEventHandler("RIFT:prisonEndJob", function(job)
    local source = source
    local user_id = RIFT.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("RIFT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("RIFT/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('RIFT:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    RIFTclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("RIFT:jailPlayer")
AddEventHandler("RIFT:jailPlayer", function(player)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        RIFTclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                RIFTclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("RIFT/get_prison_time", {user_id = RIFT.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    RIFT.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            -- check if gc then compare jailtime to 
                                            -- maxTimeGc = 7200,
                                            MySQL.execute("RIFT/set_prison_time", {user_id = RIFT.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('RIFT:prisonTransportWithBus', player, lastCellUsed+1)
                                            tRIFT.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            TriggerClientEvent('RIFT:prisonCreateItemAreas', player, prisonItemsTable)
                                            RIFTclient.notify(source, {"~g~Jailed Player."})
                                            tRIFT.sendWebhook('jail-player', 'RIFT Jail Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..GetPlayerName(player).."**\n> Criminal PermID: **"..RIFT.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            RIFTclient.notify(source, {"~r~Invalid time."})
                                        end
                                    end)
                                else
                                    RIFTclient.notify(source, {"~r~Player is already in prison."})
                                end
                            end
                        end)
                    else
                        RIFTclient.notify(source, {"~r~You must have the player handcuffed."})
                    end
                end)
            else
                RIFTclient.notify(source, {"~r~Player not found."})
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        MySQL.query("RIFT/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("RIFT/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and RIFT.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('RIFT:prisonStopClientTimer', RIFT.getUserSource(v.user_id))
                        TriggerClientEvent('RIFT:prisonReleased', RIFT.getUserSource(v.user_id))
                        TriggerClientEvent('RIFT:forcePlayerInPrison', RIFT.getUserSource(v.user_id), false)
                        RIFTclient.setHandcuffed(RIFT.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.noclip') then
        RIFT.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("RIFT/set_prison_time", {user_id = RIFT.getUserId(player), prison_time = 0})
                TriggerClientEvent('RIFT:prisonStopClientTimer', player)
                TriggerClientEvent('RIFT:prisonReleased', player)
                TriggerClientEvent('RIFT:forcePlayerInPrison', player, false)
                RIFTclient.setHandcuffed(player, {false})
                RIFTclient.notify(source, {"~g~Target will be released soon."})
            else
                RIFTclient.notify(source, {"~r~Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('RIFT:prisonUpdateGuardNumber', -1, #RIFT.getUsersByPermission('prisonguard.onduty.permission'))
    end
end)

local currentLockdown = false
RegisterServerEvent("RIFT:prisonToggleLockdown")
AddEventHandler("RIFT:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('RIFT:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('RIFT:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("RIFT:prisonSetDoorState")
AddEventHandler("RIFT:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("RIFT:enterPrisonAreaSyncDoors")
AddEventHandler("RIFT:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- RIFT:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- RIFT:requestPrisonerData