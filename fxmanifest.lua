fx_version 'cerulean'
games      { 'gta5' }
lua54      'yes'

author      'CharlesHacks#9999'
description '3D positional audio library for FiveM.'
version     '0.0.1'

--
-- Server
--

server_scripts {
    'config.lua',

    'server/server.lua',
}

--
-- Client
--

client_scripts {
    'config.lua',

    'client/client.lua',
}

--
-- NUI
--

ui_page 'nui/nui.html'

files {
    'nui/nui.html',
    'nui/app.js',

    'nui/lib/*.js',

    'sounds/**/*.ogg',
}