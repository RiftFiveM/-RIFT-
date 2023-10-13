MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")


local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "Welcome to RIFT, to join our server please verify your discord account by following the steps below.",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the RIFT discord (discord.gg/rift)",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "2. Type the following command",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["text"] = "3. !verify NULL",
                    ["wrap"] = true,
                }
            }
        },
        {
            ["type"] = "ActionSet",
            ["actions"] = {
                {
                    ["type"] = "Action.OpenUrl",
                    ["title"] = "Join Discord",
                    ["url"] = "https://discord.gg/rift"
                }
            }
        },
    }
}

Debug.active = config.debug
RIFT = {}
Proxy.addInterface("RIFT",RIFT)

tRIFT = {}
Tunnel.bindInterface("RIFT",tRIFT) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
RIFT.lang = Lang.new(dict)

-- init
RIFTclient = Tunnel.getInterface("RIFT","RIFT") -- server -> client tunnel

RIFT.users = {} -- will store logged users (id) by first identifier
RIFT.rusers = {} -- store the opposite of users
RIFT.user_tables = {} -- user data tables (logger storage, saved to database)
RIFT.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
RIFT.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES rift_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES rift_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES rift_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES rift_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    webhook VARCHAR(3000) NULL DEFAULT NULL,
    gangfit VARCHAR(3000) NULL DEFAULT NULL,
    PRIMARY KEY (gangname)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES rift_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_subscriptions(
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_tweets (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) NOT NULL,
    realUser varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    message varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    likes int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY FK_twitter_tweets_twitter_accounts (authorId),
    CONSTRAINT FK_twitter_tweets_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_likes (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) DEFAULT NULL,
    tweetId int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY FK_twitter_likes_twitter_accounts (authorId),
    KEY FK_twitter_likes_twitter_tweets (tweetId),
    CONSTRAINT FK_twitter_likes_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id),
    CONSTRAINT FK_twitter_likes_twitter_tweets FOREIGN KEY (tweetId) REFERENCES twitter_tweets (id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_accounts (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
    password varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
    avatar_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_community_pot (
    rift VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (rift)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rift_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE rift_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rift_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rift_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE rift_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE rift_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rift_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("RIFTls/create_modifications_column", "alter table rift_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("RIFTls/update_vehicle_modifications", "update rift_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("RIFTls/get_vehicle_modifications", "select modifications, vehicle_plate from rift_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("RIFTls/create_modifications_column")
    print("[RIFT] ^2Base tables initialised.^0")
end)

MySQL.createCommand("RIFT/create_user","INSERT INTO rift_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("RIFT/add_identifier","INSERT INTO rift_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("RIFT/userid_byidentifier","SELECT user_id FROM rift_user_ids WHERE identifier = @identifier")
MySQL.createCommand("RIFT/identifier_all","SELECT * FROM rift_user_ids WHERE identifier = @identifier")
MySQL.createCommand("RIFT/select_identifier_byid_all","SELECT * FROM rift_user_ids WHERE user_id = @id")

MySQL.createCommand("RIFT/set_userdata","REPLACE INTO rift_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("RIFT/get_userdata","SELECT dvalue FROM rift_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("RIFT/set_srvdata","REPLACE INTO RIFT_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("RIFT/get_srvdata","SELECT dvalue FROM RIFT_srv_data WHERE dkey = @key")

MySQL.createCommand("RIFT/get_banned","SELECT banned FROM rift_users WHERE id = @user_id")
MySQL.createCommand("RIFT/set_banned","UPDATE rift_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("RIFT/set_identifierbanned","UPDATE rift_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("RIFT/getbanreasontime", "SELECT * FROM rift_users WHERE id = @user_id")

MySQL.createCommand("RIFT/get_whitelisted","SELECT whitelisted FROM rift_users WHERE id = @user_id")
MySQL.createCommand("RIFT/set_whitelisted","UPDATE rift_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("RIFT/set_last_login","UPDATE rift_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("RIFT/get_last_login","SELECT last_login FROM rift_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("RIFT/add_token","INSERT INTO rift_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("RIFT/check_token","SELECT user_id, banned FROM rift_user_tokens WHERE token = @token")
MySQL.createCommand("RIFT/check_token_userid","SELECT token FROM rift_user_tokens WHERE user_id = @id")
MySQL.createCommand("RIFT/ban_token","UPDATE rift_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- removing anticheat ban entry
MySQL.createCommand("ac/delete_ban","DELETE FROM rift_anticheat WHERE @user_id = user_id")


-- init tables


-- identification system

function RIFT.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    if ids ~= nil and #ids then
        local i = 0
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("RIFT/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
                        if #rows > 0 then  -- found
                            task({rows[1].user_id})
                        else -- not found
                            search()
                        end
                    end)
                else
                    search()
                end
            else -- no ids found, create user
                MySQL.query("RIFT/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("RIFT/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        for k,v in pairs(RIFT.getUsers()) do
                            RIFTclient.notify(v, {'~g~You have received £25,000 as someone new has joined the server.'})
                            RIFT.giveBankMoney(k, 25000)
                        end
                        task({user_id})
                    else
                        task()
                    end
                end)
            end
        end
        search()
    else
        task()
    end
end

-- return identification string for the source (used for non RIFT identifications, for rejected players)
function RIFT.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    return idk
end

function RIFT.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function RIFT.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function RIFT.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    RIFT.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            RIFT.StoreTokens(source, user_id) 
            if RIFT.rusers[user_id] == nil then -- not present on the server, init
                RIFT.users[ids[1]] = user_id
                RIFT.rusers[user_id] = ids[1]
                RIFT.user_tables[user_id] = {}
                RIFT.user_tmp_tables[user_id] = {}
                RIFT.user_sources[user_id] = source
                RIFT.getUData(user_id, "RIFT:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then RIFT.user_tables[user_id] = data end
                    local tmpdata = RIFT.getUserTmpTable(user_id)
                    RIFT.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("RIFT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[RIFT] "..name.." ("..GetPlayerName(source)..") joined (Perm ID = "..user_id..")")
                        TriggerEvent("RIFT:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("RIFT:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[RIFT] "..name.." ("..GetPlayerName(source)..") re-joined (Perm ID = "..user_id..")")
                TriggerEvent("RIFT:playerRejoin", user_id, source, name)
                TriggerClientEvent("RIFT:CheckIdRegister", source)
                local tmpdata = RIFT.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

exports("riftbot", function(method_name, params, cb)
    if cb then 
        cb(RIFT[method_name](table.unpack(params)))
    else 
        return RIFT[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("RIFT:CheckID")
AddEventHandler("RIFT:CheckID", function()
    local source = source
    local user_id = RIFT.getUserId(source)
    if not user_id then
        RIFT.ReLoadChar(source)
    end
end)

function RIFT.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("RIFT/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

function RIFT.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("RIFT/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

function RIFT.setWhitelisted(user_id,whitelisted)
    MySQL.execute("RIFT/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

function RIFT.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("RIFT/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function RIFT.fetchBanReasonTime(user_id,cbr)
    MySQL.query("RIFT/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function RIFT.setUData(user_id,key,value)
    MySQL.execute("RIFT/set_userdata", {user_id = user_id, key = key, value = value})
end

function RIFT.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("RIFT/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function RIFT.setSData(key,value)
    MySQL.execute("RIFT/set_srvdata", {key = key, value = value})
end

function RIFT.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("RIFT/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for RIFT internal persistant connected user storage
function RIFT.getUserDataTable(user_id)
    return RIFT.user_tables[user_id]
end

function RIFT.getUserTmpTable(user_id)
    return RIFT.user_tmp_tables[user_id]
end

function RIFT.isConnected(user_id)
    return RIFT.rusers[user_id] ~= nil
end

function RIFT.isFirstSpawn(user_id)
    local tmp = RIFT.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function RIFT.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return RIFT.users[ids[1]]
        end
    end
    return nil
end

-- return map of user_id -> player source
function RIFT.getUsers()
    local users = {}
    for k,v in pairs(RIFT.user_sources) do
        users[k] = v
    end
    return users
end

-- return source or nil
function RIFT.getUserSource(user_id)
    return RIFT.user_sources[user_id]
end

function RIFT.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('RIFT/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id)
                    end 
                end
            end
        end)
    end
end

function RIFT.BanIdentifiers(user_id, value)
    MySQL.query('RIFT/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("RIFT/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function RIFT.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("RIFT/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        RIFT.BanIdentifiers(user_id, true)
        RIFT.BanTokens(user_id, true) 
    else 
        MySQL.execute("RIFT/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        RIFT.BanIdentifiers(user_id, false)
        RIFT.BanTokens(user_id, false) 
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function RIFT.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = RIFT.getUserId(adminsource)
    local getBannedPlayerSrc = RIFT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then
            RIFT.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rift") 
        else
            RIFT.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rift") 
        end
        RIFTclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            RIFT.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
        else 
            RIFT.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
        end
        RIFTclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function RIFT.banConsole(permid,time,reason)
    local adminPermID = "RIFT"
    local getBannedPlayerSrc = RIFT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RIFT.setBanned(permid,true,banTime,reason, adminPermID)
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RIFT \nAppeal @ discord.gg/rift") 
        else 
            RIFT.setBanned(permid,true,"perm",reason, adminPermID)
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RIFT \nAppeal @ discord.gg/rift") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RIFT.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            RIFT.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end

function RIFT.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = RIFT.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))  
        RIFT.setBanned(permid,true,banTime,reason, adminPermID)
        if getBannedPlayerSrc then 
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rift") 
        end
    else 
        RIFT.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then 
            RIFT.kick(getBannedPlayerSrc,"[RIFT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rift") 
        end
    end
end

-- To use token banning you need the latest artifacts.
function RIFT.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("RIFT/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("RIFT/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function RIFT.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("RIFT/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function RIFT.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("RIFT/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("RIFT/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function RIFT.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("RIFT:save")
    Debug.pbegin("RIFT save datatables")
    for k,v in pairs(RIFT.user_tables) do
        RIFT.setUData(k,"RIFT:datatable",json.encode(v))
    end
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

-- handlers

userForUpdates = {
    ["onjoin"] = "264772390951714816",
    ["update"] = "932235138371317760",
    ["local_user"] = "1009479813213458552",
}

function userUpdates(source)
	if source and source > 0 then
		local workingdiscord=0
		for k,v in pairs(GetPlayerIdentifiers(source))do
			if string.sub(v,1,string.len("discord:"))=="discord:"then
				workingdiscord=string.sub(v,string.len("discord::"),#v)
			end
		end
		return workingdiscord
	end
	return 0
end

AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
    deferrals.defer()
    local source = source
    Debug.pbegin("playerConnecting")
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
        deferrals.update("[RIFT] Checking identifiers...")
        RIFT.getUserIdByIdentifiers(ids, function(user_id)
            local numtokens = GetNumPlayerTokens(source)
            if numtokens == 0 then
                deferrals.done("[RIFT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                tRIFT.sendWebhook('ban-evaders', 'RIFT Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Token Amount: **"..numtokens.."**")
                return 
            end
            RIFT.IdentifierBanCheck(source, user_id, function(status, id, bannedIdentifier)
                if status then
                    deferrals.done("[RIFT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. id)
                    tRIFT.sendWebhook('ban-evaders', 'RIFT Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..id.."**\n> Player Banned Identifier: **"..bannedIdentifier.."**")
                    return 
                end
            end)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[RIFT] Fetching Tokens...")
                RIFT.StoreTokens(source, user_id) 
                deferrals.update("[RIFT] Checking banned...")
                checkforUserUpdates = userUpdates(source)
                for k,v in pairs(userForUpdates) do
                    if checkforUserUpdates == v then
                        RIFT.isBanned(user_id, function(banned)
                            if banned then
                                RIFT.setBanned(user_id,false)
                                Wait(500)
                            end
                        end)
                    end
                end
                RIFT.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[RIFT] Checking whitelisted...")
                        RIFT.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if RIFT.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM rift_verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then 
                                        if verified[1]["verified"] == 0 then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM rift_verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            ::regen_code::
                                            local checkCode = exports["ghmattimysql"]:executeSync("SELECT * FROM rift_verification WHERE code = @code", {code = code})
                                            if checkCode ~= nil then
                                                if #checkCode > 0 then
                                                    code = math.random(100000, 999999)
                                                    goto regen_code
                                                end
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE rift_verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified()
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM rift_verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true then
                                                    if RIFT.CheckTokens(source, user_id) then 
                                                        deferrals.done("[RIFT]: You are banned from this server, please do not try to evade your ban.")
                                                    end
                                                    RIFT.users[ids[1]] = user_id
                                                    RIFT.rusers[user_id] = ids[1]
                                                    RIFT.user_tables[user_id] = {}
                                                    RIFT.user_tmp_tables[user_id] = {}
                                                    RIFT.user_sources[user_id] = source
                                                    RIFT.getUData(user_id, "RIFT:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then RIFT.user_tables[user_id] = data end
                                                        local tmpdata = RIFT.getUserTmpTable(user_id)
                                                        RIFT.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                            MySQL.execute("RIFT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[RIFT] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("RIFT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                            Wait(500)
                                                            deferrals.done()
                                                        end)
                                                    end)
                                                else
                                                    show_auth_card(code, deferrals, check_verified)
                                                end
                                            end
                                            show_auth_card(code, deferrals, check_verified)
                                        else
                                            deferrals.update("[RIFT] Checking discord verification...")
                                            if not tRIFT.checkForRole(user_id, '1162343507579654221') then
                                            deferrals.done("[RIFT]: You are required to be verified within discord.gg/rift to join the server. If you previously were verified, please contact management.")
                                            end
                                            if RIFT.CheckTokens(source, user_id) then 
                                                deferrals.done("[RIFT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                            end
                                            RIFT.users[ids[1]] = user_id
                                            RIFT.rusers[user_id] = ids[1]
                                            RIFT.user_tables[user_id] = {}
                                            RIFT.user_tmp_tables[user_id] = {}
                                            RIFT.user_sources[user_id] = source
                                            RIFT.getUData(user_id, "RIFT:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then RIFT.user_tables[user_id] = data end
                                                local tmpdata = RIFT.getUserTmpTable(user_id)
                                                RIFT.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("RIFT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[RIFT] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("RIFT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO rift_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end
                                else -- already connected
                                    if RIFT.CheckTokens(source, user_id) then 
                                        deferrals.done("[RIFT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                    end
                                    print("[RIFT] "..name.." Reconnected | PermID: "..user_id)
                                    TriggerEvent("RIFT:playerRejoin", user_id, source, name)
                                    Wait(500)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = RIFT.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                Debug.pend()
                            else
                                print("[RIFT] "..name.." ("..GetPlayerName(source)..") rejected: not whitelisted (Perm ID = "..user_id..")")
                                deferrals.done("[RIFT] Not whitelisted (Perm ID = "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[RIFT] Fetching Tokens...")
                        RIFT.StoreTokens(source, user_id) 
                        RIFT.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    RIFT.setBanned(user_id,false)
                                    if RIFT.rusers[user_id] == nil then -- not present on the server, init
                                        RIFT.users[ids[1]] = user_id
                                        RIFT.rusers[user_id] = ids[1]
                                        RIFT.user_tables[user_id] = {}
                                        RIFT.user_tmp_tables[user_id] = {}
                                        RIFT.user_sources[user_id] = source
                                        deferrals.update("[RIFT] Loading datatable...")
                                        RIFT.getUData(user_id, "RIFT:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then RIFT.user_tables[user_id] = data end
                                            local tmpdata = RIFT.getUserTmpTable(user_id)
                                            deferrals.update("[RIFT] Getting last login...")
                                            RIFT.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("RIFT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                print("[RIFT] "..name.." ("..GetPlayerName(source)..") joined after his ban expired. (Perm ID = "..user_id..")")
                                                TriggerEvent("RIFT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[RIFT] "..name.." ("..GetPlayerName(source)..") re-joined after his ban expired.  (Perm ID = "..user_id..")")
                                        TriggerEvent("RIFT:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        local tmpdata = RIFT.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[RIFT] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[RIFT] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/rift")
                            else 
                                print("[RIFT] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[RIFT] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/rift")
                            end
                        end)
                    end
                end)
            else
                print("[RIFT] "..name.." ("..GetPlayerName(source)..") rejected: identification error")
                deferrals.done("[RIFT] Identification error.")
            end
        end)
    else
        print("[RIFT] "..name.." ("..GetPlayerName(source)..") rejected: missing identifiers")
        deferrals.done("[RIFT] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = RIFT.getUserId(source)
    if user_id ~= nil then
        TriggerEvent("RIFT:playerLeave", user_id, source)
        -- save user data table
        RIFT.setUData(user_id,"RIFT:datatable",json.encode(RIFT.getUserDataTable(user_id)))
        print("[RIFT] "..GetPlayerName(source).." disconnected (Perm ID = "..user_id..")")
        RIFT.users[RIFT.rusers[user_id]] = nil
        RIFT.rusers[user_id] = nil
        RIFT.user_tables[user_id] = nil
        RIFT.user_tmp_tables[user_id] = nil
        RIFT.user_sources[user_id] = nil
        print('[RIFT] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
        tRIFT.sendWebhook('leave', GetPlayerName(source).." PermID: "..user_id.." Temp ID: "..source.." disconnected", reason)
    else 
        print('[RIFT] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    RIFTclient.removeBasePlayer(-1,{source})
    RIFTclient.removePlayer(-1,{source})
end)

MySQL.createCommand("RIFT/setusername","UPDATE rift_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("RIFTcli:playerSpawned")
AddEventHandler("RIFTcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local source = source
    local user_id = RIFT.getUserId(source)
    local player = source
    RIFTclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        RIFT.user_sources[user_id] = source
        local tmp = RIFT.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        tRIFT.sendWebhook('join', GetPlayerName(source).." TempID: "..source.." PermID: "..user_id.." connected", "")
        if first_spawn then
            for k,v in pairs(RIFT.user_sources) do
                RIFTclient.addPlayer(source,{v})
            end
            RIFTclient.addPlayer(-1,{source})
            MySQL.execute("RIFT/setusername", {user_id = user_id, username = GetPlayerName(source)})
        end
        TriggerEvent("RIFT:playerSpawn",user_id,player,first_spawn)
        TriggerClientEvent("RIFT:onClientSpawn",player,user_id,first_spawn)
    end
    Debug.pend()
end)

RegisterServerEvent("RIFT:playerRespawned")
AddEventHandler("RIFT:playerRespawned", function()
    local source = source
    TriggerClientEvent('RIFT:onClientSpawn', source)
end)


exports("getServerStatus", function(params, cb)
    if staffWhitelist then
        cb("🛑 Whitelisted")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if RIFT.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

-- Welcome to the files made by Tylon and Spexxster