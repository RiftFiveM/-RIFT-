const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    const discordId = message.author.id; // Get the Discord ID of the message author
    fivemexports.ghmattimysql.execute("SELECT user_id FROM `rift_verification` WHERE discord_id = ?", [discordId], (result) => {
        if (result.length > 0) {
            let embed = {
                "title": "Check User ID",
                "description": `Your Perm ID is: **${result[0].user_id}**`,
                "color": settingsjson.settings.botColour,
                "footer": {
                    "text": ""
                },
                "timestamp": new Date()
            }
            message.channel.send({ embed })
        } else {
            message.reply('No account is linked for your Discord ID.')
        }
    });
}

exports.conf = {
    name: "getid",
    perm: 0,
    guild: "1162343507579654214",
    support: true,
}