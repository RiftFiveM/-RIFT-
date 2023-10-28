local lang = Polar.lang
local cfg = module("Polar-vehicles", "cfg_garages")
local cfg_inventory = module("Polar-vehicles", "cfg_inventory")
local vehicle_groups = cfg.garages
local limit = cfg.limit or 100000000
MySQL.createCommand("Polar/add_vehicle","INSERT IGNORE INTO Polar_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)")
MySQL.createCommand("Polar/remove_vehicle","DELETE FROM Polar_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("Polar/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level, impounded FROM Polar_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("Polar/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM Polar_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("Polar/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM Polar_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("Polar/get_vehicle","SELECT vehicle FROM Polar_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("Polar/get_vehicle_fuellevel","SELECT fuel_level FROM Polar_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("Polar/check_rented","SELECT * FROM Polar_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("Polar/sell_vehicle_player","UPDATE Polar_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("Polar/rentedupdate", "UPDATE Polar_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("Polar/fetch_rented_vehs", "SELECT * FROM Polar_user_vehicles WHERE rented = 1")
MySQL.createCommand("Polar/get_vehicle_count","SELECT vehicle FROM Polar_user_vehicles WHERE vehicle = @vehicle")

RegisterServerEvent("Polar:spawnPersonalVehicle")
AddEventHandler('Polar:spawnPersonalVehicle', function(vehicle)
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.vehicle == vehicle then
                    if v.impounded then
                        Polarclient.notify(source, {'~r~This vehicle is currently impounded.'})
                        return
                    else
                        TriggerClientEvent('Polar:spawnPersonalVehicle', source, v.vehicle, user_id, false, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                        return
                    end
                end
            end
        end
    end)
end)

valetCooldown = {}
RegisterServerEvent("Polar:valetSpawnVehicle")
AddEventHandler('Polar:valetSpawnVehicle', function(spawncode)
    local source = source
    local user_id = Polar.getUserId(source)
    Polarclient.isPlusClub(source,{},function(plusclub)
        Polarclient.isPlatClub(source,{},function(platclub)
            if plusclub or platclub then
                if valetCooldown[source] and not (os.time() > valetCooldown[source]) then
                    return Polarclient.notify(source,{"~r~Please wait before using this again."})
                else
                    valetCooldown[source] = nil
                end
                MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.vehicle == spawncode then
                                TriggerClientEvent('Polar:spawnPersonalVehicle', source, v.vehicle, user_id, true, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                                valetCooldown[source] = os.time() + 60
                                return
                            end
                        end
                    end
                end)
            else
                Polarclient.notify(source, {"~y~You need to be a subscriber of Polar Plus or Polar Platinum to use this feature."})
                Polarclient.notify(source, {"~y~Available @ https://Polarstudios.tebex.io"})
            end
        end)
    end)
end)

RegisterServerEvent("Polar:getVehicleRarity")
AddEventHandler('Polar:getVehicleRarity', function(spawncode)
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_vehicle_count", {vehicle = spawncode}, function(result)
        if result ~= nil then 
            TriggerClientEvent('Polar:setVehicleRarity', source, spawncode, #result)
        end
    end)
end)

RegisterServerEvent("Polar:displayVehicleBlip")
AddEventHandler('Polar:displayVehicleBlip', function(spawncode)
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polarls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                Polarclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['remoteblips'] == 1 then
                            local position = {}
                            position.x, position.y, position.z = x,y,z
                            if next(position) then
                                TriggerClientEvent('Polar:displayVehicleBlip', source, position)
                                Polarclient.notify(source, {"~g~Vehicle blip enabled."})
                                return
                            end
                        end
                        Polarclient.notify(source, {"~r~This vehicle does not have a remote vehicle blip installed."})
                    else
                        Polarclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent("Polar:viewRemoteDashcam")
AddEventHandler('Polar:viewRemoteDashcam', function(spawncode)
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polarls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                Polarclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['dashcam'] == 1 then
                            if next(table.pack(x,y,z)) then
                                for k,v in pairs(netObjects) do
                                    if math.floor(vector3(x,y,z)) == math.floor(GetEntityCoords(NetworkGetEntityFromNetworkId(k))) then
                                        TriggerClientEvent('Polar:viewRemoteDashcam', source, table.pack(x,y,z), k)
                                        return
                                    end
                                end
                            end
                        end
                        Polarclient.notify(source, {"~r~This vehicle does not have a remote dashcam installed."})
                    else
                        Polarclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent("Polar:updateFuel")
AddEventHandler('Polar:updateFuel', function(vehicle, fuel_level)
    local source = source
    local user_id = Polar.getUserId(source)
    exports["ghmattimysql"]:execute("UPDATE Polar_user_vehicles SET fuel_level = @fuel_level WHERE user_id = @user_id AND vehicle = @vehicle", {fuel_level = fuel_level, user_id = user_id, vehicle = vehicle}, function() end)
end)

RegisterServerEvent("Polar:getCustomFolders")
AddEventHandler('Polar:getCustomFolders', function()
    local source = source
    local user_id = Polar.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `Polar_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("Polar:sendFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("Polar:updateFolders")
AddEventHandler('Polar:updateFolders', function(FolderUpdated)
    local source = source
    local user_id = Polar.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `Polar_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['ghmattimysql']:execute("UPDATE Polar_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['ghmattimysql']:execute("INSERT INTO Polar_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        MySQL.query('Polar/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('Polar/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
                  if Polar.getUserSource(v.rentedid) ~= nil then
                    Polarclient.notify(Polar.getUserSource(v.rentedid), {"~r~Your rented vehicle has been returned."})
                  end
               end
            end
        end)
    end
end)

RegisterNetEvent('Polar:FetchCars')
AddEventHandler('Polar:FetchCars', function(type)
    local source = source
    local user_id = Polar.getUserId(source)
    local returned_table = {}
    local fuellevels = {}
    if user_id then
        MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local perms = false
                    local config = vehicle_groups[i]._config
                    if config.type == vehicle_groups[type]._config.type then 
                        local perm = config.permissions or nil
                        if next(perm) then
                            for i, v in pairs(perm) do
                                if Polar.hasPermission(user_id, v) then
                                    perms = true
                                end
                            end
                        else
                            perms = true
                        end
                        if perms then 
                            for a, z in pairs(v) do
                                if a ~= "_config" and veh.vehicle == a then
                                    if not returned_table[i] then 
                                        returned_table[i] = {["_config"] = config}
                                    end
                                    if not returned_table[i].vehicles then 
                                        returned_table[i].vehicles = {}
                                    end
                                    returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate, veh.fuel_level}
                                    fuellevels[a] = veh.fuel_level
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('Polar:ReturnFetchedCars', source, returned_table, fuellevels)
        end)
    end
end)

RegisterNetEvent('Polar:CrushVehicle')
AddEventHandler('Polar:CrushVehicle', function(vehicle)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id then 
        MySQL.query("Polar/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("Polar/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    Polarclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    Polarclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('Polar/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                tPolar.sendWebhook('crush-vehicle', "Polar Crush Vehicle Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Vehicle: **"..vehicle.."**")
                TriggerClientEvent('Polar:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('Polar:SellVehicle')
AddEventHandler('Polar:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = Polar.getUserId(source)
    if playerID ~= nil then
		Polarclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. Polar.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				Polar.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = Polar.getUserSource(tonumber(user_id))
						if target ~= nil then
							Polar.prompt(player,"Price £: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("Polar/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											Polarclient.notify(player,{"~r~The player already has this vehicle type."})
										else
											local tmpdata = Polar.getUserTmpTable(playerID)
											MySQL.query("Polar/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    Polarclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    Polar.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: £"..getMoneyStringFormatted(amount), 10, function(target,ok)
                                                        if ok then
                                                            local pID = Polar.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if Polar.tryFullPayment(pID,amount) then
                                                                Polarclient.despawnGarageVehicle(player,{'car',15}) 
                                                                Polar.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("Polar/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                Polar.giveBankMoney(playerID, amount)
                                                                Polarclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..getMoneyStringFormatted(amount).."!"})
                                                                Polarclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..getMoneyStringFormatted(amount).."!"})
                                                                tPolar.sendWebhook('sell-vehicle', "Polar Sell Vehicle Logs", "> Seller Name: **"..GetPlayerName(player).."**\n> Seller TempID: **"..player.."**\n> Seller PermID: **"..playerID.."**\n> Buyer Name: **"..GetPlayerName(target).."**\n> Buyer TempID: **"..target.."**\n> Buyer PermID: **"..user_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**\n> Vehicle: **"..vehicle.."**")
                                                                TriggerClientEvent('Polar:CloseGarage', player)
                                                            else
                                                                Polarclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                Polarclient.notify(target,{"~r~You don't have enough money!"})
                                                            end
                                                        else
                                                            Polarclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
                                                            Polarclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									Polarclient.notify(player,{"~r~The price of the car has to be a number."})
								end
							end)
						else
							Polarclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						Polarclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				Polarclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)


RegisterNetEvent('Polar:RentVehicle')
AddEventHandler('Polar:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = Polar.getUserId(source)
    if playerID ~= nil then
		Polarclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. Polar.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				Polar.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = Polar.getUserSource(tonumber(user_id))
						if target ~= nil then
							Polar.prompt(player,"Price £: ","",function(player,amount)
                                Polar.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("Polar/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    Polarclient.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = Polar.getUserTmpTable(playerID)
                                                    MySQL.query("Polar/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            return
                                                        else
                                                            Polar.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nVehicle: "..name.."\nRent Cost: "..getMoneyStringFormatted(amount).."\nDuration: "..rent.." hours\nRenting to player: "..GetPlayerName(target).."("..Polar.getUserId(target)..")",function(player,details)
                                                                if string.upper(details) == 'YES' then
                                                                    Polarclient.notify(player, {'~g~Rent offer sent!'})
                                                                    Polar.request(target,GetPlayerName(player).." wants to rent: " ..name.. " Price: £"..getMoneyStringFormatted(amount) .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                        if ok then
                                                                            local pID = Polar.getUserId(target)
                                                                            amount = tonumber(amount)
                                                                            if Polar.tryFullPayment(pID,amount) then
                                                                                Polarclient.despawnGarageVehicle(player,{'car',15}) 
                                                                                Polar.getUserIdentity(pID, function(identity)
                                                                                    local rentedTime = os.time()
                                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                                    MySQL.execute("Polar/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                                end)
                                                                                Polar.giveBankMoney(playerID, amount)
                                                                                Polarclient.notify(player,{"~g~You have successfully rented the vehicle to "..GetPlayerName(target).." for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                Polarclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the car for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                tPolar.sendWebhook('rent-vehicle', "Polar Rent Vehicle Logs", "> Renter Name: **"..GetPlayerName(player).."**\n> Renter TempID: **"..player.."**\n> Renter PermID: **"..playerID.."**\n> Rentee Name: **"..GetPlayerName(target).."**\n> Rentee TempID: **"..target.."**\n> Rentee PermID: **"..pID.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**\n> Duration: **"..rent.." hours**\n> Vehicle: **"..veh.."**")
                                                                                --TriggerClientEvent('Polar:CloseGarage', player)
                                                                            else
                                                                                Polarclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                                Polarclient.notify(target,{"~r~You don't have enough money!"})
                                                                            end
                                                                        else
                                                                            Polarclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent the car."})
                                                                            Polarclient.notify(target,{"~r~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                        end
                                                                    end)
                                                                else
                                                                    Polarclient.notify(player, {'~r~Rent offer cancelled!'})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            Polarclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        Polarclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							Polarclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						Polarclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				Polarclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('Polar:FetchRented')
AddEventHandler('Polar:FetchRented', function()
    local rentedin = {}
    local rentedout = {}
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_rented_vehicles_in", {user_id = user_id}, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not Polar.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not rentedin.vehicles then 
                            rentedin.vehicles = {}
                        end
                        local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                        local minutesLeft = nil
                        if hoursLeft < 1 then
                            minutesLeft = hoursLeft * 60
                            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                            datetime = minutesLeft .. " mins" 
                        else
                            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                            datetime = hoursLeft .. " hours" 
                        end
                        rentedin.vehicles[a] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        MySQL.query("Polar/get_rented_vehicles_out", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local config = vehicle_groups[i]._config
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not Polar.hasPermission(user_id, v) then
                                break
                            end
                        end
                    end
                    for a, z in pairs(v) do
                        if a ~= "_config" and veh.vehicle == a then
                            if not rentedout.vehicles then 
                                rentedout.vehicles = {}
                            end
                            local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                            local minutesLeft = nil
                            if hoursLeft < 1 then
                                minutesLeft = hoursLeft * 60
                                minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                                datetime = minutesLeft .. " mins" 
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                                datetime = hoursLeft .. " hours" 
                            end
                            rentedout.vehicles[a] = {z[1], datetime, veh.user_id, a}
                        end
                    end
                end
            end
            TriggerClientEvent('Polar:ReturnedRentedCars', source, rentedin, rentedout)
        end)
    end)
end)

RegisterNetEvent('Polar:CancelRent')
AddEventHandler('Polar:CancelRent', function(spawncode, VehicleName, a)
    local source = source
    local user_id = Polar.getUserId(source)
    if a == 'owner' then
        exports['ghmattimysql']:execute("SELECT * FROM Polar_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local target = Polar.getUserSource(result[i].user_id)
                        if target ~= nil then
                            Polar.request(target,GetPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('Polar/rentedupdate', {id = user_id, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                    Polarclient.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    Polarclient.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    Polarclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            Polarclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    elseif a == 'renter' then
        exports['ghmattimysql']:execute("SELECT * FROM Polar_user_vehicles WHERE user_id = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local rentedid = tonumber(result[i].rentedid)
                        local target = Polar.getUserSource(rentedid)
                        if target ~= nil then
                            Polar.request(target,GetPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('Polar/rentedupdate', {id = rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = user_id, veh = spawncode})
                                    Polarclient.notify(source, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    Polarclient.notify(target, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    Polarclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            Polarclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    end
end)

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = Polar.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if Polar.tryGetInventoryItem(user_id,"repairkit",1,true) then
      Polarclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        Polarclient.fixeNearestVehicle(player,{7})
        Polarclient.stopAnim(player,{false})
      end)
    end
  end
end

RegisterNetEvent("Polar:PayVehicleTax")
AddEventHandler("Polar:PayVehicleTax", function()
    local user_id = Polar.getUserId(source)
    if user_id ~= nil then
        local bank = Polar.getBankMoney(user_id)
        local payment = bank / 10000
        if Polar.tryBankPayment(user_id, payment) then
            Polarclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(math.floor(payment)).." vehicle tax."})
            TriggerEvent('Polar:addToCommunityPot', math.floor(payment))
        else
            Polarclient.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        end
    end
end)

RegisterNetEvent("Polar:refreshGaragePermissions")
AddEventHandler("Polar:refreshGaragePermissions",function()
    local source=source
    local garageTable={}
    local user_id = Polar.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if json.encode(b.permissions) ~= '[""]' then
                    local hasPermissions = 0
                    for c,d in pairs(b.permissions) do
                        if Polar.hasPermission(user_id, d) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #b.permissions then
                        table.insert(garageTable, k)
                    end
                else
                    table.insert(garageTable, k)
                end
            end
        end
    end
    local ownedVehicles = {}
    if user_id then
        MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for k,v in pairs(pvehicles) do
                table.insert(ownedVehicles, v.vehicle)
            end
            TriggerClientEvent('Polar:updateOwnedVehicles', source, ownedVehicles)
        end)
    end
    TriggerClientEvent("Polar:recieveRefreshedGaragePermissions",source,garageTable)
end)


RegisterNetEvent("Polar:getGarageFolders")
AddEventHandler("Polar:getGarageFolders",function()
    local source = source
    local user_id = Polar.getUserId(source)
    local garageFolders = {}
    local addedFolders = {}
    MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                local spawncode = v.vehicle 
                for a,b in pairs(vehicle_groups) do
                    local hasPerm = true
                    if next(b._config.permissions) then
                        if not Polar.hasPermission(user_id, b._config.permissions[1]) then
                            hasPerm = false
                        end
                    end
                    if hasPerm then
                        for c,d in pairs(b) do
                            if c == spawncode and not v.impounded then
                                if not addedFolders[a] then
                                    table.insert(garageFolders, {display = a})
                                    addedFolders[a] = true
                                end
                                for e,f in pairs (garageFolders) do
                                    if f.display == a then
                                        if f.vehicles == nil then
                                            f.vehicles = {}
                                        end
                                        table.insert(f.vehicles, {display = d[1], spawncode = spawncode})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('Polar:setVehicleFolders', source, garageFolders)
        end
    end)
end)

local cfg_weapons = module("Polar-weapons", "cfg/weapons")

RegisterServerEvent("Polar:searchVehicle")
AddEventHandler('Polar:searchVehicle', function(entity, permid)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        if Polar.getUserSource(permid) ~= nil then
            Polarclient.getNetworkedVehicleInfos(Polar.getUserSource(permid), {entity}, function(owner, spawncode)
                if spawncode and owner == permid then
                    local vehformat = 'chest:u1veh_'..spawncode..'|'..permid
                    Polar.getSData(vehformat, function(cdata)
                        if cdata ~= nil then
                            cdata = json.decode(cdata)
                            if next(cdata) then
                                for a,b in pairs(cdata) do
                                    if string.find(a, 'wbody|') then
                                        c = a:gsub('wbody|', '')
                                        cdata[c] = b
                                        cdata[a] = nil
                                    end
                                end
                                for k,v in pairs(cfg_weapons.weapons) do
                                    if cdata[k] ~= nil then
                                        if not v.policeWeapon then
                                            Polarclient.notify(source, {'~r~Seized '..v.name..' x'..cdata[k].amount..'.'})
                                            cdata[k] = nil
                                        end
                                    end
                                end
                                for c,d in pairs(cdata) do
                                    if seizeBullets[c] then
                                        Polarclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                    if seizeDrugs[c] then
                                        Polarclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                end
                                Polar.setSData(vehformat, json.encode(cdata))
                                tPolar.sendWebhook('seize-boot', 'Polar Seize Boot Logs', "> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Owner ID: **"..permid.."**")
                            else
                                Polarclient.notify(source, {'~r~This vehicle is empty.'})
                            end
                        else
                            Polarclient.notify(source, {'~r~This vehicle is empty.'})
                        end
                    end)
                end
            end)
        end
    end
end)


Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `Polar_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)
