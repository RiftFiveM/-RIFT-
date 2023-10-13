ownedGaffs = {}
local cfg = module("cfg/cfg_housing")

--SQL

MySQL = module("modules/MySQL")

MySQL.createCommand("RIFT/get_address","SELECT home, number FROM rift_user_homes WHERE user_id = @user_id")
MySQL.createCommand("RIFT/get_home_owner","SELECT user_id FROM rift_user_homes WHERE home = @home AND number = @number")
MySQL.createCommand("RIFT/rm_address","DELETE FROM rift_user_homes WHERE user_id = @user_id AND home = @home")
MySQL.createCommand("RIFT/set_address","REPLACE INTO rift_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")
MySQL.createCommand("RIFT/fetch_rented_houses", "SELECT * FROM rift_user_homes WHERE rented = 1")
MySQL.createCommand("RIFT/rentedupdatehouse", "UPDATE rift_user_homes SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND home = @home")

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('RIFT/fetch_rented_houses', {}, function(rentedhouses)
            for i,v in pairs(rentedhouses) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('RIFT/rentedupdatehouse', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, home = v.home})
               end
            end
        end)
    end
end)

function getUserAddress(user_id, cbr)
    local task = Task(cbr)
  
    MySQL.query("RIFT/get_address", {user_id = user_id}, function(rows, affected)
        task({rows[1]})
    end)
end
  
function setUserAddress(user_id, home, number)
    MySQL.execute("RIFT/set_address", {user_id = user_id, home = home, number = number})
end
  
function removeUserAddress(user_id, home)
    MySQL.execute("RIFT/rm_address", {user_id = user_id, home = home})
end

function getUserByAddress(home, number, cbr)
    local task = Task(cbr)
  
    MySQL.query("RIFT/get_home_owner", {home = home, number = number}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end

function leaveHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = RIFT.getUserSource(user_id)
    tRIFT.setBucket(player, 0)
    for k, v in pairs(cfg.homes) do
        if k == home then
            local x,y,z = table.unpack(v.entry_point)
            RIFTclient.teleport(player, {x,y,z})
            RIFTclient.setInHome(player, {false})
            task({true})
        end
    end
end

function accessHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = RIFT.getUserSource(user_id)
    local count = 0
    for k, v in pairs(cfg.homes) do
        count = count+1
        if k == home then
            tRIFT.setBucket(player, count)
            local x,y,z = table.unpack(v.leave_point)
            RIFTclient.teleport(player, {x,y,z})
            RIFTclient.setInHome(player, {true})
            task({true})
        end
    end
end

RegisterNetEvent("RIFTHousing:Buy")
AddEventHandler("RIFTHousing:Buy", function(house)
    local source = source
    local user_id = RIFT.getUserId(source)
    local player = RIFT.getUserSource(user_id)

    for k, v in pairs(cfg.homes) do
        if house == k then
            getUserByAddress(house,1,function(noowner) --check if house already has a owner
                if noowner == nil then
                    getUserAddress(user_id, function(address) -- check if user already has a home
                        if RIFT.tryFullPayment(user_id,v.buy_price) then --try payment
                            local price = v.buy_price
                            setUserAddress(user_id,house,1) --set address
                            RIFTclient.notify(player,{"~g~You bought "..k.."!"}) --notify
                            for a,b in pairs(RIFT.getUsers({})) do
                                local x,y,z = table.unpack(v.entry_point)
                                RIFTclient.removeBlipAtCoords(b,{x,y,z})
                                if user_id == a then
                                    RIFTclient.addBlip(b,{x,y,z,374,1,house})
                                end
                            end
                            local webhook = 'webhook'
                            local embed = {
                                {
                                    ["color"] = "16777215",
                                    ["title"] = "House Logs",
                                    ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..RIFT.getUserId(source).."\n**Price: **".. price.. "\n **House Name: **" ..k,
                                    ["footer"] = {
                                        ["text"] = os.date("%X"),
                                    },
                                }
                            }
                            --PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'RIFT', embeds = embed}), { ['Content-Type'] = 'application/json' })
                        else
                            RIFTclient.notify(player,{"~r~You do not have enough money to buy "..k}) --not enough money
                        end
                    end)
                else
                    RIFTclient.notify(player,{"~r~Someone already owns "..k})
                end
                if noowner ~= nil then
                    TriggerClientEvent('HouseOwned', player)
                end
            end)
        end
    end
end)

