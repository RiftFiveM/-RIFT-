Polarclient = Tunnel.getInterface("Polar","Polar")

local user_id = 0
local foundMatch = false
local inSpectatorAdminMode = false
local players = {}
local playersNearby = {}
local playersNearbyDistance = 250
local searchPlayerGroups = {}
local selectedGroup
local povlist = nil
local SelectedPerm = nil
local SelectedName = nil
local SelectedPlayerSource = nil
local hoveredPlayer = nil
local banreasons = {}
local selectedbans = {}
local Duration = 0
local BanMessage = "N/A"
local SeparatorMSG = {}
local BanPoints = 0
local g
local h = {}
local i = 1
local k = {}
local o = ''
local tt= ''
local a10
local requestedVideo = false
Tickets = {}

admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false

local q = {"PD (Mission Row)", "PD (Sandy)", "PD (Paleto)", "City Hall", "Airport", "HMP", "Arenas", "Rebel Diner", "St Thomas", "Tutorial Spawn", "Simeons"}
local r = {
    vector3(446.72503662109, -982.44342041016, 30.68931579589),
    vector3(1839.3137207031, 3671.0014648438, 34.310436248779),
    vector3(-437.32931518555, 6021.2114257813, 31.490119934082),
    vector3(-551.08221435547, -194.19259643555, 38.219661712646),
    vector3(-1142.0673828125, -2851.802734375, 13.94624710083),
    vector3(1848.2724609375, 2586.7385253906, 45.671997070313),
    vector3(-1418.8756103516,-2824.9370117188,431.12661743164),
    vector3(1588.3441162109, 6439.3696289063, 25.123600006104),
    vector3(283.37664794922, -579.45318603516, 43.219303131104),
    vector3(-1035.9499511719,-2734.6240234375,13.756628036499),
    vector3(-39.604099273682,-1111.8635253906,26.438835144043),
}
local s = 1
local communityPot = '0'

