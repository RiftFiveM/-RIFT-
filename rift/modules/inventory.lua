local lang = Polar.lang
local cfg = module("Polar-vehicles", "cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

Polar.items = {}

function Polar.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  Polar.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = Polar.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      Polar.prompt(player,lang.inventory.trash.prompt({Polar.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if Polar.tryGetInventoryItem(user_id,idname,amount,false) then
          Polarclient.notify(player,{lang.inventory.trash.done({Polar.getItemName(idname),amount})})
          Polarclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          Polarclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = Polar.getUserId(player)
  if user_id ~= nil then
    Polarclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
      usrList = ""
      for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
      end
      if usrList ~= "" then
        Polar.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, nplayer) --ask for id
          nplayer = nplayer
          if nplayer ~= nil and nplayer ~= "" then
            if nplayers[tonumber(nplayer)] then
              local nuser_id = Polar.getUserId(nplayer)
              if nuser_id ~= nil then
                Polar.prompt(player,lang.inventory.give.prompt({Polar.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
                  local amount = parseInt(amount)
                  -- weight check
                  local new_weight = Polar.getInventoryWeight(nuser_id)+Polar.getItemWeight(idname)*amount
                  if new_weight <= Polar.getInventoryMaxWeight(nuser_id) then
                    if Polar.tryGetInventoryItem(user_id,idname,amount,true) then
                      Polar.giveInventoryItem(nuser_id,idname,amount,true)
                      TriggerEvent('Polar:RefreshInventory', player)
                      TriggerEvent('Polar:RefreshInventory', nplayer)
                      Polarclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                      Polarclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
                    else
                      Polarclient.notify(player,{lang.common.invalid_value()})
                    end
                  else
                    Polarclient.notify(player,{lang.inventory.full()})
                  end
                end)
              else
                  Polarclient.notify(player,{'~r~Invalid Temp ID.'})
              end
            else
                Polarclient.notify(player,{'~r~Invalid Temp ID.'})
            end
          else
            Polarclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      else
        Polarclient.notify(player,{"~r~No players nearby!"}) --no players nearby
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = Polar.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    if Polar.getInventoryItemAmount(user_id,idname) > 1 then 
      Polar.prompt(player,lang.inventory.trash.prompt({Polar.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if Polar.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerEvent('Polar:RefreshInventory', player)
          Polarclient.notify(player,{lang.inventory.trash.done({Polar.getItemName(idname),amount})})
          Polarclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          Polarclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    else
      if Polar.tryGetInventoryItem(user_id,idname,1,false) then
        TriggerEvent('Polar:RefreshInventory', player)
        Polarclient.notify(player,{lang.inventory.trash.done({Polar.getItemName(idname),1})})
        Polarclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        Polarclient.notify(player,{lang.common.invalid_value()})
      end
    end
  end
end

function Polar.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function Polar.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function Polar.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function Polar.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function Polar.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function Polar.getItemDefinition(idname)
  local args = Polar.parseItem(idname)
  local item = Polar.items[args[1]]
  if item ~= nil then
    return Polar.computeItemName(item,args), Polar.computeItemDescription(item,args), Polar.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function Polar.getItemName(idname)
  local args = Polar.parseItem(idname)
  local item = Polar.items[args[1]]
  if item ~= nil then return Polar.computeItemName(item,args) end
  return args[1]
end

function Polar.getItemDescription(idname)
  local args = Polar.parseItem(idname)
  local item = Polar.items[args[1]]
  if item ~= nil then return Polar.computeItemDescription(item,args) end
  return ""
end

function Polar.getItemChoices(idname)
  local args = Polar.parseItem(idname)
  local item = Polar.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = Polar.computeItemChoices(item,args)
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

function Polar.getItemWeight(idname)
  local args = Polar.parseItem(idname)
  local item = Polar.items[args[1]]
  if item ~= nil then return Polar.computeItemWeight(item,args) end
  return 1
end

-- compute weight of a list of items (in inventory/chest format)
function Polar.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = Polar.getItemWeight(k)
    if iweight ~= nil then
      weight = weight+iweight*v.amount
    end
  end

  return weight
end

-- add item to a connected user inventory
function Polar.giveInventoryItem(user_id,idname,amount,notify)
  local player = Polar.getUserSource(user_id)
  if notify == nil then notify = true end -- notify by default

  local data = Polar.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = Polar.getUserSource(user_id)
      if player ~= nil then
        Polarclient.notify(player,{lang.inventory.give.received({Polar.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('Polar:RefreshInventory', player)
end


function Polar.RunTrashTask(source, itemName)
    local choices = Polar.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = Polar.getUserId(source)
        local data = Polar.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
    end
    TriggerEvent('Polar:RefreshInventory', source)
end


function Polar.RunGiveTask(source, itemName)
    local choices = Polar.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('Polar:RefreshInventory', source)
end

function Polar.RunInventoryTask(source, itemName)
    local choices = Polar.getItemChoices(itemName)
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
    TriggerEvent('Polar:RefreshInventory', source)
end

function Polar.LoadAllTask(source, itemName)
  local choices = Polar.getItemChoices(itemName)
  choices['LoadAll'][1](source)
  TriggerEvent('Polar:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function Polar.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = Polar.getUserSource(user_id)

  local data = Polar.getUserDataTable(user_id)
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
        local player = Polar.getUserSource(user_id)
        if player ~= nil then
          Polarclient.notify(player,{lang.inventory.give.given({Polar.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('Polar:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = Polar.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          Polarclient.notify(player,{lang.inventory.missing({Polar.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function Polar.getInventoryItemAmount(user_id,idname)
  local data = Polar.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function Polar.getInventoryWeight(user_id)
  local data = Polar.getUserDataTable(user_id)
  if data and data.inventory then
    return Polar.computeItemsWeight(data.inventory)
  end
  return 0
end

function Polar.getInventoryMaxWeight(user_id)
  local data = Polar.getUserDataTable(user_id)
  if data.invcap ~= nil then
    return data.invcap
  end
  return 30
end


-- clear connected user inventory
function Polar.clearInventory(user_id)
  local data = Polar.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end


AddEventHandler("Polar:playerJoin", function(user_id,source,name,last_login)
  local data = Polar.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


RegisterCommand("storebackpack", function(source, args)
  local source = source
  local user_id = Polar.getUserId(source)
  local data = Polar.getUserDataTable(user_id)
  tPolar.getSubscriptions(user_id, function(cb, plushours, plathours)
    if cb then
      local invcap = 30
      if plathours > 0 then
          invcap = invcap + 20
      elseif plushours > 0 then
          invcap = invcap + 10
      end
      if invcap == 30 then
        Polarclient.notify(source,{"~r~You do not have a backpack equipped."})
        return
      end
      if data.invcap - 15 == invcap then
        Polar.giveInventoryItem(user_id, "offwhitebag", 1, false)
      elseif data.invcap - 20 == invcap then
        Polar.giveInventoryItem(user_id, "guccibag", 1, false)
      elseif data.invcap - 30 == invcap  then
        Polar.giveInventoryItem(user_id, "nikebag", 1, false)
      elseif data.invcap - 35 == invcap  then
        Polar.giveInventoryItem(user_id, "huntingbackpack", 1, false)
      elseif data.invcap - 40 == invcap  then
        Polar.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
      elseif data.invcap - 70 == invcap  then
        Polar.giveInventoryItem(user_id, "rebelbackpack", 1, false)
      end
      Polar.updateInvCap(user_id, invcap)
      Polarclient.notify(source,{"~g~Backpack Stored"})
      TriggerClientEvent('Polar:removeBackpack', source)
    else
      if Polar.getInventoryWeight(user_id) + 5 > Polar.getInventoryMaxWeight(user_id) then
        Polarclient.notify(source,{"~r~You do not have enough room to store your backpack"})
      end
    end
  end)
end)