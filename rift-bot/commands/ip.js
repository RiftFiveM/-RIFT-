const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    message.channel.send('F8 -> **connect s1.rift.city**')
}

exports.conf = {
    name: "ip",
    perm: 0,
    guild: "1147954594903761036"
}