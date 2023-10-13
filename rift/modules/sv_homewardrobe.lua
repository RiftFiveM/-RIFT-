local outfitCodes = {}

RegisterNetEvent("RIFT:saveWardrobeOutfit")
AddEventHandler("RIFT:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.getUData(user_id, "RIFT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        RIFTclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            RIFT.setUData(user_id,"RIFT:home:wardrobe",json.encode(sets))
            RIFTclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("RIFT:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("RIFT:deleteWardrobeOutfit")
AddEventHandler("RIFT:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.getUData(user_id, "RIFT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        RIFT.setUData(user_id,"RIFT:home:wardrobe",json.encode(sets))
        RIFTclient.notify(source,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("RIFT:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("RIFT:equipWardrobeOutfit")
AddEventHandler("RIFT:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.getUData(user_id, "RIFT:home:wardrobe", function(data)
        local sets = json.decode(data)
        RIFTclient.setCustomization(source, {sets[outfitName]})
        RIFTclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("RIFT:initWardrobe")
AddEventHandler("RIFT:initWardrobe", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.getUData(user_id, "RIFT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("RIFT:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("RIFT:getCurrentOutfitCode")
AddEventHandler("RIFT:getCurrentOutfitCode", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFTclient.getCustomization(source,{},function(custom)
        RIFTclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            RIFTclient.CopyToClipBoard(source, {uuid})
            RIFTclient.notify(source, {"~g~Outfit code copied to clipboard."})
            RIFTclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("RIFT:applyOutfitCode")
AddEventHandler("RIFT:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = RIFT.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        RIFTclient.setCustomization(source, {outfitCodes[outfitCode]})
        RIFTclient.notify(source, {"~g~Outfit code applied."})
        RIFTclient.getHairAndTats(source, {})
    else
        RIFTclient.notify(source, {"~r~Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id == 1 or user_id == 2 then
        TriggerClientEvent("RIFT:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = RIFT.getUserId(source)
    local permid = tonumber(args[1])
    if RIFT.hasGroup(user_id, 'Founder') or RIFT.hasGroup(user_id, 'Lead Developer') then
        RIFTclient.getCustomization(RIFT.getUserSource(permid),{},function(custom)
            RIFTclient.setCustomization(source, {custom})
        end)
    end
end)