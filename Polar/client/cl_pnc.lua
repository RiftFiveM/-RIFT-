RegisterNUICallback("exit",function(a)
    SetDisplay(false)
    stopAnim()
end)
RegisterNUICallback("personsearch",function(a)
    TriggerServerEvent("Polar:searchPerson", a.firstname, a.lastname)
end)
RegisterNUICallback("platesearch",function(a)
    TriggerServerEvent("Polar:searchPlate", a.plate)
end)
RegisterNUICallback("submitfine",function(a)
    TriggerServerEvent("Polar:finePlayer", a.user_id, a.charges, a.amount, a.notes)
end)
RegisterNUICallback("addnote",function(a)
    TriggerServerEvent("Polar:addNote", a.user_id, a.note)
end)
RegisterNUICallback("removenote",function(a)
    TriggerServerEvent("Polar:removeNote", a.user_id, a.note)
end)
RegisterNUICallback("addattentiondrawn",function(a)
    TriggerServerEvent("Polar:addAttentionDrawn", a)
end)
RegisterNUICallback("removeattentiondrawn",function(a)
    TriggerServerEvent("Polar:removeAttentionDrawn", a.ad)
end)
RegisterNUICallback("savenotes",function(a)
    TriggerServerEvent("Polar:updateVehicleNotes", a.notes, a.user_id, a.vehicle)
end)
RegisterNUICallback("savepersonnotes",function(a)
    TriggerServerEvent("Polar:updatePersonNote", a.user_id, a.notes)
end)
RegisterNUICallback("generatewarrant",function(a)
    TriggerServerEvent("Polar:getWarrant")
end)
RegisterNUICallback("addpoint",function(a)
    TriggerServerEvent("Polar:addPoints", a.points, a.id)
end)
RegisterNUICallback("addmarker",function(a, b)
    TriggerServerEvent("Polar:addWarningMarker", tonumber(a.id), a.type, a.reason)
    b()
end)
RegisterNUICallback("wipeallmarkers",function(a, b)
    TriggerServerEvent("Polar:wipeAllMarkers", a.code)
    b()
end)
RegisterNetEvent("Polar:sendSearcheduser",function(c)
    SendNUIMessage({type = "addPersons", user = c})
end)
RegisterNetEvent("Polar:sendSearchedvehicle",function(d)
    SendNUIMessage({type = "displaySearchedVehicle", vehicle = d})
end)
RegisterNetEvent("Polar:addADToClient",function(e)
    SendNUIMessage({type = "updateAttentionDrawn", ad = e})
end)
RegisterNetEvent("Polar:verifyFineSent",function(f, g)
    SendNUIMessage({type = "verifyFine", sentornah = f, msg = g})
end)
RegisterNetEvent("Polar:novehFound",function(g)
    SendNUIMessage({type = "noveh", message = g or "No vehicles found!"})
end)
RegisterNetEvent("Polar:openPNC",function(h, i, e)
    SetNuiFocus(true, true)
    SendNUIMessage({type = "ui",status = true,id = tPolar.getUserId(),name = GetPlayerName(PlayerId()),gc = h,news = i,ad = e})
    startAnim()
end)
RegisterNetEvent("Polar:updateAttentionDrawn",function(j)
    SendNUIMessage({type = "updateAttentionDrawn", ad = j})
end)
RegisterNetEvent("Polar:setNameFields",function(k, l)
    SendNUIMessage({type = "setNameFields", lname = k, fname = l})
end)
RegisterNetEvent("Polar:noPersonsFound",function()
    SendNUIMessage({type = "NoPersonsFound"})
end)
CreateThread(function()
    while true do
        if IsControlJustPressed(0, 168) then
            TriggerServerEvent("Polar:checkForPolicewhitelist")
        end
        Citizen.Wait(0)
    end
end)
function startAnim()
    CreateThread(function()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Citizen.Wait(0)
        end
        attachObject()
        TaskPlayAnim(tPolar.getPlayerPed(),"amb@world_human_seat_wall_tablet@female@base","base",8.0,-8.0,-1,50,0,false,false,false)
    end)
end
function attachObject()
    tab = CreateObject("prop_cs_tablet", 0, 0, 0, true, true, true)
    AttachEntityToEntity(tab,tPolar.getPlayerPed(),GetPedBoneIndex(tPolar.getPlayerPed(), 57005),0.17,0.10,-0.13,24.0,180.0,180.0,true,true,false,true,1,true)
end
function stopAnim()
    StopAnimTask(tPolar.getPlayerPed(), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0)
    DeleteEntity(tab)
end
function SetDisplay(f)
    SetNuiFocus(f, f)
    SendNUIMessage({type = "ui", status = f, name = GetPlayerName(PlayerId())})
end
function PoliceSeizeTrunk(n, o)
    TriggerServerEvent("Polar:policeClearVehicleTrunk", n, o)
end
RegisterNetEvent("Polar:notifyAD",function(g, p)
    tPolar.notifyPicture("met_logo", "met_logo1", g, "Met Control", p, "police", 2)
end)