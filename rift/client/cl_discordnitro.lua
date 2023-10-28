local a = GetGameTimer()
RegisterNetEvent("Polar:spawnNitroBMX",function()
    if not tPolar.isInComa() and not tPolar.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tPolar.notify("~g~Crafting a BMX")
            local b = tPolar.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tPolar.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tPolar.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tPolar.notify("~r~Cannot craft a BMX right now.")
    end
end)
RegisterNetEvent("Polar:spawnMoped",function()
    if not tPolar.isInComa() and not tPolar.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tPolar.notify("~g~Crafting a Moped")
            local b = tPolar.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tPolar.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tPolar.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tPolar.notify("~r~Cannot craft a Moped right now.")
    end
end)
