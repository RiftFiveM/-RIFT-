local tacoDrivers = {}

RegisterNetEvent('Polar:addTacoSeller')
AddEventHandler('Polar:addTacoSeller', function(coords, price)
    local source = source
    local user_id = Polar.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('Polar:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('Polar:RemoveMeFromTacoPositions')
AddEventHandler('Polar:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = Polar.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('Polar:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('Polar:payTacoSeller')
AddEventHandler('Polar:payTacoSeller', function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    if tacoDrivers[id] then
        if Polar.getInventoryWeight(user_id)+1 <= Polar.getInventoryMaxWeight(user_id) then
            if Polar.tryFullPayment(user_id,15000) then
                Polar.giveInventoryItem(user_id, 'Taco', 1)
                Polar.giveBankMoney(id, 15000)
                TriggerClientEvent("Polar:PlaySound", source, "money")
            else
                Polarclient.notify(source, {'~r~You do not have enough money.'})
            end
        else
            Polarclient.notify(source, {'~r~Not enough inventory space.'})
        end
    end
end)