RegisterNetEvent("Polar:mutePlayers",function(a)
    for b, c in pairs(a) do
        exports["pma-voice"]:mutePlayer(b, true)
    end
end)
RegisterNetEvent("Polar:mutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, true)
end)
RegisterNetEvent("Polar:unmutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, false)
end)
