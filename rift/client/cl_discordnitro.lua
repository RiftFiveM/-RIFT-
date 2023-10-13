local a = GetGameTimer()
RegisterNetEvent("RIFT:spawnNitroBMX",function()
    if not tRIFT.isInComa() and not tRIFT.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tRIFT.notify("~g~Crafting a BMX")
            local b = tRIFT.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tRIFT.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tRIFT.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tRIFT.notify("~r~Cannot craft a BMX right now.")
    end
end)
RegisterNetEvent("RIFT:spawnMoped",function()
    if not tRIFT.isInComa() and not tRIFT.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tRIFT.notify("~g~Crafting a Moped")
            local b = tRIFT.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tRIFT.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tRIFT.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tRIFT.notify("~r~Cannot craft a Moped right now.")
    end
end)
