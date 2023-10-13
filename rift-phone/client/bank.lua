
inMenu = true
local bank = 0
function setBankBalance (value)
    bank = value
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent("RIFT:initMoney")
AddEventHandler("RIFT:initMoney", function(bankMoney)
    setBankBalance(bankMoney)
end)

RegisterNUICallback("bank_transfer", function(data) 
    TriggerServerEvent("RIFT:bankTransfer", data.user_id, data.amount)
end)