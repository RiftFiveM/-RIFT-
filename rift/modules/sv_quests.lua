MySQL.createCommand("quests/add_id", "INSERT IGNORE INTO rift_quests SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = RIFT.getUserId(source)
    MySQL.execute("quests/add_id", {user_id = user_id})
end)

RegisterServerEvent("RIFT:setQuestCompleted")
AddEventHandler("RIFT:setQuestCompleted", function()
	local source = source
	local user_id = RIFT.getUserId(source)
    local a = exports['ghmattimysql']:executeSync("SELECT * FROM rift_quests WHERE user_id = @user_id", {user_id = user_id})
    for k,v in pairs(a) do
        if v.user_id == user_id then
            if v.quests_completed < 51 and not v.reward_claimed then
                exports['ghmattimysql']:execute("UPDATE rift_quests SET quests_completed = (quests_completed+1) WHERE user_id = @user_id", {user_id = user_id}, function() end)
            else
                -- ban player for attempting to set quest completed when claimed or attempting to go over 50
                local player = RIFT.getUserSource(user_id)
                local name = GetPlayerName(player)
                Wait(500)
                TriggerEvent("RIFT:acBan", user_id, 11, name, player, 'Attempted to Trigger Plat days Quest')
            end
        end
    end
end)

RegisterServerEvent("RIFT:claimQuestReward")
AddEventHandler("RIFT:claimQuestReward", function()
	local source = source
	local user_id = RIFT.getUserId(source)
    local a = exports['ghmattimysql']:executeSync("SELECT * FROM rift_quests WHERE user_id = @user_id", {user_id = user_id})
    local plathours = 0
    for k,v in pairs(a) do
        if v.user_id == user_id then
            if not v.reward_claimed and v.quests_completed == 50 then
                -- code to give plat days
                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                    plathours = rows[1].plathours
                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + 168*2})
                    exports['ghmattimysql']:execute("UPDATE rift_quests SET reward_claimed = true WHERE user_id = @user_id", {user_id = user_id}, function() end)
                end)
            else
                -- ban player for attempting to get plat days when not got 50 quests done or reward is claimed
                local player = RIFT.getUserSource(user_id)
                local name = GetPlayerName(player)
                Wait(500)
                TriggerEvent("RIFT:acBan", user_id, 11, name, player,  'Attempted to Trigger Plat days Reward')
            end
        end
    end
end)
