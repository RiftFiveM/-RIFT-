RegisterNetEvent('Polar:purchaseHighRollersMembership')
AddEventHandler('Polar:purchaseHighRollersMembership', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if not Polar.hasGroup(user_id, 'Highroller') then
        if Polar.tryFullPayment(user_id,10000000) then
            Polar.addUserGroup(user_id, 'Highroller')
            Polarclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            tPolar.sendWebhook('purchase-highrollers',"Polar Purchased Highrollers Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            Polarclient.notify(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        Polarclient.notify(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('Polar:removeHighRollersMembership')
AddEventHandler('Polar:removeHighRollersMembership', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Highroller') then
        Polar.removeUserGroup(user_id, 'Highroller')
    else
        Polarclient.notify(source, {"~r~You do not have High Roller's License."})
    end
end)