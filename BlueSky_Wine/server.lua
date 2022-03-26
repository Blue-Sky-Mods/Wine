Transformer = false;
Air = false;
Breaker = false;
Hopper = false;
Liquid = false;
Temperature = 70;
Acid = 5.0;
IsOn = false;
Water = 0;
Grape = 0;
mistakes = 0;
lowqual = 0
highqual = 0

-- DEV
RegisterCommand('initWine', function(playerId, args, rawCommand)
    Water = 30;
    Grape = 30;
    IsOn = true
    TriggerClientEvent("EWine:updateData", -1, "grape", Grape)
    TriggerClientEvent("EWine:updateData", -1, "water", Water)
    TriggerClientEvent("EWine:updateData", -1, "power", IsOn)
end, false)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent("EWine:get")
AddEventHandler("EWine:get", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount = math.random(1, 2)
    if xPlayer.canCarryItem("grape", amount) then
        xPlayer.addInventoryItem('grape', amount)
    else
        TriggerClientEvent('esx:showNotification', source, '~r~You cant hold any more grapes')
    end
end)

ESX.RegisterServerCallback("EWine:fix", function(source, cb, fixItem)
    if fixItem == "transformer" then
        Transformer = true;
        TriggerClientEvent("EWine:updateData", -1, fixItem, true)
    elseif fixItem == "take" then
        if highqual > 0 then
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            if xPlayer.canCarryItem("highqualwine", 1) then
                xPlayer.addInventoryItem('highqualwine', 1)
                highqual = highqual - 1

                TriggerClientEvent("EWine:updateData", -1, "highqual", highqual)
            else
                TriggerClientEvent('esx:showNotification', source, "~r~You can't hold anymore of this wine.")
            end
        elseif lowqual > 0 then
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            if xPlayer.canCarryItem("lowqualwine", 1) then
                xPlayer.addInventoryItem('lowqualwine', 1)
                lowqual = lowqual - 1
                TriggerClientEvent("EWine:updateData", -1, "lowqual", lowqual)
            else
                TriggerClientEvent('esx:showNotification', source, "~r~You can't hold anymore of this wine.")
            end
        else
            TriggerClientEvent('esx:showNotification', source, "~r~There is no wine for you to take.")
        end
    elseif fixItem == "breaker" then
        Breaker = true;
        TriggerClientEvent("EWine:updateData", -1, fixItem, true)
    elseif fixItem == "air" then
        Air = true;
        TriggerClientEvent("EWine:updateData", -1, fixItem, true)
    elseif fixItem == "hopper" then
        Hopper = true;
        TriggerClientEvent("EWine:updateData", -1, fixItem, true)
    elseif fixItem == "liquid" then
        Liquid = true;
        TriggerClientEvent("EWine:updateData", -1, fixItem, true)
    elseif fixItem == "power" then
        IsOn = not IsOn
        if IsOn == true then
            Grape = Grape - Config.startAmount
            Water = Water - Config.startAmount
            TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 50.0, 'startup', 0.1, Config.Switch)
        end
        TriggerClientEvent("EWine:updateData", -1, fixItem, IsOn)
        TriggerClientEvent("EWine:updateData", -1, "grape", Grape)
        TriggerClientEvent("EWine:updateData", -1, "water", Water)
    elseif fixItem == "water" then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.getInventoryItem('water').count >= Config.ingredLoadAmount then
            xPlayer.removeInventoryItem('water', Config.ingredLoadAmount)
            Water = Water + Config.ingredLoadAmount
        elseif xPlayer.getInventoryItem('water').count >= 1 then
            local playerWaterCount = xPlayer.getInventoryItem('water').count
            xPlayer.removeInventoryItem('water', playerWaterCount)
            Water = Water + playerWaterCount
        else
            TriggerClientEvent('esx:showNotification', source, "~r~You don't have anymore water.")
        end
        TriggerClientEvent("EWine:updateData", -1, fixItem, Water)
    elseif fixItem == "grape" then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.getInventoryItem('grape').count >= Config.ingredLoadAmount then
            xPlayer.removeInventoryItem('grape', Config.ingredLoadAmount)
            Grape = Grape + Config.ingredLoadAmount
        elseif xPlayer.getInventoryItem('grape').count >= 1 then
            local playerGrapeCount = xPlayer.getInventoryItem('grape').count
            xPlayer.removeInventoryItem('grape', playerGrapeCount)
            Grape = Grape + playerGrapeCount
        else
            TriggerClientEvent('esx:showNotification', source, "~r~You don't have anymore grapes.")
        end
        TriggerClientEvent("EWine:updateData", -1, fixItem, Grape)
        cb(true)
    elseif fixItem == "temperature" then
        if Temperature > 10 then
            Temperature = Temperature - 10;
        end
        TriggerClientEvent("EWine:updateData", -1, fixItem, Temperature)
    elseif fixItem == "acid" then
        if Acid > 0.5 then
            Acid = Acid - 0.5;
        end
        TriggerClientEvent("EWine:updateData", -1, fixItem, Acid)
    end
    cb(true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
        if IsOn then
            if Temperature > Config.highTemperature then
                mistakes = mistakes + 1
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 30.0, 'overheat', 0.1,
                    Config.temperatureLocation)
            end
            if Temperature < Config.lowTemperature then
                mistakes = mistakes + 1
            end
            if Acid > Config.highAcidLevel then
                mistakes = mistakes + 1
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 30.0, 'acid', 0.1, Config.acidLocation)
            end
            if Acid < Config.lowAcidLevel then
                mistakes = mistakes + 1
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.mistakeCheckInterval)
        if IsOn then
            if not Hopper or not Air or not Transformer or not Breaker or not Liquid then
                mistakes = mistakes + 1
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.breakRate)
        if IsOn then
            itemBreak = math.random(1, 5)
            if itemBreak == 1 then
                Transformer = false;
                TriggerClientEvent("EWine:updateData", -1, "transformer", false)
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 45.0, 'boom', 0.1,
                    Config.transformerLocation)
            elseif itemBreak == 2 then
                Air = false;
                TriggerClientEvent("EWine:updateData", -1, "air", false)
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 35.0, 'metal', 0.1, Config.filterLocation)
            elseif itemBreak == 3 then
                Breaker = false;
                TriggerClientEvent("EWine:updateData", -1, "breaker", false)
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 35.0, 'shock', 0.1, Config.breakerLocation)
            elseif itemBreak == 4 then
                Liquid = false;
                TriggerClientEvent("EWine:updateData", -1, "liquid", false)
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 35.0, 'water', 0.1, Config.liquidLocation)
            elseif itemBreak == 5 then
                Hopper = false;
                TriggerClientEvent("EWine:updateData", -1, "hopper", false)
                TriggerEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords', 35.0, 'thud', 0.1, Config.hopperLocation)
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsOn then
            Citizen.Wait(Config.variableRiseRate)
            if Temperature <= 212 then
                Temperature = Temperature + 1;
                TriggerClientEvent("EWine:updateData", -1, "temperature", Temperature)
            end
            if Acid < 14.0 then
                Acid = Acid + 0.05;
                TriggerClientEvent("EWine:updateData", -1, "acid", Acid)
            end
        end

    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsOn then
            Citizen.Wait(60000)
            if mistakes < 5 then
                highqual = highqual + 1
                TriggerClientEvent("EWine:updateData", -1, "highqual", highqual)
            else
                lowqual = lowqual + 1
                TriggerClientEvent("EWine:updateData", -1, "lowqual", lowqual)
            end
            mistakes = 0
            if Water - Config.startAmount >= 0 and Grape - Config.startAmount >= 0 then
                Water = Water - Config.startAmount
                Grape = Grape - Config.startAmount
                TriggerClientEvent("EWine:updateData", -1, "grape", Grape)
                TriggerClientEvent("EWine:updateData", -1, "water", Water)
            else
                IsOn = false
                TriggerClientEvent("EWine:updateData", -1, "power", false)
            end

        end
    end
