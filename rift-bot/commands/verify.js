const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = async(fivemexports, client, message, params) => {
    if(message.channel.name === "・verify"){
        message.delete();
    }
    if (!params[0] && !parseInt(params[0])) {
        let embed = {
            "title": "Verify",
            "description": `:x: Invalid command usage \`${process.env.PREFIX}verify [code]\``,
            "color": 0xed4245,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed }).then(msg => {
            msg.delete(5000)
        })
    }
    fivemexports.ghmattimysql.execute("SELECT * FROM `rift_verification` WHERE code = ?", [params[0]], (code) => {
        if (code.length > 0) {
           if (code[0].discord_id === null ){
            fivemexports.ghmattimysql.execute("UPDATE `rift_verification` SET discord_id = ?, verified = 1 WHERE code = ?", [message.author.id, params[0]], async (result) => {
                if (result) {
                    let embed = {
                        "description": `:white_check_mark: Account successfully verified with RIFT!`,
                        "color": 0x57f288,
                    }
                    message.channel.send({ embed }).then(msg => {
                        msg.delete(5000)
                    })
                    await message.member.addRole("1150349001300914306").then().catch(console.error);
                }
            });
           }
           else{
            message.channel.send(`A discord account is already linked to this Perm ID, please contact Management to reverify.`).then(msg => {
                msg.delete(5000)
            }).catch(console.error);
           }
        }
        else {
            message.channel.send(`code \`\`${params[0]}\`\` does not exist.`).then(msg => {
                msg.delete(5000);
            }).catch(console.error);
        }     
    })
}

exports.conf = {
    name: "verify",
    perm: 0,
    guild: "1162343507579654214"
}