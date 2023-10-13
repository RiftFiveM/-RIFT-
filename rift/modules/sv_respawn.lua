local cfg=module("cfg/cfg_respawn")


RegisterNetEvent("RIFT:SendSpawnMenu")
AddEventHandler("RIFT:SendSpawnMenu",function()
    local source = source
    local user_id = RIFT.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if RIFT.hasPermission(RIFT.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['ghmattimysql']:execute("SELECT * FROM `rift_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            TriggerClientEvent("RIFT:OpenSpawnMenu",source,spawnTable)
            RIFT.clearInventory(user_id) 
            RIFTclient.setPlayerCombatTimer(source, {0})
        end
    end)
end)