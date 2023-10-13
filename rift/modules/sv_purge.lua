local purgeLB = {[1] = {"foid", 10}}

RegisterServerEvent('RIFT:getTopFraggers')
AddEventHandler('RIFT:getTopFraggers', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:gotTopFraggers', source, purgeLB)
end)

RegisterCommand('addkill', function()
    if RIFT.hasGroup(user_id, 'Founder') then
    end
    TriggerClientEvent('RIFT:incrementPurgeKills', -1)
end)

RegisterCommand('purgespawn', function()
    if RIFT.hasGroup(user_id, 'TutorialDone') then
    end
    TriggerClientEvent('RIFT:purgeSpawnClient', -1)
end)