-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/demo.ogg',
    'client/html/sounds/boom.ogg',
    'client/html/sounds/metal.ogg',
    'client/html/sounds/shock.ogg',
    'client/html/sounds/thud.ogg',
    'client/html/sounds/water.ogg',
    'client/html/sounds/startup.ogg',
    'client/html/sounds/overheat.ogg',
    'client/html/sounds/acid.ogg',
}
