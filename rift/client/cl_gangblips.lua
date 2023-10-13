local blipon = false
Blips = {}

RegisterCommand("gangblips", function()
    if not blipon then
        blipon = true
        TriggerServerEvent("RIFT:EnableGangBlips")
        notify("Gang blips Enabled")
        Citizen.CreateThread(function()
            while blipon do
                Citizen.Wait(5000)
                TriggerServerEvent("RIFT:GetGangBlipsData")
            end
        end)
    else
        DeleteAllBlips()
        blipon = false
    end
end)

RegisterNetEvent("RIFT:ReceiveGangBlipsData")
AddEventHandler("RIFT:ReceiveGangBlipsData", function(gangBlipsData)
    DeleteAllBlips()

    local localPlayerServerID = GetPlayerServerId(PlayerId())

    for _, blipData in ipairs(gangBlipsData) do
        local playerID = tonumber(blipData.playerID)

        if localPlayerServerID ~= playerID and GetPlayerPed(GetPlayerFromServerId(playerID)) ~= nil then
            local clientID = GetPlayerFromServerId(playerID)
            local blipID = AddBlipForEntity(GetPlayerPed(clientID))

            SetBlipSprite(blipID, 1)
            SetBlipColour(blipID, blipData.blipColor)
            SetBlipCategory(blipID, 2)
            SetBlipAsShortRange(blipID, false)
            Citizen.InvokeNative(0x5FBCA48327B914DF, blipID, true)
            SetBlipNameToPlayerName(blipID, clientID)
            
            Blips[#Blips + 1] = blipID
        end
    end
end)

function DeleteAllBlips()
    for _, blipID in ipairs(Blips) do
        RemoveBlip(blipID)
    end

    Blips = {}
end
