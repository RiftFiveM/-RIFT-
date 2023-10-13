local lang = RIFT.lang
local cfg = module("rift-vehicles", "cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

RIFT.items = {}

function RIFT.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  RIFT.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = RIFT.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      RIFT.prompt(player,lang.inventory.trash.prompt({RIFT.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if RIFT.tryGetInventoryItem(user_id,idname,amount,false) then
          RIFTclient.notify(player,{lang.inventory.trash.done({RIFT.getItemName(idname),amount})})
          RIFTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          RIFTclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    RIFTclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
      usrList = ""
      for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
      end
      if usrList ~= "" then
        RIFT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, nplayer) --ask for id
          nplayer = nplayer
          if nplayer ~= nil and nplayer ~= "" then
            if nplayers[tonumber(nplayer)] then
              local nuser_id = RIFT.getUserId(nplayer)
              if nuser_id ~= nil then
                RIFT.prompt(player,lang.inventory.give.prompt({RIFT.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
                  local amount = parseInt(amount)
                  -- weight check
                  local new_weight = RIFT.getInventoryWeight(nuser_id)+RIFT.getItemWeight(idname)*amount
                  if new_weight <= RIFT.getInventoryMaxWeight(nuser_id) then
                    if RIFT.tryGetInventoryItem(user_id,idname,amount,true) then
                      RIFT.giveInventoryItem(nuser_id,idname,amount,true)
                      TriggerEvent('RIFT:RefreshInventory', player)
                      TriggerEvent('RIFT:RefreshInventory', nplayer)
                      RIFTclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                      RIFTclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
                    else
                      RIFTclient.notify(player,{lang.common.invalid_value()})
                    end
                  else
                    RIFTclient.notify(player,{lang.inventory.full()})
                  end
                end)
              else
                  RIFTclient.notify(player,{'~r~Invalid Temp ID.'})
              end
            else
                RIFTclient.notify(player,{'~r~Invalid Temp ID.'})
            end
          else
            RIFTclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      else
        RIFTclient.notify(player,{"~r~No players nearby!"}) --no players nearby
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = RIFT.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    if RIFT.getInventoryItemAmount(user_id,idname) > 1 then 
      RIFT.prompt(player,lang.inventory.trash.prompt({RIFT.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if RIFT.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerEvent('RIFT:RefreshInventory', player)
          RIFTclient.notify(player,{lang.inventory.trash.done({RIFT.getItemName(idname),amount})})
          RIFTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          RIFTclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    else
      if RIFT.tryGetInventoryItem(user_id,idname,1,false) then
        TriggerEvent('RIFT:RefreshInventory', player)
        RIFTclient.notify(player,{lang.inventory.trash.done({RIFT.getItemName(idname),1})})
        RIFTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        RIFTclient.notify(player,{lang.common.invalid_value()})
      end
    end
  end
end

function RIFT.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function RIFT.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function RIFT.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function RIFT.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function RIFT.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function RIFT.getItemDefinition(idname)
  local args = RIFT.parseItem(idname)
  local item = RIFT.items[args[1]]
  if item ~= nil then
    return RIFT.computeItemName(item,args), RIFT.computeItemDescription(item,args), RIFT.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function RIFT.getItemName(idname)
  local args = RIFT.parseItem(idname)
  local item = RIFT.items[args[1]]
  if item ~= nil then return RIFT.computeItemName(item,args) end
  return args[1]
end

function RIFT.getItemDescription(idname)
  local args = RIFT.parseItem(idname)
  local item = RIFT.items[args[1]]
  if item ~= nil then return RIFT.computeItemDescription(item,args) end
  return ""
end

function RIFT.getItemChoices(idname)
  local args = RIFT.parseItem(idname)
  local item = RIFT.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = RIFT.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function RIFT.getItemWeight(idname)
  local args = RIFT.parseItem(idname)
  local item = RIFT.items[args[1]]
  if item ~= nil then return RIFT.computeItemWeight(item,args) end
  return 1
end

-- compute weight of a list of items (in inventory/chest format)
function RIFT.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = RIFT.getItemWeight(k)
    if iweight ~= nil then
      weight = weight+iweight*v.amount
    end
  end

  return weight
end

-- add item to a connected user inventory
function RIFT.giveInventoryItem(user_id,idname,amount,notify)
  local player = RIFT.getUserSource(user_id)
  if notify == nil then notify = true end -- notify by default

  local data = RIFT.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = RIFT.getUserSource(user_id)
      if player ~= nil then
        RIFTclient.notify(player,{lang.inventory.give.received({RIFT.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('RIFT:RefreshInventory', player)
end


function RIFT.RunTrashTask(source, itemName)
    local choices = RIFT.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = RIFT.getUserId(source)
        local data = RIFT.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
    end
    TriggerEvent('RIFT:RefreshInventory', source)
end


function RIFT.RunGiveTask(source, itemName)
    local choices = RIFT.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('RIFT:RefreshInventory', source)
end

function RIFT.RunInventoryTask(source, itemName)
    local choices = RIFT.getItemChoices(itemName)
    if choices['Use'] then 
        choices['Use'][1](source)
    elseif choices['Drink'] then
        choices['Drink'][1](source)
    elseif choices['Load'] then
        choices['Load'][1](source)
    elseif choices['Eat'] then
        choices['Eat'][1](source)
    elseif choices['Equip'] then 
        choices['Equip'][1](source)
    elseif choices['Take'] then 
        choices['Take'][1](source)
    end
    TriggerEvent('RIFT:RefreshInventory', source)
end

function RIFT.LoadAllTask(source, itemName)
  local choices = RIFT.getItemChoices(itemName)
  choices['LoadAll'][1](source)
  TriggerEvent('RIFT:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function RIFT.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = RIFT.getUserSource(user_id)

  local data = RIFT.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = RIFT.getUserSource(user_id)
        if player ~= nil then
          RIFTclient.notify(player,{lang.inventory.give.given({RIFT.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('RIFT:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = RIFT.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          RIFTclient.notify(player,{lang.inventory.missing({RIFT.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function RIFT.getInventoryItemAmount(user_id,idname)
  local data = RIFT.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function RIFT.getInventoryWeight(user_id)
  local data = RIFT.getUserDataTable(user_id)
  if data and data.inventory then
    return RIFT.computeItemsWeight(data.inventory)
  end
  return 0
end

function RIFT.getInventoryMaxWeight(user_id)
  local data = RIFT.getUserDataTable(user_id)
  if data.invcap ~= nil then
    return data.invcap
  end
  return 30
end


-- clear connected user inventory
function RIFT.clearInventory(user_id)
  local data = RIFT.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end


AddEventHandler("RIFT:playerJoin", function(user_id,source,name,last_login)
  local data = RIFT.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


RegisterCommand("storebackpack", function(source, args)
  local source = source
  local user_id = RIFT.getUserId(source)
  local data = RIFT.getUserDataTable(user_id)
  tRIFT.getSubscriptions(user_id, function(cb, plushours, plathours)
    if cb then
      local invcap = 30
      if plathours > 0 then
          invcap = invcap + 20
      elseif plushours > 0 then
          invcap = invcap + 10
      end
      if invcap == 30 then
        RIFTclient.notify(source,{"~r~You do not have a backpack equipped."})
        return
      end
      if data.invcap - 15 == invcap then
        RIFT.giveInventoryItem(user_id, "offwhitebag", 1, false)
      elseif data.invcap - 20 == invcap then
        RIFT.giveInventoryItem(user_id, "guccibag", 1, false)
      elseif data.invcap - 30 == invcap  then
        RIFT.giveInventoryItem(user_id, "nikebag", 1, false)
      elseif data.invcap - 35 == invcap  then
        RIFT.giveInventoryItem(user_id, "huntingbackpack", 1, false)
      elseif data.invcap - 40 == invcap  then
        RIFT.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
      elseif data.invcap - 70 == invcap  then
        RIFT.giveInventoryItem(user_id, "rebelbackpack", 1, false)
      end
      RIFT.updateInvCap(user_id, invcap)
      RIFTclient.notify(source,{"~g~Backpack Stored"})
      TriggerClientEvent('RIFT:removeBackpack', source)
    else
      if RIFT.getInventoryWeight(user_id) + 5 > RIFT.getInventoryMaxWeight(user_id) then
        RIFTclient.notify(source,{"~r~You do not have enough room to store your backpack"})
      end
    end
  end)
end)