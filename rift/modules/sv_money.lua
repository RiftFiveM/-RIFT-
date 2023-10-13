local lang = RIFT.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("RIFT/money_init_user","INSERT IGNORE INTO rift_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("RIFT/get_money","SELECT wallet,bank FROM rift_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("RIFT/set_money","UPDATE rift_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function RIFT.getMoney(user_id)
  local tmp = RIFT.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function RIFT.setMoney(user_id,value)
  local tmp = RIFT.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = RIFT.getUserSource(user_id)
  if source ~= nil then
    RIFTclient.setDivContent(source,{"money",lang.money.display({Comma(RIFT.getMoney(user_id))})})
    TriggerClientEvent('RIFT:initMoney', source, RIFT.getMoney(user_id), RIFT.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function RIFT.tryPayment(user_id,amount)
  local money = RIFT.getMoney(user_id)
  if amount >= 0 and money >= amount then
    RIFT.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function RIFT.tryBankPayment(user_id,amount)
  local bank = RIFT.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    RIFT.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function RIFT.giveMoney(user_id,amount)
  local money = RIFT.getMoney(user_id)
  RIFT.setMoney(user_id,money+amount)
end

-- get bank money
function RIFT.getBankMoney(user_id)
  local tmp = RIFT.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function RIFT.setBankMoney(user_id,value)
  local tmp = RIFT.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = RIFT.getUserSource(user_id)
  if source ~= nil then
    RIFTclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(RIFT.getBankMoney(user_id))})})
    TriggerClientEvent('RIFT:initMoney', source, RIFT.getMoney(user_id), RIFT.getBankMoney(user_id))
  end
end

-- give bank money
function RIFT.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = RIFT.getBankMoney(user_id)
    RIFT.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function RIFT.tryWithdraw(user_id,amount)
  local money = RIFT.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    RIFT.setBankMoney(user_id,money-amount)
    RIFT.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function RIFT.tryDeposit(user_id,amount)
  if amount > 0 and RIFT.tryPayment(user_id,amount) then
    RIFT.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function RIFT.tryFullPayment(user_id,amount)
  local money = RIFT.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return RIFT.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if RIFT.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return RIFT.tryPayment(user_id, amount)
    end
  end

  return false
end

local startingCash = 50000
local startingBank = 100000000

-- events, init user account if doesn't exist at connection
AddEventHandler("RIFT:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("RIFT/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank}, function(affected)
    local tmp = RIFT.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("RIFT/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("RIFT:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = RIFT.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("RIFT/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("RIFT:save", function()
  for k,v in pairs(RIFT.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("RIFT/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('RIFT:giveCashToPlayer')
AddEventHandler('RIFT:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = RIFT.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = RIFT.getUserId(nplayer)
      if nuser_id ~= nil then
        RIFT.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and RIFT.tryPayment(user_id,amount) then
            RIFT.giveMoney(nuser_id,amount)
            RIFTclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            RIFTclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            tRIFT.sendWebhook('give-cash', "RIFT Give Cash Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            RIFTclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        RIFTclient.notify(source,{lang.common.no_player_near()})
      end
    else
      RIFTclient.notify(source,{lang.common.no_player_near()})
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

RegisterServerEvent("RIFT:takeAmount")
AddEventHandler("RIFT:takeAmount", function(amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    if RIFT.tryFullPayment(user_id,amount) then
      RIFTclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("RIFT:bankTransfer")
AddEventHandler("RIFT:bankTransfer", function(id, amount)
    local source = source
    local user_id = RIFT.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if RIFT.getUserSource(id) then
      if RIFT.tryBankPayment(user_id,amount) then
        RIFTclient.notify(source,{'~g~Transferred £'..getMoneyStringFormatted(amount)..' to ID: '..id})
        RIFTclient.notify(RIFT.getUserSource(id),{'~g~Received £'..getMoneyStringFormatted(amount)..' from ID: '..user_id})
        TriggerClientEvent("rift:PlaySound", source, "apple")
        TriggerClientEvent("rift:PlaySound", RIFT.getUserSource(id), "apple")
        RIFT.giveBankMoney(id, amount)
        tRIFT.sendWebhook('bank-transfer', "RIFT Bank Transfer Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(RIFT.getUserSource(id)).."**\n> Target PermID: **"..id.."**\n> Amount: **£"..amount.."**")
      else
        RIFTclient.notify(source,{'~r~You do not have enough money.'})
      end
    else
      RIFTclient.notify(source,{'~r~Player is not online'})
    end
end)

RegisterServerEvent('RIFT:requestPlayerBankBalance')
AddEventHandler('RIFT:requestPlayerBankBalance', function()
    local user_id = RIFT.getUserId(source)
    local bank = RIFT.getBankMoney(user_id)
    local wallet = RIFT.getMoney(user_id)
    TriggerClientEvent('RIFT:setDisplayMoney', source, wallet)
    TriggerClientEvent('RIFT:setDisplayBankMoney', source, bank)
    TriggerClientEvent('RIFT:initMoney', source, wallet, bank)
end)