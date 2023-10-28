local lookup = {
    ["PolarELS:changeStage"] = "PolarELS:1",
    ["PolarELS:toggleSiren"] = "PolarELS:2",
    ["PolarELS:toggleBullhorn"] = "PolarELS:3",
    ["PolarELS:patternChange"] = "PolarELS:4",
    ["PolarELS:vehicleRemoved"] = "PolarELS:5",
    ["PolarELS:indicatorChange"] = "PolarELS:6"
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
        exports["Polar"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end