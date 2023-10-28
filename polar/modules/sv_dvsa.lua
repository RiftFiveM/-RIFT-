local currenttests = {}
local dvsamodule = module("cfg/cfg_dvsa")


local dvsaAlerts = {
    --{title = 'DVSA', message = 'No current alerts.', date = 'Wednesday 7th September 2022'},
}

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = Polar.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if next(result) then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    local data1 = {}
                    local licence = {}
                    local date = os.date("%d/%m/%Y")
                    local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    if updateddata ~= nil then
                        licence = {
                            ["banned"] = updateddata.licence == "banned",
                            ["full"] = updateddata.licence == "full",
                            ["active"] = updateddata.licence == "active",
                            ["points"] = updateddata.points or 0,
                            ["id"] = updateddata.id or "No Licence",
                            ["date"] = date or os.date("%d/%m/%Y")
                        }
                    end
                    -- updateddata.penalties will be penalty points reasons like speeding, drink driving etc (s.offence, s.type, s.date, s.points)
                    -- need pnc for this tho so will do later
                    if updateddata.penalties == nil then
                        updateddata.penalties = {}
                    end
                    if updateddata.testsaves == nil then
                        updateddata.testsaves = {}
                    end
                    TriggerClientEvent('Polar:dvsaData',source,licence,updateddata.penalties,updateddata.testsaves,dvsaAlerts)
                    return
                end
            end
        else
            exports['ghmattimysql']:execute("INSERT INTO Polar_dvsa (user_id,licence,datelicence) VALUES (@user_id, 'none',"..os.date("%d/%m/%Y")..")", {user_id = user_id})
            local data1 = {}
            local licence = {}
            local date = os.date("%d/%m/%Y")
            local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
            if updateddata ~= nil then
                licence = {
                    ["banned"] = updateddata.licence == "banned",
                    ["full"] = updateddata.licence == "full",
                    ["active"] = updateddata.licence == "active",
                    ["points"] = updateddata.points or 0,
                    ["id"] = updateddata.id or "No Licence",
                    ["date"] = date or os.date("%d/%m/%Y")
                }
            end
            TriggerClientEvent('Polar:dvsaData',source,licence,{},{},dvsaAlerts)
            return
        end
    end)
end)

function dvsaUpdate(user_id)
    local source = Polar.getUserSource(user_id)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    local licence = {}
    local date = os.date("%d/%m/%Y")
    if data ~= nil then
        licence = {
            ["banned"] = data.licence == "banned",
            ["full"] = data.licence == "full",
            ["active"] = data.licence == "active",
            ["points"] = data.points or 0,
            ["id"] = data.id or "No Licence",
            ["date"] = date or os.date("%d/%m/%Y")
        }
    end
    TriggerClientEvent('Polar:updateDvsaData',source,licence,json.decode(data.penalties),json.decode(data.testsaves),dvsaAlerts)
end
RegisterServerEvent("Polar:dvsaBucket")
AddEventHandler("Polar:dvsaBucket", function(bool)
    local source = source
    local user_id = Polar.getUserId(source)
    if bool then
        if currenttests[user_id] ~= nil then
            currenttests[user_id] = nil
        end
        tPolar.setBucket(source, 0)
    elseif not bool then
        if currenttests[user_id] ~= nil then
            Polarclient.notify(source,{'~r~You already have a test in progress.'})
            return
        end
        local bucket = math.random(21,300)
        local highestcount = 21
        if table.count(currenttests) > 0 then
            for k,v in pairs(currenttests) do
                if v.bucket == bucket then
                    repeat highestcount = math.random(21,300) until highestcount ~= bucket
                end
            end
        end
        currenttests[user_id] = {
            ["bucket"] = highestcount
        }
        tPolar.setBucket(source, currenttests[user_id].bucket)
    end
end)

RegisterServerEvent("Polar:candidatePassed")
AddEventHandler("Polar:candidatePassed", function(seriousissues,minorissues,minorreasons)
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = Polar.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM Polar_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, minor = minorissues, minorsReason = minorreasons, pass = true}) 
        else
            table.insert(previoustests, {date = localday, serious = seriousissues,  minor = minorissues, minorsReason = minorreasons, pass = true})
        end
        if licence == "active" then
            exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET licence = 'full', testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("Polar:candidateFailed")
AddEventHandler("Polar:candidateFailed", function(seriousissues,minorissues,seriousreasons,minorreasons)    
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = Polar.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM Polar_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        else
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        end
        if licence == "active" then
            exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("Polar:beginTest")
AddEventHandler("Polar:beginTest", function()
    local source = source
    local user_id = Polar.getUserId(source)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == ("full" or "banned") then
        TriggerClientEvent('Polar:beginTestClient', source, false)
        return
    end
    if data.licence == "active" then
        TriggerClientEvent('Polar:beginTestClient', source,true,math.random(1,3))
    else
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Trigger Driving Test with a non-active licence.')
    end
end)

RegisterServerEvent("Polar:surrenderLicence")
AddEventHandler("Polar:surrenderLicence", function()
    local source = source
    local user_id = Polar.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == "banned" then
        Polarclient.notify(source,{'~r~You are already banned from driving.'})
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to surrender licence when already banned.')
        return
    end
    if data.licence == "active" or data.licence == "full" then
        exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET licence = @licence WHERE user_id = @user_id", {licence = "none", user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("Polar:activateLicence")
AddEventHandler("Polar:activateLicence", function()
    local source = source
    local user_id = Polar.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM Polar_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data == nil then return end
    if data.licence == "none" then
        exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET licence = @licence, datelicence = @datelicense WHERE user_id = @user_id", {licence = "active", datelicense = os.date("%d/%m/%Y"), user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE Polar_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("Polar:speedCameraFlashServer",function(speed)
    local source = source
    local user_id = Polar.getUserId(source)
    local name = GetPlayerName(source)
    local bank = Polar.getBankMoney(user_id)
    local speed = tonumber(speed)
    local overspeed = speed-100
    local fine = 5000
    if Polar.hasPermission(user_id,"police.onduty.permission") then
        return
    end
    if tonumber(bank) > fine then
        Polar.setBankMoney(user_id,bank-fine)
        TriggerEvent('Polar:addToCommunityPot', fine)
        TriggerClientEvent('Polar:dvsaMessage', source,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..overspeed.."MPH over the speed limit.")
        -- could add in the future that it gives points to a license
        return
    else
        Polarclient.notify(source,{'~r~You could not afford the fine. Benefits paid.'})
        return
    end
end)

RegisterServerEvent('Polar:speedGunFinePlayer')
AddEventHandler('Polar:speedGunFinePlayer', function(temp, speed)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
      local fine = speed*100
      Polar.tryBankPayment(Polar.getUserId(temp), fine)
      TriggerClientEvent('Polar:speedGunPlayerFined', temp)
      TriggerClientEvent('Polar:dvsaMessage', temp,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit.")
      Polarclient.notify(source, { "~r~Fined "..GetPlayerName(temp).." £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit."})
    end
end)

local speedTraps = {}
RegisterCommand('setup', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        if speedTraps[user_id] then
            Polarclient.removeBlipAtCoords(-1,speedTraps[user_id])
            speedTraps[user_id] = nil
            Polarclient.notify(source,{'~r~Speed Trap Removed.'})
        else
            local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
            Polarclient.addBlip(-1,{x,y,z,419,0,"Speed Camera",2.5})
            speedTraps[user_id] = {x,y,z}
            Polarclient.notify(source,{'~g~Speed Trap Setup.'})
        end
    end
end)