voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("Polar:vote") 
AddEventHandler("Polar:vote", function(weatherType)
    TriggerClientEvent("Polar:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("Polar:tryStartWeatherVote") 
AddEventHandler("Polar:tryStartWeatherVote", function()
	local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("Polar:startWeatherVote", -1)
            weatherVoterCooldown = 0
RegisterServerEvent("Polar:vote") 
AddEventHandler("Polar:vote", function(weatherType)
    TriggerClientEvent("Polar:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("Polar:tryStartWeatherVote") 
AddEventHandler("Polar:tryStartWeatherVote", function()
	local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("Polar:startWeatherVote", -1)
            weatherVoterCooldown = 0
=======
>>>>>>> parent of e90955b (fix):polar/modules/sv_weather.lua
        else
            TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown-weatherVoterCooldown) .. " seconds!", {255, 0, 0})
        end
    else
        Polarclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)

<<<<<<< HEAD:polar/modules/sv_weather.lua
RegisterCommand('freezeweather', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent('Polar:notify', source, 'Dynamic weather changes are now ~r~disabled~s~.')
            else
                TriggerClientEvent('Polar:notify', source, 'Dynamic weather changes are now ~b~enabled~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
        end
    else
        DynamicWeather = not DynamicWeather
        if not DynamicWeather then
            print("Weather is now frozen.")
        else
            print("Weather is no longer frozen.")
        end
    end
end)

RegisterCommand('weather', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("Invalid syntax, correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Weather has been updated.")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('Polar:requestSync')
            else
                print("Invalid weather type, valid weather types are: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax, use ^0/weather <weatherType> ^1instead!')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('Polar:notify', source, 'Weather will change to: ~y~' .. string.lower(args[1]) .. "~s~.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('Polar:requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /weather denied.')
        end
    end
end, false)

RegisterCommand('blackout', function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print("Blackout is now enabled.")
        else
            print("Blackout is now disabled.")
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('Polar:notify', source, 'Blackout is now ~b~enabled~s~.')
            else
                TriggerClientEvent('Polar:notify', source, 'Blackout is now ~r~disabled~s~.')
            end
            TriggerEvent('Polar:requestSync')
        end
    end
end)

RegisterCommand('morning', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent('Polar:notify', source, 'Time set to ~y~morning~s~.')
        TriggerEvent('Polar:requestSync')
    end
end)
RegisterCommand('noon', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent('Polar:notify', source, 'Time set to ~y~noon~s~.')
        TriggerEvent('Polar:requestSync')
    end
end)
RegisterCommand('evening', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent('Polar:notify', source, 'Time set to ~y~evening~s~.')
        TriggerEvent('Polar:requestSync')
    end
end)
RegisterCommand('night', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent('Polar:notify', source, 'Time set to ~y~night~s~.')
        TriggerEvent('Polar:requestSync')
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("Time has changed to " .. argh .. ":" .. argm .. ".")
            TriggerEvent('Polar:requestSync')
        else
            print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent('Polar:notify', source, 'Time was changed to: ~y~' .. newtime .. "~s~!")
                TriggerEvent('Polar:requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /time denied.')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('Polar:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('Polar:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("Polar:requestSync")
    if debugprint then
        print("[Polar] New random weather type has been generated: " .. CurrentWeather .. ".\n")
        print("[Polar] Resetting timer to 10 minutes.\n")
    end
end

=======
RegisterServerEvent("Polar:getCurrentWeather") 
AddEventHandler("Polar:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("Polar:voteFinished",source,currentWeather)
end)

RegisterServerEvent("Polar:setCurrentWeather")
AddEventHandler("Polar:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
<<<<<<< HEAD:Polar/modules/sv_weather.lua
=======
        Polarclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)

RegisterServerEvent("Polar:getCurrentWeather") 
AddEventHandler("Polar:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("Polar:voteFinished",source,currentWeather)
end)

RegisterServerEvent("Polar:setCurrentWeather")
AddEventHandler("Polar:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
>>>>>>> parent of ab6642c (Haloween update):Polar/modules/sv_weather.lua
=======
>>>>>>> parent of e90955b (fix):polar/modules/sv_weather.lua
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)
>>>>>>> parent of ab6642c (Haloween update):Polar/modules/sv_weather.lua
<<<<<<< HEAD:Polar/modules/sv_weather.lua
=======
end)
>>>>>>> parent of ab6642c (Haloween update):Polar/modules/sv_weather.lua
=======
>>>>>>> parent of e90955b (fix):polar/modules/sv_weather.lua
