const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.delete()
    if (!params[0]) {
        let embed = {
            "title": "An Error Occurred",
            "description": "Incorrect Usage\n\nCorrect Usage" + process.env.PREFIX + '\n`!rulechange [description]`',
            "color": 0xed4245,
    }
    return message.channel.send({ embed })
    }
    else {
        let embed = {
            "author" : {
                name: "RIFT Announcement!",
                icon_url: "https://cdn.discordapp.com/attachments/1108459861907361802/1123313848124973076/rift.png"
            },
            //"title": `${params[0]}`,
            "description": `${params.join(' ')}`,
            "color": 0xffa358,
            "thumbnail": {
                url: 'https://cdn.discordapp.com/attachments/1125831111021445180/1126272989877501953/image.png',
            },
            "footer": {
                "text": `Posted by ${message.author.username}`
            },
            "timestamp": new Date()
        }
        const channel = client.channels.find(channel => channel.name === settingsjson.settings.RuleChangesChannel)
        channel.send({embed})
        message.channel.send(`Rule Change Sent in ${channel}`)
    }
}

exports.conf = {
    name: "rulechange",
    perm: 7,
    guild: "1147954594903761036"
}