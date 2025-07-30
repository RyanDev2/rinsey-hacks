local json = require 'json'

-- If you are looking to make this have animations uncomment below 

-- function StartTabletAnim()
--     local playerPed = PlayerPedId()
--     RequestAnimDict(tabletDict)
--     while not HasAnimDictLoaded(tabletDict) do Wait(10) end
--     TaskPlayAnim(playerPed, tabletDict, tabletAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
--     -- Spawn tablet prop
--     local x, y, z = table.unpack(GetEntityCoords(playerPed))
--     tabletProp = CreateObject(GetHashKey("prop_cs_tablet"), x, y, z+0.2, true, true, true)
--     AttachEntityToEntity(tabletProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
-- end

-- function StopTabletAnim()
--     local playerPed = PlayerPedId()
--     ClearPedTasks(playerPed)
--     if tabletProp and DoesEntityExist(tabletProp) then
--         DeleteEntity(tabletProp)
--         tabletProp = nil
--     end
-- end


local minigames = {
    {
        title = 'Placeholder Minigame 1',
        icon = 'fas fa-gamepad',
        description = 'Description for placeholder minigame 1.',
        startFunction = 'startPlaceholder1',
    },
    {
        title = 'Placeholder Minigame 2',
        icon = 'fas fa-puzzle-piece',
        description = 'Description for placeholder minigame 2.',
        startFunction = 'startPlaceholder2',
    },
    {
        title = 'Placeholder Minigame 3',
        icon = 'fas fa-question',
        description = 'Description for placeholder minigame 3.',
        startFunction = 'startPlaceholder3',
    },
}

function startPlaceholder1()
    lib.notify({
        title = 'Minigame',
        description = 'Placeholder 1 executed.',
        type = 'info',
    })
    return true
end


RegisterNUICallback('startMinigame', function(data, cb)
    local func = data and data.startFunction
    local result = false
    if func and _G[func] then
        result = _G[func]()
    end
    cb({ success = result })
end)

RegisterCommand('tablet', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showTablet',
        minigames = minigames 
    })
end, false)

RegisterNUICallback('closeTablet', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('rinsey-hacks:openTablet', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showTablet',
        minigames = minigames 
    })
end)
