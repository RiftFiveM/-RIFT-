Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO','Polar British RP - discord.gg/f3BWQpG3bR')
    AddTextEntry("PM_PANE_CFX","Polar")
end)
RegisterCommand("discord",function()
    TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 },"^0Discord: discord.gg/f3BWQpG3bR","ooc")
    tPolar.notify("~g~discord Copied to Clipboard.")
    tPolar.CopyToClipBoard("https://discord.gg/f3BWQpG3bR")
end)
RegisterCommand("ts",function()
    TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 },"^0TS: ts.Polarforums.net","ooc")
    tPolar.notify("~g~ts Copied to Clipboard.")
    tPolar.CopyToClipBoard("ts.Polarforums.net")
end)
RegisterCommand("website",function()
    TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 },"^0Forums: www.Polarforums.net","ooc")
    tPolar.notify("~g~Website Copied to Clipboard.")
    tPolar.CopyToClipBoard("www.Polarforums.net")
end)

RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        if tPolar.clientGetUserIdFromSource(tonumber(args[1])) ~= nil then
            if tPolar.clientGetUserIdFromSource(tonumber(args[1])) ~= tPolar.getUserId() then
                TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tPolar.clientGetUserIdFromSource(tonumber(args[1])), "alert")
            else
                TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tPolar.getUserId(), "alert")
            end
        else
            TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 }, "Invalid Temp ID", "alert")
        end
    else 
        TriggerEvent("chatMessage","^1[Polar]^1  ",{ 128, 128, 128 }, "Please specify a user eg: /getid [tempid]", "alert")
    end
end)
