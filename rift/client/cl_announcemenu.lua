RMenu.Add("riftannouncements","main",RageUI.CreateMenu("","~b~Announcement Menu",tRIFT.getRageUIMenuWidth(),tRIFT.getRageUIMenuHeight(),"banners","announcement"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('riftannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("RIFT:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("RIFT:serviceAnnounceCl",function(h, i)
    tRIFT.announce(h, i)
end)

RegisterNetEvent("RIFT:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("riftannouncements", "main"), not RageUI.Visible(RMenu:Get("riftannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('RIFT:getAnnounceMenu')
end)
