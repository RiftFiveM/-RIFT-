RegisterServerEvent("RIFT:getUserinformation")
AddEventHandler("RIFT:getUserinformation",function(id)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RIFT:receivedUserInformation', source, RIFT.getUserSource(id), GetPlayerName(RIFT.getUserSource(id)), math.floor(RIFT.getBankMoney(id)), math.floor(RIFT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RIFT:ManagePlayerBank")
AddEventHandler("RIFT:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    local userstemp = RIFT.getUserSource(id)
    if RIFT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            RIFT.giveBankMoney(id, amount)
            RIFTclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            RIFT.tryBankPayment(id, amount)
            RIFTclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RIFT:receivedUserInformation', source, RIFT.getUserSource(id), GetPlayerName(RIFT.getUserSource(id)), math.floor(RIFT.getBankMoney(id)), math.floor(RIFT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RIFT:ManagePlayerCash")
AddEventHandler("RIFT:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    local userstemp = RIFT.getUserSource(id)
    if RIFT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            RIFT.giveMoney(id, amount)
            RIFTclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            RIFT.tryPayment(id, amount)
            RIFTclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('RIFT:receivedUserInformation', source, RIFT.getUserSource(id), GetPlayerName(RIFT.getUserSource(id)), math.floor(RIFT.getBankMoney(id)), math.floor(RIFT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("RIFT:ManagePlayerChips")
AddEventHandler("RIFT:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    local userstemp = RIFT.getUserSource(id)
    if RIFT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            RIFTclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('RIFT:receivedUserInformation', source, RIFT.getUserSource(id), GetPlayerName(RIFT.getUserSource(id)), math.floor(RIFT.getBankMoney(id)), math.floor(RIFT.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            RIFTclient.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            tRIFT.sendWebhook('manage-balance',"RIFT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('RIFT:receivedUserInformation', source, RIFT.getUserSource(id), GetPlayerName(RIFT.getUserSource(id)), math.floor(RIFT.getBankMoney(id)), math.floor(RIFT.getMoney(id)), chips)
                end
            end)
        end
    end
end)