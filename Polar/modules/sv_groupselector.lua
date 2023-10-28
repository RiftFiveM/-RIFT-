local cfg=module("cfg/cfg_groupselector")

function Polar.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = Polar.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if Polar.hasPermission(Polar.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if Polar.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("Polar:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("Polar:getJobSelectors")
AddEventHandler("Polar:getJobSelectors",function()
    local source = source
    Polar.getJobSelectors(source)
end)

function Polar.removeAllJobs(user_id)
    local source = Polar.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and Polar.hasGroup(user_id, v[1]) then
                Polar.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and Polar.hasGroup(user_id, v[1]..' Clocked') then
                Polar.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                Polarclient.setArmour(source, {0})
                TriggerEvent('Polar:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    Polarclient.setPolice(source, {false})
    TriggerClientEvent('PolarUI5:globalOnPoliceDuty', source, false)
    Polarclient.setNHS(source, {false})
    TriggerClientEvent('PolarUI5:globalOnNHSDuty', source, false)
    Polarclient.setHMP(source, {false})
    TriggerClientEvent('PolarUI5:globalOnPrisonDuty', source, false)
    Polarclient.setLFB(source, {false})
    TriggerClientEvent('Polar:disableFactionBlips', source)
    TriggerClientEvent('Polar:radiosClearAll', source)
    -- toggle all main jobs to false
    TriggerClientEvent('Polar:toggleTacoJob', source, false)
end

RegisterNetEvent("Polar:jobSelector")
AddEventHandler("Polar:jobSelector",function(a,b)
    local source = source
    local user_id = Polar.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        Polar.removeAllJobs(user_id)
        Polarclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if Polar.hasGroup(user_id, b) then
                Polar.removeAllJobs(user_id)
                Polar.addUserGroup(user_id,b..' Clocked')
                Polarclient.setPolice(source, {true})
                TriggerClientEvent('PolarUI5:globalOnPoliceDuty', source, true)
                Polarclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tPolar.sendWebhook('pd-clock', 'Polar Police Clock On Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                Polarclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if Polar.hasGroup(user_id, b) then
                Polar.removeAllJobs(user_id)
                Polar.addUserGroup(user_id,b..' Clocked')
                Polarclient.setNHS(source, {true})
                TriggerClientEvent('PolarUI5:globalOnNHSDuty', source, true)
                Polarclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tPolar.sendWebhook('nhs-clock', 'Polar NHS Clock On Logs',"> Medic Name: **"..GetPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                Polarclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if Polar.hasGroup(user_id, b) then
                Polar.removeAllJobs(user_id)
                Polar.addUserGroup(user_id,b..' Clocked')
                Polarclient.setLFB(source, {true})
                Polarclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tPolar.sendWebhook('lfb-clock', 'Polar LFB Clock On Logs',"> Firefighter Name: **"..GetPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                Polarclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if Polar.hasGroup(user_id, b) then
                Polar.removeAllJobs(user_id)
                Polar.addUserGroup(user_id,b..' Clocked')
                Polarclient.setHMP(source, {true})
                TriggerClientEvent('PolarUI5:globalOnPrisonDuty', source, true)
                Polarclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tPolar.sendWebhook('hmp-clock', 'Polar HMP Clock On Logs',"> Prison Officer Name: **"..GetPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                Polarclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            Polar.removeAllJobs(user_id)
            Polar.addUserGroup(user_id,b)
            Polarclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('Polar:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('Polar:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('Polar:clockedOnCreateRadio', source)
        TriggerClientEvent('Polar:radiosClearAll', source)
        TriggerClientEvent('Polar:refreshGunStorePermissions', source)
        Polar.updateCurrentPlayerInfo()
    end
end)