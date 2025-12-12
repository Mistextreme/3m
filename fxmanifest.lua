fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name '3M Dealership'
author '3M Studio'
version '1.1.1'
description 'Dynamic Dealership: cinematic flow, dynamic market, test drive, financing, consignment'

dependencies {
  '/server:5181',
  'oxmysql',
 -- 'ox_lib',
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
  'locales/*.lua',
  'shared/vehicle.prices.lua'  
}

server_scripts {
  'server/notify.lua', 
  '@oxmysql/lib/MySQL.lua',
  'server/utils.lua',
  'server/market.lua',
  'server/finance.lua',
  'server/consignment.lua',
  'server/admin.lua',
  'server/main.lua',
  'server/consign.lua',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          'server/utils/.specHelper.js',
}

client_scripts {
  'client/notify.lua', 
  'client/debugcam.lua',
  'client/cams.lua',
  'client/testdrive_keys.lua',
  'client/draw.lua',
  'client/ui.lua',
  'client/main.lua',
  'client/consign.lua',
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/app.js',
  'html/style.css'
}

escrow_ignore {
  'config.lua',
  'locales/*.lua',
  'shared/vehicle.prices.lua',
  'server/utils.lua',
  'client/notify.lua',

}

dependency '/assetpacks'