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
    local user_id = Polar.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('Polar:chipsUpdated', source)
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

RegisterNetEvent("Polar:requestCoinflipTableData")
AddEventHandler("Polar:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("Polar:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("Polar:requestSitAtCoinflipTable")
AddEventHandler("Polar:requestSitAtCoinflipTable", function(chairId)
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
        TriggerClientEvent("Polar:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("Polar:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("Polar:leaveCoinflipTable")
AddEventHandler("Polar:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("Polar:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("Polar:proposeCoinflip")
AddEventHandler("Polar:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = Polar.getUserId(source)
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
                            TriggerClientEvent('Polar:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('Polar:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('Polar:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            Polarclient.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            Polarclient.notify(source,{"~r~Not enough chips!"})
                        end
                    end)
                else
                    Polarclient.notify(source,{'~r~Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       Polarclient.notify(source,{"~r~Error betting!"})
    end
end)

RegisterNetEvent("Polar:requestCoinflipTableData")
AddEventHandler("Polar:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("Polar:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("Polar:cancelCoinflip")
AddEventHandler("Polar:cancelCoinflip", function()   
    local source = source
    local user_id = Polar.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("Polar:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("Polar:acceptCoinflip")
AddEventHandler("Polar:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = Polar.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('Polar:chipsUpdated', source)
                    TriggerClientEvent("Polar:takeClientVideoAndUpload", target, tPolar.getWebhook('coinflip-bet'))
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('Polar:chipsUpdated', Polar.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = GetPlayerName(source), loser = GetPlayerName(Polar.getUserSource(v.user_id))}
                        TriggerClientEvent('Polar:coinflipOutcome', source, true, game)
                        TriggerClientEvent('Polar:coinflipOutcome', Polar.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('Polar:chipsUpdated', source)
                        tPolar.sendWebhook('coinflip-bet',"Polar Coinflip Logs", "> Winner Name: **"..GetPlayerName(source).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..GetPlayerName(Polar.getUserSource(v.user_id)).."**\n> Loser TempID: **"..Polar.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = GetPlayerName(Polar.getUserSource(v.user_id)), loser = GetPlayerName(source)}
                        TriggerClientEvent('Polar:coinflipOutcome', source, false, game)
                        TriggerClientEvent('Polar:coinflipOutcome', Polar.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('Polar:chipsUpdated', Polar.getUserSource(v.user_id))
                        tPolar.sendWebhook('coinflip-bet',"Polar Coinflip Logs", "> Winner Name: **"..GetPlayerName(Polar.getUserSource(v.user_id)).."**\n> Winner TempID: **"..Polar.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..GetPlayerName(source).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    Polarclient.notify(source,{"~r~Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)