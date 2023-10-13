local cfg = module("cfg/survival")
local lang = RIFT.lang


-- handlers

-- init values
AddEventHandler("RIFT:playerJoin", function(user_id, source, name, last_login)
    local data = RIFT.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = RIFT.getUserId(player)
    if user_id ~= nil then
        RIFTclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = RIFT.getUserId(nplayer)
            if nuser_id ~= nil then
                RIFTclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if RIFT.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            RIFTclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                RIFTclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        RIFTclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                RIFTclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('RIFT:SearchForPlayer')
AddEventHandler('RIFT:SearchForPlayer', function()
    TriggerClientEvent('RIFT:ReceiveSearch', -1, source)
end)


-- Freaking noob