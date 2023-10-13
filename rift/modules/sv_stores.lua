local cfg = module("cfg/cfg_stores")


RegisterNetEvent("RIFT:BuyStoreItem")
AddEventHandler("RIFT:BuyStoreItem", function(item, amount)
    local user_id = RIFT.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if RIFT.getInventoryWeight(user_id) <= 25 then
                if RIFT.tryPayment(user_id,v.price*amount) then
                    RIFT.giveInventoryItem(user_id, item, amount, false)
                    RIFTclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("rift:PlaySound", source, 1)
                else
                    RIFTclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("rift:PlaySound", source, 2)
                end
            else
                RIFTclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("rift:PlaySound", source, 2)
            end
        end
    end
end)