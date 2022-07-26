fx_version 'adamant'
game 'gta5'
author 'ZeBee#0433'
MadeFor 'FrenchFiveMDeveloppement'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

lua54 'yes'

escrow_ignore {
  'config.lua',  -- Only ignore one file
  'client.lua',
  'server.lua',
}