RegisterCommand('addgroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        Polar.addUserGroup(userid,group)
        print('Added Group: ' .. group .. ' to UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('removegroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        Polar.removeUserGroup(userid,group)
        print('Removed Group: ' .. group .. ' from UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('ban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local hours = args[2]
        local reason = table.concat(args," ", 3)
        if reason then 
            Polar.banConsole(userid,hours,reason)
        else 
            print('Incorrect usage: ban [permid] [hours] [reason]')
        end 
    else 
        print('Incorrect usage: ban [permid] [hours] [reason]')
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        Polar.setBanned(userid,false)
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)

RegisterCommand('givemoneytoall', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local amount = tonumber(args[1])
        for k,v in pairs(Polar.getUsers()) do
            Polar.giveBankMoney(k, amount)
        end
    else 
        print('Incorrect usage: givemoneytoall [amount]')
    end
end)

RegisterCommand('removemoney', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) then
        local amount = tonumber(args[1])
        for k, v in pairs(Polar.getUsers()) do
            local currentBalance = Polar.getBankMoney(k)
            if currentBalance >= amount then
                Polar.setBankMoney(k, currentBalance - amount)
            else
                print('Error: User ' .. k .. ' does not have enough money to deduct ' .. amount)
            end
        end
    else
        print('Incorrect usage: takemoneyfromall [amount]')
    end
end)

RegisterCommand("kit", function(source, args, raw)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasGroup(user_id, "Founder") then
        Polarclient.giveWeapons(source, {{["WEAPON_NERFMOSIN"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_AR15"] = {ammo = 250}}})
        Polarclient.setArmour(source, {100})
        TriggerClientEvent("Polar:Revive", source)
    end
end)

local cooldowns = {} -- Table to store cooldown timestamps
local cooldownTime = 1200 -- Cooldown time in seconds (20 minutes)

RegisterCommand("Boost", function(source, args, raw)
    local playerId = source
    local user_id = Polar.getUserId(playerId)

    if user_id ~= nil and Polar.hasGroup(user_id, "Booster") then
        if not cooldowns[playerId] or (GetGameTimer() - cooldowns[playerId]) >= cooldownTime * 1000 then
            Polarclient.giveWeapons(playerId, {{["WEAPON_NERFMOSIN"] = {ammo = 250}}})
            Polarclient.setArmour(playerId, {100})
            TriggerClientEvent("Polar:Revive", playerId)

            -- Set the cooldown timestamp
            cooldowns[playerId] = GetGameTimer()
        else
            local remainingTime = math.floor((cooldownTime * 1000 - (GetGameTimer() - cooldowns[playerId])) / 1000)
            TriggerClientEvent('chatMessage', playerId, '^1Cooldown: ^7You must wait ' .. remainingTime .. ' seconds before using this command again.')
        end
    end
end)

local cooldowns = {} -- Table to store cooldown timestamps
local cooldownTime = 120 -- Cooldown time in seconds (2 minutes)

RegisterCommand("GunWl", function(source, args, raw)
    local playerId = source
    local user_id = Polar.getUserId(playerId)

<<<<<<< HEAD:Polar/modules/server_commands.lua
    -- Check if the player is on the whitelist
    local whitelistedWeapons = {
        [1] = "WEAPON_NERFMOSIN",
        [37] = "WEAPON_CBHONEYBADGER",
        [66] = "WEAPON_ANARCHY",
        [19] = "WEAPON_BLASTXPHANTOM",
        [32] = "WEAPON_M82A3",
        [32] = "WEAPON_NERFMOSIN",
        [2] = "WEAPON_SPACEFLIGHTMP5"
    }

    if whitelistedWeapons[user_id] then
        local weaponName = whitelistedWeapons[user_id]
        Polarclient.giveWeapons(playerId, {{[weaponName] = {ammo = 250}}})
        Polarclient.setArmour(source, {100})
    else
        local lastCooldownTime = cooldowns[playerId] or 0
        local currentTime = GetGameTimer()

        if (currentTime - lastCooldownTime) >= cooldownTime then
            tPolar.notify("~r~You are not whitelisted to this weapon.")
=======
    if user_id == 1 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_NERFMOSIN"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    elseif user_id == 37 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_CBHONEYBADGER"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    elseif user_id == 66 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_ANARCHY"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    elseif user_id == 19 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_BLASTXPHANTOM"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    elseif user_id == 32 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_M82A3"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    elseif user_id == 2 then
        RIFTclient.giveWeapons(playerId, {{["WEAPON_SPACEFLIGHTMP5"] = {ammo = 250}}})
        RIFTclient.setArmour(source, {100})
    else
        if not cooldowns[playerId] or (GetGameTimer() - cooldowns[playerId]) >= cooldownTime * 1000 then
            tRIFT.notify("~r~You are not whitelisted to this weapon.")
>>>>>>> parent of 95ce20f (clothing store fixed):rift/modules/server_commands.lua
            -- Set the cooldown timestamp
            cooldowns[playerId] = GetGameTimer()
        else
<<<<<<< HEAD:Polar/modules/server_commands.lua
            local remainingTime = math.floor((cooldownTime - (currentTime - lastCooldownTime)) / 1000)
            tPolar.notify("^1Cooldown: ^7You must wait " .. remainingTime .. " seconds before using this command again.")
=======
            local remainingTime = math.floor((cooldownTime * 1000 - (GetGameTimer() - cooldowns[playerId])) / 1000)
            tRIFT.notify("^1Cooldown: ^7You must wait " .. remainingTime .. " seconds before using this command again.")
>>>>>>> parent of 95ce20f (clothing store fixed):rift/modules/server_commands.lua
        end
    end
end)

RegisterCommand("pdkit", function(source, args, raw)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasGroup(user_id, "Special Constable Clocked") then
        Polarclient.giveWeapons(source, {{["WEAPON_AX50"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_M4A1"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_PDGLOCK"] = {ammo = 250}}})
        Polarclient.setArmour(source, {100})
        TriggerClientEvent("Polar:Revive", source)
    end
end)

RegisterCommand("bfcjbfrjfvbjfncsdkvnccsjdcndjcndksjcndjcbcssjdcndsjkcnjkdscbdjesdcbjsdkcnj", function(source, args, raw)
   local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasGroup(user_id, "TutorialDone") then
        Polarclient.giveWeapons(source, {{["WEAPON_NERFMOSIN"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_AK200"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_REVOLVER357"] = {ammo = 250}}})
      Polarclient.giveWeapons(source, {{["WEAPON_spas12"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_SVD"] = {ammo = 250}}})
        Polarclient.giveWeapons(source, {{["WEAPON_M1911"] = {ammo = 250}}})
        Polarclient.setArmour(source, {100})
        TriggerClientEvent("Polar:Revive", source)
    end
end)

