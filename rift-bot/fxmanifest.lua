fx_version 'cerulean'
games { 'gta5' }
author 'RIFTStudios'
description 'This is a discord bot made by RIFTStudios.'

server_only 'yes'

dependency 'yarn'

server_scripts {
    "@rift/lib/utils.lua",
    "bot.js"
}

server_exports {
    'dmUser',
}