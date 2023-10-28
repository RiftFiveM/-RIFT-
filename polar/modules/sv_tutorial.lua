RegisterNetEvent('Polar:checkTutorial')
AddEventHandler('Polar:checkTutorial', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if not Polar.hasGroup(user_id, 'TutorialDone') then
        TriggerClientEvent('Polar:playTutorial', source)
        tPolar.setBucket(source, user_id)
        TriggerClientEvent('Polar:setBucket', source, user_id)
    end
end)

RegisterNetEvent('Polar:setCompletedTutorial')
AddEventHandler('Polar:setCompletedTutorial', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if not Polar.hasGroup(user_id, 'TutorialDone') then
        Polar.addUserGroup(user_id, 'TutorialDone')
        tPolar.setBucket(source, 0)
        TriggerClientEvent('Polar:setBucket', source, 0)
    end
end)