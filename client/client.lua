local framework = Config.Framework
local notificationSystem = Config.NotificationSystem
local targetSystem = Config.TargetSystem

local function notify(message)
    if notificationSystem == 'ox_lib' then
        exports.ox_lib:notify({title = 'Notification', description = message})
    elseif notificationSystem == 'mythic_notify' then
        exports.mythic_notify:SendAlert('inform', message)
    elseif notificationSystem == 'esx' then
        ESX.ShowNotification(message)
    end
end

local function logAndNotify(message)
    Config.DebugPrint(message)
    Config.LogToFile(message)
    Config.SendWebhook(message)
    notify(message)
end

local function spawnVehicle(vehicleModel, spawnLocation)
    if not IsModelInCdimage(vehicleModel) or not IsModelAVehicle(vehicleModel) then
        return
    end

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(1)
    end

    local vehicle = CreateVehicle(vehicleModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, true, false)
    SetModelAsNoLongerNeeded(vehicleModel)

    logAndNotify('Vehicle spawned: ' .. vehicleModel)
end

local function spawnBoat(boatModel, spawnLocation)
    if not IsModelInCdimage(boatModel) or not IsModelABoat(boatModel) then
        return
    end

    RequestModel(boatModel)
    while not HasModelLoaded(boatModel) do
        Citizen.Wait(1)
    end

    local boat = CreateVehicle(boatModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, true, false)
    SetModelAsNoLongerNeeded(boatModel)

    logAndNotify('Boat spawned: ' .. boatModel)
end

local function initializeFramework()
    if framework == 'qbr' then
        QBRCore = exports['qbr-core']:GetCoreObject()

        RegisterNetEvent('qbr:vehicleSpawned')
        AddEventHandler('qbr:vehicleSpawned', function(vehicle)
            spawnVehicle(vehicle, Config.Vehicle.SpawnLocations[1])
        end)

        RegisterNetEvent('qbr:boatSpawned')
        AddEventHandler('qbr:boatSpawned', function(boat)
            spawnBoat(boat, Config.Boat.SpawnLocations[1])
        end)
    elseif framework == 'vorp' then
        VORPcore = {}
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)

        RegisterNetEvent('vorp:vehicleSpawned')
        AddEventHandler('vorp:vehicleSpawned', function(vehicle)
            spawnVehicle(vehicle, Config.Vehicle.SpawnLocations[1])
        end)

        RegisterNetEvent('vorp:boatSpawned')
        AddEventHandler('vorp:boatSpawned', function(boat)
            spawnBoat(boat, Config.Boat.SpawnLocations[1])
        end)
    elseif framework == 'rsg' then
        RSGCore = exports['rsg-core']:GetCoreObject()

        RegisterNetEvent('rsg:vehicleSpawned')
        AddEventHandler('rsg:vehicleSpawned', function(vehicle)
            spawnVehicle(vehicle, Config.Vehicle.SpawnLocations[1])
        end)

        RegisterNetEvent('rsg:boatSpawned')
        AddEventHandler('rsg:boatSpawned', function(boat)
            spawnBoat(boat, Config.Boat.SpawnLocations[1])
        end)
    elseif framework == 'theluxempire' then
        TheLuxEmpireCore = exports['theluxempire-core']:GetCoreObject()

        RegisterNetEvent('theluxempire:vehicleSpawned')
        AddEventHandler('theluxempire:vehicleSpawned', function(vehicle)
            spawnVehicle(vehicle, Config.Vehicle.SpawnLocations[1])
        end)

        RegisterNetEvent('theluxempire:boatSpawned')
        AddEventHandler('theluxempire:boatSpawned', function(boat)
            spawnBoat(boat, Config.Boat.SpawnLocations[1])
        end)
    end
end

local function initializeTargetSystem()
    if targetSystem == 'qtarget' then
        exports.qtarget:AddTargetModel(Config.Vehicle.AllowedVehicles, {
            options = {
                {
                    event = "vehicle:spawn",
                    icon = "fas fa-car",
                    label = "Spawn Vehicle"
                }
            },
            distance = 2.5
        })

        exports.qtarget:AddTargetModel(Config.Boat.AllowedBoats, {
            options = {
                {
                    event = "boat:spawn",
                    icon = "fas fa-ship",
                    label = "Spawn Boat"
                }
            },
            distance = 2.5
        })
    elseif targetSystem == 'ox_target' then
        exports.ox_target:addModel(Config.Vehicle.AllowedVehicles, {
            {
                name = 'spawn_vehicle',
                label = 'Spawn Vehicle',
                icon = 'fas fa-car',
                onSelect = function()
                    TriggerEvent('vehicle:spawn')
                end
            }
        })

        exports.ox_target:addModel(Config.Boat.AllowedBoats, {
            {
                name = 'spawn_boat',
                label = 'Spawn Boat',
                icon = 'fas fa-ship',
                onSelect = function()
                    TriggerEvent('boat:spawn')
                end
            }
        })
    end
end

if Config.VersionCheck then
    Config.CheckVersion()
end

initializeFramework()
initializeTargetSystem()
