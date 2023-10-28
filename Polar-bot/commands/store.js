const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
<<<<<<< HEAD:Polar-bot/commands/store.js
        "title": "Polar Store",
        "description": `https://Polar-shop.tebex.io/`,
=======
        "title": "RIFT Store",
        "description": `https://riftstudios.tebex.io`,
>>>>>>> parent of 95ce20f (clothing store fixed):rift-bot/commands/store.js
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "store",
    perm: 0,
    guild: "1167224647142621236"
}