const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
        "title": "RIFT Staff Applications",
        "description": `https://docs.google.com/forms/d/16_ygmcgjuNAiZ5wXy1ipjxD09EReDyO9baqaJ_6Q620/edit`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "staffapp",
    perm: 0,
    guild: "1162343507579654214"
}