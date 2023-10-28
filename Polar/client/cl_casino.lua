insideDiamondCasino = false
AddEventHandler("Polar:onClientSpawn",function(a, b)
    if b then
        local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
        local d = function(e)
            insideDiamondCasino = true
            tPolar.setCanAnim(false)
            TriggerEvent("Polar:enteredDiamondCasino")
            TriggerServerEvent('Polar:getChips')
        end
        local f = function(e)
            insideDiamondCasino = false
            tPolar.setCanAnim(true)
            TriggerEvent("Polar:exitedDiamondCasino")
        end
        local g = function(e)
        end
        tPolar.createArea("diamondcasino", c, 100.0, 20, d, f, g, {})
    end
end)
