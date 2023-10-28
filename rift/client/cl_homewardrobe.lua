local a = nil
local b = {}
local c = ""
local function checkOutfits()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add("Polarwardrobe","mainmenu",RageUI.CreateMenu("", "", tPolar.getRageUIMenuWidth(), tPolar.getRageUIMenuHeight(), "banners", "cstore"))
RMenu:Get("Polarwardrobe", "mainmenu"):SetSubtitle("~b~HOME")
RMenu.Add("Polarwardrobe","listoutfits",RageUI.CreateSubMenu(RMenu:Get("Polarwardrobe", "mainmenu"),"","~b~Wardrobe",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight()))
RMenu.Add("Polarwardrobe","equip",RageUI.CreateSubMenu(RMenu:Get("Polarwardrobe", "listoutfits"),"","~b~Wardrobe",tPolar.getRageUIMenuWidth(),tPolar.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('Polarwardrobe', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("List Outfits","",{RightLabel = "→→→"},checkOutfits(),function(d, e, f)
            end,RMenu:Get("Polarwardrobe", "listoutfits"))
            RageUI.Button("Save Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    c = getGenericTextInput("outfit name:")
                    if c then
                        if not tPolar.isPlayerInAnimalForm() then
                            TriggerServerEvent("Polar:saveWardrobeOutfit", c)
                        else
                            tPolar.notify("~r~Cannot save animal in wardrobe.")
                        end
                    else
                        tPolar.notify("~r~Invalid outfit name")
                    end
                end
            end)
            RageUI.Button("Get Outfit Code","Gets a code for your current outfit which can be shared with other players.",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    if tPolar.isPlusClub() or tPolar.isPlatClub() then
                        TriggerServerEvent("Polar:getCurrentOutfitCode")
                    else
                        tPolar.notify("~y~You need to be a subscriber of Polar Plus or Polar Platinum to use this feature.")
                        tPolar.notify("~y~Available @ https://Polarstudios.tebex.io")
                    end
                end
            end,nil)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('Polarwardrobe', 'listoutfits')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= {} then
                for g, h in pairs(b) do
                    RageUI.Button(g,"",{RightLabel = "→→→"},true,function(d, e, f)
                        if f then
                            c = g
                        end
                    end,RMenu:Get("Polarwardrobe", "equip"))
                end
            else
                RageUI.Button("~r~No outfits saved","",{RightLabel = "→→→"},true,function(d, e, f)
                end,RMenu:Get("Polarwardrobe", "mainmenu"))
            end
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('Polarwardrobe', 'equip')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Equip Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("Polar:equipWardrobeOutfit", c)
                end
            end,RMenu:Get("Polarwardrobe", "listoutfits"))
            RageUI.Button("Delete Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("Polar:deleteWardrobeOutfit", c)
                end
            end,RMenu:Get("Polarwardrobe", "listoutfits"))
        end, function()
        end)
    end
end)

local function i()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('Polarwardrobe', 'mainmenu'), true)
end
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("Polarwardrobe", "mainmenu"), false)
end
RegisterNetEvent("Polar:openOutfitMenu",function(k)
    if k then
        b = k
    else
        TriggerServerEvent("Polar:initWardrobe")
    end
    i()
end)
RegisterNetEvent("Polar:refreshOutfitMenu",function(k)
    b = k
end)
RegisterNetEvent("Polar:closeOutfitMenu",function()
    j()
end)