RegisterServerEvent("Polar:getUserinformation")
AddEventHandler("Polar:getUserinformation",function(id)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('Polar:receivedUserInformation', source, Polar.getUserSource(id), GetPlayerName(Polar.getUserSource(id)), math.floor(Polar.getBankMoney(id)), math.floor(Polar.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("Polar:ManagePlayerBank")
AddEventHandler("Polar:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    local userstemp = Polar.getUserSource(id)
    if Polar.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            Polar.giveBankMoney(id, amount)
            Polarclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            Polar.tryBankPayment(id, amount)
            Polarclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('Polar:receivedUserInformation', source, Polar.getUserSource(id), GetPlayerName(Polar.getUserSource(id)), math.floor(Polar.getBankMoney(id)), math.floor(Polar.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("Polar:ManagePlayerCash")
AddEventHandler("Polar:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    local userstemp = Polar.getUserSource(id)
    if Polar.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            Polar.giveMoney(id, amount)
            Polarclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            Polar.tryPayment(id, amount)
            Polarclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('Polar:receivedUserInformation', source, Polar.getUserSource(id), GetPlayerName(Polar.getUserSource(id)), math.floor(Polar.getBankMoney(id)), math.floor(Polar.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("Polar:ManagePlayerChips")
AddEventHandler("Polar:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    local userstemp = Polar.getUserSource(id)
    if Polar.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            Polarclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('Polar:receivedUserInformation', source, Polar.getUserSource(id), GetPlayerName(Polar.getUserSource(id)), math.floor(Polar.getBankMoney(id)), math.floor(Polar.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            Polarclient.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            tPolar.sendWebhook('manage-balance',"Polar Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('Polar:receivedUserInformation', source, Polar.getUserSource(id), GetPlayerName(Polar.getUserSource(id)), math.floor(Polar.getBankMoney(id)), math.floor(Polar.getMoney(id)), chips)
                end
            end)
        end
    end
end)