RegisterNetEvent("RIFTHousing:Enter")
AddEventHandler("RIFTHousing:Enter", function(house)
    local user_id = RIFT.getUserId(source)
    local player = RIFT.getUserSource(user_id)
    local name = GetPlayerName(source)

    getUserByAddress(house, 1, function(huser_id) --check if player owns home
        local hplayer = RIFT.getUserSource(huser_id) --temp id of home owner

        if huser_id ~= nil then
            if huser_id == user_id then
                accessHome(user_id, house, 1, function(ok) --enter home
                    if not ok then
                        RIFTclient.notify(player,{"~r~Unable to enter home"}) --notify unable to enter home for whatever reason
                    end
                end)
            else
                if hplayer ~= nil then --check if home owner is online
                    RIFTclient.notify(player,{"~r~You do not own this home, Knocked on door!"})
                    RIFT.request(hplayer,name.." knocked on your door!", 30, function(v,ok) --knock on door
                        if ok then
                            RIFTclient.notify(player,{"~g~Doorbell Accepted"}) --doorbell accepted
                            accessHome(user_id, house, 1, function(ok) --enter home
                                if not ok then
                                    RIFTclient.notify(player,{"~r~Unable to enter home!"}) --notify unable to enter home for whatever reason
                                end
                            end)
                        end
                        if not ok then
                            RIFTclient.notify(player,{"~r~Doorbell Refused "}) -- doorbell refused
                        end
                    end)
                else
                    RIFTclient.notify(player,{"~r~Home owner not online!"}) -- home owner not online
                end
            end
        else
            RIFTclient.notify(player,{"~r~Nobody owns "..house..""}) --no home owner & user_id already doesn't have a house
        end
    end)
end)

RegisterNetEvent("RIFTHousing:Leave")
AddEventHandler("RIFTHousing:Leave", function(house)
    local user_id = RIFT.getUserId(source)
    local player = RIFT.getUserSource(user_id)

    leaveHome(user_id, house, 1, function(ok) --leave home
        if not ok then
            RIFTclient.notify(player,{"~r~Unable to leave home!"}) --notify if some error
        end
    end)
end)

RegisterNetEvent("RIFTHousing:Sell")
AddEventHandler("RIFTHousing:Sell", function(house)
    local user_id = RIFT.getUserId(source)
    local player = RIFT.getUserSource(user_id)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            RIFTclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. RIFT.getUserId(k) .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
                end
                if usrList ~= "" then
                    RIFT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then --validation
                            local target = RIFT.getUserSource(tonumber(target_id)) --get source of the new owner id
                            if target ~= nil then
                                RIFT.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        RIFT.request(target,GetPlayerName(player).." wants to sell: " ..house.. " Price: £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                            if ok then --bought
                                                local buyer_id = RIFT.getUserId(target) --get perm id of new owner
                                                amount = tonumber(amount) --convert amount str to int
                                                if RIFT.tryFullPayment(buyer_id,amount) then
                                                    setUserAddress(buyer_id, house, 1) --give house
                                                    removeUserAddress(user_id, house) -- remove house
                                                    RIFT.giveBankMoney(user_id, amount) --give money to original owner
                                                    RIFTclient.notify(player,{"~g~You have successfully sold "..house.." to ".. GetPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                    RIFTclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you "..house.." for £"..amount.."!"}) --notify new owner
                                                    local webhook = 'https://discord.com/api/webhooks/973347553280135198/dnkc8GYV2hOIe6oi0Nl6YXo-ymdP2OgV6zhCOG6e_SJGuPL9SawLHLCag8bvx5GbsEe6'
                                                    local embed = {
                                                        {
                                                            ["color"] = "16777215",
                                                            ["title"] = "House Logs",
                                                            ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..RIFT.getUserId(source).."\n**Buyer Name: **"..GetPlayerName(source).. "\n**Buyer ID: **" ..RIFT.getUserId(source).. "\n**Price: **".. amount.. "\n**House Name: **" ..house,
                                                            ["footer"] = {
                                                                ["text"] = os.date("%X"),
                                                            },
                                                        }
                                                    }
                                                    PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'RIFT', embeds = embed}), { ['Content-Type'] = 'application/json' })
                                    
                                               
                                                else
                                                    RIFTclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                    RIFTclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                end
                                            else
                                                RIFTclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy "..house.."!"}) --notify owner that refused
                                                RIFTclient.notify(target,{"~r~You have refused to buy "..house.."!"}) --notify new owner that refused
                                            end
                                        end)
                                    else
                                        RIFTclient.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                RIFTclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                            end
                        else
                            RIFTclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                        end
                    end)
                else
                    RIFTclient.notify(player,{"~r~No players nearby!"}) --no players nearby
                end
            end)
        else
            RIFTclient.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

