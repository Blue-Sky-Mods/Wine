local Result = nil
local NUI_status = false

local DefaultSettings = {
    keys = {"W", "A", "S", "D"}, -- Send a result message if true and callback when message closed or callback immediately without showing the message
    speed = 30, -- pixels / second
    winScore = 50, -- Score to win
    loseScore = -25,
    missScore = -5 -- Lose if this score is reached
}

function StartKeyMaster(settings)
    Result = nil
    if settings == nil then
        settings = DefaultSettings
    end

    SendNUIMessage({
        app = 'keymaster',
        method = 'setConfig',
        data = settings
    })

    NUI_status = true
    SendNUIMessage({
        app = 'keymaster',
        method = 'start',
        data = true
    })
    while NUI_status do
        Wait(5)
        SetNuiFocus(NUI_status, NUI_status)
    end
    Wait(100)
    SetNuiFocus(false, false)
    return Result
end

RegisterNUICallback('success', function()
    Result = true
    Wait(100)
    NUI_status = false
end)

RegisterNUICallback('fail', function()
    Result = false
    Wait(100)
    NUI_status = false
end)

--[[RegisterCommand('keymaster', function() --TEST COMMAND
	local CustomSettings = {
        settings = {
            handleEnd = true;  --Send a result message if true and callback when message closed or callback immediately without showing the message
            speed = 10; --pixels / second
            scoreWin = 1000; --Score to win
            scoreLose = -150; --Lose if this score is reached
            maxTime = 60000; --sec
            maxMistake = 5; --How many missed keys can there be before losing
            speedIncrement = 1; --How much should the speed increase when a key hit was successful
        },
        --keys = {"a", "w", "d", "s", "g"}; --You can keep this hashed out if you want to use default keys in the java side.
    }
    StartKeyMaster(CustomSettings)
end)]]
