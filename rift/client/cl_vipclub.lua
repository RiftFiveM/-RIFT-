RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","~w~RIFT Club",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~RIFT Club",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~RIFT Club Manage",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~RIFT Club Perks",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~w~Manage Death Sounds",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~w~Vehicle Extras",tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(),"vipclub", "vipclub"))
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}

function tRIFT.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tRIFT.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("riftclub",function()
    TriggerServerEvent('RIFT:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
end)

local c = {
    ["RIFT"] = {checked = true, soundId = "playDead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}
local d = false
local e = false
local f = false
local g = false
local h = {"Red", "Blue", "Green", "Pink", "Yellow", "Orange", "Purple"}
local i = tonumber(GetResourceKvpString("rift_damageindicatorcolour")) or 1
local v = {"Steam", "Discord", "None"}
local b = tonumber(GetResourceKvpString("rift_pfp_type")) or 1
Citizen.CreateThread(function()
    local l = GetResourceKvpString("rift_codhitmarkersounds") or "false"
    if l == "false" then
        d = false
        TriggerEvent("RIFT:codHMSoundsOff")
    else
        d = true
        TriggerEvent("RIFT:codHMSoundsOn")
    end
    local m = GetResourceKvpString("rift_killlistsetting") or "false"
    if m == "false" then
        e = false
    else
        e = true
    end
    local n = GetResourceKvpString("rift_oldkillfeed") or "false"
    if n == "false" then
        f = false
    else
        f = true
    end
    local o = GetResourceKvpString("rift_damageindicator") or "false"
    if o == "false" then
        g = false
    else
        g = true
    end
    Wait(5000)
    tRIFT.updatePFPType(v[b])
end)

AddEventHandler("RIFT:onClientSpawn",function(f, g)
    if g then
        TriggerServerEvent('RIFT:getPlayerSubscription')
        Wait(5000)
        local u=tRIFT.getDeathSound()
        local j="playDead"
        for k,l in pairs(c)do 
            if l.soundId==u then 
                j=k 
            end 
        end
        for k,m in pairs(c)do 
            if j~=k then 
                m.checked=false 
            else 
                m.checked=true 
            end 
        end 
    end
end)


function tRIFT.setDeathSound(u)
    if tRIFT.isPlusClub() or tRIFT.isPlatClub() then 
        SetResourceKvp("rift_deathsound",u)
    else 
        tRIFT.notify("~r~Cannot change deathsound, not a valid RIFT Plus or Platinum subscriber.")
    end 
end
function tRIFT.getDeathSound()
    if tRIFT.isPlusClub() or tRIFT.isPlatClub() then 
        local k=GetResourceKvpString("rift_deathsound")
        if type(k) == "string" and k~="" then 
            return k 
        else 
            return "playDead"
        end 
    else 
        return "playDead"
    end 
end
function tRIFT.setUIProfilePictureType(t)
    SetResourceKvp("rift_pfp_type", tostring(t))
end
function tRIFT.getDmgIndcator()
    return g, i
end
local function m(h)
    SendNUIMessage({transactionType = h})
end

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tRIFT.isPlusClub() or tRIFT.isPlatClub() then
                RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","managesubscription"))
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            else
                RageUI.ButtonWithStyle("Purchase Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                    if q then
                        tRIFT.OpenUrl("https://store.riftstudios.uk/category/subscriptions")
                    end
                end)
            end
            if tRIFT.isDev() or tRIFT.getStaffLevel() >= 10 then
                RageUI.ButtonWithStyle("Manage User's Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageusersubscription"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'managesubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            colourCode = getColourCode(a.hoursOfPlus)
            RageUI.Separator("Days remaining of Plus Subscription: "..colourCode..math.floor(a.hoursOfPlus/24*100)/100 .." days.")
            colourCode = getColourCode(a.hoursOfPlatinum)
            RageUI.Separator("Days remaining of Platinum Subscription: "..colourCode..math.floor(a.hoursOfPlatinum/24*100)/100 .." days.")
            RageUI.Separator()
            RageUI.ButtonWithStyle("Sell Plus Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel = "→→→"},true,function(o, p, q)
                if q then
                    if isInGreenzone then
                        TriggerServerEvent("RIFT:beginSellSubscriptionToPlayer", "Plus")
                    else
                        notify("~r~You must be in a greenzone to sell.")
                    end
                end
            end)
            RageUI.ButtonWithStyle("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel = "→→→"},true,function(o, p, q)
                if q then
                    if isInGreenzone then
                        TriggerServerEvent("RIFT:beginSellSubscriptionToPlayer", "Platinum")
                    else
                        notify("~r~You must be in a greenzone to sell.")
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tRIFT.isDev() then
                if next(z) then
                    RageUI.Separator('Perm ID: '..z.userid)
                    colourCode = getColourCode(z.hoursOfPlus)
                    RageUI.Separator('Days of Plus Remaining: '..colourCode..math.floor(z.hoursOfPlus/24*100)/100)
                    colourCode = getColourCode(z.hoursOfPlatinum)
                    RageUI.Separator('Days of Platinum Remaining: '..colourCode..math.floor(z.hoursOfPlatinum/24*100)/100)
                    RageUI.ButtonWithStyle("Set Plus Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("RIFT:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.ButtonWithStyle("Set Platinum Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("RIFT:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.ButtonWithStyle("Select Perm ID", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = tRIFT.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tRIFT.notify('Invalid Perm ID')
                            return
                        end
                        TriggerServerEvent('RIFT:getPlayerSubscription', permID)
                    end
                end, RMenu:Get("vipclubmenu", 'manageusersubscription'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageperks')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle(
                        "Custom Death Sounds",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(o, p, q)
                        end,
                        RMenu:Get("vipclubmenu", "deathsounds")
                    )
                    RageUI.ButtonWithStyle(
                        "Vehicle Extras",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(o, p, q)
                        end,
                        RMenu:Get("vipclubmenu", "vehicleextras")
                    )
                    RageUI.ButtonWithStyle(
                        "Claim Weekly Kit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(o, p, q)
                            if q then
                                if not globalInPrison and not tRIFT.isHandcuffed() then
                                    TriggerServerEvent("RIFT:claimWeeklyKit")
                                else
                                    notify("~r~You can not redeem a kit whilst in custody.")
                                end
                            end
                        end
                    )
                    local function q()
                        TriggerEvent("RIFT:codHMSoundsOn")
                        d = true
                        tRIFT.setCODHitMarkerSetting(d)
                        tRIFT.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                    end
                    local function r()
                        TriggerEvent("RIFT:codHMSoundsOff")
                        d = false
                        tRIFT.setCODHitMarkerSetting(d)
                        tRIFT.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                    end
                    RageUI.Checkbox(
                        "Enable COD Hitmarkers",
                        "~g~This adds 'hit marker' sound and image when shooting another player.",
                        d,
                        {RightBadge = RageUI.CheckboxStyle.Car},
                        function(n, p, o, s)
                        end,
                        q,
                        r
                    )
                    RageUI.Checkbox(
                        "Enable Kill List",
                        "~g~This adds a kill list below your crosshair when you kill a player.",
                        e,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            e = true
                            tRIFT.setKillListSetting(e)
                            tRIFT.notify("~y~Kill List now set to " .. tostring(e))
                        end,
                        function()
                            e = false
                            tRIFT.setKillListSetting(e)
                            tRIFT.notify("~y~Kill List now set to " .. tostring(e))
                        end
                    )
                    RageUI.Checkbox(
                        "Enable Old Kilfeed",
                        "~g~This toggles the old killfeed that notifies above minimap.",
                        f,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            f = true
                            tRIFT.setOldKillfeed(f)
                            tRIFT.notify("~y~Old killfeed now set to " .. tostring(f))
                        end,
                        function()
                            f = false
                            tRIFT.setOldKillfeed(f)
                            tRIFT.notify("~y~Old killfeed now set to " .. tostring(f))
                        end
                    )
                    RageUI.Checkbox(
                        "Enable Damage Indicator",
                        "~g~This toggles the display of damage indicator.",
                        g,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            g = true
                            tRIFT.setDamageIndicator(g)
                            tRIFT.notify("~y~Damage Indicator now set to " .. tostring(g))
                        end,
                        function()
                            g = false
                            tRIFT.setDamageIndicator(g)
                            tRIFT.notify("~y~Damage Indicator now set to " .. tostring(g))
                        end
                    )
                    if g then
                        RageUI.List(
                            "Damage Colour",
                            h,
                            i,
                            "~g~Change the displayed colour of damage",
                            {},
                            true,
                            function(A, B, C, D)
                                i = D
                                tRIFT.setDamageIndicatorColour(i)
                            end,
                            function()
                            end,
                            nil
                        )
                    end
                    RageUI.List(
                        "PFP Type",
                        v,
                        b,
                        "~g~Change the type of PFP displayed",
                        {},
                        true,
                        function(A, B, C, D)
                            b = D
                            tRIFT.updatePFPType(v[b])
                            tRIFT.setUIProfilePictureType(b)
                        end)
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "deathsounds")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    for t, k in pairs(c) do
                        RageUI.Checkbox(
                            t,
                            "",
                            k.checked,
                            {},
                            function()
                            end,
                            function()
                                for u, l in pairs(c) do
                                    l.checked = false
                                end
                                k.checked = true
                                m(k.soundId)
                                tRIFT.setDeathSound(k.soundId)
                            end,
                            function()
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "vehicleextras")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    local w = tRIFT.getPlayerVehicle()
                    SetVehicleAutoRepairDisabled(w, true)
                    for x = 1, 99, 1 do
                        if DoesExtraExist(w, x) then
                            RageUI.Checkbox(
                                "Extra " .. x,
                                "",
                                IsVehicleExtraTurnedOn(w, x),
                                {},
                                function()
                                end,
                                function()
                                    SetVehicleExtra(w, x, 0)
                                end,
                                function()
                                    SetVehicleExtra(w, x, 1)
                                end
                            )
                        end
                    end
                end
            )
        end
    end
)

RegisterNetEvent("RIFT:setVIPClubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("RIFT:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("vipclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("RIFT:userSubscriptionUpdated",function()
    TriggerServerEvent('RIFT:getPlayerSubscription', permID)
end)

Citizen.CreateThread(function()
    while true do 
        if tRIFT.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),'GADGET_PARACHUTE',false) then 
                tRIFT.allowWeapon("GADGET_PARACHUTE")
                GiveWeaponToPed(PlayerPedId(),'GADGET_PARACHUTE')
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tRIFT.isPlusClub() or tRIFT.isPlatClub()then 
            SetVehicleDirtLevel(tRIFT.getPlayerVehicle(),0.0)
        end
        Wait(500)
    end 
end)

function getColourCode(a)
    if a>=10 then 
        colourCode="~g~"
    elseif a<10 and a>3 then 
        colourCode="~y~"
    else 
        colourCode="~r~"
    end
    return colourCode
end
local C = {}
local function D()
    for y, E in pairs(C) do
        DrawAdvancedTextNoOutline(
            0.6,
            0.5 + 0.025 * y,
            0.005,
            0.0028,
            0.45,
            "Killed " .. E.name,
            255,
            255,
            255,
            255,
            tRIFT.getFontId("Akrobat-Regular"),
            4,
            1
        )
    end
end
tRIFT.createThreadOnTick(D)
RegisterNetEvent(
    "RIFT:onPlayerKilledPed",
    function(F)
        if e and (tRIFT.isPlatClub() or tRIFT.isPlusClub()) and IsPedAPlayer(F) then
            local G = NetworkGetPlayerIndexFromPed(F)
            if G >= 0 then
                local H = GetPlayerServerId(G)
                if H >= 0 then
                    local I = tRIFT.getPlayerName(G)
                    table.insert(C, {name = I, source = H})
                    SetTimeout(
                        2000,
                        function()
                            for y, E in pairs(C) do
                                if H == E.source then
                                    table.remove(C, y)
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)
