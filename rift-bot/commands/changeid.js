const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
  
    if (!params[0] || !(params[1])) {
        let embed = {
            "title": "An Error Occurred",
            "description": "Incorrect Usage\n\nCorrect Usage" + process.env.PREFIX + '\n`!changeid [old perm id] [new perm id]`',
            "color": 0xed4245,
    }
    return message.channel.send({ embed })
    }
    fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_ids WHERE user_id = ?", [parseInt(params[0])], (change) => {
        fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_ids WHERE user_id = ?", [parseInt(params[1])], (changeto) => {
            for (i = 0; i < change.length; i++) {
                fivemexports['ghmattimysql'].execute('UPDATE rift_user_ids SET user_id = ? WHERE identifier = ?', [parseInt(params[1]), change[i].identifier])
            }
            for (i = 0; i < changeto.length; i++) {
                fivemexports['ghmattimysql'].execute('UPDATE rift_user_ids SET user_id = ? WHERE identifier = ?', [parseInt(params[0]), changeto[i].identifier])
            }
            fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_data WHERE user_id = ?", [parseInt(params[0])], async(change) => {
                fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_data WHERE user_id = ?", [parseInt(params[1])], async(changeto) => {
                    //Change USER DATA
                    await fivemexports['ghmattimysql'].execute("DELETE FROM rift_user_data WHERE user_id = ?", [parseInt(params[0])])
                    await fivemexports['ghmattimysql'].execute("DELETE FROM rift_user_data WHERE user_id = ?", [parseInt(params[1])])
                    for (i = 0; i < change.length; i++) {
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:datatable", change[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:Face:Data", change[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:home:wardrobe", change[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:police_records", change[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:jail:time", change[i].dvalue])
                    }
                    for (i = 0; i < changeto.length; i++) {
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:datatable", changeto[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:Face:Data", changeto[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:home:wardrobe", changeto[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:police_records", changeto[i].dvalue])
                        fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:jail:time", changeto[i].dvalue])
                    }
                })
            })
            fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_data WHERE user_id = ?", [parseInt(params[0])], (change) => {
                fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_data WHERE user_id = ?", [parseInt(params[1])], (changeto) => {
                   // Change USER DATA
                    fivemexports['ghmattimysql'].execute("DELETE FROM rift_user_data WHERE user_id = ?", [parseInt(params[0])])
                    fivemexports['ghmattimysql'].execute("DELETE FROM rift_user_data WHERE user_id = ?", [parseInt(params[1])])
                    setTimeout(() => {

                        for (i = 0; i < change.length; i++) {
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:datatable", change[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:Face:Data", change[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:home:wardrobe", change[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:police_records", change[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[1]), "RIFT:jail:time", change[i].dvalue])
                        }
                        for (i = 0; i < changeto.length; i++) {
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:datatable", changeto[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:Face:Data", changeto[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:home:wardrobe", changeto[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:police_records", changeto[i].dvalue])
                            fivemexports['ghmattimysql'].execute('INSERT INTO rift_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(params[0]), "RIFT:jail:time", changeto[i].dvalue])
                        }
                    }, 500);
                })
            })
            fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_moneys WHERE user_id = ?", [parseInt(params[0])], (change) => {
                fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_moneys WHERE user_id = ?", [parseInt(params[1])], (changeto) => {
                    for (i = 0; i < change.length; i++) {
                        fivemexports['ghmattimysql'].execute('UPDATE rift_user_moneys SET user_id = ? WHERE user_id = ?', [parseInt(params[1]), change[i].vehicle])
                    }
                    for (i = 0; i < changeto.length; i++) {
                        fivemexports['ghmattimysql'].execute('UPDATE rift_user_moneyss SET user_id = ? WHERE user_id = ?', [parseInt(params[0]), changeto[i].vehicle])
                    }
                })
            })
            fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_vehicles WHERE user_id = ?", [parseInt(params[0])], (change) => {
                fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_vehicles WHERE user_id = ?", [parseInt(params[1])], (changeto) => {
                    for (i = 0; i < change.length; i++) {
                        setInterval(() => {
                            fivemexports['ghmattimysql'].execute('UPDATE rift_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(params[1]), change[i].vehicle])
                        }, 2000);
                    }
                    for (i = 0; i < changeto.length; i++) {
                        setInterval(() => {
                            fivemexports['ghmattimysql'].execute('UPDATE rift_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(params[0]), changeto[i].vehicle])
                        }, 2000);
                    }

                })
            })
            fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_homes WHERE user_id = ?", [parseInt(params[0])], (change) => {
                fivemexports['ghmattimysql'].execute("SELECT * FROM rift_user_homes WHERE user_id = ?", [parseInt(params[1])], (changeto) => {
                    for (i = 0; i < change.length; i++) {
                        fivemexports['ghmattimysql'].execute('UPDATE rift_user_homes SET user_id = ? WHERE home = ?', [parseInt(params[1]), change[i].home])
                    }
                    for (i = 0; i < changeto.length; i++) {
                        fivemexports['ghmattimysql'].execute('UPDATE rift_user_homes SET user_id = ? WHERE home = ?', [parseInt(params[0]), changeto[i].home])
                    }
                })
            })                
        })
    })
    let embed = {
        "title": "Change Perm ID",
        "description": `\nOld Perm ID: **${params[0]}**\nNew Perm ID: **${params[1]}**\n\nAdmin: <@${message.author.id}>`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "changeid",
    perm: 5,
    guild: "1147954594903761036"
}