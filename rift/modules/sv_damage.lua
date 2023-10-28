RegisterNetEvent("Polar:syncEntityDamage")
AddEventHandler("Polar:syncEntityDamage",function(u, v, t, s, m, n)
    local source=source
    local user_id=Polar.getUserId(source)
    TriggerClientEvent('Polar:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
end)