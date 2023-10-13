MySQL = module("modules/MySQL")

local Inventory = module("rift-vehicles", "cfg_inventory")
local Housing = module("rift", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("rift-weapons", "cfg/weapons")

AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local UserId = RIFT.getUserId(source) 
            local data = RIFT.getUserDataTable(UserId)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                end
                TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(UserId))
                InventorySpamTrack[source] = false;
            else 
                --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
            end
        end
    end
end)

RegisterNetEvent('RIFT:FetchPersonalInventory')
AddEventHandler('RIFT:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = RIFT.getUserId(source) 
        local data = RIFT.getUserDataTable(UserId)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
            end
            TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(UserId))
            InventorySpamTrack[source] = false;
        else 
            --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('RIFT:RefreshInventory', function(source)
    local UserId = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(UserId)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
        end
        TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(UserId))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('RIFT:GiveItem')
AddEventHandler('RIFT:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RIFT.RunGiveTask(source, itemId)
        TriggerEvent('RIFT:RefreshInventory', source)
    else
        RIFTclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('RIFT:TrashItem')
AddEventHandler('RIFT:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RIFT.RunTrashTask(source, itemId)
        TriggerEvent('RIFT:RefreshInventory', source)
    else
        RIFTclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('RIFT:FetchTrunkInventory')
AddEventHandler('RIFT:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = RIFT.getUserId(source)
    if InventoryCoolDown[source] then RIFTclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    RIFT.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('RIFT:RefreshInventory', source)
    end)
end)

local inHouse = {}
RegisterNetEvent('RIFT:FetchHouseInventory')
AddEventHandler('RIFT:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = RIFT.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            RIFT.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            RIFTclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('RIFT:cancelPlayerSearch')
AddEventHandler('RIFT:cancelPlayerSearch', function()
    local source = source
    local user_id = RIFT.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('RIFT:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('RIFT:searchPlayer')
AddEventHandler('RIFT:searchPlayer', function(playersrc)
    local source = source
    local user_id = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(user_id)
    local their_id = RIFT.getUserId(playersrc) 
    local their_data = RIFT.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('RIFT:startSearchingSuspect', source)
        TriggerClientEvent('RIFT:startBeingSearching', playersrc, source)
        RIFTclient.notify(playersrc, {'~b~You are being searched.'})
        Wait(10000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
            end
            exports['ghmattimysql']:execute("SELECT * FROM rift_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        if RIFT.getMoney(their_id) > 0 then
                            FormattedSecondaryInventoryData['cash'] = {amount = RIFT.getMoney(their_id), ItemName = 'Cash', Weight = 0.00}
                        end
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, RIFT.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('RIFT:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)


-- rob player where it gives you their inventory
RegisterNetEvent('RIFT:robPlayer')
AddEventHandler('RIFT:robPlayer', function(playersrc)
    local source = source
    RIFTclient.globalSurrenderring(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = RIFT.getUserId(source) 
                local data = RIFT.getUserDataTable(user_id)
                local their_id = RIFT.getUserId(playersrc) 
                local their_data = RIFT.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                    end
                    exports['ghmattimysql']:execute("SELECT * FROM rift_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    RIFT.giveInventoryItem(user_id, i, v.amount)
                                    RIFT.tryGetInventoryItem(their_id, i, v.amount)
                                end
                            end
                            if RIFT.getMoney(their_id) > 0 then
                                RIFT.giveMoney(user_id, RIFT.getMoney(their_id))
                                RIFT.tryPayment(their_id, RIFT.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('RIFT:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                else 
                    --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
                end
            end
        end
    end)
end)

RegisterNetEvent('RIFT:UseItem')
AddEventHandler('RIFT:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(user_id)
    if not itemId then RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc ~= "Plr" then
        RIFTclient.notify(source, {'~r~You need to have this item on you to use it.'})
        return
    end
    tRIFT.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            local invcap = 30
            if plathours > 0 then
                invcap = 50
            elseif plushours > 0 then
                invcap = 40
            end
            if RIFT.getInventoryMaxWeight(user_id) ~= nil then
                if RIFT.getInventoryMaxWeight(user_id) > invcap then
                    return
                end
            end
            if itemId == "offwhitebag" then
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+15)
                TriggerClientEvent('RIFT:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
            elseif itemId == "guccibag" then 
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+20)
                TriggerClientEvent('RIFT:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
            elseif itemId == "nikebag" then 
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+30)
            elseif itemId == "huntingbackpack" then 
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+35)
                TriggerClientEvent('RIFT:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
            elseif itemId == "greenhikingbackpack" then 
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+40)
            elseif itemId == "rebelbackpack" then 
                RIFT.tryGetInventoryItem(user_id, itemId, 1, true)
                RIFT.updateInvCap(user_id, invcap+70)
                TriggerClientEvent('RIFT:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
            elseif itemId == "Shaver" then 
                RIFT.ShaveHead(source)
            elseif itemId == "handcuffkeys" then 
                RIFT.handcuffKeys(source)
            end
        end
    end) 
    RIFT.RunInventoryTask(source, itemId)
    TriggerEvent('RIFT:RefreshInventory', source)
end)

local alreadyEquiping = {}
RegisterNetEvent('RIFT:EquipAll')
AddEventHandler('RIFT:EquipAll', function()
    local source = source
    local user_id = RIFT.getUserId(source) 
    if alreadyEquiping[user_id] then
        RIFTclient.notify(source, {'~r~You are already equiping all items'})
        return
    end
    alreadyEquiping[user_id] = true
    local data = RIFT.getUserDataTable(user_id)
    local sortedTable = {}
    for item,v in pairs(data.inventory) do
        if string.find(item, 'wbody|') or seizeBullets[item] then
            table.insert(sortedTable, item)
        end
    end
    table.sort(sortedTable, function(a,b) 
        if string.find(a, 'wbody|') and string.find(b, 'wbody|') then
            return a < b
        elseif string.find(a, 'wbody|') then
            return true
        elseif string.find(b, 'wbody|') then
            return false
        else
            return a < b
        end
    end)
    for _, item in ipairs(sortedTable) do
        if string.find(item:lower(), 'wbody|') then
            RIFT.RunInventoryTask(source, item)
        elseif seizeBullets[item] then
            RIFT.LoadAllTask(source, item)
        end
        Wait(500)
    end
    TriggerEvent('RIFT:RefreshInventory', source)
    alreadyEquiping[user_id] = false
end)

local alreadyLootingAll = {}
RegisterNetEvent('RIFT:LootItemAll')
AddEventHandler('RIFT:LootItemAll', function(inventoryInfo)
    local source = source
    local user_id = RIFT.getUserId(source) 
    if alreadyLootingAll[user_id] then
        RIFTclient.notify(source, {'~r~You are already looting all items'})
        return
    end
    alreadyLootingAll[user_id] = true
    local data = RIFT.getUserDataTable(user_id)
    local totalBagWeight = 0
    for itemId, _ in pairs(LootBagEntities[inventoryInfo].Items) do
        local weightCalculation = RIFT.getInventoryWeight(user_id)+RIFT.getItemWeight(itemId)
        if weightCalculation ~= nil then 
            totalBagWeight = totalBagWeight + weightCalculation
        end
    end
    if totalBagWeight > RIFT.getInventoryMaxWeight(user_id) then
        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
        return
    end
    for itemId, _ in pairs(LootBagEntities[inventoryInfo].Items) do
        RIFT.giveInventoryItem(user_id, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
        LootBagEntities[inventoryInfo].Items[itemId] = nil;

        local FormattedInventoryData = {}
        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
        end
        local maxVehKg = 200
        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)    

        Wait(500)
    end
    CloseInv(source)
    TriggerEvent('RIFT:RefreshInventory', source)
    alreadyLootingAll[user_id] = false
end)

RegisterNetEvent('RIFT:UseAllItem')
AddEventHandler('RIFT:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = RIFT.getUserId(source) 
    if not itemId then RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        RIFT.LoadAllTask(source, itemId)
        TriggerEvent('RIFT:RefreshInventory', source)
    else
        RIFTclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('RIFT:MoveItem')
AddEventHandler('RIFT:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(UserId)
    if InventoryCoolDown[source] then RIFTclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
            RIFT.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+RIFT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RIFT:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        RIFT.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+RIFT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('RIFT:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
            RIFT.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+RIFT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            RIFT.giveInventoryItem(UserId, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RIFT:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                        RIFT.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = RIFT.computeItemsWeight(cdata)+RIFT.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if RIFT.tryGetInventoryItem(UserId, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RIFT:RefreshInventory', source)
                                    RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        RIFT.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = RIFT.computeItemsWeight(cdata)+RIFT.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if RIFT.tryGetInventoryItem(UserId, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RIFT:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    RIFT.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('RIFT:MoveItemX')
AddEventHandler('RIFT:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local UserId = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(UserId)
    if InventoryCoolDown[source] then RIFTclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                RIFT.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = RIFT.getInventoryWeight(UserId)+(RIFT.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('RIFT:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            RIFT.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                RIFTclient.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                Quantity = parseInt(Quantity)
                if Quantity then
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+(RIFT.getItemWeight(itemId) * Quantity)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('RIFT:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    RIFTclient.notify(source, {'~r~Invalid input!'})
                end
            end
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                RIFT.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = RIFT.getInventoryWeight(UserId)+(RIFT.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                RIFT.giveInventoryItem(UserId, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('RIFT:RefreshInventory', source)
                            RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                        else 
                            RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                RIFTclient.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                            RIFT.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = RIFT.computeItemsWeight(cdata)+(RIFT.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if RIFT.tryGetInventoryItem(UserId, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('RIFT:RefreshInventory', source)
                                        RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                    else 
                                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            RIFTclient.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                            RIFT.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = RIFT.computeItemsWeight(cdata)+(RIFT.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if RIFT.tryGetInventoryItem(UserId, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('RIFT:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        RIFT.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            RIFTclient.notify(source, {'~r~Invalid input!'})
                        end
                    end
                else
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('RIFT:MoveItemAll')
AddEventHandler('RIFT:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = RIFT.getUserId(source) 
    local data = RIFT.getUserDataTable(UserId)
    if not itemId then RIFTclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then RIFTclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = RIFT.getUserId(NetworkGetEntityOwner(idz))
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            RIFT.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = RIFT.getInventoryWeight(user_id)+(RIFT.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    local amount = cdata[itemId].amount
                    if weightCalculation > RIFT.getInventoryMaxWeight(user_id) and RIFT.getInventoryWeight(user_id) ~= RIFT.getInventoryMaxWeight(user_id) then
                        amount = math.floor((RIFT.getInventoryMaxWeight(user_id)-RIFT.getInventoryWeight(user_id)) / RIFT.getItemWeight(itemId))
                    end
                    if math.floor(amount) > 0 or (weightCalculation <= RIFT.getInventoryMaxWeight(user_id)) then
                        RIFT.giveInventoryItem(user_id, itemId, amount, true)
                        local FormattedInventoryData = {}
                        if (cdata[itemId].amount - amount) > 0 then
                            cdata[itemId].amount = cdata[itemId].amount - amount
                        else
                            cdata[itemId] = nil
                        end
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RIFT:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        RIFT.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = nil;
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "LootBag" then
            if itemId ~= nil then    
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+(RIFT.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            RIFT.giveInventoryItem(UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('RIFT:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
            RIFT.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = RIFT.getInventoryWeight(UserId)+(RIFT.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= RIFT.getInventoryMaxWeight(UserId) then
                        RIFT.giveInventoryItem(UserId, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('RIFT:RefreshInventory', source)
                        RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                        RIFT.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = RIFT.computeItemsWeight(cdata)+(RIFT.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if RIFT.tryGetInventoryItem(UserId, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RIFT:RefreshInventory', source)
                                    RIFT.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        RIFT.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = RIFT.computeItemsWeight(cdata)+(RIFT.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if RIFT.tryGetInventoryItem(UserId, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('RIFT:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    RIFT.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    RIFTclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                RIFTclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('RIFT:InComa')
AddEventHandler('RIFT:InComa', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFTclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = RIFT.getInventoryWeight(user_id)
            if weight == 0 then return end
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
            local ndata = RIFT.getUserDataTable(user_id)
            local stored_inventory = nil;
            TriggerEvent('RIFT:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    RIFT.clearInventory(user_id)
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('RIFT:LootBag')
AddEventHandler('RIFT:LootBag', function(netid)
    local source = source
    RIFTclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = RIFT.getUserId(source)
                if user_id ~= nil then
                    TriggerClientEvent("rift:PlaySound", source, "zipper")
                    LootBagEntities[netid][5] = source
                    if RIFT.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    RIFTclient.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                RIFTclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        RIFTclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if #LootBagEntities[netid].Items > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                RIFTclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            RIFTclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('RIFT:CloseLootbag')
AddEventHandler('RIFT:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('RIFT:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = RIFT.getUserId(source)
    local data = RIFT.getUserDataTable(UserId)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
        end
        TriggerClientEvent('RIFT:FetchPersonalInventory', source, FormattedInventoryData, RIFT.computeItemsWeight(data.inventory), RIFT.getInventoryMaxWeight(UserId))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('RIFT:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = RIFT.getItemName(i), Weight = RIFT.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('RIFT:SendSecondaryInventoryData', source, FormattedInventoryData, RIFT.computeItemsWeight(LootBagItems), maxVehKg)
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    LootBagEntities[i] = nil;
                end
            end
        end
    end
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

-- local usersLockpicking = {}

-- RegisterNetEvent('RIFT:attemptLockpick')
-- AddEventHandler('RIFT:attemptLockpick', function(veh, netveh)
--     local source = source
--     local user_id = RIFT.getUserId(source)
--     if RIFT.tryGetInventoryItem(user_id, 'Lockpick', 1, true) then
--         local chance = math.random(1,8)
--         if chance == 1 then
--             TriggerClientEvent('RIFT:lockpickClient', source, veh, true)
--         else
--             TriggerClientEvent('RIFT:lockpickClient', source, veh, false)
--         end
--     end
-- end)

-- RegisterNetEvent('RIFT:lockpickVehicle')
-- AddEventHandler('RIFT:lockpickVehicle', function(spawncode, ownerid)
--     local source = source
--     local user_id = RIFT.getUserId(source)
    
-- end)

-- RegisterNetEvent('RIFT:setVehicleLock')
-- AddEventHandler('RIFT:setVehicleLock', function(netid)
--     local source = source
--     local user_id = RIFT.getUserId(source)
--     if usersLockpicking[user_id] then
--         SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
--     end
-- end)