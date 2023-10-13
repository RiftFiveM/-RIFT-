local Tunnel = module("lib/Tunnel")
local Proxy = module("lib/Proxy")

Tunnel.bindInterface("RIFT", {}) -- tylon place your tunnel in here

local function GetPlayerData(playerID)
    local playerData = {
        [1] = { name = "Player1", blipColor = 1 },
        [2] = { name = "Player2", blipColor = 2 },
        [3] = { name = "Player3", blipColor = 3 }
    }

    return playerData[playerID]
end

RegisterServerEvent("RIFT:EnableGangBlips")
AddEventHandler("RIFT:EnableGangBlips", function()
    local source = source
    local user_id = RIFT.getUserId(source)

    local playerGang, gangPermission = GetPlayerGangAndPermission(user_id)

    if playerGang then
        local gangMembers = GetGangMembers(playerGang, gangPermission)

        local filteredMembers = {}
        for _, memberID in ipairs(gangMembers) do
            if memberID ~= user_id and RIFT.isPlayerOnline(memberID) then
                table.insert(filteredMembers, memberID)
            end
        end

        local blipsData = GetBlipsData(filteredMembers)
        TriggerClientEvent("RIFT:ReceiveGangBlipsData", source, blipsData)
    end
end)

function GetPlayerGangAndPermission(user_id)
    local gangMembers = {}
    local gangPermission = 0

    exports['ghmattimysql']:execute('SELECT * FROM rift_gangs', function(gotGangs)
        for _, gangData in pairs(gotGangs) do
            local gangMembersData = json.decode(gangData.gangmembers)
            local userGangData = gangMembersData[tostring(user_id)]

            if userGangData then
                gangMembers = gangMembersData
                gangPermission = userGangData.gangPermission
                break
            end
        end

        print("Got player gang and permission:", gangMembers, gangPermission) --- added print so it intiliazes the player gang and permission
    end)

    return gangMembers, gangPermission
end

function GetGangMembers(playerGang, gangPermission)
    local gangMembers = {}

    for memberID, memberData in pairs(playerGang) do
        if memberData.gangPermission <= gangPermission then
            table.insert(gangMembers, tonumber(memberID))
        end
    end

    return gangMembers
end

function GetBlipsData(memberIDs)
    local blipsData = {}

    for _, memberID in ipairs(memberIDs) do
        local playerData = GetPlayerData(memberID)
        if playerData then
            local blipData = {
                playerID = memberID,
                playerName = playerData.name,
                blipColor = playerData.blipColor
            }
            table.insert(blipsData, blipData)
        end
    end

    return blipsData
end
