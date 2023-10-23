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
local o = json.decode(GetResourceKvpString("rift_gang_inv_colour")) or {r = 0, g = 50, b = 142}
local y2 = json.decode(GetResourceKvpString("rift_small_bar_colour")) or {r = 0, g = 75, b = 255}
local y5 = json.decode(GetResourceKvpString("rift_inventory_text")) or "RIFT"
local backgroundc = json.decode(GetResourceKvpString("rift_inv_background_colour")) or {r = 0, g = 0, b = 0}
local headerc = json.decode(GetResourceKvpString("rift_inv_header_colour")) or {r = 0, g = 0, b = 0}
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
RIFTItemList = {}
local v = 0
RIFTSecondItemList = {}
local w = 0
local x = 14
function tRIFT.getSpaceInFirstChest()
    return currentInventoryMaxWeight - d
end
function tRIFT.getSpaceInSecondChest()
    local y = 0
    if next(RIFTSecondItemList) == nil then
        return e
    else
        for u, v in pairs(RIFTSecondItemList) do
            y = y + v.amount * v.Weight
        end
        return e - y
    end
end
RegisterNetEvent(
    "RIFT:FetchPersonalInventory",
    function(z, A, B)
        RIFTItemList = z
        d = A
        currentInventoryMaxWeight = B
    end
)
RegisterNetEvent(
    "RIFT:SendSecondaryInventoryData",
    function(w, x, C, D)
        if D ~= nil then
            r = D
            inventoryType = "CarBoot"
        end
        RIFTSecondItemList = w
        e = C
        c = true
        drawInventoryUI = true
        setCursor(1)
        if C then
            g = C
            h = GetEntityCoords(tRIFT.getPlayerPed())
            if C == "notmytrunk" then
                j = GetEntityCoords(tRIFT.getPlayerPed())
            end
            if string.match(C, "player_") then
                l = string.gsub(C, "player_", "")
            else
                l = 0
            end
        end
    end
)
RegisterNetEvent(
    "RIFT:closeToRestart",
    function(w)
        i = true
        Citizen.CreateThread(
            function()
                while true do
                    RIFTSecondItemList = {}
                    c = false
                    drawInventoryUI = false
                    setCursor(0)
                    Wait(50)
                end
            end
        )
    end
)
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
        local E, F, G = tRIFT.getNearestOwnedVehicle(3.5)
        r = F
        q = G
        if E and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            p = GetEntityCoords(PlayerPedId())
            tRIFT.vc_openDoor(F, 5)
            inventoryType = "CarBoot"
            TriggerServerEvent("RIFT:FetchTrunkInventory", F)
        else
            tRIFT.notify("~r~You don't have the keys to this vehicle!")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if f ~= nil and c then
                local H = GetEntityCoords(tRIFT.getPlayerPed())
                local I = GetEntityCoords(f)
                local J = #(H - I)
                if J > 10.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if g == "house" and c then
                local H = GetEntityCoords(tRIFT.getPlayerPed())
                local I = h
                local J = #(H - I)
                if J > 5.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if g == "notmytrunk" and c then
                local H = GetEntityCoords(tRIFT.getPlayerPed())
                local I = j
                local J = #(H - I)
                if J > 5.0 then
                    TriggerEvent("RIFT:clCloseTrunk")
                    TriggerServerEvent("RIFT:closeChest")
                end
            end
            if l ~= 0 and c then
                local H = GetEntityCoords(tRIFT.getPlayerPed())
                local I = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))
                local J = #(H - I)
                if J > 5.0 then
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
local function K(L, M)
    local N = sortAlphabetically(L)
    local O = #N
    local P = M * x
    local Q = {}
    for R = P + 1, math.min(P + x, O) do
        table.insert(Q, N[R])
    end
    return Q
