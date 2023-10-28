RegisterServerEvent("Polar:adminTicketFeedback")
AddEventHandler("Polar:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    print(AdminID, FeedBackType, Message)
    local source = source
    local AdminSource = Polar.getUserSource(AdminID)
    local PlayerID = Polar.getUserId(source)

    if AdminID == nil then
        print("Admin ID is nil")
        return
    end

    if FeedBackType == "good" then
        Polar.giveBankMoney(AdminID, 25000)
        Polarclient.notify(source, {"~g~You have given a Good feedback."})
        Polarclient.notify(AdminSource, {"~g~You have received £25,000 for a good feedback."})
    elseif FeedBackType == "neutral" then
        Polar.giveBankMoney(AdminID, 10000)
        Polarclient.notify(source, {"~y~You have given a Neutral feedback."})
        Polarclient.notify(AdminSource, {"~g~You have received £10,000 for a good feedback."})
    elseif FeedBackType == "bad" then
        Polar.giveBankMoney(AdminID, 5000)
        Polarclient.notify(source, {"~r~You have given a Bad feedback."})
        Polarclient.notify(AdminSource, {"~g~You have received £5,000 for a good feedback."})
    end
    tPolar.sendWebhook('feedback', 'Polar Feedback Logs', "> Player Name: **" .. PlayerName .. "**\n> Player PermID: **" .. PlayerID .. "**\n> **Feedback Type:** " .. FeedBackType .. "\n> **Admin Perm ID: **" .. AdminID)
end)