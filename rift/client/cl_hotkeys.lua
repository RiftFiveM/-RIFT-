function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlPressed(1, 19) and IsControlJustPressed(1, 90) then
			local b = GetClosestPlayer(3)
			if b then
				targetSrc = GetPlayerServerId(b)
				if targetSrc > 0 then
					TriggerServerEvent("RIFT:dragPlayer", targetSrc)
				end
			end
			Wait(1000)
		end
	    if IsControlPressed(1, 19) and IsDisabledControlJustPressed(1,185) then -- LEFTALT + F
			TriggerServerEvent('RIFT:ejectFromVehicle')
            Wait(1000)
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1, 58) and IsPedArmed(tRIFT.getPlayerPed(), 7) and not tRIFT.isPurge() then
			local c = GetSelectedPedWeapon(tRIFT.getPlayerPed())
			if c ~= GetHashKey("WEAPON_UNARMED") then
				local d = GetWeapontypeGroup(c)
				if d ~= GetHashKey("GROUP_UNARMED") and d ~= GetHashKey("GROUP_MELEE") and d ~= GetHashKey("GROUP_THROWN") then
					if not inOrganHeist then
						TriggerServerEvent("RIFT:Knockout")
					end
				end
			end
			Wait(1000)
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,74) and (tRIFT.isDev()) then -- LEFTALT + H
			Wait(1000)
			local e = "melee@unarmed@streamed_variations"
			local f = "plyr_takedown_front_headbutt"
			local g = tRIFT.getPlayerPed()
			if DoesEntityExist(g) and not IsEntityDead(g) then
				loadAnimDict(e)
				if IsEntityPlayingAnim(g, e, f, 3) then
					TaskPlayAnim(g, e, "exit", 3.0, 1.0, -1, 0, 0, 0, 0, 0)
					ClearPedSecondaryTask(g)
				else
					TaskPlayAnim(g, e, f, 3.0, 1.0, -1, 0, 0, 0, 0, 0)
				end
				RemoveAnimDict(e)
			end
			TriggerServerEvent("RIFT:KnockoutNoAnim")
			Wait(1000)
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,32) then 
			if not IsPauseMenuActive() and not IsPedInAnyVehicle(tRIFT.getPlayerPed(), true) and not IsPedSwimming(tRIFT.getPlayerPed()) and not IsPedSwimmingUnderWater(tRIFT.getPlayerPed()) and not IsPedShooting(tRIFT.getPlayerPed()) and not IsPedDiving(tRIFT.getPlayerPed()) and not IsPedFalling(tRIFT.getPlayerPed()) and GetEntityHealth(tRIFT.getPlayerPed()) > 105 and not tRIFT.isHandcuffed() and not tRIFT.isInRadioChannel() then
				tRIFT.playAnim(true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false)
			end 
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,29) then -- LEFTALT + B
			if not IsPedInAnyVehicle(tRIFT.getPlayerPed(),false) then
				local closestPlayer = tRIFT.GetClosestPlayer(4)
				local doesTargetHaveHandsUp = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missminuteman_1ig_2', 'handsup_enter', 3)
				if doesTargetHaveHandsUp then
					TriggerServerEvent("RIFT:requestPlaceBagOnHead") -- need to do inventory checks and shit
				else
					drawNativeNotification("Player must have his hands up!")
				end
			end
		end
	end
end)