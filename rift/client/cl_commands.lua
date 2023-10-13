Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO','RIFT British RP - discord.gg/rift')
    AddTextEntry("PM_PANE_CFX","RIFT")
end)
RegisterCommand("discord",function()
    TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 },"^0Discord: discord.gg/rift","ooc")
    tRIFT.notify("~g~discord Copied to Clipboard.")
    tRIFT.CopyToClipBoard("https://discord.gg/RIFT")
end)
RegisterCommand("ts",function()
    TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 },"^0TS: ts.riftforums.net","ooc")
    tRIFT.notify("~g~ts Copied to Clipboard.")
    tRIFT.CopyToClipBoard("ts.riftforums.net")
end)
RegisterCommand("website",function()
    TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 },"^0Forums: www.riftforums.net","ooc")
    tRIFT.notify("~g~Website Copied to Clipboard.")
    tRIFT.CopyToClipBoard("www.riftforums.net")
end)

RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        if tRIFT.clientGetUserIdFromSource(tonumber(args[1])) ~= nil then
            if tRIFT.clientGetUserIdFromSource(tonumber(args[1])) ~= tRIFT.getUserId() then
                TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tRIFT.clientGetUserIdFromSource(tonumber(args[1])), "alert")
            else
                TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tRIFT.getUserId(), "alert")
            end
        else
            TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 }, "Invalid Temp ID", "alert")
        end
    else 
        TriggerEvent("chatMessage","^1[RIFT]^1  ",{ 128, 128, 128 }, "Please specify a user eg: /getid [tempid]", "alert")
    end
end)
