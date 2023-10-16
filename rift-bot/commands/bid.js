const Discord = require('discord.js');
const fs = require('fs');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');
let prevbids = require(resourcePath + '/prevbid.json');
let minBid = settingsjson.settings.minBid;
let prevBid = prevbids.prevbid;

exports.runcmd = (fivemexports, client, message, params) => {
    message.delete();
    let user = message.author;
    if (!params[0]) {
      return;
    }
    if (message.channel.name.includes('auction-room')) {
      return;
    }
    if (params[0] < minBid) {
      let embed = {
        "title": `RIFT Auction`,
        "description": `Minimum bid is £${minBid}.`,
        "color": settingsjson.settings.botColour,
        "timestamp": new Date()
      };
      message.channel.send({ embed }).then(msg => msg.delete(5000));
      return;
    }
    fivemexports.ghmattimysql.execute("SELECT user_id FROM `rift_verification` WHERE discord_id = ?", [user.id], (result) => {
      if (result.length > 0) {
        fivemexports.ghmattimysql.execute("SELECT * FROM rift_user_moneys WHERE user_id = ?", [result[0].user_id], (result) => {
          if (result) {
            bank = result[0].bank;
            if (message.channel.name.includes('auction')) {
              if (bank > params[0]) {
                if (params[0] >= prevbids.prevbid + parseInt(minBid)) {
                  let embed = {
                    "title": `RIFT Auction`,
                    "description": `${message.author.username} has bid £${params[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')} on the auction.`,
                    "color": 0x57f288,
                    "footer": {
                      "text": `User ID: ${result[0].user_id}`
                  },
                    "timestamp": new Date()
                  };
                  embed.author = {
                    name: "New bid placed!",
                    icon_url: `${message.author.avatarURL}`,
                  };

                  message.channel.send({ embed });
                  prevbids.prevbid = parseInt(params[0]);
                  prevbids.prevbidder = user.id;
                  fs.writeFile(`${resourcePath}/prevbid.json`, JSON.stringify(prevbids), function (err) { });
                } else {
                  let embed = {
                    "description": `You must bid be £100,000 or higher than the previous one.`,
                    "color": 0xed4245,
                  };
                  message.channel.send({ embed }).then(msg => msg.delete(5000));
                }
              } else {
                let embed = {
                  "description": `You do not have £${params[0].replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')}.`,
                  "color": 0xed4245,
                };
                message.channel.send({ embed }).then(msg => msg.delete(5000));
              }
            }
          }
        })
      } else {
        message.reply('You do not have a Perm ID linked to your Discord account.').then(msg => msg.delete(5000));
      }
    });
}

// TBC ADD IF BANNED CANT BID :)

exports.conf = {
  name: "bid",
  perm: 0,
  guild: "1162343507579654214"
}