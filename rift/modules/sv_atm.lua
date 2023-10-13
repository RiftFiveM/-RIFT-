local lang = RIFT.lang
RegisterNetEvent('RIFT:Withdraw')
AddEventHandler('RIFT:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = RIFT.getUserId(source)
        if user_id ~= nil then
            if RIFT.tryWithdraw(user_id, amount) then
                RIFTclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                RIFTclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        RIFTclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('RIFT:Deposit')
AddEventHandler('RIFT:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = RIFT.getUserId(source)
        if user_id ~= nil then
            if RIFT.tryDeposit(user_id, amount) then
                RIFTclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                RIFTclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        RIFTclient.notify(source, {lang.common.invalid_value()})
    end
end)

RegisterNetEvent('RIFT:WithdrawAll')
AddEventHandler('RIFT:WithdrawAll', function()
    local source = source
    local amount = RIFT.getBankMoney(RIFT.getUserId(source))
    if amount > 0 then
        local user_id = RIFT.getUserId(source)
        if user_id ~= nil then
            if RIFT.tryWithdraw(user_id, amount) then
                RIFTclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                RIFTclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        RIFTclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('RIFT:DepositAll')
AddEventHandler('RIFT:DepositAll', function()
    local source = source
    local amount = RIFT.getMoney(RIFT.getUserId(source))
    if amount > 0 then
        local user_id = RIFT.getUserId(source)
        if user_id ~= nil then
            if RIFT.tryDeposit(user_id, amount) then
                RIFTclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                RIFTclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        RIFTclient.notify(source, {lang.common.invalid_value()})
    end
end)