RegisterNetEvent('RIFTHousing:Rent')
AddEventHandler('RIFTHousing:Rent', function(house)
    local user_id = RIFT.getUserId(source)
    local player = RIFT.getUserSource(user_id)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            RIFTclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. RIFT.getUserId(k) .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
                end
                if usrList ~= "" then
                    RIFT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then --validation
                            local target = RIFT.getUserSource(tonumber(target_id)) --get source of the new owner id
                            if target ~= nil then
                                RIFT.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        RIFT.prompt(player,"Duration: ","",function(player, duration) --ask for price
                                            if tonumber(duration) and tonumber(duration) > 0 then
                                                RIFT.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nHouse: "..house.."\nRent Cost: "..amount.."\nDuration: "..duration.." hours\nRenting to player: "..GetPlayerName(target).."("..target_id..")",function(player,details)
                                                    if string.upper(details) == 'YES' then
                                                        RIFTclient.notify(player, {'~g~Rent offer sent!'})
                                                        RIFT.request(target,GetPlayerName(player).." wants to rent: " ..house.. " for "..duration.." hours, for £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                                            if ok then 
                                                                local buyer_id = RIFT.getUserId(target) --get perm id of new owner
                                                                amount = tonumber(amount) --convert amount str to int
                                                                if RIFT.tryFullPayment(buyer_id,amount) then
                                                                    local rentedTime = os.time()
                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(duration)) 
                                                                    MySQL.execute("RIFT/rentedupdatehouse", {user_id = user_id, home = house, id = target_id, rented = 1, rentedid = user_id, rentedunix =  rentedTime }) 
                                                                    RIFT.giveBankMoney(user_id, amount)
                                                                    RIFTclient.notify(player,{"~g~You have successfully rented "..house.." to ".. GetPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                                    RIFTclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you "..house.." for £"..amount.."!"}) --notify new owner
                                                                    local webhook = 'https://discord.com/api/webhooks/973347553280135198/dnkc8GYV2hOIe6oi0Nl6YXo-ymdP2OgV6zhCOG6e_SJGuPL9SawLHLCag8bvx5GbsEe6'
                                                                    local embed = {
                                                                        {
                                                                            ["color"] = "16777215",
                                                                            ["title"] = "House Logs",
                                                                            ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..RIFT.getUserId(source).."\n**Buyer Name: **"..GetPlayerName(source).. "\n**Buyer ID: **" ..RIFT.getUserId(source).. "\n**Price: **".. amount.. "\n**House Name: **" ..house,
                                                                            ["footer"] = {
                                                                                ["text"] = os.date("%X"),
                                                                            },
                                                                        }
                                                                    }
                                                                    PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'RIFT', embeds = embed}), { ['Content-Type'] = 'application/json' })
                                                    
                                                            
                                                                else
                                                                    RIFTclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    RIFTclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            else
                                                                RIFTclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent "..house.."!"}) --notify owner that refused
                                                                RIFTclient.notify(target,{"~r~You have refused to rent "..house.."!"}) --notify new owner that refused
                                                            end
                                                        end)
                                                    end
                                                end)
                                            end
                                        end)
                                    else
                                        RIFTclient.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                RIFTclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                            end
                        else
                            RIFTclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                        end
                    end)
                else
                    RIFTclient.notify(player,{"~r~No players nearby!"}) --no players nearby
                end
            end)
        else
            RIFTclient.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

-- RegisterNetEvent("RIFT:raidHome")
-- AddEventHandler("RIFT:raidHome", function(house)
--     local user_id = RIFT.getUserId(source)
--     local player = RIFT.getUserSource(user_id)
--     local name = GetPlayerName(source)

--     getUserByAddress(house, 1 function(huser_id))
-- end)

AddEventHandler("RIFT:playerSpawn",function(user_id, source, first_spawn)
    for k, v in pairs(cfg.homes) do
        local x,y,z = table.unpack(v.entry_point)
        getUserByAddress(k,1,function(owner)
            if owner == nil then
                RIFTclient.addBlip(source,{x,y,z,374,2,k,0.8,true}) -- remove the 0.8 and true to display on full map instead of minimap
            end
            if owner == user_id then
                RIFTclient.addBlip(source,{x,y,z,374,1,k})
            end
        end)
    end
end)
