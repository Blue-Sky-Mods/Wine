
------
-- Interaction Sounds by Scott
-- Version: v0.0.1
-- Path: server/main.lua
--
-- Allows sounds to be played on single clients, all clients, or all clients within
-- a specific range from the entity to which the sound has been created. Triggers
-- client events only. Used to trigger sounds on other clients from the client or
-- server without having to pass directly to another client.
------

------
-- RegisterServerEvent Erryial_Sound_SV:PlayOnOne
-- Triggers -> ClientEvent Erryial_Sound_CL:PlayOnOne
--
-- @param clientNetId  - The network id of the client that the sound should be played on.
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client.
------
RegisterNetEvent('Erryial_Sound_SV:PlayOnOne')
AddEventHandler('Erryial_Sound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('Erryial_Sound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

------
-- RegisterServerEvent Erryial_Sound_SV:PlayOnSource
-- Triggers -> ClientEvent Erryial_Sound_CL:PlayOnSource
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client, which is the source of the event.
------
RegisterNetEvent('Erryial_Sound_SV:PlayOnSource')
AddEventHandler('Erryial_Sound_SV:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('Erryial_Sound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

------
-- RegisterServerEvent Erryial_Sound_SV:PlayOnAll
-- Triggers -> ClientEvent Erryial_Sound_CL:PlayOnAll
--
-- @param soundFile     - The name of the soundfile within the client/html/sounds/ folder.
--                      - Can also specify a folder/sound file.
-- @param soundVolume   - The volume at which the soundFile should be played. Nil or don't
--                      - provide it for the default of standardVolumeOutput. Should be between
--                      - 0.1 to 1.0.
--
-- Starts playing a sound on all clients who are online in the server.
------
RegisterNetEvent('Erryial_Sound_SV:PlayOnAll')
AddEventHandler('Erryial_Sound_SV:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('Erryial_Sound_CL:PlayOnAll', -1, soundFile, soundVolume)
end)

------
-- RegisterServerEvent Erryial_Sound_SV:PlayWithinDistance
-- Triggers -> ClientEvent Erryial_Sound_CL:PlayWithinDistance
--
-- @param playOnEntity    - The entity network id (will be converted from net id to entity on client)
--                        - of the entity for which the max distance is to be drawn from.
-- @param maxDistance     - The maximum float distance (client uses Vdist) to allow the player to
--                        - hear the soundFile being played.
-- @param soundFile       - The name of the soundfile within the client/html/sounds/ folder.
--                        - Can also specify a folder/sound file.
-- @param soundVolume     - The volume at which the soundFile should be played. Nil or don't
--                        - provide it for the default of standardVolumeOutput. Should be between
--                        - 0.1 to 1.0.
--
-- Starts playing a sound on a client if the client is within the specificed maxDistance from the playOnEntity.
-- @TODO Change sound volume based on the distance the player is away from the playOnEntity.
------
RegisterNetEvent('Erryial_Sound_SV:PlayWithinDistance')
AddEventHandler('Erryial_Sound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
  if GetConvar("onesync_enableInfinity", "false") == "true" then
    TriggerClientEvent('Erryial_Sound_CL:PlayWithinDistanceOS', -1, GetEntityCoords(GetPlayerPed(source)), maxDistance, soundFile, soundVolume)
  else
    TriggerClientEvent('Erryial_Sound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
  end
end)


RegisterNetEvent('Erryial_Sound_SV:PlayWithinDistance')
AddEventHandler('Erryial_Sound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local src = source
    local DistanceLimit = 300
    if maxDistance < DistanceLimit then
	TriggerClientEvent('Erryial_Sound_CL:PlayWithinDistance', -1, GetEntityCoords(GetPlayerPed(src)), maxDistance, soundFile, soundVolume)
    else
        print(('[interact-sound] [^3WARNING^7] %s attempted to trigger Erryial_Sound_SV:PlayWithinDistance over the distance limit ' .. DistanceLimit):format(GetPlayerName(src)))
    end
end)


RegisterNetEvent('Erryial_Sound_SV:PlayWithinDistanceOfCoords')
AddEventHandler('Erryial_Sound_SV:PlayWithinDistanceOfCoords', function(maxDistance, soundFile, soundVolume, coords)
    TriggerClientEvent('Erryial_Sound_CL:PlayWithinDistance', -1, coords, maxDistance, soundFile, soundVolume)
end)
