exports.runcmd = (fivemexports, client, message, params) => {
    message.delete()
    if (!params[0]) {
        let embed = {
            "title": "An Error Occurred",
            "description": "Incorrect Usage\n\nCorrect Usage" + process.env.PREFIX + '\n`!vote [vote contents]`',
            "color": 0xed4245,
    }
    return message.channel.send({ embed })
    }
    const resourcePath = global.GetResourcePath ?
        global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
    require('dotenv').config({ path: path.join(resourcePath, './.env') })
    const settingsjson = require(resourcePath + '/settings.js')

    const vote = params.slice(0).join(' ');

    let embed = {
        "title": "RIFT Vote!",
        "description": `\n${vote}`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": `Please vote to make an impact on the server.`
        },
        "timestamp": new Date()
    }
    const channel = client.channels.find(channel => channel.name === settingsjson.settings.VoteChannel)
    
    channel.send({embed}).then(function (message) {
        message.react("👍")
        message.react("👎")
    })
    //channel.send(`||@everyone||`)
    message.channel.send(`Started vote in ${channel}`)
}

exports.conf = {
    name: "vote",
    perm: 10,
    guild: "1147954594903761036"
}