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
            ["text"] = "Welcome to Polar, to join our server please verify your discord account by following the steps below.",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the Polar discord (discord.gg/f3BWQpG3bR)",
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
                    ["url"] = "https://discord.gg/f3BWQpG3bR"
                }
            }
        },
    }
}

Debug.active = config.debug
Polar = {}
Proxy.addInterface("Polar",Polar)

tPolar = {}
Tunnel.bindInterface("Polar",tPolar) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
Polar.lang = Lang.new(dict)

-- init
Polarclient = Tunnel.getInterface("Polar","Polar") -- server -> client tunnel

Polar.users = {} -- will store logged users (id) by first identifier
Polar.rusers = {} -- store the opposite of users
Polar.user_tables = {} -- user data tables (logger storage, saved to database)
Polar.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
Polar.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_users(
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
    CREATE TABLE IF NOT EXISTS Polar_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES Polar_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES Polar_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_vehicles(
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
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES Polar_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES Polar_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_warnings (
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
    CREATE TABLE IF NOT EXISTS Polar_gangs (
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
    CREATE TABLE IF NOT EXISTS Polar_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES Polar_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_dvsa(
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
    CREATE TABLE IF NOT EXISTS Polar_subscriptions(
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_verification(
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
    CREATE TABLE IF NOT EXISTS Polar_community_pot (
    Polar VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (Polar)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS Polar_police_hours (
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
    MySQL.SingleQuery("ALTER TABLE Polar_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE Polar_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE Polar_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE Polar_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE Polar_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE Polar_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("Polarls/create_modifications_column", "alter table Polar_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("Polarls/update_vehicle_modifications", "update Polar_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("Polarls/get_vehicle_modifications", "select modifications, vehicle_plate from Polar_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("Polarls/create_modifications_column")
    print("[Polar] ^2Base tables initialised.^0")
end)

MySQL.createCommand("Polar/create_user","INSERT INTO Polar_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("Polar/add_identifier","INSERT INTO Polar_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("Polar/userid_byidentifier","SELECT user_id FROM Polar_user_ids WHERE identifier = @identifier")
MySQL.createCommand("Polar/identifier_all","SELECT * FROM Polar_user_ids WHERE identifier = @identifier")
MySQL.createCommand("Polar/select_identifier_byid_all","SELECT * FROM Polar_user_ids WHERE user_id = @id")

MySQL.createCommand("Polar/set_userdata","REPLACE INTO Polar_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("Polar/get_userdata","SELECT dvalue FROM Polar_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("Polar/set_srvdata","REPLACE INTO Polar_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("Polar/get_srvdata","SELECT dvalue FROM Polar_srv_data WHERE dkey = @key")

MySQL.createCommand("Polar/get_banned","SELECT banned FROM Polar_users WHERE id = @user_id")
MySQL.createCommand("Polar/set_banned","UPDATE Polar_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("Polar/set_identifierbanned","UPDATE Polar_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("Polar/getbanreasontime", "SELECT * FROM Polar_users WHERE id = @user_id")

MySQL.createCommand("Polar/get_whitelisted","SELECT whitelisted FROM Polar_users WHERE id = @user_id")
MySQL.createCommand("Polar/set_whitelisted","UPDATE Polar_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("Polar/set_last_login","UPDATE Polar_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("Polar/get_last_login","SELECT last_login FROM Polar_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("Polar/add_token","INSERT INTO Polar_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("Polar/check_token","SELECT user_id, banned FROM Polar_user_tokens WHERE token = @token")
MySQL.createCommand("Polar/check_token_userid","SELECT token FROM Polar_user_tokens WHERE user_id = @id")
MySQL.createCommand("Polar/ban_token","UPDATE Polar_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- removing anticheat ban entry
MySQL.createCommand("ac/delete_ban","DELETE FROM Polar_anticheat WHERE @user_id = user_id")


-- init tables


-- identification system

function Polar.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    if ids ~= nil and #ids then
        local i = 0
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("Polar/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
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
                MySQL.query("Polar/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("Polar/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        for k,v in pairs(Polar.getUsers()) do
                            Polarclient.notify(v, {'~g~You have received £25,000 as someone new has joined the server.'})
                            Polar.giveBankMoney(k, 25000)
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

-- return identification string for the source (used for non Polar identifications, for rejected players)
function Polar.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    return idk
end

function Polar.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function Polar.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function Polar.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    Polar.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            Polar.StoreTokens(source, user_id) 
            if Polar.rusers[user_id] == nil then -- not present on the server, init
                Polar.users[ids[1]] = user_id
                Polar.rusers[user_id] = ids[1]
                Polar.user_tables[user_id] = {}
                Polar.user_tmp_tables[user_id] = {}
                Polar.user_sources[user_id] = source
                Polar.getUData(user_id, "Polar:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then Polar.user_tables[user_id] = data end
                    local tmpdata = Polar.getUserTmpTable(user_id)
                    Polar.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("Polar/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[Polar] "..name.." ("..GetPlayerName(source)..") joined (Perm ID = "..user_id..")")
                        TriggerEvent("Polar:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("Polar:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[Polar] "..name.." ("..GetPlayerName(source)..") re-joined (Perm ID = "..user_id..")")
                TriggerEvent("Polar:playerRejoin", user_id, source, name)
                TriggerClientEvent("Polar:CheckIdRegister", source)
                local tmpdata = Polar.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

exports("Polarbot", function(method_name, params, cb)
    if cb then 
        cb(Polar[method_name](table.unpack(params)))
    else 
        return Polar[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("Polar:CheckID")
AddEventHandler("Polar:CheckID", function()
    local source = source
    local user_id = Polar.getUserId(source)
    if not user_id then
        Polar.ReLoadChar(source)
    end
end)

function Polar.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("Polar/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

function Polar.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("Polar/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

function Polar.setWhitelisted(user_id,whitelisted)
    MySQL.execute("Polar/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

function Polar.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("Polar/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function Polar.fetchBanReasonTime(user_id,cbr)
    MySQL.query("Polar/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function Polar.setUData(user_id,key,value)
    MySQL.execute("Polar/set_userdata", {user_id = user_id, key = key, value = value})
end

function Polar.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("Polar/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function Polar.setSData(key,value)
    MySQL.execute("Polar/set_srvdata", {key = key, value = value})
end

function Polar.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("Polar/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for Polar internal persistant connected user storage
function Polar.getUserDataTable(user_id)
    return Polar.user_tables[user_id]
end

function Polar.getUserTmpTable(user_id)
    return Polar.user_tmp_tables[user_id]
end

function Polar.isConnected(user_id)
    return Polar.rusers[user_id] ~= nil
end

function Polar.isFirstSpawn(user_id)
    local tmp = Polar.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function Polar.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return Polar.users[ids[1]]
        end
    end
    return nil
end

-- return map of user_id -> player source
function Polar.getUsers()
    local users = {}
    for k,v in pairs(Polar.user_sources) do
        users[k] = v
    end
    return users
end

-- return source or nil
function Polar.getUserSource(user_id)
    return Polar.user_sources[user_id]
end

function Polar.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('Polar/identifier_all', {identifier = v}, function(rows)
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

function Polar.BanIdentifiers(user_id, value)
    MySQL.query('Polar/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("Polar/set_identifierbanned", {banned = value, iden = rows[i].identifier })
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

function Polar.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("Polar/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        Polar.BanIdentifiers(user_id, true)
        Polar.BanTokens(user_id, true) 
    else 
        MySQL.execute("Polar/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        Polar.BanIdentifiers(user_id, false)
        Polar.BanTokens(user_id, false) 
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function Polar.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = Polar.getUserId(adminsource)
    local getBannedPlayerSrc = Polar.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then
            Polar.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
            Polar.kick(getBannedPlayerSrc,"[Polar] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/f3BWQpG3bR") 
        else
            Polar.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
            Polar.kick(getBannedPlayerSrc,"[Polar] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/f3BWQpG3bR") 
        end
        Polarclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            Polar.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
        else 
            Polar.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
        end
        Polarclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function Polar.banConsole(permid,time,reason)
    local adminPermID = "Polar"
    local getBannedPlayerSrc = Polar.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            Polar.setBanned(permid,true,banTime,reason, adminPermID)
            Polar.kick(getBannedPlayerSrc,"[Polar] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by Polar \nAppeal @ discord.gg/f3BWQpG3bR") 
        else 
            Polar.setBanned(permid,true,"perm",reason, adminPermID)
            Polar.kick(getBannedPlayerSrc,"[Polar] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by Polar \nAppeal @ discord.gg/f3BWQpG3bR") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            Polar.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            Polar.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end

function Polar.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = Polar.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))  
        Polar.setBanned(permid,true,banTime,reason, adminPermID)
        if getBannedPlayerSrc then 
            Polar.kick(getBannedPlayerSrc,"[Polar] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/f3BWQpG3bR") 
        end
    else 
        Polar.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then 
            Polar.kick(getBannedPlayerSrc,"[Polar] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/f3BWQpG3bR") 
        end
    end
end

-- To use token banning you need the latest artifacts.
function Polar.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("Polar/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("Polar/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function Polar.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("Polar/check_token", {token = token, user_id = user_id})
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

function Polar.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("Polar/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("Polar/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function Polar.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("Polar:save")
    Debug.pbegin("Polar save datatables")
    for k,v in pairs(Polar.user_tables) do
        Polar.setUData(k,"Polar:datatable",json.encode(v))
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
        deferrals.update("[Polar] Checking identifiers...")
        Polar.getUserIdByIdentifiers(ids, function(user_id)
            local numtokens = GetNumPlayerTokens(source)
            if numtokens == 0 then
                deferrals.done("[Polar]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                tPolar.sendWebhook('ban-evaders', 'Polar Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Token Amount: **"..numtokens.."**")
                return 
            end
            Polar.IdentifierBanCheck(source, user_id, function(status, id, bannedIdentifier)
                if status then
                    deferrals.done("[Polar]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. id)
                    tPolar.sendWebhook('ban-evaders', 'Polar Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..id.."**\n> Player Banned Identifier: **"..bannedIdentifier.."**")
                    return 
                end
            end)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[Polar] Fetching Tokens...")
                Polar.StoreTokens(source, user_id) 
                deferrals.update("[Polar] Checking banned...")
                checkforUserUpdates = userUpdates(source)
                for k,v in pairs(userForUpdates) do
                    if checkforUserUpdates == v then
                        Polar.isBanned(user_id, function(banned)
                            if banned then
                                Polar.setBanned(user_id,false)
                                Wait(500)
                            end
                        end)
                    end
                end
                Polar.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[Polar] Checking whitelisted...")
                        Polar.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if Polar.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM Polar_verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then 
                                        if verified[1]["verified"] == 0 then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM Polar_verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            ::regen_code::
                                            local checkCode = exports["ghmattimysql"]:executeSync("SELECT * FROM Polar_verification WHERE code = @code", {code = code})
                                            if checkCode ~= nil then
                                                if #checkCode > 0 then
                                                    code = math.random(100000, 999999)
                                                    goto regen_code
                                                end
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE Polar_verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified()
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM Polar_verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true then
                                                    if Polar.CheckTokens(source, user_id) then 
                                                        deferrals.done("[Polar]: You are banned from this server, please do not try to evade your ban.")
                                                    end
                                                    Polar.users[ids[1]] = user_id
                                                    Polar.rusers[user_id] = ids[1]
                                                    Polar.user_tables[user_id] = {}
                                                    Polar.user_tmp_tables[user_id] = {}
                                                    Polar.user_sources[user_id] = source
                                                    Polar.getUData(user_id, "Polar:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then Polar.user_tables[user_id] = data end
                                                        local tmpdata = Polar.getUserTmpTable(user_id)
                                                        Polar.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                            MySQL.execute("Polar/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[Polar] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("Polar:playerJoin", user_id, source, name, tmpdata.last_login)
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
                                            deferrals.update("[Polar] Checking discord verification...")
                                            if not tPolar.checkForRole(user_id, '1167225052249477273') then
                                            deferrals.done("[Polar]: You are required to be verified within discord.gg/f3BWQpG3bR to join the server. If you previously were verified, please contact management.")
                                            end
                                            if Polar.CheckTokens(source, user_id) then 
                                                deferrals.done("[Polar]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                            end
                                            Polar.users[ids[1]] = user_id
                                            Polar.rusers[user_id] = ids[1]
                                            Polar.user_tables[user_id] = {}
                                            Polar.user_tmp_tables[user_id] = {}
                                            Polar.user_sources[user_id] = source
                                            Polar.getUData(user_id, "Polar:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then Polar.user_tables[user_id] = data end
                                                local tmpdata = Polar.getUserTmpTable(user_id)
                                                Polar.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("Polar/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[Polar] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("Polar:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO Polar_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end
                                else -- already connected
                                    if Polar.CheckTokens(source, user_id) then 
                                        deferrals.done("[Polar]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                    end
                                    print("[Polar] "..name.." Reconnected | PermID: "..user_id)
                                    TriggerEvent("Polar:playerRejoin", user_id, source, name)
                                    Wait(500)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = Polar.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                Debug.pend()
                            else
                                print("[Polar] "..name.." ("..GetPlayerName(source)..") rejected: not whitelisted (Perm ID = "..user_id..")")
                                deferrals.done("[Polar] Not whitelisted (Perm ID = "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[Polar] Fetching Tokens...")
                        Polar.StoreTokens(source, user_id) 
                        Polar.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    Polar.setBanned(user_id,false)
                                    if Polar.rusers[user_id] == nil then -- not present on the server, init
                                        Polar.users[ids[1]] = user_id
                                        Polar.rusers[user_id] = ids[1]
                                        Polar.user_tables[user_id] = {}
                                        Polar.user_tmp_tables[user_id] = {}
                                        Polar.user_sources[user_id] = source
                                        deferrals.update("[Polar] Loading datatable...")
                                        Polar.getUData(user_id, "Polar:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then Polar.user_tables[user_id] = data end
                                            local tmpdata = Polar.getUserTmpTable(user_id)
                                            deferrals.update("[Polar] Getting last login...")
                                            Polar.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("Polar/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                print("[Polar] "..name.." ("..GetPlayerName(source)..") joined after his ban expired. (Perm ID = "..user_id..")")
                                                TriggerEvent("Polar:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[Polar] "..name.." ("..GetPlayerName(source)..") re-joined after his ban expired.  (Perm ID = "..user_id..")")
                                        TriggerEvent("Polar:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        local tmpdata = Polar.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[Polar] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[Polar] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/f3BWQpG3bR")
                            else 
                                print("[Polar] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[Polar] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/f3BWQpG3bR")
                            end
                        end)
                    end
                end)
            else
                print("[Polar] "..name.." ("..GetPlayerName(source)..") rejected: identification error")
                deferrals.done("[Polar] Identification error.")
            end
        end)
    else
        print("[Polar] "..name.." ("..GetPlayerName(source)..") rejected: missing identifiers")
        deferrals.done("[Polar] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = Polar.getUserId(source)
    if user_id ~= nil then
        TriggerEvent("Polar:playerLeave", user_id, source)
        -- save user data table
        Polar.setUData(user_id,"Polar:datatable",json.encode(Polar.getUserDataTable(user_id)))
        print("[Polar] "..GetPlayerName(source).." disconnected (Perm ID = "..user_id..")")
        Polar.users[Polar.rusers[user_id]] = nil
        Polar.rusers[user_id] = nil
        Polar.user_tables[user_id] = nil
        Polar.user_tmp_tables[user_id] = nil
        Polar.user_sources[user_id] = nil
        print('[Polar] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
        tPolar.sendWebhook('leave', GetPlayerName(source).." PermID: "..user_id.." Temp ID: "..source.." disconnected", reason)
    else 
        print('[Polar] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    Polarclient.removeBasePlayer(-1,{source})
    Polarclient.removePlayer(-1,{source})
end)

MySQL.createCommand("Polar/setusername","UPDATE Polar_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("Polarcli:playerSpawned")
AddEventHandler("Polarcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local source = source
    local user_id = Polar.getUserId(source)
    local player = source
    Polarclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        Polar.user_sources[user_id] = source
        local tmp = Polar.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        tPolar.sendWebhook('join', GetPlayerName(source).." TempID: "..source.." PermID: "..user_id.." connected", "")
        if first_spawn then
            for k,v in pairs(Polar.user_sources) do
                Polarclient.addPlayer(source,{v})
            end
            Polarclient.addPlayer(-1,{source})
            MySQL.execute("Polar/setusername", {user_id = user_id, username = GetPlayerName(source)})
        end
        TriggerEvent("Polar:playerSpawn",user_id,player,first_spawn)
        TriggerClientEvent("Polar:onClientSpawn",player,user_id,first_spawn)
    end
    Debug.pend()
end)

RegisterServerEvent("Polar:playerRespawned")
AddEventHandler("Polar:playerRespawned", function()
    local source = source
    TriggerClientEvent('Polar:onClientSpawn', source)
end)


exports("getServerStatus", function(params, cb)
    if staffWhitelist then
        cb("🛑 Whitelisted")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if Polar.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

-- Welcome to the files made by Tylon and Spexxster