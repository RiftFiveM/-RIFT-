local Tunnel = module("Polar", "lib/Tunnel")
local Proxy = module("Polar", "lib/Proxy")

Polar = Proxy.getInterface("Polar")
Polarclient = Tunnel.getInterface("Polar","Polar")

RegisterNetEvent("Polar:saveFaceData")
AddEventHandler("Polar:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = Polar.getUserId({source})
    Polar.setUData({user_id, "Polar:Face:Data", json.encode(faceSaveData)})
end)

RegisterNetEvent("Polar:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("Polar:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = Polar.getUserId({source})
    local facesavedata = {}
    Polar.getUData({user_id, "Polar:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            Polar.setUData({user_id, "Polar:Face:Data", json.encode(facesavedata)})
        end
    end})
end)

RegisterNetEvent("Polar:changeHairstyle")
AddEventHandler("Polar:changeHairstyle", function()
    local source = source
    local user_id = Polar.getUserId({source})
    Polar.getUData({user_id, "Polar:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("Polar:setHairstyle", source, json.decode(data))
        end
    end})
end)

AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = Polar.getUserId({source})
        Polar.getUData({user_id, "Polar:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("Polar:setHairstyle", source, json.decode(data))
            end
        end})
    end)
end)