turfData = {
    {name = 'Weed', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- weed
    {name = 'Cocaine', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- cocaine
    {name = 'Meth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- meth
    {name = 'Heroin', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- heroin
    {name = 'LargeArms', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- large arms
    {name = 'LSDNorth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0}, -- lsd north
    {name = 'LSDSouth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300, cooldown = 0} -- lsd south
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(turfData) do
            if v.cooldown > 0 then
                v.cooldown = v.cooldown - 1
            end
        end
    end
end)

RegisterNetEvent('Polar:refreshTurfOwnershipData')
AddEventHandler('Polar:refreshTurfOwnershipData', function()
    local source = source
	local user_id = Polar.getUserId(source)
	local data = turfData
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for a,b in pairs(data) do
			data[a].ownership = false
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I then
						if b.gangOwner == V.gangname then
							data[a].ownership = true
						end
						TriggerClientEvent('Polar:updateTurfOwner', source, a, b.gangOwner)
					end
				end
			end
		end
		TriggerClientEvent('Polar:gotTurfOwnershipData', source, data)
		TriggerClientEvent('Polar:recalculateLargeArms', source, turfData[5].commission)
		Polar.updateTraderInfo()
	end)
end)

RegisterNetEvent('Polar:checkTurfCapture')
AddEventHandler('Polar:checkTurfCapture', function(turfid)
    local source = source
	local user_id = Polar.getUserId(source)
	if not Polar.hasPermission(user_id, 'police.onduty.permission') or not Polar.hasPermission(user_id, 'nhs.onduty.permission') then
		if turfData[turfid].cooldown > 0 then 
			Polarclient.notify(source, {'~r~This turf is on cooldown for another '..turfData[turfid].cooldown..' seconds.'})
			return
		end
		exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				local array = json.decode(V.gangmembers)
				for I,L in pairs(array) do
					if tostring(user_id) == I then
						if turfData[turfid].gangOwner == V.gangname then
							TriggerClientEvent('Polar:captureOwnershipReturned', source, turfid, true, turfData[turfid].name)
						else
							TriggerClientEvent('Polar:captureOwnershipReturned', source, turfid, false, turfData[turfid].name)
						end
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('Polar:gangDefenseLocationUpdate')
AddEventHandler('Polar:gangDefenseLocationUpdate', function(turfname, atkdfnd, trueorfalse)
    local source = source
	local user_id = Polar.getUserId(source)
	local turfID = 0
	for k,v in pairs(turfData) do
		if v.name == turfname then
			turfID = k
		end
	end
	if atkdfnd == 'Attackers' then
		if trueorfalse then
			turfData[turfID].beingCaptured = false
			turfData[turfID].timeLeft = 300
			TriggerClientEvent('chatMessage', -1, "^0The "..turfData[turfID].name.." trader is no longer being captured.", { 128, 128, 128 }, message, "alert")
		end
	elseif atkdfnd == 'Defenders' then
		if trueorfalse then
			turfData[turfID].beingCaptured = true
			turfData[turfID].timeLeft = turfData[turfID].timeLeft - 1
			TriggerClientEvent('Polar:setBlockedStatus', -1, turfname, true)
		else
			turfData[turfID].beingCaptured = false
			turfData[turfID].timeLeft = 300
			TriggerClientEvent('chatMessage', -1, "^0The "..turfData[turfID].name.." is no longer being captured.", { 128, 128, 128 }, message, "alert")
		end
	end
	
end)

RegisterNetEvent('Polar:failCaptureTurfOwned')
AddEventHandler('Polar:failCaptureTurfOwned', function(x)
    local source = source
	local user_id = Polar.getUserId(source)
end)

RegisterNetEvent('Polar:initiateGangCapture')
AddEventHandler('Polar:initiateGangCapture', function(x,y)
    local source = source
	local user_id = Polar.getUserId(source)
	if not Polar.hasPermission(user_id, 'police.onduty.permission') or not Polar.hasPermission(user_id, 'nhs.onduty.permission') then
		if not turfData[x].beingCaptured then
			exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
				for K,V in pairs(gotGangs) do
					for I,L in pairs(json.decode(V.gangmembers)) do
						if tostring(user_id) == I then
							TriggerClientEvent('Polar:initiateGangCaptureCheck', source, y, true)
							turfData[x].beingCaptured = true 
							TriggerClientEvent('chatMessage', -1, "^0The "..turfData[x].name.." trader is being attacked by "..V.gangname..".", { 128, 128, 128 }, message, "alert")
							if turfData[x].gangOwner ~= 'N/A' then
								exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
									for K,V in pairs(gotGangs) do
										if V.gangname == turfData[x].gangOwner then
											for I,L in pairs(json.decode(V.gangmembers)) do
												if Polar.getUserSource(I) ~= nil then
													TriggerClientEvent('Polar:defendGangCapture', Polar.getUserSource(I))
												end
											end
										end
									end
								end)
							end
						end
					end
				end
			end)
		else
			Polarclient.notify(source, {'~r~This turf is currently being captured.'})
		end
	else
		Polarclient.notify(source, {'~r~You cannot capture a turf while on duty.'})
	end
end)

RegisterNetEvent('Polar:gangCaptureSuccess')
AddEventHandler('Polar:gangCaptureSuccess', function(turfname)
    local source = source
	local user_id = Polar.getUserId(source)
	for k,v in pairs(turfData) do
		if v.name == turfname then
			exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
				for K,V in pairs(gotGangs) do
					for I,L in pairs(json.decode(V.gangmembers)) do
						if tostring(user_id) == I then
							TriggerClientEvent('chatMessage', -1, "^0The "..v.name.." trader has been captured by "..V.gangname..".", { 128, 128, 128 }, message, "alert")
							for a,b in pairs(json.decode(V.gangmembers)) do
								turfData[k].gangOwner = V.gangname
								turfData[k].commission = V.commission
								turfData[k].cooldown = 300
								turfData[k].beingCaptured = false
								local data = turfData
								data[k].ownership = true
								TriggerClientEvent('Polar:updateTurfOwner', -1, k, V.gangname)
								if Polar.getUserSource(tonumber(a)) ~= nil then
									TriggerClientEvent('Polar:gotTurfOwnershipData', Polar.getUserSource(tonumber(a)), data)
								end
							end
						end
					end
				end
			end)
		end
	end
end)

RegisterNetEvent('Polar:gangDefenseSuccess')
AddEventHandler('Polar:gangDefenseSuccess', function(turfname)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I then
					for a,b in pairs(turfData) do
						if b.name == turfname then
							TriggerClientEvent('chatMessage', -1, "^0The "..b.name.." trader is no longer being attacked.", { 128, 128, 128 }, message, "alert")
							turfData[a] = {ownership = true, gangOwner = V.gangname, commission = b.commission, cooldown = 300, beingCaptured = false}
							TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
							return
						end
					end
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewWeedPrice')
AddEventHandler('Polar:setNewWeedPrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[1].gangOwner then
					turfData[1].commission = price
					TriggerClientEvent('chatMessage', -1, "^0Weed trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewCocainePrice')
AddEventHandler('Polar:setNewCocainePrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[2].gangOwner then
					turfData[2].commission = price
					TriggerClientEvent('chatMessage', -1, "^0Cocaine trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewMethPrice')
AddEventHandler('Polar:setNewMethPrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[3].gangOwner then
					turfData[3].commission = price
					TriggerClientEvent('chatMessage', -1, "^0Meth trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewHeroinPrice')
AddEventHandler('Polar:setNewHeroinPrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[4].gangOwner then
					turfData[4].commission = price
					TriggerClientEvent('chatMessage', -1, "^0Heroin trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewLargeArmsCommission')
AddEventHandler('Polar:setNewLargeArmsCommission', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[5].gangOwner then
					turfData[5].commission = price
					TriggerClientEvent('chatMessage', -1, "^0Large Arms trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					TriggerClientEvent('Polar:recalculateLargeArms', -1, price)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewLSDNorthPrice')
AddEventHandler('Polar:setNewLSDNorthPrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[6].gangOwner then
					turfData[6].commission = price
					TriggerClientEvent('chatMessage', -1, "^0LSD North trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

RegisterNetEvent('Polar:setNewLSDSouthPrice')
AddEventHandler('Polar:setNewLSDSouthPrice', function(price)
    local source = source
	local user_id = Polar.getUserId(source)
	exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I and V.gangname == turfData[7].gangOwner then
					turfData[7].commission = price
					TriggerClientEvent('chatMessage', -1, "^0LSD South trader commission set to "..price.."%", { 128, 128, 128 }, message, "alert")
					Polar.updateTraderInfo()
					TriggerClientEvent('Polar:gotTurfOwnershipData', -1, turfData)
					return
				end
			end
		end
	end)
end)

function Polar.turfSaleToGangFunds(amount, drugtype)
	for k,v in pairs(turfData) do
		if v.name == drugtype then
			exports['ghmattimysql']:execute('SELECT * FROM Polar_gangs', function(gotGangs)
				for a,b in pairs(gotGangs) do
					if v.gangOwner == b.gangname then
						if drugtype ~= 'LargeArms' then
							amount = amount*(v.commission/100)/(1-v.commission/100)
						else
							if v.commission == nil then
								v.commission = 0
							end
							amount = amount/(1+v.commission)
						end
						exports['ghmattimysql']:execute('UPDATE Polar_gangs SET funds = funds+@funds WHERE gangname = @gangname', {funds = amount, gangname = b.gangname})
					end
				end
			end)
		end
	end
end