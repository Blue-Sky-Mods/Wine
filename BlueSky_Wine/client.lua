Transformer = false;
Air = false;
Hopper = false;
Breaker = false;
Liquid = false;

ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then

        else
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
        end
    end
end)

local acidLevel = 5.0
local waterLoad = 0
local temperature = 70
local grapeLoad = 0
local product = {}
local isOn = false
local mistakes = 0
local callback = nil
local highqual = 0
local lowqual = 0

local locations = {}

local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
local spawned = false
Citizen.CreateThread(function()
    Citizen.Wait(10000)

    while true do
        Citizen.Wait(1000)
        if GetDistanceBetweenCoords(Config.PickupBlip.x, Config.PickupBlip.y, Config.PickupBlip.z,
            GetEntityCoords(GetPlayerPed(-1))) <= 200 then
            if spawned == false then
                for i = 0, 10 do
                    TriggerEvent('EWine:start')
                end
            end
            spawned = true
        else
            if spawned then
                locations = {}
            end
            spawned = false

        end
    end
end)

local displayed = false
local menuOpen = false

local process = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        playerCoords = GetEntityCoords(GetPlayerPed(-1))
        -- pick up spot

        -- Renders source ingrediants such as Grapes. 
        -- This will also facilitate players picking up the grape
        renderAndGiveIngredients()
        -- Put Grape spot
        prompt = "~w~Grape Grinder~y~\nPress [~b~E~y~] to put your grapes in.\n~w~" .. grapeLoad .. " ounces";
        ingredLoader(Config.grapeStorage, "grape", grapeLoad, prompt)

        -- Put Water spot
        prompt = "~w~Water Storage~y~\nPress [~b~E~y~] to add your water.\n~w~" .. waterLoad .. " gallons";
        ingredLoader(Config.waterStorage, "water", waterLoad, prompt)

        -- Show Switch to Start/Stop
        checkForStartSwitchAttempt()

        -- transformerLocation
        prompt = "~w~Transformer~y~\nPress [~b~E~y~] to fix the transformer"
        checkBoxFix(Config.transformerLocation, "transformer", Transformer, prompt)
        -- breakerLocation
        prompt = "~w~Breaker~y~\nPress [~b~E~y~] to fix the breaker"
        checkBoxFix(Config.breakerLocation, "breaker", Breaker, prompt)
        -- filterLocation
        prompt = "~w~Filter~y~\nPress [~b~E~y~] to fix the air filter"
        checkBoxFix(Config.filterLocation, "air", Air, prompt)
        -- liquidLocation
        prompt = "~w~Water~y~\nPress [~b~E~y~] to patch hole"
        checkBoxFix(Config.liquidLocation, "liquid", Liquid, prompt)
        -- hopperLocation
        prompt = "~w~Hopper~y~\nPress [~b~E~y~] to fix the hopper"
        checkBoxFix(Config.hopperLocation, "hopper", Hopper, prompt)

        -- AcidLocation
        prompt = "~w~Acid~y~\nPress [~b~E~y~] to make your wine more acidic\n~w~" ..
                     tonumber(string.format("%.2f", acidLevel)) .. " ph"
        checkForVariableBoxFix(Config.acidLocation, "acid", acidLevel, prompt, Config.lowAcidLevel, Config.highAcidLevel)
        -- temperatureLocation
        prompt = "~w~Temperature~y~\nPress [~b~E~y~] to lower the temperature.\n~w~" .. temperature .. " F"
        checkForVariableBoxFix(Config.temperatureLocation, "temperature", temperature, prompt, Config.lowTemperature,
            Config.highTemperature)

        -- EndProduct
        if GetDistanceBetweenCoords(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
            GetEntityCoords(GetPlayerPed(-1))) < 150 then
            DrawMarker(1, Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                Draw3DText(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
                    "~w~End Product~y~\nPress [~b~E~y~] to pick up your product.\n~w~" .. highqual .. " Fine Wine" ..
                        "\n~w~" .. lowqual .. " Basic Wine", 4, 0.15, 0.1)
                if IsControlJustReleased(0, Keys['E']) then
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "take")

                    end)
                end
            end

        end

    end
end)

