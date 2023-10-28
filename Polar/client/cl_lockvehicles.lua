local function a()
    local b = tPolar.getPlayerPed()
    if GetEntityHealth(b) > 102 then
        local c, d = tPolar.getNearestOwnedVehicle(8)
        if d ~= nil then
            if c then
                tPolar.vc_toggleLock(d)
                tPolar.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
                Citizen.Wait(1000)
            else
                Citizen.Wait(1000)
            end
        else
            tPolar.notify("~r~No owned vehicle found nearby to lock/unlock")
        end
    else
        tPolar.notify("~r~You may not lock/unlock your vehicle whilst dead.")
    end
end
Citizen.CreateThread(function()
    while true do
        if IsDisabledControlPressed(0, 82) then
            a()
        end
        Wait(0)
    end
end)
AddEventHandler("Polar:lockNearestVehicle",function()
    a()
end)
