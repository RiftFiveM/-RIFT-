RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("Polar:spawnNitroBMX", source)
    else
        if tPolar.checkForRole(user_id, '1149710708485927003') then
            TriggerClientEvent("Polar:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    Polarclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("Polar:spawnMoped", source)
        end
    end)
end)
