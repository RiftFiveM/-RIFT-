local cfg=module("cfg/cfg_respawn")


RegisterNetEvent("Polar:SendSpawnMenu")
AddEventHandler("Polar:SendSpawnMenu",function()
    local source = source
    local user_id = Polar.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if Polar.hasPermission(Polar.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['ghmattimysql']:execute("SELECT * FROM `Polar_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            TriggerClientEvent("Polar:OpenSpawnMenu",source,spawnTable)
            Polar.clearInventory(user_id) 
            Polarclient.setPlayerCombatTimer(source, {0})
        end
    end)
end)