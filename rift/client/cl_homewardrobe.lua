local a = nil
local b = {}
local c = ""
local function checkOutfits()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add("riftwardrobe","mainmenu",RageUI.CreateMenu("", "", tRIFT.getRageUIMenuWidth(), tRIFT.getRageUIMenuHeight(), "banners", "cstore"))
RMenu:Get("riftwardrobe", "mainmenu"):SetSubtitle("~b~HOME")
RMenu.Add("riftwardrobe","listoutfits",RageUI.CreateSubMenu(RMenu:Get("riftwardrobe", "mainmenu"),"","~b~Wardrobe",tRIFT.getRageUIMenuWidth(),tRIFT.getRageUIMenuHeight()))
RMenu.Add("riftwardrobe","equip",RageUI.CreateSubMenu(RMenu:Get("riftwardrobe", "listoutfits"),"","~b~Wardrobe",tRIFT.getRageUIMenuWidth(),tRIFT.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('riftwardrobe', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("List Outfits","",{RightLabel = "→→→"},checkOutfits(),function(d, e, f)
            end,RMenu:Get("riftwardrobe", "listoutfits"))
            RageUI.Button("Save Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    c = getGenericTextInput("outfit name:")
                    if c then
                        if not tRIFT.isPlayerInAnimalForm() then
                            TriggerServerEvent("RIFT:saveWardrobeOutfit", c)
                        else
                            tRIFT.notify("~r~Cannot save animal in wardrobe.")
                        end
                    else
                        tRIFT.notify("~r~Invalid outfit name")
                    end
                end
            end)
            RageUI.Button("Get Outfit Code","Gets a code for your current outfit which can be shared with other players.",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    if tRIFT.isPlusClub() or tRIFT.isPlatClub() then
                        TriggerServerEvent("RIFT:getCurrentOutfitCode")
                    else
                        tRIFT.notify("~y~You need to be a subscriber of RIFT Plus or RIFT Platinum to use this feature.")
                        tRIFT.notify("~y~Available @ https://riftstudios.tebex.io")
                    end
                end
            end,nil)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('riftwardrobe', 'listoutfits')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= {} then
                for g, h in pairs(b) do
                    RageUI.Button(g,"",{RightLabel = "→→→"},true,function(d, e, f)
                        if f then
                            c = g
                        end
                    end,RMenu:Get("riftwardrobe", "equip"))
                end
            else
                RageUI.Button("~r~No outfits saved","",{RightLabel = "→→→"},true,function(d, e, f)
                end,RMenu:Get("riftwardrobe", "mainmenu"))
            end
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('riftwardrobe', 'equip')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Equip Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("RIFT:equipWardrobeOutfit", c)
                end
            end,RMenu:Get("riftwardrobe", "listoutfits"))
            RageUI.Button("Delete Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("RIFT:deleteWardrobeOutfit", c)
                end
            end,RMenu:Get("riftwardrobe", "listoutfits"))
        end, function()
        end)
    end
end)

local function i()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('riftwardrobe', 'mainmenu'), true)
end
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("riftwardrobe", "mainmenu"), false)
end
RegisterNetEvent("RIFT:openOutfitMenu",function(k)
    if k then
        b = k
    else
        TriggerServerEvent("RIFT:initWardrobe")
    end
    i()
end)
RegisterNetEvent("RIFT:refreshOutfitMenu",function(k)
    b = k
end)
RegisterNetEvent("RIFT:closeOutfitMenu",function()
    j()
end)