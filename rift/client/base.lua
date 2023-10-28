cfg = module("cfg/client")

tPolar = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("Polar",tPolar)

-- get server interface
Polarserver = Tunnel.getInterface("Polar","Polar")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("Polar",tPolar)

allowedWeapons = {}
weapons = module("Polar-weapons", "cfg/weapons")
function tPolar.allowWeapon(name)
  if allowedWeapons[name] then
    return
  else
    allowedWeapons[name] = true
  end
end

function tPolar.removeWeapon(name)
  if allowedWeapons[name] then
    allowedWeapons[name] = nil
  end
end

function tPolar.ClearWeapons()
  allowedWeapons = {}
end


function tPolar.checkWeapon(name)
  if allowedWeapons[name] == nil then
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
    TriggerEvent("Polar:acBan", user_id, 11, name, player, 'Attempted to spawn a weapon')
    return
  end
end



Citizen.CreateThread(function()
  while true do 
    Wait(300)
    for k,v in pairs(weapons.weapons) do 
      if GetHashKey(k) then
        if HasPedGotWeapon(PlayerPedId(),GetHashKey(k),false) then   
          tPolar.checkWeapon(k)
        end
      end
    end
  end
end)


-- functions

function tPolar.isDevMode()
  if tPolar.isDev() then
      return true
  else
      return false
  end
end

function tPolar.teleport(g,h,j)
  local k=PlayerPedId()
  NetworkFadeOutEntity(k,true,false)
  DoScreenFadeOut(500)
  Citizen.Wait(500)
  SetEntityCoords(tPolar.getPlayerPed(),g+0.0001,h+0.0001,j+0.0001,1,0,0,1)
  NetworkFadeInEntity(k,0)
  DoScreenFadeIn(500)
end

function tPolar.teleport2(l,m)
  local k=PlayerPedId()
  NetworkFadeOutEntity(k,true,false)
  if tPolar.getPlayerVehicle()==0 or not m then 
    SetEntityCoords(tPolar.getPlayerPed(),l.x,l.y,l.z,1,0,0,1)
  else 
    SetEntityCoords(tPolar.getPlayerVehicle(),l.x,l.y,l.z,1,0,0,1)
  end
  Wait(500)
  NetworkFadeInEntity(k,0)
end

-- return x,y,z
function tPolar.getPosition()
  return GetEntityCoords(tPolar.getPlayerPed())
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tPolar.getDistanceBetweenCoords(x,y,z,x2,y2,z2)

local distance = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
  
  return distance
end

-- return false if in exterior, true if inside a building
function tPolar.isInside()
  local x,y,z = table.unpack(tPolar.getPosition())
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

local aWeapons=module("cfg/cfg_attachments")
function tPolar.getAllWeaponAttachments(weapon,Q)
  local R=PlayerPedId()
  local S={}
  if Q then 
      for T,U in pairs(aWeapons.attachments)do 
          if HasPedGotWeaponComponent(R,weapon,GetHashKey(U))and not table.has(givenAttachmentsToRemove[weapon]or{},U)then 
              table.insert(S,U)
          end 
      end 
  else 
      for T,U in pairs(aWeapons.attachments)do 
          if HasPedGotWeaponComponent(R,weapon,GetHashKey(U))then 
              table.insert(S,U)
          end 
      end 
  end
  return S 
end

-- return vx,vy,vz
function tPolar.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(PlayerPedId()))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tPolar.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end


function tPolar.addPlayer(player)
  players[player] = true
end

function tPolar.removePlayer(player)
  players[player] = nil
end

