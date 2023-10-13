local tacoDrivers = {}

RegisterNetEvent('RIFT:addTacoSeller')
AddEventHandler('RIFT:addTacoSeller', function(coords, price)
    local source = source
    local user_id = RIFT.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('RIFT:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('RIFT:RemoveMeFromTacoPositions')
AddEventHandler('RIFT:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('RIFT:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('RIFT:payTacoSeller')
AddEventHandler('RIFT:payTacoSeller', function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    if tacoDrivers[id] then
        if RIFT.getInventoryWeight(user_id)+1 <= RIFT.getInventoryMaxWeight(user_id) then
            if RIFT.tryFullPayment(user_id,15000) then
                RIFT.giveInventoryItem(user_id, 'Taco', 1)
                RIFT.giveBankMoney(id, 15000)
                TriggerClientEvent("rift:PlaySound", source, "money")
            else
                RIFTclient.notify(source, {'~r~You do not have enough money.'})
            end
        else
            RIFTclient.notify(source, {'~r~Not enough inventory space.'})
        end
    end
end)