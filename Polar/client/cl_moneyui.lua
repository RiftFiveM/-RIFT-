local a = 0
local b = 0
local c = 0
local d = 3
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
local g = {}
RegisterNetEvent("Polar:showHUD")
AddEventHandler(
    "Polar:showHUD",
    function(h)
        showhudUI(h)
    end
)
AddEventHandler(
    "pma-voice:setTalkingMode",
    function(i)
        d = i
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
function updateMoneyUI(k, l, m, n, j, o)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = k,
            bank = l,
            redmoney = m,
            proximity = proximityIdToString[n],
            topLeftAnchor = j,
            yAnchor = o
        }
    )
end
function showhudUI(h)
    SendNUIMessage({showMoney = h})
end
RegisterNetEvent("Polar:setProfilePictures")
AddEventHandler(
    "Polar:setProfilePictures",
    function(p)
        g = p
    end
)
RegisterNetEvent("Polar:setDisplayMoney")
RegisterNetEvent(
    "Polar:setDisplayMoney",
    function(q)
        local r = tostring(math.floor(q))
        a = getMoneyStringFormatted(r)
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("Polar:setDisplayBankMoney")
AddEventHandler(
    "Polar:setDisplayBankMoney",
    function(q)
        local r = tostring(math.floor(q))
        b = getMoneyStringFormatted(r)
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("Polar:setDisplayRedMoney")
AddEventHandler(
    "Polar:setDisplayRedMoney",
    function(q)
        local r = tostring(math.floor(q))
        c = getMoneyStringFormatted(r)
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("Polar:initMoney")
AddEventHandler(
    "Polar:initMoney",
    function(k, l)
        local s = tostring(math.floor(k))
        a = getMoneyStringFormatted(s)
        local r = tostring(math.floor(l))
        b = getMoneyStringFormatted(r)
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
Citizen.CreateThread(
    function()
        Wait(4000)
        while tPolar.getUserId() == nil do
            Wait(100)
        end
        TriggerServerEvent("Polar:requestPlayerBankBalance")
        local t = false
        while true do
            local u, v = GetActiveScreenResolution()
            if u ~= e or v ~= f then
                e, f = GetActiveScreenResolution()
                cachedMinimapAnchor = GetMinimapAnchor()
                updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
            end
            if NetworkIsPlayerTalking(PlayerId()) then
                if not t then
                    t = true
                    SendNUIMessage({moneyTalking = true})
                end
            else
                if t then
                    t = false
                    SendNUIMessage({moneyTalking = false})
                end
            end
            Wait(0)
        end
    end
)
RegisterNUICallback(
    "moneyUILoaded",
    function(w, x)
        local j = tPolar.getCachedMinimapAnchor()
        updateMoneyUI("£" .. tostring(a), "£" .. tostring(b), "£" .. tostring(c), d, j.rightX * j.resX)
    end
)
function tPolar.updatePFPType(y)
    if not tPolar.isPlatClub() and not tPolar.isPlusClub() then
        y = "Steam"
    end
    SendNUIMessage({setPFP = g[y]})
end
