fx_version 'bodacious'
games { 'gta5' }

author 'Erryial#7897'
description 'Keymaster'
version '1.0'

client_scripts {
    'client/*.lua',
}

ui_page {
    'html/index.html',
}
files {
    'html/index.html',
    'html/asset-manifest.json',
    'html/static/css/*.css',
    'html/static/css/*.map',
    'html/static/js/*.js',
    'html/static/js/*.map',
    'html/static/media/*.svg',
}

export 'StartKeyMaster'