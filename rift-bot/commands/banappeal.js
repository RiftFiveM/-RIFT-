const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://riftstudios.uk/forums/index.php?/forms/4-unban-appeal/')
}

exports.conf = {
    name: "banappeal",
    perm: 0,
    guild: "1147954594903761036"
}