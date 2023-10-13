RegisterServerEvent('RIFT:playTaserSound')
AddEventHandler('RIFT:playTaserSound', function(coords, sound)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('RIFT:reactivatePed')
AddEventHandler('RIFT:reactivatePed', function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('RIFT:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('RIFT:arcTaser')
AddEventHandler('RIFT:arcTaser', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
      RIFTclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = RIFT.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('RIFT:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('RIFT:barbsNoLongerServer')
AddEventHandler('RIFT:barbsNoLongerServer', function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('RIFT:barbsNoLonger', id)
    end
end)

RegisterServerEvent('RIFT:barbsRippedOutServer')
AddEventHandler('RIFT:barbsRippedOutServer', function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    TriggerClientEvent('RIFT:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'police.onduty.permission') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('RIFT:reloadTaser', source)
  end
end)