local lang = Polar.lang
RegisterNetEvent('Polar:Withdraw')
AddEventHandler('Polar:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = Polar.getUserId(source)
        if user_id ~= nil then
            if Polar.tryWithdraw(user_id, amount) then
                Polarclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                Polarclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        Polarclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('Polar:Deposit')
AddEventHandler('Polar:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = Polar.getUserId(source)
        if user_id ~= nil then
            if Polar.tryDeposit(user_id, amount) then
                Polarclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                Polarclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        Polarclient.notify(source, {lang.common.invalid_value()})
    end
end)

RegisterNetEvent('Polar:WithdrawAll')
AddEventHandler('Polar:WithdrawAll', function()
    local source = source
    local amount = Polar.getBankMoney(Polar.getUserId(source))
    if amount > 0 then
        local user_id = Polar.getUserId(source)
        if user_id ~= nil then
            if Polar.tryWithdraw(user_id, amount) then
                Polarclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                Polarclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        Polarclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('Polar:DepositAll')
AddEventHandler('Polar:DepositAll', function()
    local source = source
    local amount = Polar.getMoney(Polar.getUserId(source))
    if amount > 0 then
        local user_id = Polar.getUserId(source)
        if user_id ~= nil then
            if Polar.tryDeposit(user_id, amount) then
                Polarclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                Polarclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        Polarclient.notify(source, {lang.common.invalid_value()})
    end
end)