end)

ESX.RegisterServerCallback('EWine:sell', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('highqualwine').count >= 1 then
        xPlayer.removeInventoryItem('highqualwine', 1)
        xPlayer.addMoney(Config.fineWinePrice)
        cb(true)
    elseif xPlayer.getInventoryItem('lowqualwine').count >= 1 then
        xPlayer.removeInventoryItem('lowqualwine', 1)
        xPlayer.addMoney(Config.basicWinePrice)
        cb(true)
    else
        cb(false)
    end

end)

RegisterServerEvent("syncUp")
AddEventHandler('syncUp', function()
    TriggerClientEvent("EWine:updateData", -1, "grape", Grape)
    TriggerClientEvent("EWine:updateData", -1, "water", Water)
    TriggerClientEvent("EWine:updateData", -1, "power", IsOn)
    TriggerClientEvent("EWine:updateData", -1, "highqual", highqual)
    TriggerClientEvent("EWine:updateData", -1, "lowqual", lowqual)
    TriggerClientEvent("EWine:updateData", -1, "transformer", Transformer)
    TriggerClientEvent("EWine:updateData", -1, "hopper", Hopper)
    TriggerClientEvent("EWine:updateData", -1, "air", Air)
    TriggerClientEvent("EWine:updateData", -1, "breaker", Breaker)
    TriggerClientEvent("EWine:updateData", -1, "liquid", Liquid)
    TriggerClientEvent("EWine:updateData", -1, "temperature", Temperature)
    TriggerClientEvent("EWine:updateData", -1, "acid", Acid)
end)
