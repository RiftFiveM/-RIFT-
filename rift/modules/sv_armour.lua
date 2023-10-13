RegisterNetEvent("RIFT:getArmour")
AddEventHandler("RIFT:getArmour",function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, "police.armoury") then
        if RIFT.hasPermission(user_id, "police.maxarmour") then
            RIFTclient.setArmour(source, {100, true})
        elseif RIFT.hasGroup(user_id, "Inspector Clocked") then
            RIFTclient.setArmour(source, {75, true})
        elseif RIFT.hasGroup(user_id, "Senior Constable Clocked") or RIFT.hasGroup(user_id, "Sergeant Clocked") then
            RIFTclient.setArmour(source, {50, true})
        elseif RIFT.hasGroup(user_id, "PCSO Clocked") or RIFT.hasGroup(user_id, "PC Clocked") then
            RIFTclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("rift:PlaySound", source, 1)
        RIFTclient.notify(source, {"~g~You have received your armour."})
    else
        local player = RIFT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("RIFT:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)