MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO Polar_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM Polar_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE Polar_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE Polar_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = Polar.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("Polar:enterDiamondCasino")
AddEventHandler("Polar:enterDiamondCasino", function()
    local source = source
    local user_id = Polar.getUserId(source)
    tPolar.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('Polar:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("Polar:exitDiamondCasino")
AddEventHandler("Polar:exitDiamondCasino", function()
    local source = source
    local user_id = Polar.getUserId(source)
    tPolar.setBucket(source, 0)
end)

RegisterNetEvent("Polar:getChips")
AddEventHandler("Polar:getChips", function()
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('Polar:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("Polar:buyChips")
AddEventHandler("Polar:buyChips", function(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    if not amount then amount = Polar.getMoney(user_id) end
    if Polar.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('Polar:chipsUpdated', source)
        tPolar.sendWebhook('purchase-chips',"Polar Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        Polarclient.notify(source,{"~r~You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("Polar:sellChips")
AddEventHandler("Polar:sellChips", function(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('Polar:chipsUpdated', source)
                    tPolar.sendWebhook('sell-chips',"Polar Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    Polar.giveMoney(user_id, amount)
                else
                    Polarclient.notify(source,{"~r~You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)

-- Casino Chips is awesome PS these files were made by Spexxst3r and tylonster