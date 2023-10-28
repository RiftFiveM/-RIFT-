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
RegisterNetEvent('Polar:requestStartCooking')
AddEventHandler('Polar:requestStartCooking', function(recipe)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('Polar:beginCooking', source, recipe)
                TriggerClientEvent('Polar:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        Polarclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('Polar:pickupCookingIngredient')
AddEventHandler('Polar:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('Polar:finishedCooking', source)
            Polar.giveBankMoney(user_id, grindBoost*4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('Polar:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        Polarclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)