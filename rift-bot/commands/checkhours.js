const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');

exports.runcmd = (fivemexports, client, message, params) => {
    const mentionedUser = message.mentions.users.first();

    const discordId = mentionedUser ? mentionedUser.id : message.author.id;

    fivemexports.ghmattimysql.execute("SELECT user_id FROM `rift_verification` WHERE discord_id = ?", [discordId], (discord) => {
        if (discord.length > 0) {
            fivemexports.ghmattimysql.execute("SELECT * FROM `rift_user_data` WHERE user_id = ?", [discord[0].user_id], (result) => {
                if (result.length > 0) {
                    const hours = (JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(0);
                    let response;

                    if (mentionedUser) {
                        response = `${mentionedUser} has **${hours}** hours`;
                    } else {
                        response = `<@${message.author.id}> you have **${hours}** hours`;
                    }

                    if (hours > 0) {
                        message.channel.send(response);
                    } else {
                        message.channel.send("No hours for this user.");
                    }
                } else {
                    message.reply('No groups for this user.');
                }
            });
        } else {
            message.reply('We cannot find a RIFT User ID linked to this account.');
        }
    });
};

exports.conf = {
    name: "ch",
    perm: 0,
    guild: "1147954594903761036"
};
