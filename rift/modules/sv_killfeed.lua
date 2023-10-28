local killlogs = 'https://discordapp.com/api/webhooks/1133702120877604985/dIEZ_1tc2IWOlmP4CG6Ip8ESWt2v7CvzU88uEVocQ3W9qauP8UNGD9ITR3DWJhwvy-qz'
local damagelogs = 'https://discordapp.com/api/webhooks/1133702261953015849/7gcOmejLBkOKpePKU_PjO_TK2bC__Ga8-T1QSXXNXdmz3MWIHzbZ1eIdKMu1IjbIUsHo'

local f = module("Polar-weapons", "cfg/weapons")
f=f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

local function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

RegisterNetEvent('Polar:onPlayerKilled')
AddEventHandler('Polar:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    if distance ~= nil then
        distance = math.floor(distance) 
    end
    if killtype == 'killed' then
        if Polar.hasPermission(Polar.getUserId(source), 'police.onduty.permission') then
            killedgroup = 'police'
        elseif Polar.hasPermission(Polar.getUserId(source), 'nhs.onduty.permission') then
            killedgroup = 'nhs'
        end
        if Polar.hasPermission(Polar.getUserId(killer), 'police.onduty.permission') then
            killergroup = 'police'
        elseif Polar.hasPermission(Polar.getUserId(killer), 'nhs.onduty.permission') then
            killergroup = 'nhs'
        end
        if killer ~= nil then
            weaponhash = getWeaponName(weaponhash)
            TriggerClientEvent('Polar:newKillFeed', -1, GetPlayerName(killer), GetPlayerName(source), weaponhash, suicide, distance, killedgroup, killergroup)
            local embed = {
                {
                  ["color"] = "0x2596be",
                  ["title"] = "Kill Logs",
                  ["description"] = "",
                  ["text"] = "Polar Server #1",
                  ["fields"] = {
                    {
                        ["name"] = "Killer Name",
                        ["value"] = GetPlayerName(killer),
                        ["inline"] = true
                    }, 
                    {
                        ["name"] = "Killer ID",
                        ["value"] = Polar.getUserId(killer),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim ID",
                        ["value"] = Polar.getUserId(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Weapon Used",
                        ["value"] = weaponhash,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Distance",
                        ["value"] = distance..'m',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Kill Type",
                        ["value"] = killtype,
                        ["inline"] = true
                    },
                  }
                }
              }
              PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "Polar", embeds = embed}), { ['Content-Type'] = 'application/json' })
        else
            TriggerClientEvent('Polar:newKillFeed', -1, GetPlayerName(source), GetPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
        end
    elseif killtype == 'finished off' and killer ~= nil then
        weaponhash = getWeaponName(weaponhash)
        local embed = {
            {
              ["color"] = "0x2596be",
              ["title"] = "Finished Off Logs",
              ["description"] = "",
              ["text"] = "Polar Server #1",
              ["fields"] = {
                {
                    ["name"] = "Killer Name",
                    ["value"] = GetPlayerName(killer),
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Name",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Used",
                    ["value"] = weaponhash,
                    ["inline"] = true
                },
                {
                    ["name"] = "Killer Group",
                    ["value"] = killergroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Group",
                    ["value"] = killedgroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Kill Type",
                    ["value"] = killtype,
                    ["inline"] = true
                },
              }
            }
          }
          PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "Polar", embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
    TriggerClientEvent('Polar:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
    local user_id = Polar.getUserId(sender)
    local name = GetPlayerName(sender)
	if ev.weaponDamage ~= 0 then
        if ev.weaponType == 3218215474 or (ev.weaponType == 911657153 and not Polar.hasPermission(user_id, 'police.onduty.permission')) then
            TriggerEvent("Polar:acBan", user_id, 8, name, sender, ev.weaponType)
        end
        local embed = {
            {
              ["color"] = "0x2596be",
              ["title"] = "Damage Logs",
              ["description"] = "",
              ["text"] = "Polar Server #1",
              ["fields"] = {
                {
                    ["name"] = "Player Name",
                    ["value"] = name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Temp ID",
                    ["value"] = sender,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Perm ID",
                    ["value"] = user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "Damage",
                    ["value"] = ev.weaponDamage,
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Hash",
                    ["value"] = ev.weaponType,
                    ["inline"] = true
                },
              }
            }
          }        
        PerformHttpRequest(damagelogs, function(err, text, headers) end, 'POST', json.encode({username = "Polar", embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end)
