function getPlayerFaction(user_id)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        return 'pd'
    elseif Polar.hasPermission(user_id, 'nhs.onduty.permission') then
        return 'nhs'
    elseif Polar.hasPermission(user_id, 'hmp.onduty.permission') then
        return 'hmp'
    elseif Polar.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('Polar:factionAfkAlert')
AddEventHandler('Polar:factionAfkAlert', function(text)
    local source = source
    local user_id = Polar.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tPolar.sendWebhook(getPlayerFaction(user_id)..'-afk', 'Polar AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('Polar:setNoLongerAFK')
AddEventHandler('Polar:setNoLongerAFK', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tPolar.sendWebhook(getPlayerFaction(user_id)..'-afk', 'Polar AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if not Polar.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)