function getPlayerFaction(user_id)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        return 'pd'
    elseif RIFT.hasPermission(user_id, 'nhs.onduty.permission') then
        return 'nhs'
    elseif RIFT.hasPermission(user_id, 'hmp.onduty.permission') then
        return 'hmp'
    elseif RIFT.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('RIFT:factionAfkAlert')
AddEventHandler('RIFT:factionAfkAlert', function(text)
    local source = source
    local user_id = RIFT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tRIFT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'RIFT AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('RIFT:setNoLongerAFK')
AddEventHandler('RIFT:setNoLongerAFK', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tRIFT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'RIFT AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not RIFT.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)