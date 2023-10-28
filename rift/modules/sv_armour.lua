RegisterNetEvent("Polar:getArmour")
AddEventHandler("Polar:getArmour",function()
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, "police.armoury") then
        if Polar.hasPermission(user_id, "police.maxarmour") then
            Polarclient.setArmour(source, {100, true})
        elseif Polar.hasGroup(user_id, "Inspector Clocked") then
            Polarclient.setArmour(source, {75, true})
        elseif Polar.hasGroup(user_id, "Senior Constable Clocked") or Polar.hasGroup(user_id, "Sergeant Clocked") then
            Polarclient.setArmour(source, {50, true})
        elseif Polar.hasGroup(user_id, "PCSO Clocked") or Polar.hasGroup(user_id, "PC Clocked") then
            Polarclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("Polar:PlaySound", source, 1)
        Polarclient.notify(source, {"~g~You have received your armour."})
    else
        local player = Polar.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("Polar:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)