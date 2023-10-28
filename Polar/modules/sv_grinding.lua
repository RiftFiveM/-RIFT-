local grindingData = {
    ['Copper'] = {
        license = 'Copper', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'Copper Ore', 
        secondItem = 'Copper', 
        pickaxe = true
    },
    ['Limestone'] = {
        license = 'Limestone', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'Limestone Ore', 
        secondItem = 'Limestone', 
        pickaxe = true
    },
    ['Gold'] = {
        license = 'Gold', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'Gold Ore', 
        secondItem = 'Gold', 
        pickaxe = true
    },
    ['Weed'] = {
        license = 'Weed', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'Weed leaf', 
        secondItem = 'Weed'
    },
    ['Cocaine'] = {
        license = 'Cocaine', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'Coca leaf', 
        secondItem = 'Cocaine'
    },
    ['Meth'] = {
        license = 'Meth', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'Ephedra', 
        secondItem = 'Meth'
    },
    ['Diamond'] = {
        license = 'Diamond', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'Uncut Diamond', 
        secondItem = 'Processed Diamond', 
        pickaxe = true
    },
    ['Heroin'] = {
        license = 'Heroin', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'Opium Poppy', 
        secondItem = 'Heroin'
    },
    ['LSD'] = {
        license = 'LSD', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'Frogs legs', 
        secondItem = 'Lysergic Acid Amide', 
        thirdItem = 'LSD'
    },
}

RegisterNetEvent('Polar:requestGrinding')
AddEventHandler('Polar:requestGrinding', function(drug, grindingtype)
    local source = source
    local user_id = Polar.getUserId(source)
    local delay = 10000
    if GetPlayerRoutingBucket(source) ~= 0 then
        Polarclient.notify(source, {"~r~You cannot grind in this bucket."})
        return
    end
    for k,v in pairs(grindingData) do
        if k == drug then
            if Polar.hasGroup(user_id, v.license) then
                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                    if #rows > 0 then
                        if rows[1].plathours > 0 then
                           delay = 7500
                        end
                        if grindingtype == 'mining' then
                            if v.pickaxe then
                                TriggerClientEvent('Polar:playGrindingPickaxe', source)  
                            else
                                TriggerClientEvent('Polar:playGrindingScenario', source, v.miningScenario, false) 
                            end
                            Citizen.Wait(delay)
                            if Polar.getInventoryWeight(user_id)+(1*4) > Polar.getInventoryMaxWeight(user_id) then
                                Polarclient.notify(source,{"~r~Not enough space in inventory."})
                            else    
                                Polar.giveInventoryItem(user_id, v.firstItem, 4, true)
                            end
                        elseif grindingtype == 'processing' then
                            if Polar.getInventoryItemAmount(user_id, v.firstItem) >= 4 then
                                Polar.tryGetInventoryItem(user_id, v.firstItem, 4, true)
                                TriggerClientEvent('Polar:playGrindingScenario', source, v.processingScenario, false)
                                Citizen.Wait(delay)
                                if Polar.getInventoryWeight(user_id)+(4*1) > Polar.getInventoryMaxWeight(user_id) then
                                    Polarclient.notify(source,{"~r~Not enough space in inventory."})
                                else   
                                    if drug == 'LSD' then 
                                        Polar.giveInventoryItem(user_id, v.secondItem, 4, true)
                                    else
                                        Polar.giveInventoryItem(user_id, v.secondItem, 1, true)
                                    end
                                end
                            else
                                Polarclient.notify(source, {"~r~You do not have enough "..v.firstItem.."."})
                            end
                        elseif grindingtype == 'refinery' then
                            if Polar.getInventoryItemAmount(user_id, v.secondItem) >= 4 then
                                Polar.tryGetInventoryItem(user_id, v.secondItem, 4, true)
                                TriggerClientEvent('Polar:playGrindingScenario', source, 'WORLD_HUMAN_CLIPBOARD', false)
                                Citizen.Wait(delay)
                                if Polar.getInventoryWeight(user_id)+(4*1) > Polar.getInventoryMaxWeight(user_id) then
                                    Polarclient.notify(source,{"~r~Not enough space in inventory."})
                                else    
                                    Polar.giveInventoryItem(user_id, v.thirdItem, 1, true)
                                end
                            else
                                Polarclient.notify(source, {"~r~You do not have enough "..v.secondItem.."."})
                            end
                        end
                        TriggerEvent('Polar:RefreshInventory', source)
                    end
                end)
            end
        end
    end
end)