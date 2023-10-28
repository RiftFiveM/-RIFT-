local cfg = module("cfg/survival")
local lang = Polar.lang


-- handlers

-- init values
AddEventHandler("Polar:playerJoin", function(user_id, source, name, last_login)
    local data = Polar.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = Polar.getUserId(player)
    if user_id ~= nil then
        Polarclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = Polar.getUserId(nplayer)
            if nuser_id ~= nil then
                Polarclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if Polar.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            Polarclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                Polarclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        Polarclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                Polarclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('Polar:SearchForPlayer')
AddEventHandler('Polar:SearchForPlayer', function()
    TriggerClientEvent('Polar:ReceiveSearch', -1, source)
end)


-- Freaking noob