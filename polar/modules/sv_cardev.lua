RegisterServerEvent('Polar:openCarDev')
AddEventHandler('Polar:openCarDev', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cardev.menu") then 
      Polarclient.openCarDev(source,{})
    end
end)

RegisterServerEvent('Polar:setCarDev')
AddEventHandler('Polar:setCarDev', function(status)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cardev.menu") then 
      if status then
        SetPlayerRoutingBucket(source, 10)
      else
        SetPlayerRoutingBucket(source, 0)
      end
    end
end)

RegisterServerEvent('Polar:takeCarScreenshot')
AddEventHandler('Polar:takeCarScreenshot', function()
    local source = source
    local user_id = Polar.getUserId(source)
    local name = GetPlayerName(source)
    if user_id ~= nil and Polar.hasPermission(user_id, "cardev.menu") then 
        exports["vehicle-screenshot"]:requestClientScreenshotUploadToDiscord(source,{username = "Polar Car Screenshots"},30000,function(error)
            if error then
                return print("^1ERROR: " .. error)
            end
        end)
    end   
end)

RegisterServerEvent("Polar:getCarDevDebug")
AddEventHandler("Polar:getCarDevDebug", function(text)
   local source = source
   local user_id = Polar.getUserId(source)
   local command = {
      {
        ["color"] = "16777215",
        ["title"] = "Requested by "..GetPlayerName(source).." Perm ID: "..user_id.."",
        ["description"] = text[1],
        ["footer"] = {
          ["text"] = "Polar - "..os.date("%X"),
          ["icon_url"] = "",
        }
      }
    }
    PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "Polar Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
end)