function tPolar.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = table.unpack(tPolar.getPosition())

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tPolar.getNearestPlayer(radius)
  local p = nil

  local players = tPolar.getNearestPlayers(radius)
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tPolar.getNearestPlayersFromPosition(coords, radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = table.unpack(coords)

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tPolar.notify(msg)
  if not globalHideUi then
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
  end
end


local function b(c,d,e)
  return c<d and d or c>e and e or c 
end

local function f(g)
  local h=math.floor(#g%99==0 and#g/99 or#g/99+1)
  local i={}
  for j=0,h-1 do 
      i[j+1]=string.sub(g,j*99+1,b(#string.sub(g,j*99),0,99)+j*99)
  end
  return i 
end

local function k(l,m)
  local n=f(l)
  SetNotificationTextEntry("CELL_EMAIL_BCON")
  for o,p in ipairs(n)do 
      AddTextComponentSubstringPlayerName(p)
  end
  if m then 
      local q=GetSoundId()
      PlaySoundFrontend(q,"police_notification","DLC_AS_VNT_Sounds",true)
      ReleaseSoundId(q)
  end 
end

function tPolar.notifyPicture(ay,az,l,ac,aA,aB,aC)
  if ay~=nil and az~=nil then 
      RequestStreamedTextureDict(ay,true)
      while not HasStreamedTextureDictLoaded(ay)do 
          Wait(0)
      end 
  end
  k(l,aB=="police")
  if aC==nil then 
      aC=0 
  end
  local aD=false
  EndTextCommandThefeedPostMessagetext(ay,az,aD,aC,ac,aA)
  local aE=true
  local aF=false
  EndTextCommandThefeedPostTicker(aF,aE)
  DrawNotification(false,true)
  if aB==nil then 
      PlaySoundFrontend(-1,"CHECKPOINT_NORMAL","HUD_MINI_GAME_SOUNDSET",1)
  end 
end

function tPolar.notifyPicture2(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tPolar.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tPolar.stopScreenEffect(name)
  StopScreenEffect(name)
end

local Q={}
local R={}
function tPolar.createArea(l,W,T,U,X,Y,Z,_)
  local V={position=W,radius=T,height=U,enterArea=X,leaveArea=Y,onTickArea=Z,metaData=_}
  if V.height==nil then 
      V.height=6 
  end
  Q[l]=V
  R[l]=V 
end
function tPolar.doesAreaExist(l)
  if Q[l] then
      return true
  end
  return false
end

function DrawText3D(a, b, c, d, e, f, g)
  local h, i, j = GetScreenCoordFromWorldCoord(a, b, c)
  if h then
      SetTextScale(0.4, 0.4)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText("STRING")
      SetTextCentre(1)
      AddTextComponentSubstringPlayerName(d)
      EndTextCommandDisplayText(i, j)
  end
end
function tPolar.add3DTextForCoord(d, a, b, c, k)
  local function l(m)
      DrawText3D(m.coords.x, m.coords.y, m.coords.z, m.text)
  end
  local n = tPolar.generateUUID("3dtext", 8, "alphanumeric")
  tPolar.createArea("3dtext_" .. n,vector3(a, b, c),k,6.0,function()
  end,
  function()
  end,l,{coords = vector3(a, b, c), text = d})
end

local UUIDs = {}

local uuidTypes = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789",
}

local function randIntKey(length,type)
    local index, pw, rnd = 0, "", 0
    local chars = {
        uuidTypes[type]
    }
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    return pw
end

function tPolar.generateUUID(key,length,type)
    if UUIDs[key] == nil then
        UUIDs[key] = {}
    end

    if type == nil then type = "alphanumeric" end

    local uuid = randIntKey(length,type)
    if UUIDs[key][uuid] then
        while UUIDs[key][uuid] ~= nil do
            uuid = randIntKey(length,type)
            Wait(0)
        end
    end
    UUIDs[key][uuid] = true
    return uuid
end

function tPolar.spawnVehicle(W,v,w,H,X,Y,Z,_)
  local a0=tPolar.loadModel(W)
  local a1=CreateVehicle(a0,v,w,H,X,Z,_)
  SetModelAsNoLongerNeeded(a0)
  SetEntityAsMissionEntity(a1)
  DecorSetInt(a1, "PolarACVeh", 955)
  SetModelAsNoLongerNeeded(a0)
  if Y then 
      TaskWarpPedIntoVehicle(PlayerPedId(),a1,-1)
  end
  setVehicleFuel(a1, 100)
  return a1 
end

local a2={}
Citizen.CreateThread(function()
    while true do 
        local b2={}
        b2.playerPed=tPolar.getPlayerPed()
        b2.playerCoords=tPolar.getPlayerCoords()
        b2.playerId=tPolar.getPlayerId()
        b2.vehicle=tPolar.getPlayerVehicle()
        b2.weapon=GetSelectedPedWeapon(b2.playerPed)
        for c2=1,#a2 do 
            local d2=a2[c2]
            d2(b2)
        end
        Wait(0)
    end 
end)
function tPolar.createThreadOnTick(d2)
    a2[#a2+1]=d2
end

local a = 0
local b = 0
local c = 0
local d = vector3(0, 0, 0)
local e = false
local f = PlayerPedId
function savePlayerInfo()
    a = f()
    b = GetVehiclePedIsIn(a, false)
    c = PlayerId()
    d = GetEntityCoords(a)
    local g = GetPedInVehicleSeat(b, -1)
    e = g == a
end
_G["PlayerPedId"] = function()
    return a
end
function tPolar.getPlayerPed()
    return a
end
function tPolar.getPlayerVehicle()
    return b, e
end
function tPolar.getPlayerId()
    return c
end
function tPolar.getPlayerCoords()
    return d
end

createThreadOnTick(savePlayerInfo)

function tPolar.getClosestVehicle(bm)
  local br = tPolar.getPlayerCoords()
  local bs = 100
  local bt = 100
  for T, bu in pairs(GetGamePool("CVehicle")) do
      local bv = GetEntityCoords(bu)
      local bw = #(br - bv)
      if bw < bt then
          bt = bw
          bs = bu
      end
  end
  if bt <= bm then
      return bs
  else
      return nil
  end
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will FRly loop the first element of the sequence until stopAnim is called
function tPolar.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/Polar/pull/118)
    tPolar.stopAnim(true)

    local ped = PlayerPedId()
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = table.unpack(tPolar.getPosition())
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tPolar.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(PlayerPedId(),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(PlayerPedId(),dict,name) <= 0.95 and IsEntityPlayingAnim(PlayerPedId(),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tPolar.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(PlayerPedId())
  else
    ClearPedTasks(PlayerPedId())
  end
end

-- RAGDOLL
local ragdoll = false

-- set player ragdoll flag (true or false)
function tPolar.setRagdoll(flag)
  ragdoll = flag
end

-- ragdoll thread
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if ragdoll then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tPolar.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tPolar.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

function tPolar.playFrontendSound(dict, name)
  PlaySoundFrontend(-1, dict, name, 0)
end

function tPolar.loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function tPolar.drawNativeNotification(A)
  SetTextComponentFormat('STRING')
  AddTextComponentString(A)
  DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function tPolar.announceMpBigMsg(I,J,K)
  local L=Scaleform("MP_BIG_MESSAGE_FREEMODE")
  L.RunFunction("SHOW_SHARD_WASTED_MP_MESSAGE",{I,J,0,false,false})
  local M=false
  SetTimeout(K,function()
      M=true 
  end)
  while not M do 
      L.Render2D()
      Wait(0)
  end 
end

local m=true
function tPolar.canAnim()
    return m 
end
function tPolar.setCanAnim(n)
    m=n 
end

function tPolar.getModelGender()
  local B=PlayerPedId()
  if GetEntityModel(B)==GetHashKey('mp_f_freemode_01')then 
      return"female"
  else 
      return"male"
  end 
end

function tPolar.getPedServerId(a5)
  local a6=GetActivePlayers()
  for T,U in pairs(a6)do 
      if a5==GetPlayerPed(U)then 
          local a7=GetPlayerServerId(U)
          return a7 
      end 
  end
  return nil 
end

function tPolar.loadModel(modelName)
  local modelHash
  if type(modelName) ~= "string" then
      modelHash = modelName
  else
      modelHash = GetHashKey(modelName)
  end
  if IsModelInCdimage(modelHash) then
      if not HasModelLoaded(modelHash) then
          RequestModel(modelHash)
          while not HasModelLoaded(modelHash) do
              Wait(0)
          end
      end
      return modelHash
  else
      return nil
  end
end

function tPolar.getObjectId(a_, aX)
  if aX == nil then
      aX = ""
  end
  local aL = 0
  local b0 = NetworkDoesNetworkIdExist(a_)
  if not b0 then
      print(string.format("no object by ID %s\n%s", a_, aX))
  else
      local b1 = NetworkGetEntityFromNetworkId(a_)
      aL = b1
  end
  return aL
end

function tPolar.KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(1) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(1)
		blockinput = false 
		return nil 
	end
end

function tPolar.syncNetworkId(a8)
  SetNetworkIdExistsOnAllMachines(a8,true)
  SetNetworkIdCanMigrate(a8,false)
  NetworkSetNetworkIdDynamic(a8,true)
end

RegisterNetEvent('__Polar_callback:client')
AddEventHandler('__Polar_callback:client',function(aJ,...)
    local aK=promise.new()
    TriggerEvent(string.format('c__Polar_callback:%s',aJ),function(...)
        aK:resolve({...})end,...)
    local aL=Citizen.Await(aK)
    TriggerServerEvent(string.format('__Polar_callback:server:%s:%s',aJ,...),table.unpack(aL))
end)
tPolar.TriggerServerCallback=function(aJ,...)
    assert(type(aJ)=='string','Invalid Lua type at argument #1, expected string, got '..type(aJ))
    local aK=promise.new()
    local aM=GetGameTimer()
    RegisterNetEvent(string.format('__Polar_callback:client:%s:%s',aJ,aM))
    local aN=AddEventHandler(string.format('__Polar_callback:client:%s:%s',aJ,aM),function(...)
        aK:resolve({...})
    end)
    TriggerServerEvent('__Polar_callback:server',aJ,aM,...)
    local aL=Citizen.Await(aK)
    RemoveEventHandler(aN)
    return table.unpack(aL)
end
tPolar.RegisterClientCallback=function(aJ,aO)
    assert(type(aJ)=='string','Invalid Lua type at argument #1, expected string, got '..type(aJ))
    assert(type(aO)=='function','Invalid Lua type at argument #2, expected function, got '..type(aO))
    AddEventHandler(string.format('c__Polar_callback:%s',aJ),function(aP,...)
        aP(aO(...))
    end)
end


Citizen.CreateThread(function()
  while true do
    SetVehicleDensityMultiplierThisFrame(0.0)
    SetPedDensityMultiplierThisFrame(0.0)
    SetRandomVehicleDensityMultiplierThisFrame(0.0)
    SetParkedVehicleDensityMultiplierThisFrame(0.0)
    SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed) 
    RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
    SetGarbageTrucks(0)
    SetRandomBoats(0)
    Citizen.Wait(1)
  end
end)

function tPolar.drawTxt(L, M, N, D, E, O, P, Q, R, S)
  SetTextFont(M)
  SetTextProportional(0)
  SetTextScale(O, O)
  SetTextColour(P, Q, R, S)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(N)
  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(L)
  EndTextCommandDisplayText(D, E)
end

function drawNativeText(V)
  if not globalHideUi then
      BeginTextCommandPrint("STRING")
      AddTextComponentSubstringPlayerName(V)
      EndTextCommandPrint(100, 1)
  end
end

function clearNativeText()
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName("")
  EndTextCommandPrint(1, true)
end


function tPolar.announceClient(d)
    if d~=nil then 
        CreateThread(function()
            local e=GetGameTimer()
            local scaleform=RequestScaleformMovie('MIDSIZED_MESSAGE')
            while not HasScaleformMovieLoaded(scaleform)do 
                Wait(0)
            end
            PushScaleformMovieFunction(scaleform,"SHOW_SHARD_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~g~Polar Announcement")
            PushScaleformMovieFunctionParameterString(d)
            PushScaleformMovieMethodParameterInt(5)
            PushScaleformMovieMethodParameterBool(true)
            PushScaleformMovieMethodParameterBool(false)
            EndScaleformMovieMethod()
            while e+6*1000>GetGameTimer()do 
                DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
                Wait(0)
            end 
        end)
    end 
end

AddEventHandler("mumbleDisconnected",function(f)
    tPolar.notify("~r~[Polar] Lost connection to voice server, you may need to toggle voice chat.")
end)

RegisterNetEvent("Polar:PlaySound")
AddEventHandler("Polar:PlaySound", function(soundname)
    SendNUIMessage({
        transactionType = soundname,
    })
end)

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("Polarcli:playerSpawned")
end)


TriggerServerEvent('Polar:CheckID')

RegisterNetEvent('Polar:CheckIdRegister')
AddEventHandler('Polar:CheckIdRegister', function()
    TriggerEvent('playerSpawned')
end)

function tPolar.clientGetPlayerIsStaff(permid)
  local currentStaff = tPolar.getCurrentPlayerInfo('currentStaff')
  if currentStaff then
      for a,b in pairs(currentStaff) do
          if b == permid then
              return true
          end
      end
      return false
  end
end

local baseplayers = {}

function tPolar.setBasePlayers(players)
  baseplayers = players
end

function tPolar.addBasePlayer(player, id)
  baseplayers[player] = id
end

function tPolar.removeBasePlayer(player)
  --baseplayers[player] = nil
end

local isDev = false
local user_id = nil
local stafflevel = 0
globalOnPoliceDuty = false
globalHorseTrained = false
globalNHSOnDuty = false
globalOnPrisonDuty = false
inHome = false
customizationSaveDisabled = false
function tPolar.setPolice(y)
  TriggerServerEvent("Polar:refreshGaragePermissions")
  globalOnPoliceDuty = y
  if y then
    TriggerServerEvent("Polar:getCallsign", "police")
  end
end
function tPolar.globalOnPoliceDuty()
  return globalOnPoliceDuty
end
function tPolar.setglobalHorseTrained()
  globalHorseTrained = true
end
function tPolar.globalHorseTrained()
  return globalHorseTrained
end
function tPolar.setHMP(x)
  TriggerServerEvent("Polar:refreshGaragePermissions")
  globalOnPrisonDuty = x
  if x then
    TriggerServerEvent("Polar:getCallsign", "prison")
  end
end
function tPolar.globalOnPrisonDuty()
  return globalOnPrisonDuty
end
function tPolar.setNHS(w)
  TriggerServerEvent("Polar:refreshGaragePermissions")
  globalNHSOnDuty = w
end
function tPolar.globalNHSOnDuty()
  return globalNHSOnDuty
end
function tPolar.setDev()
    isDev = true
end
function tPolar.isDev()
    return isDev
end
function tPolar.setUserID(a)
  user_id = a
end
function tPolar.getUserId(Z)
  if Z then
    return baseplayers[Z]
  else
    return user_id
  end
end
function tPolar.clientGetUserIdFromSource(bB)
  return bu[bB]
end
function tPolar.DrawSprite3d(data)
  local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
  local fov = (1 / GetGameplayCamFov()) * 250
  local scale = 0.3
  SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
  if not HasStreamedTextureDictLoaded(data.textureDict) then
      local timer = 1000
      RequestStreamedTextureDict(data.textureDict, true)
      while not HasStreamedTextureDictLoaded(data.textureDict) and timer > 0 do
          timer = timer-1
          Citizen.Wait(100)
      end
  end
  DrawSprite(data.textureDict,data.textureName,(data.x or 0) * scale,(data.y or 0) * scale,data.width * scale,data.height * scale,data.heading or 0,data.r or 0,data.g or 0,data.b or 0,data.a or 255)
  ClearDrawOrigin()
end
function tPolar.getTempFromPerm(bC)
  for d, e in pairs(baseplayers) do
      if e == bC then
          return d
      end
  end
end
function tPolar.clientGetUserIdFromSource(tempid)
  return baseplayers[tempid]
end
function tPolar.setStaffLevel(a)
  stafflevel = a
end
function tPolar.getStaffLevel()
  return stafflevel
end
function tPolar.isStaffedOn()
  return staffMode
end
function tPolar.isNoclipping()
  return noclipActive
end
function tPolar.setInHome(aretheyinthehome)
  inHome = aretheyinthehome
end
function tPolar.isInHouse()
  return inHome
end
function tPolar.disableCustomizationSave(yesno)
  customizationSaveDisabled = yesno
end
local ac = 0
function tPolar.getPlayerBucket()
    return ac
end
RegisterNetEvent("Polar:setBucket",function(ad)
    ac = ad
end)
function tPolar.isHalloween()
  return GetConvarInt("Polar_halloween", 0) == 1
end
function tPolar.isChristmas()
  return GetConvarInt("Polar_christmas", 0) == 1
end
function tPolar.isPurge()
  return PolarConfig.Purge
end
function tPolar.inEvent()
  return false
end
function tPolar.getRageUIMenuWidth()
  local w, h = GetActiveScreenResolution()

  if w == 1920 then
      return 1300
  elseif w == 1280 and h == 540 then
      return 1000
  elseif w == 2560 and h == 1080 then
      return 1050
  elseif w == 3440 and h == 1440 then
      return 1050
  end
  return 1300
end

function tPolar.getRageUIMenuHeight()
  return 100
end

RegisterNetEvent("Polar:requestAccountInfo")
AddEventHandler("Polar:requestAccountInfo", function()
    SendNUIMessage({act="requestAccountInfo"})
end)

RegisterNUICallback("receivedAccountInfo",function(a)
  TriggerServerEvent("Polar:receivedAccountInfo",a.gpu,a.cpu,a.userAgent)
end)

function tPolar.getHairAndTats()
  TriggerServerEvent('Polar:getPlayerHairstyle')
  TriggerServerEvent('Polar:getPlayerTattoos')
end

local blipscfg = module("cfg/blips_markers")
AddEventHandler("Polar:onClientSpawn",function(D, E)
    if E then
      for A, B in pairs(blipscfg.blips) do
        tPolar.addBlip(B[1], B[2], B[3], B[4], B[5], B[6], B[7] or 0.8)
      end
      for A, B in pairs(blipscfg.markers) do
        tPolar.addMarker(B[1], B[2], B[3], B[4], B[5], B[6], B[7], B[8], B[9], B[10], B[11])
      end
    end
end)

CreateThread(function()
    while true do
        ExtendWorldBoundaryForPlayer(-9000.0, -11000.0, 30.0)
        ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
        Wait(0)
    end
end)

globalHideUi = false
function tPolar.hideUI()
  globalHideUi = true
  TriggerEvent("Polar:showHUD", false)
  TriggerEvent('Polar:hideChat', true)
end
function tPolar.showUI()
  globalHideUi = false
  TriggerEvent("Polar:showHUD", true)
  TriggerEvent('Polar:hideChat', false)
end
RegisterCommand('showui', function()
  globalHideUi = false
  TriggerEvent("Polar:showHUD", true)
  TriggerEvent('Polar:hideChat', false)
end)

RegisterCommand('hideui', function()
  tPolar.notify("~g~/showui to re-enable UI")
  globalHideUi = true
  TriggerEvent("Polar:showHUD", false)
  TriggerEvent('Polar:hideChat', true)
end)

RegisterCommand('showchat', function()
  TriggerEvent('Polar:hideChat', false)
end)

RegisterCommand('hidechat', function()
  tPolar.notify("~g~/showui to re-enable Chat")
  TriggerEvent('Polar:hideChat', true)
end)

RegisterCommand("getcoords",function()
    print(GetEntityCoords(tPolar.getPlayerPed()))
    tPolar.notify("~g~Coordinates copied to clipboard.")
    tPolar.CopyToClipBoard(tostring(GetEntityCoords(tPolar.getPlayerPed())))
end)
Citizen.CreateThread(function()
    while true do
        if globalHideUi then
            HideHudAndRadarThisFrame()
        end
        Wait(0)
    end
end)

RegisterCommand("getmyid",function()
  TriggerEvent("chatMessage", "^1Your ID: " .. tostring(tPolar.getUserId()), { 128, 128, 128 }, message, "ooc")
end,false)

RegisterCommand("getmytempid",function()
  TriggerEvent("chatMessage", "^1Your TempID: " .. tostring(GetPlayerServerId(PlayerId())), { 128, 128, 128 }, message, "ooc")
end,false)

local bt = {}
function tPolar.setDiscordNames(bu)
    bt = bu
end
function tPolar.addDiscordName(aO, b)
    bt[aO] = b
end
function tPolar.getPlayerName(ai)
    local R = GetPlayerServerId(ai)
    local S = tPolar.clientGetUserIdFromSource(R)
    if bt[S] == nil then
        return GetPlayerName(ai)
    end
    return bt[S]
end
exports("getPlayerName", tPolar.getPlayerName)
RegisterNetEvent("Polar:setUserId",function(w)
  local bv = GetResourceKvpInt("Polar_user_id")
    if bv then
      TriggerServerEvent("Polar:checkCachedId", bv, w)
  end
  tPolar.setUserId(w)
  Wait(5000)
  SetResourceKvpInt("Polar_user_id", w)
end)

local a9 = false

function tPolar.isSpectatingEvent()
    return a9
end

function getMoneyStringFormatted(cashString)
  local i, j, minus, int = tostring(cashString):find('([-]?)(%d+)%.?%d*')
  
  if int == nil then 
      return cashString
  else
      -- reverse the int-string and append a comma to all blocks of 3 digits
      int = int:reverse():gsub("(%d%d%d)", "%1,")

      -- reverse the int-string back, remove an optional comma, and put the optional minus back
      return minus .. int:reverse():gsub("^,", "")
  end
end