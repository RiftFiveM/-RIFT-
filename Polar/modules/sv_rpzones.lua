local rpZones = {}
local numRP = 0
RegisterServerEvent("Polar:createRPZone")
AddEventHandler("Polar:createRPZone", function(a)
	local source = source
	local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('Polar:createRPZone', -1, a)
    end
end)

RegisterServerEvent("Polar:removeRPZone")
AddEventHandler("Polar:removeRPZone", function(b)
	local source = source
	local user_id = Polar.getUserId(source)
    if Polar.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('Polar:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("Polar:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('Polar:createRPZone', source, rpZones)
        end
    end
end)
