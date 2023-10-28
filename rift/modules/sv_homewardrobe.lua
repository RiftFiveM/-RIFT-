local outfitCodes = {}

RegisterNetEvent("Polar:saveWardrobeOutfit")
AddEventHandler("Polar:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.getUData(user_id, "Polar:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        Polarclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            Polar.setUData(user_id,"Polar:home:wardrobe",json.encode(sets))
            Polarclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("Polar:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("Polar:deleteWardrobeOutfit")
AddEventHandler("Polar:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.getUData(user_id, "Polar:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        Polar.setUData(user_id,"Polar:home:wardrobe",json.encode(sets))
        Polarclient.notify(source,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("Polar:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("Polar:equipWardrobeOutfit")
AddEventHandler("Polar:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.getUData(user_id, "Polar:home:wardrobe", function(data)
        local sets = json.decode(data)
        Polarclient.setCustomization(source, {sets[outfitName]})
        Polarclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("Polar:initWardrobe")
AddEventHandler("Polar:initWardrobe", function()
    local source = source
    local user_id = Polar.getUserId(source)
    Polar.getUData(user_id, "Polar:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("Polar:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("Polar:getCurrentOutfitCode")
AddEventHandler("Polar:getCurrentOutfitCode", function()
    local source = source
    local user_id = Polar.getUserId(source)
    Polarclient.getCustomization(source,{},function(custom)
        Polarclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            Polarclient.CopyToClipBoard(source, {uuid})
            Polarclient.notify(source, {"~g~Outfit code copied to clipboard."})
            Polarclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("Polar:applyOutfitCode")
AddEventHandler("Polar:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = Polar.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        Polarclient.setCustomization(source, {outfitCodes[outfitCode]})
        Polarclient.notify(source, {"~g~Outfit code applied."})
        Polarclient.getHairAndTats(source, {})
    else
        Polarclient.notify(source, {"~r~Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id == 1 or user_id == 2 then
        TriggerClientEvent("Polar:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = Polar.getUserId(source)
    local permid = tonumber(args[1])
    if Polar.hasGroup(user_id, 'Founder') or Polar.hasGroup(user_id, 'Lead Developer') then
        Polarclient.getCustomization(Polar.getUserSource(permid),{},function(custom)
            Polarclient.setCustomization(source, {custom})
        end)
    end
end)