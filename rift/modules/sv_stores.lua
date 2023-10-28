local cfg = module("cfg/cfg_stores")


RegisterNetEvent("Polar:BuyStoreItem")
AddEventHandler("Polar:BuyStoreItem", function(item, amount)
    local user_id = Polar.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if Polar.getInventoryWeight(user_id) <= 25 then
                if Polar.tryPayment(user_id,v.price*amount) then
                    Polar.giveInventoryItem(user_id, item, amount, false)
                    Polarclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("Polar:PlaySound", source, 1)
                else
                    Polarclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("Polar:PlaySound", source, 2)
                end
            else
                Polarclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("Polar:PlaySound", source, 2)
            end
        end
    end
end)