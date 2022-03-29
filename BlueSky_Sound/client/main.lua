
RegisterNetEvent('BlueSky_Sound_CL:PlayWithinDistance')
AddEventHandler('BlueSky_Sound_CL:PlayWithinDistance', function(soundOrigin, maxDistance, soundFile, soundVolume)
	if hasPlayerLoaded then
		local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(soundOrigin.x, soundOrigin.y, soundOrigin.z, playerCoords)
        
        --Gives us a number between 0 and 1.0
        local distancePorportion = 0.1 - (distance/maxDistance)*0.1


		if distance < maxDistance then
			SendNUIMessage({
				transactionType = 'playSound',
				transactionFile  = soundFile,
				transactionVolume = distancePorportion
			})
		end
	end
end)

