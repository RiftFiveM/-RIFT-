RegisterNetEvent('RIFT:checkTutorial')
AddEventHandler('RIFT:checkTutorial', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not RIFT.hasGroup(user_id, 'TutorialDone') then
        TriggerClientEvent('RIFT:playTutorial', source)
        tRIFT.setBucket(source, user_id)
        TriggerClientEvent('RIFT:setBucket', source, user_id)
    end
end)

RegisterNetEvent('RIFT:setCompletedTutorial')
AddEventHandler('RIFT:setCompletedTutorial', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not RIFT.hasGroup(user_id, 'TutorialDone') then
        RIFT.addUserGroup(user_id, 'TutorialDone')
        tRIFT.setBucket(source, 0)
        TriggerClientEvent('RIFT:setBucket', source, 0)
    end
end)