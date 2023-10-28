RegisterServerEvent('Polar:saveTattoos')
AddEventHandler('Polar:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.tryFullPayment(user_id, price) then
        Polar.setUData(user_id, "Polar:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('Polar:getPlayerTattoos')
AddEventHandler('Polar:getPlayerTattoos', function()
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.getUData(user_id, "Polar:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('Polar:setTattoos', source, json.decode(data))
        end
    end)
end)
