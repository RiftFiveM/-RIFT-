local a = {
    vector3(-429.45483398438,6001.4619140625,31.716196060181), ---paleto starts here
    vector3(-426.57977294922,5998.3950195312,31.716173171997),
    vector3(-438.20788574219,5990.2465820312,31.7161693573),
    vector3(-453.10833740234,6013.1577148438,31.716299057007),
    vector3(-440.87847900391,6033.962890625,31.340543746948),
    vector3(-480.19818115234,5993.2436523438,31.332235336304),
    vector3(-181.88633728027,6148.859375,42.632907867432),
    vector3(-124.15760040283,6216.7192382812,31.190946578979),
    vector3(-168.37078857422,6273.2905273438,31.484966278076),
    vector3(-142.4326171875,6351.7456054688,31.495248794556),
    vector3(-95.432456970215,6419.767578125,31.489612579346),
    vector3(-74.995651245117,6490.0043945312,31.490831375122),
    vector3(2.09161901474,6512.7670898438,31.877841949463),
    vector3(-13.160712242126,6566.8374023438,31.916429519653),
    vector3(36.776000976562,6546.3940429688,31.251399993896),
    vector3(70.327491760254,6576.544921875,31.25147819519),
    vector3(115.38140869141,6536.9272460938,31.255500793457),
    vector3(110.725440979,6435.0297851562,38.245929718018),
    vector3(122.16581726074,6446.1752929688,31.819034576416),
    vector3(134.12829589844,6420.8618164062,31.317003250122),
    vector3(171.96823120117,6418.0014648438,33.760009765625),
    vector3(36.399463653564,6365.8666992188,31.240980148315),
    vector3(-37.71607208252,6215.6376953125,31.13560295105),
    vector3(339.41589355469,6622.6494140625,28.707509994507),
    vector3(317.93347167969,6625.3237304688,28.820859909058),
    vector3(428.66192626953,6566.8994140625,27.135944366455),
    vector3(540.35021972656,6499.0810546875,14.028672218323),
    vector3(1377.0540771484,6476.2568359375,20.047233581543),
    vector3(1450.5123291016,6554.2705078125,14.862152099609),
    vector3(1552.9838867188,6474.0986328125,23.122018814087),
    vector3(1603.0100097656,6431.1845703125,25.914196014404),
    vector3(1728.7926025391,6393.0991210938,34.624263763428),
    vector3(878.28582763672,6436.5317382812,32.130554199219),
    vector3(244.75,6471.0893554688,31.146644592285),
    vector3(-73.003082275391,6542.0170898438,31.490793228149),
    vector3(1836.1304931641,3678.4565429688,34.270072937012), --- sandy starts here
    vector3(1840.8973388672,3685.7028808594,34.270053863525),
    vector3(1849.0090332031,3658.1767578125,34.201274871826),
    vector3(1959.6585693359,3748.4291992188,32.34375),
    vector3(1791.5877685547,3737.7893066406,33.912887573242),
    vector3(1662.8134765625,3821.0971679688,35.469482421875),
    vector3(1569.7923583984,3683.9370117188,34.781227111816),
    vector3(1536.0640869141,3585.9494628906,38.766498565674),
    vector3(1550.1467285156,3519.5795898438,35.997177124023),
    vector3(1654.0275878906,3542.7580566406,35.965766906738),
    vector3(1657.8717041016,3614.5759277344,35.482654571533),
    vector3(1855.8697509766,3926.0703125,33.015701293945),
    vector3(1912.8568115234,3933.4699707031,32.458400726318),
    vector3(1963.3316650391,3834.4519042969,32.004905700684),
    vector3(1916.5557861328,3745.1635742188,32.552635192871),
    vector3(1774.6875,3341.5319824219,41.023593902588),
    vector3(1738.9353027344,3284.3073730469,41.120872497559),
    vector3(1946.5037841797,3227.1330566406,48.349208831787),
    vector3(1980.1485595703,3482.8354492188,49.650131225586),
    vector3(1920.4916992188,3619.7243652344,34.051448822021),
    vector3(1848.7700195312,3599.4606933594,46.315799713135),

}
local function b()
    math.random()
    math.random()
    math.random()
    return a[math.random(1, #a)]
end
local c = false
function tRIFT.hasSpawnProtection()
    return c
end
local function d()
    c = true
    SetTimeout(10000,function()
        c = false
    end)
    Citizen.CreateThread(function()
        SetLocalPlayerAsGhost(true)
        while c do
            SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
            SetEntityAlpha(PlayerPedId(), 100, false)
            SetEntityHealth(PlayerPedId(), 200, true)
            TriggerServerEvent("RIFT:purgeClientHasSpawned")
            Wait(0)
        end
        SetEntityAlpha(PlayerPedId(), 255, false)
        SetLocalPlayerAsGhost(false)
        ResetGhostedEntityAlpha()
        tRIFT.notify("~g~Spawn protection ended!")
        SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
    end)
end
RMenu.Add("purge","main",RageUI.CreateMenu("Spawnpoint", "Main Men", tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight()))
local e
local f = false
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('purge', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Random Spawnpoint","",{},true,function(g, h, i)
                if i then
                    f = true
                    RageUI.ActuallyCloseAll()
                end
            end,nil)
            RageUI.Button("Safe Zone","",{},true,function(g, h, i)
                if i then
                    e = vector3(-114.13684082031,6459.44140625,31.468460083008)
                    f = true
                    RageUI.ActuallyCloseAll()
                end
            end,nil)
        end) 
    end
end)

