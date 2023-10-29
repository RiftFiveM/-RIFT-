grindBoost = 2.0

local defaultPrices = {
    ["Weed"] = math.floor(3000*grindBoost),  ---1500
    ["Cocaine"] = math.floor(5000*grindBoost), ----2500
    ["Meth"] = math.floor(6000*grindBoost), ---3000
    ["Heroin"] = math.floor(20000*grindBoost), ---10000
    ["LSDNorth"] = math.floor(36000*grindBoost), --180000
    ["LSDSouth"] = math.floor(36000*grindBoost), --- 18000
    ["Copper"] = math.floor(2000*grindBoost), --- 1000
    ["Limestone"] = math.floor(4000*grindBoost), ---2000
    ["Gold"] = math.floor(8000*grindBoost), ---4000
    ["Diamond"] = math.floor(14000*grindBoost), --7000
}

function Polar.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function Polar.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function Polar.updateTraderInfo()
    TriggerClientEvent('Polar:updateTraderCommissions', -1, 
    Polar.getCommission('Weed'),
    Polar.getCommission('Cocaine'),
    Polar.getCommission('Meth'),
    Polar.getCommission('Heroin'),
    Polar.getCommission('LargeArms'),
    Polar.getCommission('LSDNorth'),
    Polar.getCommission('LSDSouth'))
    TriggerClientEvent('Polar:updateTraderPrices', -1, 
    Polar.getCommissionPrice('Weed'), 
    Polar.getCommissionPrice('Cocaine'),
    Polar.getCommissionPrice('Meth'),
    Polar.getCommissionPrice('Heroin'),
    Polar.getCommissionPrice('LSDNorth'),
    Polar.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('Polar:requestDrugPriceUpdate')
AddEventHandler('Polar:requestDrugPriceUpdate', function()
    local source = source
	local user_id = Polar.getUserId(source)
    Polar.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        Polarclient.notify(source, {'~r~You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('Polar:sellCopper')
AddEventHandler('Polar:sellCopper', function()
    local source = source
	local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Copper') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Copper', 1, false)
            Polarclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            Polar.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            Polarclient.notify(source, {'~r~You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('Polar:sellLimestone')
AddEventHandler('Polar:sellLimestone', function()
    local source = source
	local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            Polarclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            Polar.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            Polarclient.notify(source, {'~r~You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('Polar:sellGold')
AddEventHandler('Polar:sellGold', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Gold') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Gold', 1, false)
            Polarclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            Polar.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            Polarclient.notify(source, {'~r~You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('Polar:sellDiamond')
AddEventHandler('Polar:sellDiamond', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            Polarclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            Polar.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            Polarclient.notify(source, {'~r~You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('Polar:sellWeed')
AddEventHandler('Polar:sellWeed', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Weed') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Weed', 1, false)
            Polarclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(Polar.getCommissionPrice('Weed'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('Weed'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('Weed'), 'Weed')
        else
            Polarclient.notify(source, {'~r~You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('Polar:sellCocaine')
AddEventHandler('Polar:sellCocaine', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            Polarclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(Polar.getCommissionPrice('Cocaine'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('Cocaine'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('Cocaine'), 'Cocaine')
        else
            Polarclient.notify(source, {'~r~You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('Polar:sellMeth')
AddEventHandler('Polar:sellMeth', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Meth') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Meth', 1, false)
            Polarclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(Polar.getCommissionPrice('Meth'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('Meth'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('Meth'), 'Meth')
        else
            Polarclient.notify(source, {'~r~You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('Polar:sellHeroin')
AddEventHandler('Polar:sellHeroin', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            Polar.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            Polarclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(Polar.getCommissionPrice('Heroin'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('Heroin'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('Heroin'), 'Heroin')
        else
            Polarclient.notify(source, {'~r~You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('Polar:sellLSDNorth')
AddEventHandler('Polar:sellLSDNorth', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'LSD') > 0 then
            Polar.tryGetInventoryItem(user_id, 'LSD', 1, false)
            Polarclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(Polar.getCommissionPrice('LSDNorth'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('LSDNorth'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('LSDNorth'), 'LSDNorth')
        else
            Polarclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('Polar:sellLSDSouth')
AddEventHandler('Polar:sellLSDSouth', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        if Polar.getInventoryItemAmount(user_id, 'LSD') > 0 then
            Polar.tryGetInventoryItem(user_id, 'LSD', 1, false)
            Polarclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(Polar.getCommissionPrice('LSDSouth'))})
            Polar.giveMoney(user_id, Polar.getCommissionPrice('LSDSouth'))
            Polar.turfSaleToGangFunds(Polar.getCommissionPrice('LSDSouth'), 'LSDSouth')
        else
            Polarclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('Polar:sellAll')
AddEventHandler('Polar:sellAll', function()
    local source = source
    local user_id = Polar.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if Polar.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = Polar.getInventoryItemAmount(user_id, k)
                    Polar.tryGetInventoryItem(user_id, k, amount, false)
                    Polarclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    Polar.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if Polar.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = Polar.getInventoryItemAmount(user_id, 'Processed Diamond')
                    Polar.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    Polarclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    Polar.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)

RegisterCommand('testitem', function(source,args)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.hasGroup(user_id, 'Founder') or Polar.hasGroup(user_id, 'Lead Developer') then
        Polar.giveInventoryItem(user_id, args[1], 1, true)
    end
end)