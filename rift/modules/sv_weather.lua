voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("RIFT:vote") 
AddEventHandler("RIFT:vote", function(weatherType)
    TriggerClientEvent("RIFT:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("RIFT:tryStartWeatherVote") 
AddEventHandler("RIFT:tryStartWeatherVote", function()
	local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("RIFT:startWeatherVote", -1)
            weatherVoterCooldown = 0
        else
            TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown-weatherVoterCooldown) .. " seconds!", {255, 0, 0})
        end
    else
        RIFTclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)

RegisterServerEvent("RIFT:getCurrentWeather") 
AddEventHandler("RIFT:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("RIFT:voteFinished",source,currentWeather)
end)

RegisterServerEvent("RIFT:setCurrentWeather")
AddEventHandler("RIFT:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)