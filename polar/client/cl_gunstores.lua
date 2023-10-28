local weapons = module("Polar-weapons", "cfg/weapons")
local a=false
local b
local c
local d={name="",price="",model="",priceString="",ammoPrice="",weaponShop=""}
local e
local f
local g=""
local h=false
local i = {
    ["Legion"] = {
        _config = {
            {vector3(-3171.5241699219, 1087.5402832031, 19.838747024536),
            vector3(-330.56484985352, 6083.6059570312, 30.454759597778)},
            154,1,"B&Q Tool Shop",{""},true
        }
    },
    ["SmallArmsDealer"] = {
        _config = {
            {vector3(2437.5708007813, 4966.5610351563, 41.34761428833),
            vector3(-1500.4978027344, -216.72758483887, 46.889373779297),
            vector3(1243.0490722656, -427.33932495117, 67.918403625488)},
            110,1,"Small Arms Dealer",{""},true
        }
    },
    ["LargeArmsDealer"] = {
        _config = {
            {vector3(-1108.3199462891, 4934.7392578125, 217.35540771484),
            vector3(5065.6201171875, -4591.3857421875, 1.8652405738831),
            vector3(1140.0528564453,-428.7509765625,67.2958984375)},
            110,1,"Large Arms Dealer",{"gang.whitelisted"},false
        }
    },
    ["VIP"] = {
        _config = {
            {vector3(-2151.5739746094, 5191.2548828125, 14.718822479248)},
            110,5,"VIP Gun Store",{"vip.gunstore"},true
        }
    },
    ["Plat"] = {
        _config = {
            {vector3(-2151.5739746094,5191.2548828125,14.718822479248)},
            110,5,"VIP Gun Store",{"vip.gunstore"},true
        }
    },
    ["Rebel"] = {
        _config = {
            {vector3(1545.2521972656, 6331.5615234375, 23.07857131958),
            vector3(4925.6259765625, -5243.0908203125, 1.524599313736)},
            110,5,"Rebel Gun Store",{"rebellicense.whitelisted"},true
        }
    },
    ["policeSmallArms"] = {
        _config = {
            {vector3(461.53082275391, -979.35876464844, 29.689668655396),
            vector3(1842.9096679688, 3690.7692871094, 33.267082214355),
            vector3(-442.89114379883,5988.2124023438,31.716186523438),
            vector3(638.55255126953, 2.7499871253967, 43.423725128174),
            vector3(-1104.5264892578, -821.70153808594, 13.282785415649)},
            110,5,"MET Police Small Arms",{"police.onduty.permission"},false,true
        }
    },
    ["policeLargeArms"] = {
        _config = {
            {vector3(1840.6104736328, 3691.4741210938, 33.350730895996),
            vector3(461.43179321289, -982.66412353516, 29.689668655396),
            vector3(-441.31362915039,5986.71875,31.716171264648),
            vector3(640.8759765625, -0.63530212640762, 43.423385620117),
            vector3(-1102.5059814453, -820.62091064453, 13.282785415649)},
            110,5,"MET Police Large Arms",{"police.loadshop2", "police.onduty.permission"},false,true
        }
    },
    ["prisonArmoury"] = {
        _config = {
            {vector3(1779.3741455078, 2542.5639648438, 45.797782897949)},
            110,5,"Prison Armoury",{"prisonguard.onduty.permission"},false,true
        }
    },
}
RMenu.Add("PolarGunstore","mainmenu",RageUI.CreateMenu("","",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners", "gunstore"))
RMenu:Get("PolarGunstore","mainmenu"):SetSubtitle("~b~GUNSTORE")
RMenu.Add("PolarGunstore","type",RageUI.CreateSubMenu(RMenu:Get("PolarGunstore","mainmenu"),"","~b~Purchase Weapon or Ammo",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners", "gunstore"))
RMenu.Add("PolarGunstore","confirm",RageUI.CreateSubMenu(RMenu:Get("PolarGunstore","type"),"","~b~Purchase confirm your purchase",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners", "gunstore"))
RMenu.Add("PolarGunstore","vip",RageUI.CreateSubMenu(RMenu:Get("PolarGunstore","mainmenu"),"","~b~Purchase Weapon or Ammo",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight(),"banners", "gunstore"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("PolarGunstore", "mainmenu")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            h=false
        if b~=nil and i~=nil then 
            if tPolar.isPlatClub() then 
                if b=="VIP"then 
                    RageUI.ButtonWithStyle("~y~[Platinum Very Large Arms]","",{RightLabel="→→→"},true,function(j,k,l)
                    end,RMenu:Get("PolarGunstore","vip"))
                end 
            end
            for m,n in pairs(i)do 
                if b==m then 
                    for o,p in pairs(sortedKeys(n))do 
                        local q=n[p]
                        if p~="_config"then 
                            local r,s,t=table.unpack(q)
                            local x=false
                            local y
                            if p=="item|fillUpArmour"then 
                                local z=GetPedArmour(tPolar.getPlayerPed())
                                local A=100-z
                                y=A*1000
                                x=true 
                            end
                            local B=""
                            if x then 
                                B=tostring(getMoneyStringFormatted(y))
                            else 
                                B=tostring(getMoneyStringFormatted(s))
                            end
                            RageUI.ButtonWithStyle(r,"£"..B,{RightLabel="→→→"},true,function(j,k,l)
                                if j then 
                                end
                                if k then 
                                    e=p 
                                end
                                if l then 
                                    d.name=r
                                    d.priceString=B
                                    d.model=p
                                    d.price=s
                                    d.ammoPrice=t
                                    d.weaponShop=m 
                                end 
                            end,RMenu:Get("PolarGunstore","type"))
                        end 
                    end 
                end 
            end 
        end 
        end) 
    end
    if RageUI.Visible(RMenu:Get("PolarGunstore", "type")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle("Purchase Weapon Body","£"..getMoneyStringFormatted(d.price),{RightLabel="→→→"},true,function(j,k,l)
                if l then 
                    g="body"
                end 
            end,RMenu:Get("PolarGunstore","confirm"))
            if not weapons.weapons[d.model] or (weapons.weapons[d.model].ammo ~= "modelammo" and weapons.weapons[d.model].ammo ~= "") then 
                RageUI.ButtonWithStyle("Purchase Weapon Ammo (Max)","£"..getMoneyStringFormatted(math.floor(d.price/2)),{RightLabel="→→→"},true,function(j,k,l)
                    if l then 
                        g="ammo"
                    end 
                end,RMenu:Get("PolarGunstore","confirm"))
            end
        end) 
    end
    if RageUI.Visible(RMenu:Get("PolarGunstore", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle("Yes","",{RightLabel="→→→"},true,function(j,k,l)
            if l then 
                if string.sub(d.model,1,4)=="item"then 
                    TriggerServerEvent("Polar:buyWeapon",d.model,d.price,d.name,d.weaponShop,"armour")
                else 
                    if g=="ammo"then 
                        if HasPedGotWeapon(tPolar.getPlayerPed(),GetHashKey(d.model),false)then 
                            TriggerServerEvent("Polar:buyWeapon",d.model,d.price,d.name,d.weaponShop,"ammo")
                        else 
                            tPolar.notify("~r~You do not have the body of this weapon to purchase ammo.")
                        end 
                    else 
                        TriggerServerEvent("Polar:buyWeapon",d.model,d.price,d.name,d.weaponShop,"weapon",h)
                    end 
                end 
            end 
            end,RMenu:Get("PolarGunstore","confirm"))
            RageUI.ButtonWithStyle("No","",{RightLabel="→→→"},true,function(j,k,l)
            end,RMenu:Get("PolarGunstore","mainmenu"))
        end) 
    end
    if RageUI.Visible(RMenu:Get("PolarGunstore", "vip")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            local C=i["Plat"]
            for o,p in pairs(sortedKeys(C))do 
                h=true
                local q=C[p]
                if p~="_config"then 
                    local r,s,t=table.unpack(q)
                    local x=false
                    local y
                    if p=="item|fillUpArmour"then 
                        local z=GetPedArmour(tPolar.getPlayerPed())
                        local A=100-z
                        y=A*1000
                        x=true 
                    end
                    local B=""
                    if x then 
                        B=tostring(getMoneyStringFormatted(y))
                    else 
                        B=tostring(getMoneyStringFormatted(s))
                    end
                    RageUI.ButtonWithStyle(r,"£"..B,{RightLabel="→→→"},true,function(j,k,l)
                        if j then 
                        end
                        if k then 
                            e=p 
                        end
                        if l then 
                            d.name=r
                            d.priceString=B
                            d.model=p
                            d.price=s
                            d.ammoPrice=t
                            d.weaponShop="Plat"
                        end 
                    end,RMenu:Get("PolarGunstore","type"))
                end 
            end 
        end) 
    end
end)

RegisterNetEvent("Polar:refreshGunStorePermissions",function()
    TriggerServerEvent("Polar:requestNewGunshopData")
end)
local G = false
RegisterNetEvent("Polar:recieveFilteredGunStoreData")
AddEventHandler("Polar:recieveFilteredGunStoreData",function(F)
    i=F 
    for k,v in pairs(F) do
        if v["WEAPON_MP5TAZER"] then
            G = true
        end
    end
end)
RegisterNetEvent("Polar:recalculateLargeArms")
AddEventHandler("Polar:recalculateLargeArms",function(G)
    for m,n in pairs(i)do 
        if m=="LargeArmsDealer"then 
            for r,H in pairs(n)do
                if r ~="_config"then 
                    local I=i[m][r][7]
                    i[m][r][2]=I*(1+G/100)
                end     
            end 
        end 
    end 
end)
local function J(m,K)
    b=m
    c=K
    if m=="Rebel"then 
        RMenu:Get('PolarGunstore','mainmenu'):SetSpriteBanner("banners", "rebel")
    else 
        RMenu:Get('PolarGunstore','mainmenu'):SetSpriteBanner("banners", "gunstore")
    end
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('PolarGunstore','mainmenu'),true)
end
local function L(m)
    b=nil
    c=nil
    e=nil
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('PolarGunstore','mainmenu'),false)
end
Citizen.CreateThread(function()
    while true do 
        if e and f~=e then 
            f=e
            for m,n in pairs(i)do
                local H=n[f]
                if H then 
                    local v=H[5]
                    if v and c then 
                        local M=n._config[1][c]
                        if h then 
                            M=vector3(-2151.5739746094,5191.2548828125,14.718822479248)
                        end
                        local N=tPolar.loadModel(v)
                        if N then
                            local O=CreateObject(N,M.x,M.y,M.z+1,false,false,false)
                            while f==e and DoesEntityExist(O)do 
                                SetEntityHeading(O,GetEntityHeading(O)+1%360)
                                Wait(0)
                            end
                            DeleteEntity(O)
                        end
                        SetModelAsNoLongerNeeded(N)
                    end 
                end 
            end 
        end
        local R = PlayerPedId()
        if not G and GetSelectedPedWeapon(R) == GetHashKey("WEAPON_MP5TAZER") then
            tPolar.setWeapon(R, "WEAPON_UNARMED", true)
        end
        Wait(0)
    end 
end)
AddEventHandler("Polar:onClientSpawn",function(D, E)
    if E then
        TriggerServerEvent("Polar:requestNewGunshopData")
        for m,n in pairs(i)do 
            local P,Q,R,S,u,T=table.unpack(n["_config"])
            for K,U in pairs(P)do 
                if T then 
                    tPolar.addBlip(U.x,U.y,U.z,Q,R,S)
                end
                tPolar.addMarker(U.x,U.y,U.z,1.0,1.0,1.0,255,0,0,170,50,27)
                local V=function()
                    if GetVehiclePedIsIn(tPolar.getPlayerPed(),false)==0 then 
                        J(m,K)
                    else 
                        tPolar.notify("~r~Exit your vehicle to access the gun store.")
                    end 
                end
                local W=function()
                    L(m)
                end
                local X=function()
                end
                tPolar.createArea("gunstore_"..m.."_"..K,U,1.5,6,V,W,X,{})
            end 
        end 
    end
end)

local Y={}
function tPolar.createGunStore(Z,_,a0)
    local V=function()
        if GetVehiclePedIsIn(tPolar.getPlayerPed(),false)==0 then 
            J(_)
        else 
            tPolar.notify("~r~Exit your vehicle to access the gun store.")
        end 
    end
    local W=function()
        L(_)
    end
    local a1=string.format("gunstore_%s_%s",_,Z)
    tPolar.createArea(a1,a0,1.5,6,V,W,function()
    end)
    local a2=tPolar.addMarker(a0.x,a0.y,a0.z,1.0,1.0,1.0,255,0,0,170,50,27)
    Y[Z]={area=a1,marker=a2}
end
function tPolar.deleteGunStore(Z)
    local a3=Y[Z]
    if a3 then 
        tPolar.removeMarker(a3.marker)
        tPolar.removeArea(a3.area)
        Y[Z]=nil 
    end 
end