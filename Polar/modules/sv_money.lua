local lang = Polar.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("Polar/money_init_user","INSERT IGNORE INTO Polar_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("Polar/get_money","SELECT wallet,bank FROM Polar_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("Polar/set_money","UPDATE Polar_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function Polar.getMoney(user_id)
  local tmp = Polar.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function Polar.setMoney(user_id,value)
  local tmp = Polar.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = Polar.getUserSource(user_id)
  if source ~= nil then
    Polarclient.setDivContent(source,{"money",lang.money.display({Comma(Polar.getMoney(user_id))})})
    TriggerClientEvent('Polar:initMoney', source, Polar.getMoney(user_id), Polar.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function Polar.tryPayment(user_id,amount)
  local money = Polar.getMoney(user_id)
  if amount >= 0 and money >= amount then
    Polar.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function Polar.tryBankPayment(user_id,amount)
  local bank = Polar.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    Polar.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function Polar.giveMoney(user_id,amount)
  local money = Polar.getMoney(user_id)
  Polar.setMoney(user_id,money+amount)
end

-- get bank money
function Polar.getBankMoney(user_id)
  local tmp = Polar.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function Polar.setBankMoney(user_id,value)
  local tmp = Polar.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = Polar.getUserSource(user_id)
  if source ~= nil then
    Polarclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(Polar.getBankMoney(user_id))})})
    TriggerClientEvent('Polar:initMoney', source, Polar.getMoney(user_id), Polar.getBankMoney(user_id))
  end
end

-- give bank money
function Polar.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = Polar.getBankMoney(user_id)
    Polar.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function Polar.tryWithdraw(user_id,amount)
  local money = Polar.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    Polar.setBankMoney(user_id,money-amount)
    Polar.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function Polar.tryDeposit(user_id,amount)
  if amount > 0 and Polar.tryPayment(user_id,amount) then
    Polar.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function Polar.tryFullPayment(user_id,amount)
  local money = Polar.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return Polar.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if Polar.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return Polar.tryPayment(user_id, amount)
    end
  end

  return false
end

local startingCash = 50000
local startingBank = 10000000

-- events, init user account if doesn't exist at connection
AddEventHandler("Polar:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("Polar/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank}, function(affected)
    local tmp = Polar.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("Polar/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("Polar:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = Polar.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("Polar/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("Polar:save", function()
  for k,v in pairs(Polar.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("Polar/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('Polar:giveCashToPlayer')
AddEventHandler('Polar:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = Polar.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = Polar.getUserId(nplayer)
      if nuser_id ~= nil then
        Polar.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and Polar.tryPayment(user_id,amount) then
            Polar.giveMoney(nuser_id,amount)
            Polarclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            Polarclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            tPolar.sendWebhook('give-cash', "Polar Give Cash Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            Polarclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        Polarclient.notify(source,{lang.common.no_player_near()})
      end
    else
      Polarclient.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("Polar:takeAmount")
AddEventHandler("Polar:takeAmount", function(amount)
    local source = source
    local user_id = Polar.getUserId(source)
    if Polar.tryFullPayment(user_id,amount) then
      Polarclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("Polar:bankTransfer")
AddEventHandler("Polar:bankTransfer", function(id, amount)
    local source = source
    local user_id = Polar.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if Polar.getUserSource(id) then
      if Polar.tryBankPayment(user_id,amount) then
        Polarclient.notify(source,{'~g~Transferred £'..getMoneyStringFormatted(amount)..' to ID: '..id})
        Polarclient.notify(Polar.getUserSource(id),{'~g~Received £'..getMoneyStringFormatted(amount)..' from ID: '..user_id})
        TriggerClientEvent("Polar:PlaySound", source, "apple")
        TriggerClientEvent("Polar:PlaySound", Polar.getUserSource(id), "apple")
        Polar.giveBankMoney(id, amount)
        tPolar.sendWebhook('bank-transfer', "Polar Bank Transfer Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(Polar.getUserSource(id)).."**\n> Target PermID: **"..id.."**\n> Amount: **£"..amount.."**")
      else
        Polarclient.notify(source,{'~r~You do not have enough money.'})
      end
    else
      Polarclient.notify(source,{'~r~Player is not online'})
    end
end)

RegisterServerEvent('Polar:requestPlayerBankBalance')
AddEventHandler('Polar:requestPlayerBankBalance', function()
    local user_id = Polar.getUserId(source)
    local bank = Polar.getBankMoney(user_id)
    local wallet = Polar.getMoney(user_id)
    TriggerClientEvent('Polar:setDisplayMoney', source, wallet)
    TriggerClientEvent('Polar:setDisplayBankMoney', source, bank)
    TriggerClientEvent('Polar:initMoney', source, wallet, bank)
end)