end
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI then
                DrawRect(0.5, 0.53, 0.572, 0.508, backgroundc.r, backgroundc.g, backgroundc.b, 150)
                DrawAdvancedText(0.593, 0.242, 0.005, 0.0028, 0.66, y5.." Inventory", 255, 255, 255, 255, 7, 0)
                DrawRect(0.5, 0.24, 0.572, 0.058, headerc.r, headerc.g, headerc.b, 200)
                DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
                DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
                if s and not inventoryType then
                    DrawAdvancedText(0.664, 0.305, 0.005, 0.0028, 0.325, "Loot All", 255, 255, 255, 255, 6, 0)
                end
                if next(RIFTItemList) then
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
                if table.count(RIFTItemList) > x then
                    DrawAdvancedText(0.528, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.412, 0.432, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        local S = math.floor(table.count(RIFTItemList) / x)
                        v = math.min(v + 1, S)
                    end
                    DrawAdvancedText(0.349, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.239, 0.269, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        v = math.max(v - 1, 0)
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
                    local T = 0.026
                    local U = 0.026
                    local V = 0
                    local W = 0
                    for X, Y in pairs(sortAlphabetically(RIFTSecondItemList)) do
                        W = W + Y["value"].amount * Y["value"].Weight
                    end
                    local Z = K(RIFTSecondItemList, w)
                    if #Z == 0 then
                        w = 0
                    end
                    for X, Y in pairs(Z) do
                        local _ = Y.title
                        local a0 = Y["value"]
                        local a1, a2, y = a0.ItemName, a0.amount, a0.Weight
                        DrawAdvancedText(0.714, 0.360 + V * U, 0.005, 0.0028, 0.366, a1, 255, 255, 255, 255, 4, 0)
                        DrawAdvancedText(
                            0.831,
                            0.360 + V * U,
                            0.005,
                            0.0028,
                            0.366,
                            tostring(y * a2) .. "kg",
                            255,
                            255,
                            255,
                            255,
                            4,
                            0
                        )
                        DrawAdvancedText(0.798, 0.360 + V * U, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                        if CursorInArea(0.5443, 0.7584, 0.3435 + V * U, 0.3690 + V * U) then
                            DrawRect(0.652, 0.331 + T * (V + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if not lockInventorySoUserNoSpam then
                                    b = _
                                    a = false
                                    k = a2
                                    selectedItemWeight = y
                                    lockInventorySoUserNoSpam = true
                                    Citizen.CreateThread(
                                        function()
                                            Wait(250)
                                            lockInventorySoUserNoSpam = false
                                        end
                                    )
                                end
                            end
                        elseif _ == b then
                            DrawRect(0.652, 0.331 + T * (V + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        end
                        V = V + 1
                    end
                    if W / e > 0.5 then
                        if W / e > 0.9 then
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. W .. "/" .. e .. "kg",
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
                                "Weight: " .. W .. "/" .. e .. "kg",
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
                            "Weight: " .. W .. "/" .. e .. "kg",
                            255,
                            255,
                            153,
                            255,
                            4,
                            0
                        )
                    end
                    if table.count(RIFTSecondItemList) > x then
                        DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.735, 0.755, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            local S = math.floor(table.count(RIFTSecondItemList) / x)
                            w = math.min(w + 1, S)
                        end
                        DrawAdvancedText(0.661, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.55, 0.58, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            w = math.max(w - 1, 0)
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
                        local a3 = tonumber(GetInvAmountText()) or 1
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if tRIFT.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, r, false, a3)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "home", false, a3)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "crate", false, a3)
                                        elseif s then
                                            TriggerServerEvent("RIFT:MoveItemX", "Plr", a, "LootBag", true, a3)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, r, false, a3)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, "home", false, a3)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("RIFT:MoveItemX", inventoryType, b, "crate", false, a3)
                                    else
                                        TriggerServerEvent("RIFT:MoveItemX", "LootBag", b, LootBagIDNew, true, a3)
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
                                    local K = tRIFT.getSpaceInSecondChest()
                                    local a3 = k
                                    if k * selectedItemWeight > K then
                                        a3 = math.floor(K / selectedItemWeight)
                                    end
                                    if a3 > 0 then
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
                                            elseif s then
                                                TriggerServerEvent("RIFT:MoveItemAll", "Plr", a, "LootBag")
                                            end
                                        end
                                    else
                                        tRIFT.notify("~r~Not enough space in secondary chest!")
                                    end
                                elseif b and g ~= nil and c then
                                    local L = tRIFT.getSpaceInFirstChest()
                                    local a3 = k
                                    if k * selectedItemWeight > L then
                                        a3 = math.floor(L / selectedItemWeight)
                                    end
                                    if a3 > 0 then
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
                if s and not inventoryType then
                    if CursorInArea(0.5428, 0.5952, 0.2879, 0.3111) then
                        DrawRect(0.5695, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("RIFT:LootItemAll", LootBagIDNew)
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
                if next(RIFTItemList) then
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
                local T = 0.026
                local U = 0.026
                local V = 0
                local W = 0
                local a4 = sortAlphabetically(RIFTItemList)
                for X, Y in pairs(a4) do
                    local _ = Y.title
                    local a0 = Y["value"]
                    local a1, a2, y = a0.ItemName, a0.amount, a0.Weight
                    W = W + a2 * y
                    DrawAdvancedText(0.404, 0.360 + V * U, 0.005, 0.0028, 0.366, a1, 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(
                        0.521,
                        0.360 + V * U,
                        0.005,
                        0.0028,
                        0.366,
                        tostring(y * a2) .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                    DrawAdvancedText(0.488, 0.360 + V * U, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                    if CursorInArea(0.2343, 0.4484, 0.3435 + V * U, 0.3690 + V * U) then
                        DrawRect(0.342, 0.331 + T * (V + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            a = _
                            if n[a] then
                                m = true
                            else
                                m = false
                            end
                            k = a2
                            selectedItemWeight = y
                            b = false
                        end
                    elseif _ == a then
                        DrawRect(0.342, 0.331 + T * (V + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                    end
                    V = V + 1
                end
                if W / currentInventoryMaxWeight > 0.5 then
                    if W / currentInventoryMaxWeight > 0.9 then
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. W .. "/" .. currentInventoryMaxWeight .. "kg",
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
                            "Weight: " .. W .. "/" .. currentInventoryMaxWeight .. "kg",
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
                        "Weight: " .. W .. "/" .. currentInventoryMaxWeight .. "kg",
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
        local M = GetOnscreenKeyboardResult()
        return M
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
function LoadAnimDict(a5)
    while not HasAnimDictLoaded(a5) do
        RequestAnimDict(a5)
        Citizen.Wait(5)
    end
end
RegisterNetEvent("RIFT:InventoryOpen")
AddEventHandler(
    "RIFT:InventoryOpen",
    function(a6, a7, a8)
        s = a7
        LootBagIDNew = a8
        if a6 and not i then
            drawInventoryUI = true
            setCursor(1)
            inGUIRIFT = true
        else
            drawInventoryUI = false
            setCursor(0)
            RIFTSecondItemList = {}
            inGUIRIFT = false
            inventoryType = nil
            local a9 = PlayerPedId()
            local W = GetEntityCoords(a9)
            ClearPedTasks(a9)
            ForcePedAiAndAnimationUpdate(a9, false, false)
            if tRIFT.getPlayerVehicle() == 0 then
                SetEntityCoordsNoOffset(a9, W.x, W.y, W.z + 0.1, true, false, false)
            end
        end
    end
)
function tRIFT.setInventoryColour()
    tRIFT.clientPrompt(
        "Enter rgb value eg 255,100,150:",
        "",
        function(a9)
            if a9 ~= "" then
                local H = stringsplit(a9, ",")
                if H[1] ~= nil and H[2] ~= nil and H[3] ~= nil then
                    o.r = tonumber(H[1])
                    o.g = tonumber(H[2])
                    o.b = tonumber(H[3])
                    tRIFT.notify("~g~Inventory colour updated.")
                else
                    tRIFT.notify("~r~Invalid value")
                end
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("rift_gang_inv_colour", json.encode(o))
        end
    )
end

function tRIFT.ResetSmallBarColour()
    y2.r = 0
    y2.g = 75
    y2.b = 255
    SetResourceKvp("rift_small_bar_colour", json.encode(y2))
end
function tRIFT.setSmallBarColour()
    tRIFT.clientPrompt(
        "Enter rgb value eg 255,255,255:",
        "",
        function(a9)
            if a9 ~= "" then
                local H1 = stringsplit(a9, ",")
                if H1[1] ~= nil and H1[2] ~= nil and H1[3] ~= nil then
                    y2.r = tonumber(H1[1])
                    y2.g = tonumber(H1[2])
                    y2.b = tonumber(H1[3])
                    tRIFT.notify("~g~Inventory Small Bar colour updated.")
                else
                    tRIFT.notify("~r~Invalid value")
                end
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("rift_small_bar_colour", json.encode(y2))
        end
    )
end

function tRIFT.ResetBackgroundColour()
    backgroundc.r = 0
    backgroundc.g = 0
    backgroundc.b = 0
    SetResourceKvp("rift_inv_background_colour", json.encode(backgroundc))
end
    

function tRIFT.setBackgroundColour()
    tRIFT.clientPrompt(
        "Enter rgb value eg 255,255,255:",
        "",
        function(a9)
            if a9 ~= "" then
                local H2 = stringsplit(a9, ",")
                if H2[1] ~= nil and H2[2] ~= nil and H2[3] ~= nil then
                    backgroundc.r = tonumber(H2[1])
                    backgroundc.g = tonumber(H2[2])
                    backgroundc.b = tonumber(H2[3])
                    tRIFT.notify("~g~Inventory Background colour updated.")
                else
                    tRIFT.notify("~r~Invalid value")
                end
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("rift_inv_background_colour", json.encode(backgroundc))
        end
    )
end

function tRIFT.ResetHeaderColour()
    headerc.r = 0
    headerc.g = 0
    headerc.b = 0
    SetResourceKvp("rift_inv_header_colour", json.encode(headerc))
end
    

function tRIFT.setHeaderColour()
    tRIFT.clientPrompt(
        "Enter rgb value eg 255,255,255:",
        "",
        function(a9)
            if a9 ~= "" then
                local H3 = stringsplit(a9, ",")
                if H3[1] ~= nil and H3[2] ~= nil and H3[3] ~= nil then
                    headerc.r = tonumber(H3[1])
                    headerc.g = tonumber(H3[2])
                    headerc.b = tonumber(H3[3])
                    tRIFT.notify("~g~Inventory Header colour updated.")
                else
                    tRIFT.notify("~r~Invalid value")
                end
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("rift_inv_header_colour", json.encode(headerc))
        end
    )
end

function tRIFT.setRandomInventoryColour()
    headerc.r = math.random(1, 255)
    headerc.g = math.random(1, 255)
    headerc.b = math.random(1, 255)
    backgroundc.r = math.random(1, 255)
    backgroundc.g = math.random(1, 255)
    backgroundc.b = math.random(1, 255)
    y2.r = math.random(1, 255)
    y2.g = math.random(1, 255)
    y2.b = math.random(1, 255)
    SetResourceKvp("rift_inv_header_colour", json.encode(headerc))
    SetResourceKvp("rift_inv_background_colour", json.encode(backgroundc))
    SetResourceKvp("rift_small_bar_colour", json.encode(y2))
end




function tRIFT.ResetInventoryText()
    y5 = "RIFT" -- Reset y5 to the default value
    SetResourceKvp("rift_inventory_text", json.encode(y5))
end

function tRIFT.SetInventoryTextName(source)
    local source = source
    if source ~= nil then
        local player_name = GetPlayerName(source)
        y5 = player_name
        SetResourceKvp("rift_inventory_text", json.encode(y5))
    end
end

function tRIFT.setInventoryText()
    tRIFT.clientPrompt(
        "Enter Inventory Text:",
        "",
        function(a11)
            if a11 ~= "" then
                y5 = a11 -- Assign the value of a9 to y5 if it's not empty
                tRIFT.notify("~g~Inventory Text updated.")
            else
                tRIFT.notify("~r~Invalid value")
            end
            SetResourceKvp("rift_inventory_text", json.encode(y5))
        end
    )
end