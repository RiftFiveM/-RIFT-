RMenu.Add("Polarannouncements","main",RageUI.CreateMenu("","~b~Announcement Menu",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners","announcement"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('Polarannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("Polar:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("Polar:serviceAnnounceCl",function(h, i)
    tPolar.announce(h, i)
end)

RegisterNetEvent("Polar:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("Polarannouncements", "main"), not RageUI.Visible(RMenu:Get("Polarannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('Polar:getAnnounceMenu')
end)
