<<<<<<< HEAD:polar/client/cl_weather.lua
CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

RegisterNetEvent('Polar:updateWeather')
AddEventHandler('Polar:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('Polar:updateTime')
AddEventHandler('Polar:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('Polar:requestSync')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('Polar:notify')
AddEventHandler('Polar:notify', function(message, blink)
    ShowNotification(message, blink)
=======
local a = "EXTRASUNNY"
local b = {h = 12, m = 0, s = 0}
local c = false
local function d(e)
    a = e
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(a)
    SetWeatherTypeNow(a)
    SetWeatherTypeNowPersist(a)
    if a == "XMAS" then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end
function tPolar.setTime(f, g, h)
    b = {h = f, m = g, s = h}
end
function tPolar.overrideTime(f, g, h)
    b.h = f
    b.m = g
    b.s = h
    c = true
end
function tPolar.cancelOverrideTimeWeather()
    c = false
end
function tPolar.setWeather(i)
    a = i
end
function func_manageTimeAndWeather()
    NetworkOverrideClockTime(b.h, b.m, b.s)
    d(a)
end
tPolar.createThreadOnTick(func_manageTimeAndWeather)
RegisterNetEvent("Polar:setTime",function(f, g, h)
    tPolar.setTime(f, g, h)
>>>>>>> parent of ab6642c (Haloween update):Polar/client/cl_weather.lua
end)
RegisterNetEvent("Polar:setWeather",function(i)
    tPolar.setWeather(i)
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        b.s = b.s + 10
        if b.s == 60 then
            b.s = 0
            b.m = b.m + 1
        end
        if b.m == 60 then
            b.m = 0
            b.h = b.h + 1
        end
        if b.h == 24 then
            b.h = 0
        end
        if not c then
            tPolar.setTime(b.h, b.m, b.s)
        end
    end
end)
local j = false
local k = false
local l = 60
local m = {
    ["CLEAR"] = 0,
    ["EXTRASUNNY"] = 0,
    ["CLOUDS"] = 0,
    ["OVERCAST"] = 0,
    ["RAIN"] = 0,
    ["THUNDER"] = 0,
    ["HALLOWEEN"] = 0,
    ["SMOG"] = 0,
    ["FOGGY"] = 0,
    ["XMAS"] = 0,
    ["SNOWLIGHT"] = 0,
    ["BLIZZARD"] = 0
}
local function n(o, p, q, f, r, s, t, u, v, w, x, y)
    SetTextFont(x)
    SetTextScale(r, r)
    SetTextJustification(y)
    SetTextColour(t, u, v, w)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(s)
    EndTextCommandDisplayText(o - 0.1 + q, p - 0.02 + f)
end
local z = 0.1
local A = 0.005
local B = 0.02
Citizen.CreateThread(function()
    while true do
        if j then
            n(z + 0.265, 0.96, 0.005, 0.0028, 0.30, "Time Left:", 0, 208, 104, 255, 4, 1)
            n(z + 0.295, 0.96, 0.005, 0.0028, 0.275, tostring(l), 255, 74, 53, 255, 0, 1)
            n(z + 0.29, 0.827, 0.005, 0.0028, 0.38, "Weather Voter", 0, 208, 104, 255, 4, 1)
            n(z + 0.2645, 0.848, 0.005, 0.0028, 0.30, "Clear", 255, 255, 255, 255, 4, 1)
            n(z + 0.2645, 0.866, 0.005, 0.0028, 0.30, "ExtraSunny", 255, 255, 255, 255, 4, 1)
            n(z + 0.2645, 0.884, 0.005, 0.0028, 0.30, "Cloudy", 255, 255, 255, 255, 4, 1)
            n(z + 0.2645, 0.902, 0.005, 0.0028, 0.30, "Overcast", 255, 255, 255, 255, 4, 1)
            n(z + 0.2645, 0.920, 0.005, 0.0028, 0.30, "Rain", 255, 255, 255, 255, 4, 1)
            n(z + 0.2645, 0.938, 0.005, 0.0028, 0.30, "Thunder", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.293, 0.848, 0.005, 0.0028, 0.25, tostring(m["CLEAR"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.293, 0.866, 0.005, 0.0028, 0.25, tostring(m["EXTRASUNNY"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.293, 0.884, 0.005, 0.0028, 0.25, tostring(m["CLOUDS"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.293, 0.902, 0.005, 0.0028, 0.25, tostring(m["OVERCAST"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.293, 0.920, 0.005, 0.0028, 0.25, tostring(m["RAIN"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.293, 0.938, 0.005, 0.0028, 0.25, tostring(m["THUNDER"]), 255, 74, 53, 255, 0, 1)
            n(z + A + 0.315, 0.848, 0.005, 0.0028, 0.30, "Halloween", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.315, 0.866, 0.005, 0.0028, 0.30, "Smog", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.315, 0.884, 0.005, 0.0028, 0.30, "Snow", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.315, 0.902, 0.005, 0.0028, 0.30, "Blizzard", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.315, 0.920, 0.005, 0.0028, 0.30, "Snowlight", 255, 255, 255, 255, 4, 1)
            n(z + A + 0.315, 0.938, 0.005, 0.0028, 0.30, "Foggy", 255, 255, 255, 255, 4, 1)
            n(z + B + 0.333, 0.848, 0.005, 0.0028, 0.25, tostring(m["HALLOWEEN"]), 255, 74, 53, 255, 0, 1)
            n(z + B + 0.333, 0.866, 0.005, 0.0028, 0.25, tostring(m["SMOG"]), 255, 74, 53, 255, 0, 1)
            n(z + B + 0.333, 0.884, 0.005, 0.0028, 0.25, tostring(m["XMAS"]), 255, 74, 53, 255, 0, 1)
            n(z + B + 0.333, 0.902, 0.005, 0.0028, 0.25, tostring(m["BLIZZARD"]), 255, 74, 53, 255, 0, 1)
            n(z + B + 0.333, 0.920, 0.005, 0.0028, 0.25, tostring(m["SNOWLIGHT"]), 255, 74, 53, 255, 0, 1)
            n(z + B + 0.333, 0.938, 0.005, 0.0028, 0.25, tostring(m["FOGGY"]), 255, 74, 53, 255, 0, 1)
        end
        Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        if j then
            l = l - 1
            if l == 0 then
                j = false
                l = 60
                k = false
                resetVotes()
            end
        end
        Wait(1000)
    end
end)
function voteWeather(C)
    if j then
        if not k then
            TriggerServerEvent("Polar:vote", C)
            k = true
            tPolar.notify("~g~Vote sent!")
        else
            tPolar.notify("~r~You have already voted!")
        end
    else
        tPolar.notify("~r~Vote not in progress, start a vote with /voteweather!")
    end
end
function resetVotes()
    m = {
        ["CLEAR"] = 0,
        ["EXTRASUNNY"] = 0,
        ["CLOUDS"] = 0,
        ["OVERCAST"] = 0,
        ["RAIN"] = 0,
        ["THUNDER"] = 0,
        ["HALLOWEEN"] = 0,
        ["SMOG"] = 0,
        ["FOGGY"] = 0,
        ["XMAS"] = 0,
        ["SNOWLIGHT"] = 0,
        ["BLIZZARD"] = 0
    }
end
RegisterNetEvent("Polar:startWeatherVote",function()
    j = true
    TriggerEvent("chatMessage","Weather vote has started! Type /[weather] e.g /snow or /rain to vote.",{0, 250, 50})
    TriggerEvent("chatMessage", "Weather types are in bottom left & /voteweather to start a vote", {0, 250, 50})
end)
RegisterNetEvent("Polar:voteStateChange",function(D)
    m[D] = m[D] + 1
end)
RegisterCommand("voteweather",function()
    TriggerServerEvent("Polar:tryStartWeatherVote")
end,false)
RegisterCommand("clear",function()
    voteWeather("CLEAR")
end,false)
RegisterCommand("extrasunny",function()
    voteWeather("EXTRASUNNY")
end,false)
RegisterCommand("cloudy",function()
    voteWeather("CLOUDS")
end,false)
RegisterCommand("overcast",function()
    voteWeather("OVERCAST")
end,false)
RegisterCommand("rain",function()
    voteWeather("RAIN")
end,false)
RegisterCommand("thunder",function()
    voteWeather("THUNDER")
end,false)
RegisterCommand("halloween",function()
    voteWeather("HALLOWEEN")
end,false)
RegisterCommand("smog",function()
    voteWeather("SMOG")
end,false)
RegisterCommand("foggy",function()
    voteWeather("FOGGY")
end,false)
RegisterCommand("snow",function()
    voteWeather("XMAS")
end,false)
RegisterCommand("snowlight",function()
    voteWeather("SNOWLIGHT")
end,false)
RegisterCommand("blizzard",function()
    voteWeather("BLIZZARD")
end,false)
