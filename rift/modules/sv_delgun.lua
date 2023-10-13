netObjects = {}

RegisterServerEvent("RIFT:spawnVehicleCallback")
AddEventHandler('RIFT:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = RIFT.getUserSource(a), id = a, name = GetPlayerName(RIFT.getUserSource(a))}
end)

RegisterServerEvent("RIFT:delGunDelete")
AddEventHandler("RIFT:delGunDelete", function(object)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("RIFT:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("RIFT:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)