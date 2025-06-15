local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"
local tabletProp = nil
local json = require 'json'

function StartTabletAnim()
    local playerPed = PlayerPedId()
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Wait(10) end
    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
    -- Spawn tablet prop
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    tabletProp = CreateObject(GetHashKey("prop_cs_tablet"), x, y, z+0.2, true, true, true)
    AttachEntityToEntity(tabletProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end

function StopTabletAnim()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    if tabletProp and DoesEntityExist(tabletProp) then
        DeleteEntity(tabletProp)
        tabletProp = nil
    end
end


local minigames = {
    {
        ["title"] = "Firewall Pulse",
        ["icon"] = "fas fa-bolt",
        ["description"] = "React quickly to firewall pulses.",
        ["startFunction"] = "StartFirewallPulse"
    },
    {
        ["title"] = "Backdoor Sequence",
        ["icon"] = "fas fa-door-open",
        ["description"] = "Input the correct backdoor sequence.",
        ["startFunction"] = "StartBackdoorSequence"
    },
    {
        ["title"] = "Circuit Rhythm",
        ["icon"] = "fas fa-music",
        ["description"] = "Match the circuit rhythm.",
        ["startFunction"] = "StartCircuitRhythm"
    },
    {
        ["title"] = "Surge Override",
        ["icon"] = "fas fa-bolt-lightning",
        ["description"] = "Override the surge in time.",
        ["startFunction"] = "StartSurgeOverride"
    },
    {
        ["title"] = "Circuit Breaker",
        ["icon"] = "fas fa-plug",
        ["description"] = "Break the circuit correctly.",
        ["startFunction"] = "StartCircuitBreaker"
    },
    {
        ["title"] = "Data Crack",
        ["icon"] = "fas fa-database",
        ["description"] = "Crack the data code.",
        ["startFunction"] = "StartDataCrack"
    },
    {
        ["title"] = "Brute Force",
        ["icon"] = "fas fa-key",
        ["description"] = "Brute force the password.",
        ["startFunction"] = "StartBruteForce"
    },
    {
        ["title"] = "VAR Hack",
        ["icon"] = "fas fa-code",
        ["description"] = "Hack the VAR system.",
        ["startFunction"] = "StartVarHack"
    }
}

function StartFirewallPulse()
    return exports['glitch-minigames']:StartFirewallPulse()
end

function StartBackdoorSequence()
    return exports['glitch-minigames']:StartBackdoorSequence(3, 20, 20, 3, 2.0, 3, 6, {'W', 'A', 'S', 'D'}, 'W, A, S, D only')
end

function StartCircuitRhythm()
    return exports['glitch-minigames']:StartCircuitRhythm()
end

function StartSurgeOverride()
    return exports['glitch-minigames']:StartSurgeOverride()
end

function StartCircuitBreaker()
    return exports['glitch-minigames']:StartCircuitBreaker(2, 1, 1000, 5000, 5000, 10000, 3000, 30000)
end

function StartDataCrack()
    return exports['glitch-minigames']:StartDataCrack(3)
end

function StartBruteForce()
    return exports['glitch-minigames']:StartBruteForce(5)
end

function StartVarHack()
    return exports['glitch-minigames']:StartVarHack(5, 5)
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
    StartTabletAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showTablet',
        minigames = minigames 
    })
end, false)

RegisterNUICallback('closeTablet', function(_, cb)
    StopTabletAnim()
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('rinsey-hacks:openTablet', function()
    StartTabletAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showTablet',
        minigames = minigames 
    })
end)
