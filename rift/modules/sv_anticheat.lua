local f = module("rift-weapons", "cfg/weapons")
f=f.weapons

local gettingVideo = false

local actypes = {
    {type = 1, desc = 'Noclip'},
    {type = 2, desc = 'Spawning of Weapon(s)'},
    {type = 3, desc = 'Explosion Event'},
    {type = 4, desc = 'Blacklisted Event'},
    {type = 5, desc = 'Removal of Weapon(s)'},
    {type = 6, desc = 'Semi Godmode'},
    {type = 7, desc = 'Mod Menu'},
    {type = 8, desc = 'Weapon Modifier'},
    {type = 9, desc = 'Armour Modifier'},
    {type = 10, desc = 'Health Modifier'},
    {type = 11, desc = 'Server Trigger'},
    {type = 12, desc = 'Vehicle Modifications'}, --- using fg not server
    {type = 13, desc = 'Night Vision'},
    {type = 14, desc = 'Model Dimensions'},
    {type = 15, desc = 'Godmoding'},
    {type = 16, desc = 'Failed Keep Alive (screenshot-basic)'},
    {type = 17, desc = 'Spawned Ammo'},
    {type = 18, desc = 'Resource Injection'},
    {type = 19, desc = 'Infinite Combat Roll'},
    {type = 20, desc = 'Well i did Warn you'},
}

RegisterServerEvent("RIFT:acType1")
AddEventHandler("RIFT:acType1", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local name = GetPlayerName(source)
    if not table.includes(carrying, source) then
        Wait(500)
        TriggerEvent("RIFT:acBan", user_id, 1, name, source)
    end
end)


function table.includes(table,p)
    for q,r in pairs(table)do 
        if r==p then 
            return true 
        end 
    end
    return false 
end

local a8 = false

function tRIFT.isSpectatingEvent()
    return a8
end


local BlockedExplosions = {--0, 
1, 2, --4, 
5, --25, 
32, 33, 35, 35, 36, 37, 38, 45}
AddEventHandler('explosionEvent', function(source, ev)
    local source = source
    local user_id = RIFT.getUserId(source)
    local name = GetPlayerName(source)
    for k, v in ipairs(BlockedExplosions) do 
        if ev.explosionType == v then
            ev.damagescale = 0.0
            CancelEvent()
            Wait(500)
            TriggerEvent("RIFT:acBan", user_id, 3, name, source, 'Explosion Type: '..ev.explosionType)
        end
    end
end)

local BlacklistedEvents = {
    "esx:getSharedObject",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    "esx_dmvschool:pay"
}

for i, eventName in ipairs(BlacklistedEvents) do
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function()
        local source = source
        local user_id = RIFT.getUserId(source)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("RIFT:acBan", user_id, 4, name, source, 'Event: '..eventName)
    end)
end

AddEventHandler('removeWeaponEvent', function(pedid, weaponType)
    CancelEvent()
    local source = pedid
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 5, name, source)
end)

AddEventHandler("giveWeaponEvent", function(source)
    CancelEvent()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 5, name, source)
end)

AddEventHandler("removeAllWeaponsEvent", function(source)
    CancelEvent()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 5, name, plasourceyer)
end)

RegisterServerEvent("RIFT:acType6")
AddEventHandler("RIFT:acType6", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 6, name, source)
end)

RegisterServerEvent("RIFT:acType7")
AddEventHandler("RIFT:acType7", function(modmenu)
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 7, name, source, modmenu)
end)

RegisterServerEvent("RIFT:acType8")
AddEventHandler("RIFT:acType8", function(extra)
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 8, name, source, extra)
end)

RegisterServerEvent("RIFT:acType9")
AddEventHandler("RIFT:acType9", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 9, name, source)
end)

RegisterServerEvent("RIFT:acType10")
AddEventHandler("RIFT:acType10", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 10, name, source)
end)

RegisterServerEvent("RIFT:acType11")
AddEventHandler("RIFT:acType11", function(extra)
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 11, name, source, extra)
end)

RegisterServerEvent("RIFT:acType13")
AddEventHandler("RIFT:acType13", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 13, name, source)
end)

RegisterServerEvent("RIFT:acType14")
AddEventHandler("RIFT:acType14", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    --TriggerEvent("RIFT:acBan", user_id, 14, name, source)
end)

local godmodeVid = false
RegisterServerEvent("RIFT:acType15")
AddEventHandler("RIFT:acType15", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    if not godmodeVid then
        TriggerClientEvent("RIFT:takeClientVideoAndUpload", source, tRIFT.getWebhook('anticheat'))
        Wait(25000)
        godmodeVid = true
    end
    godmodeVid = false
    tRIFT.sendWebhook('anticheat', 'Anticheat Log', "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **Type #15**\n> Type Meaning: **Godmoding**")
end)

RegisterServerEvent("RIFT:acType16")
AddEventHandler("RIFT:acType16", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    TriggerEvent("RIFT:acBan", user_id, 16, name, source)
end)

RegisterServerEvent("RIFT:acType17")
AddEventHandler("RIFT:acType17", function(weapon)
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 17, name, source, weapon)
end)

RegisterServerEvent("RIFT:acType18")
AddEventHandler("RIFT:acType18", function(resource)
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    if resource == 'fivem-map-hipster' then return end
    TriggerEvent("RIFT:acBan", user_id, 18, name, source, resource)
end)

RegisterServerEvent("RIFT:acType19")
AddEventHandler("RIFT:acType19", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 19, name, source)
end)

RegisterServerEvent("RIFT:acType20")
AddEventHandler("RIFT:acType20", function()
    local source = source
    local user_id = RIFT.getUserId(source)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("RIFT:acBan", user_id, 20, name, source)
end)

RegisterServerEvent("RIFT:acBan")
AddEventHandler("RIFT:acBan",function(user_id, bantype, name, player, extra)
    local desc = ''
    local reason = ''
    if extra == nil then extra = 'None' end
    if user_id == 1 then 
        print('Ban Type: '..bantype, 'Name: '..name, 'Extra: '..extra)
        return 
    end
    if source == '' then
        if not gettingVideo then
            for k,v in pairs(actypes) do
                if bantype == v.type then
                    reason = 'Type #'..bantype
                    desc = v.desc
                end
            end
            gettingVideo = true
            TriggerClientEvent("RIFT:takeClientVideoAndUpload", player, tRIFT.getWebhook('anticheat'))
            Wait(25000)
            gettingVideo = false
            tRIFT.sendWebhook('anticheat', 'Anticheat Ban', "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **"..reason.."**\n> Type Meaning: **"..desc.."**\n> Extra Info: **"..extra.."**")
            TriggerClientEvent("chatMessage", -1, "^7^*[RIFT Anticheat]", {180, 0, 0}, name .. " ^7 Was Banned | Reason: Cheating "..reason, "alert")
            RIFT.banConsole(user_id,"perm","Cheating "..reason)
            exports['ghmattimysql']:execute("INSERT INTO `rift_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);", {user_id = user_id, username = name, reason = reason, extra = extra}, function() end) 
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
    CREATE TABLE IF NOT EXISTS `rift_anticheat` (
    `ban_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(100) NOT NULL,
    `extra` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ban_id`)
    );]])
    print("[RIFT] ^2Anticheat tables initialised.^0")
end)
