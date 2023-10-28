local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("Polar:getAnnounceMenu")
AddEventHandler("Polar:getAnnounceMenu", function()
    local source = source
    local user_id = Polar.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if Polar.hasPermission(user_id, v.permission) or Polar.hasGroup(user_id, 'Founder') or Polar.hasGroup(user_id, 'Lead Developer') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("Polar:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("Polar:serviceAnnounce")
AddEventHandler("Polar:serviceAnnounce", function(announceType)
    local source = source
    local user_id = Polar.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if Polar.hasPermission(user_id, v.permission) or Polar.hasGroup(user_id, 'Founder') or Polar.hasGroup(user_id, 'Lead Developer') then
                if Polar.tryFullPayment(user_id, v.info.price) then
                    Polar.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('Polar:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            Polarclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                        else
                            Polarclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                        end
                    end)
                else
                    Polarclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("Polar:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)

-- just some rando comments yaknow