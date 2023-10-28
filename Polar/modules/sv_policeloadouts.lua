loadouts = {
    ['Pcso'] = {
        permission = "police.pcso",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK20VA5",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK20VA5",
            "WEAPON_M4A1CMG",
        },
    },
    ['CTSFO'] = {
        permission = "police.ctsfo",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK20VA5",
            "WEAPON_SPAR17",
            "WEAPON_HEYMAKER",
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
            "WEAPON_PDGLOCK20VA5",
            "WEAPON_M4A1CMG",
            "WEAPON_MK14",
            "WEAPON_FLASHBANG",
        },
    },
}


RegisterNetEvent('Polar:getPoliceLoadouts')
AddEventHandler('Polar:getPoliceLoadouts', function()
    local source = source
    local user_id = Polar.getUserId(source)
    local loadoutsTable = {}
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(loadouts) do
            v.hasPermission = Polar.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('Polar:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('Polar:selectLoadout')
AddEventHandler('Polar:selectLoadout', function(loadout)
    local source = source
    local user_id = Polar.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if Polar.hasPermission(user_id, 'police.onduty.permission') and Polar.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    Polarclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                end
                Polarclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                Polarclient.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)