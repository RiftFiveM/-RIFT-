local a=false
local b=false
RegisterNetEvent("RIFT:applyMorphine")
AddEventHandler("RIFT:applyMorphine",function()
    if not a then 
        a=true
        local c="mp_suicide"
        local d="pill"
        tRIFT.loadAnimDict(c)
        TaskPlayAnim(tRIFT.getPlayerPed(),c,d,2.0,2.0,2500,48,1,9,false,false,false)
        Wait(2500)
        local e=0
        while e<=100 do 
            if GetEntityHealth(PlayerPedId())<=200 and GetEntityHealth(PlayerPedId())>102 then 
                tRIFT.varyHealth(1)
            end
            e=e+1
            Wait(250)
        end
        a=false 
    else 
        tRIFT.notify("~r~Fuck, I don't feel too good...")
        local c="mp_suicide"
        local d="pill"
        tRIFT.loadAnimDict(c)
        TaskPlayAnim(tRIFT.getPlayerPed(),c,d,2.0,2.0,2500,48,1,9,false,false,false)
        Wait(2500)
        tRIFT.playScreenEffect("DrugsMichaelAliensFight",30)
        local e=0
        while e<=100 do 
            if GetEntityHealth(PlayerPedId())>102 then 
                tRIFT.varyHealth(-2)
            end
            e=e+1
            Wait(250)
        end 
    end 
end)
RegisterNetEvent("RIFT:eatTaco")
AddEventHandler("RIFT:eatTaco",function()
    if not b then 
        b=true
        local f={{"mp_player_inteat@burger","mp_player_int_eat_burger_enter",1},{"mp_player_inteat@burger","mp_player_int_eat_burger",1},{"mp_player_inteat@burger","mp_player_int_eat_burger_fp",1},{"mp_player_inteat@burger","mp_player_int_eat_exit_burger",1}}
        tRIFT.playAnim(true,f,false)
        Wait(2500)
        local e=0
        while e<=25 do 
            if GetEntityHealth(PlayerPedId())<=200 and GetEntityHealth(PlayerPedId())>102 then 
                tRIFT.varyHealth(1)
            end
            e=e+1
            Wait(125)
        end
        b=false 
    else 
        tRIFT.notify("~r~You dropped the taco on the floor trying to stuff it in your mouth!")
    end 
end)