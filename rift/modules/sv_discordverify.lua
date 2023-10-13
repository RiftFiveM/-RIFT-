local verifyCodes = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for k,v in pairs(verifyCodes) do
            if verifyCodes[k] ~= nil then
                verifyCodes[k] = nil
            end
        end
    end
end)

RegisterServerEvent('RIFT:changeLinkedDiscord', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.prompt(source,"Enter Discord Id:","",function(source,discordid) 
        if discordid ~= nil then
            TriggerClientEvent('RIFT:gotDiscord', source)
            RIFTclient.generateUUID(source, {"linkcode", 5, "alphanumeric"}, function(code)
                verifyCodes[user_id] = {code = code, discordid = discordid}
                exports['rift-bot']:dmUser(source, {discordid, code, user_id}, function()end)
            end)
        end
	end)
end)


RegisterServerEvent('RIFT:enterDiscordCode', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    RIFT.prompt(source,"Enter Code:","",function(source,code) 
        if code ~= nil then
            if verifyCodes[user_id].code == code then
                exports['ghmattimysql']:execute("UPDATE `rift_verification` SET discord_id = @discord_id WHERE user_id = @user_id", {user_id = user_id, discord_id = verifyCodes[user_id].discordid}, function() end)
                RIFTclient.notify(source, {'~g~Your discord has been successfully updated.'})
            end
        end
	end)
end)
