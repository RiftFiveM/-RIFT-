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
local o = json.decode(GetResourceKvpString("Polar_gang_inv_colour")) or {r = 0, g = 50, b = 142}
local p = nil
local q = nil
local r = nil
local s = false
inventoryType = nil
local t = false
local function u()
    if IsUsingKeyboard(2) and not tPolar.isInComa() and not tPolar.isHandcuffed() then
        TriggerServerEvent("Polar:FetchPersonalInventory")
        if not i then
            drawInventoryUI = not drawInventoryUI
            if drawInventoryUI then
                setCursor(1)
            else
                setCursor(0)
                inGUIPolar = false
                if p then
                    tPolar.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    TriggerEvent("Polar:clCloseTrunk")
                end
                inventoryType = nil
                PolarSecondItemList = {}
            end
        else
            tPolar.notify("~r~Cannot open inventory right before a restart!")
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
PolarItemList = {}
local v = 0
PolarSecondItemList = {}
local w = 0
local x = 14
function tPolar.getSpaceInFirstChest()
    return currentInventoryMaxWeight - d
end
function tPolar.getSpaceInSecondChest()
    local y = 0
    if next(PolarSecondItemList) == nil then
        return e
    else
        for u, v in pairs(PolarSecondItemList) do
            y = y + v.amount * v.Weight
        end
        return e - y
    end
