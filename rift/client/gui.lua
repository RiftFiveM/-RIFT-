function tRIFT.request(a,b,c)
  SendNUIMessage({act="request",id=a,text=tostring(b),time=c})
  tRIFT.playSound("HUD_MINI_GAME_SOUNDSET","5_SEC_WARNING")
end
RegisterNUICallback("request",function(d,e)
  if d.act=="response"then 
      RIFTserver.requestResult({d.id,d.ok})
  end 
end)
function tRIFT.announce(f,g)
  SendNUIMessage({act="announce",background=f,content=g})
end
function tRIFT.setDiv(h,i,g)
  SendNUIMessage({act="set_div",name=h,css=i,content=g})
end
function tRIFT.setDivCss(h,i)
  SendNUIMessage({act="set_div_css",name=h,css=i})
end
function tRIFT.setDivContent(h,g)
  SendNUIMessage({act="set_div_content",name=h,content=g})
end
function tRIFT.divExecuteJS(h,j)
  SendNUIMessage({act="div_execjs",name=h,js=j})
end
function tRIFT.removeDiv(h)
  SendNUIMessage({act="remove_div",name=h})
end
local k=false
function tRIFT.isPaused()
  return k 
end

local controls = {
  phone = {
    -- PHONE CONTROLS
    up = {3,172},
    down = {3,173},
    left = {3,174},
    right = {3,175},
    select = {3,176},
    cancel = {3,177},
    open = {3,31123}, -- K to open the menu
  },
  request = {
    yes = {0,83}, -- +
    no = {0,84} -- -
  }
}

Citizen.CreateThread(function()
  while true do 
      if IsDisabledControlJustPressed(table.unpack(controls.request.yes))then 
          SendNUIMessage({act="event",event="requestAccept"})
      end
      if IsDisabledControlJustPressed(table.unpack(controls.request.no))then 
          SendNUIMessage({act="event",event="requestDeny"})
      end
      local l=IsPauseMenuActive()
      if l and not k then 
          k=true
          TriggerEvent("rift:pauseChange",k)
      elseif not l and k then 
          k=false
          TriggerEvent("rift:pauseChange",k)
      end
      Wait(0)
  end 
end)
AddEventHandler("rift:pauseChange",function(k)
  SendNUIMessage({act="pause_change",paused=k})
end)