
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local user_id = RIFT.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not RIFT.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        RIFTclient.notify(source, {"~r~You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if RIFT.hasGroup(user_id, job) then 
            RIFTclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("rift:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if RIFT.tryFullPayment(user_id, v.price) then
                        RIFT.addUserGroup(user_id,job)
                        RIFTclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        tRIFT.sendWebhook('purchases',"RIFT License Centre Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("rift:PlaySound", source, 1)
                        TriggerClientEvent("RIFT:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("RIFT:refreshGunStorePermissions", source)
                    else 
                        RIFTclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                        TriggerClientEvent("rift:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("RIFT:acBan", userid, 11, GetPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)



function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if RIFT.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("RIFT:GetLicenses")
AddEventHandler("RIFT:GetLicenses", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("RIFT:RecievedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("RIFT:getOwnedLicenses")
AddEventHandler("RIFT:getOwnedLicenses", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("RIFT:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)