local a = {
    ["burger"] = {
        [1] = 'bun',
        [2] = 'lettuce',
        [3] = 'tomato',
        [4] = 'onion',
        [5] = 'cheese',
        [6] = 'beef_patty',
        [7] = 'bbq',
    }
}

local cookingStages = {}
RegisterNetEvent('RIFT:requestStartCooking')
AddEventHandler('RIFT:requestStartCooking', function(recipe)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('RIFT:beginCooking', source, recipe)
                TriggerClientEvent('RIFT:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        RIFTclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('RIFT:pickupCookingIngredient')
AddEventHandler('RIFT:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('RIFT:finishedCooking', source)
            RIFT.giveBankMoney(user_id, grindBoost*4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('RIFT:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        RIFTclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)