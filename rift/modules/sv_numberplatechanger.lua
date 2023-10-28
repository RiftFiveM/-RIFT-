local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
	"nigger",
	"cunt",
	"faggot",
	"fuck",
	"fucker",
	"fucking",
	"anal",
	"stupid",
	"damn",
	"cock",
	"cum",
	"dick",
	"dipshit",
	"dildo",
	"douchbag",
	"douch",
	"kys",
	"jerk",
	"jerkoff",
	"gay",
	"homosexual",
	"lesbian",
	"suicide",
	"mothafucka",
	"negro",
	"pussy",
	"queef",
	"queer",
	"weeb",
	"retard",
	"masterbate",
	"suck",
	"tard",
	"allahu akbar",
	"terrorist",
	"twat",
	"vagina",
	"wank",
	"whore",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"free up mandem",
	"nazi",
	"hitler",
	"cheater",
	"cheating",
}

MySQL.createCommand("Polar/update_numplate","UPDATE Polar_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("Polar/check_numplate","SELECT * FROM Polar_user_vehicles WHERE vehicle_plate = @plate")

RegisterNetEvent('Polar:getCars')
AddEventHandler('Polar:getCars', function()
    local cars = {}
    local source = source
    local user_id = Polar.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM `Polar_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('Polar:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("Polar:ChangeNumberPlate")
AddEventHandler("Polar:ChangeNumberPlate", function(vehicle)
	local source = source
    local user_id = Polar.getUserId(source)
	Polar.prompt(source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		exports['ghmattimysql']:execute("SELECT * FROM `Polar_user_vehicles` WHERE vehicle_plate = @plate", {plate = plateName}, function(result)
            if next(result) then 
                Polarclient.notify(source,{"~r~This plate is already taken."})
                return
			else
				for name in pairs(forbiddenNames) do
					if plateName == forbiddenNames[name] then
						Polarclient.notify(source,{"~r~You cannot have this plate."})
						return
					end
				end
				if Polar.tryFullPayment(user_id,50000) then
					Polarclient.notify(source,{"~g~Changed plate of "..vehicle.." to "..plateName})
					MySQL.execute("Polar/update_numplate", {user_id = user_id, registration = plateName, vehicle = vehicle})
					TriggerClientEvent("Polar:RecieveNumberPlate", source, plateName)
					TriggerClientEvent("Polar:PlaySound", source, "apple")
					TriggerEvent('Polar:getCars')
				else
					Polarclient.notify(source,{"~r~You don't have enough money!"})
				end
            end
        end)
	end)
end)

RegisterNetEvent("Polar:checkPlateAvailability")
AddEventHandler("Polar:checkPlateAvailability", function(plate)
	local source = source
    local user_id = Polar.getUserId(source)
	MySQL.query("Polar/check_numplate", {plate = plate}, function(result)
		if #result > 0 then 
			Polarclient.notify(source, {"~r~The plate "..plate.." is already taken."})
		else
			Polarclient.notify(source, {"~g~The plate "..plate.." is available."})
		end
	end)
end)
