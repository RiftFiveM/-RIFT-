local countdown = 0

RegisterNetEvent("FR:CLOSE_DEATH_SCREEN", function()
    SendNUIMessage({
        app = "",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(false, false)
    countdown = 0
end)

RegisterNetEvent("FR:respawnKeyPressed", function()
    SendNUIMessage({
        page = "deathscreen",
        type = "RESPAWN_KEY_PRESSED",
    })
end)

RegisterNetEvent("FR:SHOW_DEATH_SCREEN", function(timer, killer, killerPermId, killedByWeapon, suicide)
    SendNUIMessage({
        page = "deathscreen",
        type = "SHOW_DEATH_SCREEN",
        info = {
            timer = timer,
            killer = killer,
            killerPermId = killerPermId,
            killedByWeapon = killedByWeapon,
            suicide = suicide,
        }
    })
    countdown = math.floor(timer)
end)

RegisterNetEvent("FR:DEATH_SCREEN_NHS_CALLED", function()
    SendNUIMessage({
        page = "deathscreen",
        type = "DEATH_SCREEN_NHS_CALLED",
    })
end)

Citizen.CreateThread(function()
    while true do
        if countdown > 0 then
            countdown = countdown - 1
            if countdown == 0 then
                TriggerEvent("FR:countdownEnded")
            end
        end
        Citizen.Wait(1000)
    end
end)