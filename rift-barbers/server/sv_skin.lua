local Tunnel = module("rift", "lib/Tunnel")
local Proxy = module("rift", "lib/Proxy")

RIFT = Proxy.getInterface("RIFT")
RIFTclient = Tunnel.getInterface("RIFT","RIFT")

RegisterNetEvent("RIFT:saveFaceData")
AddEventHandler("RIFT:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = RIFT.getUserId({source})
    RIFT.setUData({user_id, "RIFT:Face:Data", json.encode(faceSaveData)})
end)

RegisterNetEvent("RIFT:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("RIFT:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = RIFT.getUserId({source})
    local facesavedata = {}
    RIFT.getUData({user_id, "RIFT:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            RIFT.setUData({user_id, "RIFT:Face:Data", json.encode(facesavedata)})
        end
    end})
end)

RegisterNetEvent("RIFT:changeHairstyle")
AddEventHandler("RIFT:changeHairstyle", function()
    local source = source
    local user_id = RIFT.getUserId({source})
    RIFT.getUData({user_id, "RIFT:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("RIFT:setHairstyle", source, json.decode(data))
        end
    end})
end)

AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = RIFT.getUserId({source})
        RIFT.getUData({user_id, "RIFT:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("RIFT:setHairstyle", source, json.decode(data))
            end
        end})
    end)
end)