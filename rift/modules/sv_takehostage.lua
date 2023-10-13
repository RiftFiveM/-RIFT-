local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("RIFT:takeHostageSync")
AddEventHandler("RIFT:takeHostageSync", function(targetSrc)
	local source = source
	TriggerClientEvent("RIFT:takeHostageSyncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("RIFT:takeHostageReleaseHostage")
AddEventHandler("RIFT:takeHostageReleaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("RIFT:takeHostageReleaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("RIFT:takeHostageKillHostage")
AddEventHandler("RIFT:takeHostageKillHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("RIFT:takeHostageKillHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("RIFT:takeHostageStop")
AddEventHandler("RIFT:takeHostageStop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("RIFT:takeHostageCl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("RIFT:takeHostageCl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("RIFT:takeHostageCl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end
	if takenHostage[source] then
		TriggerClientEvent("RIFT:takeHostageCl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)