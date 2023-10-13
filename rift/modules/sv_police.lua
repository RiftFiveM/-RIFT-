
-- this module define some police tools and functions
local lang = RIFT.lang
local a = module("rift-weapons", "cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = RIFT.getUserId(player)
    local data = RIFT.getUserDataTable(user_id)
    RIFTclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
        tRIFT.getSubscriptions(user_id, function(cb, plushours, plathours)
          if cb then
            local maxWeight = 30
            if plathours > 0 then
              maxWeight = 50
            elseif plushours > 0 then
              maxWeight = 40
            end
            if RIFT.getInventoryWeight(user_id) <= maxWeight then
              isStoring[player] = true
              RIFTclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                  if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                    RIFT.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                      for i,c in pairs(a.weapons) do
                        if i == k and c.class ~= 'Melee' then
                          if v.ammo > 250 then
                            v.ammo = 250
                          end
                          RIFT.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                        end   
                      end
                    end
                  end
                end
                RIFTclient.notify(player,{"~g~Weapons Stored"})
                TriggerEvent('RIFT:RefreshInventory', player)
                RIFTclient.ClearWeapons(player,{})
                data.weapons = {}
                SetTimeout(3000,function()
                    isStoring[player] = nil 
                end)
              end)
            else
              RIFTclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
          end
        end)
      end 
    end)
end

