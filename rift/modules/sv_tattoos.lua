RegisterServerEvent('RIFT:saveTattoos')
AddEventHandler('RIFT:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.tryFullPayment(user_id, price) then
        RIFT.setUData(user_id, "RIFT:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('RIFT:getPlayerTattoos')
AddEventHandler('RIFT:getPlayerTattoos', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.getUData(user_id, "RIFT:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('RIFT:setTattoos', source, json.decode(data))
        end
    end)
end)
