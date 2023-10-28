RMenu.Add('Polarpedsmenu','main',RageUI.CreateMenu("Polar Peds", "Polar Peds Menu", tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight()))
local a=module("cfg/cfg_peds")
local b = a.pedMenus
local c = {}
local d = nil
local e = nil
local f = true
local g
local h = false
local j = {}
local k = {}
local l = 0
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('Polarpedsmenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if d ~= nil or e ~= nil and tPolar.getCustomization() ~= d then
                RageUI.Button("Reset",nil,{},true,function(m, n, o)
                    if o then
                        revertPedChange()
                    end
                end)
            end
            for i = 1, #c, 1 do
                RageUI.Button(c[i][2],nil,{},true,function(m, n, o)
                    if o then
                        if GetEntityHealth(tPolar.getPlayerPed()) > 102 then
                            spawnPed(c[i][1])
                        else
                            tPolar.notify("~r~You try to change ped, but then remember you are dead.")
                        end
                    end
                end)
            end
        end)
    end
end)

function showPedsMenu(p)
    RageUI.Visible(RMenu:Get("Polarpedsmenu", "main"), p)
end
function spawnPed(q)
    local r = tPolar.getPlayerPed()
    local s = GetEntityHeading(r)
    tPolar.setCustomization({model = q})
    SetEntityHeading(tPolar.getPlayerPed(), s)
    Wait(100)
    SetEntityMaxHealth(tPolar.getPlayerPed(), 200)
    SetEntityHealth(tPolar.getPlayerPed(), 200)
end
function revertPedChange()
    tPolar.setCustomization(d)
end
RegisterNetEvent("Polar:buildPedMenus",function(t)
    for i = 1, #j do
        tPolar.removeArea(j[i])
        j[i] = nil
    end
    for i = 1, #k do
        tPolar.removeMarker(k[i])
    end
    local u = function(v)
    end
    local w = function(x)
        c = a.peds[x.menu_id]
        g = i
        if f then
            d = tPolar.getCustomization()
            l = GetEntityHealth(tPolar.getPlayerPed())
        end
        h = true
        showPedsMenu(true)
        f = false
    end
    local y = function(v)
        showPedsMenu(false)
        f = true
        h = false
        SetEntityHealth(tPolar.getPlayerPed(), l)
    end
    for i = 1, #t do
        local z = t[i]
        local A = z[1]
        local B = string.format("pedmenu_%s_%s", A, i)
        tPolar.createArea(B, z[2], 1.25, 6, w, y, u, {menu_id = A})
        local C = tPolar.addMarker(z[2].x, z[2].y, z[2].z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 27, false, false)
        j[#j + 1] = B
        k[#k + 1] = C
    end
end)
function getPedMenuId(string)
    return stringsplit(string, "_")[2]
end