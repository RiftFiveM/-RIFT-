local cfg = module("cfg/cfg_radios")

local function getRadioType(user_id)
    if Polar.hasPermission(user_id, "police.onduty.permission") then
        return "Police"
    elseif Polar.hasPermission(user_id, "nhs.onduty.permission") then
        return "NHS"
    elseif Polar.hasPermission(user_id, "prisonguard.onduty.permission") then
        return "HMP"
    elseif Polar.hasPermission(user_id, "lfb.onduty.permission") then
        return "LFB"
    end
    return false
end

local radioChannels = {
    ['Police'] = {
        name = 'Police',
        players = {},
        channel = 1,
        callsign = true,
    },
    ['NHS'] = {
        name = 'NHS',
        players = {},
        channel = 2,
        callsign = false,
    },
    ['Staff'] = {
        name = 'Staff',
        players = {},
        channel = 4,
        callsign = false,
    },
    ['LFB'] = {
        name = 'LFB',
        players = {},
        channel = 5,
        callsign = false,
    },
}

function createRadio(source)
    local source = source
    local user_id = Polar.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        Wait(1000)
        for k,v in pairs(cfg.sortOrder[radioType]) do
            if Polar.hasPermission(user_id, v) then
                local sortOrder = k
                local name = GetPlayerName(source)
                if radioChannels[radioType].callsign then
                    name = name.." ["..getCallsign(radioType, source, user_id, radioType).."]"
                end
                radioChannels[radioType]['players'][source] = {name = name, sortOrder = sortOrder}
                TriggerClientEvent('Polar:radiosCreateChannel', source, radioChannels[radioType].channel, radioChannels[radioType].name, radioChannels[radioType].players, true)
                TriggerClientEvent('Polar:radiosAddPlayer', -1, radioChannels[radioType].channel, source, {name = name, sortOrder = sortOrder})
            end
        end
    end
end

function removeRadio(source)
    for a,b in pairs(radioChannels) do
        if next(radioChannels[a]['players']) then
            for k,v in pairs(radioChannels[a]['players']) do
                if k == source then
                    TriggerClientEvent('Polar:radiosRemovePlayer', -1, radioChannels[a].channel, k)
                    radioChannels[a]['players'][source] = nil
                end
            end
        end
    end
end

RegisterServerEvent("Polar:clockedOnCreateRadio")
AddEventHandler("Polar:clockedOnCreateRadio", function(source)
    local source = source
    createRadio(source)
end)

RegisterServerEvent("Polar:clockedOffRemoveRadio")
AddEventHandler("Polar:clockedOffRemoveRadio", function(source)
    local source = source
    removeRadio(source)
end)

AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    createRadio(source)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    removeRadio(source)
end)

RegisterServerEvent("Polar:radiosSetIsMuted")
AddEventHandler("Polar:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = Polar.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(radioChannels[radioType]['players']) do
            if k == source then
                TriggerClientEvent('Polar:radiosSetPlayerIsMuted', -1, radioChannels[radioType].channel, k, mutedState)
            end
        end
    end
end)