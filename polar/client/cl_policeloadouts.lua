local loadouts = {}
local selectedLoadout = nil
local weapons = module("Polar-weapons", "cfg/weapons")
local loadoutCoords = {
    vector3(457.0222, -983.0001, 30.68948), -- mission row
    vector3(1844.323, 3692.164, 34.26707), -- sandy
    vector3(-448.82821655273,6014.4443359375,36.995677947998), -- paleto
    vector3(-1106.505, -826.4623, 14.2828), -- vespucci
}

RMenu.Add("policeloadouts","main",RageUI.CreateMenu("","Please Select Division",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners","gunstore"))
RMenu.Add("policeloadouts","confirm",RageUI.CreateSubMenu(RMenu:Get("policeloadouts", "main"),"","Confirm Selection",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("policeloadouts", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false, x = 0.875, y = 0.20 }, function()
            for k, v in pairs(loadouts) do
                RageUI.Button(k, nil, { RightBadge = "→→→" }, v.hasPermission, function(Hovered, Active, Selected)
                    if Selected then
                        selectedLoadout = k -- Set the selectedLoadout here.
                    end
                end, RMenu:Get("policeloadouts", "confirm"))
            end
        end)
    end

    if RageUI.Visible(RMenu:Get("policeloadouts", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false, x = 0.875, y = 0.20 }, function()
            if selectedLoadout ~= nil and loadouts[selectedLoadout] ~= nil and loadouts[selectedLoadout].weapons ~= nil then
                RageUI.Separator("~g~Selected Loadout: " .. selectedLoadout)
                for k, v in pairs(loadouts[selectedLoadout].weapons) do
                    local weaponData = weapons.weapons[v]
                    if weaponData then
                        RageUI.Separator(weaponData.name)
                    end
                end
            end
            RageUI.Button("Confirm", nil, { RightBadge = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected and selectedLoadout ~= nil then
                    TriggerServerEvent("Polar:selectLoadout", selectedLoadout)
                    RageUI.CloseAll()
                end
            end)
        end)
    end
end)

RegisterNetEvent('Polar:gotLoadouts')
AddEventHandler('Polar:gotLoadouts', function(loadoutsTable)
    loadouts = loadoutsTable
end)

AddEventHandler("Polar:onClientSpawn",function(p, q)
    if q then
        local r = function(s)
        end
        local t = function(s)
            selectedLoadout = nil
            RageUI.Visible(RMenu:Get("policeloadouts", "main"), false)
            RageUI.Visible(RMenu:Get("policeloadouts", "confirm"), false)
            RageUI.ActuallyCloseAll()
        end
        local u = function(s)
            if IsControlJustPressed(1, 38) then
                TriggerServerEvent('Polar:getPoliceLoadouts')
                RageUI.Visible(RMenu:Get("policeloadouts", "main"), not RageUI.Visible(RMenu:Get("policeloadouts", "main")))
            end
            local v, w, x = table.unpack(GetFinalRenderedCamCoord())
            DrawText3D(loadoutCoords[s.locationId].x,loadoutCoords[s.locationId].y,loadoutCoords[s.locationId].z,"Press [E] to open Police Loadouts",v,w,x)
        end
        for k,v in pairs(loadoutCoords) do
            tPolar.createArea("police_loadouts_"..k, v, 1.5, 6, r, t, u, {locationId = k})
        end
    end
end)