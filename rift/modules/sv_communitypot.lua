RegisterServerEvent("RIFT:getCommunityPotAmount")
AddEventHandler("RIFT:getCommunityPotAmount", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    exports['ghmattimysql']:execute("SELECT value FROM rift_community_pot", function(potbalance)
        TriggerClientEvent('RIFT:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
    end)
end)

RegisterServerEvent("RIFT:tryDepositCommunityPot")
AddEventHandler("RIFT:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM rift_community_pot", function(potbalance)
            if RIFT.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['ghmattimysql']:execute("UPDATE rift_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('RIFT:gotCommunityPotAmount', source, newpotbalance)
                tRIFT.sendWebhook('com-pot', 'RIFT Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("RIFT:tryWithdrawCommunityPot")
AddEventHandler("RIFT:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM rift_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['ghmattimysql']:execute("UPDATE rift_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('RIFT:gotCommunityPotAmount', source, newpotbalance)
                RIFT.giveMoney(user_id, amount)
                tRIFT.sendWebhook('com-pot', 'RIFT Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("RIFT:addToCommunityPot")
AddEventHandler("RIFT:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['ghmattimysql']:execute("SELECT value FROM rift_community_pot", function(potbalance)
        local newpotbalance = 0
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['ghmattimysql']:execute("UPDATE rift_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)