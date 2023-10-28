local cfg = module("Polar-vehicles", "cfg_garages")
local impoundcfg = module("cfg/cfg_impound")

MySQL.createCommand("Polar/get_impounded_vehicles", "SELECT * FROM Polar_user_vehicles WHERE user_id = @user_id AND impounded = 1")
MySQL.createCommand("Polar/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level FROM Polar_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("Polar/unimpound_vehicle", "UPDATE Polar_user_vehicles SET impounded = 0, impound_info = null, impound_time = null WHERE vehicle = @vehicle AND user_id = @user_id")
MySQL.createCommand("Polar/impound_vehicle", "UPDATE Polar_user_vehicles SET impounded = 1, impound_info = @impound_info, impound_time = @impound_time WHERE vehicle = @vehicle AND user_id = @user_id")



RegisterNetEvent('Polar:getImpoundedVehicles')
AddEventHandler('Polar:getImpoundedVehicles', function()
    local source = source
    local user_id = Polar.getUserId(source)
    local returned_table = {}
    if user_id then
        MySQL.query("Polar/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
            for k,v in pairs(impoundedvehicles) do
                if impoundedvehicles[k]['impound_info'] ~= '' then
                    data = json.decode(impoundedvehicles[k]['impound_info'])
                    returned_table[v.vehicle] = {vehicle = v.vehicle, vehicle_name = data.vehicle_name, impounded_by_name = data.impounded_by_name, impounder = data.impounder, reasons = data.reasons}
                end
            end
            TriggerClientEvent('Polar:receiveImpoundedVehicles', source, returned_table)
        end)
    end
end)


RegisterNetEvent('Polar:fetchInfoForVehicleToImpound')
AddEventHandler('Polar:fetchInfoForVehicleToImpound', function(userid, spawncode, entityid)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(cfg.garages) do
            for a,b in pairs(v) do
                if a == spawncode then
                    vehicle = spawncode
                    vehicle_name = b[1]
                    owner_id = userid
                    vehiclenetid = entityid
                    if Polar.getUserSource(userid) ~= nil then
                        owner_name = GetPlayerName(Polar.getUserSource(userid))
                        TriggerClientEvent('Polar:receiveInfoForVehicleToImpound', source, owner_id, owner_name, vehicle, vehicle_name, vehiclenetid)
                        return
                    else
                        Polarclient.notify(source, {'~r~Unable to locate owner.'})
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Polar:releaseImpoundedVehicle')
AddEventHandler('Polar:releaseImpoundedVehicle', function(spawncode)
    local source = source
    local user_id = Polar.getUserId(source)
    MySQL.query("Polar/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
        for k,v in pairs(impoundedvehicles) do
            if impoundedvehicles[k]['impound_time'] ~= '' then
                if os.time() >= tonumber(impoundedvehicles[k]['impound_time'])+600 then
                    if Polar.tryFullPayment(user_id, 25000) then
                        MySQL.execute("Polar/unimpound_vehicle", {vehicle = spawncode, user_id = user_id})
                        local randomSpawn = math.random(#impoundcfg.positions)
                        MySQL.query("Polar/get_vehicles", {user_id = user_id}, function(result)
                            if result ~= nil then 
                                for k,v in pairs(result) do
                                    if v.vehicle == spawncode then
                                        TriggerClientEvent('Polar:spawnPersonalVehicle', source, v.vehicle, user_id, false, vector3(impoundcfg.positions[randomSpawn].x, impoundcfg.positions[randomSpawn].y, impoundcfg.positions[randomSpawn].z), v.vehicle_plate, v.fuel_level)
                                        TriggerEvent('Polar:addToCommunityPot', 10000)
                                        Polarclient.notifyPicture(source, {"polnotification","notification","Your vehicle has been released from the impound at the cost of ~g~£10,000~w~."})
                                        return
                                    end
                                end
                            end
                        end)
                    else
                        Polarclient.notify(source, {'~r~You do not have enough money to retrieve your vehicle from the impound.'})
                    end
                else
                    Polarclient.notifyPicture(source, {"polnotification","notification","This vehicle cannot be unimpounded for another ~r~"..math.floor( (tonumber(impoundedvehicles[k]['impound_time'])+600 - os.time())/60).."minutes ~w~."})
                end
            end
        end
    end)
end)


RegisterNetEvent('Polar:impoundVehicle')
AddEventHandler('Polar:impoundVehicle', function(userid, name, spawncode, vehiclename, reasons, entityid)
    local source = source
    local user_id = Polar.getUserId(source)
    local entitynetid = NetworkGetEntityFromNetworkId(entityid)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        local m = {}
        for k,v in pairs(impoundcfg.reasonsForImpound) do 
            for a,b in pairs(reasons) do
                if k == a then
                    table.insert(m, v.option)
                end
            end
        end
        MySQL.execute("Polar/impound_vehicle", {impound_info = json.encode({vehicle_name = vehiclename, impounded_by_name = GetPlayerName(source), impounder = user_id, reasons = m}), impound_time = os.time(), vehicle = spawncode, user_id = userid})
        local A,B = GetVehicleColours(entitynetid)
        TriggerClientEvent('Polar:impoundSuccess', source, entityid, vehiclename, GetPlayerName(Polar.getUserSource(userid)), spawncode, A, B, GetEntityCoords(entitynetid), GetEntityHeading(entitynetid))
        Polarclient.notifyPicture(Polar.getUserSource(userid), {"polnotification","notification","Your "..vehiclename.." has been impounded by ~b~"..GetPlayerName(source).." \n\n~w~For more information please visit the impound.","Metropolitan Police","Impound",nil,nil})
        tPolar.sendWebhook('impound', 'Polar Seize Boot Logs', "> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Vehicle Name: **"..vehiclename.."**\n> Owner ID: **"..userid.."**")
    end
end)


RegisterServerEvent("Polar:deleteImpoundEntities")
AddEventHandler("Polar:deleteImpoundEntities", function(a,b,c)
    TriggerClientEvent("Polar:deletePropClient", -1, a)
    TriggerClientEvent("Polar:deletePropClient", -1, b)
    TriggerClientEvent("Polar:deletePropClient", -1, c)
end)

RegisterServerEvent("Polar:awaitTowTruckArrival")
AddEventHandler("Polar:awaitTowTruckArrival", function(vehicle, flatbed, ped)
    local count = 0
    while count < 30 do
        Citizen.Wait(1000)
        count = count + 1
    end
    if count == 30 then
        TriggerClientEvent("Polar:deletePropClient", -1, vehicle)
        TriggerClientEvent("Polar:deletePropClient", -1, flatbed)
        TriggerClientEvent("Polar:deletePropClient", -1, ped)
    end
end)
