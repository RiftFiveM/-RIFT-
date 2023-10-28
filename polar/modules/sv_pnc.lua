RegisterServerEvent('Polar:checkForPolicewhitelist')
AddEventHandler('Polar:checkForPolicewhitelist', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        if Polar.hasPermission(user_id, 'police.announce') then
            TriggerClientEvent('Polar:openPNC', source, true, {}, {})
        else
            TriggerClientEvent('Polar:openPNC', source, false, {}, {})
        end
    end
end)

RegisterServerEvent('Polar:searchPerson')
AddEventHandler('Polar:searchPerson', function(firstname, lastname)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        exports['ghmattimysql']:execute("SELECT * FROM Polar_user_identities WHERE firstname = @firstname AND name = @lastname", {firstname = firstname, lastname = lastname}, function(result) 
            if result ~= nil then
                local returnedUsers = {}
                for k,v in pairs(result) do
                    local user_id = result[k].user_id
                    local firstname = result[k].firstname
                    local lastname = result[k].name
                    local age = result[k].age
                    local phone = result[k].phone
                    local data = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    local licence = data.licence
                    local points = data.points
                    local ownedVehicles = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
                    local actualVehicles = {}
                    for a,b in pairs(ownedVehicles) do 
                        table.insert(actualVehicles, b.vehicle)
                    end
                    local ownedProperties = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_user_homes WHERE user_id = @user_id", {user_id = user_id})
                    local actualHouses = {}
                    for a,b in pairs(ownedProperties) do 
                        table.insert(actualHouses, b.home)
                    end
                    table.insert(returnedUsers, {user_id = user_id, firstname = firstname, lastname = lastname, age = age, phone = phone, licence = licence, points = points, vehicles = actualVehicles, playerhome = actualHouses, warrants = {}, warning_markers = {}})
                end
                if next(returnedUsers) then
                    TriggerClientEvent('Polar:sendSearcheduser', source, returnedUsers)
                else
                    TriggerClientEvent('Polar:noPersonsFound', source)
                end
            end
        end)
    end
end)

RegisterServerEvent('Polar:finePlayer')
AddEventHandler('Polar:finePlayer', function(id, charges, amount, notes)
    local source = source
    local user_id = Polar.getUserId(source)
    local amount = tonumber(amount)
    if amount > 250000 then
        amount = 250000
    end
    if next(charges) then
        local chargesList = ""
        for k,v in pairs(charges) do
            chargesList = chargesList.."\n> - **"..v.fine.."**"
        end
        if Polar.hasPermission(user_id, 'police.onduty.permission') then
            if id == user_id then
                TriggerClientEvent('Polar:verifyFineSent', source, false, "Can't fine yourself!")
                return
            end
            if Polar.tryBankPayment(id, amount) then
                Polar.giveBankMoney(user_id, amount*0.1)
                Polarclient.notify(Polar.getUserSource(id), {'~r~You have been fined £'..getMoneyStringFormatted(amount)..'.'})
                Polarclient.notify(source, {'~g~You have received £'..getMoneyStringFormatted(math.floor(amount*0.1))..' for fining '..GetPlayerName(Polar.getUserSource(id))..'.'})
                TriggerEvent('Polar:addToCommunityPot', tonumber(amount))
                TriggerClientEvent('Polar:verifyFineSent', source, true)
                tPolar.sendWebhook('fine-player', 'Polar Fine Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..GetPlayerName(Polar.getUserSource(id)).."**\n> Criminal PermID: **"..id.."**\n> Criminal TempID: **"..Polar.getUserSource(id).."**\n> Amount: **£"..amount.."**\n> Charges: "..chargesList)--.."\n> Notes: **"..notes.."**")
                -- do notes later
            else
                TriggerClientEvent('Polar:verifyFineSent', source, false, 'The player does not have enough money.')
            end
        end
    end
end)

RegisterServerEvent('Polar:addPoints')
AddEventHandler('Polar:addPoints', function(points, id)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        -- Polarclient.notify(Polar.getUserSource(id), {'~r~You have received '..points..' on your licence.'})
        -- exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET points = points+@newpoints WHERE user_id = @user_id", {user_id = id, newpoints = points})
        -- exports['ghmattimysql']:execute('SELECT * FROM Polar_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(licenceInfo)
        --     local licenceType = licenceInfo[1].licence
        --     local points = json.decode(licenceInfo[1].points)
        --     if (licenceType == "active" or licenceType == "full") and points > 12 then
        --         exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET licence = 'banned' WHERE user_id = @user_id", {user_id = id})
        --         Wait(100)
        --         dvsaUpdate(user_id)
        --     end
        -- end)
    end
end)


RegisterCommand('testad', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id == 1 then
        TriggerClientEvent('Polar:notifyAD', source, 'Phase 3 Firearms', 'Red Vauxhall Corsa')
    end
end)