local cfg = module("rift-vehicles", "cfg_garages")
local impoundcfg = module("cfg/cfg_impound")

MySQL.createCommand("RIFT/get_impounded_vehicles", "SELECT * FROM rift_user_vehicles WHERE user_id = @user_id AND impounded = 1")
MySQL.createCommand("RIFT/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level FROM rift_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("RIFT/unimpound_vehicle", "UPDATE rift_user_vehicles SET impounded = 0, impound_info = null, impound_time = null WHERE vehicle = @vehicle AND user_id = @user_id")
MySQL.createCommand("RIFT/impound_vehicle", "UPDATE rift_user_vehicles SET impounded = 1, impound_info = @impound_info, impound_time = @impound_time WHERE vehicle = @vehicle AND user_id = @user_id")



RegisterNetEvent('RIFT:getImpoundedVehicles')
AddEventHandler('RIFT:getImpoundedVehicles', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local returned_table = {}
    if user_id then
        MySQL.query("RIFT/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
            for k,v in pairs(impoundedvehicles) do
                if impoundedvehicles[k]['impound_info'] ~= '' then
                    data = json.decode(impoundedvehicles[k]['impound_info'])
                    returned_table[v.vehicle] = {vehicle = v.vehicle, vehicle_name = data.vehicle_name, impounded_by_name = data.impounded_by_name, impounder = data.impounder, reasons = data.reasons}
                end
            end
            TriggerClientEvent('RIFT:receiveImpoundedVehicles', source, returned_table)
        end)
    end
end)


RegisterNetEvent('RIFT:fetchInfoForVehicleToImpound')
AddEventHandler('RIFT:fetchInfoForVehicleToImpound', function(userid, spawncode, entityid)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(cfg.garages) do
            for a,b in pairs(v) do
                if a == spawncode then
                    vehicle = spawncode
                    vehicle_name = b[1]
                    owner_id = userid
                    vehiclenetid = entityid
                    if RIFT.getUserSource(userid) ~= nil then
                        owner_name = GetPlayerName(RIFT.getUserSource(userid))
                        TriggerClientEvent('RIFT:receiveInfoForVehicleToImpound', source, owner_id, owner_name, vehicle, vehicle_name, vehiclenetid)
                        return
                    else
                        RIFTclient.notify(source, {'~r~Unable to locate owner.'})
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('RIFT:releaseImpoundedVehicle')
AddEventHandler('RIFT:releaseImpoundedVehicle', function(spawncode)
    local source = source
    local user_id = RIFT.getUserId(source)
    MySQL.query("RIFT/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
        for k,v in pairs(impoundedvehicles) do
            if impoundedvehicles[k]['impound_time'] ~= '' then
                if os.time() >= tonumber(impoundedvehicles[k]['impound_time'])+600 then
                    if RIFT.tryFullPayment(user_id, 25000) then
                        MySQL.execute("RIFT/unimpound_vehicle", {vehicle = spawncode, user_id = user_id})
                        local randomSpawn = math.random(#impoundcfg.positions)
                        MySQL.query("RIFT/get_vehicles", {user_id = user_id}, function(result)
                            if result ~= nil then 
                                for k,v in pairs(result) do
                                    if v.vehicle == spawncode then
                                        TriggerClientEvent('RIFT:spawnPersonalVehicle', source, v.vehicle, user_id, false, vector3(impoundcfg.positions[randomSpawn].x, impoundcfg.positions[randomSpawn].y, impoundcfg.positions[randomSpawn].z), v.vehicle_plate, v.fuel_level)
                                        TriggerEvent('RIFT:addToCommunityPot', 10000)
                                        RIFTclient.notifyPicture(source, {"polnotification","notification","Your vehicle has been released from the impound at the cost of ~g~£10,000~w~."})
                                        return
                                    end
                                end
                            end
                        end)
                    else
                        RIFTclient.notify(source, {'~r~You do not have enough money to retrieve your vehicle from the impound.'})
                    end
                else
                    RIFTclient.notifyPicture(source, {"polnotification","notification","This vehicle cannot be unimpounded for another ~r~"..math.floor( (tonumber(impoundedvehicles[k]['impound_time'])+600 - os.time())/60).."minutes ~w~."})
                end
            end
        end
    end)
end)


RegisterNetEvent('RIFT:impoundVehicle')
AddEventHandler('RIFT:impoundVehicle', function(userid, name, spawncode, vehiclename, reasons, entityid)
    local source = source
    local user_id = RIFT.getUserId(source)
    local entitynetid = NetworkGetEntityFromNetworkId(entityid)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        local m = {}
        for k,v in pairs(impoundcfg.reasonsForImpound) do 
            for a,b in pairs(reasons) do
                if k == a then
                    table.insert(m, v.option)
                end
            end
        end
        MySQL.execute("RIFT/impound_vehicle", {impound_info = json.encode({vehicle_name = vehiclename, impounded_by_name = GetPlayerName(source), impounder = user_id, reasons = m}), impound_time = os.time(), vehicle = spawncode, user_id = userid})
        local A,B = GetVehicleColours(entitynetid)
        TriggerClientEvent('RIFT:impoundSuccess', source, entityid, vehiclename, GetPlayerName(RIFT.getUserSource(userid)), spawncode, A, B, GetEntityCoords(entitynetid), GetEntityHeading(entitynetid))
        RIFTclient.notifyPicture(RIFT.getUserSource(userid), {"polnotification","notification","Your "..vehiclename.." has been impounded by ~b~"..GetPlayerName(source).." \n\n~w~For more information please visit the impound.","Metropolitan Police","Impound",nil,nil})
        tRIFT.sendWebhook('impound', 'RIFT Seize Boot Logs', "> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Vehicle Name: **"..vehiclename.."**\n> Owner ID: **"..userid.."**")
    end
end)


RegisterServerEvent("RIFT:deleteImpoundEntities")
AddEventHandler("RIFT:deleteImpoundEntities", function(a,b,c)
    TriggerClientEvent("RIFT:deletePropClient", -1, a)
    TriggerClientEvent("RIFT:deletePropClient", -1, b)
    TriggerClientEvent("RIFT:deletePropClient", -1, c)
end)

RegisterServerEvent("RIFT:awaitTowTruckArrival")
AddEventHandler("RIFT:awaitTowTruckArrival", function(vehicle, flatbed, ped)
    local count = 0
    while count < 30 do
        Citizen.Wait(1000)
        count = count + 1
    end
    if count == 30 then
        TriggerClientEvent("RIFT:deletePropClient", -1, vehicle)
        TriggerClientEvent("RIFT:deletePropClient", -1, flatbed)
        TriggerClientEvent("RIFT:deletePropClient", -1, ped)
    end
end)