RegisterServerEvent("RIFT:forceStoreSingleWeapon")
AddEventHandler("RIFT:forceStoreSingleWeapon",function(model)
    local source = source
    local user_id = RIFT.getUserId(source)
    if model ~= nil then
      RIFTclient.getWeapons(source,{},function(weapons)
        for k,v in pairs(weapons) do
          if k == model then
            local new_weight = RIFT.getInventoryWeight(user_id)+RIFT.getItemWeight(model)
            if new_weight <= RIFT.getInventoryMaxWeight(user_id) then
              RemoveWeaponFromPed(GetPlayerPed(source), k)
              RIFTclient.removeWeapon(source,{k})
              RIFT.giveInventoryItem(user_id, "wbody|"..k, 1, true)
              if v.ammo > 0 then
                for i,c in pairs(a.weapons) do
                  if i == model and c.class ~= 'Melee' then
                    RIFT.giveInventoryItem(user_id, c.ammo, v.ammo, true)
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
      RIFTclient.notify(source, {'~r~You must wait 3 seconds before using this command again.'})
    end
end)


RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'cop.whitelisted') then
    TriggerClientEvent('RIFT:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  RIFTclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      RIFTclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and RIFT.hasPermission(user_id, 'admin.tickets')) or RIFT.hasPermission(user_id, 'cop.whitelisted') then
          RIFTclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = RIFT.getUserId(nplayer)
              if (not RIFT.hasPermission(nplayer_id, 'cop.whitelisted') or RIFT.hasPermission(nplayer_id, 'police.undercover')) then
                RIFTclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('RIFT:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('RIFT:unHandcuff', source, false)
                  else
                    TriggerClientEvent('RIFT:arrestCriminal', nplayer, source)
                    TriggerClientEvent('RIFT:arrestFromPolice', source)
                  end
                  TriggerClientEvent('RIFT:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('RIFT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              RIFTclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  RIFTclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      RIFTclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and RIFT.hasPermission(user_id, 'admin.tickets')) or RIFT.hasPermission(user_id, 'cop.whitelisted') then
          RIFTclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = RIFT.getUserId(nplayer)
              if (not RIFT.hasPermission(nplayer_id, 'cop.whitelisted') or RIFT.hasPermission(nplayer_id, 'police.undercover')) then
                RIFTclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('RIFT:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('RIFT:unHandcuff', source, true)
                  else
                    TriggerClientEvent('RIFT:arrestCriminal', nplayer, source)
                    TriggerClientEvent('RIFT:arrestFromPolice', source)
                  end
                  TriggerClientEvent('RIFT:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('RIFT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              RIFTclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function RIFT.handcuffKeys(source)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    RIFTclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = RIFT.getUserId(nplayer)
        RIFTclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            RIFT.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('RIFT:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('RIFT:unHandcuff', source, false)
            TriggerClientEvent('RIFT:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('RIFT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        RIFTclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("RIFT:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            RIFTclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('RIFT:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('RIFT:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('RIFT:dragPlayer')
AddEventHandler('RIFT:dragPlayer', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and (RIFT.hasPermission(user_id, "cop.whitelisted") or RIFT.hasPermission(user_id, "prisonguard.onduty.permission")) then
      if playersrc ~= nil then
        local nuser_id = RIFT.getUserId(playersrc)
          if nuser_id ~= nil then
            RIFTclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("RIFT:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("RIFT:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    RIFTclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              RIFTclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          RIFTclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('RIFT:putInVehicle')
AddEventHandler('RIFT:putInVehicle', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cop.whitelisted") then
      if playersrc ~= nil then
        RIFTclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            RIFTclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            RIFTclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('RIFT:ejectFromVehicle')
AddEventHandler('RIFT:ejectFromVehicle', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cop.whitelisted") then
      RIFTclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = RIFT.getUserId(nplayer)
        if nuser_id ~= nil then
          RIFTclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              RIFTclient.ejectVehicle(nplayer, {})
            else
              RIFTclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          RIFTclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("RIFT:Knockout")
AddEventHandler('RIFT:Knockout', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFTclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = RIFT.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('RIFT:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('RIFT:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("RIFT:KnockoutNoAnim")
AddEventHandler('RIFT:KnockoutNoAnim', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Founder') or RIFT.hasGroup(user_id, 'Lead Developer') then
      RIFTclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = RIFT.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('RIFT:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('RIFT:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("RIFT:requestPlaceBagOnHead")
AddEventHandler('RIFT:requestPlaceBagOnHead', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      RIFTclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = RIFT.getUserId(nplayer)
          if nuser_id ~= nil then
              RIFT.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('RIFT:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('RIFT:gunshotTest')
AddEventHandler('RIFT:gunshotTest', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cop.whitelisted") then
      if playersrc ~= nil then
        RIFTclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            RIFTclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            RIFTclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('RIFT:tryTackle')
AddEventHandler('RIFT:tryTackle', function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') or RIFT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('RIFT:playTackle', source)
        TriggerClientEvent('RIFT:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasGroup(user_id, 'Drone Trained') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'cop.whitelisted') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('RIFT:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('RIFT:startThrowSmokeGrenade')
AddEventHandler('RIFT:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('RIFT:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('RIFT:breathalyserCommand', source)
  end
end)

RegisterServerEvent('RIFT:breathalyserRequest')
AddEventHandler('RIFT:breathalyserRequest', function(temp)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') then
      TriggerClientEvent('RIFT:beingBreathalysed', temp)
      TriggerClientEvent('RIFT:breathTestResult', source, math.random(0, 100), GetPlayerName(temp))
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

RegisterServerEvent('RIFT:seizeWeapons')
AddEventHandler('RIFT:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') then
      RIFTclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = RIFT.getUserId(playerSrc)
          local cdata = RIFT.getUserDataTable(player_id)
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
          TriggerEvent('RIFT:RefreshInventory', playerSrc)
          RIFTclient.notify(source, {'~r~Seized weapons.'})
          RIFTclient.notify(playerSrc, {'~r~Your weapons have been seized.'})
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
RegisterServerEvent('RIFT:seizeIllegals')
AddEventHandler('RIFT:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') then
      local player_id = RIFT.getUserId(playerSrc)
      local cdata = RIFT.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('RIFT:RefreshInventory', playerSrc)
      RIFTclient.notify(source, {'~r~Seized illegals.'})
      RIFTclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("RIFT:newPanic")
AddEventHandler("RIFT:newPanic", function(a,b)
	local source = source
	local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'cop.whitelisted') or RIFT.hasPermission(user_id, 'prisonguard.onduty.permission') or RIFT.hasPermission(user_id, 'nhs.onduty.permission') or RIFT.hasPermission(user_id, 'gang.whitelisted') then
        TriggerClientEvent("RIFT:returnPanic", -1, nil, a, b)
        tRIFT.sendWebhook(getPlayerFaction(user_id)..'-panic', 'RIFT Panic Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("RIFT:flashbangThrown")
AddEventHandler("RIFT:flashbangThrown", function(coords)   
    TriggerClientEvent("RIFT:flashbangExplode", -1, coords)
end)

RegisterNetEvent("RIFT:updateSpotlight")
AddEventHandler("RIFT:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("RIFT:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'cop.whitelisted') then
    RIFTclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        RIFTclient.getPoliceCallsign(source, {}, function(callsign)
          RIFTclient.getPoliceRank(source, {}, function(rank)
            RIFTclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            RIFTclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..GetPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('RIFT:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  if RIFT.hasPermission(user_id, 'cop.whitelisted') then
    RIFTclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        RIFTclient.getPoliceCallsign(source, {}, function(callsign)
          RIFTclient.getPoliceRank(source, {}, function(rank)
            RIFTclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            RIFTclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('RIFT:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
