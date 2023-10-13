grindBoost = 2.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(18000*grindBoost),
    ["LSDSouth"] = math.floor(18000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(7000*grindBoost),
}

function RIFT.getCommissionPrice(drugtype)
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

function RIFT.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function RIFT.updateTraderInfo()
    TriggerClientEvent('RIFT:updateTraderCommissions', -1, 
    RIFT.getCommission('Weed'),
    RIFT.getCommission('Cocaine'),
    RIFT.getCommission('Meth'),
    RIFT.getCommission('Heroin'),
    RIFT.getCommission('LargeArms'),
    RIFT.getCommission('LSDNorth'),
    RIFT.getCommission('LSDSouth'))
    TriggerClientEvent('RIFT:updateTraderPrices', -1, 
    RIFT.getCommissionPrice('Weed'), 
    RIFT.getCommissionPrice('Cocaine'),
    RIFT.getCommissionPrice('Meth'),
    RIFT.getCommissionPrice('Heroin'),
    RIFT.getCommissionPrice('LSDNorth'),
    RIFT.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('RIFT:requestDrugPriceUpdate')
AddEventHandler('RIFT:requestDrugPriceUpdate', function()
    local source = source
	local user_id = RIFT.getUserId(source)
    RIFT.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        RIFTclient.notify(source, {'~r~You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('RIFT:sellCopper')
AddEventHandler('RIFT:sellCopper', function()
    local source = source
	local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Copper') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Copper', 1, false)
            RIFTclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            RIFT.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            RIFTclient.notify(source, {'~r~You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellLimestone')
AddEventHandler('RIFT:sellLimestone', function()
    local source = source
	local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            RIFTclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            RIFT.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            RIFTclient.notify(source, {'~r~You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellGold')
AddEventHandler('RIFT:sellGold', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Gold') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Gold', 1, false)
            RIFTclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            RIFT.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            RIFTclient.notify(source, {'~r~You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellDiamond')
AddEventHandler('RIFT:sellDiamond', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            RIFTclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            RIFT.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            RIFTclient.notify(source, {'~r~You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellWeed')
AddEventHandler('RIFT:sellWeed', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Weed') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Weed', 1, false)
            RIFTclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('Weed'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('Weed'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('Weed'), 'Weed')
        else
            RIFTclient.notify(source, {'~r~You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellCocaine')
AddEventHandler('RIFT:sellCocaine', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            RIFTclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('Cocaine'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('Cocaine'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('Cocaine'), 'Cocaine')
        else
            RIFTclient.notify(source, {'~r~You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellMeth')
AddEventHandler('RIFT:sellMeth', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Meth') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Meth', 1, false)
            RIFTclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('Meth'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('Meth'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('Meth'), 'Meth')
        else
            RIFTclient.notify(source, {'~r~You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellHeroin')
AddEventHandler('RIFT:sellHeroin', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            RIFTclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('Heroin'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('Heroin'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('Heroin'), 'Heroin')
        else
            RIFTclient.notify(source, {'~r~You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellLSDNorth')
AddEventHandler('RIFT:sellLSDNorth', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            RIFTclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('LSDNorth'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('LSDNorth'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('LSDNorth'), 'LSDNorth')
        else
            RIFTclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellLSDSouth')
AddEventHandler('RIFT:sellLSDSouth', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        if RIFT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            RIFT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            RIFTclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(RIFT.getCommissionPrice('LSDSouth'))})
            RIFT.giveMoney(user_id, RIFT.getCommissionPrice('LSDSouth'))
            RIFT.turfSaleToGangFunds(RIFT.getCommissionPrice('LSDSouth'), 'LSDSouth')
        else
            RIFTclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('RIFT:sellAll')
AddEventHandler('RIFT:sellAll', function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if RIFT.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = RIFT.getInventoryItemAmount(user_id, k)
                    RIFT.tryGetInventoryItem(user_id, k, amount, false)
                    RIFTclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    RIFT.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if RIFT.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = RIFT.getInventoryItemAmount(user_id, 'Processed Diamond')
                    RIFT.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    RIFTclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    RIFT.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)

RegisterCommand('testitem', function(source,args)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.hasGroup(user_id, 'Founder') or RIFT.hasGroup(user_id, 'Lead Developer') then
        RIFT.giveInventoryItem(user_id, args[1], 1, true)
    end
end)