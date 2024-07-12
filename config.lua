Config = {}

-- Framework options: 'qbr', 'vorp', 'rsg', 'theluxempire'
Config.Framework = 'qbr'

-- Notification options: 'ox_lib', 'mythic_notify', 'esx', etc.
Config.NotificationSystem = 'ox_lib'

-- Target options: 'qtarget', 'ox_target', etc.
Config.TargetSystem = 'qtarget'

-- General settings
Config.Debug = true
Config.VersionCheck = true

-- Webhook settings
Config.Webhook = {
    Enabled = true,
    URL = 'https://yourwebhookurl.com/webhook'
}

-- Logging settings
Config.Logging = {
    Enabled = true,
    LogFile = 'vehicle_fix.log'
}

-- Vehicle settings
Config.Vehicle = {
    SpawnLocations = {
        {x = 1325.0, y = -1291.0, z = 76.0},
        {x = -1783.0, y = -408.0, z = 157.0}
    },
    DefaultVehicle = 'wagon2',
    AllowedVehicles = {'wagon2', 'wagon3', 'wagon4'}
}

-- Boat settings
Config.Boat = {
    SpawnLocations = {
        {x = 1295.0, y = -1205.0, z = 43.0},
        {x = -1600.0, y = -800.0, z = 90.0}
    },
    DefaultBoat = 'rowboat',
    AllowedBoats = {'rowboat', 'canoe'}
}

-- Function to log debug messages
function Config.DebugPrint(message)
    if Config.Debug then
        print(('[DEBUG] %s'):format(message))
    end
end

-- Function to send a webhook message
function Config.SendWebhook(message)
    if Config.Webhook.Enabled then
        PerformHttpRequest(Config.Webhook.URL, function(err, text, headers) end, 'POST', json.encode({content = message}), {['Content-Type'] = 'application/json'})
    end
end

-- Function to log messages to a file
function Config.LogToFile(message)
    if Config.Logging.Enabled then
        local file = io.open(Config.Logging.LogFile, "a")
        if file then
            file:write(('[%s] %s\n'):format(os.date('%Y-%m-%d %H:%M:%S'), message))
            file:close()
        end
    end
end

-- Version check function
function Config.CheckVersion()
    PerformHttpRequest('https://api.github.com/repos/thelux/thelux_rdr_vehfix/releases/latest', function(err, response, headers)
        if err == 200 then
            local data = json.decode(response)
            if data and data.tag_name and data.tag_name ~= Config.Version then
                print(('New version available: %s (current: %s)'):format(data.tag_name, Config.Version))
            end
        end
    end, 'GET', '', {['Content-Type'] = 'application/json'})
end

-- https://github.com/iboss21
