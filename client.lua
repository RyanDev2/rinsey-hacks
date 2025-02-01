local QBCore = exports['qb-core']:GetCoreObject()

local minigames = {
    {
        title = 'Mine Sweeper Minigame',
        icon = 'fas fa-font',
        description = 'Show your word-finding skills.',
        startFunction = 'startMineSweeper',
    },
    {
        title = 'Untangle Minigame',
        icon = 'fas fa-sort',
        description = 'Sort items accurately and fast!',
        startFunction = 'startUntangle',
    },
    {
        title = 'Path Finder Minigame',
        icon = 'fas fa-unlock',
        description = 'Crack the pin and gain access!',
        startFunction = 'startPathFinder',
    },
}

Citizen.CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.Target.coords,
        size = Config.Target.size,
        rotation = Config.Target.rotation,
        options = {
            {
                name = "minigame_menu",
                label = "Open Minigames",
                icon = "fas fa-gamepad",
                distance = Config.Target.distance,
                onSelect = function()
                    TriggerEvent("minigame:openMenu") 
                end
            }
        }
    })
end)

RegisterNetEvent('minigame:openMenu', function()
    local options = {}
    for _, minigame in ipairs(minigames) do
        table.insert(options, {
            title = minigame.title,
            icon = minigame.icon,
            description = minigame.description,
            onSelect = function()
                _G[minigame.startFunction]()
            end,
        })
    end

    table.insert(options, {
        title = 'Cancel',
        icon = 'fas fa-times',
        description = 'Close the menu.',
        onSelect = function()
            lib.hideContext()
        end,
    })

    lib.registerContext({
        id = 'minigame_menu',
        title = 'Minigame Options',
        options = options,
    })

    lib.showContext('minigame_menu')
end)

function startMineSweeper()
    local success = exports.bl_ui:MineSweeper(3, {
        grid = 4, 
        duration = 10000, 
        target = 4, 
        previewDuration = 2000 
    })
    if success then
        lib.notify({
            title = 'Minigame Completed',
            description = 'Great job!',
            type = 'success',
        })
    else
        lib.notify({
            title = 'Minigame Failed',
            description = 'Better luck next time.',
            type = 'error',
        })
    end
end

function startUntangle()
    local success = exports.bl_ui:Untangle(3, {
        numberOfNodes = 10,
        duration = 5000,
    })
    if success then
        lib.notify({
            title = 'Minigame Completed',
            description = 'Great job!',
            type = 'success',
        })
    else
        lib.notify({
            title = 'Minigame Failed',
            description = 'Better luck next time.',
            type = 'error',
        })
    end
end

function startPathFinder()
    local success = exports.bl_ui:PathFind(3, {
        numberOfNodes = 10,
        duration = 5000,
    })
    if success then
        lib.notify({
            title = 'Minigame Completed',
            description = 'Great job!',
            type = 'success',
        })
    else
        lib.notify({
            title = 'Minigame Failed',
            description = 'Better luck next time.',
            type = 'error',
        })
    end
end