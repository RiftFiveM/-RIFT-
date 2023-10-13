local lookup = {
    ["RIFTELS:changeStage"] = "RIFTELS:1",
    ["RIFTELS:toggleSiren"] = "RIFTELS:2",
    ["RIFTELS:toggleBullhorn"] = "RIFTELS:3",
    ["RIFTELS:patternChange"] = "RIFTELS:4",
    ["RIFTELS:vehicleRemoved"] = "RIFTELS:5",
    ["RIFTELS:indicatorChange"] = "RIFTELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["rift"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end