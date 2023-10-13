RegisterServerEvent('RIFT:openCarDev')
AddEventHandler('RIFT:openCarDev', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cardev.menu") then 
      RIFTclient.openCarDev(source,{})
    end
end)

RegisterServerEvent('RIFT:setCarDev')
AddEventHandler('RIFT:setCarDev', function(status)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cardev.menu") then 
      if status then
        SetPlayerRoutingBucket(source, 10)
      else
        SetPlayerRoutingBucket(source, 0)
      end
    end
end)

RegisterServerEvent('RIFT:takeCarScreenshot')
AddEventHandler('RIFT:takeCarScreenshot', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local name = GetPlayerName(source)
    if user_id ~= nil and RIFT.hasPermission(user_id, "cardev.menu") then 
        exports["vehicle-screenshot"]:requestClientScreenshotUploadToDiscord(source,{username = "RIFT Car Screenshots"},30000,function(error)
            if error then
                return print("^1ERROR: " .. error)
            end
        end)
    end   
end)

RegisterServerEvent("RIFT:getCarDevDebug")
AddEventHandler("RIFT:getCarDevDebug", function(text)
   local source = source
   local user_id = RIFT.getUserId(source)
   local command = {
      {
        ["color"] = "16777215",
        ["title"] = "Requested by "..GetPlayerName(source).." Perm ID: "..user_id.."",
        ["description"] = text[1],
        ["footer"] = {
          ["text"] = "RIFT - "..os.date("%X"),
          ["icon_url"] = "",
        }
      }
    }
    PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "RIFT Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
end)