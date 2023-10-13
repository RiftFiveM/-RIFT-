insideDiamondCasino = false
AddEventHandler("RIFT:onClientSpawn",function(a, b)
    if b then
        local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
        local d = function(e)
            insideDiamondCasino = true
            tRIFT.setCanAnim(false)
            tRIFT.overrideTime(12, 0, 0)
            TriggerEvent("RIFT:enteredDiamondCasino")
            TriggerServerEvent('RIFT:getChips')
        end
        local f = function(e)
            insideDiamondCasino = false
            tRIFT.setCanAnim(true)
            tRIFT.cancelOverrideTimeWeather()
            TriggerEvent("RIFT:exitedDiamondCasino")
        end
        local g = function(e)
        end
        tRIFT.createArea("diamondcasino", c, 100.0, 20, d, f, g, {})
    end
end)
