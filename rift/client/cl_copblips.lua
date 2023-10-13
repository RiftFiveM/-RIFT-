local a=false
local b={}
local c={}
local function d()
    for e,f in pairs(b)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    b={}
end
local function g()
    for e,f in pairs(c)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    c={}
end
local function h(i,j,k)
    if not DoesBlipExist(i)then 
        local l=AddBlipForEntity(j)
        table.insert(b, l)
        SetBlipSprite(l,1)
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
    else 
        if GetEntityHealth(j)>102 then 
            SetBlipSprite(i,1)
        else 
            SetBlipSprite(i,274)
        end
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
    end 
end

local function checkVisibleOrStaff(n, o)
    return IsEntityVisible(n) or not tRIFT.clientGetPlayerIsStaff(o)
end

local function m(n,o,k)
    local l=AddBlipForCoord(n.x,n.y,n.z)
    table.insert(c,l)
    if o==0 then 
        SetBlipSprite(l,1)
    else 
        SetBlipSprite(l,274)
    end
    SetBlipScale(l,0.85)
    SetBlipAlpha(l,255)
    SetBlipColour(l,k)
end

RegisterCommand("blipson",function()
    if tRIFT.globalOnPoliceDuty() or tRIFT.globalNHSOnDuty() then 
        tRIFT.notify('~g~Emergency blips enabled.')
        a=true 
    end 
end,false)

RegisterCommand("blipsoff",function()
    if tRIFT.globalOnPoliceDuty() or tRIFT.globalNHSOnDuty() then 
        tRIFT.notify('~r~Emergency blips disabled.')
        a=false
        d()
        g()
    end 
end,false)

RegisterNetEvent("RIFT:disableFactionBlips",function()
    a=false
    tRIFT.setPolice(false)
    tRIFT.setHMP(false)
    tRIFT.setNHS(false)
    d()
    g()
end)

function tRIFT.copBlips()
    return a
end
Citizen.CreateThread(function()
    while true do 
        if a or tRIFT.isInComa() then 
            local p=tRIFT.getPlayerPed()
            for e,f in ipairs(GetActivePlayers())do
                local j=GetPlayerPed(f)
                if j~=p then 
                    local i=GetBlipFromEntity(j)
                    local q=GetPlayerServerId(f)
                    if q~=-1 then 
                        local r=tRIFT.clientGetUserIdFromSource(q)
                        local s=tRIFT.getJobType(r)
                        if s~="" and r ~= tRIFT.getUserId() then 
                            if checkVisibleOrStaff(j, q) then
                                if a then
                                    if s=="metpd"then 
                                        h(i,j,3)
                                    elseif s=="cid"then 
                                        h(i,j,27)
                                    elseif s=="npas"then 
                                        h(i,j,5)
                                    elseif s=="hmp"then 
                                        h(i,j,29)
                                    elseif s=="lfb"then
                                        h(i,j,1)
                                    elseif s=="hems"then 
                                        h(i,j,44)
                                    elseif s=="nhs"then 
                                        h(i,j,2)
                                    end
                                elseif tRIFT.isInComa() then
                                    if s=="nhs"then 
                                        h(i,j,2)
                                    end
                                end
                            else
                                local w = GetBlipFromEntity(j)
                                if w ~= 0 then
                                    RemoveBlip(w)
                                end
                            end
                        end 
                    end 
                end 
            end 
        end
        Wait(100)
    end 
end)
local u=true
local v=GetPlayerServerId(PlayerId())
CreateThread(function()
    Wait(20000)
    u=false
end)
RegisterNetEvent("RIFT:sendFarBlips",function(w)
    if not u and a then
        g()
        for e,x in pairs(w)do 
            if x.source~=v and GetPlayerFromServerId(x.source)== -1 and x.bucket == tRIFT.getPlayerBucket() then 
                m(x.position,x.dead,x.colour)
            end 
        end 
    end 
end)

RegisterNetEvent("RIFT:Revive",function()
    if not a then
        Citizen.Wait(1000)
        d()
    end
end)