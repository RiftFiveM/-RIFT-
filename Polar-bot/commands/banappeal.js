const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('https://Polarstudios.uk/forums/index.php?/forms/4-unban-appeal/')
}

exports.conf = {
    name: "banappeal",
    perm: 0,
    guild: "1167224647142621236"
}