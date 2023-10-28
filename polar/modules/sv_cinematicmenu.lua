RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('Polar:openCinematicMenu', source)
    end
end)