RegisterServerEvent("RIFT:adminTicketFeedback")
AddEventHandler("RIFT:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    print(AdminID, FeedBackType, Message)
    local source = source
    local AdminSource = RIFT.getUserSource(AdminID)
    local PlayerID = RIFT.getUserId(source)

    if AdminID == nil then
        print("Admin ID is nil")
        return
    end

    if FeedBackType == "good" then
        RIFT.giveBankMoney(AdminID, 25000)
        RIFTclient.notify(source, {"~g~You have given a Good feedback."})
        RIFTclient.notify(AdminSource, {"~g~You have received £25,000 for a good feedback."})
    elseif FeedBackType == "neutral" then
        RIFT.giveBankMoney(AdminID, 10000)
        RIFTclient.notify(source, {"~y~You have given a Neutral feedback."})
        RIFTclient.notify(AdminSource, {"~g~You have received £10,000 for a good feedback."})
    elseif FeedBackType == "bad" then
        RIFT.giveBankMoney(AdminID, 5000)
        RIFTclient.notify(source, {"~r~You have given a Bad feedback."})
        RIFTclient.notify(AdminSource, {"~g~You have received £5,000 for a good feedback."})
    end
    tRIFT.sendWebhook('feedback', 'RIFT Feedback Logs', "> Player Name: **" .. PlayerName .. "**\n> Player PermID: **" .. PlayerID .. "**\n> **Feedback Type:** " .. FeedBackType .. "\n> **Admin Perm ID: **" .. AdminID)
end)