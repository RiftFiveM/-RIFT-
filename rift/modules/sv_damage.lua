RegisterNetEvent("RIFT:syncEntityDamage")
AddEventHandler("RIFT:syncEntityDamage",function(u, v, t, s, m, n)
    local source=source
    local user_id=RIFT.getUserId(source)
    TriggerClientEvent('RIFT:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
end)