local tickets = {}
local callID = 0
local cooldown = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = Polar.getUserId(source)
    local user_source = Polar.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            Polarclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    Polar.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 25 then
                callID = callID + 1
                tickets[callID] = {
                    name = GetPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = 'Admin Ticket',
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(Polar.getUsers({})) do
                    TriggerClientEvent("Polar:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                Polarclient.notify(user_source,{"~b~Your request has been sent."})
                Polarclient.notify(user_source,{"~y~If you are reporting a player you can also create a report at www.Polarrp.co.uk/forums"})
            else
                Polarclient.notify(user_source,{"~r~Please enter a minimum of 25 characters."})
            end
        else
            Polarclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = Polar.getUserId(source)
    local user_source = Polar.getUserSource(user_id)
    Polar.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(Polar.getUsers({})) do
                TriggerClientEvent("Polar:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            Polarclient.notify(user_source,{"~b~Sent Police Call."})
        else
            Polarclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = Polar.getUserId(source)
    local user_source = Polar.getUserSource(user_id)
    Polar.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(Polar.getUsers({})) do
                TriggerClientEvent("Polar:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            Polarclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            Polarclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.tickets') then
        if savedPositions[user_id] then
            tPolar.setBucket(source, savedPositions[user_id].bucket)
            Polarclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            Polarclient.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            Polarclient.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('Polar:sendTicketInfo', source)
        Polarclient.staffMode(source, {false})
        SetTimeout(1000, function() 
            Polarclient.setPlayerCombatTimer(source, {0})
        end)
    end
end)


RegisterNetEvent("Polar:TakeTicket")
AddEventHandler("Polar:TakeTicket", function(ticketID)
    local user_id = Polar.getUserId(source)
    local admin_source = Polar.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and Polar.hasPermission(user_id, "admin.tickets") then
                    if Polar.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                tPolar.setBucket(admin_source, playerbucket)
                                Polarclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            Polarclient.getPosition(v.tempID, {}, function(coords)
                                Polarclient.staffMode(admin_source, {true})
                                TriggerClientEvent('Polar:sendTicketInfo', admin_source, v.permID, v.name)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                    ticketPay = 20000
                                else
                                    ticketPay = 10000
                                end
                                exports['ghmattimysql']:execute("SELECT * FROM `Polar_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                    if result ~= nil then 
                                        for k,v in pairs(result) do
                                            if v.user_id == user_id then
                                                exports['ghmattimysql']:execute("UPDATE Polar_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = GetPlayerName(admin_source)}, function() end)
                                                return
                                            end
                                        end
                                        exports['ghmattimysql']:execute("INSERT INTO Polar_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = GetPlayerName(admin_source)}, function() end) 
                                    end
                                end)
                                Polar.giveBankMoney(user_id, ticketPay)
                                Polarclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for being cute. ❤️"})
                                -- Polarclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                TriggerClientEvent('Polar:smallAnnouncement', v.tempID, '~r~Ticket Accepted', "~Y~Your admin ticket has been accepted by "..GetPlayerName(admin_source), 33, 10000)
                                tPolar.sendWebhook('ticket-logs',"Polar Ticket Logs", "> Admin Name: **"..GetPlayerName(admin_source).."**\n> Admin TempID: **"..admin_source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..v.name.."**\n> Player PermID: **"..v.permID.."**\n> Player TempID: **"..v.tempID.."**\n> Reason: **"..v.reason.."**")
                                Polarclient.teleport(admin_source, {table.unpack(coords)})
                                TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                                tickets[ticketID] = nil
                            end)
                        else
                            Polarclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        Polarclient.notify(admin_source,{"~r~You cannot take a ticket from an offline player."})
                        TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and Polar.hasPermission(user_id, "police.onduty.permission") then
                    if Polar.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                Polarclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                        else
                            Polarclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and Polar.hasPermission(user_id, "nhs.onduty.permission") then
                    if Polar.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            Polarclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                        else
                            Polarclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("Polar:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

RegisterNetEvent("Polar:PDRobberyCall")
AddEventHandler("Polar:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = Polar.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(Polar.getUsers({})) do
        TriggerClientEvent("Polar:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("Polar:NHSComaCall")
AddEventHandler("Polar:NHSComaCall", function()
    local user_id = Polar.getUserId(source)
    local user_source = Polar.getUserSource(user_id)
    local reason = 'Immediate Attention'
    callID = callID + 1
    tickets[callID] = {
        name = GetPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        reason = reason,
        type = 'nhs'
    }
    for k, v in pairs(Polar.getUsers({})) do
        TriggerClientEvent("Polar:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
    end
end)