function checkForStartSwitchAttempt()
    if GetDistanceBetweenCoords(Config.Switch.x, Config.Switch.y, Config.Switch.z, GetEntityCoords(GetPlayerPed(-1))) <
        150 then
        DrawMarker(1, Config.Switch.x, Config.Switch.y, Config.Switch.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0,
            200, 0, 110, 0, 1, 0, 0)
        if GetDistanceBetweenCoords(Config.Switch.x, Config.Switch.y, Config.Switch.z,
            GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
            -- Notify You hear the machines begin to buzz
            -- Add logic to show different stuff based on isOn
            if isOn then
                Draw3DText(Config.Switch.x, Config.Switch.y, Config.Switch.z,
                    "~w~On/Off Switch~y~\nPress [~b~E~y~] to Turn the Machine off.", 4, 0.15, 0.1)
            else
                Draw3DText(Config.Switch.x, Config.Switch.y, Config.Switch.z,
                    "~w~On/Off Switch~y~\nPress [~b~E~y~] to Turn the Machine on.", 4, 0.15, 0.1)
            end
            if IsControlJustReleased(0, Keys['E']) then
                -- Change this for all of them
                Citizen.CreateThread(function()
                    -- Notify you hear the machines start to whirr and buzz
                    if isOn then
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "power")

                    else
                        if grapeLoad >= Config.startAmount and waterLoad >= Config.startAmount then
                            ESX.TriggerServerCallback('EWine:fix', function(output)
                                grindResult = output
                            end, "power")
                        else
                            ESX.ShowNotification("The machine is empty! Add more ingrediants")
                            ESX.ShowNotification("The machine is empty! Add more ingrediants")
                        end
                    end

                end)
            end
        end

    end
end

