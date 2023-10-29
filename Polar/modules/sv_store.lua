function getStoreRankName(source)
    local user_id = Polar.getUserId(source)
    local ranks = {
        [1] = 'Baller',
        [2] = 'Rainmaker',
        [3] = 'Kingpin',
        [4] = 'Supreme',
        [5] = 'Premium',
        [6] = 'Supporter',
    }
    for k,v in ipairs(ranks) do
        if Polar.hasGroup(user_id, v) then
            return v
        end
    end
    return "None"
end
    
AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn and user_id == 1 then
        TriggerClientEvent('Polar:setStoreRankName', source, getStoreRankName(source))
        local storeItemsOwned = {
            'premium',
            'baller',
            'lock_slot',
            'phone_number',
            'license_plate',
            'smg_import',
            'baller_id',
            'shotgun_whitelist',
            'Polar_platinum',
            'supporter_to_supreme',
            'import_slot',
            'import_slot',
            'vip_car',
            'black_friday',
            'baller_id',
        }
        TriggerClientEvent('Polar:sendStoreItems', source, storeItemsOwned)
    end
end)

RegisterServerEvent("Polar:getStoreLockedVehicleCategories")
AddEventHandler("Polar:getStoreLockedVehicleCategories", function()
    local lockedCategories = {} -- Define the locked vehicle categories here
    TriggerClientEvent("Polar:setStoreLockedVehicleCategories", source, lockedCategories)
end)

RegisterServerEvent("Polar:redeemStoreItem")
AddEventHandler("Polar:redeemStoreItem", function(itemName, args)
    -- Handle the redemption logic here
    local player = source
    -- Example: Give the player the redeemed item or perform any other necessary actions
    -- You can access the args table to get the arguments sent from the client
    -- For example: local vehicleCategory = args.vehicleCategory

    -- Trigger any other events or logic that needs to happen upon redeeming an item
    TriggerClientEvent("Polar:storeDrawEffects", player) -- Notify clients to play effects
end)
-- NO WHERE NEAR DONE BTW SORRY