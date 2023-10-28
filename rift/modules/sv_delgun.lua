netObjects = {}

RegisterServerEvent("Polar:spawnVehicleCallback")
AddEventHandler('Polar:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = Polar.getUserSource(a), id = a, name = GetPlayerName(Polar.getUserSource(a))}
end)

RegisterServerEvent("Polar:delGunDelete")
AddEventHandler("Polar:delGunDelete", function(object)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("Polar:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("Polar:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)