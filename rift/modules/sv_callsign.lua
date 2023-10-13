function getCallsign(guildType, source, user_id, type)
    local discord_id = exports['rift']:Get_Client_Discord_ID(source)
    if discord_id then
        local guilds_info = exports['rift']:Get_Guilds()
        for guild_name, guild_id in pairs(guilds_info) do
            if guild_name == guildType then
                local nick_name = exports['rift']:Get_Guild_Nickname(guild_id, discord_id)
                if nick_name then
                    local open_bracket = string.find(nick_name, '[', nil, true) -- Extra Params to toggle pattern matching
                    local closed_bracket = string.find(nick_name, ']', nil, true) -- Extra Params to toggle pattern matching
                    if open_bracket and closed_bracket then
                        local callsign_value = string.sub(nick_name, open_bracket + 1, closed_bracket - 1)
                        return callsign_value, string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), GetPlayerName(source)
                    end
                end
            end
        end
    end
end

RegisterServerEvent("RIFT:getCallsign")
AddEventHandler("RIFT:getCallsign", function(type)
    local source = source
    local user_id = RIFT.getUserId(source)
    Wait(1000)
    if type == 'police' and RIFT.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent("RIFT:receivePoliceCallsign", source, getCallsign('Police', source, user_id, 'Police'))
        TriggerClientEvent("RIFT:setPoliceOnDuty", source, true)
    elseif type == 'prison' and RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("RIFT:receiveHmpCallsign", source, getCallsign('HMP', source, user_id, 'HMP'))
        TriggerClientEvent("RIFT:setPrisonGuardOnDuty", source, true)
    end
end)