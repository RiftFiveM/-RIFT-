local currentPlayerInfo = {}

RegisterNetEvent("RIFT:receiveCurrentPlayerInfo")
AddEventHandler("RIFT:receiveCurrentPlayerInfo",function(playerInfo)
    currentPlayerInfo = playerInfo
end)

function tRIFT.getCurrentPlayerInfo(z)
    for k,v in pairs(currentPlayerInfo) do
        if k == z then
            return v
        end
    end
end