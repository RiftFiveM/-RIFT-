RegisterNetEvent('RIFT:purchaseHighRollersMembership')
AddEventHandler('RIFT:purchaseHighRollersMembership', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not RIFT.hasGroup(user_id, 'Highroller') then
        if RIFT.tryFullPayment(user_id,10000000) then
            RIFT.addUserGroup(user_id, 'Highroller')
            RIFTclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            tRIFT.sendWebhook('purchase-highrollers',"RIFT Purchased Highrollers Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            RIFTclient.notify(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        RIFTclient.notify(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('RIFT:removeHighRollersMembership')
AddEventHandler('RIFT:removeHighRollersMembership', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Highroller') then
        RIFT.removeUserGroup(user_id, 'Highroller')
    else
        RIFTclient.notify(source, {"~r~You do not have High Roller's License."})
    end
end)