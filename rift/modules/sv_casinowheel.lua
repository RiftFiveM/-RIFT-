RegisterNetEvent("RIFT:requestSpinLuckyWheel")
AddEventHandler("RIFT:requestSpinLuckyWheel", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local chips = nil
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local chips = rows[1].chips
            if chips < 50000 then
                RIFTclient.notify(source,{"~r~You don't have enough chips."})
            else
                MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = 50000})
                TriggerClientEvent('RIFT:chipsUpdated', source)
                TriggerClientEvent('RIFT:spinLuckyWheel', source)
                TriggerClientEvent('RIFT:syncLuckyWheel', source, 1) -- the number correlates to the item on the wheel
            end
        end
    end)
end)

--casino wheel doesnt work so ur shit