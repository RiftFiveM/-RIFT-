local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id,"DJ") then
        TriggerClientEvent('Polar:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('Polar:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = Polar.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if Polar.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('Polar:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("Polar:adminStopSong")
AddEventHandler("Polar:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('Polar:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('Polar:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("Polar:playDjSongServer")
AddEventHandler("Polar:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = Polar.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('Polar:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("Polar:skipServer")
AddEventHandler("Polar:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('Polar:skipDj', -1,coords,param)
end)
RegisterServerEvent("Polar:stopSongServer")
AddEventHandler("Polar:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('Polar:stopSong', -1,coords)
end)
RegisterServerEvent("Polar:updateVolumeServer")
AddEventHandler("Polar:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('Polar:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("Polar:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("Polar:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('Polar:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("Polar:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("Polar:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == Polar.getUserSource(x) then
            TriggerClientEvent('Polar:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
