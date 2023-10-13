RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('RIFT:openCinematicMenu', source)
    end
end)