RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","~w~Polar Club",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~Polar Club",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~Polar Club Manage",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~w~Polar Club Perks",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~w~Manage Death Sounds",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~w~Vehicle Extras",tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"vipclub", "vipclub"))
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}

function tPolar.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tPolar.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("Polarclub",function()
    TriggerServerEvent('Polar:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
end)

local c = {
    ["Polar"] = {checked = true, soundId = "playDead"},
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
local i = tonumber(GetResourceKvpString("Polar_damageindicatorcolour")) or 1
local v = {"Steam", "Discord", "None"}
local b = tonumber(GetResourceKvpString("Polar_pfp_type")) or 1
Citizen.CreateThread(function()
    local l = GetResourceKvpString("Polar_codhitmarkersounds") or "false"
    if l == "false" then
        d = false
        TriggerEvent("Polar:codHMSoundsOff")
    else
        d = true
        TriggerEvent("Polar:codHMSoundsOn")
    end
    local m = GetResourceKvpString("Polar_killlistsetting") or "false"
    if m == "false" then
        e = false
    else
        e = true
    end
    local n = GetResourceKvpString("Polar_oldkillfeed") or "false"
    if n == "false" then
        f = false
    else
        f = true
    end
    local o = GetResourceKvpString("Polar_damageindicator") or "false"
    if o == "false" then
        g = false
    else
        g = true
    end
    Wait(5000)
    tPolar.updatePFPType(v[b])
end)

AddEventHandler("Polar:onClientSpawn",function(f, g)
    if g then
        TriggerServerEvent('Polar:getPlayerSubscription')
        Wait(5000)
        local u=tPolar.getDeathSound()
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


function tPolar.setDeathSound(u)
    if tPolar.isPlusClub() or tPolar.isPlatClub() then 
        SetResourceKvp("Polar_deathsound",u)
    else 
        tPolar.notify("~r~Cannot change deathsound, not a valid Polar Plus or Platinum subscriber.")
    end 
end
function tPolar.getDeathSound()
    if tPolar.isPlusClub() or tPolar.isPlatClub() then 
        local k=GetResourceKvpString("Polar_deathsound")
        if type(k) == "string" and k~="" then 
            return k 
        else 
            return "playDead"
        end 
    else 
        return "playDead"
    end 
end
function tPolar.setUIProfilePictureType(t)
    SetResourceKvp("Polar_pfp_type", tostring(t))
end
function tPolar.getDmgIndcator()
    return g, i
end
local function m(h)
    SendNUIMessage({transactionType = h})
end

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.isPlusClub() or tPolar.isPlatClub() then
                RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","managesubscription"))
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            else
                RageUI.ButtonWithStyle("Purchase Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                    if q then
                        tPolar.OpenUrl("https://store.Polarstudios.uk/category/subscriptions")
                    end
                end)
            end
            if tPolar.isDev() or tPolar.getStaffLevel() >= 10 then
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
                        TriggerServerEvent("Polar:beginSellSubscriptionToPlayer", "Plus")
                    else
                        notify("~r~You must be in a greenzone to sell.")
                    end
                end
            end)
            RageUI.ButtonWithStyle("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel = "→→→"},true,function(o, p, q)
                if q then
                    if isInGreenzone then
                        TriggerServerEvent("Polar:beginSellSubscriptionToPlayer", "Platinum")
                    else
                        notify("~r~You must be in a greenzone to sell.")
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.isDev() then
                if next(z) then
                    RageUI.Separator('Perm ID: '..z.userid)
                    colourCode = getColourCode(z.hoursOfPlus)
                    RageUI.Separator('Days of Plus Remaining: '..colourCode..math.floor(z.hoursOfPlus/24*100)/100)
                    colourCode = getColourCode(z.hoursOfPlatinum)
                    RageUI.Separator('Days of Platinum Remaining: '..colourCode..math.floor(z.hoursOfPlatinum/24*100)/100)
                    RageUI.ButtonWithStyle("Set Plus Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("Polar:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.ButtonWithStyle("Set Platinum Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("Polar:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.ButtonWithStyle("Select Perm ID", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = tPolar.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tPolar.notify('Invalid Perm ID')
                            return
                        end
                        TriggerServerEvent('Polar:getPlayerSubscription', permID)
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
                                if not globalInPrison and not tPolar.isHandcuffed() then
                                    TriggerServerEvent("Polar:claimWeeklyKit")
                                else
                                    notify("~r~You can not redeem a kit whilst in custody.")
                                end
                            end
                        end
                    )
                    local function q()
                        TriggerEvent("Polar:codHMSoundsOn")
                        d = true
                        tPolar.setCODHitMarkerSetting(d)
                        tPolar.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                    end
                    local function r()
                        TriggerEvent("Polar:codHMSoundsOff")
                        d = false
                        tPolar.setCODHitMarkerSetting(d)
                        tPolar.notify("~y~COD Hitmarkers now set to " .. tostring(d))
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
                            tPolar.setKillListSetting(e)
                            tPolar.notify("~y~Kill List now set to " .. tostring(e))
                        end,
                        function()
                            e = false
                            tPolar.setKillListSetting(e)
                            tPolar.notify("~y~Kill List now set to " .. tostring(e))
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
                            tPolar.setOldKillfeed(f)
                            tPolar.notify("~y~Old killfeed now set to " .. tostring(f))
                        end,
                        function()
                            f = false
                            tPolar.setOldKillfeed(f)
                            tPolar.notify("~y~Old killfeed now set to " .. tostring(f))
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
                            tPolar.setDamageIndicator(g)
                            tPolar.notify("~y~Damage Indicator now set to " .. tostring(g))
                        end,
                        function()
                            g = false
                            tPolar.setDamageIndicator(g)
                            tPolar.notify("~y~Damage Indicator now set to " .. tostring(g))
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
                                tPolar.setDamageIndicatorColour(i)
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
                            tPolar.updatePFPType(v[b])
                            tPolar.setUIProfilePictureType(b)
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
                                tPolar.setDeathSound(k.soundId)
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
                    local w = tPolar.getPlayerVehicle()
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

RegisterNetEvent("Polar:setVIPClubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("Polar:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("vipclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("Polar:userSubscriptionUpdated",function()
    TriggerServerEvent('Polar:getPlayerSubscription', permID)
end)

Citizen.CreateThread(function()
    while true do 
        if tPolar.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),'GADGET_PARACHUTE',false) then 
                tPolar.allowWeapon("GADGET_PARACHUTE")
                GiveWeaponToPed(PlayerPedId(),'GADGET_PARACHUTE')
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tPolar.isPlusClub() or tPolar.isPlatClub()then 
            SetVehicleDirtLevel(tPolar.getPlayerVehicle(),0.0)
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
            tPolar.getFontId("Akrobat-Regular"),
            4,
            1
        )
    end
end
tPolar.createThreadOnTick(D)
RegisterNetEvent(
    "Polar:onPlayerKilledPed",
    function(F)
        if e and (tPolar.isPlatClub() or tPolar.isPlusClub()) and IsPedAPlayer(F) then
            local G = NetworkGetPlayerIndexFromPed(F)
            if G >= 0 then
                local H = GetPlayerServerId(G)
                if H >= 0 then
                    local I = tPolar.getPlayerName(G)
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
