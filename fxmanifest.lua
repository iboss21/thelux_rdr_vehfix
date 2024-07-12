fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'TheLux RDR Vehicle Fix'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua', -- Change to your language
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'config.lua',
}

dependencies {
    'rsg-core',
    'rsg-target',
    'ox_lib'
}

lua54 'yes'
