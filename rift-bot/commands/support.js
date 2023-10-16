const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://discord.gg/8Ygzf7PUhY')
}

exports.conf = {
    name: "support",
    perm: 0,
    guild: "1162343507579654214"
}