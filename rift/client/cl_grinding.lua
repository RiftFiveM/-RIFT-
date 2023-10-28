local a = false
local b = {
    ["Weed"] = {
        ["mining"] = {position = vector3(2218.0529785156, 5577.3530273438, 53.859241485596), radius = 10},
        ["processing"] = {position = vector3(1065.2957763672, -3183.2448730468, -39.163402557374), radius = 20}
    },
    ["Cocaine"] = {
        ["mining"] = {position = vector3(1542.8984375, 1725.802734375, 109.81414794922), radius = 10},
        ["processing"] = {position = vector3(1088.580078125, -3188.4384765625, -38.993461608886), radius = 10}
    },
    ["Meth"] = {
        ["mining"] = {position = vector3(1391.96484375, 3603.0559082032, 38.941928863526), radius = 2},
        ["processing"] = {position = vector3(1011.0156860352, -3196.03125, -38.993114471436), radius = 4}
    },
    ["Heroin"] = {
        ["mining"] = {position = vector3(2304.98828125, 5135.8110351563, 51.296546936035), radius = 100},
        ["processing"] = {position = vector3(1593.9248046875, 3585.1362304688, 38.964069366456), radius = 15}
    },
    ["LSD"] = {
        ["mining"] = {position = vector3(5382.7719726562, -5251.4077148438, 34.086650848389), radius = 100},
        ["processing"] = {position = vector3(-2082.3818359375, 2611.9619140625, 3.0839722156525), radius = 25},
        ["refinery"] = {position = vector3(461.9499206543, -3230.3815917969, 6.0695543289185), radius = 30}
    },
    ["Copper"] = {
        ["mining"] = {position = vector3(1917.1696777344, 3289.0961914062, 44.55207824707), radius = 50},
        ["processing"] = {position = vector3(863.66119384766, 2166.7131347656, 52.284519195556), radius = 50}
    },
    ["Limestone"] = {
        ["mining"] = {position = vector3(2957.5529785156, 2787.4877929688, 40.078433990478), radius = 50},
        ["processing"] = {position = vector3(2928.1279296875, 4304.5869140625, 50.534091949463), radius = 50}
    },
    ["Gold"] = {
        ["mining"] = {position = vector3(-593.01190185546, 2077.3544921875, 131.38098144532), radius = 10},
        ["processing"] = {position = vector3(2711.3342285156, 1519.6458740234, 24.500577926636), radius = 50}
    },
    ["Diamond"] = {
        ["mining"] = {position = vector3(382.52517700195, 2893.7443847656, 43.554821014404), radius = 100},
        ["processing"] = {position = vector3(2645.3518066406, 2814.0886230469, 33.947082519531), radius = 100}
    }
}
RegisterNetEvent(
    "Polar:playGrindingScenario",
    function(c, d)
        if not a then
            a = true
            local e = GetGameTimer()
            TaskStartScenarioInPlace(tPolar.getPlayerPed(), c, 0, true)
            local f
            if d then
                if not HasNamedPtfxAssetLoaded("core") then
                    RequestNamedPtfxAsset("core")
                    while not HasNamedPtfxAssetLoaded("core") do
                        Wait(0)
                    end
                end
                UseParticleFxAsset("core")
                local g = GetEntityCoords(tPolar.getPlayerPed())
                f =
                    StartParticleFxLoopedAtCoord(
                    "ent_amb_smoke_foundry",
                    g.x,
                    g.y,
                    g.z - 3,
                    0.0,
                    0.0,
                    0.0,
                    1.0,
                    false,
                    false,
                    false
                )
                RemoveNamedPtfxAsset("core")
            end
            local h = 10000
            if tPolar.isPlatClub() then
                h = 7500
            end
            CreateThread(
                function()
                    tPolar.startCircularProgressBar(
                        "",
                        h,
                        nil,
                        function()
                        end
                    )
                end
            )
            while e + h > GetGameTimer() do
                Wait(0)
            end
            ClearPedTasksImmediately(tPolar.getPlayerPed())
            if d then
                RemoveParticleFx(f)
            end
            a = false
        end
    end
)
RegisterNetEvent(
    "Polar:playGrindingPickaxe",
    function()
        if not a then
            a = true
            local e = GetGameTimer()
            RequestAnimDict("melee@large_wpn@streamed_core")
            while not HasAnimDictLoaded("melee@large_wpn@streamed_core") do
                Wait(0)
            end
            local i = tPolar.getPlayerPed()
            local j = tPolar.loadModel("prop_tool_pickaxe")
            local k = CreateObject(j, 0, 0, 0, true, true, true)
            AttachEntityToEntity(
                k,
                i,
                GetPedBoneIndex(i, 57005),
                0.18,
                -0.02,
                -0.02,
                350.0,
                100.00,
                140.0,
                true,
                true,
                false,
                true,
                1,
                true
            )
            SetModelAsNoLongerNeeded(j)
            local h = 10000
            if tPolar.isPlatClub() then
                h = 7500
            end
            CreateThread(
                function()
                    tPolar.startCircularProgressBar(
                        "",
                        h,
                        nil,
                        function()
                        end
                    )
                end
            )
            while e + h > GetGameTimer() do
                while IsEntityPlayingAnim(
                    tPolar.getPlayerPed(),
                    "melee@large_wpn@streamed_core",
                    "ground_attack_on_spot",
                    3
                ) == 1 do
                    Wait(0)
                end
                TaskPlayAnim(
                    i,
                    "melee@large_wpn@streamed_core",
                    "ground_attack_on_spot",
                    8.0,
                    8.0,
                    1250,
                    80,
                    0,
                    0,
                    0,
                    0
                )
                Wait(0)
            end
            RemoveAnimDict("melee@large_wpn@streamed_core")
            DeleteEntity(k)
            ClearPedTasksImmediately(i)
            a = false
        else
            tPolar.notify("~r~Mining currently in progress.")
        end
    end
)
local l = false
local function m()
    for n, o in pairs(GetGamePool("CObject")) do
        if GetEntityModel(o) == "p_cs_clipboard" then
            SetEntityAsMissionEntity(o, false, false)
            DeleteEntity(o)
        end
    end
