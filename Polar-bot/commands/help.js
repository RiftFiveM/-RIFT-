const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    const commandList = client.commands.map(cmd => `! ${cmd.conf.name}`).join('\n');
    const embed = {
        "title": " Polar Droid Help",
        "description": "" + '__**Prefix**__\n ! \n\n__**Commands**__ \n**bid** \n**getroles**\n**checkhours**\n**help**\n**howmanycars**\n**verify**\n**ts**\n**forums**\n**merch**\n**locklist**\n**twitter**\n**fivemrules**\n**suggestion**\n**banappeal**\n**nhscord**\n**pdcord**\n**bug**\n**discord**\n**loadingsong**\n**catalogue**\n**Polartrader**\n**support**\n**logs**\n**hmp**\n**fivemapp**\n**report**\n**gunguide**\n**ip**\n**linktwitter**\n**faq**\n**soa**\n**donate**\n**store**\n**server-status**\n**ss**\n**crashes**\n**deathmatch**\n**lfb**\n**connect** ' + " ",
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed });
}


// "description": `Here is a list of available commands:\n${commandList}`,

exports.conf = {
    name: "help",
    guild: "1167224647142621236"
}
