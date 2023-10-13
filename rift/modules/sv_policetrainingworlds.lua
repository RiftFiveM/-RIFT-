local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('RIFT:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('RIFT:trainingWorldOpen', source, RIFT.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("RIFT:trainingWorldCreate")
AddEventHandler("RIFT:trainingWorldCreate", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    RIFT.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        RIFTclient.notify(source, {"~r~This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        RIFTclient.notify(source, {"~r~You already have a world, please delete it first."})
                        return
                    end
                end
            end
            RIFT.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = GetPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                tRIFT.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('RIFT:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                RIFTclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            RIFTclient.notify(source, {"~r~Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("RIFT:trainingWorldRemove")
AddEventHandler("RIFT:trainingWorldRemove", function(world)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('RIFT:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = RIFT.getUserSource(v)
                if memberSource ~= nil then
                    tRIFT.setBucket(memberSource, 0)
                    RIFTclient.notify(memberSource, {"~b~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("RIFT:trainingWorldJoin")
AddEventHandler("RIFT:trainingWorldJoin", function(world)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            RIFTclient.notify(source, {"~r~Invalid Password."})
            return
        else
            tRIFT.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            RIFTclient.notify(source, {"~b~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("RIFT:trainingWorldLeave")
AddEventHandler("RIFT:trainingWorldLeave", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    tRIFT.setBucket(source, 0)
    RIFTclient.notify(source, {"~b~You have left the training world."})
end)

