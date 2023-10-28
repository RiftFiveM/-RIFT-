local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('Polar:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('Polar:trainingWorldOpen', source, Polar.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("Polar:trainingWorldCreate")
AddEventHandler("Polar:trainingWorldCreate", function()
    local source = source
    local user_id = Polar.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    Polar.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        Polarclient.notify(source, {"~r~This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        Polarclient.notify(source, {"~r~You already have a world, please delete it first."})
                        return
                    end
                end
            end
            Polar.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = GetPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                tPolar.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('Polar:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                Polarclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            Polarclient.notify(source, {"~r~Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("Polar:trainingWorldRemove")
AddEventHandler("Polar:trainingWorldRemove", function(world)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('Polar:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = Polar.getUserSource(v)
                if memberSource ~= nil then
                    tPolar.setBucket(memberSource, 0)
                    Polarclient.notify(memberSource, {"~b~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("Polar:trainingWorldJoin")
AddEventHandler("Polar:trainingWorldJoin", function(world)
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            Polarclient.notify(source, {"~r~Invalid Password."})
            return
        else
            tPolar.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            Polarclient.notify(source, {"~b~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("Polar:trainingWorldLeave")
AddEventHandler("Polar:trainingWorldLeave", function()
    local source = source
    local user_id = Polar.getUserId(source)
    tPolar.setBucket(source, 0)
    Polarclient.notify(source, {"~b~You have left the training world."})
end)

