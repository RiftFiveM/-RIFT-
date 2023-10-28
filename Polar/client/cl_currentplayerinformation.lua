local currentPlayerInfo = {}

RegisterNetEvent("Polar:receiveCurrentPlayerInfo")
AddEventHandler("Polar:receiveCurrentPlayerInfo",function(playerInfo)
    currentPlayerInfo = playerInfo
end)

function tPolar.getCurrentPlayerInfo(z)
    for k,v in pairs(currentPlayerInfo) do
        if k == z then
            return v
        end
    end
end