RegisterServerEvent('Polar:playTaserSound')
AddEventHandler('Polar:playTaserSound', function(coords, sound)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('Polar:reactivatePed')
AddEventHandler('Polar:reactivatePed', function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('Polar:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('Polar:arcTaser')
AddEventHandler('Polar:arcTaser', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
      Polarclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = Polar.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('Polar:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('Polar:barbsNoLongerServer')
AddEventHandler('Polar:barbsNoLongerServer', function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('Polar:barbsNoLonger', id)
    end
end)

RegisterServerEvent('Polar:barbsRippedOutServer')
AddEventHandler('Polar:barbsRippedOutServer', function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    TriggerClientEvent('Polar:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'police.onduty.permission') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('Polar:reloadTaser', source)
  end
end)