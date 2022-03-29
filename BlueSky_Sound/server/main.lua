RegisterNetEvent('BlueSky_Sound_SV:PlayWithinDistance')
AddEventHandler('BlueSky_Sound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
  if GetConvar("onesync_enableInfinity", "false") == "true" then
    TriggerClientEvent('BlueSky_Sound_CL:PlayWithinDistanceOS', -1, GetEntityCoords(GetPlayerPed(source)), maxDistance, soundFile, soundVolume)
  else
    TriggerClientEvent('BlueSky_Sound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
  end
end)


RegisterNetEvent('BlueSky_Sound_SV:PlayWithinDistance')
AddEventHandler('BlueSky_Sound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local src = source
    local DistanceLimit = 300
    if maxDistance < DistanceLimit then
	TriggerClientEvent('BlueSky_Sound_CL:PlayWithinDistance', -1, GetEntityCoords(GetPlayerPed(src)), maxDistance, soundFile, soundVolume)
    else
        print(('[interact-sound] [^3WARNING^7] %s attempted to trigger BlueSky_Sound_SV:PlayWithinDistance over the distance limit ' .. DistanceLimit):format(GetPlayerName(src)))
    end
end)


RegisterNetEvent('BlueSky_Sound_SV:PlayWithinDistanceOfCoords')
AddEventHandler('BlueSky_Sound_SV:PlayWithinDistanceOfCoords', function(maxDistance, soundFile, soundVolume, coords)
    TriggerClientEvent('BlueSky_Sound_CL:PlayWithinDistance', -1, coords, maxDistance, soundFile, soundVolume)
end)
