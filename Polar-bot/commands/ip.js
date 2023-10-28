const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
<<<<<<< HEAD:Polar-bot/commands/ip.js
        "title": "Server IP",
        "description": `F8 > connect ${client.ip}`,
=======
        "title": "RIFT Staff Applications",
        "description": `https://docs.google.com/forms/d/16_ygmcgjuNAiZ5wXy1ipjxD09EReDyO9baqaJ_6Q620/edit`,
>>>>>>> parent of d80eecf (....):rift-bot/commands/staffapp.js
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "ip",
    perm: 0,
    guild: "1167224647142621236"
}