end
local p = false
local q = nil
local r = nil
local s = "None"
function func_drawGrindUI()
    if p then
        DrawRect(0.471, 0.329, 0.285, -0.005, 0, 168, 255, 204)
        DrawRect(0.471, 0.304, 0.285, 0.046, 0, 0, 0, 150)
        DrawRect(0.471, 0.428, 0.285, 0.194, 0, 0, 0, 150)
        DrawRect(0.383, 0.442, 0.066, 0.046, singleR, singleG, singleB, 150)
        DrawRect(0.469, 0.442, 0.066, 0.046, multiR, multiG, multiB, 150)
        DrawAdvancedText(0.558, 0.303, 0.005, 0.0028, 0.539, "Polar Grinding", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.478, 0.442, 0.005, 0.0028, 0.473, "Grind Single", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.564, 0.443, 0.005, 0.0028, 0.473, "Grind Vehicle", 255, 255, 255, 255, 4, 0)
        DrawRect(0.561, 0.377, 0.065, -0.003, 0, 168, 255, 204)
        DrawAdvancedText(0.654, 0.37, 0.005, 0.0028, 0.364, "Nearby Vehicles", 255, 255, 255, 255, 4, 0)
        local t, u = tPolar.getNearestOwnedVehicle(8)
        if t then
            s = u
        else
            s = "None"
        end
        DrawAdvancedText(0.656, 0.398 + 0.020 * 0, 0.005, 0.0028, 0.234, s, 255, 255, 255, 255, 0, 0)
        if CursorInArea(0.35, 0.415, 0.415, 0.46) then
            singleR, singleG, singleB = 0, 168, 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                m()
                TriggerServerEvent("Polar:requestGrinding", q, r)
                Wait(500)
                p = false
                setCursor(0)
                inGUIPolar = false
            end
        else
            singleR, singleG, singleB = 0, 0, 0
        end
        if CursorInArea(0.435, 0.51, 0.415, 0.46) then
            multiR, multiG, multiB = 0, 168, 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if s ~= "None" then
                    m()
                    TriggerServerEvent("Polar:requestGrinding", q, r, s)
                    Wait(500)
                    p = false
                    setCursor(0)
                    inGUIPolar = false
                else
                    tPolar.notify("~r~No owned vehicle nearby.")
                end
            end
        else
            multiR, multiG, multiB = 0, 0, 0
        end
        DisableControlAction(0, 177, true)
        if IsDisabledControlPressed(0, 177) then
            p = false
            setCursor(0)
            inGUIPolar = false
        end
    end
    if a and s ~= "None" then
        if IsControlJustPressed(0, 73) then
            s = "None"
            TriggerServerEvent("Polar:stopGrinding")
            tPolar.notify("~r~Grinding cancelled.")
        end
    end
