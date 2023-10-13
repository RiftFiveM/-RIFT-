local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id,"DJ") then
        TriggerClientEvent('RIFT:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('RIFT:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = RIFT.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if RIFT.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('RIFT:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("RIFT:adminStopSong")
AddEventHandler("RIFT:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('RIFT:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('RIFT:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("RIFT:playDjSongServer")
AddEventHandler("RIFT:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = RIFT.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('RIFT:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("RIFT:skipServer")
AddEventHandler("RIFT:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('RIFT:skipDj', -1,coords,param)
end)
RegisterServerEvent("RIFT:stopSongServer")
AddEventHandler("RIFT:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('RIFT:stopSong', -1,coords)
end)
RegisterServerEvent("RIFT:updateVolumeServer")
AddEventHandler("RIFT:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('RIFT:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("RIFT:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("RIFT:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('RIFT:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("RIFT:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("RIFT:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == RIFT.getUserSource(x) then
            TriggerClientEvent('RIFT:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
