
local items = {}

local cocaine_sniff = {}
cocaine_sniff["Take"] = {function(player,choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    if RIFT.tryGetInventoryItem(user_id,"Cocaine",1) then
      RIFTclient.notify(player,{"~g~Taking Cocaine."})
      TriggerEvent('RIFT:RefreshInventory', player)
      TriggerClientEvent('RIFT:cocaineEffect', player)
    end
  end
end}

local heroin_take = {}
heroin_take["Take"] = {function(player,choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    if RIFT.tryGetInventoryItem(user_id,"Heroin",1) then
      RIFTclient.notify(player,{"~g~Taking Heroin."})
      TriggerEvent('RIFT:RefreshInventory', player)
      TriggerClientEvent('RIFT:heroinEffect', player)
    end
  end
end}


local lsd_take = {}
lsd_take["Take"] = {function(player,choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    if RIFT.tryGetInventoryItem(user_id,"LSD",1) then
      RIFTclient.notify(player,{"~g~Taking LSD."})
      TriggerEvent('RIFT:RefreshInventory', player)
      TriggerClientEvent('RIFT:doAcid', player)
    end
  end
end}

local morphine_choices = {}
morphine_choices["Take"] = {function(player,choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    if RIFT.tryGetInventoryItem(user_id,"Morphine",1) then
      TriggerEvent('RIFT:RefreshInventory', player)
      TriggerClientEvent('RIFT:applyMorphine', player)
    end
  end
end}

local taco_choices = {}
taco_choices["Take"] = {function(player,choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    if RIFT.tryGetInventoryItem(user_id,"Taco",1) then
      TriggerEvent('RIFT:RefreshInventory', player)
      TriggerClientEvent('RIFT:eatTaco', player)
    end
  end
end}

-- Drugs
items["Cocaine"] = {"Cocaine","Some Cocaine.",function(args) return cocaine_sniff end,4}
items["Heroin"] = {"Heroin","Some Heroin.",function(args) return heroin_take end,4}
items["LSD"] = {"LSD","Some LSD.",function(args) return lsd_take end,4}

-- Edibles
items["Morphine"] = {"Morphine","Some Morphine.",function(args) return morphine_choices end,1}
items["Taco"] = {"Taco","A Taco.",function(args) return taco_choices end,1}

return items
