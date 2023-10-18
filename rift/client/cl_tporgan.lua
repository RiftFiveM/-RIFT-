RegisterCommand("tporgan", function()
    local s = GetEntityCoords(PlayerPedId())
    if isInGreenzone then
        tRIFT.notify("You will be Teleported Shortly.")
        Wait(5000)
    SetEntityCoords(PlayerPedId(), 233.6941986084,-1387.4366455078,30.547966003418)
    tRIFT.notify("~g~You have been Teleported to Organ Heist.")
    else
        tRIFT.notify("~r~You have to be in a greenzone to do this.")
    end
end)