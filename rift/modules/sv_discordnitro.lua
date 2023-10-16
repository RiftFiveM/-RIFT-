RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("RIFT:spawnNitroBMX", source)
    else
        if tRIFT.checkForRole(user_id, '1149710708485927003') then
            TriggerClientEvent("RIFT:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFTclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("RIFT:spawnMoped", source)
        end
    end)
end)