menuColour = '~b~'

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~b~Admin Menu", tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(), "banners", "admin"))
RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "closeplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "staffmembers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Search Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Functions Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Dev Functions Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "communitypot", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Community Pot',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "communitypot"))
RMenu.Add("adminmenu", "ticketdata",RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"),"",menuColour .. "Ticket Data",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "moneymenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Money Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Admin Player Interaction Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchhistory", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "notespreviewban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Player Notes',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "banselection", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "notespreviewban"), "", menuColour..'Ban Menu ~w~- ~o~[Tab] to search bans',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "generatedban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "banselection"), "", menuColour..'Ban Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "notesub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Player Notes',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Admin Groups Menu ~w~- ~o~[Tab] to search groups',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(),"banners", "admin"))
RMenu:Get('adminmenu', 'main')

local groups = {
	["Founder"] = "Founder",
    ["Staff Manager"] = "Staff Manager",
    ["Operations Manager"] = "Operations Manager",
    ["Community Manager"] = "Community Manager",
    ["Head Admin"] = "Head Administrator",
    ["Senior Admin"] = "Senior Administrator",
	["Admin"] = "Administrator",
    ["Senior Mod"] = "Senior Moderator",
	["Moderator"] = "Moderator",
    ["Support Team"] = "Support Team",
    ["Trial Staff"] = "Trial Staff",
    ["cardev"] = "Car Developer",
    ["Supporter"] = "Supporter",
    ["Premium"] = "Premium",
    ["Supreme"] = "Supreme",
    ["Kingpin"] = "Kingpin",
    ["Rainmaker"] = "Rainmaker",
    ["Baller"] = "Baller",
    ["pov"] = "POV List",
    ["Copper"] = "Copper License",
    ["Weed"] = "Weed License",
    ["Limestone"] = "Limestone License",
    ["Gang"] = "Gang License",
    ["Cocaine"] = "Cocaine License",
    ["Meth"] = "Meth License",
    ["Heroin"] = "Heroin License",
    ["LSD"] = "LSD License",
    ["Rebel"] = "Rebel License",
    ["AdvancedRebel"] = "Advanced Rebel License",
    ["Gold"] = "Gold License",
    ["Diamond"] = "Diamond License",
    ["DJ"] = "DJ License",
    ["PilotLicense"] = "Pilot License",
    ["polblips"] = "Long Range Emergency Blips",
    ["Highroller"] = "Highrollers License",
    ["TutorialDone"] = "Completed Tutorial",
    ["Royal Mail Driver"] = "Royal Mail Driver",
    ["Bus Driver"] = "Bus Driver",
    ["Deliveroo"] = "Deliveroo",
    ["Scuba Diver"] = "Scuba Diver",
    ["G4S Driver"] = "G4S Driver",
    ["Taco Seller"] = "Taco Seller",
    ["Burger Shot Cook"] = "Burger Shot Cook",
    ["Cinematic"] = "Cinematic Menu",
    ["Booster"] = "Discord Booster",
    ["Editz"] = "Editz Perms",
}


RegisterNetEvent("Polar:ReturnNearbyPlayers")
AddEventHandler("Polar:ReturnNearbyPlayers", function(table)
    playersNearby = table
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hoveredPlayer ~= nil then
            local playerCoords = GetEntityCoords(tPolar.getPlayerPed())
            if tPolar.isInSpectate() then
                playerCoords = GetFinalRenderedCamCoord()
            end
            TriggerServerEvent("Polar:GetNearbyPlayers", playerCoords, 250)
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hoveredPlayer ~= nil then
            local hoveredPedCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(hoveredPlayer)))
            DrawMarker(2, hoveredPedCoords.x, hoveredPedCoords.y, hoveredPedCoords.z + 1.1,0.0,0.0,0.0,0.0,-180.0,0.0,0.4,0.4,0.4,36,113,252,125,false,true,2, false)
        end
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if tPolar.getStaffLevel() >= 1 then
        if RageUI.Visible(RMenu:Get('adminmenu', 'main')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                hoveredPlayer = nil
                selectedbans = {}
                for k, v in pairs(banreasons) do
                    v.itemchecked = false
                end
                RageUI.ButtonWithStyle("All Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'players'))
                RageUI.ButtonWithStyle("Nearby Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local playerCoords = GetEntityCoords(tPolar.getPlayerPed())
                        if tPolar.isInSpectate() then
                            playerCoords = GetFinalRenderedCamCoord()
                        end
                        TriggerServerEvent("Polar:GetNearbyPlayers", playerCoords, 250)
                    end
                end, RMenu:Get('adminmenu', 'closeplayers'))
                RageUI.ButtonWithStyle("Search Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'searchoptions'))
                RageUI.ButtonWithStyle("Online Staff Members", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'staffmembers'))
                RageUI.ButtonWithStyle("Functions", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'functions'))
                RageUI.ButtonWithStyle("Settings", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('SettingsMenu', 'MainMenu'))
            end)
        end
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'players')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                if not tPolar.isUserHidden(v[3]) then
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            SelectedPerm = v[3]
                            TriggerServerEvent("Polar:CheckPov",v[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'closeplayers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if next(playersNearby) then
                for i, v in pairs(playersNearby) do
                    if not tPolar.isUserHidden(v[3]) then
                        RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then 
                                SelectedPlayer = playersNearby[i]
                                SelectedPerm = v[3]
                                TriggerServerEvent("Polar:CheckPov",v[3])
                            end
                            if Active then 
                                hoveredPlayer = v[2]
                            end
                        end, RMenu:Get("adminmenu", "submenu"))
                    end
                end
            else
                RageUI.Separator("No players nearby!")
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'staffmembers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                if not tPolar.isUserHidden(v[3]) then
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            SelectedPerm = v[3]
                            TriggerServerEvent("Polar:CheckStaff",v[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchoptions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            foundMatch = false
            RageUI.ButtonWithStyle("Search by Name", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchname'))
            RageUI.ButtonWithStyle("Search by Perm ID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchpermid'))
            RageUI.ButtonWithStyle("Search by Temp ID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchtempid'))
            RageUI.ButtonWithStyle("Search History", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchhistory'))
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'functions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.getStaffLevel() >= 1 then
                RageUI.ButtonWithStyle("Get Coords", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:GetCoords')
                    end
                end)                 
                RageUI.List("Teleport",q,s,"",{},true,function(x, y, z, N)
                    s = N
                    if z then
                        tPolar.teleport2(vector3(r[s]), true)
                    end
                end,
                function()end)
            end
            if tPolar.getStaffLevel() >= 5 then
                RageUI.ButtonWithStyle("TP To Coords","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Tp2Coords")
                    end
                end)
            end
            if tPolar.getStaffLevel() >= 2 then
                RageUI.ButtonWithStyle("Offline Ban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.clientPrompt("Perm ID:","",function(a)
                            banningPermID = a
                            banningName = 'ID: ' .. banningPermID
                            o = nil
                            selectedbans = {}
                            for k, v in pairs(banreasons) do
                                v.itemchecked = false
                            end
                            TriggerServerEvent('Polar:getNotes', banningPermID)
                        end)
                    end
                end, RMenu:Get('adminmenu', 'notespreviewban'))
            end
<<<<<<< HEAD:Polar/client/adminmenu.lua
            if tPolar.getStaffLevel() >= 10 then
=======
            if tRIFT.getStaffLevel() >= 5 then
>>>>>>> parent of 95ce20f (clothing store fixed):rift/client/adminmenu.lua
                RageUI.ButtonWithStyle("TP To Waypoint", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local WaypointHandle = GetFirstBlipInfoId(8)
                        if DoesBlipExist(WaypointHandle) then
                            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                            for height = 1, 1000 do
                                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                if foundGround then
                                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    break
                                end
                                Citizen.Wait(5)
                            end
                        else
                            tPolar.notify("~r~You do not have a waypoint set")
                        end
                    end
                end)
            end
            if tPolar.getStaffLevel() >= 5 then
                RageUI.ButtonWithStyle("Unban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Unban")
                    end
                end)
            end
            if tPolar.getStaffLevel() >= 3 then
                RageUI.ButtonWithStyle("Spawn Taxi", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local A = GetEntityCoords(tPolar.getPlayerPed())
                        tPolar.spawnVehicle("taxi",A.x,A.y,A.z,GetEntityHeading(tPolar.getPlayerPed()),true,true,true)
                    end
                end)
            end
            if tPolar.getStaffLevel() >= 5 then
                RageUI.ButtonWithStyle("Revive All Nearby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local D = tPolar.getPlayerCoords()
                        for E, S in pairs(GetActivePlayers()) do
                            local T = GetPlayerServerId(S)
                            local M = GetPlayerPed(S)
                            if T ~= -1 and M ~= 0 then
                                local U = GetEntityCoords(M, true)
                                if #(D - U) < 500.0 then
                                    local V = tPolar.clientGetUserIdFromSource(T)
                                    if V > 0 then
                                        TriggerServerEvent('Polar:RevivePlayer', GetPlayerServerId(PlayerId()), V, true)
                                    end
                                end
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Remove Warning","",{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry('FMMC_MPM_NC', "Enter the Warning ID")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                                TriggerServerEvent('Polar:RemoveWarning', result)
                            end
                        end
                    end
                end)
            end 
            if tPolar.getStaffLevel() >= 6 then
                local P=""
                if tPolar.hasStaffBlips() then 
                    P="~r~Turn off blips"
                else 
                    P="~g~Turn on blips"
                end
                RageUI.ButtonWithStyle("Toggle Blips", P, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.staffBlips(not tPolar.hasStaffBlips())
                    end
                end)
                RageUI.ButtonWithStyle("Community Pot Menu","",{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:getCommunityPotAmount")
                    end
                end,RMenu:Get('adminmenu','communitypot'))
                RageUI.ButtonWithStyle("RP Zones","",{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                end,RMenu:Get("rpzones","mainmenu"))
            end  
            if tPolar.getStaffLevel() >= 10 then
                RageUI.ButtonWithStyle("Give Money","",{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                end,RMenu:Get('adminmenu','moneymenu'))
                RageUI.ButtonWithStyle("Add Car", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:AddCar')
                    end
                end, RMenu:Get('adminmenu', 'functions'))
                RageUI.ButtonWithStyle("Check Tickets","~g~Displays your ticket data",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.notify("~y~Feature Coming Soon!")
                        -- TriggerServerEvent("Polar:GetAdminTickets")
                    end
                end, RMenu:Get("adminmenu", "ticketdata"))
                RageUI.Checkbox("Set Globally Hidden","",tPolar.isLocalPlayerHidden(),{},function()
                end,function()
                    TriggerServerEvent("Polar:setUserHidden", true)
                end,function()
                    TriggerServerEvent("Polar:setUserHidden", false)
                end)
            end
        end)
    end
    -- RageUI.IsVisible(
    --     RMenu:Get("adminmenu", "ticketdata"),
    --     true,
    --     true,
    --     true,
    --     function()
    --         if next(z) == nil then
    --             RageUI.Separator("~r~No ticket data found")
    --         else
    --             for r, J in ipairs(z) do
    --                 RageUI.Separator(J)
    --             end
    --         end
            -- RageUI.ButtonWithStyle(
            --     "View Leaderboard",
            --     "",
            --     {RightLabel = "→→→"},
            --     true,
            --     function(K, L, M)
            --         if M then
            --             TriggerServerEvent("Polar:getTicketLeadeboard")
            --         end
            --     end
            -- )
    --         RageUI.ButtonWithStyle(
    --             "View Self",
    --             "",
    --             {RightLabel = "→→→"},
    --             true,
    --             function(K, L, M)
    --                 if M then
    --                     TriggerServerEvent("Polar:getTicketData")
    --                 end
    --             end
    --         )
    --     end,
    --     function()
    --     end
    -- )
    if RageUI.Visible(RMenu:Get('adminmenu', 'moneymenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if a10 ~= nil and sn ~= nil and sc ~= nil and sb ~= nil and sw ~= nil and sch ~= nil then
                RageUI.Separator("Name: ~b~"..sn)
                RageUI.Separator("PermID: ~b~"..a10)
                RageUI.Separator("TempID: ~b~"..sc)
                RageUI.Separator("Bank Balance: ~b~£"..sb)
                RageUI.Separator("Cash Balance: ~b~£"..sw)
                RageUI.Separator("Casino Chips: ~b~"..sch)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("Bank Balance ~g~+",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(j)
                            if tonumber(j) then
                                TriggerServerEvent('Polar:ManagePlayerBank',a10,j,"Increase")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Bank Balance ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(j)
                            if tonumber(j) then
                                TriggerServerEvent('Polar:ManagePlayerBank',a10,j,"Decrease")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Cash Balance ~g~+~w~",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('Polar:ManagePlayerCash',a10,l,"Increase")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Cash Balance ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('Polar:ManagePlayerCash',a10,l,"Decrease")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Casino Chips ~g~+",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('Polar:ManagePlayerChips',a10,l,"Increase")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Casino Chips ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tPolar.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('Polar:ManagePlayerChips',a10,l,"Decrease")
                            else
                                tPolar.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
            end
            RageUI.ButtonWithStyle("Choose PermID",nil, { RightLabel = "→→→" }, true, function(w,x,y)
                if y then
                    tPolar.clientPrompt("PermID:","",function(j)
                        if tonumber(j) then
                            a10 = tonumber(j)
                            tPolar.notify("~g~PermID Set To "..j)
                            TriggerServerEvent('Polar:getUserinformation',a10)
                        else
                            tPolar.notify("~r~Invalid PermID")
                            a10 = nil
                        end
                    end)
                end
            end, RMenu:Get('adminmenu', 'moneymenu'))
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'communitypot')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("Community Pot Balance: ~g~£"..getMoneyStringFormatted(communityPot))
            RageUI.ButtonWithStyle("Deposit","",{RightLabel="→→→"},true,function(e,f,g)
                if g then 
                    tPolar.clientPrompt("Enter Amount:","",function(d)
                        if tonumber(d)then 
                            TriggerServerEvent("Polar:tryDepositCommunityPot",d)
                        else 
                            tPolar.notify("~r~Invalid amount.")
                        end 
                    end)
                end 
            end)
            RageUI.ButtonWithStyle("Withdraw","",{RightLabel="→→→"},true,function(e,f,g)
                if g then 
                    tPolar.clientPrompt("Enter Amount:","",function(d)
                        if tonumber(d)then 
                            TriggerServerEvent("Polar:tryWithdrawCommunityPot",d)
                        else 
                            tPolar.notify("~r~Invalid amount.")
                        end 
                    end)
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.isDev() or tPolar.getStaffLevel() >= 10 then
                RageUI.ButtonWithStyle("Spawn Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:Giveweapon')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
                RageUI.ButtonWithStyle("Give Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:GiveWeaponToPlayer')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
                RageUI.ButtonWithStyle("Armour", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.setArmour(100)
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end        
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                searchforPermID = tPolar.KeyboardInput("Enter Perm ID", "", 10)
                if searchforPermID == nil then 
                    searchforPermID = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[3],searchforPermID) then
                    if not tPolar.isUserHidden(v[3]) then
                        RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = players[k]
                                TriggerServerEvent("Polar:CheckPov",v[3])
                                g = v[3]
                                h[i] = g
                                i = i + 1
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchtempid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                searchid = tPolar.KeyboardInput("Enter Temp ID", "", 10)
                if searchid == nil then 
                    searchid = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[2], searchid) then
                    if not tPolar.isUserHidden(v[3]) then
                        RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = players[k]
                                TriggerServerEvent("Polar:CheckPov",v[3])
                                g = v[2]
                                h[i] = g
                                i = i + 1
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchname')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                SearchName = tPolar.KeyboardInput("Enter Name", "", 10)
                if SearchName == nil then 
                    SearchName = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(string.lower(v[1]), string.lower(SearchName)) then
                    if not tPolar.isUserHidden(v[3]) then
                        RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = players[k]
                                TriggerServerEvent("Polar:CheckPov",v[3])
                                g = v[1]
                                h[i] = g
                                i = i + 1
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchhistory')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                if i > 1 then
                    for K = #h, #h - 10, -1 do
                        if h[K] then
                            if tonumber(h[K]) == v[3] or tonumber(h[K]) == v[2] or h[K] == v[1] then
                                RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        SelectedPlayer = players[k]
                                        TriggerServerEvent("Polar:CheckPov",v[3])
                                    end
                                end, RMenu:Get('adminmenu', 'submenu'))
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'submenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            hoveredPlayer = nil
            if tPolar.isUserHidden(SelectedPlayer[3]) then
                RageUI.ActuallyCloseAll()
            end
            if povlist == nil then
                RageUI.Separator("~y~Player must provide POV on request: Loading...")
            elseif povlist == true then
                RageUI.Separator("~y~Player must provide POV on request: ~g~true")
            elseif povlist == false then
                RageUI.Separator("~y~Player must provide POV on request: ~r~false")
            end
            if tPolar.getStaffLevel() >= 1 then
                RageUI.ButtonWithStyle("Player Notes", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:getNotes', SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'notesub'))
                RageUI.ButtonWithStyle("Kick Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:ABCDEFGHIJKLMNOP', uid, SelectedPlayer[3], SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 2 then
                RageUI.ButtonWithStyle("Ban Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        banningPermID = SelectedPlayer[3]
                        banningName = SelectedPlayer[1]
                        o = nil
                        TriggerServerEvent('Polar:getNotes', SelectedPlayer[3])
                        selectedbans = {}
                        for k, v in pairs(banreasons) do
                            v.itemchecked = false
                        end
                    end
                end, RMenu:Get('adminmenu', 'notespreviewban'))
                RageUI.ButtonWithStyle("Spectate Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if tonumber(SelectedPlayer[2]) ~= GetPlayerServerId(PlayerId()) then
                            if not tPolar.isInSpectate() then
                                inRedZone = false
                                TriggerServerEvent("Polar:spectatePlayer", SelectedPlayer[3])
                                inSpectatorAdminMode = true
                                RageUI.Text({message = string.format("~r~Press [E] to stop spectating.")})
                            else
                                tPolar.notify("~r~You are already spectating a player.")
                            end
                        else
                            tPolar.notify("~r~You cannot spectate yourself.")
                        end
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 5 then
                RageUI.ButtonWithStyle("Revive", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:RevivePlayer', uid, SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
<<<<<<< HEAD:Polar/client/adminmenu.lua
            if tPolar.getStaffLevel() >= 10 then
                RageUI.ButtonWithStyle("Armour", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:ArmourPlayer', uid, SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 1 then
=======
            if tRIFT.getStaffLevel() >= 1 then
>>>>>>> parent of 95ce20f (clothing store fixed):rift/client/adminmenu.lua
                RageUI.ButtonWithStyle("Teleport to Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local newSource = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:TeleportToPlayer', newSource, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport Player to Me", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:BringPlayer', SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Admin Zone", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        inRedZone = false
                        savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                        TriggerServerEvent("Polar:Teleport2AdminIsland", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport Back from Admin Zone", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:TeleportBackFromAdminZone", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Legion", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2Legion", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Give Player Mosin", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("RIFT:EditzgiveMosin", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Arena", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2arena", SelectedPlayer[2])
                    end
                end,RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Simeons", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2simeons", SelectedPlayer[2])
                    end
                end,RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Casino", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2casino", SelectedPlayer[2])
                    end
                end,RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Rebel", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2rebel", SelectedPlayer[2])
                    end
                end,RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Teleport to Paleto", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:Teleport2Paleto", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Freeze", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        isFrozen = not isFrozen
                        TriggerServerEvent('Polar:FreezeSV', uid, SelectedPlayer[2], isFrozen)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 5 then
                RageUI.ButtonWithStyle("Slap Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:SlapPlayer', uid, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Force Clock Off", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:ForceClockOff', SelectedPlayer[2])
                        TriggerEvent("Polar:ForceRefreshData")
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 12 then
                RageUI.ButtonWithStyle("Force Staff Off", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('Polar:ForceStaffOff', SelectedPlayer[2])
                        TriggerEvent("Polar:ForceRefreshData")
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 1 then
                RageUI.ButtonWithStyle("Open F10 Warning Log", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("sw " .. SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 2 then
                RageUI.ButtonWithStyle("Take Screenshot", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:RequestScreenshot', uid , SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.Button("Take Video", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], requestedVideo and {RightLabel = ""} or {RightLabel = "→→→"}, not requestedVideo, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Polar:RequestVideo', uid, SelectedPlayer[2])
                        requestedVideo = true
                        SetTimeout(15000, function()
                            requestedVideo = false
                        end)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if tPolar.getStaffLevel() >= 6 then
                RageUI.ButtonWithStyle("Request Account Info", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:requestAccountInfosv", SelectedPlayer[3])
                    end
                end,RMenu:Get("adminmenu", "submenu"))
                RageUI.ButtonWithStyle("See Groups", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:GetGroups", SelectedPlayer[3])
                        tt=''
                    end
                end,RMenu:Get("adminmenu", "groups"))
            end
            if tPolar.getStaffLevel() >= 10 then
                RageUI.ButtonWithStyle("Commit Godly Wrath on Player","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:zapPlayer", SelectedPlayer[2])
                    end
                end,RMenu:Get("adminmenu", "submenu"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'notespreviewban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.getStaffLevel() >= 2 then
                if noteslist == nil then
                    RageUI.Separator("~o~Player notes: Loading...")
                elseif #noteslist == 0 then
                    RageUI.Separator("~o~There are no player notes to display.")
                else
                    RageUI.Separator("~o~Player notes:")
                    for _ = 1, #noteslist do
                        RageUI.Separator("~o~ID: " .. noteslist[_].id .. " " .. noteslist[_].note .. " (" .. noteslist[_].author .. ")")
                    end
                end
                RageUI.ButtonWithStyle("Continue to Ban", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'banselection'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'banselection')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.getStaffLevel() >= 2 then
                if IsControlJustPressed(0, 37) then
                    tPolar.clientPrompt("Search for: ","",function(O)
                        if O ~= "" then
                            o = string.lower(O)
                        else
                            o = nil
                        end
                    end)
                end
                for k, v in pairs(banreasons) do
                    local function SelectedTrue()
                        selectedbans[v.id] = true
                    end
                    local function SelectedFalse()
                        selectedbans[v.id] = nil
                    end
                    if o == nil or string.match(string.lower(v.id), o) or string.match(string.lower(v.name), o) then
                        RageUI.Checkbox(v.name, v.bandescription, v.itemchecked, { RightBadge = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                            if Selected then
                                if v.itemchecked then
                                    SelectedTrue()
                                end
                                if not v.itemchecked then
                                    SelectedFalse()
                                end
                            end
                            v.itemchecked = Checked
                        end)
                    end
                end
                RageUI.ButtonWithStyle("Confirm Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Polar:GenerateBan", banningPermID, selectedbans)
                    end
                end, RMenu:Get('adminmenu', 'generatedban'))
        
                RageUI.ButtonWithStyle("Cancel Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        selectedbans = {}
                        for k, v in pairs(banreasons) do
                            v.itemchecked = false
                        end
                        RageUI.ActuallyCloseAll()
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'generatedban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.getStaffLevel() >= 2 then
                if next(selectedbans) then
                    if BanMessage == "N/A" then
                        RageUI.Separator("~g~Generating ban info, please wait...")
                    else
                        RageUI.Separator("~r~You are about to ban " ..banningName, function() end)
                        RageUI.Separator("For the following reason(s):", function() end)
                        for k,v in pairs(SeparatorMsg) do
                            RageUI.Separator(v, function() end)
                        end
                        local U=false
                        if Duration == -1 then
                            U=true
                        end
                        RageUI.Separator("~w~Total Length: "..(U and "Permanent" or Duration.." hrs"))
                        RageUI.ButtonWithStyle("Cancel", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                selectedbans = {}
                                for k, v in pairs(banreasons) do
                                    v.itemchecked = false
                                end
                                RageUI.ActuallyCloseAll()
                            end
                        end)
                        RageUI.ButtonWithStyle("Confirm", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("Polar:BanPlayer", banningPermID, Duration, BanMessage, BanPoints)
                            end
                        end)
                    end
                else
                    RageUI.Separator("~r~You must select at least one ban reason.", function() end)
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'notesub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if noteslist == nil then
                RageUI.Separator("~o~Player notes: Loading...")
            elseif #noteslist == 0 then
                RageUI.Separator("~o~There are no player notes to display.")
            else
                RageUI.Separator("~o~Player notes:")
                for _ = 1, #noteslist do
                    RageUI.Separator("~o~ID: " .. noteslist[_].id .. " " .. noteslist[_].note .. " (" .. noteslist[_].author .. ")")
                end
            end
            if tPolar.getStaffLevel() >= 1 then
                RageUI.ButtonWithStyle("Add To Notes:", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.clientPrompt("Add To Notes: ","",function(a7)
                            if a7 ~= "" then
                                if #noteslist ~= 0 then
                                    noteslist[#noteslist + 1] = {id = #noteslist + 1, note = a7, author = tPolar.getUserId()}
                                else
                                    noteslist = {{id = 1, note = a7, author = tPolar.getUserId()}}
                                end
                                TriggerServerEvent("Polar:updatePlayerNotes", SelectedPlayer[3], noteslist)
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Remove Note", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        tPolar.clientPrompt("Type the ID of the note","",function(a7)
                            if a7 ~= "" then
                                a7 = tonumber(a7)
                                local a8 = {}
                                local a9 = false
                                for _ = 1, #noteslist do
                                    if noteslist[_].id == a7 then
                                        for aa = 1, #noteslist do
                                            if aa ~= _ then
                                                a8[#a8 + 1] = {
                                                    id = #a8 + 1,
                                                    note = noteslist[aa].note,
                                                    author = noteslist[aa].author
                                                }
                                            end
                                        end
                                        a9 = true
                                        break
                                    end
                                end
                                if a9 == true then
                                    if #a8 == 0 then
                                        a8 = nil
                                        noteslist = {}
                                    else
                                        noteslist = a8
                                    end
                                    TriggerServerEvent("Polar:updatePlayerNotes", SelectedPlayer[3], a8)
                                end
                            end
                        end)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tPolar.getStaffLevel() >= 7 then
                if IsControlJustPressed(0, 37) then
                    tPolar.clientPrompt("Search for: ","",function(S)
                        tt=string.lower(S)
                    end)
                end
                for k,S in pairs(groups) do
                    if tt=="" or string.find(string.lower(S),string.lower(tt)) then
                        if searchPlayerGroups[k] then
                            RageUI.ButtonWithStyle("~g~"..S,"~g~User has this group.",{RightLabel="→→→"},true,function(x,y,z)
                                if z then 
                                    selectedGroup = k
                                end 
                            end,RMenu:Get('adminmenu','removegroup'))
                        else 
                            RageUI.ButtonWithStyle("~r~"..S,"~r~User does not have this group.",{RightLabel="→→→"},true,function(x,y,z)
                                if z then 
                                    selectedGroup = k
                                end 
                            end,RMenu:Get('adminmenu','addgroup'))
                        end 
                    end
                end
            end
        end) 
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'addgroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Add this group to user", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("Polar:AddGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'removegroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Remove user from group", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("Polar:RemoveGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups')) 
        end)
    end
end)

RegisterCommand("cleanup", function()
    TriggerServerEvent('Polar:CleanAll')
end)

RegisterNetEvent('Polar:SlapPlayer')
AddEventHandler('Polar:SlapPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)


frozen = false
RegisterNetEvent("Polar:Freeze",function()
    local Q = tPolar.getPlayerPed()
    if IsPedSittingInAnyVehicle(Q) then
        local ak = GetVehiclePedIsIn(Q, false)
        TaskLeaveVehicle(Q, ak, 4160)
    end
    if not frozen then
        FreezeEntityPosition(Q, true)
        frozen = true
        while frozen do
            tPolar.setWeapon(Q, "WEAPON_UNARMED", true)
            Wait(0)
        end
    else
        FreezeEntityPosition(Q, false)
        frozen = false
    end
end)


RegisterNetEvent("Polar:sendNotes",function(a7)
    a7 = json.decode(a7)
    if a7 == nil then
        noteslist = {}
    else
        noteslist = a7
    end
end)

RegisterNetEvent('Polar:ReturnPov')
AddEventHandler('Polar:ReturnPov', function(pov)
    povlist = pov
end)

RegisterNetEvent("Polar:GotGroups")
AddEventHandler("Polar:GotGroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

RegisterNetEvent("Polar:getPlayersInfo")
AddEventHandler("Polar:getPlayersInfo", function(BB, preasons)
    players = BB
    banreasons = preasons
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
end)

RegisterNetEvent("Polar:RecieveBanPlayerData")
AddEventHandler("Polar:RecieveBanPlayerData",function(BanDuration, CollectedBanMessage, SepMSG, points)
    Duration = BanDuration
    BanMessage = CollectedBanMessage
    SeparatorMsg = SepMSG
    BanPoints = points
    RageUI.Visible(RMenu:Get('adminmenu', 'generatedban'), true)
end)

RegisterNetEvent("Polar:receivedUserInformation")
AddEventHandler("Polar:receivedUserInformation", function(us,un,ub,uw,uc)
    if us == nil or un == nil or ub == nil or uw == nil or uc == nil then
        a10 = nil
        tPolar.notify("Player does not exist.")
        return
    end
    sc=us
    sn=un
    sb=getMoneyStringFormatted(ub)
    sw=getMoneyStringFormatted(uw)
    sch=getMoneyStringFormatted(uc)
end)

RegisterNetEvent("Polar:gotCommunityPotAmount",function(d)
    communityPot=tostring(d)
end)


function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent('Polar:OpenAdminMenu')
AddEventHandler('Polar:OpenAdminMenu', function(admin)
    if admin then
        TriggerServerEvent('Polar:GetPlayerData')
        TriggerServerEvent("Polar:GetNearbyPlayerData")
        TriggerServerEvent("Polar:getAdminLevel")
    end
end)

    RageUI.IsVisible(RMenu:Get("adminmenu", "tickets"),true, false,true,function()
            RageUI.Separator("All Your Admin Tickets Will Show Up Here", function() end)
            RageUI.Separator("", function() end)
            for k,v in pairs(Tickets) do
                RageUI.Separator("Name: "..v.Name, function() end)
                RageUI.Separator("UserID: "..k, function() end)
                RageUI.Separator("Total Admin Tickets: "..v.Tickets, function() end)
        end
    end)

RegisterNetEvent("Polar:GotAdminTickets")
AddEventHandler("Polar:GotAdminTickets", function(a)
    if a ~= '[]' then
        Tickets = a
    end
end)

-- RegisterCommand('devmenu',function()
--     if tPolar.isDev() then
--         RageUI.Visible(RMenu:Get("adminmenu", "devfunctions"), not RageUI.Visible(RMenu:Get("adminmenu", "devfunctions")))
--     end
-- end)

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function func_checkSpectatorMode()
    if inSpectatorAdminMode then
        if IsControlJustPressed(0, 51) then
            inSpectatorAdminMode = false
            TriggerServerEvent("Polar:stopSpectatePlayer")
        end
    end
end
tPolar.createThreadOnTick(func_checkSpectatorMode)


RegisterNetEvent("Polar:takeClientScreenshotAndUpload",function(url)
    local url = url -- need a custom uploader whenever
    exports["screenshot-basic"]:requestScreenshotUpload(url,"files[]",function(ab)
    end)
end)

RegisterNetEvent("Polar:takeClientVideoAndUpload",function(url)
    local url = url  -- need a custom uploader whenever
    exports["screenshot-basic"]:requestVideoUpload(url,"files[]",{headers = {}, isVideo = true, isManual = true, encoding = "mp4"},function(ac)
    end)
end)

local an = 0
local function ao()
    local ap = GetResourceState("screenshot-basic")
    if ap == "started" then
        exports["screenshot-basic"]:requestKeepAlive(function(aq)
            if not aq then
                an = GetGameTimer()
            end
        end)
    end
    if GetGameTimer() - an > 60000 then
        TriggerServerEvent("Polar:acType16")
    end
end
AddEventHandler("Polar:onClientSpawn",function(C, D)
    if D then
        an = GetGameTimer()
        while true do
            ao()
            Citizen.Wait(5000)
        end
    end
end)