end
tPolar.createThreadOnTick(func_drawGrindUI)
AddEventHandler(
    "Polar:onClientSpawn",
    function(v, w)
        if w then
            local x = function(y)
                y.nearby = true
                if not l then
                    if y.drug == "LSD" and y.type == "mining" then
                        l = true
                    end
                end
            end
            local z = function(y)
                y.nearby = false
            end
            local A = function(y)
                if y.nearby then
                    if IsControlJustReleased(0, 38) and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                        if not a then
                            if not IsNuiFocused() and not inGUIPolar then
                                p = true
                                setCursor(1)
                                inGUIPolar = true
                                q = y.drug
                                r = y.type
                            end
                        else
                            tPolar.notify("~r~Action in progress, please wait.")
                        end
                    end
                end
            end
            for B, C in pairs(b) do
                for D, E in pairs(C) do
                    tPolar.createArea(
                        B .. "_" .. D,
                        E.position,
                        E.radius,
                        6,
                        x,
                        z,
                        A,
                        {drug = B, type = D, nearby = false}
                    )
                end
            end
        end
    end
)
local F = {
    vector3(-2538.2626953125, 2538.5344238281, 1.5569897890091),
    vector3(-2539.4194335938, 2539.9475097656, 1.7244160175323),
    vector3(-2538.71484375, 2543.5520019531, 1.0692403316498),
    vector3(-2533.0373535156, 2542.5346679688, 0.32451114058495),
    vector3(-2527.6525878906, 2537.4482421875, 0.56682348251343),
    vector3(-2523.6909179688, 2529.111328125, 1.4954501390457),
    vector3(-2525.0510253906, 2531.9443359375, 0.9762516617775),
    vector3(-2526.4099121094, 2525.73828125, 1.6228685379028),
    vector3(-2533.9858398438, 2521.1958007813, 3.1568129062653),
    vector3(-2543.078125, 2522.0473632813, 3.0881731510162),
    vector3(-2550.4807128906, 2524.4438476563, 3.1460916996002),
    vector3(-2553.2941894531, 2529.9609375, 2.8802394866943),
    vector3(-2530.7827148438, 2530.3264160156, 1.5112105607986),
    vector3(-2530.287109375, 2523.9948730469, 2.4006836414337),
    vector3(-2521.775390625, 2524.0747070313, 1.6176110506058)
}
Citizen.CreateThread(
    function()
        while not l do
            Wait(100)
        end
        local G = tPolar.loadModel("a_c_hen")
        for n, H in pairs(F) do
            local I = CreatePed(5, G, H.x, H.y, H.z, 0.0, false, true)
            SetEntityInvincible(I, true)
            SetBlockingOfNonTemporaryEvents(I, true)
        end
        SetModelAsNoLongerNeeded(G)
    end
)
