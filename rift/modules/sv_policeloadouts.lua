loadouts = {
    ['Pcso'] = {
        permission = "police.pcso",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_M4A1",
        },
    },
    ['CTSFO'] = {
        permission = "police.ctsfo",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_SPAR17",
            "WEAPON_REMINGTON700",
            "WEAPON_FLASHBANG",
        },
    },
    -- ['MP5 Tazer'] = {
    --     permission = "police.announce",
    --     weapons = {
    --         "WEAPON_NONMP5",
    --     },
    -- },
    ['Gold Command'] = {
        permission = "Gold.command",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_M4A1",
            "WEAPON_AX50",
            "WEAPON_FLASHBANG",
        },
    },
}


RegisterNetEvent('RIFT:getPoliceLoadouts')
AddEventHandler('RIFT:getPoliceLoadouts', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local loadoutsTable = {}
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(loadouts) do
            v.hasPermission = RIFT.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('RIFT:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('RIFT:selectLoadout')
AddEventHandler('RIFT:selectLoadout', function(loadout)
    local source = source
    local user_id = RIFT.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if RIFT.hasPermission(user_id, 'police.onduty.permission') and RIFT.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    RIFTclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                end
                RIFTclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                RIFTclient.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)