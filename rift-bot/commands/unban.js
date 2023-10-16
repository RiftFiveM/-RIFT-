const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        let embed = {
            "title": "An Error Occurred",
            "description": "Incorrect Usage\n\nCorrect Usage" + process.env.PREFIX + '\n`!unban [permid]`',
            "color": 0xed4245,
    }
    return message.channel.send({ embed })
    }
    const reason = params.slice(1).join(' ');
    let newval = fivemexports.rift.riftbot('setBanned', [params[0], false])
    let embed = {
        "title": "Unbanned User",
        "description": `\nPerm ID: **${params[0]}**\n\nAdmin: <@${message.author.id}>`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "unban",
    perm: 5,
    guild: "1162343507579654214",
    support: true,
}