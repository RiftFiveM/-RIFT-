RegisterNetEvent("RIFT:mutePlayers",function(a)
    for b, c in pairs(a) do
        exports["pma-voice"]:mutePlayer(b, true)
    end
end)
RegisterNetEvent("RIFT:mutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, true)
end)
RegisterNetEvent("RIFT:unmutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, false)
end)
