
-- this module define some police tools and functions
local lang = Polar.lang
local a = module("Polar-weapons", "cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = Polar.getUserId(player)
    local data = Polar.getUserDataTable(user_id)
    Polarclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
        tPolar.getSubscriptions(user_id, function(cb, plushours, plathours)
          if cb then
            local maxWeight = 30
            if plathours > 0 then
              maxWeight = 50
            elseif plushours > 0 then
              maxWeight = 40
            end
            if Polar.getInventoryWeight(user_id) <= maxWeight then
              isStoring[player] = true
              Polarclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                  if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                    Polar.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                      for i,c in pairs(a.weapons) do
                        if i == k and c.class ~= 'Melee' then
                          if v.ammo > 250 then
                            v.ammo = 250
                          end
                          Polar.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                        end   
                      end
                    end
                  end
                end
                Polarclient.notify(player,{"~g~Weapons Stored"})
                TriggerEvent('Polar:RefreshInventory', player)
                Polarclient.ClearWeapons(player,{})
                data.weapons = {}
                SetTimeout(3000,function()
                    isStoring[player] = nil 
                end)
              end)
            else
              Polarclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
          end
        end)
      end 
    end)
end

RegisterServerEvent("Polar:forceStoreSingleWeapon")
AddEventHandler("Polar:forceStoreSingleWeapon",function(model)
    local source = source
    local user_id = Polar.getUserId(source)
    if model ~= nil then
      Polarclient.getWeapons(source,{},function(weapons)
        for k,v in pairs(weapons) do
          if k == model then
            local new_weight = Polar.getInventoryWeight(user_id)+Polar.getItemWeight(model)
            if new_weight <= Polar.getInventoryMaxWeight(user_id) then
              RemoveWeaponFromPed(GetPlayerPed(source), k)
              Polarclient.removeWeapon(source,{k})
              Polar.giveInventoryItem(user_id, "wbody|"..k, 1, true)
              if v.ammo > 0 then
                for i,c in pairs(a.weapons) do
                  if i == model and c.class ~= 'Melee' then
                    Polar.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                  end   
                end
              end
            end
          end
        end
      end)
    end
end)

local cooldowns = {}

RegisterCommand('storeallweapons', function(source)
    local playerId = source
    local currentTime = os.time()
    if not cooldowns[playerId] or (currentTime - cooldowns[playerId] >= 3) then
        choice_store_weapons(playerId)
        cooldowns[playerId] = currentTime
    else
      Polarclient.notify(source, {'~r~You must wait 3 seconds before using this command again.'})
    end
end)


RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'cop.whitelisted') then
    TriggerClientEvent('Polar:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  Polarclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      Polarclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and Polar.hasPermission(user_id, 'admin.tickets')) or Polar.hasPermission(user_id, 'cop.whitelisted') then
          Polarclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = Polar.getUserId(nplayer)
              if (not Polar.hasPermission(nplayer_id, 'cop.whitelisted') or Polar.hasPermission(nplayer_id, 'police.undercover')) then
                Polarclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('Polar:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('Polar:unHandcuff', source, false)
                  else
                    TriggerClientEvent('Polar:arrestCriminal', nplayer, source)
                    TriggerClientEvent('Polar:arrestFromPolice', source)
                  end
                  TriggerClientEvent('Polar:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('Polar:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              Polarclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  Polarclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      Polarclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and Polar.hasPermission(user_id, 'admin.tickets')) or Polar.hasPermission(user_id, 'cop.whitelisted') then
          Polarclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = Polar.getUserId(nplayer)
              if (not Polar.hasPermission(nplayer_id, 'cop.whitelisted') or Polar.hasPermission(nplayer_id, 'police.undercover')) then
                Polarclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('Polar:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('Polar:unHandcuff', source, true)
                  else
                    TriggerClientEvent('Polar:arrestCriminal', nplayer, source)
                    TriggerClientEvent('Polar:arrestFromPolice', source)
                  end
                  TriggerClientEvent('Polar:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('Polar:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              Polarclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function Polar.handcuffKeys(source)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    Polarclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = Polar.getUserId(nplayer)
        Polarclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            Polar.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('Polar:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('Polar:unHandcuff', source, false)
            TriggerClientEvent('Polar:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('Polar:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        Polarclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("Polar:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            Polarclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('Polar:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('Polar:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('Polar:dragPlayer')
AddEventHandler('Polar:dragPlayer', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and (Polar.hasPermission(user_id, "cop.whitelisted") or Polar.hasPermission(user_id, "prisonguard.onduty.permission")) then
      if playersrc ~= nil then
        local nuser_id = Polar.getUserId(playersrc)
          if nuser_id ~= nil then
            Polarclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("Polar:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("Polar:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    Polarclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              Polarclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          Polarclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('Polar:putInVehicle')
AddEventHandler('Polar:putInVehicle', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cop.whitelisted") then
      if playersrc ~= nil then
        Polarclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            Polarclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            Polarclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('Polar:ejectFromVehicle')
AddEventHandler('Polar:ejectFromVehicle', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cop.whitelisted") then
      Polarclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = Polar.getUserId(nplayer)
        if nuser_id ~= nil then
          Polarclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              Polarclient.ejectVehicle(nplayer, {})
            else
              Polarclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          Polarclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("Polar:Knockout")
AddEventHandler('Polar:Knockout', function()
    local source = source
    local user_id = Polar.getUserId(source)
    Polarclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = Polar.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('Polar:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('Polar:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("Polar:KnockoutNoAnim")
AddEventHandler('Polar:KnockoutNoAnim', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Founder') or Polar.hasGroup(user_id, 'Lead Developer') then
      Polarclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = Polar.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('Polar:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('Polar:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("Polar:requestPlaceBagOnHead")
AddEventHandler('Polar:requestPlaceBagOnHead', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      Polarclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = Polar.getUserId(nplayer)
          if nuser_id ~= nil then
              Polar.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('Polar:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('Polar:gunshotTest')
AddEventHandler('Polar:gunshotTest', function(playersrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cop.whitelisted") then
      if playersrc ~= nil then
        Polarclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            Polarclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            Polarclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('Polar:tryTackle')
AddEventHandler('Polar:tryTackle', function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') or Polar.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('Polar:playTackle', source)
        TriggerClientEvent('Polar:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasGroup(user_id, 'Drone Trained') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'cop.whitelisted') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('Polar:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('Polar:startThrowSmokeGrenade')
AddEventHandler('Polar:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('Polar:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('Polar:breathalyserCommand', source)
  end
end)

RegisterServerEvent('Polar:breathalyserRequest')
AddEventHandler('Polar:breathalyserRequest', function(temp)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('Polar:beingBreathalysed', temp)
      TriggerClientEvent('Polar:breathTestResult', source, math.random(0, 100), GetPlayerName(temp))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
  ['5.56mm NATO'] = true,
}

RegisterServerEvent('Polar:seizeWeapons')
AddEventHandler('Polar:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') then
      Polarclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = Polar.getUserId(playerSrc)
          local cdata = Polar.getUserDataTable(player_id)
          for a,b in pairs(cdata.inventory) do
              if string.find(a, 'wbody|') then
                  c = a:gsub('wbody|', '')
                  cdata.inventory[c] = b
                  cdata.inventory[a] = nil
              end
          end
          for k,v in pairs(a.weapons) do
              if cdata.inventory[k] ~= nil then
                  if not v.policeWeapon then
                    cdata.inventory[k] = nil
                  end
              end
          end
          for c,d in pairs(cdata.inventory) do
              if seizeBullets[c] then
                cdata.inventory[c] = nil
              end
          end
          TriggerEvent('Polar:RefreshInventory', playerSrc)
          Polarclient.notify(source, {'~r~Seized weapons.'})
          Polarclient.notify(playerSrc, {'~r~Your weapons have been seized.'})
        end
      end)
    end
end)

seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('Polar:seizeIllegals')
AddEventHandler('Polar:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') then
      local player_id = Polar.getUserId(playerSrc)
      local cdata = Polar.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('Polar:RefreshInventory', playerSrc)
      Polarclient.notify(source, {'~r~Seized illegals.'})
      Polarclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("Polar:newPanic")
AddEventHandler("Polar:newPanic", function(a,b)
	local source = source
	local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'cop.whitelisted') or Polar.hasPermission(user_id, 'prisonguard.onduty.permission') or Polar.hasPermission(user_id, 'nhs.onduty.permission') or Polar.hasPermission(user_id, 'gang.whitelisted') then
        TriggerClientEvent("Polar:returnPanic", -1, nil, a, b)
        tPolar.sendWebhook(getPlayerFaction(user_id)..'-panic', 'Polar Panic Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("Polar:flashbangThrown")
AddEventHandler("Polar:flashbangThrown", function(coords)   
    TriggerClientEvent("Polar:flashbangExplode", -1, coords)
end)

RegisterNetEvent("Polar:updateSpotlight")
AddEventHandler("Polar:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("Polar:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'cop.whitelisted') then
    Polarclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        Polarclient.getPoliceCallsign(source, {}, function(callsign)
          Polarclient.getPoliceRank(source, {}, function(rank)
            Polarclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            Polarclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..GetPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('Polar:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  if Polar.hasPermission(user_id, 'cop.whitelisted') then
    Polarclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        Polarclient.getPoliceCallsign(source, {}, function(callsign)
          Polarclient.getPoliceRank(source, {}, function(rank)
            Polarclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            Polarclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('Polar:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
