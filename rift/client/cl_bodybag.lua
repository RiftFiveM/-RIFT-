RegisterCommand("bodybag",function()
    local a = tRIFT.getNearestPlayer(3)
    if a then
        TriggerServerEvent("RIFT:requestBodyBag", a)
    else
        tRIFT.notify("No one dead nearby")
    end
end)

RegisterNetEvent("RIFT:removeIfOwned",function(b)
    local c = tRIFT.getObjectId(b, "bodybag_removeIfOwned")
    if c then
        if DoesEntityExist(c) then
            if NetworkHasControlOfEntity(c) then
                DeleteEntity(c)
            end
        end
    end
end)

RegisterNetEvent("RIFT:placeBodyBag",function()
    local d = tRIFT.getPlayerPed()
    local e = GetEntityCoords(d)
    local f = GetEntityHeading(d)
    SetEntityVisible(d, false, 0)
    local g = tRIFT.loadModel("xm_prop_body_bag")
    local h = CreateObject(g, e.x, e.y, e.z, true, true, true)
    DecorSetInt(h, "RIFTACVeh", 955)
    PlaceObjectOnGroundProperly(h)
    SetModelAsNoLongerNeeded(g)
    local b = ObjToNet(h)
    TriggerServerEvent("RIFT:removeBodybag", b)
    while GetEntityHealth(tRIFT.getPlayerPed()) <= 102 do
        Wait(0)
    end
    DeleteEntity(h)
    SetEntityVisible(d, true, 0)
end)
