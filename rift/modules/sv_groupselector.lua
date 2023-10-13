local cfg=module("cfg/cfg_groupselector")

function RIFT.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = RIFT.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if RIFT.hasPermission(RIFT.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if RIFT.hasGroup(user_id, b[1]) then
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
    TriggerClientEvent("RIFT:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("RIFT:getJobSelectors")
AddEventHandler("RIFT:getJobSelectors",function()
    local source = source
    RIFT.getJobSelectors(source)
end)

function RIFT.removeAllJobs(user_id)
    local source = RIFT.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and RIFT.hasGroup(user_id, v[1]) then
                RIFT.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and RIFT.hasGroup(user_id, v[1]..' Clocked') then
                RIFT.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                RIFTclient.setArmour(source, {0})
                TriggerEvent('RIFT:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    RIFTclient.setPolice(source, {false})
    TriggerClientEvent('RIFTUI5:globalOnPoliceDuty', source, false)
    RIFTclient.setNHS(source, {false})
    TriggerClientEvent('RIFTUI5:globalOnNHSDuty', source, false)
    RIFTclient.setHMP(source, {false})
    TriggerClientEvent('RIFTUI5:globalOnPrisonDuty', source, false)
    RIFTclient.setLFB(source, {false})
    TriggerClientEvent('RIFT:disableFactionBlips', source)
    TriggerClientEvent('RIFT:radiosClearAll', source)
    -- toggle all main jobs to false
    TriggerClientEvent('RIFT:toggleTacoJob', source, false)
end

RegisterNetEvent("RIFT:jobSelector")
AddEventHandler("RIFT:jobSelector",function(a,b)
    local source = source
    local user_id = RIFT.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("RIFT:acBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        RIFT.removeAllJobs(user_id)
        RIFTclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if RIFT.hasGroup(user_id, b) then
                RIFT.removeAllJobs(user_id)
                RIFT.addUserGroup(user_id,b..' Clocked')
                RIFTclient.setPolice(source, {true})
                TriggerClientEvent('RIFTUI5:globalOnPoliceDuty', source, true)
                RIFTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tRIFT.sendWebhook('pd-clock', 'RIFT Police Clock On Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RIFTclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if RIFT.hasGroup(user_id, b) then
                RIFT.removeAllJobs(user_id)
                RIFT.addUserGroup(user_id,b..' Clocked')
                RIFTclient.setNHS(source, {true})
                TriggerClientEvent('RIFTUI5:globalOnNHSDuty', source, true)
                RIFTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tRIFT.sendWebhook('nhs-clock', 'RIFT NHS Clock On Logs',"> Medic Name: **"..GetPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RIFTclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if RIFT.hasGroup(user_id, b) then
                RIFT.removeAllJobs(user_id)
                RIFT.addUserGroup(user_id,b..' Clocked')
                RIFTclient.setLFB(source, {true})
                RIFTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tRIFT.sendWebhook('lfb-clock', 'RIFT LFB Clock On Logs',"> Firefighter Name: **"..GetPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RIFTclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if RIFT.hasGroup(user_id, b) then
                RIFT.removeAllJobs(user_id)
                RIFT.addUserGroup(user_id,b..' Clocked')
                RIFTclient.setHMP(source, {true})
                TriggerClientEvent('RIFTUI5:globalOnPrisonDuty', source, true)
                RIFTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tRIFT.sendWebhook('hmp-clock', 'RIFT HMP Clock On Logs',"> Prison Officer Name: **"..GetPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                RIFTclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            RIFT.removeAllJobs(user_id)
            RIFT.addUserGroup(user_id,b)
            RIFTclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('RIFT:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('RIFT:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('RIFT:clockedOnCreateRadio', source)
        TriggerClientEvent('RIFT:radiosClearAll', source)
        TriggerClientEvent('RIFT:refreshGunStorePermissions', source)
        RIFT.updateCurrentPlayerInfo()
    end
end)