function checkForVariableBoxFix(fixLocation, name, currValue, prompt, low, high)
    if GetDistanceBetweenCoords(fixLocation.x, fixLocation.y, fixLocation.z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
        if currValue < low or currValue > high then
            DrawMarker(1, fixLocation.x, fixLocation.y, fixLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 200,
                0, 0, 110, 0, 1, 0, 0)
        else
            DrawMarker(1, fixLocation.x, fixLocation.y, fixLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0,
                200, 0, 110, 0, 1, 0, 0)
        end
        if GetDistanceBetweenCoords(fixLocation.x, fixLocation.y, fixLocation.z, GetEntityCoords(GetPlayerPed(-1)), true) <
            1.5 then
            Draw3DText(fixLocation.x, fixLocation.y, fixLocation.z, prompt, 4, 0.15, 0.1)
            if IsControlJustReleased(0, Keys['E']) then
                -- Change this for all of them
                Citizen.CreateThread(function()
                    ESX.TriggerServerCallback('EWine:fix', function(output)
                        grindResult = output
                    end, name)

                    Citizen.Wait(500)
                end)
            end
        end

    end
end

function ingredLoader(loadLocation, item, numAvail, prompt)
    if GetDistanceBetweenCoords(loadLocation.x, loadLocation.y, loadLocation.z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
        DrawMarker(1, loadLocation.x, loadLocation.y, loadLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0,
            200, 0, 110, 0, 1, 0, 0)
        if GetDistanceBetweenCoords(loadLocation.x, loadLocation.y, loadLocation.z, GetEntityCoords(GetPlayerPed(-1)),
            true) < 1.5 then
            Draw3DText(loadLocation.x, loadLocation.y, loadLocation.z, prompt, 4, 0.15, 0.1)
            -- Change this for all of them
            if IsControlJustReleased(0, Keys['E']) then
                Citizen.CreateThread(function()

                    ESX.TriggerServerCallback('EWine:fix', function(output)
                        grindResult = output
                    end, item)
                end)
            end
        end
    end
end

function renderAndGiveIngredients()
    for k in pairs(locations) do
        if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z, GetEntityCoords(GetPlayerPed(-1))) <
            150 then
            DrawMarker(3, locations[k].x, locations[k].y, locations[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
                0, 200, 0, 200, 0, 1, 0, 0)

            if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z,
                GetEntityCoords(GetPlayerPed(-1)), false) < 2 then
                if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    TriggerServerEvent('EWine:get')
                    TriggerEvent('EWine:new', k)
                end
            end

        end
    end
end

function checkBoxFix(Box, name, currValue, prompt)
    if GetDistanceBetweenCoords(Box.x, Box.y, Box.z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
        if currValue then
            DrawMarker(1, Box.x, Box.y, Box.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
        else
            DrawMarker(1, Box.x, Box.y, Box.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 200, 0, 0, 110, 0, 1, 0, 0)
        end
        tryPlayerFix(Box, name, prompt)

    end
end

function tryPlayerFix(Box, name, prompt)
    if GetDistanceBetweenCoords(Box.x, Box.y, Box.z, GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
        Draw3DText(Box.x, Box.y, Box.z, prompt, 4, 0.15, 0.1)
        if IsControlJustReleased(0, Keys['E']) then
            -- Change this for all of them
            Citizen.CreateThread(function()
                local grindResult

                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
                local CustomSettings = {
                    settings = {
                        handleEnd = false, -- Send a result message if true and callback when message closed or callback immediately without showing the message
                        speed = 7, -- pixels / second
                        scoreWin = 150, -- Score to win
                        scoreLose = -150, -- Lose if this score is reached
                        maxTime = 60000, -- sec
                        maxMistake = 5, -- How many missed keys can there be before losing
                        speedIncrement = 1 -- How much should the speed increase when a key hit was successful
                    },
                    keys = {"a", "w", "d", "s", "g"} -- You can hash this out if you want to use default keys in the java side.
                }
                local win = exports['Erryial_Keymaster']:StartKeyMaster(CustomSettings)
                ClearPedTasksImmediately(PlayerPedId())
                if win == true then
                    ESX.TriggerServerCallback('EWine:fix', function(output)
                        grindResult = output
                    end, name)
                end
            end)
        end
    end
end

-- Teleport function
function FastTravel(coords, heading)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Citizen.Wait(500)
    end
    ESX.Game.Teleport(playerPed, coords, function()
        DoScreenFadeIn(800)
        if heading then
            SetEntityHeading(playerPed, heading)
        end
    end)
end

function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    if inDist then
        SetTextColour(0, 190, 0, 220) -- You can change the text color here
    else
        SetTextColour(220, 0, 0, 220) -- You can change the text color here
    end
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z + 2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('EWine:start')
AddEventHandler('EWine:start', function()
    local set = false
    Citizen.Wait(10)

    local rnX = Config.PickupBlip.x + math.random(-35, 35)
    local rnY = Config.PickupBlip.y + math.random(-35, 35)

    local u, Z = GetGroundZFor_3dCoord(rnX, rnY, 300.0, 0)

    table.insert(locations, {
        x = rnX,
        y = rnY,
        z = Z + 0.3
    });

end)

RegisterNetEvent('EWine:new')
AddEventHandler('EWine:new', function(id)
    local set = false
    Citizen.Wait(10)

    local rnX = Config.PickupBlip.x + math.random(-35, 35)
    local rnY = Config.PickupBlip.y + math.random(-35, 35)

    local u, Z = GetGroundZFor_3dCoord(rnX, rnY, 300.0, 0)

    locations[id].x = rnX
    locations[id].y = rnY
    locations[id].z = Z + 0.3

end)

RegisterNetEvent('EWine:message')
AddEventHandler('EWine:message', function(message)
    ESX.ShowNotification(message)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('EWine:updateData')
AddEventHandler('EWine:updateData', function(item, value)
    if item == "transformer" then
        Transformer = value
    elseif item == "breaker" then
        Breaker = value
    elseif item == "air" then
        Air = value
    elseif item == "hopper" then
        Hopper = value
    elseif item == "liquid" then
        Liquid = value
    elseif item == "temperature" then
        temperature = value
    elseif item == "lowqual" then
        lowqual = value
    elseif item == "highqual" then
        highqual = value
    elseif item == "acid" then
        acidLevel = value
    elseif item == "grape" then
        grapeLoad = value
    elseif item == "water" then
        waterLoad = value
    elseif item == "power" then
        isOn = value
    end
end)
Citizen.CreateThread(function()
    TriggerServerEvent('syncUp')
    local blip = AddBlipForCoord(853.76, -1967.00, 100)
    SetBlipSprite(blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.0)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Brewery')
    EndTextCommandSetBlipName(blip)

    local pickupblip = AddBlipForCoord(Config.PickupBlip.x, Config.PickupBlip.y, Config.PickupBlip.z)
    SetBlipSprite(pickupblip, 238)
    SetBlipColour(pickupblip, 31)
    SetBlipDisplay(pickupblip, 4)
    SetBlipScale(pickupblip, 1.0)
    SetBlipScale(pickupblip, 1.0)
    SetBlipAsShortRange(pickupblip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Grape Vineyard')
    EndTextCommandSetBlipName(pickupblip)
    local sellblip = AddBlipForCoord(Config.sell.x, Config.sell.y, Config.sell.z)
    SetBlipSprite(sellblip, 478)
    SetBlipColour(sellblip, 31)
    SetBlipDisplay(sellblip, 4)
    SetBlipScale(sellblip, 1.0)
    SetBlipScale(sellblip, 1.0)
    SetBlipAsShortRange(sellblip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Wine Buyer')
    EndTextCommandSetBlipName(sellblip)
end)

local isSelling = false;
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.sell.x, Config.sell.y, Config.sell.z, true) <=
            10 then
            DrawMarker(20, Config.sell.x, Config.sell.y, Config.sell.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102,
                100, 102, 100, false, true, 2, false, false, false, false)

            if GetDistanceBetweenCoords(coords, Config.sell.x, Config.sell.y, Config.sell.z, true) < 1.0 then

                DisplayHelpText("Press ~INPUT_PICKUP~ to sell.")

                if IsControlJustReleased(1, 51) then
                    ESX.TriggerServerCallback('EWine:sell', function(output)
                        if output == true then
                            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                            isSelling = true
                            Citizen.CreateThread(function()
                                ESX.Streaming.RequestAnimDict("mp_common", function()
                                    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8.0, -1, 0, 0.0, false, false, false)
                                end)
                                Citizen.Wait(3000)
                                ClearPedTasksImmediately(PlayerPedId())
                                isSelling = false
                            end)
                        else
                            ESX.ShowNotification("You don't have any wine to sell.")
                        end
                    end)

                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if isSelling then
            DisableControlAction(0, 51, true) -- E 
        end
    end
end)