end
RegisterNetEvent(
    "Polar:FetchPersonalInventory",
    function(z, A, B)
        PolarItemList = z
        d = A
        currentInventoryMaxWeight = B
    end
)
RegisterNetEvent(
    "Polar:SendSecondaryInventoryData",
    function(w, x, C, D)
        if D ~= nil then
            r = D
            inventoryType = "CarBoot"
        end
        PolarSecondItemList = w
        e = C
        c = true
        drawInventoryUI = true
        setCursor(1)
        if C then
            g = C
            h = GetEntityCoords(tPolar.getPlayerPed())
            if C == "notmytrunk" then
                j = GetEntityCoords(tPolar.getPlayerPed())
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
    "Polar:closeToRestart",
    function(w)
        i = true
        Citizen.CreateThread(
            function()
                while true do
                    PolarSecondItemList = {}
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
    "Polar:closeSecondInventory",
    function()
        PolarSecondItemList = {}
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
    end
)
AddEventHandler(
    "Polar:clCloseTrunk",
    function()
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
        f = nil
        inGUIPolar = false
        PolarSecondItemList = {}
    end
)
AddEventHandler(
    "Polar:clOpenTrunk",
    function()
        local E, F, G = tPolar.getNearestOwnedVehicle(3.5)
        r = F
        q = G
        if E and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            p = GetEntityCoords(PlayerPedId())
            tPolar.vc_openDoor(F, 5)
            inventoryType = "CarBoot"
            TriggerServerEvent("Polar:FetchTrunkInventory", F)
        else
            tPolar.notify("~r~You don't have the keys to this vehicle!")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if f ~= nil and c then
                local H = GetEntityCoords(tPolar.getPlayerPed())
                local I = GetEntityCoords(f)
                local J = #(H - I)
                if J > 10.0 then
                    TriggerEvent("Polar:clCloseTrunk")
                    TriggerServerEvent("Polar:closeChest")
                end
            end
            if g == "house" and c then
                local H = GetEntityCoords(tPolar.getPlayerPed())
                local I = h
                local J = #(H - I)
                if J > 5.0 then
                    TriggerEvent("Polar:clCloseTrunk")
                    TriggerServerEvent("Polar:closeChest")
                end
            end
            if g == "notmytrunk" and c then
                local H = GetEntityCoords(tPolar.getPlayerPed())
                local I = j
                local J = #(H - I)
                if J > 5.0 then
                    TriggerEvent("Polar:clCloseTrunk")
                    TriggerServerEvent("Polar:closeChest")
                end
            end
            if l ~= 0 and c then
                local H = GetEntityCoords(tPolar.getPlayerPed())
                local I = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))
                local J = #(H - I)
                if J > 5.0 then
                    TriggerEvent("Polar:clCloseTrunk")
                    TriggerServerEvent("Polar:closeChest")
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
                DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150)
                DrawAdvancedText(0.593, 0.242, 0.005, 0.0028, 0.66, "Polar INVENTORY", 255, 255, 255, 255, 7, 0)
                DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225)
                DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
                DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
                if s and not inventoryType then
                    DrawAdvancedText(0.664, 0.305, 0.005, 0.0028, 0.325, "Loot All", 255, 255, 255, 255, 6, 0)
                end
                if next(PolarItemList) then
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
                if table.count(PolarItemList) > x then
                    DrawAdvancedText(0.528, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.412, 0.432, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        local S = math.floor(table.count(PolarItemList) / x)
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
                inGUIPolar = true
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
                    for X, Y in pairs(sortAlphabetically(PolarSecondItemList)) do
                        W = W + Y["value"].amount * Y["value"].Weight
                    end
                    local Z = K(PolarSecondItemList, w)
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
                    if table.count(PolarSecondItemList) > x then
                        DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.735, 0.755, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            local S = math.floor(table.count(PolarSecondItemList) / x)
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
                                    TriggerServerEvent("Polar:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    Polarserver.useInventoryItem({b})
                                else
                                    tPolar.notify("~r~No item selected!")
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
                                    TriggerServerEvent("Polar:UseAllItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    Polarserver.useInventoryItem({b})
                                else
                                    tPolar.notify("~r~No item selected!")
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
                                    TriggerServerEvent("Polar:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                else
                                    tPolar.notify("~r~No item selected!")
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
                                    if tPolar.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("Polar:MoveItem", "Plr", a, r, false)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("Polar:MoveItem", "Plr", a, "home", false)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("Polar:MoveItem", "Plr", a, "crate", false)
                                        elseif s then
                                            TriggerServerEvent("Polar:MoveItem", "Plr", a, "LootBag", true)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("Polar:MoveItem", inventoryType, b, r, false)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("Polar:MoveItem", inventoryType, b, "home", false)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("Polar:MoveItem", inventoryType, b, "crate", false)
                                    else
                                        TriggerServerEvent("Polar:MoveItem", "LootBag", b, LootBagIDNew, true)
                                    end
                                else
                                    tPolar.notify("~r~No item selected!")
                                end
                            else
                                tPolar.notify("~r~No second inventory available!")
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
                                    if tPolar.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("Polar:MoveItemX", "Plr", a, r, false, a3)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("Polar:MoveItemX", "Plr", a, "home", false, a3)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("Polar:MoveItemX", "Plr", a, "crate", false, a3)
                                        elseif s then
                                            TriggerServerEvent("Polar:MoveItemX", "Plr", a, "LootBag", true, a3)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("Polar:MoveItemX", inventoryType, b, r, false, a3)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("Polar:MoveItemX", inventoryType, b, "home", false, a3)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("Polar:MoveItemX", inventoryType, b, "crate", false, a3)
                                    else
                                        TriggerServerEvent("Polar:MoveItemX", "LootBag", b, LootBagIDNew, true, a3)
                                    end
                                else
                                    tPolar.notify("~r~No item selected!")
                                end
                            else
                                tPolar.notify("~r~No second inventory available!")
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
                                    local K = tPolar.getSpaceInSecondChest()
                                    local a3 = k
                                    if k * selectedItemWeight > K then
                                        a3 = math.floor(K / selectedItemWeight)
                                    end
                                    if a3 > 0 then
                                        if tPolar.getPlayerCombatTimer() > 0 then
                                            notify("~r~You can not store items whilst in combat.")
                                        else
                                            if inventoryType == "CarBoot" then
                                                TriggerServerEvent(
                                                    "Polar:MoveItemAll",
                                                    "Plr",
                                                    a,
                                                    r,
                                                    NetworkGetNetworkIdFromEntity(tPolar.getNearestVehicle(3))
                                                )
                                            elseif inventoryType == "Housing" then
                                                TriggerServerEvent("Polar:MoveItemAll", "Plr", a, "home")
                                            elseif inventoryType == "Crate" then
                                                TriggerServerEvent("Polar:MoveItemAll", "Plr", a, "crate")
                                            elseif s then
                                                TriggerServerEvent("Polar:MoveItemAll", "Plr", a, "LootBag")
                                            end
                                        end
                                    else
                                        tPolar.notify("~r~Not enough space in secondary chest!")
                                    end
                                elseif b and g ~= nil and c then
                                    local L = tPolar.getSpaceInFirstChest()
                                    local a3 = k
                                    if k * selectedItemWeight > L then
                                        a3 = math.floor(L / selectedItemWeight)
                                    end
                                    if a3 > 0 then
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent(
                                                "Polar:MoveItemAll",
                                                inventoryType,
                                                b,
                                                r,
                                                NetworkGetNetworkIdFromEntity(tPolar.getNearestVehicle(3))
                                            )
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("Polar:MoveItemAll", inventoryType, b, "home")
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("Polar:MoveItemAll", inventoryType, b, "crate")
                                        else
                                            TriggerServerEvent("Polar:MoveItemAll", "LootBag", b, LootBagIDNew)
                                        end
                                    else
                                        tPolar.notify("~r~Not enough space in secondary chest!")
                                    end
                                else
                                    tPolar.notify("~r~No item selected!")
                                end
                            else
                                tPolar.notify("~r~No second inventory available!")
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
                                TriggerServerEvent("Polar:GiveItem", a, "Plr")
                            elseif b then
                                Polarserver.giveToNearestPlayer({b})
                            else
                                tPolar.notify("~r~No item selected!")
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
                                TriggerServerEvent("Polar:LootItemAll", LootBagIDNew)
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
                if next(PolarItemList) then
                    if CursorInArea(0.233854, 0.282813, 0.287037, 0.308333) then
                        DrawRect(0.2600, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("Polar:EquipAll")
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
                                TriggerServerEvent("Polar:TrashItem", a, "Plr")
                            elseif b then
                                tPolar.notify("~r~Please move the item to your inventory to trash")
                            else
                                tPolar.notify("~r~No item selected!")
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
                local a4 = sortAlphabetically(PolarItemList)
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
            if GetEntityHealth(tPolar.getPlayerPed()) <= 102 then
                PolarSecondItemList = {}
                c = false
                drawInventoryUI = false
                inGUIPolar = false
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
                    tPolar.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    inventoryType = nil
                end
            end
            if drawInventoryUI then
                if
                    tPolar.isInComa() or
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
                    TriggerEvent("Polar:InventoryOpen", false)
                    if p then
                        tPolar.vc_closeDoor(q, 5)
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
RegisterNetEvent("Polar:InventoryOpen")
AddEventHandler(
    "Polar:InventoryOpen",
    function(a6, a7, a8)
        s = a7
        LootBagIDNew = a8
        if a6 and not i then
            drawInventoryUI = true
            setCursor(1)
            inGUIPolar = true
        else
            drawInventoryUI = false
            setCursor(0)
            PolarSecondItemList = {}
            inGUIPolar = false
            inventoryType = nil
            local a9 = PlayerPedId()
            local W = GetEntityCoords(a9)
            ClearPedTasks(a9)
            ForcePedAiAndAnimationUpdate(a9, false, false)
            if tPolar.getPlayerVehicle() == 0 then
                SetEntityCoordsNoOffset(a9, W.x, W.y, W.z + 0.1, true, false, false)
            end
        end
    end
)
function tPolar.setInventoryColour()
    tPolar.clientPrompt(
        "Enter rgb value eg 255,100,150:",
        "",
        function(a9)
            if a9 ~= "" then
                local H = stringsplit(a9, ",")
                if H[1] ~= nil and H[2] ~= nil and H[3] ~= nil then
                    o.r = tonumber(H[1])
                    o.g = tonumber(H[2])
                    o.b = tonumber(H[3])
                    tPolar.notify("~g~Inventory colour updated.")
                else
                    tPolar.notify("~r~Invalid value")
                end
            else
                tPolar.notify("~r~Invalid value")
            end
            SetResourceKvp("Polar_gang_inv_colour", json.encode(o))
        end
    )
end
