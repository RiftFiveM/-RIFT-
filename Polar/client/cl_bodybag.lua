RegisterCommand("bodybag",function()
    local a = tPolar.getNearestPlayer(3)
    if a then
        TriggerServerEvent("Polar:requestBodyBag", a)
    else
        tPolar.notify("No one dead nearby")
    end
end)

RegisterNetEvent("Polar:removeIfOwned",function(b)
    local c = tPolar.getObjectId(b, "bodybag_removeIfOwned")
    if c then
        if DoesEntityExist(c) then
            if NetworkHasControlOfEntity(c) then
                DeleteEntity(c)
            end
        end
    end
end)

RegisterNetEvent("Polar:placeBodyBag",function()
    local d = tPolar.getPlayerPed()
    local e = GetEntityCoords(d)
    local f = GetEntityHeading(d)
    SetEntityVisible(d, false, 0)
    local g = tPolar.loadModel("xm_prop_body_bag")
    local h = CreateObject(g, e.x, e.y, e.z, true, true, true)
    DecorSetInt(h, "PolarACVeh", 955)
    PlaceObjectOnGroundProperly(h)
    SetModelAsNoLongerNeeded(g)
    local b = ObjToNet(h)
    TriggerServerEvent("Polar:removeBodybag", b)
    while GetEntityHealth(tPolar.getPlayerPed()) <= 102 do
        Wait(0)
    end
    DeleteEntity(h)
    SetEntityVisible(d, true, 0)
end)
