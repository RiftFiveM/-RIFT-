const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');

let groups = [
  'Supporter',
  'Premium',
  'Supreme',
  'King Pin',
  'Rainmaker',
  'Baller',
];

exports.runcmd = async (fivemexports, client, message, params) => {
  let rolesCount = 0;
  let rolesOwned = [];
  let descriptionText = '';
  fivemexports.ghmattimysql.execute("SELECT user_id FROM `rift_verification` WHERE discord_id = ?", [message.author.id], (result) => {
    let user_id = result[0].user_id;
    fivemexports.ghmattimysql.execute("SELECT dvalue FROM `rift_user_data` WHERE user_id = ? AND dkey = 'RIFT:datatable'", [user_id], async (data) => {
      let groupsdata = JSON.parse(Object.values(data[0])).groups;
      for (const [key, value] of Object.entries(groupsdata)) {
        for (let j = 0; j < groups.length; j++) {
          if (groups[j] === key) {
            let role = message.guild.roles.find(r => r.name === `[${groups[j]}]`);
            console.log(`Giving ${key} role.`);
            if (role && !message.member.roles.has(role.id)) {
              rolesCount++;
              rolesOwned.push(`\n<@&${role.id}>`);
              await message.member.addRole(role.id).catch(console.error);
            }
          }
        }
      }
      let playtime = data[0].PlayerTime/60;
      if (playtime > 1000) {
        let role = message.guild.roles.find(r => r.name === `[1,000 hours]`);
        if (role && !message.member.roles.has(role.id)) {
          rolesCount++;
          rolesOwned.push(`\n<@&${role.id}>`);
          await message.member.addRole(role.id).catch(console.error);
        }
      }
      if (rolesCount > 0) {
        let embed = {
          "title": "Added the following missing roles:",
          "description": descriptionText + '\n' + rolesOwned.join('').replace(',', '') + '',
          "color": 0x1e1f22,
          "footer": {
            "text": "RIFT Studios"
          }
        };
        message.channel.send({ embed });
      } else {
        let embed = {
          "description": "You have no missing roles that need adding",
          "color": 0xed4245,
        };
        message.channel.send({ embed });
      }
    });
  });
};

exports.conf = {
  name: "getroles",
  perm: 0,
  guild: "1147954594903761036"
};
