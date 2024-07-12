fx_version 'cerulean'
game 'rdr3'

author 'theluxempire - iBoss21'
description 'Advanced Vehicle Fix for RedM, compatible with multiple frameworks and notification/target systems'
version '1.0.0'

shared_script 'config.lua'

client_script 'client/client.lua'
server_script 'server/server.lua'

-- Ensure the resource name is correct
local resource_name = GetCurrentResourceName()
if resource_name ~= 'thelux_rdr_vehfix' then
    print('This resource must be named "thelux_rdr_vehfix" for it to work correctly.')
    return
end
