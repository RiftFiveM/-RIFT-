const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        // Define the JSON structure to be updated in the `dvalue` field
        const updatedData = {
            "customization": {
                "1": [0, 0],
                "0": [0, 0],
                "11": [5, 0],
                "10": [0, 0],
                "14": [0, 0],
                "15": [0, 2],
                "3": [5, 0],
                "13": [0, 0],
                "model": "mp_m_freemode_01",
                "5": [0, 0],
                "4": [4, 0],
                "2": [47, 0],
                "12": [4, 0],
                "9": [0, 1],
                "8": [0, 240],
                "7": [51, 0],
                "6": [7, 0],
                "19": [0, 0],
                "18": [0, 0],
                "17": [0, 0],
                "16": [0, 0]
            },
            "position": {
                "y": -2039.9810180663936,
                "x": -913.5539550781276,
                "z": 9.5095081329346
            },
            "groups": {
                "TutorialDone": true,
                "Supporter": true
            },
            "inventory": [],
            "weapons": {
                "GADGET_PARACHUTE": {
                    "ammo": 0
                }
            },
            "PlayerTime": 0, // Set PlayerTime to 0
            "invcap": 30
        };

        // Reset the playtime for all users in the database and update dvalue with the new JSON
        fivemexports.ghmattimysql.execute("UPDATE `Polar_user_data` SET dvalue = ?", [JSON.stringify(updatedData)], (result) => {
            message.reply('Playtime and user data have been reset for all users.');
        });
    } else {
        fivemexports.ghmattimysql.execute("SELECT * FROM `Polar_user_data` WHERE user_id = ?", [params[0]], (result) => {
            if (result.length > 0) {
                let embed = {
                    "description": `**${(JSON.parse(result[0].dvalue).PlayerTime/60).toFixed(2)}** hours`,
                    "color": settingsjson.settings.botColour,
                }
                message.reply({ embed });
            } else {
                message.reply('No hours for this user.');
            }
        });
    }
}

exports.conf = {
    name: "resethours",
    perm: 10,
    guild: "1167224647142621236"
}