RegisterNetEvent("RIFT:purgeSpawnClient")
AddEventHandler("RIFT:purgeSpawnClient",function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    d()
    DoScreenFadeOut(250)
    tRIFT.hideUI()
    Wait(500)
    TriggerScreenblurFadeIn(100.0)
    e = b()
    tRIFT.checkCustomization()
    RequestCollisionAtCoord(e.x, e.y, e.z)
    local j = GetGameTimer()
    while HaveAllStreamingRequestsCompleted(PlayerPedId()) ~= 1 and GetGameTimer() - j < 5000 do
        Wait(0)
        print("[RIFT] Waiting for streaming requests to complete!")
    end
    DoScreenFadeIn(1000)
    tRIFT.showUI()
    local k = tRIFT.getPlayerCoords()
    SetEntityCoordsNoOffset(PlayerPedId(), k.x, k.y, 1200.0, false, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    while not f do
        RageUI.Visible(RMenu:Get("purge", "main"), true)
        Citizen.Wait(0)
    end
    f = false
    SetEntityVisible(PlayerPedId(), true, true)
    SetFocusPosAndVel(e.x, e.y, e.z + 1000)
    spawnCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", e.x, e.y, e.z + 1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(spawnCam, true)
    RenderScriptCams(true, true, 0, 1, 0, 0)
    spawnCam2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", e.x, e.y, e.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActiveWithInterp(spawnCam2, spawnCam, 5000, 0, 0)
    Wait(2500)
    ClearFocus()
    if not playerIsInPrison then
        SetEntityCoords(PlayerPedId(), e.x, e.y, e.z)
    end
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerScreenblurFadeOut(2000.0)
    Wait(2000)
    DestroyCam(spawnCam)
    DestroyCam(spawnCam2)
    RenderScriptCams(false, true, 2000, 0, 0)
    tRIFT.checkCustomization()
    TriggerServerEvent('RIFT:changeHairstyle')
    TriggerServerEvent('RIFT:getPlayerTattoos')
    SetEntityHealth(PlayerPedId(), 200)
    TriggerServerEvent("RIFT:purgeClientHasSpawned")
end)
RegisterNetEvent("RIFT:purgeGetWeapon")
AddEventHandler("RIFT:purgeGetWeapon",function()
    tRIFT.notify("~y~Random weapon received!")
    PlaySoundFrontend(-1, "Weapon_Upgrade", "DLC_GR_Weapon_Upgrade_Soundset", true)
end)
Citizen.CreateThread(function()
    if tRIFT.isPurge() then
        local l = AddBlipForRadius(0.0, 0.0, 0.0, 50000.0)
        SetBlipColour(l, 1)
        SetBlipAlpha(l, 180)
    end
end)
