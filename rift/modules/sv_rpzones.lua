local rpZones = {}
local numRP = 0
RegisterServerEvent("RIFT:createRPZone")
AddEventHandler("RIFT:createRPZone", function(a)
	local source = source
	local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('RIFT:createRPZone', -1, a)
    end
end)

RegisterServerEvent("RIFT:removeRPZone")
AddEventHandler("RIFT:removeRPZone", function(b)
	local source = source
	local user_id = RIFT.getUserId(source)
    if RIFT.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('RIFT:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("RIFT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('RIFT:createRPZone', source, rpZones)
        end
    end
end)
