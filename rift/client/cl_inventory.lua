drawInventoryUI = false
local a = false
local b = false
local c = false
local d = 0.00
local e = 0.00
local f = nil
local g = nil
local h = nil
local i = false
local j = nil
local k = 0
local l = 0
local m = false
local n = {
    ["9mm Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["7.62mm Bullets"] = true,
    ["5.56mm NATO"] = true,
    [".357 Bullets"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued 12 Gauge"] = true
}
local o = json.decode(GetResourceKvpString("RIFT_gang_inv_colour")) or {r = 0, g = 50, b = 142}
local p = nil
local q = nil
local r = nil
local s = false
inventoryType = nil
local t = false
local function u()
    if IsUsingKeyboard(2) and not tRIFT.isInComa() and not tRIFT.isHandcuffed() then
        TriggerServerEvent("RIFT:FetchPersonalInventory")
        if not i then
            drawInventoryUI = not drawInventoryUI
            if drawInventoryUI then
                setCursor(1)
            else
                setCursor(0)
                inGUIRIFT = false
                if p then
                    tRIFT.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    TriggerEvent("RIFT:clCloseTrunk")
                end
                inventoryType = nil
                RIFTSecondItemList = {}
            end
        else
            tRIFT.notify("~r~Cannot open inventory right before a restart!")
        end
    end
end
RegisterCommand("inventory", u, false)
RegisterKeyMapping("inventory", "Open Inventory", "KEYBOARD", "L")
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI and IsDisabledControlJustReleased(0, 200) then
                u()
            end
            Wait(0)
        end
    end
)
local v = {}
local w = 0
local RIFTSecondItemList = {}
local x = 0
local y = 14
function tRIFT.getSpaceInFirstChest()
    return currentInventoryMaxWeight - d
end
function tRIFT.getSpaceInSecondChest()
    local z = 0
    if next(RIFTSecondItemList) == nil then
        return e
    else
        for u, w in pairs(RIFTSecondItemList) do
            z = z + w.amount * w.Weight
        end
        return e - z
    end
end
RegisterNetEvent(
    "RIFT:FetchPersonalInventory",
    function(A, B, C)
        v = A
        d = B
        currentInventoryMaxWeight = C
    end
)
RegisterNetEvent(
    "RIFT:SendSecondaryInventoryData",
    function(x, y, D, E)
        if E ~= nil then
            r = E
            inventoryType = "CarBoot"
        end
        RIFTSecondItemList = x
        e = D
        c = true
        drawInventoryUI = true
        setCursor(1)
        if D then
            g = D
            h = GetEntityCoords(tRIFT.getPlayerPed())
            if D == "notmytrunk" then
                j = GetEntityCoords(tRIFT.getPlayerPed())
            end
            if string.match(D, "player_") then
                l = string.gsub(D, "player_", "")
            else
                l = 0
            end
        end
    end
)
RegisterNetEvent("RIFT:CloseToRestart", function(x)
    CloseToRestart = true 
    TriggerServerEvent("RIFT:CloseToRestarting")
    Citizen.CreateThread(function()
        while true do
            RIFTSecondItemList = {}
            c = false
            drawInventoryUI = false
            setCursor(0)
            Wait(50)
        end
    end)
end)
RegisterNetEvent(
    "RIFT:closeSecondInventory",
    function()
        RIFTSecondItemList = {}
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
    end
)
AddEventHandler(
    "RIFT:clCloseTrunk",
    function()
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
        f = nil
        inGUIRIFT = false
        RIFTSecondItemList = {}
    end
)
AddEventHandler(
    "RIFT:clOpenTrunk",
    function()
        local F, G, H = tRIFT.getNearestOwnedVehicle(3.5)
        r = G
        q = H
        if F and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            p = GetEntityCoords(PlayerPedId())
            tRIFT.vc_openDoor(G, 5)
            inventoryType = "CarBoot"
            TriggerServerEvent("RIFT:FetchTrunkInventory", G)
        else
            tRIFT.notify("~r~You don't have the keys to this vehicle!")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if f ~= nil and c then
                local I = GetEntityCoords(tRIFT.getPlayerPed())
                local J = GetEntityCoords(f)
                local K = #(I - J)
                if K > 10.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if g == "house" and c then
                local I = GetEntityCoords(tRIFT.getPlayerPed())
                local J = h
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if g == "notmytrunk" and c then
                local I = GetEntityCoords(tRIFT.getPlayerPed())
                local J = j
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if l ~= 0 and c then
                local I = GetEntityCoords(tRIFT.getPlayerPed())
                local J = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if f == nil and g == "trunk" then
                c = false
                drawInventoryUI = false
            end
            Wait(500)
        end
    end
)
local function L(M, N)
    local O = sortAlphabetically(M)
    local P = #O
    local Q = N * y
    local R = {}
    for S = Q + 1, math.min(Q + y, P) do
        table.insert(R, O[S])
    end
    return R
end
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI then
                DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150)
                DrawAdvancedText(0.593, 0.242, 0.005, 0.0028, 0.66, "Rift Inventory", 255, 255, 255, 255, 7, 0)
                DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225)
                DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
                DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
                if s then
                    DrawAdvancedText(0.664, 0.305, 0.005, 0.0028, 0.325, "Loot All", 255, 255, 255, 255, 6, 0)
                end
                if c then
                    DrawAdvancedText(0.440, 0.305, 0.005, 0.0028, 0.325, "Transfer All", 255, 255, 255, 255, 6, 0)
                end
                if next(v) then
                    DrawAdvancedText(0.355, 0.305, 0.005, 0.0028, 0.325, "Equip All", 255, 255, 255, 255, 6, 0)
                end
                if m then
                    DrawAdvancedText(0.575, 0.364, 0.005, 0.0028, 0.325, "Use", 255, 255, 255, 255, 6, 0)
                    DrawAdvancedText(0.615, 0.364, 0.005, 0.0028, 0.325, "Use All", 255, 255, 255, 255, 6, 0)
                else
                    DrawAdvancedText(0.594, 0.364, 0.005, 0.0028, 0.4, "Use", 255, 255, 255, 255, 6, 0)
                end
                DrawAdvancedText(0.594, 0.454, 0.005, 0.0028, 0.4, "Move", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.575, 0.545, 0.005, 0.0028, 0.325, "Move X", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.615, 0.545, 0.005, 0.0028, 0.325, "Move All", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.595, 0.634, 0.005, 0.0028, 0.35, "Give to Nearest Player", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.594, 0.722, 0.005, 0.0028, 0.4, "Trash", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.488, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.404, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.521, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.833, 0.776, 0.005, 0.0028, 0.288, "[Press L to close]", 255, 255, 255, 255, 4, 0)
                DrawRect(0.5, 0.273, 0.572, 0.0069999999999999, o.r, o.g, o.b, 150)
                DisableControlAction(0, 200, true)
                if table.count(v) > y then
                    DrawAdvancedText(0.528, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.412, 0.432, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        local T = math.floor(table.count(v) / y)
                        w = math.min(w + 1, T)
                    end
                    DrawAdvancedText(0.349, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.239, 0.269, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        w = math.max(w - 1, 0)
                    end
                end
                inGUIRIFT = true
                if not c then
                    DrawAdvancedText(
                        0.751,
                        0.525,
                        0.005,
                        0.0028,
                        0.49,
                        "2nd Inventory not available",
                        255,
                        255,
                        255,
                        118,
                        6,
                        0
                    )
                elseif g ~= nil then
                    DrawAdvancedText(0.798, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.714, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.831, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                    local U = 0.026
                    local V = 0.026
                    local W = 0
                    local X = 0
                    for Y, Z in pairs(sortAlphabetically(RIFTSecondItemList)) do
                        X = X + Z["value"].amount * Z["value"].Weight
                    end
                    local _ = L(RIFTSecondItemList, x)
                    if #_ == 0 then
                        x = 0
                    end
                    for Y, Z in pairs(_) do
                        local a0 = Z.title
                        local a1 = Z["value"]
                        local a2, a3, z = a1.ItemName, a1.amount, a1.Weight
                        DrawAdvancedText(0.714, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                        DrawAdvancedText(
                            0.831,
                            0.360 + W * V,
                            0.005,
                            0.0028,
                            0.366,
                            tostring(z * a3) .. "kg",
                            255,
                            255,
                            255,
                            255,
                            4,
                            0
                        )
                        DrawAdvancedText(0.798, 0.360 + W * V, 0.005, 0.0028, 0.366, a3, 255, 255, 255, 255, 4, 0)
                        if CursorInArea(0.5443, 0.7584, 0.3435 + W * V, 0.3690 + W * V) then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if not lockInventorySoUserNoSpam then
                                    b = a0
                                    a = false
                                    k = a3
                                    selectedItemWeight = z
                                    lockInventorySoUserNoSpam = true
                                    Citizen.CreateThread(
                                        function()
                                            Wait(250)
                                            lockInventorySoUserNoSpam = false
                                        end
                                    )
                                end
                            end
                        elseif a0 == b then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        end
                        W = W + 1
                    end
                    if X / e > 0.5 then
                        if X / e > 0.9 then
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                50,
                                0,
                                255,
                                4,
                                0
                            )
                        else
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                165,
                                0,
                                255,
                                4,
                                0
                            )
                        end
                    else
                        DrawAdvancedText(
                            0.826,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. e .. "kg",
                            255,
                            255,
                            153,
                            255,
                            4,
                            0
                        )
                    end
                    if table.count(RIFTSecondItemList) > y then
                        DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.735, 0.755, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            local T = math.floor(table.count(RIFTSecondItemList) / y)
                            x = math.min(x + 1, T)
                        end
                        DrawAdvancedText(0.661, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.55, 0.58, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            x = math.max(x - 1, 0)
                        end
                    end
                end
                if m then
                    if CursorInArea(0.46, 0.496, 0.33, 0.383) then
                        DrawRect(0.48, 0.359, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("RIFT:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    RIFTserver.useInventoryItem({b})
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.48, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                    if CursorInArea(0.501, 0.536, 0.329, 0.381) then
                        DrawRect(0.52, 0.359, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("RIFT:UseAllItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    RIFTserver.useInventoryItem({b})
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.52, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                else
                    if CursorInArea(0.4598, 0.5333, 0.3283, 0.3848) then
                        DrawRect(0.5, 0.36, 0.075, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("RIFT:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5, 0.36, 0.075, 0.056, 0, 0, 0, 150)
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.418, 0.4709) then
                    DrawRect(0.5, 0.45, 0.075, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if tRIFT.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("RIFT:MoveItem", "Plr", a, r, false)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("RIFT:MoveItem", "Plr", a, "home", false)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("RIFT:MoveItem", "Plr", a, "crate", false)
                                        elseif s then
                                            TriggerServerEvent("RIFT:MoveItem", "Plr", a, "LootBag", true)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("RIFT:MoveItem", inventoryType, b, r, false)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("RIFT:MoveItem", inventoryType, b, "home", false)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("RIFT:MoveItem", inventoryType, b, "crate", false)
                                    else
                                        TriggerServerEvent("RIFT:MoveItem", "LootBag", b, LootBagIDNew, true)
                                    end
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            else
                                tRIFT.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.45, 0.075, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.4598, 0.498, 0.5042, 0.5666) then
                    DrawRect(0.48, 0.54, 0.0375, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        local a4 = tonumber(GetInvAmountText()) or 1
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if tRIFT.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, r, false, a4)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "home", false, a4)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "crate", false, a4)
                                        elseif s then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "LootBag", true, a4)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, r, false, a4)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, "home", false, a4)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, "crate", false, a4)
                                    else
                                        TriggerServerEvent("RIFT:MoveItemX", "LootBag", b, LootBagIDNew, true, a4)
                                    end
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            else
                                tRIFT.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.5004, 0.5333, 0.5042, 0.5666) then
                    DrawRect(0.52, 0.54, 0.0375, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    local L = tRIFT.getSpaceInSecondChest()
                                    local a4 = k
                                    if k * selectedItemWeight > L then
                                        a4 = math.floor(L / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if tRIFT.getPlayerCombatTimer() > 0 then
                                            notify("~r~You can not store items whilst in combat.")
                                        else
                                            if inventoryType == "CarBoot" then
                                                TriggerServerEvent(
                                                    "RIFT:MoveItemAll",
                                                    "Plr",
                                                    a,
                                                    r,
                                                    NetworkGetNetworkIdFromEntity(tRIFT.getNearestVehicle(3))
                                                )
                                            elseif inventoryType == "Housing" then
                                                TriggerServerEvent("RIFT:MoveItemAll", "Plr", a, "home")
                                            elseif inventoryType == "Crate" then
                                                TriggerServerEvent("RIFT:MoveItemAll", "Plr", a, "crate")
                                            elseif inventoryType == "LootBag" then
                                                TriggerServerEvent("RIFT:MoveItemAll", "Plr", a, "LootBag")
                                            end
                                        end
                                    else
                                        tRIFT.notify("~r~Not enough space in secondary chest!")
                                    end
                                elseif b and g ~= nil and c then
                                    local M = tRIFT.getSpaceInFirstChest()
                                    local a4 = k
                                    if k * selectedItemWeight > M then
                                        a4 = math.floor(M / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent(
                                                "RIFT:MoveItemAll",
                                                inventoryType,
                                                b,
                                                r,
                                                NetworkGetNetworkIdFromEntity(tRIFT.getNearestVehicle(3))
                                            )
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("RIFT:MoveItemAll", inventoryType, b, "home")
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("RIFT:MoveItemAll", inventoryType, b, "crate")
                                        else
                                            TriggerServerEvent("RIFT:MoveItemAll", "LootBag", b, LootBagIDNew)
                                        end
                                    else
                                        tRIFT.notify("~r~Not enough space in secondary chest!")
                                    end
                                else
                                    tRIFT.notify("~r~No item selected!")
                                end
                            else
                                tRIFT.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.4598, 0.5333, 0.5931, 0.6477) then
                    DrawRect(0.5, 0.63, 0.075, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("RIFT:GiveItem", a, "Plr")
                            elseif b then
                                RIFTserver.giveToNearestPlayer({b})
                            else
                                tRIFT.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.63, 0.075, 0.056, 0, 0, 0, 150)
                end
                if s then
                    if CursorInArea(0.5428, 0.5952, 0.2879, 0.3111) then
                        DrawRect(0.5695, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("RIFT:LootItemAll", LootBagIDNew, CarBoot)
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5695, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if next(v) then
                    if CursorInArea(0.233854, 0.282813, 0.287037, 0.308333) then
                        DrawRect(0.2600, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("RIFT:EquipAll")
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.2600, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if c then
                    if CursorInArea(0.32000, 0.37000, 0.287037, 0.308333) then
                        DrawRect(0.3453, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                tRIFT.notify("~r~This feature is currently in development")
                                TriggerServerEvent("RIFT:TransferAll")
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.3453, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.6831, 0.7377) then
                    DrawRect(0.5, 0.72, 0.075, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("RIFT:TrashItem", a, "Plr")
                            elseif b then
                                tRIFT.notify("~r~Please move the item to your inventory to trash")
                            else
                                tRIFT.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.72, 0.075, 0.056, 0, 0, 0, 150)
                end
                local U = 0.026
                local V = 0.026
                local W = 0
                local X = 0
                local a5 = sortAlphabetically(v)
                for Y, Z in pairs(a5) do
                    local a0 = Z.title
                    local a1 = Z["value"]
                    local a2, a3, z = a1.ItemName, a1.amount, a1.Weight
                    X = X + a3 * z
                    DrawAdvancedText(0.404, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(
                        0.521,
                        0.360 + W * V,
                        0.005,
                        0.0028,
                        0.366,
                        tostring(z * a3) .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                    DrawAdvancedText(0.488, 0.360 + W * V, 0.005, 0.0028, 0.366, a3, 255, 255, 255, 255, 4, 0)
                    if CursorInArea(0.2343, 0.4484, 0.3435 + W * V, 0.3690 + W * V) then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            a = a0
                            if n[a] then
                                m = true
                            else
                                m = false
                            end
                            k = a3
                            selectedItemWeight = z
                            b = false
                        end
                    elseif a0 == a then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                    end
                    W = W + 1
                end
                if X / currentInventoryMaxWeight > 0.5 then
                    if X / currentInventoryMaxWeight > 0.9 then
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            50,
                            0,
                            255,
                            4,
                            0
                        )
                    else
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            165,
                            0,
                            255,
                            4,
                            0
                        )
                    end
                else
                    DrawAdvancedText(
                        0.516,
                        0.307,
                        0.005,
                        0.0028,
                        0.366,
                        "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if GetEntityHealth(tRIFT.getPlayerPed()) <= 102 then
                RIFTSecondItemList = {}
                c = false
                drawInventoryUI = false
                inGUIRIFT = false
                setCursor(0)
            end
            Wait(50)
        end
    end
)
function GetInvAmountText()
    AddTextEntry("FMMC_MPM_NA", "Enter amount: (Blank to cancel)")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount: (Blank to cancel)", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local N = GetOnscreenKeyboardResult()
        return N
    end
    return nil
end
Citizen.CreateThread(
    function()
        while true do
            Wait(250)
            if p then
                if #(p - GetEntityCoords(PlayerPedId())) > 8.0 then
                    drawInventoryUI = false
                    tRIFT.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    inventoryType = nil
                end
            end
            if drawInventoryUI then
                if
                    tRIFT.isInComa() or
                        inventoryType == "Crate" and
                            GetClosestObjectOfType(
                                GetEntityCoords(PlayerPedId()),
                                5.0,
                                GetHashKey("xs_prop_arena_crate_01a"),
                                false,
                                false,
                                false
                            ) == 0
                 then
                    TriggerEvent("RIFT:InventoryOpen", false)
                    if p then
                        tRIFT.vc_closeDoor(q, 5)
                        p = nil
                        q = nil
                        r = nil
                    end
                end
            end
        end
    end
)
function LoadAnimDict(a6)
    while not HasAnimDictLoaded(a6) do
        RequestAnimDict(a6)
        Citizen.Wait(5)
    end
end
RegisterNetEvent("RIFT:InventoryOpen")
AddEventHandler(
    "RIFT:InventoryOpen",
    function(a7, a8, a9)
        s = a8
        LootBagIDNew = a9
        if a7 and not i then
            drawInventoryUI = true
            setCursor(1)
            inGUIRIFT = true
        else
            drawInventoryUI = false
            setCursor(0)
            RIFTSecondItemList = {}
            inGUIRIFT = false
            inventoryType = nil
            local aa = PlayerPedId()
            local X = GetEntityCoords(aa)
            ClearPedTasks(aa)
            ForcePedAiAndAnimationUpdate(aa, false, false)
            if tRIFT.getPlayerVehicle() == 0 then
                SetEntityCoordsNoOffset(aa, X.x, X.y, X.z + 0.1, true, false, false)
            end
        end
    end
)
function tRIFT.setInventoryColour()
    tRIFT.clientPrompt(
        "Enter rgb value eg 255,100,150:",
        "",
        function(aa)
            if aa ~= "" then
                local I = stringsplit(aa, ",")
                if I[1] ~= nil and I[2] ~= nil and I[3] ~= nil then
                    o.r = tonumber(I[1])
                    o.g = tonumber(I[2])
                    o.b = tonumber(I[3])
                    tRIFT.notify("~g~Inventory colour updated.")
                else
                    tRIFT.notify("~r~Invalid value")
                end
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("RIFT_gang_inv_colour", json.encode(o))
        end
    )
end
