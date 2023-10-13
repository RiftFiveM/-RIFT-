local coinflipTables = {
    [1] = false,
    [2] = false,
    [5] = false,
    [6] = false,
}

local linkedTables = {
    [1] = 2,
    [2] = 1,
    [5] = 6,
    [6] = 5,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = RIFT.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('RIFT:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
            coinflipGameData[k] = nil
        end
    end
end)

RegisterNetEvent("RIFT:requestCoinflipTableData")
AddEventHandler("RIFT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("RIFT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("RIFT:requestSitAtCoinflipTable")
AddEventHandler("RIFT:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        local currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("RIFT:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("RIFT:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("RIFT:leaveCoinflipTable")
AddEventHandler("RIFT:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("RIFT:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("RIFT:proposeCoinflip")
AddEventHandler("RIFT:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = RIFT.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            TriggerClientEvent('RIFT:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('RIFT:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('RIFT:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            RIFTclient.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            RIFTclient.notify(source,{"~r~Not enough chips!"})
                        end
                    end)
                else
                    RIFTclient.notify(source,{'~r~Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       RIFTclient.notify(source,{"~r~Error betting!"})
    end
end)

RegisterNetEvent("RIFT:requestCoinflipTableData")
AddEventHandler("RIFT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("RIFT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("RIFT:cancelCoinflip")
AddEventHandler("RIFT:cancelCoinflip", function()   
    local source = source
    local user_id = RIFT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("RIFT:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("RIFT:acceptCoinflip")
AddEventHandler("RIFT:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = RIFT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('RIFT:chipsUpdated', source)
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('RIFT:chipsUpdated', RIFT.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = GetPlayerName(source), loser = GetPlayerName(RIFT.getUserSource(v.user_id))}
                        TriggerClientEvent('RIFT:coinflipOutcome', source, true, game)
                        TriggerClientEvent('RIFT:coinflipOutcome', RIFT.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('RIFT:chipsUpdated', source)
                        tRIFT.sendWebhook('coinflip-bet',"RIFT Coinflip Logs", "> Winner Name: **"..GetPlayerName(source).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..GetPlayerName(RIFT.getUserSource(v.user_id)).."**\n> Loser TempID: **"..RIFT.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = GetPlayerName(RIFT.getUserSource(v.user_id)), loser = GetPlayerName(source)}
                        TriggerClientEvent('RIFT:coinflipOutcome', source, false, game)
                        TriggerClientEvent('RIFT:coinflipOutcome', RIFT.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('RIFT:chipsUpdated', RIFT.getUserSource(v.user_id))
                        tRIFT.sendWebhook('coinflip-bet',"RIFT Coinflip Logs", "> Winner Name: **"..GetPlayerName(RIFT.getUserSource(v.user_id)).."**\n> Winner TempID: **"..RIFT.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..GetPlayerName(source).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    RIFTclient.notify(source,{"~r~Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)