local jackpotChairs = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false,
    [10] = false,
    [11] = false,
    [12] = false,
    [13] = false,
    [14] = false,
    [15] = false,
}
local currentJackpotTotal = 0
local currentJackpotBets = {}
local numJackpotBets = 0
local currentJackpotInProgress = false

RegisterNetEvent("RIFT:requestJackpotChairData")
AddEventHandler("RIFT:requestJackpotChairData", function()   
    local source = source
    TriggerClientEvent('RIFT:sendJackpotChairData', source, jackpotChairs)
end)

RegisterNetEvent("RIFT:requestSitAtJackpot")
AddEventHandler("RIFT:requestSitAtJackpot", function(chair)   
    local source = source
    local user_id = RIFT.getUserId(source)
    if jackpotChairs[chair] == false then
        jackpotChairs[chair] = user_id
        TriggerClientEvent("RIFT:sitAtJackpotChair", source, chair)
    end
end)

RegisterNetEvent("RIFT:leaveJackpotChair")
AddEventHandler("RIFT:leaveJackpotChair", function()   
    local source = source
    local user_id = RIFT.getUserId(source)
    for k,v in pairs(jackpotChairs) do
        if v == user_id then
            jackpotChairs[k] = false
        end
    end
end)

RegisterNetEvent("RIFT:setJackpotBet")
AddEventHandler("RIFT:setJackpotBet", function(betAmount)   
    local source = source
    local user_id = RIFT.getUserId(source)
    if not currentJackpotInProgress then
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            chips = rows[1].chips
            if chips >= betAmount then
                MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = betAmount})
                currentJackpotBets[user_id] = {user_id = user_id, colour = {r = math.random(0,255), g = math.random(0,255), b = math.random(0,255), a = 255}, betAmount = betAmount, tickets_start = currentJackpotTotal, tickets_end = currentJackpotTotal + betAmount}
                currentJackpotTotal = currentJackpotTotal + betAmount
                numJackpotBets = numJackpotBets + 1
                TriggerClientEvent("RIFT:updateTotalPot", -1, currentJackpotTotal)
                TriggerClientEvent('RIFT:successJackpotBet', source)
                TriggerClientEvent('RIFT:newJackpotBet', -1, currentJackpotBets[user_id])
                TriggerClientEvent('RIFT:chipsUpdated', source)
                for k,v in pairs(currentJackpotBets) do
                    if RIFT.getUserSource(k) ~= nil then
                        TriggerClientEvent("RIFT:updatePlayerWinChance", RIFT.getUserSource(k), (v.betAmount/currentJackpotTotal)*100)
                    end
                end
            else 
                RIFTclient.notify(source,{"~r~Not enough chips!"})
            end
        end)
    else
        RIFTclient.notify(source,{"~r~Please wait for the next Jackpot."})
    end
end)

local winner = nil
local winnerName = nil
local winnerBetPercentage = nil
local winnerTicketsBought = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if numJackpotBets >= 2 and not currentJackpotInProgress then
            TriggerClientEvent('RIFT:beginJackpot', -1)
            currentJackpotInProgress = true
            Wait(60000)
            local winningTicket = math.random(1, currentJackpotTotal)
            for k,v in pairs(currentJackpotBets) do
                if winningTicket >= v.tickets_start and winningTicket <= v.tickets_end then
                    winner = v.user_id
                    winnerName = GetPlayerName(RIFT.getUserSource(winner))
                    winnerBetPercentage = (v.betAmount/currentJackpotTotal)*100
                    winnerTicketsBought = v.betAmount
                end
            end
            TriggerClientEvent('RIFT:rollJackpot', -1, winner, winnerTicketsBought, winnerName, winnerBetPercentage, winner)
        end
    end
end)

RegisterNetEvent("RIFT:waitingOnWinConfirm")
AddEventHandler("RIFT:waitingOnWinConfirm", function()   
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id == winner then
        MySQL.execute("casinochips/add_chips", {user_id = winner, amount = currentJackpotTotal})
        TriggerClientEvent('RIFT:chipsUpdated', source)
        Wait(10000)
        TriggerClientEvent("RIFT:cleanupJackpot", -1)
        currentJackpotTotal = 0
        currentJackpotBets = {}
        winner = nil
        winnerName = nil
        winnerBetPercentage = nil
        winnerTicketsBought = nil
        currentJackpotInProgress = false
    end
end)